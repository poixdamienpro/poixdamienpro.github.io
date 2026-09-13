-- ============================================================
-- BUY-INNER — Corrige la confusion "OBC (Onboard Computer)" vs
-- "Calculateurs embarqués", révélée en creusant une remarque
-- utilisateur. Trois bugs distincts trouvés dans cette seule
-- catégorie mal nommée :
--
-- 1. 3 vrais calculateurs de bord dans "OBC (Onboard Computer)"
--    doivent rejoindre "Calculateurs embarqués" (42 produits déjà
--    dedans) — le doublon signalé par l'utilisateur.
-- 2. 2 chargeurs embarqués véhicule électrique (Delta Electronics,
--    Brusa) étaient rangés par erreur dans "Calculateurs embarqués"
--    à cause de la confusion OBC=Computer / OBC=Charger. La page
--    pages/obc-chargeur-embarque.html pointe déjà vers la catégorie
--    "OBC (On-Board Charger)" — qui n'avait donc AUCUN produit et
--    un bouton "Voir tous les produits" cassé (0 résultat).
-- 3. 3 produits de segment sol (station sol, contrôle de mission)
--    n'étaient ni des calculateurs ni des chargeurs — nouvelle
--    catégorie dédiée "Segment sol & opérations".
--
-- Idempotent (toutes les clauses sont re-jouables sans dupliquer).
-- ============================================================

-- ------------------------------------------------------------
-- 1. Fusion des vrais calculateurs de bord
-- ------------------------------------------------------------
UPDATE products SET category = 'Calculateurs embarqués'
WHERE id IN (
  '054ff5e1-a6f7-4d94-965c-42b5c2e7d009', -- Bright Ascension — Flightkit
  'd5eacf44-8ac3-43b0-a586-fd43fc3af736', -- EnduroSat — OBC CubeSat ARM Cortex-M7
  'f347709b-5f94-4266-8fe1-85f6a209555a'  -- KP Labs — Antelope
) AND category = 'OBC (Onboard Computer)';

-- ------------------------------------------------------------
-- 2. Correction des chargeurs embarqués mal catégorisés
-- ------------------------------------------------------------
UPDATE products SET category = 'OBC (On-Board Charger)'
WHERE id IN (
  'e3f3b186-7cf1-46d5-be64-fb941390f3d9', -- Delta Electronics — OBC 22 kW Bidirectionnel V2G
  'b3716c3b-4011-42ed-839b-4caafb9e78d3'  -- Brusa Elektronik — OBC NLG5 11kW
) AND category = 'Calculateurs embarqués';

-- ------------------------------------------------------------
-- 3. Nouvelle catégorie pour les produits de segment sol
-- ------------------------------------------------------------
UPDATE products SET category = 'Segment sol & opérations'
WHERE id IN (
  '9f67cd18-3d3f-4ea2-804f-b324b257e009', -- Groundcom — Antenne de station sol partagée
  'c96a9f3d-9090-44ff-9f82-d523b572ff25', -- PrimaLuceLab — Station sol robotisée
  '7a7bb457-ddf5-4408-82d1-c488b63bf443'  -- Spaceit — Contrôle de mission en tant que service
) AND category = 'OBC (Onboard Computer)';

-- ------------------------------------------------------------
-- 4. Nettoyage de la table de tags company_product_categories —
--    "OBC (Onboard Computer)" devient orpheline (plus aucun
--    produit ne l'utilise), on la retire et on ajoute les
--    nouveaux tags correspondants.
-- ------------------------------------------------------------
DELETE FROM company_product_categories WHERE category = 'OBC (Onboard Computer)';

INSERT INTO company_product_categories (company_id, category) VALUES
  ('4276f7e1-42be-464d-9578-ccde91d6e328', 'Calculateurs embarqués'), -- Bright Ascension
  ('c24f634a-7ea9-46ac-affb-3490eea38385', 'Calculateurs embarqués'), -- EnduroSat
  ('00d984e3-3f2c-45a6-9abe-72058743f64b', 'Calculateurs embarqués')  -- KP Labs
ON CONFLICT DO NOTHING;

INSERT INTO company_product_categories (company_id, category) VALUES
  ('f0aa8937-6522-45de-81c8-0021cb129a0e', 'OBC (On-Board Charger)'), -- Delta Electronics
  ('22b655ac-985b-4b25-a396-d3cc9b00e5e7', 'OBC (On-Board Charger)')  -- Brusa Elektronik
ON CONFLICT DO NOTHING;

INSERT INTO company_product_categories (company_id, category) VALUES
  ('77730838-54c1-474a-8e6c-f34619ec5b53', 'Segment sol & opérations'), -- Groundcom
  ('cda69ddd-b28f-4249-830f-48540e0f272f', 'Segment sol & opérations'), -- PrimaLuceLab
  ('2d013757-a0da-4200-83eb-80c7d6d4bf4a', 'Segment sol & opérations')  -- Spaceit
ON CONFLICT DO NOTHING;

-- ------------------------------------------------------------
-- Vérification rapide après exécution :
-- select category, count(*) from products where category in
--   ('Calculateurs embarqués','OBC (On-Board Charger)','Segment sol & opérations')
--   group by category;
-- -- attendu : Calculateurs embarqués = 45, OBC (On-Board Charger) = 2,
-- -- Segment sol & opérations = 3, et 'OBC (Onboard Computer)' plus présent du tout.
-- ============================================================
