-- ============================================================
-- BUY-INEER -- ACTIA Aerospace (France) — électronique embarquée spatiale
-- Verifie sur le catalogue produit officiel ACTIA Aerospace
-- (CATALOGUE-PRODUIT-AEROSPACE-EN-HD.pdf) et aerospace.actia.com
-- NOTE : steel-electronique.com redirige integralement vers
-- aerospace.actia.com. STEEL Electronique est la filiale historique
-- (40+ ans d'experience) desormais integree a ACTIA Aerospace, qui
-- conserve sa marque pour les produits electroniques embarques —
-- pas une entite separee avec son propre catalogue.
-- Idempotent.
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'ACTIA Aerospace', '🇫🇷 France', 'Toulouse', 'Spatial', 'https://aerospace.actia.com', '🛰️',
  'Division spatiale et aéronautique du groupe ACTIA (Toulouse), héritière des 40+ ans d''expérience de sa filiale STEEL Electronique. 300 employés, 81.7M€ de chiffre d''affaires (2025), plus de 2 500 équipements spatiaux en orbite et plus de 100 missions spatiales : ordinateurs de bord, unités de traitement de charge utile, mémoires de masse, convertisseurs DC/DC et récepteurs GNSS.',
  TRUE, TRUE, '300', '1986', 'contact@actia-aerospace.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'ACTIA Aerospace');

-- M-OBC
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'M-OBC' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'M-OBC', 'OBC (On-Board Charger)', 'Spatial', 'Module de traitement haute performance et flexible d''ACTIA Aerospace, principalement conçu pour les CubeSats et nanosatellites. Au-delà du cœur de traitement, l''unité M-OBC offre une large gamme d''interfaces AOCS et est hautement configurable pour des applications sur mesure.', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cœur de traitement', 'Zynq 7030 ou 7045, 1GB DDR3 (512MB avec protection ECC)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Mémoire', '16MB QSPI (boot), 1GB NVM, 32GB mémoire de masse, 256kB FRAM', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Architecture', '1 carte CPU principale + 1 carte d''interface personnalisable', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Format', 'Fond de panier standard PC104', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interfaces', 'RS422, LVDS/SpW, entrées analogiques, thermistances, sorties PWM, pont en H, distribution de puissance', 5, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Flexibilité de configuration', 92, '#1B4965');
END $$;

-- HYPERION
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'HYPERION' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'HYPERION', 'OBC (On-Board Charger)', 'Spatial', 'Ordinateur avionique intégré à bas coût d''ACTIA Aerospace, disponible en version froide-redondante ou en version simple flux pour les missions à coût réduit (sans redondance).', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cœur de traitement', 'Zynq 7100, 1GB DDR3 (512MB EDAC)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Redondance', 'Unité de supervision et reconfiguration tolérante aux radiations', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bus d''alimentation primaire', 'Non régulé, 20-40V', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interfaces', 'MIL-BUS 1553A/B, RS422, CAN bus, SpaceWire, LVDS, SerDes (GTX)', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Rapport coût/performance', 88, '#1B4965');
END $$;

-- NINANO
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'NINANO' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'NINANO', 'OBC (On-Board Charger)', 'Spatial', 'Ordinateur de bord au format PC104 d''ACTIA Aerospace, multi-applications : calculateur central nanosatellite, traitement de données de charge utile, gestion d''instrument.', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cœur de traitement', 'Zynq 7030', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'RAM', '1GB DDR3 (512MB avec ECC)', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Mémoire non volatile', '8Kbyte FRAM, 16MB QSPI, 8/128Gbits NAND flash', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interfaces', 'I2C, UART, CAN bus, SpaceWire, LVDS, RS422', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Polyvalence multi-applications', 90, '#1B4965');
END $$;

-- COMODO
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'COMODO' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'COMODO', 'OBC (On-Board Charger)', 'Spatial', 'Gamme de Computer-On-Modules d''ACTIA Aerospace basée sur différents Systems-On-Chip : COMODO-U avec la technologie européenne durcie aux radiations NG-Ultra de NanoXplore, COMODO-V avec le composant Versal d''AMD/Xilinx. Destiné à l''intégration sur carte mère pour applications sur mesure (OBC, traitement de données de charge utile).', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Variantes', 'COMODO-U (NG-Ultra, NanoXplore), COMODO-V (Versal, AMD/Xilinx)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Format', 'Carte de format carte de crédit', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Alimentation', 'Tension unique 5V', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Intégration', '3 connecteurs haute densité, montage sur carte mère', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Souveraineté technologique (NG-Ultra)', 93, '#1B4965');
END $$;

-- ICU
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'ICU — Instrument Control Unit' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'ICU — Instrument Control Unit', 'OBC (On-Board Charger)', 'Spatial', 'Unité de contrôle d''instrument/charge utile d''ACTIA Aerospace, à architecture modulaire combinant modules standards sur étagère (cartes à héritage de vol) et matériel personnalisé selon l''instrument à piloter.', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Composants', 'Convertisseurs DC/DC, module processeur, traitement numérique FPGA', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interfaces de communication', '1553, SpaceWire, CAN, UART, SerDes', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fonction', 'Distribution de puissance intégrée', 3, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Adaptabilité par instrument', 90, '#1B4965');
END $$;

-- DREAM
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'DREAM' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'DREAM', 'Capteurs & Instrumentation', 'Spatial', 'Instrument DREAM (Miniaturized and Adaptable Energy Radiation Detector) d''ACTIA Aerospace, basé sur des détecteurs à diode silicium, capable de mesurer l''énergie des protons entre 13 et 200 MeV et des électrons de 350 keV à 3 MeV.', 'Sur devis', '☢️'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '< 400 g', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Volume', '< 0.6U (55x100x100 mm³)', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '5V / 2.5 W', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plage de mesure', 'Protons 13-200 MeV, électrons 350 keV-3 MeV', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Performance', '256 canaux d''énergie, forme d''onde numérisée', 5, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 94, '#1B4965');
END $$;

-- EGCU
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'EGCU' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'EGCU', 'OBC (On-Board Charger)', 'Spatial', 'Unité de contrôle ACTIA Aerospace à processeur Zynq dual-core avec matrice FPGA puissante, intégrant le contrôle thermique et la distribution de puissance pour la gestion de charge utile.', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cœur de traitement', 'Zynq 7030/7045 dual-core (125K / 350K cellules FPGA)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Mémoire', '1GB DDR3 (512MB ECC), 1GB NVM, 32GB stockage, 256kB FRAM', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension d''entrée', '13-17V', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interfaces', 'Jusqu''à 6 SpaceWire, LVDS, RS422', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fonctions additionnelles', 'Contrôle thermique, distribution de puissance', 5, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Capacité FPGA', 91, '#1B4965');
END $$;

-- CCE — Cryocooler Electronics
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'CCE — Cryocooler Electronics' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'CCE — Cryocooler Electronics', 'Vannes & Actionneurs', 'Spatial', 'Unité électronique d''ACTIA Aerospace utilisée pour piloter et contrôler un refroidisseur cryogénique, afin de maintenir un détecteur à température cryogénique. La CCE peut piloter des cryorefroidisseurs compacts à tube à impulsions (ex. refroidisseur LPT6510 de Thales Cryogenics).', 'Sur devis', '🧊'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension d''entrée', '26 à 42 VDC', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance de sortie', 'Jusqu''à 90W AC', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Stabilité de régulation', '25 mK', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plage de température opérationnelle', '-40°C à +50°C', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interface', 'UART RS422, CAN (option)', 5, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Stabilité de régulation thermique', 96, '#1B4965');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Isolation galvanique complète');
END $$;

-- MYR-EV/SWOT
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'MYR-EV/SWOT' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'MYR-EV/SWOT', 'OBC (On-Board Charger)', 'Spatial', 'Unité de mémoire de masse de charge utile d''ACTIA Aerospace, à architecture modulaire permettant redondance et interfaces personnalisées. Volée sur la mission SWOT (Surface Water and Ocean Topography).', 'Sur devis', '💾'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Capacité', '2 Tbits (1 module), évolutif jusqu''à 8 Tbits (4 modules)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Débit de données', '300-400 Mbps', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'TM/TC', '1553, SpaceWire, UART, CAN', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Protection des données', 'ECC, formatage CCSDS', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Qualité composants', 'ECSS classe 2 ou 3', 5, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Scalabilité de capacité', 92, '#1B4965');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Volé sur mission SWOT (NASA/CNES)');
END $$;

-- FURY
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'FURY' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'FURY', 'OBC (On-Board Charger)', 'Spatial', 'Système haute performance de mémoire de masse et de traitement d''ACTIA Aerospace, conforme à la norme ESA ADHA (format cPCI Serial Space 3U-extended), à concept modulaire et flexible pour applications de mémoire de masse et de traitement de données de charge utile (PDHU).', 'Sur devis', '💾'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Format', 'ESA ADHA-compliant, cPCI Serial Space 3U-extended', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Capacité mémoire de masse (par module)', '20 Tbits', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Débit (par module)', '8 Gbps (4 Gbps entrée, 4 Gbps sortie)', 3, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interfaces', 'HSSL, LVDS, RS422, CAN, SpaceWire, GPIO', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Système de fichiers', 'ESA SAVOIR File Management System', 5, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Qualité composants', 'ECSS classe 2 ou 3', 6, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Débit de traitement', 95, '#1B4965');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Conforme standard ESA ADHA');
END $$;

-- STRELLAN
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'STRELLAN' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'STRELLAN', 'Capteurs & Instrumentation', 'Spatial', 'Récepteur GNSS multi-constellation et multi-canal d''ACTIA Aerospace, renforcé par un système de synchronisation temporelle par détermination d''orbite. Compatible plateformes LEO/MEO, conforme volume CubeSat.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision de position', 'Jusqu''à 1 m', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision de vitesse', 'Jusqu''à 20 mm/s', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision temporelle', '20 ns', 3, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Constellations supportées', 'GALILEO, GPS, GLONASS, Beidou, QZSS, NavIC', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Robustesse', 'Mode holdover, anti-jamming & anti-spoofing', 5, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interface', 'CAN / UART, mono ou double antenne', 6, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision de positionnement', 96, '#1B4965');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Conforme standard ESA TMTC PUS');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'OBC (On-Board Charger)' FROM companies WHERE name = 'ACTIA Aerospace' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Capteurs & Instrumentation' FROM companies WHERE name = 'ACTIA Aerospace' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Vannes & Actionneurs' FROM companies WHERE name = 'ACTIA Aerospace' LIMIT 1 ON CONFLICT DO NOTHING;
