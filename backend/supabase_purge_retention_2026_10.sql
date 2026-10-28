-- ============================================================
-- BUY-INNER — Purge automatique des données selon les durées annoncées dans la politique de confidentialité
-- (script à exécuter UNE fois, idempotent)
--
--   site_page_views, entity_views : mesure d'audience interne, 13 mois maximum
--   password_reset_requests       : adresse + IP d'une demande de mot de passe oublié, 24 heures maximum
--                                   (le Worker en purge déjà à chaque demande ; ce script garantit la durée même s'il
--                                   n'y a plus de demande)
--
-- Une fonction public.purge_expired_data() supprime les lignes trop anciennes et renvoie le nombre supprimé par table.
-- Elle est programmée toutes les heures (à hh:17) avec pg_cron. Si pg_cron n'est pas activé sur le projet, le script ne
-- plante pas : il l'indique, la fonction reste utilisable à la main (SELECT * FROM public.purge_expired_data();), et
-- il suffit d'activer l'extension (Database > Extensions > pg_cron) puis de relancer ce script.
-- ============================================================

CREATE OR REPLACE FUNCTION public.purge_expired_data()
RETURNS TABLE (table_name text, deleted bigint)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  r record;
  n bigint;
BEGIN
  FOR r IN
    SELECT * FROM (VALUES
      ('site_page_views',         '13 months'),
      ('entity_views',            '13 months'),
      ('password_reset_requests', '24 hours')
    ) AS v(tbl, keep)
  LOOP
    -- Une table absente (script pas encore exécuté) est ignorée : la purge des autres continue.
    IF to_regclass(format('public.%I', r.tbl)) IS NOT NULL THEN
      EXECUTE format('DELETE FROM public.%I WHERE created_at < now() - %L::interval', r.tbl, r.keep);
      GET DIAGNOSTICS n = ROW_COUNT;
      table_name := r.tbl; deleted := n;
      RETURN NEXT;
    END IF;
  END LOOP;
END;
$$;

-- Jamais appelable depuis le navigateur : seulement par la base (pg_cron) ou la clé de service.
REVOKE ALL ON FUNCTION public.purge_expired_data() FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.purge_expired_data() TO service_role;

-- ── Programmation : toutes les heures à hh:17 ─────────────────────────────
DO $$
BEGIN
  CREATE EXTENSION IF NOT EXISTS pg_cron;
  PERFORM cron.unschedule(jobid) FROM cron.job WHERE jobname = 'buyinner-purge-retention';
  PERFORM cron.schedule('buyinner-purge-retention', '17 * * * *', 'SELECT public.purge_expired_data()');
  RAISE NOTICE 'Purge programmée : toutes les heures à hh:17 (tâche buyinner-purge-retention).';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'pg_cron indisponible (%). Activez l''extension pg_cron (Database > Extensions) puis relancez ce script ; en attendant, appelez SELECT * FROM public.purge_expired_data(); à la main.', SQLERRM;
END;
$$;

-- ── Contrôles ────────────────────────────────────────────────────────────
-- 1) Première purge, tout de suite : nombre de lignes supprimées par table.
SELECT * FROM public.purge_expired_data();
-- 2) La tâche est-elle programmée ? (doit renvoyer 1 ligne ; aucune ligne = pg_cron pas activé)
--    SELECT jobname, schedule, active FROM cron.job WHERE jobname = 'buyinner-purge-retention';
