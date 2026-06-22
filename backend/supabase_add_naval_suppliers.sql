-- ============================================================
-- BUY-INEER -- Fournisseurs francais du naval / sous-marin
-- Verifie directement sur alseamar-alcen.com et rtsys.eu
-- A executer dans Supabase : SQL Editor -> New query -> Run
-- Idempotent : peut etre relance sans creer de doublons.
-- ============================================================

-- ============ ENTREPRISES ============

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'ALSEAMAR', '🇫🇷 France', 'Rousset', 'Marine & Offshore', 'https://www.alseamar-alcen.com', '🌊', 'Filiale du groupe ALCEN specialisee en robotique sous-marine : gliders oceanographiques, solutions acoustiques sous-marines et equipements navals de defense.', TRUE, FALSE, '100+', '2007', 'contact@alseamar-alcen.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'ALSEAMAR');

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'RTsys', '🇫🇷 France', 'Lorient', 'Marine & Offshore', 'https://www.rtsys.eu', '🔊', 'Specialiste francais de la surveillance acoustique sous-marine (PAM), des vehicules autonomes sous-marins et des systemes de lutte anti-sous-marine et anti-mines pour les marines.', TRUE, FALSE, '50+', '1991', 'contact@rtsys.eu'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'RTsys');

-- ============ PRODUITS ============

-- SEAEXPLORER 200 (ALSEAMAR)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'SEAEXPLORER 200' AND c.name = 'ALSEAMAR') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'SEAEXPLORER 200', 'Vannes & Actionneurs', 'Marine & Offshore', 'Glider sous-marin oceanographique rechargeable, profondeur max 200m. Drone furtif a endurance etendue pour missions multi-capteurs.', 'Sur devis', '🌊'
  FROM companies c WHERE c.name = 'ALSEAMAR' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Profondeur max', '200 m', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse (batterie simple)', '65 kg', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse (batterie double)', '90 kg', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Endurance (batterie simple)', '75 jours / 1 350 km', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Endurance (batterie double)', '135 jours / 2 500 km', 5, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Endurance', 92, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Modularité capteurs', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié opérationnel');
END $$;

-- SEAEXPLORER 1000 (ALSEAMAR)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'SEAEXPLORER 1000' AND c.name = 'ALSEAMAR') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'SEAEXPLORER 1000', 'Vannes & Actionneurs', 'Marine & Offshore', 'Glider sous-marin oceanographique haute profondeur, jusqu''a 1000m. Endurance exceptionnelle pour missions longue duree.', 'Sur devis', '🌊'
  FROM companies c WHERE c.name = 'ALSEAMAR' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Profondeur max', '1 000 m', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '59 kg', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Endurance', '125 jours / 2 700 km', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Dimensions (hors antenne)', '2 000 mm × Ø 250 mm', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Endurance', 95, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Profondeur opérationnelle', 93, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié opérationnel');
END $$;

-- SYSENSE — Station de fond multiparamètre (RTsys)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'SYSENSE — Station de fond multiparamètre' AND c.name = 'RTsys') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'SYSENSE — Station de fond multiparamètre', 'Capteurs & Instrumentation', 'Marine & Offshore', 'Station de fond marin multiparametre pour le monitoring temps reel : acoustique, salinite, profondeur, turbidite. Donnees accessibles a distance via site web dedie.', 'Sur devis', '🔊'
  FROM companies c WHERE c.name = 'RTsys' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Paramètres mesurés', 'Acoustique, salinité, profondeur, turbidité', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Mode', 'Temps réel, monitoring à distance', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Application', 'Construction littorale, surveillance environnementale', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Polyvalence multiparamètre', 92, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Monitoring temps réel', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié opérationnel');
END $$;

-- ============ CATÉGORIES PRODUITS (filtres annuaire) ============

INSERT INTO company_product_categories (company_id, category) SELECT id, 'Vannes & Actionneurs' FROM companies WHERE name = 'ALSEAMAR' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Capteurs & Instrumentation' FROM companies WHERE name = 'RTsys' LIMIT 1 ON CONFLICT DO NOTHING;