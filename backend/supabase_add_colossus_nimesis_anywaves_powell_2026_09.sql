-- ============================================================
-- BUY-INNER — Ajoute 4 entreprises rencontrées par l'utilisateur,
-- avec la gamme complète de leurs produits (pas juste un produit
-- vitrine) :
--   1. Colossus Compute (Oakland, USA)   — 12 produits (calculateurs
--      de bord, cartes d'extension, stockage, réseau spatial durci)
--   2. Nimesis Space (Mécleuves, France) — 9 produits (actionneurs
--      & mécanismes SMA : verrouillage, déploiement, désorbitation)
--   3. Anywaves (Toulouse, France)       — 24 produits (catalogue réel
--      anywaves.com/our-space-products/ : 18 antennes, 3 électroniques
--      charge utile VILSA/LNB, 3 bancs de test sol), photos officielles
--      incluses directement (image_url)
--   4. Powell Electronics (Swedesboro, USA / présence Europe) —
--      distributeur multi-marques (pas de gamme "maison" propre :
--      3 grandes familles de produits distribués, pas des SKU
--      individuels — voir note dans la section 4)
-- Vérifié sur les sites officiels (colossuscompute.com/products,
-- nimesis.com/products, anywaves.com/products ; powell.com bloqué
-- au fetch automatisé mais activité confirmée via sources tierces
-- recoupées). Toutes les specs numériques ci-dessous sont reprises
-- telles quelles des pages produit officielles, pas inventées.
-- Idempotent — remplace/complète le fichier précédent du même nom.
-- ============================================================

-- 1. COLOSSUS COMPUTE ------------------------------------------------
INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Colossus Compute', '🇺🇸 États-Unis', 'Oakland, Californie', 'Spatial', 'https://colossuscompute.com', '💻',
  'Fabricant américain de systèmes de calcul, stockage et réseau durcis pour le spatial (LEO, MEO, GEO, lunaire et au-delà). Architecture tolérante aux radiations : circuits durcis, mémoire à correction d''erreur (ECC), CPU redondants en lockstep, watchdogs et mécanismes de récupération intégrés — pensée pour le traitement embarqué avancé, y compris l''IA à bord.',
  TRUE, FALSE, NULL, NULL, 'rob@colossuscompute.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Colossus Compute');

-- Nettoie l'éventuel produit vitrine unique inséré par une version précédente de ce script
DELETE FROM products WHERE name = 'Falcon — calculateur de bord durci spatial'
  AND company_id = (SELECT id FROM companies WHERE name = 'Colossus Compute');

WITH new_products AS (
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon, datasheet_url)
  SELECT c.id, x.name, x.category, 'Spatial', x.description, 'Sur devis', x.icon, 'https://colossuscompute.com/products'
  FROM companies c, (VALUES
    ('Falcon',      'Calculateurs embarqués Edge IA', 'Calculateur de bord durci spatial à base de puce NVIDIA Orin AGX, pour traitement edge IA embarqué.', '💻'),
    ('Vulture',     'Calculateurs embarqués Edge IA', 'Calculateur de bord haute performance à base de puce NVIDIA Thor AGX, pour charge de calcul IA intensive à bord.', '💻'),
    ('Yellowjacket','Calculateurs embarqués Edge IA', 'Calculateur de bord à base de puce AMD Versal, orienté traitement edge IA embarqué.', '💻'),
    ('Wasp',        'Calculateurs embarqués Edge IA', 'Calculateur de bord haute densité à base de puce AMD Versal, pour charge de calcul IA intensive à bord.', '💻'),
    ('Cygnus',      'Calculateurs embarqués', 'Carte d''extension d''interconnexion (SERDES et LVDS) pour les calculateurs de la gamme Colossus.', '🔌'),
    ('Draco',       'Calculateurs embarqués', 'Carte d''extension PCIe et MIPI pour les calculateurs de la gamme Colossus.', '🔌'),
    ('Eridanus',    'Calculateurs embarqués', 'Carte d''extension Ethernet 1G et distribution de puissance pour les calculateurs de la gamme Colossus.', '🔌'),
    ('Fornax',      'Calculateurs embarqués', 'Carte d''extension Ethernet 10G pour les calculateurs de la gamme Colossus.', '🔌'),
    ('Spirit',      'Mémoires', 'Module de stockage embarqué 8 emplacements SSD, RAID ajustable, pour environnement spatial.', '💾'),
    ('Pelican',     'Mémoires', 'Contrôleur mémoire NAND durci pour applications spatiales.', '💾'),
    ('Razorback',   'Routers', 'Commutateur Ethernet 1G durci spatial, 8 ports.', '🌐'),
    ('Puma',        'Routers', 'Commutateur Ethernet 10G ou optique durci spatial, 10 ports.', '🌐')
  ) AS x(name, category, description, icon)
  WHERE c.name = 'Colossus Compute'
    AND NOT EXISTS (
      SELECT 1 FROM products p2 JOIN companies c2 ON c2.id = p2.company_id
      WHERE p2.name = x.name AND c2.name = 'Colossus Compute'
    )
  RETURNING id, name
)
INSERT INTO product_specs (product_id, label, value, sort_order, is_premium)
SELECT np.id, s.label, s.value, s.sort_order, s.is_premium
FROM new_products np
JOIN (VALUES
  ('Falcon',       'Puce', 'NVIDIA Orin AGX', 1, FALSE),
  ('Falcon',       'Performance IA', '248 TOPS', 2, FALSE),
  ('Vulture',      'Puce', 'NVIDIA Thor AGX', 1, FALSE),
  ('Vulture',      'Performance IA', '2070 TFLOPS', 2, FALSE),
  ('Yellowjacket', 'Puce', 'AMD Versal', 1, FALSE),
  ('Yellowjacket', 'Performance IA', '60 TOPS', 2, FALSE),
  ('Wasp',         'Puce', 'AMD Versal', 1, FALSE),
  ('Wasp',         'Performance IA', '369 TOPS', 2, FALSE),
  ('Cygnus',       'Interconnexion', '+12 SERDES / +36 LVDS', 1, FALSE),
  ('Draco',        'Interconnexion', '+6 PCIe / +1 MIPI', 1, FALSE),
  ('Eridanus',     'Interconnexion', '+8 Ethernet 1G / +9 alimentation', 1, FALSE),
  ('Fornax',       'Interconnexion', '+2 Ethernet 10G', 1, FALSE),
  ('Spirit',       'Capacité', '8x emplacements SSD, RAID ajustable', 1, FALSE),
  ('Pelican',      'Fonction', 'Contrôleur NAND', 1, FALSE),
  ('Razorback',    'Ports', 'Ethernet 1G, 8 ports', 1, FALSE),
  ('Puma',         'Ports', 'Ethernet 10G ou optique, 10 ports', 1, FALSE)
) AS s(name, label, value, sort_order, is_premium) ON s.name = np.name;

INSERT INTO company_product_categories (company_id, category)
SELECT id, cat FROM companies, unnest(ARRAY['Calculateurs embarqués Edge IA','Calculateurs embarqués','Mémoires','Routers']) AS cat
WHERE name = 'Colossus Compute'
ON CONFLICT DO NOTHING;


-- 2. NIMESIS SPACE ----------------------------------------------------
INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Nimesis Space', '🇫🇷 France', 'Mécleuves', 'Spatial', 'https://www.nimesis.com', '⚙️',
  'Concepteur français d''actionneurs et mécanismes intelligents pour le spatial, basés sur sa technologie propriétaire d''alliage à mémoire de forme (SMA). Trois familles : verrouillage/déverrouillage, déploiement, et désorbitation — du TRL 3 au TRL 9. Références clients : Airbus, CNES, JAXA, DLR. Accompagnement en ingénierie sur-mesure, du concept à la production.',
  TRUE, FALSE, 17, NULL, 'f.willig@nimesis.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Nimesis Space');

DELETE FROM products WHERE name = 'SATLATCH — mécanisme de déploiement SMA'
  AND company_id = (SELECT id FROM companies WHERE name = 'Nimesis Space');

WITH new_products AS (
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon, datasheet_url)
  SELECT c.id, x.name, 'Actionneurs & GNC', 'Spatial', x.description, 'Sur devis', '⚙️', 'https://www.nimesis.com/products'
  FROM companies c, (VALUES
    ('Triggy',  'Mécanisme de verrouillage/déverrouillage à SMA pour satellite, lanceur et rover.'),
    ('Gripper', 'Mécanisme de préhension/verrouillage à SMA pour satellite et lanceur.'),
    ('Harper',  'Mécanisme de verrouillage/déverrouillage à SMA pour lanceur.'),
    ('Jack',    'Mécanisme de verrouillage/déverrouillage à SMA pour satellite et rover.'),
    ('Lara',    'Mécanisme de verrouillage/déverrouillage à SMA pour lanceur.'),
    ('SATLATCH','Mécanisme de déploiement à SMA, sans pyrotechnie, pour satellite et rover.'),
    ('Hector',  'Mécanisme de déploiement à SMA pour satellite et rover.'),
    ('Stepper', 'Mécanisme de déploiement à SMA pour satellite.'),
    ('Murphy',  'Mécanisme de désorbitation/décommissionnement à SMA pour satellite et lanceur.')
  ) AS x(name, description)
  WHERE c.name = 'Nimesis Space'
    AND NOT EXISTS (
      SELECT 1 FROM products p2 JOIN companies c2 ON c2.id = p2.company_id
      WHERE p2.name = x.name AND c2.name = 'Nimesis Space'
    )
  RETURNING id, name
)
INSERT INTO product_specs (product_id, label, value, sort_order, is_premium)
SELECT np.id, s.label, s.value, s.sort_order, s.is_premium
FROM new_products np
JOIN (VALUES
  ('Triggy',   'Maturité', 'TRL 9', 1, FALSE), ('Triggy',   'Applications', 'Satellite, lanceur, rover', 2, FALSE),
  ('Gripper',  'Maturité', 'TRL 9', 1, FALSE), ('Gripper',  'Applications', 'Satellite, lanceur', 2, FALSE),
  ('Harper',   'Maturité', 'TRL 5', 1, FALSE), ('Harper',   'Applications', 'Lanceur', 2, FALSE),
  ('Jack',     'Maturité', 'TRL 3', 1, FALSE), ('Jack',     'Applications', 'Satellite, rover', 2, FALSE),
  ('Lara',     'Maturité', 'TRL 4', 1, FALSE), ('Lara',     'Applications', 'Lanceur', 2, FALSE),
  ('SATLATCH', 'Maturité', 'TRL 7', 1, FALSE), ('SATLATCH', 'Applications', 'Satellite, rover', 2, FALSE),
  ('Hector',   'Maturité', 'TRL 6', 1, FALSE), ('Hector',   'Applications', 'Satellite, rover', 2, FALSE),
  ('Stepper',  'Maturité', 'TRL 3', 1, FALSE), ('Stepper',  'Applications', 'Satellite', 2, FALSE),
  ('Murphy',   'Maturité', 'TRL 6', 1, FALSE), ('Murphy',   'Applications', 'Satellite, lanceur', 2, FALSE)
) AS s(name, label, value, sort_order, is_premium) ON s.name = np.name;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'Actionneurs & GNC' FROM companies WHERE name = 'Nimesis Space' LIMIT 1 ON CONFLICT DO NOTHING;


-- 3. ANYWAVES -----------------------------------------------------------
INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Anywaves', '🇫🇷 France', 'Toulouse', 'Spatial', 'https://anywaves.com', '📡',
  'Essaimage du CNES basé à Toulouse, concepteur et fabricant d''antennes et d''électronique RF pour le spatial : antennes TT&C, liaison de données, navigation, lanceur et charge utile, radios logicielles (gamme VILSA) et électronique RF bas bruit. Plus de 2000 produits RF livrés sur 200+ missions. Certifié EN 9100, produits ITAR-free.',
  TRUE, FALSE, 60, 2017, 'p.vedrenne@anywaves.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Anywaves');

-- Nettoie les fiches approximatives d'une version precedente de ce script
-- (8 produits regroupes a la louche) : le vrai catalogue anywaves.com/our-space-products/
-- compte 24 references distinctes, reprises ci-dessous avec leurs photos officielles.
DELETE FROM product_specs WHERE product_id IN (
  SELECT p.id FROM products p JOIN companies c ON c.id = p.company_id WHERE c.name = 'Anywaves'
  AND p.name IN ('Antenne TT&C bande S', 'Antenne compacte bande X', 'Antenne compacte bande X bi-polarisation',
    'Antenne bande X à faisceau large', 'Antenne bande X haut gain', 'Antenne GNSS multi-bandes',
    'Antennes large bande compactes', 'Électronique de charge utile RF', 'Banc de test bande X (Test Hat)',
    'Antennes spatiales TT&C et liaison de données')
);
DELETE FROM product_certs WHERE product_id IN (
  SELECT p.id FROM products p JOIN companies c ON c.id = p.company_id WHERE c.name = 'Anywaves'
  AND p.name IN ('Antenne TT&C bande S', 'Antenne compacte bande X', 'Antenne compacte bande X bi-polarisation',
    'Antenne bande X à faisceau large', 'Antenne bande X haut gain', 'Antenne GNSS multi-bandes',
    'Antennes large bande compactes', 'Électronique de charge utile RF', 'Banc de test bande X (Test Hat)',
    'Antennes spatiales TT&C et liaison de données')
);
DELETE FROM products WHERE company_id = (SELECT id FROM companies WHERE name = 'Anywaves')
  AND name IN ('Antenne TT&C bande S', 'Antenne compacte bande X', 'Antenne compacte bande X bi-polarisation',
    'Antenne bande X à faisceau large', 'Antenne bande X haut gain', 'Antenne GNSS multi-bandes',
    'Antennes large bande compactes', 'Électronique de charge utile RF', 'Banc de test bande X (Test Hat)',
    'Antennes spatiales TT&C et liaison de données');

WITH new_products AS (
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon, datasheet_url, image_url)
  SELECT c.id, x.name, 'Communication & RF', 'Spatial', x.description, 'Sur devis', x.icon, x.href, x.img
  FROM companies c, (VALUES
    ('Antenne TT&C bande S compacte', 'Antenne compacte de télémesure, poursuite et télécommande (TT&C) en bande S.', '📡',
      'https://anywaves.com/products/compact-s-band-ttc-antenna/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/compact-s-band-ttc.png'),
    ('Antenne TT&C bande S', 'Antenne de télémesure, poursuite et télécommande (TT&C) en bande S.', '📡',
      'https://anywaves.com/products/s-band-ttc-antenna/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/s-band-ttc.png'),
    ('Antenne TT&C bande Ka', 'Antenne de télémesure, poursuite et télécommande (TT&C) en bande Ka.', '📡',
      'https://anywaves.com/products/choke-ring-ttc-ka-band-antenna/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/ka-band-ttc.png'),
    ('Antenne compacte bande X', 'Antenne compacte flight-proven (TRL 9) pour la télémesure charge utile depuis un satellite LEO, 7.9–8.5 GHz, gain 15.5 dBi, encombrement 100×100 mm.', '📡',
      'https://anywaves.com/products/compact-x-band-payload-telemetry-antenna/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/compact-x-band.png'),
    ('Antenne compacte bande X bi-polarisation', 'Variante bi-polarisation (LHCP et RHCP simultanées sur connecteurs séparés) de l''antenne compacte bande X.', '📡',
      'https://anywaves.com/products/compact-x-band-dual-circularly-polarized-antenna/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/compact-x-band-dual-pol.png'),
    ('Antenne bande X haut gain', 'Antenne bande X haut gain pour liaison de données à haut débit.', '📡',
      'https://anywaves.com/products/high-gain-x-band-antenna/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/high-gain-x-band.png'),
    ('Antenne bande X à faisceau large', 'Antenne bande X à faisceau large pour liaison de données.', '📡',
      'https://anywaves.com/products/wide-beam-x-band-payload-telemetry-antenna/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/wide-beam-x-band.png'),
    ('Antenne GNSS multi-bandes', 'Antenne de navigation couvrant l''ensemble des bandes GNSS.', '📡',
      'https://anywaves.com/products/gnss-all-bands-antenna/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/gnss-all-bands.png'),
    ('Antenne GNSS multi-bandes avec LNA intégré', 'Antenne GNSS multi-bandes avec carte amplificateur faible bruit (LNA) intégrée.', '📡',
      'https://anywaves.com/products/gnss-all-bands-antenna-with-lna-integrated-card/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/gnss-all-bands-lna.png'),
    ('Antenne GNSS bandes L1/E1', 'Antenne de navigation dédiée aux bandes GNSS L1/E1.', '📡',
      'https://anywaves.com/products/gnss-l1-e1-bands-antenna/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/gnss-l1-e1.png'),
    ('Antenne lanceur bande S', 'Antenne de télémesure bande S pour lanceur.', '📡',
      'https://anywaves.com/products/s-band-launcher-antenna/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/s-band-launcher.png'),
    ('Antenne lanceur GNSS multi-bandes', 'Antenne de navigation multi-bandes GNSS pour lanceur.', '📡',
      'https://anywaves.com/products/gnss-all-bands-launcher-antenna/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/gnss-launcher.png'),
    ('Antenne réseau à guide d''ondes à fentes', 'Antenne réseau à guide d''ondes à fentes pour applications charge utile.', '📡',
      'https://anywaves.com/products/slotted-waveguide-array-antenna/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/slotted-waveguide.png'),
    ('Antenne à réseau réflecteur', 'Antenne à réseau réflecteur pour applications charge utile haut gain.', '📡',
      'https://anywaves.com/products/reflectarray-antenna/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/reflectarray.png'),
    ('Antenne réseau à rayonnement direct', 'Antenne réseau à rayonnement direct pour applications charge utile.', '📡',
      'https://anywaves.com/products/direct-radiating-array-antenna/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/direct-radiating.png'),
    ('Antennes compactes large bande', 'Antennes compactes large bande pour applications charge utile.', '📡',
      'https://anywaves.com/products/compact-wideband-antennas/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/compact-wideband.png'),
    ('Antenne cornet à crêtes croisées', 'Antenne cornet à quatre crêtes (quad-ridged horn), large bande.', '📡',
      'https://anywaves.com/products/quad-ridged-horn-antenna/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/quad-ridged-horn.png'),
    ('Antenne hélice quadrifilaire', 'Antenne hélice quadrifilaire.', '📡',
      'https://anywaves.com/products/quadrifilar-helix-antennas/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/quadrifilar-helix.png'),
    ('VILSA — Radio logicielle (SDR)', 'Radio logicielle (SDR) de la gamme VILSA pour traitement de signal embarqué.', '📶',
      'https://anywaves.com/products/vilsa-software-defined-radio/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/vilsa-sdr.png'),
    ('VILSA XDL — Émetteur liaison descendante bande X', 'Émetteur de liaison descendante bande X de la gamme VILSA.', '📶',
      'https://anywaves.com/products/vilsa-xdl-x-band-downlink-transmitter/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/vilsa-xdl.png'),
    ('Convertisseur bas bruit (LNB)', 'Convertisseur de fréquence bas bruit (LNB) pour réception RF.', '📶',
      'https://anywaves.com/products/low-noise-block-downconverter/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/lnb.png'),
    ('Banc de test bande GNSS multi-bandes', 'Équipement de test sol pour la validation RF fonctionnelle des antennes GNSS multi-bandes, une fois intégrées sur le satellite.', '🧪',
      'https://anywaves.com/products/test-cap-for-gnss-all-bands-antennas/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/test-hat-gnss.png'),
    ('Banc de test bande S TT&C', 'Équipement de test sol pour la validation RF fonctionnelle des antennes TT&C bande S, une fois intégrées sur le satellite.', '🧪',
      'https://anywaves.com/products/test-cap-for-s-band-ttc-antennas/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/test-hat-s-band.png'),
    ('Banc de test bande X', 'Équipement de test sol pour la validation RF fonctionnelle des antennes bande X, une fois intégrées sur le satellite.', '🧪',
      'https://anywaves.com/products/test-cap-for-x-band-antennas/', 'https://www.buy-inner.com/api/storage/v1/object/public/product-images/submissions/anywaves/test-hat-x-band.png')
  ) AS x(name, description, icon, href, img)
  WHERE c.name = 'Anywaves'
    AND NOT EXISTS (
      SELECT 1 FROM products p2 JOIN companies c2 ON c2.id = p2.company_id
      WHERE p2.name = x.name AND c2.name = 'Anywaves'
    )
  RETURNING id, name
),
specs_ins AS (
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium)
  SELECT np.id, s.label, s.value, s.sort_order, s.is_premium
  FROM new_products np
  JOIN (VALUES
    ('Antenne compacte bande X', 'Fréquence', '7.9–8.5 GHz', 1, FALSE),
    ('Antenne compacte bande X', 'Gain', '15.5 dBi', 2, FALSE),
    ('Antenne compacte bande X', 'Encombrement', '100×100 mm', 3, FALSE),
    ('Antenne compacte bande X', 'Maturité', 'TRL 9, flight-proven', 4, TRUE),
    ('Antenne compacte bande X bi-polarisation', 'Polarisation', 'LHCP et RHCP simultanées, connecteurs séparés', 1, FALSE)
  ) AS s(name, label, value, sort_order, is_premium) ON s.name = np.name
  RETURNING 1
)
INSERT INTO product_certs (product_id, cert_name)
SELECT np.id, cert
FROM new_products np, unnest(ARRAY['EN 9100', 'ITAR-free']) AS cert
WHERE np.name = 'Antenne compacte bande X';

INSERT INTO company_product_categories (company_id, category) SELECT id, 'Communication & RF' FROM companies WHERE name = 'Anywaves' LIMIT 1 ON CONFLICT DO NOTHING;


-- 4. POWELL ELECTRONICS ---------------------------------------------
-- Powell est un DISTRIBUTEUR/REVENDEUR multi-marques (TE Connectivity,
-- Amphenol, etc.), pas un fabricant avec une gamme "maison" -- classé
-- comme prestataire de service ("Distribution de composants", nouvelle
-- catégorie ajoutée à SERVICE_CATS dans js/pages/prestations.js et
-- js/pages/carte.js + CATALOGUE_EXCLUDED_CATS dans js/pages/catalogue.js),
-- donc absent du catalogue produit comme les autres prestataires.
INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Powell Electronics', '🇺🇸 États-Unis', 'Swedesboro, New Jersey', 'Aéronautique & Défense', 'https://www.powell.com', '🔌',
  'Distributeur à valeur ajoutée de composants électroniques haute fiabilité pour environnements sévères : connecteurs, interrupteurs, capteurs et produits électromécaniques multi-marques. Distributeur agréé et qualifié QPL sur plus de 50 spécifications militaires, certifié ISO. Fondé en 1946, plus de 200 collaborateurs, 11 sites aux USA et présence dans 6 pays européens. Sert l''aérospatial, la défense, le spatial, les télécoms, le transport et l''imagerie médicale.',
  TRUE, FALSE, 200, 1946, 'europe@powell.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Powell Electronics');

INSERT INTO company_industries (company_id, industry)
SELECT id, 'Spatial' FROM companies WHERE name = 'Powell Electronics' LIMIT 1
ON CONFLICT DO NOTHING;

DELETE FROM products WHERE name = 'Connecteurs & composants électromécaniques haute fiabilité'
  AND company_id = (SELECT id FROM companies WHERE name = 'Powell Electronics');

WITH new_products AS (
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon, datasheet_url)
  SELECT c.id, x.name, 'Distribution de composants', 'Aéronautique & Défense', x.description, 'Sur devis', x.icon, 'https://www.powell.com'
  FROM companies c, (VALUES
    ('Connecteurs haute fiabilité multi-marques', 'Distribution de connecteurs multi-marques qualifiés pour environnements sévères (aérospatial, défense, spatial).', '🔌'),
    ('Interrupteurs & relais électromécaniques',  'Distribution d''interrupteurs et relais électromécaniques qualifiés pour applications critiques.', '🔘'),
    ('Capteurs pour environnements sévères',      'Distribution de capteurs qualifiés pour environnements sévères (aérospatial, défense, spatial, industriel).', '📟')
  ) AS x(name, description, icon)
  WHERE c.name = 'Powell Electronics'
    AND NOT EXISTS (
      SELECT 1 FROM products p2 JOIN companies c2 ON c2.id = p2.company_id
      WHERE p2.name = x.name AND c2.name = 'Powell Electronics'
    )
  RETURNING id, name
)
INSERT INTO product_specs (product_id, label, value, sort_order, is_premium)
SELECT np.id, s.label, s.value, s.sort_order, s.is_premium
FROM new_products np
JOIN (VALUES
  ('Connecteurs haute fiabilité multi-marques', 'Qualification', 'QPL sur 50+ spécifications militaires, certifié ISO', 1, FALSE),
  ('Interrupteurs & relais électromécaniques',  'Qualification', 'QPL sur 50+ spécifications militaires, certifié ISO', 1, FALSE),
  ('Capteurs pour environnements sévères',      'Qualification', 'QPL sur 50+ spécifications militaires, certifié ISO', 1, FALSE)
) AS s(name, label, value, sort_order, is_premium) ON s.name = np.name;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'Distribution de composants' FROM companies WHERE name = 'Powell Electronics' LIMIT 1 ON CONFLICT DO NOTHING;
