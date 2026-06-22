-- ============================================================
-- BUY-INEER — Accès admin (page de validation des soumissions)
-- À exécuter dans Supabase : SQL Editor → New query → Run
-- Prérequis : avoir déjà exécuté supabase_product_submissions.sql
-- ============================================================

-- ------------------------------------------------------------
-- 1. Créer le compte admin (à faire une fois, dans le Dashboard)
-- ------------------------------------------------------------
-- Authentication → Users → Add user → Create new user
--   Email: poixdamien.pro@gmail.com
--   Password: (choisis-en un fort, c'est la seule porte d'entrée)
--   Auto Confirm User: coché (sinon il faudra confirmer par email)
-- ------------------------------------------------------------

-- ------------------------------------------------------------
-- 2. Fonction is_admin() — vérifie l'email du token connecté
-- ------------------------------------------------------------
create or replace function public.is_admin()
returns boolean
language sql
stable
as $$
  select auth.jwt() ->> 'email' = 'poixdamien.pro@gmail.com';
$$;

-- ------------------------------------------------------------
-- 3. product_submissions — l'admin peut lire/valider/rejeter
-- ------------------------------------------------------------
drop policy if exists "admin_can_select_submissions" on public.product_submissions;
create policy "admin_can_select_submissions"
  on public.product_submissions for select
  to authenticated
  using (is_admin());

drop policy if exists "admin_can_update_submissions" on public.product_submissions;
create policy "admin_can_update_submissions"
  on public.product_submissions for update
  to authenticated
  using (is_admin())
  with check (is_admin());

drop policy if exists "admin_can_delete_submissions" on public.product_submissions;
create policy "admin_can_delete_submissions"
  on public.product_submissions for delete
  to authenticated
  using (is_admin());

-- ------------------------------------------------------------
-- 4. companies / products / specs / bars / certs / tags / catégories
--    — l'admin peut écrire pour publier une soumission approuvée
--    (lecture publique déjà en place via les vues v_companies_summary
--    et v_products_full, on ne touche pas à ça)
-- ------------------------------------------------------------
alter table public.companies enable row level security;
alter table public.products enable row level security;
alter table public.product_specs enable row level security;
alter table public.product_bars enable row level security;
alter table public.product_certs enable row level security;
alter table public.company_tags enable row level security;
alter table public.company_product_categories enable row level security;

drop policy if exists "admin_write_companies" on public.companies;
create policy "admin_write_companies" on public.companies
  for all to authenticated using (is_admin()) with check (is_admin());

drop policy if exists "admin_write_products" on public.products;
create policy "admin_write_products" on public.products
  for all to authenticated using (is_admin()) with check (is_admin());

drop policy if exists "admin_write_product_specs" on public.product_specs;
create policy "admin_write_product_specs" on public.product_specs
  for all to authenticated using (is_admin()) with check (is_admin());

drop policy if exists "admin_write_product_bars" on public.product_bars;
create policy "admin_write_product_bars" on public.product_bars
  for all to authenticated using (is_admin()) with check (is_admin());

drop policy if exists "admin_write_product_certs" on public.product_certs;
create policy "admin_write_product_certs" on public.product_certs
  for all to authenticated using (is_admin()) with check (is_admin());

drop policy if exists "admin_write_company_tags" on public.company_tags;
create policy "admin_write_company_tags" on public.company_tags
  for all to authenticated using (is_admin()) with check (is_admin());

drop policy if exists "admin_write_company_product_categories" on public.company_product_categories;
create policy "admin_write_company_product_categories" on public.company_product_categories
  for all to authenticated using (is_admin()) with check (is_admin());

-- ------------------------------------------------------------
-- IMPORTANT : si companies/products avaient déjà des policies
-- "lecture publique" (anon select) avant ce script, elles restent
-- actives — ce script n'ajoute QUE des policies d'écriture admin,
-- il ne retire aucun accès en lecture existant.
-- ------------------------------------------------------------
