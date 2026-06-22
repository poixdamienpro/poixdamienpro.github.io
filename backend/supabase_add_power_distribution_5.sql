-- ============================================================
-- BUY-INEER -- 5 fabricants de distribution de puissance (DC/DC, PDU, PCDU)
-- Europe, plusieurs domaines. Verifie sur les sites officiels.
-- Idempotent
-- ============================================================

-- ============================================================
-- XP Power (Royaume-Uni) — Industriel / Médical / Défense
-- Verifie sur xppower.com
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'XP Power', '🇬🇧 Royaume-Uni', 'Singapour / Camberley', 'Industriel', 'https://www.xppower.com', '⚡',
  'Fabricant britannique de solutions de conversion de puissance : alimentations AC/DC, convertisseurs DC/DC et solutions haute tension, pour applications industrielles, médicales, ferroviaires et défense/avionique.',
  TRUE, TRUE, '1 500+', '1988', 'info@xppower.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'XP Power');

-- BCT40 Series
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'BCT40 Series' AND c.name = 'XP Power') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'BCT40 Series', 'DC/DC Converters', 'Industriel', 'Convertisseur DC/DC ultra-compact 40W de XP Power, destiné à l''intégration dans des équipements industriels, ferroviaires et de défense/avionique nécessitant une conversion de puissance embarquée.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'XP Power' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '40 W', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Format', 'Ultra-compact', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Applications cibles', 'Industriel, ferroviaire, défense/avionique', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Densité de puissance', 88, '#1B4965');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Conforme normes ferroviaires et défense');
END $$;

-- FLXPro Series
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'FLXPro Series' AND c.name = 'XP Power') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'FLXPro Series', 'Power Supplies', 'Industriel', 'Alimentation AC/DC entièrement numérique, intelligente et configurable de XP Power, au format 1U, conçue pour s''intégrer dans des baies et systèmes de distribution de puissance industriels.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'XP Power' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '1.3 kW', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Format', '1U, configurable', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Entièrement digital, intelligent', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Configurabilité', 92, '#1B4965');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'DC/DC Converters' FROM companies WHERE name = 'XP Power' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Power Supplies' FROM companies WHERE name = 'XP Power' LIMIT 1 ON CONFLICT DO NOTHING;

-- ============================================================
-- RECOM Power (Autriche) — Industriel / Électronique embarquée
-- Verifie sur recom-power.com
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'RECOM Power', '🇦🇹 Autriche', 'Gmunden', 'Industriel', 'https://recom-power.com', '⚡',
  'Fabricant autrichien de convertisseurs DC/DC isolés, modules de puissance et alimentations, destinés à l''intégration dans des systèmes électroniques industriels, médicaux et de télécommunications.',
  TRUE, TRUE, '500+', '1996', 'info@recom-power.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'RECOM Power');

-- RECOM K-Series
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'RECOM K-Series' AND c.name = 'RECOM Power') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'RECOM K-Series', 'DC/DC Converters', 'Industriel', 'Gamme de convertisseurs DC/DC isolés RECOM, disponible en version régulateur de commutation et module DIN rail, conçue pour l''intégration dans des systèmes d''alimentation industriels distribués.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'RECOM Power' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Convertisseur DC/DC isolé', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Formats disponibles', 'DIN rail, régulateur de commutation', 2, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Isolation galvanique', 90, '#1B4965');
END $$;

-- RECOM E-Series
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'RECOM E-Series' AND c.name = 'RECOM Power') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'RECOM E-Series', 'DC/DC Converters', 'Industriel', 'Convertisseur DC/DC isolé RECOM au format DIN rail, à intégrer dans une armoire de distribution électrique pour la conversion de tension en environnement industriel.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'RECOM Power' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Convertisseur DC/DC isolé', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Format', 'DIN rail', 2, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Isolation galvanique', 90, '#1B4965');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'DC/DC Converters' FROM companies WHERE name = 'RECOM Power' LIMIT 1 ON CONFLICT DO NOTHING;

-- ============================================================
-- GAIA Converter (France) — Avionique / Défense / Ferroviaire
-- Verifie sur gaia-converter.com
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'GAIA Converter', '🇫🇷 France', 'Toulouse', 'Défense', 'https://www.gaia-converter.com', '⚡',
  'Fabricant français de convertisseurs DC/DC isolés et non isolés, modules front-end et cartes de distribution de puissance, destinés aux marchés avionique, défense, ferroviaire et industriel.',
  TRUE, TRUE, '100+', '1985', 'info@gaia-converter.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'GAIA Converter');

-- GRD-12A
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'GRD-12A' AND c.name = 'GAIA Converter') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'GRD-12A', 'PDU (Power Distribution)', 'Défense', 'Carte de référence GAIA Converter à sorties multiples configurables, basée sur les modules COTS de la série MGDD. Distribue jusqu''à 120W sur 3 canaux principaux et 2 canaux auxiliaires, conforme aux normes militaires Mil-Std-1275/704/461.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'GAIA Converter' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance max', '120 W', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Canaux', '3 principaux + 2 auxiliaires (jusqu''à 7 sorties)', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plage de sortie', '3.3V à 52V', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Normes militaires', 'Mil-Std-1275, Mil-Std-704, Mil-Std-461', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Configurabilité', 90, '#1B4965');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse (surtensions/surintensités)', 88, '#1B4965');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Mil-Std-1275 / 704 / 461');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'PDU (Power Distribution)' FROM companies WHERE name = 'GAIA Converter' LIMIT 1 ON CONFLICT DO NOTHING;

-- ============================================================
-- CAEN ELS (Italie) — Instrumentation scientifique / Industriel
-- Verifie sur caenels.com
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'CAEN ELS', '🇮🇹 Italie', 'Pise', 'Industriel', 'https://www.caenels.com', '⚡',
  'Fabricant italien d''alimentations de précision et de systèmes de distribution de puissance programmables, destinés aux accélérateurs de particules, à l''instrumentation scientifique et aux applications industrielles de haute précision.',
  TRUE, TRUE, '50+', '2008', 'info@caenels.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'CAEN ELS');

-- FAST-Bi-1K5
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'FAST-Bi-1K5' AND c.name = 'CAEN ELS') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'FAST-Bi-1K5', 'Power Supplies', 'Industriel', 'Alimentation bipolaire bidirectionnelle et régénérative quatre quadrants de CAEN ELS, à intégrer dans des systèmes de distribution de puissance pour accélérateurs de particules et instrumentation de précision.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'CAEN ELS' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '1.5 kW', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Bipolaire, bidirectionnel, régénératif (4 quadrants)', 2, FALSE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 95, '#1B4965');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'Power Supplies' FROM companies WHERE name = 'CAEN ELS' LIMIT 1 ON CONFLICT DO NOTHING;

-- ============================================================
-- PULS GmbH (Allemagne) — Industriel
-- Verifie sur pulspower.com
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'PULS GmbH', '🇩🇪 Allemagne', 'Munich', 'Industriel', 'https://www.pulspower.com', '⚡',
  'Fabricant allemand spécialisé dans les alimentations DIN rail, convertisseurs DC/DC, disjoncteurs électroniques et modules DC-UPS, destinés à l''intégration dans des armoires de distribution électrique industrielles.',
  TRUE, TRUE, '300+', '2003', 'info@pulspower.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'PULS GmbH');

-- PULS DIMENSION
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'PULS DIMENSION' AND c.name = 'PULS GmbH') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'PULS DIMENSION', 'Power Supplies', 'Industriel', 'Famille d''alimentations DIN rail PULS de la gamme DIMENSION, conçue pour l''intégration dans des armoires de distribution électrique industrielles à haute densité de puissance.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'PULS GmbH' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Format', 'Montage DIN rail', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Alimentation industrielle', 2, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Densité de puissance', 88, '#1B4965');
END $$;

-- PULS PLANET
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'PULS PLANET' AND c.name = 'PULS GmbH') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'PULS PLANET', 'Power Supplies', 'Industriel', 'Famille d''alimentations DIN rail PULS de la gamme PLANET, conçue pour la distribution de puissance compacte dans les armoires électriques industrielles.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'PULS GmbH' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Format', 'Montage DIN rail', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Alimentation industrielle compacte', 2, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 90, '#1B4965');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'Power Supplies' FROM companies WHERE name = 'PULS GmbH' LIMIT 1 ON CONFLICT DO NOTHING;
