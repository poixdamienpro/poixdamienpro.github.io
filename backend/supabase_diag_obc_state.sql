-- ============================================================
-- BUY-INEER -- Diagnostic (lecture seule) : etat actuel des produits OBC
-- N'effectue AUCUNE modification -- juste un SELECT.
-- A executer dans Supabase : SQL Editor -> New query -> Run
-- ============================================================

-- 1) Contenu des fiches produits
SELECT category, industry, count(*) AS nb_produits
FROM products
WHERE category ILIKE '%OBC%'
GROUP BY category, industry
ORDER BY category, industry;

-- 2) Ce qui pilote reellement les chips de filtre sur l'annuaire/catalogue
SELECT category, count(*) AS nb_entreprises
FROM company_product_categories
WHERE category ILIKE '%OBC%'
GROUP BY category
ORDER BY category;
