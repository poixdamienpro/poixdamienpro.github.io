-- ============================================================
-- BUY-INEER -- EREMS (France) — équipements électroniques spatiaux
-- Verifie sur erems.fr (OBC, PCDU, batteries, propulsion electrique)
-- Idempotent
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'EREMS', '🇫🇷 France', 'Aix-en-Provence', 'Spatial', 'https://erems.fr', '🛰️',
  'PME française fondée en 1979, spécialisée dans la conception et la fabrication d''équipements électroniques de vol et de sol pour le spatial, la défense, l''aéronautique et le nucléaire : ordinateurs de bord, PCDU, systèmes de batteries et propulsion électrique. Équipements à bord de SVOM, Kinéis, Pléiades Neo, SWOT, MicroCarb/CO3D.',
  TRUE, TRUE, '150+', '1979', 'contact@erems.fr'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'EREMS');

-- NG Medium Module — Modular ICU (OBC)
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'NG Medium Module' AND c.name = 'EREMS') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'NG Medium Module', 'OBC (On-Board Charger)', 'Spatial', 'Module FPGA d''EREMS pouvant fonctionner en mode autonome ou être alimenté et supervisé par d''autres modules, conçu spécifiquement pour une utilisation au sein d''une unité de contrôle modulaire (ICU).', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'EREMS' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Module FPGA', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Mode de fonctionnement', 'Autonome ou intégré (Modular ICU)', 2, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Modularité', 90, '#1B4965');
END $$;

-- GR740 Module — ICU Module (OBC)
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'GR740 Module' AND c.name = 'EREMS') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'GR740 Module', 'OBC (On-Board Charger)', 'Spatial', 'Module CPU d''EREMS gérant les fonctions de télémesure/télécommande (TM/TC) et exécutant les calculs logiciels dédiés, conçu pour s''intégrer dans une unité de contrôle modulaire (ICU).', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'EREMS' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Module CPU', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fonctions', 'Gestion TM/TC, calculs logiciels dédiés', 2, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Capacité de traitement', 88, '#1B4965');
END $$;

-- Modular ICU (OBC)
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Modular ICU' AND c.name = 'EREMS') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Modular ICU', 'OBC (On-Board Charger)', 'Spatial', 'Unité de contrôle modulaire (Instrument Control Unit) d''EREMS destinée au marché spatial : satellites scientifiques, sondes, programmes d''observation de la Terre, missions d''exploration ou de sécurité.', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'EREMS' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Applications', 'Satellites scientifiques, sondes, observation de la Terre, exploration', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Architecture', 'Modulaire (combinable avec modules CPU et FPGA)', 2, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Adaptabilité multi-mission', 92, '#1B4965');
END $$;

-- CPU BOARD — Control and Processing Unit (OBC)
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'CPU BOARD — Control and Processing Unit' AND c.name = 'EREMS') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'CPU BOARD — Control and Processing Unit', 'OBC (On-Board Charger)', 'Spatial', 'Nouvelle génération du module de contrôle ICARE-NG2 d''EREMS, conçue pour résoudre les problématiques d''obsolescence de composants (y compris le choix du microcontrôleur) et assurer la compatibilité avec les bus satellite TM/TC.', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'EREMS' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Génération', 'Successeur ICARE-NG2', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Compatibilité', 'Bus satellite TM/TC', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Avantage', 'Résolution des obsolescences composants', 3, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Pérennité (anti-obsolescence)', 90, '#1B4965');
END $$;

-- CPUGEN — On-Board Computing Module (OBC)
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'CPUGEN' AND c.name = 'EREMS') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'CPUGEN', 'OBC (On-Board Charger)', 'Spatial', 'Carte processeur haute performance d''EREMS, basée sur des composants durcis aux radiations, conçue pour les applications spatiales en collaboration avec le CNES.', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'EREMS' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Composants', 'Durcis aux radiations', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Partenaire de développement', 'CNES', 2, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Tolérance aux radiations', 93, '#1B4965');
END $$;

-- UGTS — Scientific Treatment and Management Unit (OBC)
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'UGTS — Unité de Gestion et de Traitement Scientifique' AND c.name = 'EREMS') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'UGTS — Unité de Gestion et de Traitement Scientifique', 'OBC (On-Board Charger)', 'Spatial', 'Unité d''EREMS en charge de l''alimentation et du contrôle de l''instrument, ainsi que du traitement scientifique des données de la caméra front-end et de la génération du signal de déclenchement d''alerte.', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'EREMS' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fonctions', 'Alimentation/contrôle instrument, traitement scientifique', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interface', 'Caméra front-end', 2, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Capacité de traitement scientifique', 88, '#1B4965');
END $$;

-- GAN — Converter Board (DC/DC)
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'GAN — Converter Board' AND c.name = 'EREMS') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'GAN — Converter Board', 'DC/DC Converters', 'Spatial', 'Carte convertisseur d''EREMS basée sur une architecture DC/DC isolée avec transistor GaN (nitrure de gallium), destinée à l''intégration dans des systèmes de distribution de puissance spatiale.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'EREMS' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Architecture', 'DC/DC isolée', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Technologie de commutation', 'Transistor GaN (GaNFET)', 2, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Efficacité de conversion', 92, '#1B4965');
END $$;

-- PCDU MMX — Power Conditioning and Distribution Unit
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'PCDU MMX' AND c.name = 'EREMS') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'PCDU MMX', 'PDU (Power Distribution)', 'Spatial', 'Power Conditioning and Distribution Unit développée par EREMS dans le cadre du projet MMX (Martian Moons eXploration), gérant l''ensemble de l''alimentation électrique du rover.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'EREMS' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Mission', 'MMX (Martian Moons eXploration)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fonction', 'Alimentation électrique complète du rover', 2, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité (mission interplanétaire)', 94, '#1B4965');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Développé, vérifié et livré pour JAXA/CNES MMX');
END $$;

-- PCDU NANO — Power Conditioning and Distribution Unit
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'PCDU NANO' AND c.name = 'EREMS') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'PCDU NANO', 'PDU (Power Distribution)', 'Spatial', 'Power Conditioning and Distribution Unit d''EREMS pour nanosatellites, conforme au standard CubeSat, à architecture modulaire composée de 4 modules principaux permettant une mise en service rapide multi-missions (6U à 27U).', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'EREMS' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Standard', 'CubeSat (6U à 27U)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Architecture', 'Modulaire, 4 modules principaux', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Mise en service', 'Rapide, multi-missions', 3, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Modularité', 93, '#1B4965');
END $$;

-- DCDC Converter Unit — Modular ICU
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'DCDC Converter Unit' AND c.name = 'EREMS') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'DCDC Converter Unit', 'DC/DC Converters', 'Spatial', 'Module convertisseur DC/DC d''EREMS qui alimente l''unité de contrôle modulaire (ICU) en puissance.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'EREMS' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fonction', 'Alimentation de l''ICU', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Intégration', 'Module Modular ICU', 2, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compatibilité modulaire', 90, '#1B4965');
END $$;

-- ACES — Power Distribution Unit
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'ACES — Power Distribution Unit' AND c.name = 'EREMS') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'ACES — Power Distribution Unit', 'PDU (Power Distribution)', 'Spatial', 'Unité de distribution de puissance d''EREMS pour le payload ACES (Atomic Clock Ensemble in Space), qui embarque deux horloges atomiques haute performance (PHARAO et SHM), installé sur la Station Spatiale Internationale.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'EREMS' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Mission', 'ACES (Atomic Clock Ensemble in Space) — ISS', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Charge utile associée', 'Horloges PHARAO et SHM', 2, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision de distribution (haute performance)', 95, '#1B4965');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol habité (ISS)');
END $$;

-- IPE
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'IPE' AND c.name = 'EREMS') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'IPE', 'PDU (Power Distribution)', 'Spatial', 'Équipement IPE développé par EREMS, responsable de la génération et de la fourniture de puissance à l''électronique front-end du capteur optique.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'EREMS' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fonction', 'Génération et fourniture de puissance', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interface', 'Électronique front-end du capteur optique', 2, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Stabilité d''alimentation', 90, '#1B4965');
END $$;

-- BoMo — Modular Boxes
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'BoMo — Modular Boxes' AND c.name = 'EREMS') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'BoMo — Modular Boxes', 'PDU (Power Distribution)', 'Spatial', 'Boîtiers modulaires BoMo, co-développés par EREMS et le CNES dans le cadre de l''essor du marché concurrentiel des mini-satellites.', 'Sur devis', '📦'
  FROM companies c WHERE c.name = 'EREMS' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Co-développement', 'EREMS / CNES', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Marché cible', 'Mini-satellites', 2, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Modularité', 88, '#1B4965');
END $$;

-- ACES-MWL — Power Supply Unit
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'ACES-MWL — Power Supply Unit' AND c.name = 'EREMS') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'ACES-MWL — Power Supply Unit', 'PDU (Power Distribution)', 'Spatial', 'Unité d''alimentation d''EREMS pour le lien micro-ondes (MicroWave Link) du payload ACES, composé d''un segment de vol (MWL-FS) et de ses antennes associées.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'EREMS' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Mission', 'ACES — MicroWave Link (MWL)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Segment', 'Flight Segment (MWL-FS) + antennes', 2, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité (vol habité ISS)', 93, '#1B4965');
END $$;

-- SBS IRIDIUM NEXT — Battery Modules
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'SBS IRIDIUM NEXT — Battery Modules' AND c.name = 'EREMS') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'SBS IRIDIUM NEXT — Battery Modules', 'Batteries & Stockage', 'Spatial', 'Plus de 2 400 modules électroniques d''équilibrage de batteries fournis par EREMS à SAFT pour la constellation Iridium NEXT.', 'Sur devis', '🔋'
  FROM companies c WHERE c.name = 'EREMS' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Volume produit', '> 2 400 modules', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Client', 'SAFT (constellation Iridium NEXT)', 2, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité (production de masse)', 95, '#1B4965');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Volé sur la constellation Iridium NEXT (66+ satellites)');
END $$;

-- PPSU — Plasma Propulsion Selection Unit
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'PPSU — Plasma Propulsion Selection Unit' AND c.name = 'EREMS') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'PPSU — Plasma Propulsion Selection Unit', 'Vannes & Actionneurs', 'Spatial', 'Équipement de vol conçu et développé par EREMS, permettant la commutation de tous les signaux électriques de propulseur et XFC depuis deux unités de conditionnement de puissance (PPU) vers un propulseur.', 'Sur devis', '🔧'
  FROM companies c WHERE c.name = 'EREMS' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fonction', 'Commutation des signaux propulseur/XFC', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Configuration', '2 PPU vers 1 propulseur', 2, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité de commutation', 91, '#1B4965');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'OBC (On-Board Charger)' FROM companies WHERE name = 'EREMS' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'PDU (Power Distribution)' FROM companies WHERE name = 'EREMS' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'DC/DC Converters' FROM companies WHERE name = 'EREMS' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Batteries & Stockage' FROM companies WHERE name = 'EREMS' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Vannes & Actionneurs' FROM companies WHERE name = 'EREMS' LIMIT 1 ON CONFLICT DO NOTHING;
