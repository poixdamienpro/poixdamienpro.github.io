-- ============================================================
-- BUY-INNER — Remplace l'admin unique codé en dur par une vraie
-- table d'administrateurs, pour pouvoir en ajouter d'autres depuis
-- l'interface admin (voir cloudflare/supabase-proxy-worker.js
-- /api/admin-create-user et pages/admin.html).
--
-- À exécuter dans Supabase : SQL Editor → New query → Run
-- Prérequis : avoir déjà exécuté supabase_admin_setup.sql
-- Idempotent.
-- ============================================================

-- 1. Table des administrateurs -----------------------------------------
create table if not exists public.admins (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references auth.users(id) on delete cascade,
  email text not null,
  created_at timestamptz not null default now()
);

alter table public.admins enable row level security;

-- 2. Migration : fait entrer le compte admin actuel (codé en dur
--    jusqu'ici) dans la table, AVANT de changer is_admin() -- sinon
--    tu te coupes toi-même l'accès à la prochaine requête.
insert into public.admins (user_id, email)
select id, email from auth.users where email = 'poixdamien.pro@gmail.com'
on conflict (user_id) do nothing;

-- 3. is_admin() vérifie désormais la table plutôt qu'un email en dur.
--    SECURITY DEFINER est nécessaire : sans ça, la policy RLS sur
--    "admins" (qui appelle is_admin()) et la fonction elle-même
--    s'appelleraient en boucle. En SECURITY DEFINER, la fonction
--    s'exécute avec les droits de son propriétaire (le rôle utilisé
--    par l'éditeur SQL), qui contourne la RLS — comportement voulu
--    uniquement pour cette lecture précise.
create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (select 1 from public.admins where user_id = auth.uid());
$$;

-- 4. RLS sur admins : seuls les admins existants peuvent lister/ajouter/
--    retirer des admins (l'écriture réelle passe par le Worker avec la
--    clé service_role, qui contourne la RLS de toute façon — cette
--    policy protège la LECTURE/écriture directe via l'API publique).
drop policy if exists "admin_manage_admins" on public.admins;
create policy "admin_manage_admins" on public.admins
  for all to authenticated using (is_admin()) with check (is_admin());
