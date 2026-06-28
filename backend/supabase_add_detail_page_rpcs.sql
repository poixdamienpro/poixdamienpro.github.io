-- ============================================================
-- BUY-INEER — RPC pour les fiches dédiées entreprise/produit (SEO)
-- À exécuter dans Supabase : SQL Editor → New query → Run
-- Prérequis : backend/supabase_anti_scraping_pagination.sql déjà exécuté
-- (get_companies_page/get_products_page existent, et l'accès direct
-- aux vues v_companies_summary/v_products_full est coupé pour anon).
--
-- pages/entreprise.html et pages/produit.html ont besoin de lire UNE
-- fiche précise par id — ces RPC le permettent sans rouvrir l'accès
-- libre aux vues complètes.
-- ============================================================

create or replace function public.get_company_by_id(p_id uuid)
returns setof public.v_companies_summary
language sql
stable
security definer
set search_path = public
as $$
  select * from public.v_companies_summary where id = p_id limit 1;
$$;

create or replace function public.get_products_by_company(p_company_id uuid)
returns setof public.v_products_full
language sql
stable
security definer
set search_path = public
as $$
  select * from public.v_products_full where company_id = p_company_id order by name asc limit 100;
$$;

create or replace function public.get_product_by_id(p_id uuid)
returns setof public.v_products_full
language sql
stable
security definer
set search_path = public
as $$
  select * from public.v_products_full where id = p_id limit 1;
$$;

grant execute on function public.get_company_by_id(uuid) to anon, authenticated;
grant execute on function public.get_products_by_company(uuid) to anon, authenticated;
grant execute on function public.get_product_by_id(uuid) to anon, authenticated;
