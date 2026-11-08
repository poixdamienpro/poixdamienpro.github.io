-- ============================================================
-- BUY-INNER — Catalogue réservé aux comptes inscrits (script idempotent, à exécuter UNE fois)
--
-- Jusqu'ici le verrou « compte gratuit » était seulement visuel (voir js/buyer.js) : les RPC du catalogue restaient
-- appelables par n'importe qui avec la clé publique (anon), page par page, et on pouvait récupérer tous les noms de
-- fabricants et de produits sans se connecter. Ce script ferme réellement l'accès :
--
--   1. les fonctions qui renvoient les entreprises et les produits ne sont plus appelables que par un compte connecté
--      (rôle authenticated : acheteur, fournisseur, admin) et par la clé de service (Worker) ;
--   2. les tables annexes du catalogue (catégories, tags, secteurs, implantations, caractéristiques) ne sont plus
--      lisibles sans compte ;
--   3. deux fonctions publiques ne renvoient que des totaux et des libellés génériques : get_public_stats()
--      (chiffres de la page d'accueil) et get_public_taxonomy() (listes de secteurs et de catégories du formulaire
--      de référencement, qui doit rester accessible aux fournisseurs non inscrits).
--
-- ORDRE DE DÉPLOIEMENT (important) : d'abord pousser le site et redéployer le Worker, puis exécuter ce script. Avant,
-- l'ancien site appelle les fonctions sans compte et affichera une erreur de chargement.
-- Retour arrière : voir le bloc en bas de fichier.
-- ============================================================

-- ── 1. Fonctions du catalogue : comptes connectés uniquement ──────────────────────────────────────────────
DO $$
DECLARE sig text;
BEGIN
  FOREACH sig IN ARRAY ARRAY[
    'public.get_companies_page(int, int)',
    'public.get_products_page(int, int)',
    'public.get_company_by_id(uuid)',
    'public.get_product_by_id(uuid)',
    'public.get_products_by_company(uuid)'
  ] LOOP
    IF to_regprocedure(sig) IS NOT NULL THEN
      EXECUTE format('REVOKE EXECUTE ON FUNCTION %s FROM PUBLIC, anon', sig);
      EXECUTE format('GRANT EXECUTE ON FUNCTION %s TO authenticated, service_role', sig);
    ELSE
      RAISE NOTICE 'Fonction absente, ignorée : %', sig;
    END IF;
  END LOOP;
END $$;

-- ── 2. Tables annexes du catalogue : plus de lecture sans compte ─────────────────────────────────────────
DO $$
DECLARE t text;
BEGIN
  FOREACH t IN ARRAY ARRAY['company_tags', 'company_product_categories', 'company_industries', 'company_locations', 'product_characteristics', 'product_tags']
  LOOP
    IF to_regclass('public.' || t) IS NOT NULL THEN
      EXECUTE format('REVOKE SELECT ON public.%I FROM anon', t);
    ELSE
      RAISE NOTICE 'Table absente, ignorée : %', t;
    END IF;
  END LOOP;
END $$;

-- ── 3. Fonctions publiques : seulement des totaux et des libellés génériques ─────────────────────────────
CREATE OR REPLACE FUNCTION public.get_public_stats()
RETURNS TABLE (n_companies int, n_products int, n_categories int, n_industries int)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  n_companies := (SELECT count(*) FROM public.companies c WHERE NOT c.hidden);
  n_products  := (SELECT count(*) FROM public.products p JOIN public.companies c ON c.id = p.company_id WHERE NOT c.hidden);
  n_categories := 0;
  IF to_regclass('public.company_product_categories') IS NOT NULL THEN
    n_categories := (SELECT count(DISTINCT x.category) FROM public.company_product_categories x JOIN public.companies c ON c.id = x.company_id WHERE NOT c.hidden);
  END IF;
  IF to_regclass('public.company_industries') IS NOT NULL THEN
    n_industries := (SELECT count(DISTINCT s.i) FROM (
      SELECT c.industry AS i FROM public.companies c WHERE NOT c.hidden AND c.industry IS NOT NULL
      UNION
      SELECT ci.industry FROM public.company_industries ci JOIN public.companies c ON c.id = ci.company_id WHERE NOT c.hidden
    ) s);
  ELSE
    n_industries := (SELECT count(DISTINCT c.industry) FROM public.companies c WHERE NOT c.hidden AND c.industry IS NOT NULL);
  END IF;
  RETURN NEXT;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_public_taxonomy()
RETURNS TABLE (kind text, label text)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN QUERY SELECT 'industry'::text, c.industry FROM public.companies c WHERE NOT c.hidden AND c.industry IS NOT NULL GROUP BY c.industry;
  IF to_regclass('public.company_industries') IS NOT NULL THEN
    RETURN QUERY SELECT 'industry'::text, ci.industry FROM public.company_industries ci JOIN public.companies c ON c.id = ci.company_id
      WHERE NOT c.hidden AND ci.industry IS NOT NULL AND ci.industry NOT IN (SELECT c2.industry FROM public.companies c2 WHERE c2.industry IS NOT NULL)
      GROUP BY ci.industry;
  END IF;
  IF to_regclass('public.company_product_categories') IS NOT NULL THEN
    RETURN QUERY SELECT 'category'::text, x.category FROM public.company_product_categories x JOIN public.companies c ON c.id = x.company_id
      WHERE NOT c.hidden AND x.category IS NOT NULL GROUP BY x.category;
  END IF;
END;
$$;

REVOKE ALL ON FUNCTION public.get_public_stats() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.get_public_taxonomy() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_public_stats() TO anon, authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.get_public_taxonomy() TO anon, authenticated, service_role;

-- ── Contrôles (avec la clé publique, sans compte) ────────────────────────────────────────────────────────
--   POST /rest/v1/rpc/get_companies_page  -> 401 permission denied
--   POST /rest/v1/rpc/get_products_page   -> 401
--   POST /rest/v1/rpc/get_company_by_id   -> 401
--   GET  /rest/v1/company_product_categories?select=*&limit=1 -> 401
--   POST /rest/v1/rpc/get_public_stats    -> 200, une ligne de quatre totaux
--   POST /rest/v1/rpc/get_public_taxonomy -> 200, secteurs et catégories sans nom d'entreprise
-- Avec un compte connecté, les fonctions du catalogue répondent 200 comme avant.

-- ── Retour arrière (à n'utiliser qu'en cas de problème) ──────────────────────────────────────────────────
-- GRANT EXECUTE ON FUNCTION public.get_companies_page(int, int), public.get_products_page(int, int),
--   public.get_company_by_id(uuid), public.get_product_by_id(uuid), public.get_products_by_company(uuid) TO anon;
-- GRANT SELECT ON public.company_tags, public.company_product_categories, public.company_industries,
--   public.company_locations, public.product_characteristics, public.product_tags TO anon;
