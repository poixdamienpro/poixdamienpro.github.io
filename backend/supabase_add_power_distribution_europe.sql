-- ============================================================
-- BUY-INEER -- Distribution de puissance (Europe, plusieurs domaines)
-- Composants verifies sur les sites officiels des fabricants
-- Idempotent
-- ============================================================

-- ============================================================
-- Murrelektronik (Allemagne) — Industriel
-- Verifie sur my.murrelektronik.com
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Murrelektronik', '🇩🇪 Allemagne', 'Oppenweiler', 'Industriel', 'https://www.murrelektronik.com', '⚡',
  'Fabricant allemand de composants pour l''automatisation industrielle, spécialisé dans la connectivité et la distribution de puissance électronique (modules MICO) pour applications 24V/48V DC en armoire électrique.',
  TRUE, TRUE, '3 700+', '1975', 'info@murrelektronik.de'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Murrelektronik');

-- MICO Pro
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'MICO Pro' AND c.name = 'Murrelektronik') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'MICO Pro', 'PDU (Power Distribution)', 'Industriel', 'Module électronique de surveillance de courant et de distribution de puissance pour applications 12V/24V DC, à intégrer en armoire électrique. Système modulaire à 1, 2 ou 4 canaux de sortie, cascadable, avec concept intégré de distribution de potentiel.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'Murrelektronik' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '12 V / 24 V DC', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Canaux de sortie', '1, 2 ou 4', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Courants de déclenchement (modules Fix)', '2, 4, 6, 8, 10, 16 A', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Largeur module', '8, 12 ou 24 mm', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Charge capacitive max par canal', '30 000 µF', 5, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Gain d''espace armoire', 85, '#1B4965');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Modularité', 92, '#1B4965');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Procédé de déclenchement brevété');
END $$;

-- MICO Basic
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'MICO Basic' AND c.name = 'Murrelektronik') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'MICO Basic', 'PDU (Power Distribution)', 'Industriel', 'Module de distribution de puissance intelligent pour applications 24V DC, surveillant 4 ou 8 canaux avec coupure en cas de court-circuit. Conçu pour protéger un grand nombre de capteurs et actionneurs aux exigences similaires.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'Murrelektronik' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '24 V DC', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Canaux de sortie', '4 ou 8', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Courants de déclenchement', '2, 4 ou 6 A', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Gain d''espace vs disjoncteurs', '66%', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Gain d''espace armoire', 90, '#1B4965');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité de coupure', 88, '#1B4965');
END $$;

-- MICO Fuse 250
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'MICO Fuse 250' AND c.name = 'Murrelektronik') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'MICO Fuse 250', 'PDU (Power Distribution)', 'Industriel', 'Module universel de distribution de puissance par fusibles tube verre, couvrant la gamme 0 à 250V AC/DC, avec 8 canaux de sortie accessibles depuis l''avant. Alternative compacte aux borniers de sécurité individuels.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'Murrelektronik' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plage de tension', '0 à 250 V AC/DC', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Canaux de sortie', '8', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Courant total max', '40 A', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Protection', 'Fusibles tube verre', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Facilité de maintenance', 90, '#1B4965');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 85, '#1B4965');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'PDU (Power Distribution)' FROM companies WHERE name = 'Murrelektronik' LIMIT 1 ON CONFLICT DO NOTHING;
