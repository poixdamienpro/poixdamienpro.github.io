-- ============================================================
-- BUY-INNER — Actualités bilingues (français + anglais) — 2026-10
--
-- À exécuter APRÈS backend/supabase_news_2026_10.sql. Chaque actualité a désormais une version anglaise
-- (title_en, summary_en, body_en) : elle est OBLIGATOIRE pour publier, facultative pour un brouillon.
-- La source d'une veille, l'image, les thèmes et l'adresse (slug) sont communs aux deux langues.
-- linkedin_posted_en_at : date du post LinkedIn en anglais (linkedin_posted_at = post en français).
--
-- Les actualités déjà publiées sans version anglaise restent lisibles en français ; elles ne seront pas
-- proposées en anglais, et il faudra ajouter leur version anglaise pour pouvoir les modifier.
-- Idempotent : peut être relancé sans risque.
-- ============================================================

ALTER TABLE public.news_posts
  ADD COLUMN IF NOT EXISTS title_en text,
  ADD COLUMN IF NOT EXISTS summary_en text,
  ADD COLUMN IF NOT EXISTS body_en text,
  ADD COLUMN IF NOT EXISTS linkedin_posted_en_at timestamptz;

ALTER TABLE public.news_posts DROP CONSTRAINT IF EXISTS news_posts_len_en_chk;
ALTER TABLE public.news_posts ADD CONSTRAINT news_posts_len_en_chk CHECK (
  (title_en IS NULL OR char_length(btrim(title_en)) BETWEEN 5 AND 160)
  AND (summary_en IS NULL OR char_length(summary_en) BETWEEN 20 AND 300)
  AND (body_en IS NULL OR char_length(body_en) BETWEEN 20 AND 8000)
  AND (kind <> 'watch' OR body_en IS NULL OR char_length(body_en) <= 1500)
);

-- Publier exige les deux langues. NOT VALID : les lignes déjà en base ne sont pas contrôlées rétroactivement,
-- mais toute nouvelle ligne ou modification doit respecter la règle.
ALTER TABLE public.news_posts DROP CONSTRAINT IF EXISTS news_posts_en_required_chk;
ALTER TABLE public.news_posts ADD CONSTRAINT news_posts_en_required_chk CHECK (
  status <> 'published' OR (title_en IS NOT NULL AND summary_en IS NOT NULL AND body_en IS NOT NULL)
) NOT VALID;

CREATE OR REPLACE FUNCTION public._news_posts_touch()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
  NEW.updated_at := now();
  NEW.title := btrim(NEW.title);
  NEW.title_en := NULLIF(btrim(NEW.title_en), '');
  NEW.summary_en := NULLIF(btrim(NEW.summary_en), '');
  NEW.body_en := NULLIF(btrim(NEW.body_en), '');
  IF NEW.status = 'published' AND NEW.published_at IS NULL THEN NEW.published_at := now(); END IF;
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION public._news_posts_touch() FROM PUBLIC, anon, authenticated;

-- Lecture publique : mêmes fonctions, avec les colonnes anglaises en plus.
DROP FUNCTION IF EXISTS public.get_news_page(integer, integer, text);
CREATE FUNCTION public.get_news_page(p_limit integer DEFAULT 20, p_offset integer DEFAULT 0, p_kind text DEFAULT NULL)
RETURNS TABLE (id uuid, slug text, kind text, title text, summary text, title_en text, summary_en text,
               source_name text, source_url text, image_url text, tags text[], published_at timestamptz, updated_at timestamptz)
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
  SELECT n.id, n.slug, n.kind, n.title, n.summary, n.title_en, n.summary_en,
         n.source_name, n.source_url, n.image_url, n.tags, n.published_at, n.updated_at
  FROM public.news_posts n
  WHERE n.status = 'published' AND n.published_at <= now()
    AND (p_kind IS NULL OR n.kind = p_kind)
  ORDER BY n.published_at DESC, n.id
  LIMIT LEAST(GREATEST(COALESCE(p_limit, 20), 1), 50)
  OFFSET GREATEST(COALESCE(p_offset, 0), 0);
$$;

DROP FUNCTION IF EXISTS public.get_news_by_slug(text);
CREATE FUNCTION public.get_news_by_slug(p_slug text)
RETURNS TABLE (id uuid, slug text, kind text, title text, summary text, body text, title_en text, summary_en text, body_en text,
               source_name text, source_url text, image_url text, tags text[], published_at timestamptz, updated_at timestamptz)
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
  SELECT n.id, n.slug, n.kind, n.title, n.summary, n.body, n.title_en, n.summary_en, n.body_en,
         n.source_name, n.source_url, n.image_url, n.tags, n.published_at, n.updated_at
  FROM public.news_posts n
  WHERE n.slug = p_slug AND n.status = 'published' AND n.published_at <= now()
  LIMIT 1;
$$;

REVOKE ALL ON FUNCTION public.get_news_page(integer, integer, text) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.get_news_by_slug(text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_news_page(integer, integer, text) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.get_news_by_slug(text) TO anon, authenticated;

-- Contrôle : 4 colonnes ajoutées, 2 contraintes, 2 fonctions.
SELECT (SELECT count(*) FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'news_posts'
          AND column_name IN ('title_en', 'summary_en', 'body_en', 'linkedin_posted_en_at')) AS colonnes_en,
       (SELECT count(*) FROM pg_constraint WHERE conrelid = 'public.news_posts'::regclass
          AND conname IN ('news_posts_len_en_chk', 'news_posts_en_required_chk')) AS contraintes,
       (SELECT count(*) FROM pg_proc WHERE pronamespace = 'public'::regnamespace AND proname IN ('get_news_page', 'get_news_by_slug')) AS fonctions;
