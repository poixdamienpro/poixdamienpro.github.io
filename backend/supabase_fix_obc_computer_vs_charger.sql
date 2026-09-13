-- ============================================================
-- BUY-INEER -- Fix categorie OBC : separer "On-Board Computer" (Spatial)
-- de "On-Board Charger" (Automobile)
--
-- Bug : 23 produits "ordinateur de bord" spatiaux sont etiquetes
-- 'OBC (On-Board Charger)' au lieu de 'OBC (Onboard Computer)'. Le filtre
-- JS de pages/categories/obc.html exclut tout ce qui contient "CHARGER"
-- dans la categorie -> ces 23 produits sont invisibles sur leur propre
-- page categorie. Seul Brusa Elektronik / OBC NLG5 11kW (Automobile) est
-- un vrai chargeur embarque et doit garder son nom actuel.
--
-- A executer dans Supabase : SQL Editor -> New query -> Run
-- Idempotent : peut etre relance sans effet si deja applique.
-- ============================================================

-- Produits : uniquement les OBC spatiaux (jamais Automobile)
UPDATE products
SET category = 'OBC (Onboard Computer)'
WHERE category = 'OBC (On-Board Charger)'
  AND industry = 'Spatial';

-- Filtres annuaire (company_product_categories) : idem, uniquement pour
-- les entreprises dont l'industrie est Spatial (pas Brusa Elektronik).
UPDATE company_product_categories cpc
SET category = 'OBC (Onboard Computer)'
FROM companies c
WHERE cpc.company_id = c.id
  AND cpc.category = 'OBC (On-Board Charger)'
  AND c.industry = 'Spatial';

-- Verification (a lancer manuellement pour controler le resultat) :
-- SELECT name, category, industry FROM products WHERE category ILIKE 'OBC%' ORDER BY category, industry;
