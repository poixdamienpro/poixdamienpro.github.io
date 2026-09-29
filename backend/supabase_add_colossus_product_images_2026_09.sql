-- ============================================================
-- BUY-INNER — Ajoute les photos produit officielles Colossus Compute.
-- Images téléchargées depuis colossuscompute.com/products/* et
-- réhébergées dans le bucket Supabase "product-images" (déjà en
-- place, voir supabase_product_images.sql).
--
-- Sur les 12 produits Colossus, seuls 5 ont une vraie photo publiée
-- par le fabricant (Falcon, Cygnus, Draco, Eridanus, Razorback) —
-- les 7 autres (Vulture, Yellowjacket, Wasp, Fornax, Spirit, Pelican,
-- Puma) n'affichent qu'un dégradé de marque générique sur leur propre
-- page produit, donc pas de vraie photo à reprendre pour l'instant.
--
-- À exécuter dans Supabase : SQL Editor → New query → Run
-- Idempotent (met juste à jour image_url, rejouable sans risque).
-- ============================================================

UPDATE products SET image_url = 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/colossus-compute/falcon-board.png'
WHERE name = 'Falcon' AND company_id = (SELECT id FROM companies WHERE name = 'Colossus Compute');

UPDATE products SET image_url = 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/colossus-compute/cygnus-board.png'
WHERE name = 'Cygnus' AND company_id = (SELECT id FROM companies WHERE name = 'Colossus Compute');

UPDATE products SET image_url = 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/colossus-compute/draco-board.png'
WHERE name = 'Draco' AND company_id = (SELECT id FROM companies WHERE name = 'Colossus Compute');

UPDATE products SET image_url = 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/colossus-compute/eridanus-board.png'
WHERE name = 'Eridanus' AND company_id = (SELECT id FROM companies WHERE name = 'Colossus Compute');

UPDATE products SET image_url = 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/colossus-compute/razorback-board.png'
WHERE name = 'Razorback' AND company_id = (SELECT id FROM companies WHERE name = 'Colossus Compute');
