-- ============================================================
-- BUY-INEER — Comptes fournisseur (revendication manuelle,
-- toute modification de produit repasse par validation admin)
-- À exécuter dans Supabase : SQL Editor → New query → Run
-- Prérequis : supabase_product_submissions.sql et
--             supabase_admin_setup.sql déjà exécutés
-- ============================================================

-- ------------------------------------------------------------
-- 1. Lien entreprise ↔ compte fournisseur
-- ------------------------------------------------------------
alter table public.companies
  add column if not exists claimed_by_user_id uuid references auth.users(id);

-- ------------------------------------------------------------
-- 2. Demandes de revendication (toujours validées à la main par toi)
-- ------------------------------------------------------------
create table if not exists public.company_claims (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  status text not null default 'pending', -- pending | approved | rejected
  user_id uuid not null references auth.users(id),
  user_email text not null,
  company_id uuid not null references public.companies(id),
  notes text
);
alter table public.company_claims enable row level security;

drop policy if exists "user_can_request_own_claim" on public.company_claims;
create policy "user_can_request_own_claim"
  on public.company_claims for insert
  to authenticated
  with check (user_id = auth.uid());

drop policy if exists "user_can_see_own_claims" on public.company_claims;
create policy "user_can_see_own_claims"
  on public.company_claims for select
  to authenticated
  using (user_id = auth.uid() or is_admin());

drop policy if exists "admin_can_update_claims" on public.company_claims;
create policy "admin_can_update_claims"
  on public.company_claims for update
  to authenticated
  using (is_admin())
  with check (is_admin());

-- ------------------------------------------------------------
-- 3. product_submissions — étendre pour modif/suppression et
--    pour les soumissions venant du tableau de bord fournisseur
-- ------------------------------------------------------------
alter table public.product_submissions
  add column if not exists submission_type text not null default 'new', -- new | update | delete
  add column if not exists target_product_id uuid references public.products(id),
  add column if not exists company_id uuid references public.companies(id),
  add column if not exists submitter_user_id uuid references auth.users(id);

-- Le fournisseur connecté peut soumettre new/update/delete UNIQUEMENT
-- pour une entreprise qu'il a fait revendiquer avec succès (claimed_by_user_id).
-- Pour 'update'/'delete', le produit visé doit appartenir à cette même entreprise.
drop policy if exists "owner_can_submit_changes" on public.product_submissions;
create policy "owner_can_submit_changes"
  on public.product_submissions for insert
  to authenticated
  with check (
    submitter_user_id = auth.uid()
    and company_id in (select id from public.companies where claimed_by_user_id = auth.uid())
    and (
      target_product_id is null
      or target_product_id in (
        select p.id from public.products p
        join public.companies c on c.id = p.company_id
        where c.claimed_by_user_id = auth.uid()
      )
    )
  );

drop policy if exists "owner_can_see_own_submissions" on public.product_submissions;
create policy "owner_can_see_own_submissions"
  on public.product_submissions for select
  to authenticated
  using (submitter_user_id = auth.uid() or is_admin());

-- ------------------------------------------------------------
-- 4. Le fournisseur connecté peut voir (lecture seule) sa propre
--    entreprise et ses propres produits pour son tableau de bord —
--    aucune écriture directe, tout passe par product_submissions.
-- ------------------------------------------------------------
drop policy if exists "owner_select_own_company" on public.companies;
create policy "owner_select_own_company"
  on public.companies for select
  to authenticated
  using (claimed_by_user_id = auth.uid());

drop policy if exists "owner_select_own_products" on public.products;
create policy "owner_select_own_products"
  on public.products for select
  to authenticated
  using (company_id in (select id from public.companies where claimed_by_user_id = auth.uid()));

drop policy if exists "owner_select_own_product_specs" on public.product_specs;
create policy "owner_select_own_product_specs"
  on public.product_specs for select
  to authenticated
  using (product_id in (
    select p.id from public.products p
    join public.companies c on c.id = p.company_id
    where c.claimed_by_user_id = auth.uid()
  ));

drop policy if exists "owner_select_own_product_certs" on public.product_certs;
create policy "owner_select_own_product_certs"
  on public.product_certs for select
  to authenticated
  using (product_id in (
    select p.id from public.products p
    join public.companies c on c.id = p.company_id
    where c.claimed_by_user_id = auth.uid()
  ));

-- ------------------------------------------------------------
-- Rappel du flux :
--   1. Le fournisseur crée un compte (email + mot de passe) → Supabase Auth.
--   2. Il demande à revendiquer son entreprise (company_claims, pending).
--   3. TOI tu valides la revendication dans la page admin → companies.claimed_by_user_id = son uid.
--   4. Une fois revendiquée, il voit son tableau de bord (ses produits actuels).
--   5. Ajout / modif / suppression → crée une ligne product_submissions
--      (type new/update/delete), TOUJOURS en attente de ta validation
--      dans la page admin, exactement comme les soumissions publiques.
-- ------------------------------------------------------------
