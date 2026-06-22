-- ============================================================
-- BUY-INEER -- ACTIA Aerospace — segment SatCom (amplificateurs RF sol)
-- Complement a supabase_add_actia_aerospace.sql (qui ne couvrait que
-- le segment Space). Verifie sur le catalogue produit officiel
-- ACTIA Aerospace (CATALOGUE-PRODUIT-AEROSPACE-EN-HD.pdf).
-- Idempotent. Necessite que la societe 'ACTIA Aerospace' existe deja
-- (cf. supabase_add_actia_aerospace.sql) ou la recree si absente.
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'ACTIA Aerospace', '🇫🇷 France', 'Toulouse', 'Spatial', 'https://aerospace.actia.com', '🛰️',
  'Division spatiale et aéronautique du groupe ACTIA (Toulouse), héritière des 40+ ans d''expérience de sa filiale STEEL Electronique. 300 employés, 81.7M€ de chiffre d''affaires (2025), plus de 2 500 équipements spatiaux en orbite et plus de 100 missions spatiales : ordinateurs de bord, unités de traitement de charge utile, mémoires de masse, convertisseurs DC/DC et récepteurs GNSS.',
  TRUE, TRUE, '300', '1986', 'contact@actia-aerospace.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'ACTIA Aerospace');

-- ASH100X / ASH150X — Outdoor SSPA X-band
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'ASH100X / ASH150X' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'ASH100X / ASH150X', 'Amplificateurs RF', 'Télécommunications', 'Amplificateur SSPA extérieur bande X (7.9-8.4 GHz) d''ACTIA Aerospace, 100W ou 150W, conception robuste pour environnements difficiles, conforme MIL-STD-188-164C.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande', 'X-band (7.9-8.4 GHz)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '100W ou 150W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'SSPA extérieur', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Contrôle', 'RS485 et IP distant', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse environnementale', 90, '#1B4965');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-188-164C');
END $$;

-- ASR250X — Indoor SSPA X-band
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'ASR250X' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'ASR250X', 'Amplificateurs RF', 'Télécommunications', 'Amplificateur SSPA intérieur bande X (7.9-8.4 GHz) d''ACTIA Aerospace, 250W, technologie GaN, châssis compact monté en rack avec interface tactile.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande', 'X-band (7.9-8.4 GHz)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '250W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Technologie', 'GaN', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interfaces', '2 interfaces de supervision et contrôle', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 88, '#1B4965');
END $$;

-- ASM600X — Outdoor SSPB X-band
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'ASM600X' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'ASM600X', 'Amplificateurs RF', 'Télécommunications', 'Amplificateur SSPB extérieur bande X (7.9-8.4 GHz) d''ACTIA Aerospace, 600W, technologie GaAs multi-porteuse, avec redondance intégrée 3+1 de l''alimentation.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande', 'X-band (7.9-8.4 GHz)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '600W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Technologie', 'GaAs multi-porteuse', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Redondance', 'Préamplificateur/convertisseur redondants, alimentation 3+1', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité (redondance)', 93, '#1B4965');
END $$;

-- ASM1200X — Indoor SSPA X-band
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'ASM1200X' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'ASM1200X', 'Amplificateurs RF', 'Télécommunications', 'Amplificateur SSPA intérieur bande X (7.9-8.4 GHz) d''ACTIA Aerospace, 1200W, technologie GaN, refroidissement liquide haute performance.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande', 'X-band (7.9-8.4 GHz)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '1200W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Technologie', 'GaN', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Refroidissement', 'Liquide haute performance', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Densité de puissance', 95, '#1B4965');
END $$;

-- ATR2500X — Indoor TWTA X-band
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'ATR2500X' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'ATR2500X', 'Amplificateurs RF', 'Télécommunications', 'Amplificateur TWTA intérieur bande X (7.9-8.4 GHz) d''ACTIA Aerospace, 2500W, architecture 2 tiroirs (RF + alimentation) pour intégration et maintenance facilitées, refroidissement par air avec moteur brushless.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande', 'X-band (7.9-8.4 GHz)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '2500W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Architecture', '2 tiroirs (RF + alimentation)', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Refroidissement', 'Air, moteur brushless haute fiabilité', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Puissance maximale', 97, '#1B4965');
END $$;

-- ATH400KU / ATH400KU-LIN — Outdoor TWTA Ku-band
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'ATH400KU / ATH400KU-LIN' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'ATH400KU / ATH400KU-LIN', 'Amplificateurs RF', 'Télécommunications', 'Amplificateur TWTA extérieur bande Ku (12.75-14.5 GHz) d''ACTIA Aerospace, 400W, fonctionnement multi-porteuse large bande, châssis bas profil pour montage facile sur antenne, version avec linéariseur intégré disponible.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande', 'Ku-band (12.75-14.5 GHz)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '400W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Option', 'Linéariseur intégré (version -LIN)', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Contrôle', 'Interface web avancée pour contrôle distant', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse climatique', 92, '#1B4965');
END $$;

-- ATR400KU — Indoor TWTA Ku-band
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'ATR400KU' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'ATR400KU', 'Amplificateurs RF', 'Télécommunications', 'Amplificateur TWTA intérieur bande Ku (12.75-14.5 GHz) d''ACTIA Aerospace, 400W, châssis compact monté en rack, options linéariseur intégral et convertisseur de fréquence montante bande L.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande', 'Ku-band (12.75-14.5 GHz)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '400W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Options', 'Linéariseur intégral, convertisseur bande L', 3, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 88, '#1B4965');
END $$;

-- ATH750KU / ATH750KUH — Outdoor TWTA Ku-band
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'ATH750KU / ATH750KUH' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'ATH750KU / ATH750KUH', 'Amplificateurs RF', 'Télécommunications', 'Amplificateur TWTA extérieur bande Ku d''ACTIA Aerospace, 750W (jusqu''à 14.8 GHz pour la version H), avec linéariseur et contrôleur de redondance 1+1 intégrés, châssis bas profil pour intégration facile sur antenne.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande', 'Ku-band (jusqu''à 14.8 GHz)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '750W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Redondance', 'Contrôleur 1+1 intégré', 3, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité (redondance)', 93, '#1B4965');
END $$;

-- ASH20KA — Outdoor SSPA Ka-band
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'ASH20KA' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'ASH20KA', 'Amplificateurs RF', 'Télécommunications', 'Amplificateur SSPA extérieur bande Ka (27.5-31 GHz) d''ACTIA Aerospace, 20W, technologie GaN, unité compacte et légère pour terminaux tactiques.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande', 'Ka-band (27.5-31 GHz)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '20W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Technologie', 'GaN', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Contrôle', 'RS485 et Ethernet IP', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Portabilité (terminaux tactiques)', 90, '#1B4965');
END $$;

-- ASH40KA — Outdoor SSPA Ka-band
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'ASH40KA' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'ASH40KA', 'Amplificateurs RF', 'Télécommunications', 'Amplificateur SSPA extérieur bande Ka (27.5-31 GHz) d''ACTIA Aerospace, 40W, conception compacte et hautement fiable pour terminaux tactiques, qualifiée pour environnements difficiles.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande', 'Ka-band (27.5-31 GHz)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '40W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Contrôle', 'RS485 et Ethernet IP', 3, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse environnementale', 91, '#1B4965');
END $$;

-- ATH250KA — Outdoor TWTA Ka-band
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'ATH250KA' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'ATH250KA', 'Amplificateurs RF', 'Télécommunications', 'Amplificateur TWTA extérieur bande Ka (27.5-31 GHz) d''ACTIA Aerospace, 250W, compact et léger, pour stations sol fixes ou transportables, option convertisseur bande L.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande', 'Ka-band (27.5-31 GHz)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '250W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Application', 'Stations sol fixes ou transportables', 3, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Performance RF', 92, '#1B4965');
END $$;

-- ATH550KA — Outdoor TWTA Ka-band
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'ATH550KA' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'ATH550KA', 'Amplificateurs RF', 'Télécommunications', 'Amplificateur TWTA extérieur bande Ka (27.5-31 GHz) d''ACTIA Aerospace, 550W, refroidissement air ou liquide, résistant aux intempéries pour montage sur antenne extérieure, contrôleur de commutation 1+1.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande', 'Ka-band (27.5-31 GHz)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '550W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Refroidissement', 'Air ou liquide', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Redondance', 'Contrôleur de commutation 1+1', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Résistance aux intempéries', 93, '#1B4965');
END $$;

-- ATH750KA — Outdoor TWTA Ka-band
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'ATH750KA' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'ATH750KA', 'Amplificateurs RF', 'Télécommunications', 'Amplificateur TWTA extérieur bande Ka (27.5-31 GHz) d''ACTIA Aerospace, 750W, résistant aux intempéries, options linéariseur intégral, convertisseur bande L et contrôleur de commutation 2+1.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande', 'Ka-band (27.5-31 GHz)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '750W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Options', 'Linéariseur intégral, contrôleur de commutation 2+1', 3, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Puissance maximale (Ka-band)', 94, '#1B4965');
END $$;

-- ATH140Q — Outdoor TWTA Q-band
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'ATH140Q' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'ATH140Q', 'Amplificateurs RF', 'Télécommunications', 'Amplificateur TWTA extérieur bande Q (43.5-45.5 GHz) d''ACTIA Aerospace, 140W, résistant aux intempéries, contrôleur de commutation 1+1, options linéariseur intégral et convertisseur bande L.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande', 'Q-band (43.5-45.5 GHz)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '140W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Redondance', 'Contrôleur de commutation 1+1', 3, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Performance haute fréquence', 90, '#1B4965');
END $$;

-- ATH250V / ATH250VE — Outdoor TWTA V-band
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'ATH250V / ATH250VE' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'ATH250V / ATH250VE', 'Amplificateurs RF', 'Télécommunications', 'Amplificateur TWTA extérieur bande V (47.2-52.4 GHz) d''ACTIA Aerospace, 250W (jusqu''à 52.4 GHz), refroidissement air ou liquide, linéariseur intégré, options redondance 1+1 ou 2+1.', 'Sur devis', '📡'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande', 'V-band (47.2-52.4 GHz)', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '250W', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Refroidissement', 'Air ou liquide', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Options', 'Redondance 1+1 ou 2+1', 4, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Performance RF (V-band)', 91, '#1B4965');
END $$;

-- ZENYA — Software suite
DO $$
DECLARE pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'ZENYA' AND c.name = 'ACTIA Aerospace') THEN RETURN; END IF;
  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'ZENYA', 'Logiciels de supervision', 'Télécommunications', 'Suite logicielle ACTIA pour la supervision et le contrôle de systèmes SatCom (gateways satellites), à architecture microservices, déployable en cloud, fonctionnant en environnement clusterisé. Trois niveaux : Local Manager (segment SatCom unique), Central Manager (système SatCom complet), Mission Planner (définition des porteuses satellite selon besoins utilisateurs).', 'Sur devis', '🖥️'
  FROM companies c WHERE c.name = 'ACTIA Aerospace' LIMIT 1 RETURNING id INTO pid;
  IF pid IS NULL THEN RETURN; END IF;
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Architecture', 'Microservices, clusterisée, prête pour le cloud', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Niveaux', 'Local Manager, Central Manager, Mission Planner', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interface', 'Web moderne, responsive, tableaux de bord personnalisables', 3, TRUE);
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Scalabilité', 93, '#1B4965');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Compatible déploiement cloud');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'Amplificateurs RF' FROM companies WHERE name = 'ACTIA Aerospace' LIMIT 1 ON CONFLICT DO NOTHING;
INSERT INTO company_product_categories (company_id, category) SELECT id, 'Logiciels de supervision' FROM companies WHERE name = 'ACTIA Aerospace' LIMIT 1 ON CONFLICT DO NOTHING;
