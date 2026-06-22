-- ============================================================
-- BUY-INEER -- Fournisseurs francais du spatial
-- Produits verifies directement sur le site officiel de chaque
-- fabricant (et non sur satsearch.co, bloque par Cloudflare).
-- A executer dans Supabase : SQL Editor -> New query -> Run
-- Idempotent : peut etre relance sans creer de doublons.
-- ============================================================

-- ============ ENTREPRISES ============

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Exotrail', '🇫🇷 France', 'Massy', 'Spatial', 'https://www.exotrail.com', '🚀', 'Fournisseur francais de systemes de propulsion electrique (effet Hall) pour satellites. Plus de 150 unites commandees, vendu dans 19 pays.', TRUE, TRUE, '150+', '2017', 'contact@exotrail.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Exotrail');

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Anywaves', '🇫🇷 France', 'Toulouse', 'Spatial', 'https://www.anywaves.com', '📡', 'Specialiste francais des antennes spatiales compactes et de l''electronique RF pour satellites : TT&C, telemetrie payload, navigation.', TRUE, FALSE, '100+', '2016', 'contact@anywaves.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Anywaves');

-- ============ PRODUITS ============

-- spaceware-nano (Exotrail)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'spaceware-nano' AND c.name = 'Exotrail') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'spaceware-nano', 'Vannes & Actionneurs', 'Spatial', 'Propulseur a effet Hall classe 60W, compact et flexible, specifiquement developpe pour etre integre dans des CubeSats (10 a 80 kg).', 'Sur devis', '🚀'
  FROM companies c WHERE c.name = 'Exotrail' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Poussée', '2,5 mN', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '60 W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Impulsion totale', 'Jusqu''à 6 kN·s', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cycles ON/OFF', '3 000', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Durée de vie', '5 ans en orbite', 5, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Propergol', 'Xénon', 6, FALSE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 95, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Flexibilité d''intégration', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- spaceware-mini (Exotrail)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'spaceware-mini' AND c.name = 'Exotrail') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'spaceware-mini', 'Vannes & Actionneurs', 'Spatial', 'Propulseur a effet Hall classe 400W multi-propergol (Xenon et Krypton), conçu comme base pour les constellations de petits satellites.', 'Sur devis', '🚀'
  FROM companies c WHERE c.name = 'Exotrail' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Poussée', '12–32 mN', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '300–600 W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Impulsion totale', 'Jusqu''à 450 kN·s', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cycles ON/OFF', '11 000', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Durée de vie', '7 ans en orbite', 5, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Propergol', 'Xénon / Krypton', 6, FALSE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Puissance', 90, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Polyvalence propergol', 92, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- Antenne compacte de télémesure payload bande X (Anywaves)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Antenne compacte de télémesure payload bande X' AND c.name = 'Anywaves') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Antenne compacte de télémesure payload bande X', 'Communication & RF', 'Spatial', 'Antenne compacte bande X pour la telemesure de charge utile sur satellites, conception optimisee pour l''integration smallsat.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'Anywaves' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande', 'X', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Application', 'Télémesure payload', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Conception', 'Compacte, intégration smallsat', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 93, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Performance RF', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- Antenne TT&C (Anywaves)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Antenne TT&C' AND c.name = 'Anywaves') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Antenne TT&C', 'Communication & RF', 'Spatial', 'Antenne pour les fonctions de telemetrie, suivi et telecommande (TT&C) de satellites, gamme compacte pour petites plateformes.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'Anywaves' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fonction', 'TT&C (Telemetry, Tracking & Command)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Conception', 'Compacte', 2, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité en vol', 90, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 92, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Qualifié vol');
END $$;

-- ============ CATÉGORIES PRODUITS (filtres annuaire) ============

INSERT INTO company_product_categories (company_id, category) SELECT id, 'Vannes & Actionneurs' FROM companies WHERE name = 'Exotrail' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Communication & RF' FROM companies WHERE name = 'Anywaves' LIMIT 1 ON CONFLICT DO NOTHING;