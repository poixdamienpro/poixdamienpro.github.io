-- ============================================================
-- BUY-INEER — Compteur de visites (analytics basique, lu depuis l'admin)
-- À exécuter dans Supabase : SQL Editor → New query → Run
-- Prérequis : supabase_admin_setup.sql déjà exécuté (fonction is_admin())
--
-- Nom "site_page_views" (et pas "page_views") car une table page_views
-- existe déjà dans cette base avec un usage différent (suivi par
-- company_id/product_id, probablement lié à view_count_30d) — on ne
-- veut pas entrer en conflit avec ce mécanisme existant.
-- ============================================================

create table if not exists public.site_page_views (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  page text not null,        -- ex: "/", "/pages/annuaire.html"
  referrer text,              -- document.referrer, peut être vide
  user_agent text
);

alter table public.site_page_views enable row level security;

-- Le public (clé anon) peut uniquement insérer une ligne par vue de page —
-- jamais lire les vues des autres visiteurs. Pas de cookie, pas d'IP stockée :
-- ce sont des événements anonymes, pas un suivi individuel.
drop policy if exists "anon_can_log_view" on public.site_page_views;
create policy "anon_can_log_view"
  on public.site_page_views
  for insert
  to anon
  with check (true);

-- Seul l'admin peut lire les statistiques agrégées.
drop policy if exists "admin_can_select_site_page_views" on public.site_page_views;
create policy "admin_can_select_site_page_views"
  on public.site_page_views
  for select
  to authenticated
  using (is_admin());

create index if not exists site_page_views_created_at_idx on public.site_page_views (created_at desc);
