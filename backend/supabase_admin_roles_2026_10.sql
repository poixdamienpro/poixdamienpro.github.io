-- ============================================================
-- Rôles d'administrateur : super-admin / admin — 2026-10
--
--   * super-admin : tout ce que fait un admin + créer des admins, donner ou
--     retirer le statut super-admin, retirer les droits admin et supprimer
--     / désactiver / réinitialiser les autres admins ;
--   * admin : gère les comptes non-admin et leur rattachement aux entreprises,
--     mais ne touche PAS aux autres admins.
--
-- IMPORTANT : jusqu'ici, la règle de la table `admins` laissait n'importe quel
-- admin y lire / ajouter / modifier / supprimer des lignes directement depuis son
-- navigateur. Elle est remplacée : lecture pour tous les admins, ÉCRITURE
-- réservée aux super-admins (le Worker, lui, écrit avec la clé service_role).
--
-- Garde-fou : il reste toujours au moins un super-admin (impossible de retirer
-- le statut ou de supprimer le dernier, même depuis l'éditeur SQL).
--
-- Au premier passage, poixdamien.pro@gmail.com devient super-admin ; à défaut
-- d'admin portant cette adresse, le plus ancien admin le devient (pour ne
-- jamais rester sans super-admin). Les contrôles en fin de fichier listent qui
-- l'est : corrige-le si besoin avec
--   UPDATE public.admins SET is_super = true WHERE lower(email) = lower('ton@email');
--
-- Une seule transaction. Sûr à relancer. Prérequis : table admins (user_id, email) + is_admin().
-- ============================================================

BEGIN;

ALTER TABLE public.admins ADD COLUMN IF NOT EXISTS is_super boolean NOT NULL DEFAULT false;

-- Premier super-admin (une seule fois : seulement s'il n'y en a pas encore).
UPDATE public.admins SET is_super = true
WHERE NOT EXISTS (SELECT 1 FROM public.admins WHERE is_super)
  AND lower(email) = 'poixdamien.pro@gmail.com';

UPDATE public.admins SET is_super = true
WHERE NOT EXISTS (SELECT 1 FROM public.admins WHERE is_super)
  AND user_id = (SELECT a.user_id FROM public.admins a JOIN auth.users u ON u.id = a.user_id
                 ORDER BY u.created_at, a.user_id LIMIT 1);

-- ------------------------------------------------------------
-- is_super_admin() : SECURITY DEFINER (la règle de la table admins l'appelle)
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.is_super_admin()
RETURNS boolean
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (SELECT 1 FROM public.admins WHERE user_id = auth.uid() AND is_super);
$$;
REVOKE ALL ON FUNCTION public.is_super_admin() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.is_super_admin() TO authenticated;

-- ------------------------------------------------------------
-- Règles de la table admins : on repart de zéro (noms variables selon
-- les anciens scripts), puis lecture admin / écriture super-admin.
-- ------------------------------------------------------------
DO $$
DECLARE r record;
BEGIN
  FOR r IN SELECT policyname FROM pg_policies WHERE schemaname = 'public' AND tablename = 'admins' LOOP
    EXECUTE format('DROP POLICY %I ON public.admins', r.policyname);
  END LOOP;
END $$;

CREATE POLICY "admins_read" ON public.admins
  FOR SELECT TO authenticated USING (public.is_admin());

CREATE POLICY "admins_write_super_only" ON public.admins
  FOR ALL TO authenticated
  USING (public.is_super_admin()) WITH CHECK (public.is_super_admin());

-- ------------------------------------------------------------
-- Il reste toujours au moins un super-admin
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION public._keep_one_super_admin()
RETURNS trigger
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  IF OLD.is_super AND (TG_OP = 'DELETE' OR NEW.is_super IS NOT TRUE) THEN
    IF NOT EXISTS (SELECT 1 FROM public.admins WHERE is_super AND user_id <> OLD.user_id) THEN
      RAISE EXCEPTION 'LAST_SUPER';
    END IF;
  END IF;
  RETURN CASE WHEN TG_OP = 'DELETE' THEN OLD ELSE NEW END;
END;
$$;
REVOKE ALL ON FUNCTION public._keep_one_super_admin() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS admins_keep_one_super ON public.admins;
CREATE TRIGGER admins_keep_one_super
  BEFORE UPDATE OR DELETE ON public.admins
  FOR EACH ROW EXECUTE FUNCTION public._keep_one_super_admin();

-- ------------------------------------------------------------
-- Suppression d'un compte : un admin peut maintenant être supprimé (par un
-- super-admin, vérifié par le Worker). On remplace la fonction de nettoyage :
-- nouveau paramètre p_allow_admin (faux par défaut = comportement précédent).
-- ------------------------------------------------------------
DROP FUNCTION IF EXISTS public.admin_prepare_user_deletion(uuid);

CREATE OR REPLACE FUNCTION public.admin_prepare_user_deletion(p_user uuid, p_allow_admin boolean DEFAULT false)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  IF NOT p_allow_admin AND EXISTS (SELECT 1 FROM public.admins WHERE user_id = p_user) THEN
    RAISE EXCEPTION 'IS_ADMIN';
  END IF;

  IF EXISTS (SELECT 1 FROM public.rfq_dossiers WHERE submitter_user_id = p_user)
     OR EXISTS (SELECT 1 FROM public.rfq_responses WHERE submitter_user_id = p_user)
     OR EXISTS (SELECT 1 FROM public.rfq_nda_acceptances WHERE user_id = p_user)
     OR EXISTS (SELECT 1 FROM public.rfq_custom_nda_signatures WHERE submitter_user_id = p_user) THEN
    RAISE EXCEPTION 'HAS_RFQ_DATA';
  END IF;

  UPDATE public.companies SET claimed_by_user_id = NULL WHERE claimed_by_user_id = p_user;
  DELETE FROM public.company_claims WHERE user_id = p_user;
  UPDATE public.product_submissions SET submitter_user_id = NULL WHERE submitter_user_id = p_user;
  -- admins, company_members, buyer_profiles : supprimés en cascade avec le compte.
END;
$$;
REVOKE ALL ON FUNCTION public.admin_prepare_user_deletion(uuid, boolean) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.admin_prepare_user_deletion(uuid, boolean) TO service_role;

COMMIT;

-- Contrôles (à lire après exécution) :
--   1. Qui est super-admin (au moins 1 ligne avec is_super = true) :
--        SELECT email, is_super FROM public.admins ORDER BY is_super DESC, email;
--   2. Les règles de la table admins (2 lignes : admins_read, admins_write_super_only) :
--        SELECT policyname, cmd FROM pg_policies WHERE tablename = 'admins';
