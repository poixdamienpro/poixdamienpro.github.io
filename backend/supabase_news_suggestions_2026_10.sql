-- ============================================================
-- BUY-INNER — Propositions d'actualités rédigées par Claude (routine « Veille & posts LinkedIn ») — 2026-10
--
-- La routine de veille dépose ici des brouillons d'actualités déjà rédigés en français ET en anglais (via
-- l'adresse /api/news-ingest du Worker, protégée par une clé). Rien n'est jamais publié automatiquement :
-- dans l'onglet « Actualités » de pages/admin.html, quand on veut créer une actualité, on choisit une des
-- 2-3 dernières propositions, on la modifie, puis on la publie (ou on l'ignore).
--
--   * Les propositions n'ont aucun accès public. Seuls les administrateurs (is_admin()) les lisent et les
--     modifient ; l'écriture par la routine passe par le Worker (clé de service), jamais par le navigateur.
--   * Mêmes règles de fond que les actualités : veille = source citée + résumé de 1 500 caractères maximum,
--     version anglaise obligatoire, liens en http(s).
--   * Une même source (source_url) n'est proposée qu'une fois.
--
-- Prérequis : supabase_news_2026_10.sql (table news_posts) et is_admin().
-- Idempotent : peut être relancé sans risque.
-- ============================================================

CREATE TABLE IF NOT EXISTS public.news_suggestions (
  id          uuid primary key default gen_random_uuid(),
  kind        text not null default 'watch',
  title       text not null,
  summary     text not null,
  body        text not null,
  title_en    text not null,
  summary_en  text not null,
  body_en     text not null,
  source_name text,
  source_url  text,
  image_url   text,
  tags        text[] not null default '{}',
  angle       text,                                  -- pourquoi cet angle / pourquoi maintenant (affiché à l'admin)
  status      text not null default 'new',           -- new | used | dismissed
  news_id     uuid references public.news_posts(id) on delete set null,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  CONSTRAINT news_sugg_kind_chk   CHECK (kind IN ('company', 'watch')),
  CONSTRAINT news_sugg_status_chk CHECK (status IN ('new', 'used', 'dismissed')),
  CONSTRAINT news_sugg_len_chk    CHECK (char_length(btrim(title)) BETWEEN 5 AND 160 AND char_length(btrim(title_en)) BETWEEN 5 AND 160
                                         AND char_length(summary) BETWEEN 20 AND 300 AND char_length(summary_en) BETWEEN 20 AND 300
                                         AND char_length(body) BETWEEN 20 AND 8000 AND char_length(body_en) BETWEEN 20 AND 8000
                                         AND (angle IS NULL OR char_length(angle) <= 300)),
  CONSTRAINT news_sugg_tags_chk   CHECK (cardinality(tags) <= 8),
  CONSTRAINT news_sugg_urls_chk   CHECK ((source_url IS NULL OR source_url ~* '^https?://[^[:space:]]+$')
                                         AND (image_url IS NULL OR image_url ~* '^https?://[^[:space:]]+$')),
  CONSTRAINT news_sugg_watch_chk  CHECK (kind <> 'watch' OR (source_name IS NOT NULL AND char_length(btrim(source_name)) > 0
                                         AND source_url IS NOT NULL AND char_length(body) <= 1500 AND char_length(body_en) <= 1500))
);

-- Une même source n'est proposée qu'une seule fois.
CREATE UNIQUE INDEX IF NOT EXISTS news_sugg_source_uniq ON public.news_suggestions (lower(source_url)) WHERE source_url IS NOT NULL;
CREATE INDEX IF NOT EXISTS news_sugg_status_idx ON public.news_suggestions (status, created_at DESC);

ALTER TABLE public.news_suggestions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS admin_all_news_suggestions ON public.news_suggestions;
CREATE POLICY admin_all_news_suggestions ON public.news_suggestions
  FOR ALL TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- Le projet retire les droits par défaut : on les accorde explicitement (la politique ci-dessus filtre).
REVOKE ALL ON public.news_suggestions FROM anon, authenticated;
GRANT SELECT, UPDATE, DELETE ON public.news_suggestions TO authenticated;
-- Le Worker (route /api/news-ingest) écrit avec la clé de service : droits explicites, au cas où les droits par défaut seraient retirés.
GRANT ALL ON public.news_suggestions TO service_role;

CREATE OR REPLACE FUNCTION public._news_suggestions_touch()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION public._news_suggestions_touch() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS news_suggestions_touch ON public.news_suggestions;
CREATE TRIGGER news_suggestions_touch
  BEFORE UPDATE ON public.news_suggestions
  FOR EACH ROW EXECUTE FUNCTION public._news_suggestions_touch();

-- Contrôle : table avec RLS et 1 politique.
SELECT c.relname, c.relrowsecurity AS rls,
       (SELECT count(*) FROM pg_policies p WHERE p.schemaname = 'public' AND p.tablename = 'news_suggestions') AS policies
FROM pg_class c WHERE c.oid = 'public.news_suggestions'::regclass;
