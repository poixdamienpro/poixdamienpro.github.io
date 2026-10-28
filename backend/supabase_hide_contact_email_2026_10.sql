-- ============================================================
-- BUY-INNER — Ne plus exposer les e-mails de contact des entreprises dans l'API publique
-- (script à exécuter UNE fois, idempotent)
--
-- Constat (audit du 28/10/2026) : get_companies_page et get_company_by_id renvoient toutes les colonnes de la vue
-- v_companies_summary, dont contact_email. 225 adresses étaient donc lisibles par n'importe qui interrogeant l'API,
-- alors qu'aucune page publique ne les affiche. Certaines sont nominatives (données personnelles) et les personnes
-- n'ont pas été informées de cette collecte.
--
-- Correctif : les deux fonctions renvoient désormais contact_email à NULL. Le type de retour ne change pas (même
-- vue, mêmes colonnes dans le même ordre), donc le site continue de fonctionner sans autre modification. Si une
-- colonne est ajoutée plus tard à la vue, elle est reprise automatiquement.
--
-- Ce qui continue de lire l'adresse, par un chemin protégé :
--   • le tableau de bord fournisseur : lecture de sa propre ligne companies avec son jeton (RLS), pas ces fonctions ;
--   • l'admin : lecture directe de companies avec le rôle admin ;
--   • le Worker et les fonctions serveur : clé de service.
-- ============================================================

CREATE OR REPLACE FUNCTION public.get_companies_page(p_limit int DEFAULT 20, p_offset int DEFAULT 0)
RETURNS SETOF public.v_companies_summary
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT (jsonb_populate_record(null::public.v_companies_summary,
                                to_jsonb(v) || jsonb_build_object('contact_email', null))).*
  FROM public.v_companies_summary v
  WHERE NOT v.hidden
  ORDER BY v.premium DESC, v.name ASC
  LIMIT least(greatest(p_limit, 1), 50)
  OFFSET greatest(p_offset, 0);
$$;

CREATE OR REPLACE FUNCTION public.get_company_by_id(p_id uuid)
RETURNS SETOF public.v_companies_summary
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT (jsonb_populate_record(null::public.v_companies_summary,
                                to_jsonb(v) || jsonb_build_object('contact_email', null))).*
  FROM public.v_companies_summary v
  WHERE v.id = p_id
  LIMIT 1;
$$;

-- Les droits existants restent valables (CREATE OR REPLACE ne les retire pas) ; on les réaffirme par prudence.
GRANT EXECUTE ON FUNCTION public.get_companies_page(int, int) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.get_company_by_id(uuid)      TO anon, authenticated;

-- ── Contrôles ────────────────────────────────────────────────────────────
-- 1) Doit renvoyer 0 : plus aucune adresse dans la réponse publique.
--    SELECT count(*) FROM public.get_companies_page(50, 0) WHERE contact_email IS NOT NULL;
-- 2) Doit renvoyer le nombre d'entreprises visibles (le site fonctionne comme avant).
--    SELECT count(*) FROM public.get_companies_page(50, 0);
-- 3) Les adresses restent bien en base (lecture admin / clé de service) :
--    SELECT count(*) FROM public.companies WHERE contact_email IS NOT NULL;
