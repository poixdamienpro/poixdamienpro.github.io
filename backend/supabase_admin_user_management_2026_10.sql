-- ============================================================
-- Gestion des comptes depuis l'admin — 2026-10
--
-- 1. admin_audit_log : journal des actions sensibles faites depuis la page
--    admin (création / suppression / désactivation de compte, lien de
--    nouveau mot de passe). Écrit par le Worker (clé service_role) ; seuls
--    les admins peuvent le lire.
--
-- 2. admin_prepare_user_deletion(uid) : prépare la suppression d'un compte.
--    Plusieurs tables pointent vers auth.users SANS suppression en cascade
--    (revendications, soumissions, dossiers RFQ...) : supprimer le compte
--    échouerait. Cette fonction, atomique, refuse si le compte a des données
--    RFQ (on le désactive plutôt) ou s'il est admin, et sinon détache le
--    compte de l'entreprise, de ses revendications et soumissions.
--    Appelée uniquement par le Worker (service_role).
--
-- Sûr à relancer.
-- ============================================================

CREATE TABLE IF NOT EXISTS public.admin_audit_log (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at   timestamptz NOT NULL DEFAULT now(),
  admin_email  text NOT NULL,
  action       text NOT NULL,
  target_email text,
  details      jsonb
);
CREATE INDEX IF NOT EXISTS admin_audit_log_created_idx ON public.admin_audit_log (created_at DESC);
ALTER TABLE public.admin_audit_log ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "admin_read_audit_log" ON public.admin_audit_log;
CREATE POLICY "admin_read_audit_log" ON public.admin_audit_log
  FOR SELECT TO authenticated USING (public.is_admin());

-- Ce projet révoque les droits par défaut sur les nouvelles tables
-- (supabase_lock_base_tables.sql) : GRANT explicite, le contrôle reste la RLS.
GRANT SELECT ON public.admin_audit_log TO authenticated;

CREATE OR REPLACE FUNCTION public.admin_prepare_user_deletion(p_user uuid)
RETURNS void
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  IF EXISTS (SELECT 1 FROM public.admins WHERE user_id = p_user) THEN
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
  -- company_members, buyer_profiles : supprimés en cascade avec le compte ;
  -- leads.buyer_user_id passe à NULL tout seul (ON DELETE SET NULL).
END;
$$;

REVOKE ALL ON FUNCTION public.admin_prepare_user_deletion(uuid) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.admin_prepare_user_deletion(uuid) TO service_role;

-- Contrôles (doivent renvoyer chacun 1 ligne) :
SELECT 'journal' AS objet FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'admin_audit_log'
UNION ALL
SELECT 'fonction' FROM pg_proc WHERE proname = 'admin_prepare_user_deletion';
