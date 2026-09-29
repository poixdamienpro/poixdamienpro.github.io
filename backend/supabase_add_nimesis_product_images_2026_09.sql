-- ============================================================
-- BUY-INNER — Ajoute les photos produit officielles Nimesis Space.
-- Images téléchargées depuis nimesis.com/actionneurs/* et réhébergées
-- dans le bucket Supabase "product-images". Les 9 produits ont tous
-- une vraie photo dédiée (contrairement à Colossus où 7/12 n'en ont pas).
--
-- À exécuter dans Supabase : SQL Editor → New query → Run
-- Prérequis : avoir déjà exécuté supabase_add_colossus_nimesis_anywaves_powell_2026_09.sql
-- Idempotent.
-- ============================================================

UPDATE products SET image_url = 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/nimesis-space/triggy.png'
WHERE name = 'Triggy' AND company_id = (SELECT id FROM companies WHERE name = 'Nimesis Space');

UPDATE products SET image_url = 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/nimesis-space/gripper.png'
WHERE name = 'Gripper' AND company_id = (SELECT id FROM companies WHERE name = 'Nimesis Space');

UPDATE products SET image_url = 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/nimesis-space/harper.png'
WHERE name = 'Harper' AND company_id = (SELECT id FROM companies WHERE name = 'Nimesis Space');

UPDATE products SET image_url = 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/nimesis-space/jack.png'
WHERE name = 'Jack' AND company_id = (SELECT id FROM companies WHERE name = 'Nimesis Space');

UPDATE products SET image_url = 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/nimesis-space/lara.png'
WHERE name = 'Lara' AND company_id = (SELECT id FROM companies WHERE name = 'Nimesis Space');

UPDATE products SET image_url = 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/nimesis-space/satlatch.png'
WHERE name = 'SATLATCH' AND company_id = (SELECT id FROM companies WHERE name = 'Nimesis Space');

UPDATE products SET image_url = 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/nimesis-space/hector.jpg'
WHERE name = 'Hector' AND company_id = (SELECT id FROM companies WHERE name = 'Nimesis Space');

UPDATE products SET image_url = 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/nimesis-space/stepper.png'
WHERE name = 'Stepper' AND company_id = (SELECT id FROM companies WHERE name = 'Nimesis Space');

UPDATE products SET image_url = 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/nimesis-space/murphy.png'
WHERE name = 'Murphy' AND company_id = (SELECT id FROM companies WHERE name = 'Nimesis Space');
