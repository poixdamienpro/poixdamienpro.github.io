-- ============================================================
-- Correctif : droits de lecture sur company_members — 2026-10
--
-- Ce projet a révoqué les droits par défaut sur les nouvelles tables
-- (ALTER DEFAULT PRIVILEGES ... REVOKE SELECT, voir
-- supabase_lock_base_tables.sql). Sans GRANT explicite, les comptes
-- connectés ne peuvent pas lire company_members, et l'espace fournisseur
-- ne retrouve plus leur entreprise.
--
-- Les règles RLS de la migration restent le vrai contrôle d'accès :
--   * un membre ne voit que l'équipe de SON entreprise ;
--   * seul l'admin plateforme peut écrire directement dans la table
--     (tout le reste passe par les RPC, qui sont SECURITY DEFINER).
-- company_invites reste volontairement SANS droit (le jeton ne doit
-- jamais être lisible côté client).
--
-- Sûr à relancer.
-- ============================================================

GRANT SELECT, INSERT, UPDATE, DELETE ON public.company_members TO authenticated;

-- Contrôle (doit renvoyer 4 lignes : SELECT, INSERT, UPDATE, DELETE) :
SELECT privilege_type
FROM information_schema.role_table_grants
WHERE table_schema = 'public' AND table_name = 'company_members' AND grantee = 'authenticated'
ORDER BY privilege_type;
