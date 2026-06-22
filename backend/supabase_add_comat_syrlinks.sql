-- ============================================================
-- BUY-INEER -- Comat et Syrlinks (fournisseurs francais du spatial)
-- Comat verifie sur comat.space ; Syrlinks verifie via Wayback
-- Machine (site officiel redirige desormais vers Safran).
-- A executer dans Supabase : SQL Editor -> New query -> Run
-- Idempotent : peut etre relance sans creer de doublons.
-- ============================================================

-- ============ ENTREPRISES ============

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Comat', '🇫🇷 France', 'Flourens (Toulouse)', 'Spatial', 'https://comat.space', '🛠️', 'Equipementier francais specialise dans les mecanismes spatiaux complexes : roues de reaction, SADM, structures deployables. 45 ans d''expertise, leader europeen sur son segment.', TRUE, FALSE, '100+', '1979', 'contact@comat.space'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Comat');

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Syrlinks', '🇫🇷 France', 'Cesson-Sevigne', 'Spatial', 'https://www.syrlinks.com', '📡', 'Fabricant francais d''equipements de radiocommunication RF pour petits et moyens satellites LEO, et de solutions temps-frequence. Filiale de Safran Electronics & Defense depuis 2022.', TRUE, FALSE, '150+', '1994', 'contact@syrlinks.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Syrlinks');

-- ============ PRODUITS ============

-- Roue de réaction RW40 (Comat)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Roue de réaction RW40' AND c.name = 'Comat') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Roue de réaction RW40', 'Vannes & Actionneurs', 'Spatial', 'Roue de reaction Comat, seule roue de reaction nanosat qualifiee pour 8 ans d''operation en orbite, offrant une mission tres sure aux maitres d''oeuvre satellites.', 'Sur devis', '🛠️'
  FROM companies c WHERE c.name = 'Comat' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Application', 'Nanosatellites', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Durée de vie qualifiée', '8 ans en orbite', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Particularité', 'Seule roue nanosat qualifiée 8 ans', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité en vol', 97, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durée de vie', 96, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- SADM — Mécanisme d'entraînement panneaux solaires (Comat)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'SADM — Mécanisme d''entraînement panneaux solaires' AND c.name = 'Comat') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'SADM — Mécanisme d''entraînement panneaux solaires', 'Vannes & Actionneurs', 'Spatial', 'Mecanisme d''entrainement de panneaux solaires (Solar Array Drive Mechanism) developpe par Comat, en cours de pre-qualification dans le cadre du plan France 2030.', 'Sur devis', '🛠️'
  FROM companies c WHERE c.name = 'Comat' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Mécanisme rotatif panneaux solaires', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Programme', 'France 2030 (pré-qualification)', 2, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse', 90, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'En cours de qualification');
END $$;

-- NANOBOOM — Mât déployable (Comat)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'NANOBOOM — Mât déployable' AND c.name = 'Comat') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'NANOBOOM — Mât déployable', 'Vannes & Actionneurs', 'Spatial', 'Mat deployable compact NANOBOOM pour applications nanosatellites, conception en bloc de construction reutilisable.', 'Sur devis', '🛠️'
  FROM companies c WHERE c.name = 'Comat' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Mât déployable', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cible', 'Nanosatellites', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Conception', 'Building block réutilisable', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité au rangement', 93, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Légèreté', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- Antenne déployable nanosatellite (Comat)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Antenne déployable nanosatellite' AND c.name = 'Comat') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Antenne déployable nanosatellite', 'Communication & RF', 'Spatial', 'Antenne deployable concue et assemblee par Comat pour la mission IoT du nanosatellite Kineis, garantissant la communication en orbite.', 'Sur devis', '🛠️'
  FROM companies c WHERE c.name = 'Comat' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Antenne déployable', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Référence programme', 'Kinéis (IoT)', 2, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité en vol', 92, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- EWC31-NG — Émetteur-récepteur bande S (Syrlinks)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'EWC31-NG — Émetteur-récepteur bande S' AND c.name = 'Syrlinks') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'EWC31-NG — Émetteur-récepteur bande S', 'Communication & RF', 'Spatial', 'Nouvelle generation d''emetteur-recepteur bande S de Syrlinks pour satellites LEO (mini, micro, cube/nanosatellites), conception miniaturisee basse consommation.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'Syrlinks' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande', 'S', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Application', 'Mini/Micro/Cube/Nanosatellites LEO', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Conception', 'Miniaturisée, basse consommation', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 92, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Faible consommation', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- MMA — Micro Horloge Atomique (Syrlinks)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'MMA — Micro Horloge Atomique' AND c.name = 'Syrlinks') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'MMA — Micro Horloge Atomique', 'Capteurs & Instrumentation', 'Spatial', 'Micro horloge atomique basse consommation de Syrlinks, offrant un compromis unique entre haute stabilite temps-frequence et faible consommation.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'Syrlinks' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Micro horloge atomique', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Consommation', 'Basse consommation', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Stabilité', 'Haute stabilité temps-fréquence', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Stabilité', 95, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Faible consommation', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- ============ CATÉGORIES PRODUITS (filtres annuaire) ============

INSERT INTO company_product_categories (company_id, category) SELECT id, 'Vannes & Actionneurs' FROM companies WHERE name = 'Comat' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Communication & RF' FROM companies WHERE name = 'Comat' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Communication & RF' FROM companies WHERE name = 'Syrlinks' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Capteurs & Instrumentation' FROM companies WHERE name = 'Syrlinks' LIMIT 1 ON CONFLICT DO NOTHING;