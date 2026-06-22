-- ============================================================
-- BUY-INEER -- Hemeria et CILAS (fournisseurs francais du spatial)
-- Verifie directement sur hemeria-group.com et cilas.com
-- A executer dans Supabase : SQL Editor -> New query -> Run
-- Idempotent : peut etre relance sans creer de doublons.
-- ============================================================

-- ============ ENTREPRISES ============

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Hemeria', '🇫🇷 France', 'Toulouse', 'Spatial', 'https://www.hemeria-group.com', '🛰️', 'Equipementier et integrateur francais de nano/microsatellites, ballons stratospheriques et equipements satellite (structures, harnais, panneaux solaires).', TRUE, FALSE, '300+', '2019', 'contact@hemeria-group.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Hemeria');

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'CILAS', '🇫🇷 France', 'Orléans', 'Spatial', 'https://www.cilas.com', '🔬', 'Expert francais en lasers et optiques de precision pour applications spatiales, defense et scientifiques : amplificateurs optiques pour communication laser, revetements optiques.', TRUE, FALSE, '300+', '1969', 'contact@cilas.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'CILAS');

-- ============ PRODUITS ============

-- SPECTRA-L40 — Plateforme nanosatellite (Hemeria)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'SPECTRA-L40 — Plateforme nanosatellite' AND c.name = 'Hemeria') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'SPECTRA-L40 — Plateforme nanosatellite', 'Plateformes satellites', 'Spatial', 'Plateforme nanosatellite SPECTRA-L40 d''Hemeria, conçue pour les missions d''observation et de telecommunication en orbite basse.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Hemeria' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Format', 'Nanosatellite', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Application', 'Observation / télécommunication', 2, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Flight heritage', 88, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Modularité', 85, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- SPRINT-L60 — Plateforme microsatellite (Hemeria)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'SPRINT-L60 — Plateforme microsatellite' AND c.name = 'Hemeria') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'SPRINT-L60 — Plateforme microsatellite', 'Plateformes satellites', 'Spatial', 'Plateforme microsatellite SPRINT-L60 d''Hemeria, segment intermediaire entre nano et microsatellites pour des missions plus exigeantes en puissance et charge utile.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Hemeria' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Format', 'Microsatellite', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Application', 'Charge utile renforcée', 2, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Flight heritage', 87, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Capacité charge utile', 86, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- SPARTA-G70 — Plateforme microsatellite avancée (Hemeria)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'SPARTA-G70 — Plateforme microsatellite avancée' AND c.name = 'Hemeria') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'SPARTA-G70 — Plateforme microsatellite avancée', 'Plateformes satellites', 'Spatial', 'Plateforme microsatellite SPARTA-G70 d''Hemeria, la plus avancee de la gamme, pour les missions necessitant la plus grande capacite embarquee.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Hemeria' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Format', 'Microsatellite avancé', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Position gamme', 'Haut de gamme Hemeria', 2, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Flight heritage', 85, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Capacité charge utile', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- HPOA — Amplificateur optique haute puissance (CILAS)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'HPOA — Amplificateur optique haute puissance' AND c.name = 'CILAS') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'HPOA — Amplificateur optique haute puissance', 'Communication & RF', 'Spatial', 'Amplificateur a fibre optique haute puissance pour terminaux de communication laser spatiaux. Selectionne par Airbus Defence and Space pour les demonstrations en orbite TELEO et LASIN, embarque sur BADR-8 (GEO) et CO3D (LEO).', 'Sur devis', '🔬'
  FROM companies c WHERE c.name = 'CILAS' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Longueur d''onde', '1535–1565 nm (bande C)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance de sortie', 'Jusqu''à 5 W (11 W en développement)', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance d''entrée min.', '-13 dBm (50 µW)', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Modulations supportées', 'OOK, DPSK, NRZ, QPSK', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Référence en vol', 'BADR-8 (GEO), CO3D (LEO)', 5, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Puissance optique', 90, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité en vol', 92, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Hi-Rel');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- Revêtements optiques de protection (CILAS)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Revêtements optiques de protection' AND c.name = 'CILAS') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Revêtements optiques de protection', 'Capteurs & Instrumentation', 'Spatial', 'Revetements optiques protecteurs pour composants optiques spatiaux de grande dimension (jusqu''a 2m x 2m), technologie de pulverisation magnetron.', 'Sur devis', '🔬'
  FROM companies c WHERE c.name = 'CILAS' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Dimension max', 'Jusqu''à 2 m × 2 m', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Technologie', 'Pulvérisation magnétron', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Applications', 'Espace, astronomie, recherche', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Résistance environnementale', 93, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision optique', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ISO qualité');
END $$;

-- ============ CATÉGORIES PRODUITS (filtres annuaire) ============

INSERT INTO company_product_categories (company_id, category) SELECT id, 'Plateformes satellites' FROM companies WHERE name = 'Hemeria' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Communication & RF' FROM companies WHERE name = 'CILAS' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Capteurs & Instrumentation' FROM companies WHERE name = 'CILAS' LIMIT 1 ON CONFLICT DO NOTHING;