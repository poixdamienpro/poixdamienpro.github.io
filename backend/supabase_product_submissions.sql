-- ============================================================
-- BUY-INEER — File d'attente de soumissions fournisseur
-- À exécuter dans Supabase : SQL Editor → New query → Run
-- ============================================================

create table if not exists public.product_submissions (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  status text not null default 'pending', -- pending | approved | rejected

  -- contact (qui soumet)
  submitter_name text not null,
  submitter_email text not null,

  -- entreprise (nouvelle ou existante)
  company_name text not null,
  company_country text,
  company_hq text,
  company_industry text,
  company_site text,
  company_description text,
  company_contact_email text,

  -- produit
  product_name text not null,
  product_category text not null,
  product_industry text,
  product_description text,
  product_price_label text,
  product_specs jsonb,      -- [{"label":"...", "value":"..."}]
  product_certs text[],     -- ["CE","UN38.3", ...]

  notes text
);

alter table public.product_submissions enable row level security;

-- Le public (clé anon) peut uniquement INSÉRER, jamais lire/modifier/supprimer.
-- Ça empêche un visiteur de voir les soumissions des autres fournisseurs,
-- et empêche toute modification a posteriori depuis le site.
drop policy if exists "anon_can_submit" on public.product_submissions;
create policy "anon_can_submit"
  on public.product_submissions
  for insert
  to anon
  with check (true);

-- Pour relire/valider les soumissions, utilise l'éditeur de table Supabase
-- (connecté avec ton compte, pas avec la clé anon) ou la clé service_role
-- en backend. Aucune policy SELECT n'est créée pour anon ici, par design.
