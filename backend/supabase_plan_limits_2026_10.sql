-- ============================================================
-- Limites du plan gratuit — 2026-10
--
-- 1. Produits : une entreprise NON Premium ne peut pas avoir plus de 2
--    produits (publiés + demandes d'ajout en attente). Premium : illimité.
--    S'applique à l'espace fournisseur ET au formulaire public d'inscription
--    (là, l'entreprise est reconnue par son nom + l'email du dépôt ; une
--    entreprise déjà Premium n'est pas limitée). Un dépôt qui dépasse est
--    refusé EN ENTIER.
--    Les entreprises qui ont déjà plus de 2 produits les gardent (on ne
--    retire rien) ; elles ne peuvent simplement plus en ajouter.
--    Appliqué par un trigger sur product_submissions (message : PRODUCT_LIMIT).
--
-- 2. RFQ / RFI / RFP : réservés aux fournisseurs Premium, y compris pour
--    CONSULTER et RÉPONDRE (jusqu'ici seul le dépôt exigeait Premium) :
--      * get_rfq_dossiers_page / get_rfq_dossier_detail refusent
--        (exception 'premium_required') ;
--      * accepter l'accord de confidentialité, répondre à un dossier et
--        signer un NDA spécifique exigent d'être membre d'une entreprise Premium.
--    Les fonctions et règles RFQ sont réécrites à partir de leur définition
--    ACTUELLE en base (les corrections faites depuis aux fichiers rfq_* sont
--    conservées).
--
-- 3. Hygiène : trois fonctions internes de la migration « équipes » étaient
--    exécutables par tout compte connecté (ce projet accorde EXECUTE
--    automatiquement aux nouvelles fonctions) ; on retire ce droit.
--
-- Une seule transaction : si une vérification finale échoue, RIEN n'est modifié.
-- Prérequis : supabase_company_members_2026_10.sql. Sûr à relancer.
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- 0. Membre d'une entreprise Premium ?
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.is_premium_member()
RETURNS boolean
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.company_members m
    JOIN public.companies c ON c.id = m.company_id
    WHERE m.user_id = auth.uid() AND c.premium = true
  );
$$;
REVOKE ALL ON FUNCTION public.is_premium_member() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.is_premium_member() TO authenticated;

-- ------------------------------------------------------------
-- 1. Limite de produits du plan gratuit
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION public._free_product_limit()
RETURNS int LANGUAGE sql IMMUTABLE AS $$ SELECT 2 $$;

CREATE OR REPLACE FUNCTION public._enforce_free_product_limit()
RETURNS trigger
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  used int;
BEGIN
  -- Seules les demandes d'AJOUT de produit sont limitées.
  IF NEW.submission_type IS DISTINCT FROM 'new' THEN
    RETURN NEW;
  END IF;

  IF NEW.company_id IS NOT NULL THEN
    -- Espace fournisseur : l'entreprise est connue.
    IF COALESCE((SELECT premium FROM public.companies WHERE id = NEW.company_id), false) THEN
      RETURN NEW;
    END IF;
    used := (SELECT count(*) FROM public.products WHERE company_id = NEW.company_id)
          + (SELECT count(*) FROM public.product_submissions
             WHERE company_id = NEW.company_id AND submission_type = 'new' AND status = 'pending');
  ELSE
    -- Formulaire public d'inscription : pas encore de company_id. On reconnaît l'entreprise
    -- par son nom (insensible à la casse) : déjà Premium => pas de limite ; sinon on compte
    -- ses produits publiés et les produits en attente déposés avec la même adresse email.
    -- (Fonction VOLATILE : dans un dépôt de plusieurs lignes, chaque ligne voit les précédentes.)
    IF NEW.company_name IS NULL THEN RETURN NEW; END IF;
    IF EXISTS (SELECT 1 FROM public.companies WHERE lower(name) = lower(NEW.company_name) AND premium = true) THEN
      RETURN NEW;
    END IF;
    used := (SELECT count(*) FROM public.products p JOIN public.companies c ON c.id = p.company_id
             WHERE lower(c.name) = lower(NEW.company_name))
          + (SELECT count(*) FROM public.product_submissions
             WHERE company_id IS NULL AND submission_type = 'new' AND status = 'pending'
               AND lower(company_name) = lower(NEW.company_name)
               AND lower(submitter_email) = lower(NEW.submitter_email));
  END IF;

  IF used >= public._free_product_limit() THEN
    RAISE EXCEPTION 'PRODUCT_LIMIT';
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS product_submissions_free_limit ON public.product_submissions;
CREATE TRIGGER product_submissions_free_limit
  BEFORE INSERT ON public.product_submissions
  FOR EACH ROW EXECUTE FUNCTION public._enforce_free_product_limit();

-- ------------------------------------------------------------
-- 2. RFQ réservés aux fournisseurs Premium
-- ------------------------------------------------------------
DO $$
DECLARE
  r record;
  def text;
  new_check text;
  n_fn int := 0;
  n_pol int := 0;
BEGIN
  -- 2a. Les deux RPC de consultation : refus avant même le contrôle du NDA.
  FOR r IN
    SELECT p.oid, p.proname
    FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public' AND p.proname IN ('get_rfq_dossiers_page', 'get_rfq_dossier_detail')
  LOOP
    def := pg_get_functiondef(r.oid);
    IF def ~ 'premium_required' THEN CONTINUE; END IF;
    def := regexp_replace(def, '\mBEGIN\M',
      E'BEGIN\n  IF NOT (public.is_premium_member() OR public.is_admin()) THEN\n    RAISE EXCEPTION ''premium_required'';\n  END IF;', 'i');
    IF def !~ 'premium_required' THEN RAISE EXCEPTION 'Structure inattendue de %', r.proname; END IF;
    EXECUTE def;
    n_fn := n_fn + 1;
    RAISE NOTICE 'fonction protégée : public.%', r.proname;
  END LOOP;

  -- 2b. Les règles d'écriture : accepter le NDA, répondre, signer un NDA spécifique.
  FOR r IN
    SELECT schemaname, tablename, policyname, with_check
    FROM pg_policies
    WHERE schemaname = 'public'
      AND policyname IN ('user_can_accept_nda', 'supplier_can_respond_to_published_rfq', 'supplier_can_submit_custom_nda_signature')
  LOOP
    IF r.with_check IS NULL THEN RAISE EXCEPTION 'Policy % sans WITH CHECK : structure inattendue', r.policyname; END IF;
    IF r.with_check ~ 'is_premium_member' THEN CONTINUE; END IF;
    new_check := '(' || r.with_check || ') AND public.is_premium_member()';
    EXECUTE format('ALTER POLICY %I ON %I.%I WITH CHECK (%s)', r.policyname, r.schemaname, r.tablename, new_check);
    n_pol := n_pol + 1;
    RAISE NOTICE 'policy protégée : %.% / %', r.schemaname, r.tablename, r.policyname;
  END LOOP;

  RAISE NOTICE 'RFQ réservés au Premium : % fonctions, % policies mises à jour.', n_fn, n_pol;
END $$;

-- ------------------------------------------------------------
-- 3. Hygiène : fonctions internes non appelables par les utilisateurs
-- ------------------------------------------------------------
REVOKE ALL ON FUNCTION public._company_seat_limit(uuid), public._company_seats_used(uuid),
  public._sync_company_owner(), public._enforce_free_product_limit(), public._free_product_limit()
  FROM PUBLIC, anon, authenticated;

-- ------------------------------------------------------------
-- 4. Vérification finale (sinon ROLLBACK)
-- ------------------------------------------------------------
DO $$
DECLARE
  missing text;
BEGIN
  SELECT string_agg(x, ', ') INTO missing FROM (
    SELECT p.proname AS x FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public' AND p.proname IN ('get_rfq_dossiers_page', 'get_rfq_dossier_detail')
      AND p.prosrc !~ 'premium_required'
    UNION ALL
    SELECT policyname FROM pg_policies
    WHERE schemaname = 'public'
      AND policyname IN ('user_can_accept_nda', 'supplier_can_respond_to_published_rfq', 'supplier_can_submit_custom_nda_signature')
      AND COALESCE(with_check, '') !~ 'is_premium_member'
  ) q;
  IF missing IS NOT NULL THEN
    RAISE EXCEPTION 'Protection RFQ incomplète pour : %. Rien n''a été modifié.', missing;
  END IF;
  IF (SELECT count(*) FROM pg_policies WHERE schemaname = 'public'
        AND policyname IN ('user_can_accept_nda', 'supplier_can_respond_to_published_rfq', 'supplier_can_submit_custom_nda_signature')) < 3 THEN
    RAISE EXCEPTION 'Une des règles RFQ attendues est introuvable. Rien n''a été modifié.';
  END IF;
END $$;

COMMIT;

-- Contrôles (à lire après exécution) :
--   1. Limite en place (1 ligne) :
--        SELECT tgname FROM pg_trigger WHERE tgname = 'product_submissions_free_limit';
--   2. RFQ protégés (3 lignes) :
--        SELECT policyname FROM pg_policies WHERE with_check ~ 'is_premium_member';
