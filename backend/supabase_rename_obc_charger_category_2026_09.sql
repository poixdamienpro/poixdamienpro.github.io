-- ============================================================
-- BUY-INNER -- Renomme la categorie "OBC (On-Board Charger)" en
-- "Chargeur embarque".
--
-- Contexte : le sigle "OBC" est utilise sur le site avec deux sens
-- incompatibles -- "On-Board Charger" (chargeur embarque, cette
-- categorie) et "On-Board Computer" (ordinateur de bord spatial/
-- avionique, cf. page pages/categories/obc.html et la sous-categorie
-- "Calculateurs embarques" du groupe "Intelligence embarquee" dans
-- js/pages/catalogue.js). Decision : OBC reste reserve au sens
-- "ordinateur de bord" partout sur le site -- cette categorie perd
-- donc le sigle et devient simplement "Chargeur embarque".
--
-- Prerequis deja rempli : supabase_fix_obc_taxonomy_2026_09.sql a deja
-- tourne en prod (verifie le 2026-09-13 via le catalogue live -- la
-- categorie "OBC (On-Board Charger)" ne contient plus que les 2 vrais
-- chargeurs, Brusa Elektronik et Delta Electronics). Ce script-ci est
-- donc un pur renommage cosmetique, sans risque de melange de donnees.
--
-- A EXECUTER AVANT de deployer le changement correspondant cote
-- frontend (js/pages/catalogue.js, ligne du groupe "Battery & stockage
-- d'energie" ; et les liens catalogue.html?cat=... des pages
-- pages/obc-chargeur-embarque.html et en/on-board-chargers.html) --
-- tant que ce script n'a pas tourne, ces pages doivent continuer a
-- filtrer sur la valeur "OBC (On-Board Charger)", sous peine de ne
-- plus afficher aucun produit.
--
-- Idempotent (UPDATE ... WHERE category = ..., sans effet si deja
-- applique).
-- ============================================================

UPDATE products SET category = 'Chargeur embarqué'
WHERE category = 'OBC (On-Board Charger)';

-- ------------------------------------------------------------
-- Verification rapide apres execution :
-- select category, count(*) from products where category in
--   ('Chargeur embarqué', 'OBC (On-Board Charger)') group by category;
-- -- attendu : 'OBC (On-Board Charger)' = 0 ligne, 'Chargeur embarqué' = le total precedent
-- ============================================================
