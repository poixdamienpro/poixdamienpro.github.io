-- ============================================================
-- BUY-INNER — Statistiques d'inscriptions pour l'onglet admin
-- "Inscrits" (pages/admin.html + js/pages/admin.js loadSignupStats).
--
-- Source : auth.users (tous les comptes créés sur le site : acheteurs,
-- fournisseurs), hors administrateurs. buyer_profiles ne convient pas :
-- chaque acheteur n'y voit que sa propre ligne (RLS), et la ligne n'est
-- créée qu'à la première connexion confirmée.
--
-- auth.users n'est pas lisible depuis l'API publique ; on passe donc par
-- une fonction SECURITY DEFINER réservée aux admins (is_admin(), voir
-- supabase_add_admins_table_2026_10.sql). Elle ne renvoie que des
-- agrégats par jour, jamais d'email ni d'identifiant.
--
-- À exécuter dans Supabase : SQL Editor → New query → Run
-- Prérequis : avoir exécuté supabase_add_admins_table_2026_10.sql
-- Idempotent.
-- ============================================================

drop function if exists public.get_signup_stats();

create function public.get_signup_stats()
returns table (day date, signups int, confirmed int)
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not public.is_admin() then
    raise exception 'forbidden' using errcode = '42501';
  end if;

  return query
  select
    (u.created_at at time zone 'Europe/Paris')::date as day,
    count(*)::int as signups,
    count(*) filter (where u.email_confirmed_at is not null)::int as confirmed
  from auth.users u
  where not exists (select 1 from public.admins a where a.user_id = u.id)
  group by 1
  order by 1;
end;
$$;

-- Ce projet Supabase redonne automatiquement EXECUTE à anon sur toute
-- fonction (re)créée : on le retire explicitement.
revoke all on function public.get_signup_stats() from public;
revoke execute on function public.get_signup_stats() from anon;
grant execute on function public.get_signup_stats() to authenticated;

-- Vérification (en tant qu'admin connecté sur le site, pas dans l'éditeur SQL
-- où auth.uid() est nul) : l'onglet admin "Inscrits" doit afficher les courbes.
