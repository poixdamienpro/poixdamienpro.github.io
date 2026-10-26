-- ============================================================
-- BUY-INNER — Actualités : veille et analyses techniques longues (script à exécuter UNE fois, idempotent)
--
-- Jusqu'ici une veille était limitée à 1 500 caractères (un résumé). Pour publier de vraies analyses techniques,
-- le texte d'une veille peut désormais aller jusqu'à 12 000 caractères par langue. Les règles de fond ne changent pas :
-- une veille cite toujours sa source (nom + lien) et on ne recopie pas l'article d'origine.
-- Une actualité Buy-inner (kind = 'company') reste limitée à 8 000 caractères.
--
-- Concerne : news_posts (français et anglais) et news_suggestions (file d'attente alimentée par la routine).
-- À exécuter AVANT de redéployer le Worker et de pousser le site.
-- ============================================================

-- ── news_posts : texte français ────────────────────────────────────────────
ALTER TABLE public.news_posts DROP CONSTRAINT IF EXISTS news_posts_len_chk;
ALTER TABLE public.news_posts ADD CONSTRAINT news_posts_len_chk CHECK (
  char_length(title) BETWEEN 5 AND 160
  AND char_length(summary) BETWEEN 20 AND 300
  AND char_length(body) BETWEEN 20 AND 12000
  AND (kind <> 'company' OR char_length(body) <= 8000)
);

ALTER TABLE public.news_posts DROP CONSTRAINT IF EXISTS news_posts_watch_chk;
ALTER TABLE public.news_posts ADD CONSTRAINT news_posts_watch_chk CHECK (
  kind <> 'watch' OR (
    source_name IS NOT NULL AND char_length(btrim(source_name)) > 0
    AND source_url IS NOT NULL)
);

-- ── news_posts : texte anglais ─────────────────────────────────────────────
ALTER TABLE public.news_posts DROP CONSTRAINT IF EXISTS news_posts_len_en_chk;
ALTER TABLE public.news_posts ADD CONSTRAINT news_posts_len_en_chk CHECK (
  (title_en IS NULL OR char_length(btrim(title_en)) BETWEEN 5 AND 160)
  AND (summary_en IS NULL OR char_length(summary_en) BETWEEN 20 AND 300)
  AND (body_en IS NULL OR char_length(body_en) BETWEEN 20 AND 12000)
  AND (kind <> 'company' OR body_en IS NULL OR char_length(body_en) <= 8000)
);

-- ── news_suggestions (propositions de la routine) ─────────────────────────
ALTER TABLE public.news_suggestions DROP CONSTRAINT IF EXISTS news_sugg_len_chk;
ALTER TABLE public.news_suggestions ADD CONSTRAINT news_sugg_len_chk CHECK (
  char_length(btrim(title)) BETWEEN 5 AND 160 AND char_length(btrim(title_en)) BETWEEN 5 AND 160
  AND char_length(summary) BETWEEN 20 AND 300 AND char_length(summary_en) BETWEEN 20 AND 300
  AND char_length(body) BETWEEN 20 AND 12000 AND char_length(body_en) BETWEEN 20 AND 12000
  AND (kind <> 'company' OR (char_length(body) <= 8000 AND char_length(body_en) <= 8000))
  AND (angle IS NULL OR char_length(angle) <= 300)
);

ALTER TABLE public.news_suggestions DROP CONSTRAINT IF EXISTS news_sugg_watch_chk;
ALTER TABLE public.news_suggestions ADD CONSTRAINT news_sugg_watch_chk CHECK (
  kind <> 'watch' OR (source_name IS NOT NULL AND char_length(btrim(source_name)) > 0 AND source_url IS NOT NULL)
);
