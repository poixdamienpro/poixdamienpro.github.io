-- ============================================================
-- Comptes multiples par entreprise (équipe) — 2026-10
--
-- Avant : une entreprise n'avait qu'UN compte propriétaire
-- (companies.claimed_by_user_id). Maintenant :
--   * table company_members : plusieurs comptes par entreprise,
--     rôle 'owner' (administrateur : gère l'équipe) ou 'member'
--     (collaborateur : mêmes droits sur produits, leads, RFQ, stats,
--     mais ne gère pas l'équipe) ;
--   * invitations par email (company_invites) créées par un owner ;
--   * limite de comptes selon le plan : 1 en gratuit, 20 en Premium.
--
-- Ce fichier réécrit AUSSI, à partir de leur définition actuelle en base,
-- toutes les règles d'accès (policies RLS, fonctions) qui testaient
-- « claimed_by_user_id = auth.uid() » : elles testent désormais
-- is_company_member(...). Rien n'est recopié à la main, donc les
-- corrections apportées depuis aux fichiers rfq_* sont conservées.
--
-- Prérequis : supabase_supplier_accounts.sql et is_admin() déjà en place.
-- Sûr à relancer. Le tout est une seule transaction : si une vérification
-- finale échoue, RIEN n'est modifié.
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- 1. Membres d'une entreprise
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.company_members (
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  user_id    uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role       text NOT NULL DEFAULT 'member' CHECK (role IN ('owner', 'member')),
  invited_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (company_id, user_id)
);
CREATE INDEX IF NOT EXISTS company_members_user_idx ON public.company_members (user_id);
ALTER TABLE public.company_members ENABLE ROW LEVEL SECURITY;

-- Les propriétaires actuels deviennent 'owner' de leur entreprise.
INSERT INTO public.company_members (company_id, user_id, role)
SELECT id, claimed_by_user_id, 'owner'
FROM public.companies
WHERE claimed_by_user_id IS NOT NULL
ON CONFLICT (company_id, user_id) DO NOTHING;

-- ------------------------------------------------------------
-- 2. Fonctions d'appartenance (SECURITY DEFINER : pas de récursion RLS)
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.is_company_member(p_company uuid)
RETURNS boolean
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.company_members
    WHERE company_id = p_company AND user_id = auth.uid()
  );
$$;

CREATE OR REPLACE FUNCTION public.is_company_owner(p_company uuid)
RETURNS boolean
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.company_members
    WHERE company_id = p_company AND user_id = auth.uid() AND role = 'owner'
  );
$$;

GRANT EXECUTE ON FUNCTION public.is_company_member(uuid) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.is_company_owner(uuid) TO anon, authenticated;

-- Ce projet révoque les droits par défaut sur les nouvelles tables
-- (supabase_lock_base_tables.sql) : il faut un GRANT explicite. Le vrai
-- contrôle d'accès reste les policies RLS ci-dessous.
GRANT SELECT, INSERT, UPDATE, DELETE ON public.company_members TO authenticated;

-- Un membre voit l'équipe de son entreprise ; l'admin plateforme voit tout.
-- Aucune écriture directe pour les utilisateurs : tout passe par les RPC
-- ci-dessous (sauf l'admin plateforme, qui rattache un compte à la main).
DROP POLICY IF EXISTS "members_read_team" ON public.company_members;
CREATE POLICY "members_read_team" ON public.company_members
  FOR SELECT TO authenticated
  USING (public.is_company_member(company_id) OR public.is_admin());

DROP POLICY IF EXISTS "admin_manage_members" ON public.company_members;
CREATE POLICY "admin_manage_members" ON public.company_members
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- Quand l'admin approuve une revendication (companies.claimed_by_user_id),
-- le compte devient automatiquement 'owner'.
CREATE OR REPLACE FUNCTION public._sync_company_owner()
RETURNS trigger
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  IF NEW.claimed_by_user_id IS NOT NULL
     AND (TG_OP = 'INSERT' OR NEW.claimed_by_user_id IS DISTINCT FROM OLD.claimed_by_user_id) THEN
    INSERT INTO public.company_members (company_id, user_id, role)
    VALUES (NEW.id, NEW.claimed_by_user_id, 'owner')
    ON CONFLICT (company_id, user_id) DO UPDATE SET role = 'owner';
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS companies_sync_owner ON public.companies;
CREATE TRIGGER companies_sync_owner
  AFTER INSERT OR UPDATE OF claimed_by_user_id ON public.companies
  FOR EACH ROW EXECUTE FUNCTION public._sync_company_owner();

-- ------------------------------------------------------------
-- 3. Invitations
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.company_invites (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id  uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  email       text NOT NULL,
  role        text NOT NULL DEFAULT 'member' CHECK (role IN ('owner', 'member')),
  token       text NOT NULL UNIQUE
              DEFAULT replace(gen_random_uuid()::text || gen_random_uuid()::text, '-', ''),
  invited_by  uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at  timestamptz NOT NULL DEFAULT now(),
  expires_at  timestamptz NOT NULL DEFAULT now() + interval '7 days',
  accepted_at timestamptz,
  revoked_at  timestamptz
);
CREATE INDEX IF NOT EXISTS company_invites_company_idx ON public.company_invites (company_id);
ALTER TABLE public.company_invites ENABLE ROW LEVEL SECURITY;
-- Pas de policy pour les utilisateurs : le jeton ne doit jamais être lisible
-- côté client, tout passe par les RPC. L'admin plateforme peut tout voir.
DROP POLICY IF EXISTS "admin_manage_invites" ON public.company_invites;
CREATE POLICY "admin_manage_invites" ON public.company_invites
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- Nombre de comptes autorisés : 1 en gratuit, 20 en Premium.
CREATE OR REPLACE FUNCTION public._company_seat_limit(p_company uuid)
RETURNS int
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT CASE WHEN COALESCE((SELECT premium FROM public.companies WHERE id = p_company), false)
              THEN 20 ELSE 1 END;
$$;

-- Comptes utilisés = membres + invitations en attente.
CREATE OR REPLACE FUNCTION public._company_seats_used(p_company uuid)
RETURNS int
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT (SELECT count(*) FROM public.company_members WHERE company_id = p_company)::int
       + (SELECT count(*) FROM public.company_invites
          WHERE company_id = p_company AND accepted_at IS NULL AND revoked_at IS NULL
            AND expires_at > now())::int;
$$;

-- ------------------------------------------------------------
-- 4. RPC (appelées par le tableau de bord fournisseur)
--    Erreurs : message = code stable, traduit côté site.
-- ------------------------------------------------------------

-- Équipe + capacité (le libellé « 1/1 » du tableau de bord)
CREATE OR REPLACE FUNCTION public.list_company_members(p_company uuid)
RETURNS TABLE (user_id uuid, email text, role text, created_at timestamptz, is_me boolean)
LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path = public AS $$
BEGIN
  IF auth.uid() IS NULL THEN RAISE EXCEPTION 'AUTH_REQUIRED'; END IF;
  IF NOT (public.is_company_member(p_company) OR public.is_admin()) THEN
    RAISE EXCEPTION 'NOT_MEMBER';
  END IF;
  RETURN QUERY
    SELECT m.user_id, u.email::text, m.role, m.created_at, (m.user_id = auth.uid())
    FROM public.company_members m
    JOIN auth.users u ON u.id = m.user_id
    WHERE m.company_id = p_company
    ORDER BY (m.role = 'owner') DESC, m.created_at;
END;
$$;

CREATE OR REPLACE FUNCTION public.list_company_invites(p_company uuid)
RETURNS TABLE (id uuid, email text, role text, created_at timestamptz, expires_at timestamptz)
LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path = public AS $$
BEGIN
  IF auth.uid() IS NULL THEN RAISE EXCEPTION 'AUTH_REQUIRED'; END IF;
  IF NOT (public.is_company_owner(p_company) OR public.is_admin()) THEN
    RAISE EXCEPTION 'NOT_OWNER';
  END IF;
  RETURN QUERY
    SELECT i.id, i.email, i.role, i.created_at, i.expires_at
    FROM public.company_invites i
    WHERE i.company_id = p_company AND i.accepted_at IS NULL AND i.revoked_at IS NULL
      AND i.expires_at > now()
    ORDER BY i.created_at DESC;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_company_seats(p_company uuid)
RETURNS jsonb
LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path = public AS $$
BEGIN
  IF auth.uid() IS NULL THEN RAISE EXCEPTION 'AUTH_REQUIRED'; END IF;
  IF NOT (public.is_company_member(p_company) OR public.is_admin()) THEN
    RAISE EXCEPTION 'NOT_MEMBER';
  END IF;
  RETURN jsonb_build_object(
    'used', public._company_seats_used(p_company),
    'limit', public._company_seat_limit(p_company),
    'is_owner', public.is_company_owner(p_company)
  );
END;
$$;

-- Crée l'invitation. L'email est envoyé ensuite par le Worker
-- (/api/send-invite-email), qui relit l'invitation avec le jeton de
-- l'inviteur : le client ne peut donc pas choisir un destinataire libre.
CREATE OR REPLACE FUNCTION public.invite_company_member(p_company uuid, p_email text, p_role text DEFAULT 'member')
RETURNS jsonb
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_email text := lower(trim(COALESCE(p_email, '')));
  v_id uuid;
BEGIN
  IF auth.uid() IS NULL THEN RAISE EXCEPTION 'AUTH_REQUIRED'; END IF;
  IF NOT (public.is_company_owner(p_company) OR public.is_admin()) THEN
    RAISE EXCEPTION 'NOT_OWNER';
  END IF;
  IF v_email !~ '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$' THEN RAISE EXCEPTION 'INVALID_EMAIL'; END IF;
  IF p_role NOT IN ('owner', 'member') THEN RAISE EXCEPTION 'INVALID_ROLE'; END IF;

  IF EXISTS (
    SELECT 1 FROM public.company_members m JOIN auth.users u ON u.id = m.user_id
    WHERE m.company_id = p_company AND lower(u.email) = v_email
  ) THEN RAISE EXCEPTION 'ALREADY_MEMBER'; END IF;

  -- Garde-fou anti-spam : 20 invitations par entreprise et par jour.
  IF (SELECT count(*) FROM public.company_invites
      WHERE company_id = p_company AND created_at > now() - interval '1 day') >= 20 THEN
    RAISE EXCEPTION 'RATE_LIMIT';
  END IF;

  -- Une nouvelle invitation pour la même adresse remplace l'ancienne.
  UPDATE public.company_invites SET revoked_at = now()
  WHERE company_id = p_company AND lower(email) = v_email
    AND accepted_at IS NULL AND revoked_at IS NULL;

  IF public._company_seats_used(p_company) >= public._company_seat_limit(p_company) THEN
    RAISE EXCEPTION 'SEAT_LIMIT';
  END IF;

  INSERT INTO public.company_invites (company_id, email, role, invited_by)
  VALUES (p_company, v_email, p_role, auth.uid())
  RETURNING id INTO v_id;

  RETURN jsonb_build_object('invite_id', v_id);
END;
$$;

-- Données de l'email d'invitation (appelée par le Worker avec le jeton de l'inviteur).
CREATE OR REPLACE FUNCTION public.get_invite_email_payload(p_invite uuid)
RETURNS jsonb
LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path = public AS $$
DECLARE
  i public.company_invites%ROWTYPE;
BEGIN
  IF auth.uid() IS NULL THEN RAISE EXCEPTION 'AUTH_REQUIRED'; END IF;
  SELECT * INTO i FROM public.company_invites WHERE id = p_invite;
  IF NOT FOUND THEN RAISE EXCEPTION 'INVITE_INVALID'; END IF;
  IF NOT (public.is_company_owner(i.company_id) OR public.is_admin()) THEN
    RAISE EXCEPTION 'NOT_OWNER';
  END IF;
  IF i.accepted_at IS NOT NULL OR i.revoked_at IS NOT NULL OR i.expires_at <= now() THEN
    RAISE EXCEPTION 'INVITE_INVALID';
  END IF;
  RETURN jsonb_build_object(
    'email', i.email,
    'token', i.token,
    'role', i.role,
    'expires_at', i.expires_at,
    'company_name', (SELECT name FROM public.companies WHERE id = i.company_id),
    'inviter_email', (SELECT email FROM auth.users WHERE id = auth.uid())
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.revoke_company_invite(p_invite uuid)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_company uuid;
BEGIN
  IF auth.uid() IS NULL THEN RAISE EXCEPTION 'AUTH_REQUIRED'; END IF;
  SELECT company_id INTO v_company FROM public.company_invites WHERE id = p_invite;
  IF v_company IS NULL THEN RAISE EXCEPTION 'INVITE_INVALID'; END IF;
  IF NOT (public.is_company_owner(v_company) OR public.is_admin()) THEN
    RAISE EXCEPTION 'NOT_OWNER';
  END IF;
  UPDATE public.company_invites SET revoked_at = now()
  WHERE id = p_invite AND accepted_at IS NULL AND revoked_at IS NULL;
END;
$$;

-- Acceptation : le compte connecté doit avoir l'adresse invitée.
CREATE OR REPLACE FUNCTION public.accept_company_invite(p_token text)
RETURNS jsonb
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  i public.company_invites%ROWTYPE;
  v_mail text;
BEGIN
  IF auth.uid() IS NULL THEN RAISE EXCEPTION 'AUTH_REQUIRED'; END IF;
  SELECT * INTO i FROM public.company_invites WHERE token = p_token FOR UPDATE;
  IF NOT FOUND OR i.revoked_at IS NOT NULL THEN RAISE EXCEPTION 'INVITE_INVALID'; END IF;
  IF i.accepted_at IS NOT NULL THEN RAISE EXCEPTION 'INVITE_USED'; END IF;
  IF i.expires_at <= now() THEN RAISE EXCEPTION 'INVITE_EXPIRED'; END IF;

  SELECT lower(email) INTO v_mail FROM auth.users WHERE id = auth.uid();
  IF v_mail IS DISTINCT FROM lower(i.email) THEN RAISE EXCEPTION 'EMAIL_MISMATCH'; END IF;

  -- L'invitation réservait une place ; si le Premium a pris fin entre-temps,
  -- on ne dépasse pas la limite du plan.
  IF (SELECT count(*) FROM public.company_members WHERE company_id = i.company_id)
       >= public._company_seat_limit(i.company_id)
     AND NOT EXISTS (SELECT 1 FROM public.company_members
                     WHERE company_id = i.company_id AND user_id = auth.uid()) THEN
    RAISE EXCEPTION 'SEAT_LIMIT';
  END IF;

  INSERT INTO public.company_members (company_id, user_id, role, invited_by)
  VALUES (i.company_id, auth.uid(), i.role, i.invited_by)
  ON CONFLICT (company_id, user_id) DO UPDATE
    SET role = CASE WHEN EXCLUDED.role = 'owner' THEN 'owner' ELSE public.company_members.role END;

  UPDATE public.company_invites SET accepted_at = now() WHERE id = i.id;

  RETURN jsonb_build_object(
    'company_id', i.company_id,
    'company_name', (SELECT name FROM public.companies WHERE id = i.company_id),
    'role', i.role
  );
END;
$$;

-- Retirer un membre (un owner retire n'importe qui ; chacun peut se retirer
-- lui-même). On ne peut jamais retirer le dernier administrateur.
CREATE OR REPLACE FUNCTION public.remove_company_member(p_company uuid, p_user uuid)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_role text;
BEGIN
  IF auth.uid() IS NULL THEN RAISE EXCEPTION 'AUTH_REQUIRED'; END IF;
  IF NOT (public.is_company_owner(p_company) OR public.is_admin() OR p_user = auth.uid()) THEN
    RAISE EXCEPTION 'NOT_OWNER';
  END IF;
  SELECT role INTO v_role FROM public.company_members WHERE company_id = p_company AND user_id = p_user;
  IF v_role IS NULL THEN RAISE EXCEPTION 'NOT_MEMBER'; END IF;
  IF v_role = 'owner'
     AND (SELECT count(*) FROM public.company_members WHERE company_id = p_company AND role = 'owner') <= 1 THEN
    RAISE EXCEPTION 'LAST_OWNER';
  END IF;
  DELETE FROM public.company_members WHERE company_id = p_company AND user_id = p_user;
END;
$$;

CREATE OR REPLACE FUNCTION public.set_company_member_role(p_company uuid, p_user uuid, p_role text)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_role text;
BEGIN
  IF auth.uid() IS NULL THEN RAISE EXCEPTION 'AUTH_REQUIRED'; END IF;
  IF NOT (public.is_company_owner(p_company) OR public.is_admin()) THEN RAISE EXCEPTION 'NOT_OWNER'; END IF;
  IF p_role NOT IN ('owner', 'member') THEN RAISE EXCEPTION 'INVALID_ROLE'; END IF;
  SELECT role INTO v_role FROM public.company_members WHERE company_id = p_company AND user_id = p_user;
  IF v_role IS NULL THEN RAISE EXCEPTION 'NOT_MEMBER'; END IF;
  IF v_role = 'owner' AND p_role = 'member'
     AND (SELECT count(*) FROM public.company_members WHERE company_id = p_company AND role = 'owner') <= 1 THEN
    RAISE EXCEPTION 'LAST_OWNER';
  END IF;
  UPDATE public.company_members SET role = p_role WHERE company_id = p_company AND user_id = p_user;
END;
$$;

REVOKE ALL ON FUNCTION public.list_company_members(uuid), public.list_company_invites(uuid),
  public.get_company_seats(uuid), public.invite_company_member(uuid, text, text),
  public.get_invite_email_payload(uuid), public.revoke_company_invite(uuid),
  public.accept_company_invite(text), public.remove_company_member(uuid, uuid),
  public.set_company_member_role(uuid, uuid, text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.list_company_members(uuid), public.list_company_invites(uuid),
  public.get_company_seats(uuid), public.invite_company_member(uuid, text, text),
  public.get_invite_email_payload(uuid), public.revoke_company_invite(uuid),
  public.accept_company_invite(text), public.remove_company_member(uuid, uuid),
  public.set_company_member_role(uuid, uuid, text) TO authenticated;

-- ------------------------------------------------------------
-- 5. Réécriture des règles d'accès existantes
--    « claimed_by_user_id = auth.uid() »  ->  « is_company_member(<id>) »
--    appliquée à la définition ACTUELLE des policies (public + storage)
--    et des fonctions du schéma public.
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION pg_temp.bi_rewrite(t text)
RETURNS text LANGUAGE plpgsql AS $$
DECLARE
  uid_re constant text := '(auth\.uid\(\)|\(\s*SELECT\s+auth\.uid\(\)\s+AS\s+uid\s*\))';
BEGIN
  IF t IS NULL THEN RETURN NULL; END IF;
  -- avec alias / nom de table : c.claimed_by_user_id = auth.uid()
  t := regexp_replace(t, '(\w+)\.claimed_by_user_id\s*=\s*' || uid_re, 'public.is_company_member(\1.id)', 'gi');
  -- sans alias (sous-requête sur companies seule)
  t := regexp_replace(t, 'claimed_by_user_id\s*=\s*' || uid_re, 'public.is_company_member(id)', 'gi');
  RETURN t;
END;
$$;

DO $$
DECLARE
  r record;
  q text;
  wc text;
  def text;
  n_pol int := 0;
  n_fn int := 0;
BEGIN
  FOR r IN
    SELECT schemaname, tablename, policyname, qual, with_check
    FROM pg_policies
    WHERE schemaname IN ('public', 'storage')
      AND (COALESCE(qual, '') ~* 'claimed_by_user_id' OR COALESCE(with_check, '') ~* 'claimed_by_user_id')
  LOOP
    q  := pg_temp.bi_rewrite(r.qual);
    wc := pg_temp.bi_rewrite(r.with_check);
    EXECUTE format('ALTER POLICY %I ON %I.%I%s%s',
      r.policyname, r.schemaname, r.tablename,
      CASE WHEN q  IS NOT NULL THEN ' USING (' || q || ')' ELSE '' END,
      CASE WHEN wc IS NOT NULL THEN ' WITH CHECK (' || wc || ')' ELSE '' END);
    n_pol := n_pol + 1;
    RAISE NOTICE 'policy réécrite : %.% / %', r.schemaname, r.tablename, r.policyname;
  END LOOP;

  FOR r IN
    SELECT p.oid, p.proname
    FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.prosrc ~* 'claimed_by_user_id'
      AND p.proname NOT IN ('_sync_company_owner')
      AND p.prokind = 'f'
  LOOP
    def := pg_temp.bi_rewrite(pg_get_functiondef(r.oid));
    EXECUTE def;
    n_fn := n_fn + 1;
    RAISE NOTICE 'fonction réécrite : public.%', r.proname;
  END LOOP;

  RAISE NOTICE 'Réécriture terminée : % policies, % fonctions.', n_pol, n_fn;
END $$;

-- ------------------------------------------------------------
-- 6. Vérification finale : plus aucune règle ne doit dépendre du
--    propriétaire unique. Sinon, ROLLBACK automatique (exception).
-- ------------------------------------------------------------
DO $$
DECLARE
  n_pol int;
  n_fn int;
BEGIN
  SELECT count(*) INTO n_pol FROM pg_policies
  WHERE schemaname IN ('public', 'storage')
    AND (COALESCE(qual, '') ~* 'claimed_by_user_id' OR COALESCE(with_check, '') ~* 'claimed_by_user_id');

  SELECT count(*) INTO n_fn
  FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
  WHERE n.nspname = 'public' AND p.prokind = 'f'
    AND p.prosrc ~* 'claimed_by_user_id' AND p.proname NOT IN ('_sync_company_owner');

  IF n_pol > 0 OR n_fn > 0 THEN
    RAISE EXCEPTION 'Réécriture incomplète : % policies et % fonctions testent encore claimed_by_user_id. Rien n''a été modifié.', n_pol, n_fn;
  END IF;
END $$;

COMMIT;

-- Contrôles (à lire après exécution) :
--   1. Membres créés à partir des propriétaires actuels :
--        SELECT role, count(*) FROM public.company_members GROUP BY role;
--   2. Plus aucune règle sur claimed_by_user_id (doit renvoyer 0 ligne) :
--        SELECT policyname FROM pg_policies WHERE schemaname IN ('public','storage')
--          AND (qual ~* 'claimed_by_user_id' OR with_check ~* 'claimed_by_user_id');
