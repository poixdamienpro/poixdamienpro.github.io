-- ============================================================
-- BUY-INEER -- Lot OBC / Power / Capteurs (VPT, AAC Clyde Space, Terma,
-- DHV Technology, Bradford, + OBC et capteurs trouves via SatNow)
-- Tous les produits sont verifies sur les sites officiels des fabricants
-- ou sur les fiches techniques SatNow (satnow.com).
-- Idempotent.
-- ============================================================

-- ============================================================
-- VPT Inc (Etats-Unis) — Convertisseurs DC/DC spatiaux et militaires
-- Verifie sur vptpower.com
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'VPT Inc', '🇺🇸 États-Unis', 'Blacksburg, Virginie', 'Spatial', 'https://www.vptpower.com', '⚡',
  'Fabricant américain de convertisseurs DC/DC hi-rel pour applications spatiales, avioniques et militaires, qualifiés en tolérance aux radiations (TID, SEE) et aux environnements extrêmes (-55°C à +125°C).',
  TRUE, TRUE, '200+', '1979', 'sales@vptpower.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'VPT Inc');

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'VPT100-2812S' AND c.name = 'VPT Inc') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'VPT100-2812S', 'DC/DC Converters', 'Spatial', 'Convertisseur DC/DC isolé 100W de VPT, entrée 28V, sortie simple 12V, destiné à l''intégration dans des systèmes d''alimentation de satellites et d''équipements avioniques.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'VPT Inc' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension d''entrée', '28 V', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '100 W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension de sortie', '12 V (sortie simple)', 3, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plage de température', '-55°C à +105°C', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse thermique', 90, '#1B4965');
END $$;

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'SGRB12018S' AND c.name = 'VPT Inc') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'SGRB12018S', 'DC/DC Converters', 'Spatial', 'Convertisseur DC/DC haute puissance de VPT, qualifié radiations (TID et SEE), pour applications spatiales nécessitant une forte densité de puissance embarquée.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'VPT Inc' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension d''entrée', '100 V ou 120 V', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '1 600 W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension de sortie', '28 V', 3, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tolérance TID', '100 krad(Si)', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tolérance SEE', '85 MeV/mg/cm²', 5, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Tolérance aux radiations', 96, '#1B4965');
END $$;

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'VXR250-2828S' AND c.name = 'VPT Inc') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'VXR250-2828S', 'DC/DC Converters', 'Spatial', 'Convertisseur DC/DC 250W de VPT, entrée 28V, sortie simple 28V, conçu pour l''intégration dans des systèmes de distribution de puissance avionique et spatiale.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'VPT Inc' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension d''entrée', '28 V', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '250 W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plage de température', '-55°C à +105°C', 3, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Densité de puissance', 88, '#1B4965');
END $$;

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'SVFL2815S' AND c.name = 'VPT Inc') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'SVFL2815S', 'DC/DC Converters', 'Spatial', 'Convertisseur DC/DC 120W de VPT, qualifié radiations, entrée 28V, sortie simple 15V, pour environnement spatial extrême (-55°C à +125°C).', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'VPT Inc' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension d''entrée', '28 V', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '120 W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tolérance TID', '60 krad(Si)', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tolérance SEE', '44 MeV/mg/cm²', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plage de température', '-55°C à +125°C', 5, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Tolérance aux radiations', 90, '#1B4965');
END $$;

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'VSC100-2828S' AND c.name = 'VPT Inc') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'VSC100-2828S', 'DC/DC Converters', 'Spatial', 'Convertisseur DC/DC 100W de VPT, qualifié radiations, entrée et sortie 28V, destiné aux systèmes d''alimentation de satellites en environnement à forte exposition radiative.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'VPT Inc' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension d''entrée/sortie', '28 V / 28 V', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '100 W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tolérance TID', '30 krad(Si)', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tolérance SEE', '42 MeV/mg/cm²', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Tolérance aux radiations', 85, '#1B4965');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'DC/DC Converters' FROM companies WHERE name = 'VPT Inc' LIMIT 1 ON CONFLICT DO NOTHING;

-- ============================================================
-- Terma (Danemark) — Systèmes de puissance et capteurs spatiaux
-- Verifie sur terma.com
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Terma', '🇩🇰 Danemark', 'Lystrup', 'Spatial', 'https://www.terma.com', '🛰️',
  'Industriel danois de l''électronique de défense et spatiale, plus de 50 ans d''expérience dans les systèmes de puissance, star trackers et unités de traitement pour missions ESA (BepiColombo, Euclid, Rosetta, Mars Express, PLATO).',
  TRUE, TRUE, '1 800+', '1949', 'terma.space@terma.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Terma');

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Terma PCDU' AND c.name = 'Terma') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Terma PCDU', 'PDU (Power Distribution)', 'Spatial', 'Power Conditioning and Distribution Unit modulaire de Terma, à architecture scalable jusqu''à 15kW, conçue pour s''intégrer dans des satellites en orbite terrestre, missions GEO ou sondes interplanétaires. Volée sur BepiColombo, Euclid, XMM-Newton, Rosetta, Mars Express, Venus Express et PLATO.', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'Terma' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Capacité de puissance', 'Jusqu''à 15 kW', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bus de distribution', '28V, 50V, 100V (régulé ou non régulé)', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Régulation', 'Sequential Shunt Switching ou Maximum Power Point Tracking', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Missions de référence', 'BepiColombo, Euclid, XMM-Newton, Rosetta, PLATO', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Scalabilité', 95, '#1B4965');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité (5 décennies de vol)', 97, '#1B4965');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol ESA (multiples missions)');
END $$;

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'T1 Star Tracker' AND c.name = 'Terma') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'T1 Star Tracker', 'Capteurs & Instrumentation', 'Spatial', 'Senseur stellaire de Terma basé sur le capteur CMOS Faintstar-2, baffle et caméra séparés pour stabilité thermique optimale, conçu pour les missions à forte exposition radiative (GEO, 15 ans en orbite).', 'Sur devis', '⭐'
  FROM companies c WHERE c.name = 'Terma' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Capteur', 'Faintstar-2 (CMOS Active Pixel Sensor)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Durée de vie', '15 ans en GEO', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Architecture', 'Baffle et caméra séparés + unité de traitement dédiée', 3, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Tolérance aux radiations', 95, '#1B4965');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Plus de 200 satellites en orbite');
END $$;

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'T3 Star Tracker' AND c.name = 'Terma') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'T3 Star Tracker', 'Capteurs & Instrumentation', 'Spatial', 'Senseur stellaire compact de Terma, version réduite du T1, à haute précision et excellente stabilité thermique, conçu pour les missions microsatellites de 5 ans en orbite basse (LEO).', 'Sur devis', '⭐'
  FROM companies c WHERE c.name = 'Terma' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Durée de vie', '5 ans en LEO', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Composants', 'COTS haute fiabilité', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Architecture', 'Système optique réduit, unité de traitement intégrée', 3, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 92, '#1B4965');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Volé sur ESA CryoSat-2');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'PDU (Power Distribution)' FROM companies WHERE name = 'Terma' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Capteurs & Instrumentation' FROM companies WHERE name = 'Terma' LIMIT 1 ON CONFLICT DO NOTHING;

-- ============================================================
-- DHV Technology (Espagne) — Systèmes électriques et PCDU smallsat
-- Verifie sur dhvtechnology.com
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'DHV Technology', '🇪🇸 Espagne', 'Malaga', 'Spatial', 'https://www.dhvtechnology.com', '🔋',
  'Fabricant espagnol de panneaux solaires, systèmes électriques de puissance (EPS) et PCDU pour CubeSats et small satellites, ainsi que de mécanismes d''entraînement de panneaux solaires (SADA).',
  TRUE, TRUE, '50+', '2013', 'enquiry@dhvtechnology.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'DHV Technology');

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'PICO EPS' AND c.name = 'DHV Technology') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'PICO EPS', 'Batteries & Stockage', 'Spatial', 'Système électrique de puissance (Electrical Power System) de DHV Technology conçu pour l''intégration dans des plateformes CubeSat de très petite taille.', 'Sur devis', '🔋'
  FROM companies c WHERE c.name = 'DHV Technology' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plateforme cible', 'CubeSat (format pico)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fonction', 'Distribution et régulation de puissance embarquée', 2, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 90, '#1B4965');
END $$;

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'NANO EPS' AND c.name = 'DHV Technology') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'NANO EPS', 'Batteries & Stockage', 'Spatial', 'Système électrique de puissance (Electrical Power System) de DHV Technology conçu pour l''intégration dans des plateformes CubeSat de format nano.', 'Sur devis', '🔋'
  FROM companies c WHERE c.name = 'DHV Technology' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plateforme cible', 'CubeSat (format nano)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fonction', 'Distribution et régulation de puissance embarquée', 2, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 88, '#1B4965');
END $$;

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'DHV PCDU — Power Conditioning and Distribution System' AND c.name = 'DHV Technology') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'DHV PCDU — Power Conditioning and Distribution System', 'PDU (Power Distribution)', 'Spatial', 'Power Conditioning and Distribution Unit de DHV Technology pour plateformes smallsat, avec fonctions de contrôle de déploiement et de poursuite du point de puissance maximale (MPPT).', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'DHV Technology' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plateforme cible', 'Small satellites', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fonctions', 'Contrôle de déploiement, Maximum Power Point Tracking (MPPT)', 2, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Efficacité de conversion', 90, '#1B4965');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'Batteries & Stockage' FROM companies WHERE name = 'DHV Technology' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'PDU (Power Distribution)' FROM companies WHERE name = 'DHV Technology' LIMIT 1 ON CONFLICT DO NOTHING;

-- ============================================================
-- AAC Clyde Space (Royaume-Uni / Suède) — Avionique et capteurs CubeSat
-- Verifie sur aac-clyde.space et satnow.com
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'AAC Clyde Space', '🇬🇧 Royaume-Uni', 'Glasgow', 'Spatial', 'https://www.aac-clyde.space', '🛰️',
  'Fabricant écossais de sous-systèmes standardisés et miniaturisés pour CubeSats et small satellites (jusqu''à 500kg) : avionique, OBC, PCDU, batteries, capteurs solaires et systèmes de communication.',
  TRUE, TRUE, '150+', '2005', 'info@aac-clyde.space'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'AAC Clyde Space');

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'STARBUCK-MINI PCDU' AND c.name = 'AAC Clyde Space') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'STARBUCK-MINI PCDU', 'PDU (Power Distribution)', 'Spatial', 'Power Conditioning and Distribution Unit d''AAC Clyde Space, utilisée notamment sur le lander lunaire Nova-C du programme NASA CLPS (Commercial Lunar Payload Services).', 'Sur devis', '⚡'
  FROM companies c WHERE c.name = 'AAC Clyde Space' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Mission de référence', 'Nova-C (NASA CLPS, atterrisseur lunaire)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Catégorie', 'PCDU miniaturisée', 2, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité (vol lunaire)', 95, '#1B4965');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Volé sur mission lunaire NASA CLPS');
END $$;

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'SIRIUS OBC LEON3FT' AND c.name = 'AAC Clyde Space') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'SIRIUS OBC LEON3FT', 'OBC (On-Board Charger)', 'Spatial', 'Ordinateur de bord (On-Board Computer) 50MHz d''AAC Clyde Space avec unité de protocole de communication intégrée, destiné aux missions SmallSat en orbite basse (LEO).', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'AAC Clyde Space' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fréquence', '50 MHz', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '0.13 kg', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '3.3 à 16 V', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Consommation', '1.3 W', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tolérance radiations', '20 à 30 krad', 5, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interfaces', 'PCIe, RS-485, UART, SpaceWire', 6, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité (heritage de vol)', 93, '#1B4965');
END $$;

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'SS200' AND c.name = 'AAC Clyde Space') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'SS200', 'Capteurs & Instrumentation', 'Spatial', 'Capteur solaire numérique (Digital Sun Sensor) d''AAC Clyde Space destiné aux CubeSats, à très faible masse et faible consommation.', 'Sur devis', '☀️'
  FROM companies c WHERE c.name = 'AAC Clyde Space' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision', '0.3°', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Champ de vision', '110°', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '3 g', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tolérance radiations', '36 krad (Si)', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Consommation', '2.5 à 40 mW', 5, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision angulaire', 92, '#1B4965');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'PDU (Power Distribution)' FROM companies WHERE name = 'AAC Clyde Space' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'OBC (On-Board Charger)' FROM companies WHERE name = 'AAC Clyde Space' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Capteurs & Instrumentation' FROM companies WHERE name = 'AAC Clyde Space' LIMIT 1 ON CONFLICT DO NOTHING;

-- ============================================================
-- Berlin Space Technologies (Allemagne) — OBC et capteurs solaires
-- Verifie via fiches techniques SatNow
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Berlin Space Technologies', '🇩🇪 Allemagne', 'Berlin', 'Spatial', 'https://www.berlin-space-tech.com', '🛰️',
  'Fabricant allemand de plateformes microsatellites et de sous-systèmes avioniques (ordinateurs de bord, capteurs solaires) pour missions d''observation de la Terre.',
  TRUE, FALSE, '50+', '2014', 'info@berlin-space-tech.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Berlin Space Technologies');

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'OBC-100 & ACC-100' AND c.name = 'Berlin Space Technologies') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'OBC-100 & ACC-100', 'OBC (On-Board Charger)', 'Spatial', 'Ordinateur de bord et processeur auxiliaire de Berlin Space Technologies, fonctionnant sous système d''exploitation Linux, destiné aux missions LEO.', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'Berlin Space Technologies' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Orbite', 'LEO', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '0.87 kg', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interfaces', 'RS-422, PCIe', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Système d''exploitation', 'Linux', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Polyvalence logicielle', 88, '#1B4965');
END $$;

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'FSSA-110' AND c.name = 'Berlin Space Technologies') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'FSSA-110', 'Capteurs & Instrumentation', 'Spatial', 'Fine Sun Sensor Assembly de Berlin Space Technologies, composé de trois capteurs solaires analogiques, destiné à l''intégration dans des systèmes ADCS.', 'Sur devis', '☀️'
  FROM companies c WHERE c.name = 'Berlin Space Technologies' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision', '±5°', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Champ de vision', 'Jusqu''à 114°', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '102 g (avec 3 capteurs)', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tolérance radiations', '20 krad', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Consommation', '185 mW', 5, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité (héritage de vol)', 90, '#1B4965');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'OBC (On-Board Charger)' FROM companies WHERE name = 'Berlin Space Technologies' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Capteurs & Instrumentation' FROM companies WHERE name = 'Berlin Space Technologies' LIMIT 1 ON CONFLICT DO NOTHING;

-- ============================================================
-- ISISPACE (Pays-Bas) — OBC CubeSat
-- Verifie via fiches techniques SatNow
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'ISISPACE', '🇳🇱 Pays-Bas', 'Delft', 'Spatial', 'https://www.isispace.nl', '🛰️',
  'Fabricant néerlandais de sous-systèmes CubeSat flight-proven, dont les ordinateurs de bord IOBC, déployeurs et plateformes nanosatellites.',
  TRUE, FALSE, '50+', '2006', 'info@isispace.nl'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'ISISPACE');

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'IOBC' AND c.name = 'ISISPACE') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'IOBC', 'OBC (On-Board Charger)', 'Spatial', 'Ordinateur de bord flight-proven d''ISISPACE pour CubeSats, à très faible masse et faible consommation, conçu pour l''intégration dans des plateformes nanosatellites.', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'ISISPACE' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '0.094 à 0.10 kg', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '3.3 V', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Consommation', '0.40 W', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interfaces', 'I2C, SPI, UART, RS-422, PCIe, RS-485, RS-232, USB', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité (flight-proven)', 94, '#1B4965');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'OBC (On-Board Charger)' FROM companies WHERE name = 'ISISPACE' LIMIT 1 ON CONFLICT DO NOTHING;

-- ============================================================
-- SPACEMANIC (Slovaquie) — OBC nanosatellites
-- Verifie via fiches techniques SatNow
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'SPACEMANIC', '🇸🇰 Slovaquie', 'Bratislava', 'Spatial', 'https://spacemanic.com', '🛰️',
  'Fabricant slovaque de plateformes et sous-systèmes nanosatellites, dont des ordinateurs de bord ultra-compacts pour CubeSats.',
  TRUE, FALSE, '30+', '2018', 'info@spacemanic.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'SPACEMANIC');

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'SM-OBC-MSP430' AND c.name = 'SPACEMANIC') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'SM-OBC-MSP430', 'OBC (On-Board Charger)', 'Spatial', 'Ordinateur de bord ultra-compact de SPACEMANIC pour CubeSats et nanosatellites, à très faible masse et consommation minimale.', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'SPACEMANIC' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '0.025 kg', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '3.3 à 5 V', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Consommation', '0.1 W', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tolérance radiations', '20 krad', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interfaces', 'I2C, RS-485, UART, CAN, SPI, PWM', 5, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 96, '#1B4965');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'OBC (On-Board Charger)' FROM companies WHERE name = 'SPACEMANIC' LIMIT 1 ON CONFLICT DO NOTHING;

-- ============================================================
-- Argotec (Italie) — OBC deep space
-- Verifie via fiches techniques SatNow
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Argotec', '🇮🇹 Italie', 'Turin', 'Spatial', 'https://www.argotecgroup.com', '🛰️',
  'Fabricant italien de microsatellites et sous-systèmes pour missions deep space, dont l''ordinateur de bord FERMI utilisé sur les missions d''exploration lointaine de la NASA.',
  TRUE, FALSE, '200+', '2008', 'info@argotecgroup.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Argotec');

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'FERMI' AND c.name = 'Argotec') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'FERMI', 'OBC (On-Board Charger)', 'Spatial', 'Ordinateur de bord d''Argotec conçu pour les missions deep space, à forte tolérance radiative, utilisé notamment sur les missions CubeSat lunaires de la NASA (ArgoMoon).', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'Argotec' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Consommation', '5 W', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tolérance radiations', '100 krad', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interfaces', 'RS-422, PCIe, UART, SPI, LVDS, I2C', 3, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Tolérance aux radiations (deep space)', 95, '#1B4965');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'OBC (On-Board Charger)' FROM companies WHERE name = 'Argotec' LIMIT 1 ON CONFLICT DO NOTHING;

-- ============================================================
-- GomSpace (Danemark) — OBC nanosatellites/microsatellites
-- Verifie via fiches techniques SatNow
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'GomSpace', '🇩🇰 Danemark', 'Aalborg', 'Spatial', 'https://gomspace.com', '🛰️',
  'Fabricant danois de sous-systèmes nanosatellites et microsatellites, dont la gamme d''ordinateurs de bord NanoMind, largement utilisée dans l''industrie des smallsats.',
  TRUE, TRUE, '150+', '2007', 'info@gomspace.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'GomSpace');

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'NanoMind A3200' AND c.name = 'GomSpace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'NanoMind A3200', 'OBC (On-Board Charger)', 'Spatial', 'Ordinateur de bord GomSpace de la gamme NanoMind, conçu pour les missions nanosatellites, CubeSat et microsatellites, à très faible consommation.', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'GomSpace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '0.024 kg', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '3.20 à 3.40 V', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Consommation', '0.17 à 0.9 W', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interfaces', 'I2C, CAN, UART, SPI, PWM, USART', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Efficacité énergétique', 93, '#1B4965');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'OBC (On-Board Charger)' FROM companies WHERE name = 'GomSpace' LIMIT 1 ON CONFLICT DO NOTHING;

-- ============================================================
-- D-Orbit (Italie) — OBC pour missions LEO
-- Verifie via fiches techniques SatNow
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'D-Orbit', '🇮🇹 Italie', 'Fino Mornasco', 'Spatial', 'https://www.dorbit.space', '🛰️',
  'Fabricant italien de services de transport orbital (ION) et de sous-systèmes satellites, dont l''ordinateur de bord Simba conforme à la norme ECSS Class-1.',
  TRUE, TRUE, '200+', '2011', 'info@dorbit.space'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'D-Orbit');

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Simba' AND c.name = 'D-Orbit') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Simba', 'OBC (On-Board Charger)', 'Spatial', 'Ordinateur de bord de D-Orbit pour missions en orbite basse (LEO), conforme à la norme ECSS Class-1, destiné à l''intégration dans des plateformes satellites.', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'D-Orbit' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '1.2 kg', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '12 à 28 V', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Consommation', '15 à 80 W', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tolérance radiations', '40 krad', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Norme', 'ECSS Class-1', 5, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Conformité norme spatiale', 95, '#1B4965');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'OBC (On-Board Charger)' FROM companies WHERE name = 'D-Orbit' LIMIT 1 ON CONFLICT DO NOTHING;

-- ============================================================
-- SITAEL (Italie) — Capteurs solaires
-- Verifie via fiches techniques SatNow
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'SITAEL', '🇮🇹 Italie', 'Mola di Bari', 'Spatial', 'https://www.sitael.com', '🛰️',
  'Industriel italien spécialisé dans la propulsion électrique, les plateformes satellites et les capteurs d''attitude pour missions LEO et GEO.',
  TRUE, TRUE, '600+', '1971', 'info@sitael.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'SITAEL');

DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'SITAEL Sun' AND c.name = 'SITAEL') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'SITAEL Sun', 'Capteurs & Instrumentation', 'Spatial', 'Capteur solaire numérique de SITAEL pour orbites LEO et GEO, destiné à l''intégration dans des systèmes de détermination d''attitude (ADCS).', 'Sur devis', '☀️'
  FROM companies c WHERE c.name = 'SITAEL' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision', '0.5°', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Champ de vision', '140°', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '240 g', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension d''alimentation', '12 à 50 V', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interfaces', 'RS-422, CAN, SPI', 5, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision angulaire', 88, '#1B4965');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'Capteurs & Instrumentation' FROM companies WHERE name = 'SITAEL' LIMIT 1 ON CONFLICT DO NOTHING;

-- ============================================================
-- Ajouts sur entreprises déjà existantes
-- ============================================================

-- Kongsberg NanoAvionics — SatBus 3C2 (OBC)
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'SatBus 3C2' AND c.name = 'Kongsberg NanoAvionics') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'SatBus 3C2', 'OBC (On-Board Charger)', 'Spatial', 'Ordinateur de bord de Kongsberg NanoAvionics pour CubeSats et nanosatellites, intégrant un magnétomètre et un gyroscope pour le support de la détermination d''attitude.', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'Kongsberg NanoAvionics' LIMIT 1
  RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plateformes cibles', 'NanoSat, CubeSat, SmallSat', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Capteurs d''attitude intégrés', 'Magnétomètre, gyroscope', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interfaces', 'CAN, SPI, I2C, UART, USB, USART', 3, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Polyvalence d''intégration', 90, '#1B4965');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Héritage de vol confirmé');
END $$;

-- Airbus Defence & Space — Amethyst (OBC)
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Amethyst' AND c.name = 'Airbus Defence & Space') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Amethyst', 'OBC (On-Board Charger)', 'Spatial', 'Ordinateur de bord d''Airbus pour applications satellites globales, conçu pour l''intégration dans des plateformes SmallSat en orbite basse (LEO).', 'Sur devis', '💻'
  FROM companies c WHERE c.name = 'Airbus Defence & Space' LIMIT 1
  RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '3.5 kg', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '22 à 38 V (5V secondaire)', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Consommation', '20 à 50 W', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interfaces', 'Ethernet, SpaceWire, RS-422, PCIe', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Capacité de traitement', 92, '#1B4965');
END $$;

-- Bradford ECAPS — Mini Fine Sun Sensor (Mini-FSS)
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Mini Fine Sun Sensor (Mini-FSS)' AND c.name = 'Bradford ECAPS') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Mini Fine Sun Sensor (Mini-FSS)', 'Capteurs & Instrumentation', 'Spatial', 'Capteur solaire analogique de Bradford mesurant l''angle d''aspect solaire sur deux axes via un détecteur à quadrants, destiné à l''intégration dans des systèmes ADCS de small satellites.', 'Sur devis', '☀️'
  FROM companies c WHERE c.name = 'Bradford ECAPS' LIMIT 1
  RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision', '±0.2 à 1.5°', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Champ de vision nominal', '128 x 128°', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '50 g', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Capteur solaire analogique (détecteur à quadrants)', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision angulaire', 90, '#1B4965');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Héritage de vol confirmé');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'OBC (On-Board Charger)' FROM companies WHERE name = 'Kongsberg NanoAvionics' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'OBC (On-Board Charger)' FROM companies WHERE name = 'Airbus Defence & Space' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Capteurs & Instrumentation' FROM companies WHERE name = 'Bradford ECAPS' LIMIT 1 ON CONFLICT DO NOTHING;
