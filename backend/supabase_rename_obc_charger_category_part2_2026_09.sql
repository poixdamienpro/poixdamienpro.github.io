-- ============================================================
-- BUY-INNER -- Complement a supabase_rename_obc_charger_category_2026_09.sql
--
-- Ce premier script ne renommait que products.category. Or les chips
-- de filtre catalogue/annuaire sont peuplees a partir d'une AUTRE
-- table, company_product_categories (voir le commentaire de
-- supabase_diag_obc_state.sql : "ce qui pilote reellement les chips de
-- filtre"), pas encore mise a jour -- resultat : le filtre
-- "OBC (On-Board Charger)" reste propose (0 produit derriere), et
-- "Chargeur embarque" n'apparait pas du tout.
--
-- Idempotent (UPDATE ... WHERE category = ..., sans effet si deja
-- applique).
-- ============================================================

UPDATE company_product_categories SET category = 'Chargeur embarqué'
WHERE category = 'OBC (On-Board Charger)';

-- ------------------------------------------------------------
-- Verification rapide apres execution :
-- select category, count(*) from company_product_categories where category in
--   ('Chargeur embarqué', 'OBC (On-Board Charger)') group by category;
-- -- attendu : 'OBC (On-Board Charger)' = 0 ligne, 'Chargeur embarqué' = 2
-- (Delta Electronics, Brusa Elektronik)
-- ============================================================
