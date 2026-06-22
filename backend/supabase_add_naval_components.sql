-- ============================================================
-- BUY-INEER -- Naval : equipements composants (Exail / iXblue)
-- Composants integrables (AHRS/INS) pour ROV/AUV, verifie sur exail.com
-- Idempotent
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Exail', '🇫🇷 France', 'Saint-Germain-en-Laye', 'Naval', 'https://www.exail.com', '⚓',
  'Concepteur et fabricant français de systèmes de navigation inertielle (FOG), capteurs et équipements pour applications subsea, marines et de défense. Plus de 3000 systèmes de navigation subsea en service dans le monde.',
  True, True, '1500+', '2022', 'contact@exail.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Exail');

-- Octans Nano
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Octans Nano' AND c.name = 'Exail') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Octans Nano', 'Navigation inertielle', 'Naval', 'AHRS (Attitude Heading and Reference System) à technologie FOG de la gamme Exail pour ROV et petits véhicules sous-marins, conçu pour s''intégrer comme composant de navigation au sein de systèmes plus larges.', 'Sur devis', '⚓'
  FROM companies c WHERE c.name = 'Exail' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision de cap', '0.5°', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision roulis/tangage', '0.1°', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Poids dans l''eau', '5.5 kg', 3, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Profondeur max', '4 000 m', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Technologie', 'Gyroscope à fibre optique (FOG)', 5, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision de navigation', 70, '#1B4965');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 90, '#1B4965');
END $$;

-- Rovins Nano
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Rovins Nano' AND c.name = 'Exail') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Rovins Nano', 'Navigation inertielle', 'Naval', 'INS (Inertial Navigation System) compact de la gamme Exail destiné à l''intégration dans des ROV et AUV de petite taille nécessitant une navigation de qualité compacte.', 'Sur devis', '⚓'
  FROM companies c WHERE c.name = 'Exail' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision de cap', '0.1°', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision DVL-aidée (%TD CEP50)', '0.04%', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Poids dans l''eau', '1.6 kg', 3, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Technologie', 'Gyroscope à fibre optique (FOG)', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision de navigation', 80, '#1B4965');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 95, '#1B4965');
END $$;

-- Phins Compact C7
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Phins Compact C7' AND c.name = 'Exail') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Phins Compact C7', 'Navigation inertielle', 'Naval', 'INS compact de qualité survey de la gamme Exail, conçu pour être intégré comme module de navigation de haute précision au sein d''AUV.', 'Sur devis', '⚓'
  FROM companies c WHERE c.name = 'Exail' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision de cap', '0.01°', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision roulis/tangage', '0.01°', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Poids dans l''eau', '3.5 kg', 3, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Technologie', 'Gyroscope à fibre optique (FOG)', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision de navigation', 97, '#1B4965');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 85, '#1B4965');
END $$;

-- Phins Subsea
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Phins Subsea' AND c.name = 'Exail') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Phins Subsea', 'Navigation inertielle', 'Naval', 'INS haute performance de la gamme Exail pour navigation de qualité survey en eaux profondes, conçu pour intégration dans des systèmes ROV/AUV deep-water.', 'Sur devis', '⚓'
  FROM companies c WHERE c.name = 'Exail' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision de cap', '0.01°', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision roulis/tangage', '0.01°', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Profondeur max', '6 000 m', 3, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Technologie', 'Gyroscope à fibre optique (FOG)', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision de navigation', 97, '#1B4965');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Profondeur opérationnelle', 95, '#1B4965');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'Navigation inertielle' FROM companies WHERE name = 'Exail' LIMIT 1 ON CONFLICT DO NOTHING;

-- ============================================================
-- Saab Seaeye (Royaume-Uni) — verifie sur saabseaeye.com
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Saab Seaeye', '🇬🇧 Royaume-Uni', 'Fareham', 'Naval', 'https://www.saabseaeye.com', '⚓',
  'Leader mondial de la robotique sous-marine électrique, concepteur de véhicules ROV et de composants électriques (manipulateurs, propulseurs) destinés à s''intégrer dans des systèmes sous-marins complexes.',
  TRUE, TRUE, '250+', '1987', 'contact@saabseaeye.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Saab Seaeye');

-- Seaeye eM1-7
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Seaeye eM1-7' AND c.name = 'Saab Seaeye') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Seaeye eM1-7', 'Manipulateurs sous-marins', 'Naval', 'Manipulateur électrique sept fonctions destiné à être intégré sur des ROV de classe travail. Joints électriques modulaires permettant un contrôle d''arme précis, planification de trajectoire et diagnostics intégrés.', 'Sur devis', '⚓'
  FROM companies c WHERE c.name = 'Saab Seaeye' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Dexterité', '7 fonctions (6 degrés de liberté + pince)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Portée maximale', '2 030 mm', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Capacité de levage (extension max)', '122 kg', 3, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Capacité de levage (extension min)', '454 kg', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Couple au poignet', '330 Nm', 5, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Poids dans l''eau', '84 kg', 6, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Profondeur max', '4 000 m', 7, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension d''entrée', '500-800 VDC (option 110 VAC)', 8, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision de positionnement', 92, '#1B4965');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité (vs hydraulique)', 90, '#1B4965');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Système entièrement électrique');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'Manipulateurs sous-marins' FROM companies WHERE name = 'Saab Seaeye' LIMIT 1 ON CONFLICT DO NOTHING;

-- ============================================================
-- MacArtney (Danemark) — verifie sur macartney.com
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'MacArtney', '🇩🇰 Danemark', 'Esbjerg', 'Naval', 'https://www.macartney.com', '⚓',
  'Fabricant danois de connectivité sous-marine (connecteurs et câbles SubConn, TrustLink) et de systèmes pour l''instrumentation océanographique, intégrés dans des ROV, AUV et capteurs subsea du monde entier.',
  TRUE, TRUE, '300+', '1965', 'contact@macartney.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'MacArtney');

-- SubConn Circular - 6, 8 et 10 contacts
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'SubConn Circular — 6, 8 et 10 contacts' AND c.name = 'MacArtney') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'SubConn Circular — 6, 8 et 10 contacts', 'Connecteurs sous-marins', 'Naval', 'Connecteur sous-marin de la gamme SubConn Circular, à 6, 8 ou 10 contacts, conçu pour l''intégration électrique entre composants de systèmes ROV, AUV et instrumentation océanographique en environnement marin.', 'Sur devis', '🔌'
  FROM companies c WHERE c.name = 'MacArtney' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Nombre de contacts', '6, 8 ou 10', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Connecteur circulaire wet-mate', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Usage', 'Intégration ROV, AUV, capteurs subsea', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Résistance environnement marin', 95, '#1B4965');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Gamme SubConn (standard de référence subsea)');
END $$;

-- SubConn Power Battery - 2, 3 et 4 contacts
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'SubConn Power Battery — 2, 3 et 4 contacts' AND c.name = 'MacArtney') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'SubConn Power Battery — 2, 3 et 4 contacts', 'Connecteurs sous-marins', 'Naval', 'Connecteur sous-marin de la gamme SubConn Power dédié à la liaison batterie, à 2, 3 ou 4 contacts, destiné à l''intégration des blocs d''alimentation au sein de véhicules sous-marins.', 'Sur devis', '🔌'
  FROM companies c WHERE c.name = 'MacArtney' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Nombre de contacts', '2, 3 ou 4', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Connecteur de puissance wet-mate', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Usage', 'Liaison batterie sur véhicules sous-marins', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Résistance environnement marin', 95, '#1B4965');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Gamme SubConn (standard de référence subsea)');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'Connecteurs sous-marins' FROM companies WHERE name = 'MacArtney' LIMIT 1 ON CONFLICT DO NOTHING;