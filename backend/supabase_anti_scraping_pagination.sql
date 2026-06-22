-- ============================================================
-- BUY-INEER — Anti-scraping : pagination forcée sur les lectures publiques
-- À exécuter dans Supabase : SQL Editor → New query → Run
-- Prérequis : v_companies_summary et v_products_full existent déjà.
--
-- Pourquoi : aujourd'hui, n'importe qui peut faire une seule requête
-- GET sur v_companies_summary / v_products_full et récupérer tout le
-- catalogue d'un coup (copier-coller en 1 clic). On remplace l'accès
-- direct à ces vues par des fonctions RPC qui imposent une limite de
-- page (max 50 lignes) — un scraper doit alors boucler page par page
-- au lieu de dumper la base en une requête.
--
-- ⚠️ DEUX ÉTAPES SÉPARÉES, À NE PAS LANCER EN MÊME TEMPS :
--   ÉTAPE 1 (additive, sans risque) : crée les fonctions RPC, ne casse
--     rien — exécute-la dès maintenant, avant ou après avoir poussé le
--     nouveau index.html/js/api.js sur GitHub Pages, l'ordre ne compte
--     pas pour celle-ci.
--   ÉTAPE 2 (coupe l'ancien accès) : à exécuter SEULEMENT une fois que
--     tu as confirmé que le site en ligne fonctionne avec le nouveau
--     code (qui appelle les RPC). Si tu la lances avant, le site
--     affichera des erreurs tant que le nouveau code n'est pas déployé
--     (et que le cache GitHub Pages, ~10 min, n'a pas expiré).
-- ============================================================

-- ------------------------------------------------------------
-- ÉTAPE 1 — fonctions RPC paginées (lecture publique uniquement)
-- ------------------------------------------------------------
create or replace function public.get_companies_page(p_limit int default 20, p_offset int default 0)
returns setof public.v_companies_summary
language sql
stable
security definer
set search_path = public
as $$
  select * from public.v_companies_summary
  order by premium desc, name asc
  limit least(greatest(p_limit, 1), 50)
  offset greatest(p_offset, 0);
$$;

create or replace function public.get_products_page(p_limit int default 20, p_offset int default 0)
returns setof public.v_products_full
language sql
stable
security definer
set search_path = public
as $$
  select * from public.v_products_full
  order by company_name asc, name asc
  limit least(greatest(p_limit, 1), 50)
  offset greatest(p_offset, 0);
$$;

grant execute on function public.get_companies_page(int, int) to anon, authenticated;
grant execute on function public.get_products_page(int, int) to anon, authenticated;

-- ------------------------------------------------------------
-- ÉTAPE 2 — à lancer SÉPARÉMENT, plus tard, une fois le nouveau
-- front confirmé en ligne. Retire l'accès direct en lecture aux
-- vues pour anon/authenticated — seules les RPC ci-dessus restent
-- un chemin de lecture public (elles tournent en security definer,
-- donc continuent de fonctionner même sans accès direct à la vue).
-- ------------------------------------------------------------
-- revoke select on public.v_companies_summary from anon, authenticated;
-- revoke select on public.v_products_full from anon, authenticated;
