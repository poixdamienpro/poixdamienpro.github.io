-- ============================================================
-- BUY-INEER — Ajout de fournisseurs Défense
-- 5 entreprises · 5 produits
-- À exécuter dans Supabase : SQL Editor → New query → Run
-- N'efface RIEN — ajoute uniquement de nouvelles lignes.
-- ============================================================

-- ============================================================
-- ENTREPRISES
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Thales', '🇫🇷 France', 'Courbevoie', 'Aéronautique & Défense', 'https://www.thalesgroup.com', '📡', 'Leader européen des systèmes radio et radar tactiques. Modules RF durcis pour plateformes terrestres, navales et spatiales.', TRUE, TRUE, '80 000+', '2000', 'contact@thalesgroup.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Thales');

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Cobham', '🇬🇧 Royaume-Uni', 'Wimborne', 'Aéronautique & Défense', 'https://www.cobham.com', '📶', 'Antennes et systèmes RF pour aéronefs, satellites et véhicules de défense. Forte présence SATCOM.', TRUE, FALSE, '10 000+', '1934', ''
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Cobham');

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'L3Harris Technologies', '🇺🇸 États-Unis', 'Melbourne, FL', 'Aéronautique & Défense', 'https://www.l3harris.com', '🛰️', 'Connecteurs et amplificateurs RF durcis pour radios tactiques et liaisons satellites militaires.', TRUE, TRUE, '50 000+', '2019', 'l3harris@l3harris.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'L3Harris Technologies');

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Rheinmetall', '🇩🇪 Allemagne', 'Düsseldorf', 'Aéronautique & Défense', 'https://www.rheinmetall.com', '⚙️', 'Actionneurs et servovannes haute robustesse pour véhicules blindés et systèmes d''armes.', TRUE, FALSE, '26 000+', '1889', ''
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Rheinmetall');

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Honeywell Aerospace', '🇺🇸 États-Unis', 'Phoenix, AZ', 'Aéronautique & Défense', 'https://aerospace.honeywell.com', '🧭', 'Centrales inertielles (IMU) et capteurs de navigation pour défense, aviation et spatial.', TRUE, TRUE, '20 000+', '1929', 'aerospace@honeywell.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Honeywell Aerospace');

-- ============================================================
-- TAGS & CATÉGORIES PAR ENTREPRISE
-- ============================================================

INSERT INTO company_tags (company_id, tag) SELECT id, 'RF durci' FROM companies WHERE name = 'Thales' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_tags (company_id, tag) SELECT id, 'MIL-STD-810' FROM companies WHERE name = 'Thales' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_tags (company_id, tag) SELECT id, 'Tactique' FROM companies WHERE name = 'Thales' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Communication & RF' FROM companies WHERE name = 'Thales' LIMIT 1 ON CONFLICT DO NOTHING;

INSERT INTO company_tags (company_id, tag) SELECT id, 'SATCOM' FROM companies WHERE name = 'Cobham' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_tags (company_id, tag) SELECT id, 'Antenne' FROM companies WHERE name = 'Cobham' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_tags (company_id, tag) SELECT id, 'Bande Ku' FROM companies WHERE name = 'Cobham' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Communication & RF' FROM companies WHERE name = 'Cobham' LIMIT 1 ON CONFLICT DO NOTHING;

INSERT INTO company_tags (company_id, tag) SELECT id, 'Connecteur durci' FROM companies WHERE name = 'L3Harris Technologies' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_tags (company_id, tag) SELECT id, 'Amplificateur RF' FROM companies WHERE name = 'L3Harris Technologies' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_tags (company_id, tag) SELECT id, 'Radio tactique' FROM companies WHERE name = 'L3Harris Technologies' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Communication & RF' FROM companies WHERE name = 'L3Harris Technologies' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Câblage & Connecteurs' FROM companies WHERE name = 'L3Harris Technologies' LIMIT 1 ON CONFLICT DO NOTHING;

INSERT INTO company_tags (company_id, tag) SELECT id, 'Servovanne' FROM companies WHERE name = 'Rheinmetall' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_tags (company_id, tag) SELECT id, 'Blindé' FROM companies WHERE name = 'Rheinmetall' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_tags (company_id, tag) SELECT id, 'Haute robustesse' FROM companies WHERE name = 'Rheinmetall' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Vannes & Actionneurs' FROM companies WHERE name = 'Rheinmetall' LIMIT 1 ON CONFLICT DO NOTHING;

INSERT INTO company_tags (company_id, tag) SELECT id, 'IMU' FROM companies WHERE name = 'Honeywell Aerospace' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_tags (company_id, tag) SELECT id, 'Navigation inertielle' FROM companies WHERE name = 'Honeywell Aerospace' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_tags (company_id, tag) SELECT id, 'Gyroscope' FROM companies WHERE name = 'Honeywell Aerospace' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Capteurs & Instrumentation' FROM companies WHERE name = 'Honeywell Aerospace' LIMIT 1 ON CONFLICT DO NOTHING;

-- ============================================================
-- PRODUITS
-- ============================================================

-- Module RF tactique (Thales)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Module émetteur-récepteur RF TRX-200' AND c.name = 'Thales') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Module émetteur-récepteur RF TRX-200', 'Communication & RF', 'Aéronautique & Défense', 'Transceiver RF durci multi-bandes pour liaisons tactiques et plateformes embarquées. Conçu pour environnements sévères.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'Thales' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande de fréquence', 'UHF / L / S', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance d''émission', '10 W crête', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Alimentation', '18–32 VDC', 3, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '1,8 kg', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Température', '-40 à +71 °C', 5, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Étanchéité', 'IP67', 6, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Chiffrement', 'AES-256', 7, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse environnementale', 92, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Portée', 80, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 65, '#D4500A');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-810G');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-461');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'DO-160G');
END $$;

-- Antenne SATCOM bande Ku (Cobham)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Antenne SATCOM Ku-Band SAT-450' AND c.name = 'Cobham') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Antenne SATCOM Ku-Band SAT-450', 'Communication & RF', 'Aéronautique & Défense', 'Antenne directionnelle bande Ku pour liaisons satellites embarquées sur véhicules et plateformes mobiles.', 'Sur devis', '📶'
  FROM companies c WHERE c.name = 'Cobham' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande de fréquence', 'Ku (12-18 GHz)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Gain', '38 dBi', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Diamètre', '45 cm', 3, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '6,2 kg', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Pointage', 'Automatique, motorisé 2 axes', 5, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Température', '-30 à +60 °C', 6, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Gain / compacité', 75, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse', 88, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision de pointage', 90, '#D4500A');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-810G');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'IP66');
END $$;

-- Connecteur RF durci (L3Harris)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Connecteur RF durci RFC-7' AND c.name = 'L3Harris Technologies') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Connecteur RF durci RFC-7', 'Câblage & Connecteurs', 'Aéronautique & Défense', 'Connecteur coaxial étanche pour liaisons RF haute fréquence sur radios tactiques et systèmes embarqués.', '~120 €', '🔌'
  FROM companies c WHERE c.name = 'L3Harris Technologies' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Impédance', '50 Ω', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fréquence max', '18 GHz', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cycles d''insertion', '> 5 000', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Étanchéité', 'IP68', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Verrouillage', 'Baïonnette quart de tour', 5, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durabilité', 90, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Étanchéité', 95, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-DTL-38999');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'IP68');
END $$;

-- Servovanne haute robustesse (Rheinmetall)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Servovanne hydraulique SV-900' AND c.name = 'Rheinmetall') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Servovanne hydraulique SV-900', 'Vannes & Actionneurs', 'Aéronautique & Défense', 'Servovanne hydraulique haute robustesse pour systèmes de stabilisation et d''orientation sur véhicules blindés.', 'Sur devis', '⚙️'
  FROM companies c WHERE c.name = 'Rheinmetall' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Pression de service', '0–350 bar', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Débit nominal', '40 L/min', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Temps de réponse', '< 15 ms', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '4,5 kg', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Vibrations', 'MIL-STD-810G Method 514', 5, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Réactivité', 85, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse', 93, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-810G');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'STANAG 4370');
END $$;

-- Centrale inertielle (Honeywell Aerospace)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Centrale inertielle IMU-HG4930' AND c.name = 'Honeywell Aerospace') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Centrale inertielle IMU-HG4930', 'Capteurs & Instrumentation', 'Aéronautique & Défense', 'IMU tactique 6 axes haute précision pour navigation, guidage et stabilisation de plateformes défense et spatial.', 'Sur devis', '🧭'
  FROM companies c WHERE c.name = 'Honeywell Aerospace' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Gyroscope MEMS 6 axes', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Dérive gyroscopique', '< 0,5 °/h', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fréquence de sortie', 'Jusqu''à 1 kHz', 3, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '0,5 kg', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Alimentation', '5 VDC', 5, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Température', '-40 à +85 °C', 6, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 94, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 80, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse', 90, '#D4500A');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-810G');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ITAR');
END $$;

-- ============================================================
-- PRODUITS SUPPLÉMENTAIRES (catalogue complet par entreprise)
-- ============================================================

-- Antenne tactique repliable (Thales)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Antenne tactique repliable AT-150' AND c.name = 'Thales') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Antenne tactique repliable AT-150', 'Communication & RF', 'Aéronautique & Défense', 'Antenne large bande repliable pour véhicules et postes tactiques. Déploiement rapide, faible signature.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'Thales' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande de fréquence', 'HF / VHF / UHF', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Gain', '3 dBi', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Longueur déployée', '2,4 m', 3, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '0,9 kg', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Temps de déploiement', '< 30 s', 5, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Portabilité', 95, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse', 88, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-810G');
END $$;

-- Récepteur GNSS militaire (Thales)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Récepteur GNSS militaire GR-Defense' AND c.name = 'Thales') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Récepteur GNSS militaire GR-Defense', 'Communication & RF', 'Aéronautique & Défense', 'Récepteur GNSS multi-constellation anti-leurrage pour navigation de précision en environnement contesté.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Thales' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Constellations', 'GPS, Galileo, GLONASS', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision', '< 1 m (mode différentiel)', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Anti-leurrage', 'M-Code compatible', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Alimentation', '10–32 VDC', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Température', '-40 à +71 °C', 5, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Résistance au brouillage', 92, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 90, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-810G');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ITAR');
END $$;

-- Radio tactique multibande (Thales)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Radio tactique multibande RT-9000' AND c.name = 'Thales') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Radio tactique multibande RT-9000', 'Communication & RF', 'Aéronautique & Défense', 'Radio logicielle multibande pour communications vocales et données sécurisées sur le terrain.', 'Sur devis', '📻'
  FROM companies c WHERE c.name = 'Thales' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande de fréquence', '30 MHz – 2 GHz', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '1–20 W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Chiffrement', 'AES-256', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '1,4 kg', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Autonomie', '12 h (batterie standard)', 5, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Sécurité des communications', 96, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Autonomie', 80, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-810G');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'NATO SECRET compatible');
END $$;

-- Modem SATCOM compact (Cobham)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Modem SATCOM compact CSM-200' AND c.name = 'Cobham') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Modem SATCOM compact CSM-200', 'Communication & RF', 'Aéronautique & Défense', 'Modem satellite compact pour liaisons de données haut débit sur plateformes mobiles et aéronefs.', 'Sur devis', '📶'
  FROM companies c WHERE c.name = 'Cobham' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Débit max', '50 Mbps', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bandes supportées', 'Ku / Ka', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '1,1 kg', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Alimentation', '18–32 VDC', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Débit', 85, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 90, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-810G');
END $$;

-- Amplificateur RF haute puissance (Cobham)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Amplificateur RF haute puissance PA-500' AND c.name = 'Cobham') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Amplificateur RF haute puissance PA-500', 'Communication & RF', 'Aéronautique & Défense', 'Amplificateur de puissance RF pour liaisons satellites et radars embarqués. Gamme bande Ku.', 'Sur devis', '🔊'
  FROM companies c WHERE c.name = 'Cobham' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance sortie', '500 W', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande', 'Ku (12-18 GHz)', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Rendement', '> 45 %', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Refroidissement', 'Convection forcée', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Puissance', 90, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Rendement', 78, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-810G');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'IP66');
END $$;

-- Positionneur d'antenne 2 axes (Cobham)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Positionneur d''antenne 2 axes ATP-300' AND c.name = 'Cobham') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Positionneur d''antenne 2 axes ATP-300', 'Communication & RF', 'Aéronautique & Défense', 'Système de pointage motorisé 2 axes pour antennes SATCOM mobiles, suivi automatique de satellite.', 'Sur devis', '🎯'
  FROM companies c WHERE c.name = 'Cobham' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision de pointage', '0,1°', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Vitesse de rotation', '30°/s', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Charge max', '15 kg', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Alimentation', '24 VDC', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 93, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Réactivité', 85, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-810G');
END $$;

-- Radio tactique vétronique (L3Harris)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Radio tactique vétronique AN/PRC-200' AND c.name = 'L3Harris Technologies') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Radio tactique vétronique AN/PRC-200', 'Communication & RF', 'Aéronautique & Défense', 'Radio tactique durcie pour intégration véhicule et usage portatif. Réseau maillé sécurisé.', 'Sur devis', '📻'
  FROM companies c WHERE c.name = 'L3Harris Technologies' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande de fréquence', '30 MHz – 512 MHz', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '1–50 W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Réseau', 'Maillé ad-hoc', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '2,1 kg', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Portée', 88, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Sécurité', 94, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-810G');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ITAR');
END $$;

-- Amplificateur RF large bande (L3Harris)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Amplificateur RF large bande AB-150' AND c.name = 'L3Harris Technologies') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Amplificateur RF large bande AB-150', 'Communication & RF', 'Aéronautique & Défense', 'Amplificateur RF large bande pour radios tactiques, montage véhicule ou station fixe.', 'Sur devis', '🔊'
  FROM companies c WHERE c.name = 'L3Harris Technologies' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance sortie', '150 W', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande', '30–512 MHz', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '3,2 kg', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Alimentation', '24 VDC', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Puissance', 87, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse', 90, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-810G');
END $$;

-- Kit connecteurs RF durcis (L3Harris)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Kit connecteurs RF durcis RFK-12' AND c.name = 'L3Harris Technologies') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Kit connecteurs RF durcis RFK-12', 'Câblage & Connecteurs', 'Aéronautique & Défense', 'Kit de connecteurs RF étanches et câbles assemblés pour intégration radio sur véhicules tactiques.', '~350 €', '🔌'
  FROM companies c WHERE c.name = 'L3Harris Technologies' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Nombre de connecteurs', '12', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Impédance', '50 Ω', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Étanchéité', 'IP68', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Longueur câbles', '0,5–3 m', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Étanchéité', 95, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durabilité', 88, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-DTL-38999');
END $$;

-- Actionneur électrique de tourelle (Rheinmetall)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Actionneur électrique de tourelle EA-600' AND c.name = 'Rheinmetall') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Actionneur électrique de tourelle EA-600', 'Vannes & Actionneurs', 'Aéronautique & Défense', 'Actionneur électrique pour rotation et stabilisation de tourelle sur véhicules blindés.', 'Sur devis', '⚙️'
  FROM companies c WHERE c.name = 'Rheinmetall' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Couple nominal', '600 N·m', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Vitesse de rotation', '45°/s', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Alimentation', '28 VDC', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '12 kg', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Couple', 85, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Réactivité', 80, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-810G');
END $$;

-- Vérin hydraulique de stabilisation (Rheinmetall)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Vérin hydraulique de stabilisation HC-450' AND c.name = 'Rheinmetall') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Vérin hydraulique de stabilisation HC-450', 'Vannes & Actionneurs', 'Aéronautique & Défense', 'Vérin hydraulique pour stabilisation de canon et systèmes d''armes sur plateformes mobiles.', 'Sur devis', '⚙️'
  FROM companies c WHERE c.name = 'Rheinmetall' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Course', '450 mm', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Pression de service', '0–320 bar', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Force max', '85 kN', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '18 kg', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Force', 90, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse', 92, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-810G');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'STANAG 4370');
END $$;

-- Bloc de vannes pneumatiques (Rheinmetall)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Bloc de vannes pneumatiques PV-220' AND c.name = 'Rheinmetall') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Bloc de vannes pneumatiques PV-220', 'Vannes & Actionneurs', 'Aéronautique & Défense', 'Bloc de distribution pneumatique pour systèmes auxiliaires de véhicules blindés.', 'Sur devis', '⚙️'
  FROM companies c WHERE c.name = 'Rheinmetall' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Pression de service', '0–10 bar', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Nombre de voies', '8', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Débit', '220 L/min', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '4,8 kg', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Débit', 78, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 82, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-810G');
END $$;

-- Système de navigation GPS/INS (Honeywell Aerospace)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Système de navigation GPS/INS HG-9900' AND c.name = 'Honeywell Aerospace') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Système de navigation GPS/INS HG-9900', 'Capteurs & Instrumentation', 'Aéronautique & Défense', 'Système de navigation hybride GPS/INS pour aéronefs et véhicules défense, fonctionnement en environnement dégradé.', 'Sur devis', '🧭'
  FROM companies c WHERE c.name = 'Honeywell Aerospace' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'GPS/INS hybride', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision position', '< 5 m CEP', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Autonomie sans GPS', '10 min (dérive < 0,1 NM)', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '2,3 kg', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Alimentation', '28 VDC', 5, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 93, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Résilience GPS-denied', 88, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-810G');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'DO-160G');
END $$;

-- Calculateur de données air (Honeywell Aerospace)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Calculateur de données air ADC-3000' AND c.name = 'Honeywell Aerospace') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Calculateur de données air ADC-3000', 'Capteurs & Instrumentation', 'Aéronautique & Défense', 'Calculateur de données air pour aéronefs militaires : altitude, vitesse, température extérieure.', 'Sur devis', '📊'
  FROM companies c WHERE c.name = 'Honeywell Aerospace' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plage altitude', '-1 000 à 80 000 ft', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision altitude', '± 20 ft', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fréquence de mise à jour', '50 Hz', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '1,8 kg', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 95, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Réactivité', 90, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'DO-160G');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'DO-178C');
END $$;

-- Altimètre radar (Honeywell Aerospace)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Altimètre radar RA-200' AND c.name = 'Honeywell Aerospace') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Altimètre radar RA-200', 'Capteurs & Instrumentation', 'Aéronautique & Défense', 'Altimètre radar basse altitude pour vol tactique et atterrissage en conditions dégradées.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'Honeywell Aerospace' LIMIT 1
  RETURNING id INTO pid;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plage de mesure', '0–5 000 ft', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision', '± 2 ft (basse altitude)', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fréquence radar', 'Bande C', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '2,0 kg', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision basse altitude', 96, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité', 92, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'DO-160G');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-461');
END $$;
