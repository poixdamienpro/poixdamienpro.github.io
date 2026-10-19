-- ============================================================
-- BUY-INNER — Actualités (blog > Actualités) — 2026-10
--
-- Deux types d'actualités, écrites et publiées depuis l'onglet « Actualités » de pages/admin.html :
--   * company : annonces de Buy-inner (nouveaux fournisseurs, partenariats, nouveautés du site…) ;
--   * watch   : veille sectorielle — un RÉSUMÉ court, rédigé avec ses propres mots, qui cite la source et renvoie
--               vers l'article d'origine (source_name et source_url obligatoires, texte limité : on ne recopie pas
--               le contenu d'un tiers).
--
--   * Public (anon) : lit uniquement les actualités publiées dont la date est passée, via deux fonctions
--     (get_news_page, get_news_by_slug) — jamais la table.
--   * Administrateurs (is_admin()) : lisent, écrivent, publient, programment (published_at dans le futur), suppriment.
--
-- Prérequis : is_admin() (supabase_admin_setup.sql / supabase_multi_admin.sql).
-- Idempotent : peut être relancé sans risque.
-- ============================================================

CREATE TABLE IF NOT EXISTS public.news_posts (
  id                 uuid primary key default gen_random_uuid(),
  slug               text not null,
  kind               text not null default 'company',
  title              text not null,
  summary            text not null,
  body               text not null,
  source_name        text,
  source_url         text,
  image_url          text,
  tags               text[] not null default '{}',
  status             text not null default 'draft',
  published_at       timestamptz,
  linkedin_posted_at timestamptz,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  CONSTRAINT news_posts_slug_uniq   UNIQUE (slug),
  CONSTRAINT news_posts_slug_chk    CHECK (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$' AND char_length(slug) <= 90),
  CONSTRAINT news_posts_kind_chk    CHECK (kind IN ('company', 'watch')),
  CONSTRAINT news_posts_status_chk  CHECK (status IN ('draft', 'published')),
  CONSTRAINT news_posts_len_chk     CHECK (char_length(title) BETWEEN 5 AND 160
                                           AND char_length(summary) BETWEEN 20 AND 300
                                           AND char_length(body) BETWEEN 20 AND 8000),
  CONSTRAINT news_posts_tags_chk    CHECK (cardinality(tags) <= 8),
  CONSTRAINT news_posts_urls_chk    CHECK ((source_url IS NULL OR source_url ~* '^https?://[^[:space:]]+$')
                                           AND (image_url IS NULL OR image_url ~* '^https?://[^[:space:]]+$')),
  -- Veille : source citée obligatoire et résumé court (on ne republie pas l'article d'un tiers).
  CONSTRAINT news_posts_watch_chk   CHECK (kind <> 'watch' OR (
                                             source_name IS NOT NULL AND char_length(btrim(source_name)) > 0
                                             AND source_url IS NOT NULL AND char_length(body) <= 1500))
);

CREATE INDEX IF NOT EXISTS news_posts_published_idx ON public.news_posts (status, published_at DESC);

ALTER TABLE public.news_posts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS admin_all_news_posts ON public.news_posts;
CREATE POLICY admin_all_news_posts ON public.news_posts
  FOR ALL TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- Le projet retire les droits par défaut : on les accorde explicitement (la politique ci-dessus filtre).
REVOKE ALL ON public.news_posts FROM anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.news_posts TO authenticated;

-- Horodatage + date de publication automatique au passage en « publié ».
CREATE OR REPLACE FUNCTION public._news_posts_touch()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
  NEW.updated_at := now();
  NEW.title := btrim(NEW.title);
  IF NEW.status = 'published' AND NEW.published_at IS NULL THEN NEW.published_at := now(); END IF;
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION public._news_posts_touch() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS news_posts_touch ON public.news_posts;
CREATE TRIGGER news_posts_touch
  BEFORE INSERT OR UPDATE ON public.news_posts
  FOR EACH ROW EXECUTE FUNCTION public._news_posts_touch();

-- Lecture publique : liste (sans le corps) et fiche par slug.
DROP FUNCTION IF EXISTS public.get_news_page(integer, integer, text);
CREATE FUNCTION public.get_news_page(p_limit integer DEFAULT 20, p_offset integer DEFAULT 0, p_kind text DEFAULT NULL)
RETURNS TABLE (id uuid, slug text, kind text, title text, summary text, source_name text, source_url text,
               image_url text, tags text[], published_at timestamptz, updated_at timestamptz)
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
  SELECT n.id, n.slug, n.kind, n.title, n.summary, n.source_name, n.source_url, n.image_url, n.tags, n.published_at, n.updated_at
  FROM public.news_posts n
  WHERE n.status = 'published' AND n.published_at <= now()
    AND (p_kind IS NULL OR n.kind = p_kind)
  ORDER BY n.published_at DESC, n.id
  LIMIT LEAST(GREATEST(COALESCE(p_limit, 20), 1), 50)
  OFFSET GREATEST(COALESCE(p_offset, 0), 0);
$$;

DROP FUNCTION IF EXISTS public.get_news_by_slug(text);
CREATE FUNCTION public.get_news_by_slug(p_slug text)
RETURNS TABLE (id uuid, slug text, kind text, title text, summary text, body text, source_name text, source_url text,
               image_url text, tags text[], published_at timestamptz, updated_at timestamptz)
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
  SELECT n.id, n.slug, n.kind, n.title, n.summary, n.body, n.source_name, n.source_url, n.image_url, n.tags, n.published_at, n.updated_at
  FROM public.news_posts n
  WHERE n.slug = p_slug AND n.status = 'published' AND n.published_at <= now()
  LIMIT 1;
$$;

REVOKE ALL ON FUNCTION public.get_news_page(integer, integer, text) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.get_news_by_slug(text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_news_page(integer, integer, text) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.get_news_by_slug(text) TO anon, authenticated;

-- Contrôle : table avec RLS, 1 politique, 2 fonctions publiques.
SELECT c.relname, c.relrowsecurity AS rls,
       (SELECT count(*) FROM pg_policies p WHERE p.schemaname = 'public' AND p.tablename = 'news_posts') AS policies,
       (SELECT count(*) FROM pg_proc WHERE pronamespace = 'public'::regnamespace AND proname IN ('get_news_page', 'get_news_by_slug')) AS fonctions
FROM pg_class c WHERE c.oid = 'public.news_posts'::regclass;
