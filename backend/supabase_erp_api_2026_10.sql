-- ============================================================
-- BUY-INEER — API ERP (v1) : clés API, quotas, lectures catalogue
-- À exécuter dans Supabase : SQL Editor → New query → Run
-- Prérequis : is_admin(), v_products_full, v_companies_summary, table leads.
-- Sûr à relancer.
--
-- POURQUOI
-- --------
-- Les ERP des acheteurs (Odoo, SAP, Dynamics, Sage…) veulent chercher des
-- composants dans le catalogue et envoyer des demandes de devis sans passer
-- par le site. On leur ouvre www.buy-inner.com/api/v1/* (Worker Cloudflare,
-- voir cloudflare/supabase-proxy-worker.js), MAIS sans rouvrir le scraping
-- fermé par supabase_lock_base_tables.sql :
--   - chaque client a SA clé, délivrée par un admin, révocable ;
--   - chaque clé a un quota de requêtes par jour (api_usage) ;
--   - toutes les fonctions ci-dessous sont réservées à service_role : seul
--     le Worker peut les appeler, jamais la clé anon du navigateur (le proxy
--     générique /api/rest/v1/rpc/... ne permet donc PAS de les atteindre).
--
-- La clé en clair n'est JAMAIS stockée : le Worker la hache (SHA-256) et
-- ne la montre qu'une fois, à sa création, dans le panneau admin.
-- ============================================================

-- ------------------------------------------------------------
-- 1. Clés API
-- ------------------------------------------------------------
create table if not exists public.api_keys (
  id             uuid primary key default gen_random_uuid(),
  client_company text not null,
  label          text,
  contact_email  text,
  key_prefix     text not null,          -- ex. « bik_3f9a2c… », pour reconnaître la clé dans l'admin
  key_hash       text not null unique,   -- SHA-256 hex de la clé complète
  scopes         text[] not null default array['catalog:read', 'quotes:write'],
  daily_quota    int not null default 1000 check (daily_quota > 0),
  created_by     text,
  created_at     timestamptz not null default now(),
  last_used_at   timestamptz,
  revoked_at     timestamptz
);

create table if not exists public.api_usage (
  key_id   uuid not null references public.api_keys(id) on delete cascade,
  day      date not null,
  requests int not null default 0,
  primary key (key_id, day)
);

alter table public.api_keys  enable row level security;
alter table public.api_usage enable row level security;

-- Lecture réservée aux admins (affichage dans le panneau) ; aucune écriture
-- côté navigateur : création/révocation passent par le Worker (service_role).
revoke all on public.api_keys  from anon, authenticated;
revoke all on public.api_usage from anon, authenticated;
grant select on public.api_keys  to authenticated;
grant select on public.api_usage to authenticated;

drop policy if exists api_keys_admin_read on public.api_keys;
create policy api_keys_admin_read on public.api_keys
  for select to authenticated using (public.is_admin());

drop policy if exists api_usage_admin_read on public.api_usage;
create policy api_usage_admin_read on public.api_usage
  for select to authenticated using (public.is_admin());

-- ------------------------------------------------------------
-- 2. Authentification + décompte, en un seul appel atomique.
--    Ne renvoie rien si la clé est inconnue ou révoquée. Compte aussi
--    les requêtes au-delà du quota : c'est le Worker qui refuse (429).
-- ------------------------------------------------------------
create or replace function public.api_consume_key(p_key_hash text)
returns table (key_id uuid, client_company text, scopes text[], daily_quota int, used int)
language plpgsql
security definer
set search_path = public
as $$
#variable_conflict use_column
declare
  k public.api_keys;
  n int;
begin
  select * into k from public.api_keys where key_hash = p_key_hash and revoked_at is null;
  if not found then return; end if;

  insert into public.api_usage (key_id, day, requests) values (k.id, current_date, 1)
  on conflict (key_id, day) do update set requests = public.api_usage.requests + 1
  returning requests into n;

  update public.api_keys set last_used_at = now() where id = k.id;

  return query select k.id, k.client_company, k.scopes, k.daily_quota, n;
end;
$$;

-- ------------------------------------------------------------
-- 3. Recherche catalogue pour l'API. Pages de 100 lignes max (+1 pour
--    que le Worker sache s'il reste une page suivante).
-- ------------------------------------------------------------
create or replace function public.api_search_products(
  p_q text default null,
  p_category text default null,
  p_industry text default null,
  p_company_id uuid default null,
  p_limit int default 50,
  p_offset int default 0
)
returns setof public.v_products_full
language sql
stable
security definer
set search_path = public
as $$
  select * from public.v_products_full v
  where (p_q is null
         or v.name ilike '%' || p_q || '%'
         or v.name_en ilike '%' || p_q || '%'
         or v.description ilike '%' || p_q || '%'
         or v.company_name ilike '%' || p_q || '%')
    and (p_category is null or v.category ilike p_category)
    and (p_industry is null or v.industry ilike p_industry)
    and (p_company_id is null or v.company_id = p_company_id)
  order by v.company_name asc, v.name asc, v.id asc
  limit least(greatest(p_limit, 1), 101)
  offset greatest(p_offset, 0);
$$;

create or replace function public.api_search_companies(
  p_q text default null,
  p_country text default null,
  p_limit int default 50,
  p_offset int default 0
)
returns setof public.v_companies_summary
language sql
stable
security definer
set search_path = public
as $$
  select * from public.v_companies_summary v
  where (p_q is null
         or v.name ilike '%' || p_q || '%'
         or v.description ilike '%' || p_q || '%')
    and (p_country is null or v.country ilike p_country)
  order by v.name asc, v.id asc
  limit least(greatest(p_limit, 1), 101)
  offset greatest(p_offset, 0);
$$;

-- Postgres donne EXECUTE à PUBLIC par défaut, et Supabase à anon/authenticated :
-- on retire tout, puis on ne rend la main qu'à service_role (le Worker).
revoke execute on function public.api_consume_key(text) from public, anon, authenticated;
revoke execute on function public.api_search_products(text, text, text, uuid, int, int) from public, anon, authenticated;
revoke execute on function public.api_search_companies(text, text, int, int) from public, anon, authenticated;
grant execute on function public.api_consume_key(text) to service_role;
grant execute on function public.api_search_products(text, text, text, uuid, int, int) to service_role;
grant execute on function public.api_search_companies(text, text, int, int) to service_role;

-- ------------------------------------------------------------
-- 4. Demandes de devis venues d'un ERP : même table que le formulaire
--    du site (leads), avec la source et la référence côté ERP. L'index
--    unique rend l'envoi idempotent : un ERP qui renvoie la même demande
--    (même external_ref) après un timeout ne crée pas de doublon.
-- ------------------------------------------------------------
alter table public.leads add column if not exists source       text not null default 'web';
alter table public.leads add column if not exists api_key_id   uuid references public.api_keys(id) on delete set null;
alter table public.leads add column if not exists external_ref text;

create unique index if not exists leads_api_external_ref_uniq
  on public.leads (api_key_id, external_ref)
  where api_key_id is not null and external_ref is not null;

-- ------------------------------------------------------------
-- Vérification (doit renvoyer false pour anon) :
--   select has_function_privilege('anon', 'public.api_search_products(text,text,text,uuid,int,int)', 'execute');
-- ------------------------------------------------------------
