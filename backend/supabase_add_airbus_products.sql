-- ============================================================
-- BUY-INEER -- Airbus Defence & Space : produits reels et precis
-- Source : airbus.com/en/products-services/space/space-equipment
-- (et sous-pages power/avionics/launcher)
-- Remplace les produits generiques par les vraies references produit
-- A executer dans Supabase : SQL Editor -> New query -> Run
-- Idempotent : peut etre relance sans creer de doublons.
-- ============================================================

-- PSR 100V MKII
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'PSR 100V MKII' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'PSR 100V MKII', 'Convertisseurs & Onduleurs', 'Spatial', 'Regulateur de puissance (Power Supply Regulator) qualifie pour satellites telecom. Heritage PSR 50V, plus de 80 unites en vol sur Alphabus, E3000, E3000-NEO et Galileo.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', 'Jusqu''a 23 kW', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '100 V', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plateformes', 'Alphabus, E3000, E3000-NEO, Galileo', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Unites en vol', '> 80', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilite en vol', 97, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Puissance geree', 92, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS-E-ST-20');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- EVO PCDU
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'EVO PCDU' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'EVO PCDU', 'PDU (Power Distribution)', 'Spatial', 'PCDU modulaire nouvelle generation, solution de reference pour missions d''observation de la Terre, scientifiques et interplanetaires.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Architecture', 'Modulaire', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Applications', 'Earth observation, science, interplanetaire', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Redondance', 'Configurable', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Modularite', 93, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilite en vol', 94, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS-E-ST-20');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- PureLine Pearl
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'PureLine Pearl' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'PureLine Pearl', 'PDU (Power Distribution)', 'Spatial', 'Unite de puissance et distribution la plus compacte et legere d''Airbus. Tension nominale non regulee 22-38V, jusqu''a 1,5kW.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '22-38 V (non regulee)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', 'Jusqu''a 1,5 kW', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Conception', 'Ultra-compacte, legere', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacite', 96, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Legerete', 94, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS-E-ST-20');
END $$;

-- MVPCU
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'MVPCU' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'MVPCU', 'PDU (Power Distribution)', 'Spatial', 'Unite de conditionnement de puissance multi-tension pour orbite geostationnaire, missions scientifiques et telecom. Technologie GaN et controle numerique.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Technologie', 'GaN, controle numerique', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Applications', 'GEO, science, telecom', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Performance', 'Etat de l''art', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Performance', 95, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Flexibilite', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS-E-ST-20');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- MEGA PCDU
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'MEGA PCDU' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'MEGA PCDU', 'PDU (Power Distribution)', 'Spatial', 'PCDU base sur composants automotive-grade eprouves, conception modulaire a masse et volume competitifs, taille pour les constellations LEO.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Composants', 'Automotive-grade', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Application', 'Constellations LEO', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Conception', 'Modulaire, compacte', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Cout / unite', 94, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Production en serie', 92, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS-E-ST-20');
END $$;

-- PureLine Topaz/THORs
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'PureLine Topaz/THORs' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'PureLine Topaz/THORs', 'Convertisseurs & Onduleurs', 'Spatial', 'Sous-systeme de propulsion electrique compact et flexible pour New Space. 10 ans de duree de vie en LEO, concu pour le maintien a poste et la desorbitation.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Duree de vie', '10 ans en LEO', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Applications', 'Orbit raising, station keeping, deorbiting', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Conception', 'Compacte, latch-up-free', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacite', 92, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilite', 90, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS-E-ST-20');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- Elektro PPU NG1
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Elektro PPU NG1' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Elektro PPU NG1', 'Convertisseurs & Onduleurs', 'Spatial', 'Unite de traitement de puissance (PPU), coeur du systeme de propulsion electrique (EPS). Conditionnement de puissance pour propulseurs a effet Hall et systeme de gestion du Xenon.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fonction', 'Conditionnement puissance EPS', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Compatibilite', 'Propulseurs a effet Hall', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Gestion fluide', 'Xenon Flow Assembly', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilite en vol', 93, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Rendement', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS-E-ST-20');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- Elektro PPU NG2
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Elektro PPU NG2' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Elektro PPU NG2', 'Convertisseurs & Onduleurs', 'Spatial', 'Evolution du PPU NG1 : conditionnement de puissance pour propulseurs a effet Hall avec gestion fluidique Xenon/Krypton.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fonction', 'Conditionnement puissance EPS', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Gestion fluide', 'Xenon / Krypton', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Generation', 'NG2', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilite en vol', 94, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Rendement', 92, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS-E-ST-20');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- COSMO-BATT-S
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'COSMO-BATT-S' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'COSMO-BATT-S', 'Batteries & Stockage', 'Spatial', 'Module batterie COSMO-BATT, version S (500 a 1000 Wh), embarque sur les satellites de navigation Galileo.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Energie', '500 - 1 000 Wh', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plateforme', 'Galileo', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Chimie', 'Li-ion COTS qualifie spatial', 3, FALSE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilite en vol', 98, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacite', 85, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS-E-ST-20-08');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- COSMO-BATT-M
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'COSMO-BATT-M' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'COSMO-BATT-M', 'Batteries & Stockage', 'Spatial', 'Module batterie COSMO-BATT, version M (1100 a 2100 Wh), embarque sur les satellites OneSat.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Energie', '1 100 - 2 100 Wh', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plateforme', 'OneSat', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Chimie', 'Li-ion COTS qualifie spatial', 3, FALSE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilite en vol', 98, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Densite energie', 78, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS-E-ST-20-08');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- COSMO-BATT-L
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'COSMO-BATT-L' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'COSMO-BATT-L', 'Batteries & Stockage', 'Spatial', 'Module batterie COSMO-BATT, version L (2200 a 3000 Wh), embarque sur les satellites E3000-NEO. Plus de 300 unites fabriquees, plus de 100 en vol.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Energie', '2 200 - 3 000 Wh', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plateforme', 'E3000-NEO', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Unites fabriquees', '> 300', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilite en vol', 99, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Heritage mission', 96, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS-E-ST-20-08');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- STELLAR-BATT-S
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'STELLAR-BATT-S' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'STELLAR-BATT-S', 'Batteries & Stockage', 'Spatial', 'Module STELLAR-BATT, version S, 30V ~1700 Wh, montage externe avec radiateur integre. Selectionne pour la constellation OneWeb.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '30 V', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Energie', '~1 700 Wh', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Montage', 'Externe, radiateur integre', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Programme', 'OneWeb', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilite en vol', 97, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Adaptabilite', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- STELLAR-BATT-L
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'STELLAR-BATT-L' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'STELLAR-BATT-L', 'Batteries & Stockage', 'Spatial', 'Module STELLAR-BATT, version L, 30V de 900 a 3600 Wh selon configuration modulaire. Plus de 800 unites fabriquees, selectionne pour OneWeb (630+ satellites).', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '30 V', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Energie', '900 - 3 600 Wh', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Unites fabriquees', '> 800', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Programme', 'OneWeb (630+ satellites)', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilite en vol', 97, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Modularite', 93, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- LAUNCHER-BATT-S
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'LAUNCHER-BATT-S' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'LAUNCHER-BATT-S', 'Batteries & Stockage', 'Spatial', 'Batterie LAUNCHER-BATT, version S, configuration 30V ~260 Wh, pour alimentation d''unites de lanceur ou mise a feu pyrotechnique.', 'Sur devis', '🚀'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '30 V', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Energie', '~260 Wh', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Usage', 'Alimentation unites lanceur / pyrotechnie', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Securite', 95, '#D4500A');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilite', 93, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS');
END $$;

-- LAUNCHER-BATT-L
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'LAUNCHER-BATT-L' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'LAUNCHER-BATT-L', 'Batteries & Stockage', 'Spatial', 'Batterie LAUNCHER-BATT, version L, configuration 60V ~1600 Wh. Selectionnee par ArianeGroup pour Ariane 6 (> 150 modules fabriques, > 30 embarques au premier vol).', 'Sur devis', '🚀'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '60 V', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Energie', '~1 600 Wh', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Programme', 'Ariane 6', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Unites fabriquees', '> 150', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilite en vol', 96, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Heritage mission', 94, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Ariane 6 qualifie');
END $$;

-- Astrix NS
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Astrix NS' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Astrix NS', 'Capteurs & Instrumentation', 'Spatial', 'Gyroscope a fibre optique compact 3 axes Astrix New Space. 6 millions d''heures de vol cumulees sur plus de 40 satellites sans incident.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Gyroscope a fibre optique 3 axes', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Stabilite de biais', '< 0,02 °/h', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Consommation', '7 W', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Heures de vol cumulees', '6 000 000 h', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Precision', 94, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Heritage en vol', 98, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS-E-ST-60');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- Astrix 200
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Astrix 200' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Astrix 200', 'Capteurs & Instrumentation', 'Spatial', 'Gyroscope a fibre optique haute precision pour missions GEO de 15 ans. Stabilite de biais < 0,0005°/h, bruit 0,0001°/√h.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Gyroscope a fibre optique', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Stabilite de biais', '< 0,0005 °/h', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bruit angulaire', '0,0001 °/√h', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Duree de mission', '15 ans GEO', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Precision', 99, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Stabilite long-terme', 97, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS-E-ST-60');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- Astrix 1090
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Astrix 1090' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Astrix 1090', 'Capteurs & Instrumentation', 'Spatial', 'Centrale inertielle a fibre optique 3 axes. Plus de 3 millions d''heures de vol et 100% de succes en mission, LEO/MEO/GEO et sondes profondes.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Centrale inertielle 3 axes (FOG)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Stabilite de biais', '< 0,01 °/h', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'ARW', '< 0,005 °/√h', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Heures de vol cumulees', '> 3 000 000 h', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Precision', 96, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilite', 99, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS-E-ST-60');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- BASS Bi-Axis Sun Sensor
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'BASS Bi-Axis Sun Sensor' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'BASS Bi-Axis Sun Sensor', 'Capteurs & Instrumentation', 'Spatial', 'Capteur solaire bi-axe passif. Champ de vision +-90°, faible masse (65g), haute resistance thermique. Plus de 290 unites en orbite.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Champ de vision', '+-90°', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '65 g', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Temperature', '-40 a +90 °C', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Unites en orbite', '> 290', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilite en vol', 97, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Legerete', 95, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS-E-ST-60');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- CMG 15-45
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'CMG 15-45' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'CMG 15-45', 'Vannes & Actionneurs', 'Spatial', 'Gyroscope a moment de controle (CMG) optimise pour satellites agiles jusqu''a 1 tonne. 45 Nm de couple, agilite 3°/s en moins de 2 secondes.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Couple', '45 N.m', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Moment angulaire', '15 N.m.s', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Agilite', '3°/s en < 2 s', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Duree de vie', '> 10 ans LEO', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Agilite', 95, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Precision', 92, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS-E-ST-60');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- CMG 40-60S
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'CMG 40-60S' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'CMG 40-60S', 'Vannes & Actionneurs', 'Spatial', 'Gyroscope a moment de controle pour satellites de 1 a 2 tonnes. 60 Nm de couple, amortisseurs de micro-vibration integres.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Couple', '60 N.m', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse satellite cible', '1-2 tonnes', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Duree de vie', '10 ans en LEO', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Agilite', 92, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Precision', 93, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS-E-ST-60');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- CMG 75-75S
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'CMG 75-75S' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'CMG 75-75S', 'Vannes & Actionneurs', 'Spatial', 'Gyroscope a moment de controle haute performance pour satellites agiles jusqu''a 3 tonnes. 75 Nm de couple, conception compacte brevetee.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Couple', '75 N.m', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Moment angulaire', '75 N.m.s', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse satellite cible', 'Jusqu''a 3 tonnes', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Couple', 96, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacite', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS-E-ST-60');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- Newton CMG Package
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Newton CMG Package' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Newton CMG Package', 'Vannes & Actionneurs', 'Spatial', 'Package de gyroscopes a moment de controle a performance evolutive, sans singularite, electronique de controle integree. Couvre 500 kg a plus de 2 tonnes.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Couple', '15 a 75 N.m', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Moment angulaire', 'Jusqu''a 75 N.m.s', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Electronique', 'Controle integre', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Duree de vie', '> 10 ans en orbite', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Agilite', 93, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Simplicite d''integration', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS-E-ST-60');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- Detumbler
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Detumbler' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Detumbler', 'Vannes & Actionneurs', 'Spatial', 'Dispositif passif compact (diametre 85mm, hauteur 53mm) garantissant qu''un satellite ne finira pas en rotation incontrolee en fin de vie. Frein a induction passif sur champ magnetique terrestre.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Frein a induction passif', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Dimensions', 'Diam. 85 mm x h53 mm', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fonctionnement', 'Passif, sans alimentation', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Usage', 'Retrait actif de debris (mitigation fin de vie)', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Simplicite', 97, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilite passive', 95, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;

-- Sparkwing
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Sparkwing' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Sparkwing', 'Panneaux solaires', 'Spatial', 'Panneau solaire deployable leger pour smallsats et constellations. Plus de 200 unites livrees a MDA Space pour le programme AURORA.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Panneau deployable', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Reference programme', 'MDA AURORA (> 200 unites)', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cellules', 'Triple jonction', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Legerete', 92, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Production en serie', 95, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS Class 1');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifie');
END $$;
