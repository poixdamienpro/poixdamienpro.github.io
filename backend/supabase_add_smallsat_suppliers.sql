-- ============================================================
-- BUY-INEER -- Fournisseurs de composants smallsat / CubeSat
-- Entreprises identifiees via satsearch.co, produits verifies
-- directement sur le site officiel de chaque fabricant.
-- A executer dans Supabase : SQL Editor -> New query -> Run
-- Idempotent : peut etre relance sans creer de doublons.
-- ============================================================

-- ============ ENTREPRISES ============

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'CubeSpace', '🇿🇦 Afrique du Sud', 'Stellenbosch', 'Spatial', 'https://www.cubespace.co.za', '🧭', 'Specialiste sud-africain des systemes ADCS (controle d''attitude) pour CubeSats et SmallSats : roues de reaction, magnetorqueurs, capteurs solaires, star trackers.', TRUE, FALSE, '50+', '2014', 'sales@cubespace.co.za'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'CubeSpace');

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'NewSpace Systems', '🇿🇦 Afrique du Sud', 'Le Cap', 'Spatial', 'https://www.newspacesystems.com', '🛰️', 'Fabricant sud-africain de composants ADCS et RF pour petits satellites : capteurs solaires, roues de reaction, magnetorqueurs, recepteurs GPS, antennes.', TRUE, FALSE, '50+', '2013', 'info@newspacesystems.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'NewSpace Systems');

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Oxford Space Systems', '🇬🇧 Royaume-Uni', 'Harwell', 'Spatial', 'https://oxford.space', '📡', 'Leader des antennes deployables pour l''espace : conceptions Helical, Wrapped Rib, Yagi pour reduire masse et volume de rangement.', TRUE, FALSE, '50+', '2013', 'info@oxford.space'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Oxford Space Systems');

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Kongsberg NanoAvionics', '🇱🇹 Lituanie', 'Vilnius', 'Spatial', 'https://nanoavionics.com', '🛰️', 'Fabricant de plateformes satellites standardisees CubeSat et microsatellite. Plus de 60 satellites lances, plus de 300 en production.', TRUE, TRUE, '200+', '2014', 'info@nanoavionics.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Kongsberg NanoAvionics');

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Solar MEMS Technologies', '🇪🇸 Espagne', 'Séville', 'Spatial', 'https://www.solar-mems.com', '☀️', 'Specialiste espagnol des capteurs solaires et star trackers miniaturises pour petits satellites, base sur la technologie MEMS.', TRUE, FALSE, '30+', '2008', 'info@solar-mems.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Solar MEMS Technologies');

-- ============ PRODUITS ============

-- Roue de réaction CW0500 (CubeSpace)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Roue de réaction CW0500' AND c.name = 'CubeSpace') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Roue de réaction CW0500', 'Vannes & Actionneurs', 'Spatial', 'Roue de reaction robuste a moteur CW0500 maison, pour CubeSats et SmallSats. Equilibrage laser automatise, blindage magnetique integre.', 'Sur devis', '🧭'
  FROM companies c WHERE c.name = 'CubeSpace' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '840 g', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tenue aux chocs', 'Testée (qualifiée vol)', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Vibrations aléatoires', '7 g RMS', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tolérance radiation', '13 kRad', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Délai de production', '6 semaines', 5, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse', 92, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision micro-vibration', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Blindage magnétique mu-métal');
END $$;

-- Fine Sun Sensor (CubeSpace)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Fine Sun Sensor' AND c.name = 'CubeSpace') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Fine Sun Sensor', 'Capteurs & Instrumentation', 'Spatial', 'Capteur solaire fin haute precision pour determination d''attitude sur CubeSats et SmallSats.', 'Sur devis', '🧭'
  FROM companies c WHERE c.name = 'CubeSpace' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Capteur solaire fin', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Format', 'Compact CubeSat', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision', 'Haute précision', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 90, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 92, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- NSS Sun Sensor (NewSpace Systems)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'NSS Sun Sensor' AND c.name = 'NewSpace Systems') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'NSS Sun Sensor', 'Capteurs & Instrumentation', 'Spatial', 'Capteur solaire robuste et eprouve en vol pour la determination d''attitude des petits satellites.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'NewSpace Systems' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Capteur solaire', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Robustesse', 'Éprouvé en vol', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Application', 'Détermination d''attitude', 3, FALSE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité en vol', 93, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- NSS Magnetorquer Rod (NewSpace Systems)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'NSS Magnetorquer Rod' AND c.name = 'NewSpace Systems') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'NSS Magnetorquer Rod', 'Vannes & Actionneurs', 'Spatial', 'Magnetorqueur a barreau pour desaturation des roues de reaction et controle d''attitude basse puissance.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'NewSpace Systems' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Magnetorqueur à barreau', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Usage', 'Désaturation roues de réaction', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Consommation', 'Basse puissance', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité', 91, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Simplicité d''intégration', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- Helical — Antenne déployable (Oxford Space Systems)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Helical — Antenne déployable' AND c.name = 'Oxford Space Systems') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Helical — Antenne déployable', 'Communication & RF', 'Spatial', 'Antenne helicoidale deployable pour petits satellites, optimisee pour minimiser la masse et le volume de rangement.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'Oxford Space Systems' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Antenne hélicoïdale déployable', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Conception', 'Minimisation masse/volume', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Application', 'Communication smallsat', 3, FALSE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité au rangement', 94, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Légèreté', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- Wrapped Rib — Réflecteur déployable (Oxford Space Systems)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Wrapped Rib — Réflecteur déployable' AND c.name = 'Oxford Space Systems') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Wrapped Rib — Réflecteur déployable', 'Communication & RF', 'Spatial', 'Reflecteur a nervures enroulees (Wrapped Rib) pour grandes antennes deployables haute performance.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'Oxford Space Systems' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Réflecteur déployable Wrapped Rib', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Performance', 'Haute performance RF', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Stockage', 'Très compact replié', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité au rangement', 96, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Performance RF', 92, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- M6P — Plateforme CubeSat 6U (Kongsberg NanoAvionics)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'M6P — Plateforme CubeSat 6U' AND c.name = 'Kongsberg NanoAvionics') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'M6P — Plateforme CubeSat 6U', 'Plateformes satellites', 'Spatial', 'Plateforme CubeSat 6U standardisee et flight-proven, disponible en configurations Light, Mid et Max selon les besoins de mission.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Kongsberg NanoAvionics' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Format', '6U CubeSat', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Configurations', 'Light / Mid / Max', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Héritage', '> 60 satellites lancés', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Flight heritage', 93, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Modularité', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- M12P — Plateforme CubeSat 12U (Kongsberg NanoAvionics)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'M12P — Plateforme CubeSat 12U' AND c.name = 'Kongsberg NanoAvionics') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'M12P — Plateforme CubeSat 12U', 'Plateformes satellites', 'Spatial', 'Plateforme CubeSat 12U standardisee pour missions necessitant plus de capacite charge utile, meme architecture modulaire que la gamme M.', 'Sur devis', '🛰️'
  FROM companies c WHERE c.name = 'Kongsberg NanoAvionics' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Format', '12U CubeSat', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Configurations', 'Light / Mid / Max', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Production', '> 300 satellites en production', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Flight heritage', 92, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Capacité charge utile', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- FDSS — Fine Digital Sun Sensor (Solar MEMS Technologies)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'FDSS — Fine Digital Sun Sensor' AND c.name = 'Solar MEMS Technologies') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'FDSS — Fine Digital Sun Sensor', 'Capteurs & Instrumentation', 'Spatial', 'Capteur solaire fin numerique haute precision pour la determination d''attitude de satellites en LEO/MEO/GEO.', 'Sur devis', '☀️'
  FROM companies c WHERE c.name = 'Solar MEMS Technologies' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Capteur solaire fin numérique', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interface', 'Numérique', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Orbites', 'LEO / MEO / GEO', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 93, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- MicroST — Star Tracker nanosatellites (Solar MEMS Technologies)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'MicroST — Star Tracker nanosatellites' AND c.name = 'Solar MEMS Technologies') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'MicroST — Star Tracker nanosatellites', 'Capteurs & Instrumentation', 'Spatial', 'Star tracker miniaturise specifiquement concu pour les contraintes de masse et de volume des nanosatellites.', 'Sur devis', '☀️'
  FROM companies c WHERE c.name = 'Solar MEMS Technologies' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Star tracker miniaturisé', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cible', 'Nanosatellites', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Technologie', 'MEMS', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 90, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 95, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- ============ CATÉGORIES PRODUITS (filtres annuaire) ============

INSERT INTO company_product_categories (company_id, category) SELECT id, 'Vannes & Actionneurs' FROM companies WHERE name = 'CubeSpace' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Capteurs & Instrumentation' FROM companies WHERE name = 'CubeSpace' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Capteurs & Instrumentation' FROM companies WHERE name = 'NewSpace Systems' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Vannes & Actionneurs' FROM companies WHERE name = 'NewSpace Systems' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Communication & RF' FROM companies WHERE name = 'Oxford Space Systems' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Plateformes satellites' FROM companies WHERE name = 'Kongsberg NanoAvionics' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Capteurs & Instrumentation' FROM companies WHERE name = 'Solar MEMS Technologies' LIMIT 1 ON CONFLICT DO NOTHING;