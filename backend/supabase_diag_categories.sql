-- Diagnostic : pourquoi les catégories ne s'affichent pas sur le site
-- À exécuter dans Supabase SQL Editor, puis copie-moi le résultat de chaque requête.

-- 1) La vue v_companies_summary expose-t-elle bien une colonne "id" ?
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'v_companies_summary'
ORDER BY ordinal_position;

-- 2) Aperçu des données réellement renvoyées par la vue
SELECT * FROM v_companies_summary LIMIT 3;

-- 3) Les lignes existent-elles bien dans company_product_categories ?
SELECT COUNT(*) AS nb_lignes_categories FROM company_product_categories;

-- 4) Jointure manuelle : est-ce que company_id de company_product_categories
--    correspond bien aux id de companies ?
SELECT c.name, cpc.category
FROM companies c
JOIN company_product_categories cpc ON cpc.company_id = c.id
LIMIT 10;

-- 5) RLS : la table company_product_categories autorise-t-elle la lecture publique (anon) ?
SELECT schemaname, tablename, policyname, roles, cmd, qual
FROM pg_policies
WHERE tablename = 'company_product_categories';

-- 6) RLS activé ou non sur la table ?
SELECT relname, relrowsecurity, relforcerowsecurity
FROM pg_class
WHERE relname = 'company_product_categories';
