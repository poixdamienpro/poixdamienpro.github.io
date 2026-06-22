-- ============================================================
-- BUY-INEER — Complétion du catalogue produits
-- Ajoute 2-3 produits pour chaque entreprise qui en avait 0 ou 1
-- À exécuter dans Supabase : SQL Editor → New query → Run
-- Idempotent : peut être relancé sans créer de doublons.
-- ============================================================

-- ============ Samsung SDI ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Cellule prismatique 94Ah NMC' AND c.name = 'Samsung SDI') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Cellule prismatique 94Ah NMC', 'Batteries & Stockage', 'Automobile & Mobilité électrique', 'Cellule prismatique haute densité pour packs VE premium. Format compact, charge rapide.', '~95 € / cellule', '🔷'
  FROM companies c WHERE c.name = 'Samsung SDI' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Chimie', 'NMC', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Capacité', '94 Ah', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension nominale', '3,68 V', 3, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Énergie spécifique', '235 Wh/kg', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cycle de vie', '> 2 000 cycles', 5, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Densité énergie', 90, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durée de vie', 78, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'UN38.3');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Module ESS PRiMX 50kWh' AND c.name = 'Samsung SDI') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Module ESS PRiMX 50kWh', 'Batteries & Stockage', 'Énergie & Utilities', 'Module de stockage stationnaire PRiMX pour applications réseau et industrielles.', 'Sur devis', '🔷'
  FROM companies c WHERE c.name = 'Samsung SDI' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Chimie', 'NMC PRiMX', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Énergie', '50 kWh', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '614 V DC', 3, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cycle de vie', '> 6 000 cycles', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Refroidissement', 'Air forcé', 5, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durée de vie', 88, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Densité énergie', 82, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'UL 9540');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'IEC 62619');
END $$;

-- ============ LG Energy Solution ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Cellule cylindrique 2170' AND c.name = 'LG Energy Solution') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Cellule cylindrique 2170', 'Batteries & Stockage', 'Automobile & Mobilité électrique', 'Cellule cylindrique haute performance pour VE et outillage électroportatif.', '~6 € / cellule', '🟩'
  FROM companies c WHERE c.name = 'LG Energy Solution' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Format', '21700', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Capacité', '5 000 mAh', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension nominale', '3,6 V', 3, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Énergie spécifique', '260 Wh/kg', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Densité énergie', 92, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durée de vie', 75, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'UN38.3');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Pack pouch RESU ESS 10 kWh' AND c.name = 'LG Energy Solution') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Pack pouch RESU ESS 10 kWh', 'Batteries & Stockage', 'Énergie & Utilities', 'Pack résidentiel/commercial RESU pour stockage solaire et autoconsommation.', '~4 500 €', '🟩'
  FROM companies c WHERE c.name = 'LG Energy Solution' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Énergie', '10 kWh', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '400 V DC', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cycle de vie', '> 6 000 cycles', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Garantie', '10 ans', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durée de vie', 90, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Densité énergie', 80, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'IEC 62619');
END $$;

-- ============ Blue Solutions ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Cellule LMP tout-solide' AND c.name = 'Blue Solutions') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Cellule LMP tout-solide', 'Batteries & Stockage', 'Énergie & Utilities', 'Cellule lithium métal polymère tout-solide, technologie brevetée Blue Solutions.', 'Sur devis', '🔵'
  FROM companies c WHERE c.name = 'Blue Solutions' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Chimie', 'LMP tout-solide', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension nominale', '3,3 V', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cycle de vie', '> 3 000 cycles', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Sécurité', 'Pas de risque thermique', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Sécurité', 98, '#D4500A');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durée de vie', 85, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'UN38.3');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Module Bluestorage 35 kWh' AND c.name = 'Blue Solutions') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Module Bluestorage 35 kWh', 'Batteries & Stockage', 'Industrie & Manufacturing', 'Module de stockage stationnaire LMP pour sites industriels et bus électriques.', 'Sur devis', '🔵'
  FROM companies c WHERE c.name = 'Blue Solutions' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Énergie', '35 kWh', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '667 V DC', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Température', '-20 à +60 °C', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse thermique', 92, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durée de vie', 85, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

-- ============ Verkor ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Cellule NMC bas-carbone' AND c.name = 'Verkor') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Cellule NMC bas-carbone', 'Batteries & Stockage', 'Automobile & Mobilité électrique', 'Cellule NMC fabriquée en gigafactory bas-carbone pour véhicules électriques premium.', 'Sur devis', '🟢'
  FROM companies c WHERE c.name = 'Verkor' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Chimie', 'NMC', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Empreinte carbone', '< 60 kg CO2/kWh', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Énergie spécifique', '250 Wh/kg', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Densité énergie', 90, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Empreinte carbone', 95, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'UN38.3');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Pack VE 75 kWh bas-carbone' AND c.name = 'Verkor') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Pack VE 75 kWh bas-carbone', 'Batteries & Stockage', 'Automobile & Mobilité électrique', 'Pack batterie complet pour VE premium, traçabilité carbone intégrale.', 'Sur devis', '🟢'
  FROM companies c WHERE c.name = 'Verkor' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Énergie', '75 kWh', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '400 V DC', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cycle de vie', '> 2 000 cycles', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Densité énergie', 88, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durabilité', 82, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

-- ============ Schneider Electric ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'PDU APC rack intelligent' AND c.name = 'Schneider Electric') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'PDU APC rack intelligent', 'PDU (Power Distribution)', 'Industrie & Manufacturing', 'PDU rack monitoré APC pour datacenters et salles serveurs. Gestion via EcoStruxure.', '~900 €', '🟩'
  FROM companies c WHERE c.name = 'Schneider Electric' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Courant', '32 A', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '230 V AC', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Prises', '20× C13', 3, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Interface', 'SNMP, Modbus', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Monitoring', 90, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'UL');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Onduleur Galaxy VS 100kVA' AND c.name = 'Schneider Electric') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Onduleur Galaxy VS 100kVA', 'Convertisseurs & Onduleurs', 'Industrie & Manufacturing', 'Onduleur UPS modulaire Galaxy VS pour datacenters et industries critiques.', 'Sur devis', '🟩'
  FROM companies c WHERE c.name = 'Schneider Electric' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '100 kVA', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Rendement', '> 97 %', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Autonomie', 'Modulaire', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Rendement', 97, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Disponibilité', 95, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'IEC 62040');
END $$;

-- ============ Brusa Elektronik ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'OBC NLG5 11kW' AND c.name = 'Brusa Elektronik') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'OBC NLG5 11kW', 'OBC (On-Board Charger)', 'Automobile & Mobilité électrique', 'Chargeur embarqué compact 11kW pour véhicules utilitaires et flottes légères.', '~1 800 €', '🔌'
  FROM companies c WHERE c.name = 'Brusa Elektronik' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '11 kW', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension entrée', '3×400 V AC', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Rendement', '> 93 %', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '3,2 kg', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Rendement', 93, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Convertisseur DC/DC BDC546' AND c.name = 'Brusa Elektronik') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Convertisseur DC/DC BDC546', 'Convertisseurs & Onduleurs', 'Automobile & Mobilité électrique', 'Convertisseur DC/DC bidirectionnel haute tension pour architectures VE.', 'Sur devis', '🔌'
  FROM companies c WHERE c.name = 'Brusa Elektronik' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '3 kW', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension entrée', '200–800 V DC', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Rendement', '> 95 %', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Rendement', 95, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Flexibilité', 85, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

-- ============ Parker Hannifin ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Vanne proportionnelle D1FP' AND c.name = 'Parker Hannifin') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Vanne proportionnelle D1FP', 'Vannes & Actionneurs', 'Industrie & Manufacturing', 'Vanne proportionnelle haute précision pour applications hydrauliques industrielles.', '~650 €', '⚙️'
  FROM companies c WHERE c.name = 'Parker Hannifin' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Débit', '60 L/min', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Pression max', '350 bar', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision', '< 1 %', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 90, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Débit', 80, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ISO 9001');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Vérin hydraulique série 2H' AND c.name = 'Parker Hannifin') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Vérin hydraulique série 2H', 'Vannes & Actionneurs', 'Industrie & Manufacturing', 'Vérin hydraulique standard ISO pour applications industrielles lourdes.', '~420 €', '⚙️'
  FROM companies c WHERE c.name = 'Parker Hannifin' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Course', 'Jusqu''à 2 000 mm', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Pression max', '250 bar', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Force max', '180 kN', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Force', 88, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durabilité', 90, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ISO 6020');
END $$;

-- ============ Bürkert ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Électrovanne type 6213' AND c.name = 'Bürkert') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Électrovanne type 6213', 'Vannes & Actionneurs', 'Industrie & Manufacturing', 'Électrovanne 2/2 voies à membrane pour fluides neutres et agressifs.', '~85 €', '🔵'
  FROM companies c WHERE c.name = 'Bürkert' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Diamètre nominal', 'DN15–DN50', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Pression max', '16 bar', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Matériau corps', 'PVDF/Inox', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Résistance chimique', 92, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 80, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ATEX option');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Capteur de débit FLOWave SE30' AND c.name = 'Bürkert') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Capteur de débit FLOWave SE30', 'Capteurs & Instrumentation', 'Industrie & Manufacturing', 'Capteur de débit massique sans pièce mobile, hygiénique, pour applications pharma.', '~1 100 €', '🔵'
  FROM companies c WHERE c.name = 'Bürkert' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plage de mesure', '0,1–600 L/min', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision', '± 0,3 %', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Matériau', 'Inox 316L', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 95, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Hygiène', 96, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'EHEDG');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, '3-A');
END $$;

-- ============ Siemens ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Variateur SINAMICS G120X' AND c.name = 'Siemens') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Variateur SINAMICS G120X', 'Convertisseurs & Onduleurs', 'Industrie & Manufacturing', 'Variateur de fréquence robuste pour pompes, ventilateurs et applications industrielles.', '~1 500 €', '🔵'
  FROM companies c WHERE c.name = 'Siemens' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '0,75–250 kW', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '380–480 V AC', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Rendement', '> 97 %', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Rendement', 97, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'UL');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Moteur SIMOTICS GP' AND c.name = 'Siemens') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Moteur SIMOTICS GP', 'Moteurs & Entraînements', 'Industrie & Manufacturing', 'Moteur asynchrone industriel standard IE3 pour applications de process.', '~800 €', '🔵'
  FROM companies c WHERE c.name = 'Siemens' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '0,12–250 kW', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Classe efficacité', 'IE3', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Protection', 'IP55', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Efficacité', 90, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'IE3');
END $$;

-- ============ Nidec ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'eAxle intégré 150kW' AND c.name = 'Nidec') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'eAxle intégré 150kW', 'Moteurs & Entraînements', 'Automobile & Mobilité électrique', 'Système eAxle intégrant moteur, onduleur et réducteur pour VE.', 'Sur devis', '🔄'
  FROM companies c WHERE c.name = 'Nidec' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '150 kW', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Couple max', '310 N·m', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Rendement', '> 96 %', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Rendement', 96, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ISO 26262');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Servomoteur PMSM industriel' AND c.name = 'Nidec') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Servomoteur PMSM industriel', 'Moteurs & Entraînements', 'Industrie & Manufacturing', 'Servomoteur synchrone à aimants permanents pour robotique et automatisation.', '~950 €', '🔄'
  FROM companies c WHERE c.name = 'Nidec' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '0,4–7 kW', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Couple nominal', 'Jusqu''à 35 N·m', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision', 'Encodeur 23 bits', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 94, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Dynamique', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

-- ============ Alstom ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Convertisseur de traction ONIX' AND c.name = 'Alstom') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Convertisseur de traction ONIX', 'Convertisseurs & Onduleurs', 'Ferroviaire', 'Convertisseur de traction modulaire pour trains et trams. Architecture SiC.', 'Sur devis', '🚄'
  FROM companies c WHERE c.name = 'Alstom' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', 'Jusqu''à 1 200 kW', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Technologie', 'SiC', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Rendement', '> 98 %', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Rendement', 98, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 85, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'EN 50155');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Moteur de traction synchrone' AND c.name = 'Alstom') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Moteur de traction synchrone', 'Moteurs & Entraînements', 'Ferroviaire', 'Moteur de traction synchrone à aimants permanents pour matériel roulant.', 'Sur devis', '🚄'
  FROM companies c WHERE c.name = 'Alstom' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', 'Jusqu''à 500 kW', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Couple nominal', 'Élevé basse vitesse', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Refroidissement', 'Air forcé', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Rendement', 95, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité', 92, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'EN 50125');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

-- ============ Danfoss ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Variateur VACON 100' AND c.name = 'Danfoss') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Variateur VACON 100', 'Convertisseurs & Onduleurs', 'Industrie & Manufacturing', 'Variateur de fréquence polyvalent pour applications process et HVAC industriel.', '~1 100 €', '🌡️'
  FROM companies c WHERE c.name = 'Danfoss' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '0,75–500 kW', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '380–500 V AC', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Rendement', '> 97 %', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Rendement', 97, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Polyvalence', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'UL');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Vanne hydraulique mobile PVG' AND c.name = 'Danfoss') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Vanne hydraulique mobile PVG', 'Vannes & Actionneurs', 'Industrie & Manufacturing', 'Bloc de vannes proportionnelles pour hydraulique mobile et engins de chantier.', 'Sur devis', '🌡️'
  FROM companies c WHERE c.name = 'Danfoss' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Débit', 'Jusqu''à 350 L/min', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Pression max', '350 bar', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Sections', 'Modulaires', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Débit', 85, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Modularité', 90, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

-- ============ Emerson (Fisher) ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Vanne de contrôle Fisher easy-e' AND c.name = 'Emerson (Fisher)') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Vanne de contrôle Fisher easy-e', 'Vannes & Actionneurs', 'Énergie & Utilities', 'Vanne de contrôle de procédé globe, référence industrie oil & gas et chimie.', 'Sur devis', '🌐'
  FROM companies c WHERE c.name = 'Emerson (Fisher)' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Diamètre nominal', 'DN15–DN300', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Pression max', 'Jusqu''à 420 bar', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Matériau corps', 'Acier carbone/inox', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision contrôle', 90, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse', 92, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'API 6D');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Positionneur numérique FIELDVUE DVC6200' AND c.name = 'Emerson (Fisher)') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Positionneur numérique FIELDVUE DVC6200', 'Capteurs & Instrumentation', 'Énergie & Utilities', 'Positionneur numérique intelligent pour vannes de contrôle, diagnostic intégré.', '~2 800 €', '🌐'
  FROM companies c WHERE c.name = 'Emerson (Fisher)' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Communication', 'HART, Foundation Fieldbus', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision', '± 0,5 %', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Diagnostic', 'Intégré', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 92, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Connectivité', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ATEX');
END $$;

-- ============ Neogy ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Pack batterie B2B sur-mesure NMC' AND c.name = 'Neogy') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Pack batterie B2B sur-mesure NMC', 'Batteries & Stockage', 'Automobile & Mobilité électrique', 'Pack batterie personnalisé pour véhicules industriels et engins spécifiques.', 'Sur devis', '⚙️'
  FROM companies c WHERE c.name = 'Neogy' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Chimie', 'NMC', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Énergie', 'Configurable 5–200 kWh', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'BMS', 'Intégré', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Flexibilité', 95, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durée de vie', 85, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'UN38.3');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Pack LFP stationnaire sur-mesure' AND c.name = 'Neogy') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Pack LFP stationnaire sur-mesure', 'Batteries & Stockage', 'Énergie & Utilities', 'Pack LiFePO4 sur-mesure pour stockage stationnaire et applications industrielles.', 'Sur devis', '⚙️'
  FROM companies c WHERE c.name = 'Neogy' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Chimie', 'LiFePO4', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cycle de vie', '> 5 000 cycles', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Production', 'Pompignac (33)', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durée de vie', 92, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Sécurité', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'UN38.3');
END $$;

-- ============ Lemo ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Connecteur push-pull série K' AND c.name = 'Lemo') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Connecteur push-pull série K', 'Câblage & Connecteurs', 'Aéronautique & Défense', 'Connecteur push-pull de précision, référence médical et militaire.', '~45 € / u', '🇨🇭'
  FROM companies c WHERE c.name = 'Lemo' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Verrouillage', 'Push-pull', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Étanchéité', 'IP68', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cycles d''insertion', '> 10 000', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durabilité', 95, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Étanchéité', 92, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'IP68');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ISO 13485');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Câble assemblé médical série M' AND c.name = 'Lemo') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Câble assemblé médical série M', 'Câblage & Connecteurs', 'Aéronautique & Défense', 'Câble assemblé sur-mesure avec connecteurs Lemo pour équipements médicaux.', 'Sur devis', '🇨🇭'
  FROM companies c WHERE c.name = 'Lemo' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Connecteurs', 'Série M push-pull', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Stérilisation', 'Autoclave compatible', 2, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité', 94, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Résistance stérilisation', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ISO 13485');
END $$;

-- ============ Flowserve ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Vanne à bille Worcester série 44' AND c.name = 'Flowserve') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Vanne à bille Worcester série 44', 'Vannes & Actionneurs', 'Énergie & Utilities', 'Vanne à bille industrielle pour applications oil & gas et chimie lourde.', 'Sur devis', '💧'
  FROM companies c WHERE c.name = 'Flowserve' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Diamètre nominal', 'DN15–DN600', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Pression max', 'Jusqu''à 420 bar', 2, FALSE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse', 92, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Étanchéité', 90, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'API 6D');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Pompe centrifuge Durco Mark 3' AND c.name = 'Flowserve') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Pompe centrifuge Durco Mark 3', 'Vannes & Actionneurs', 'Énergie & Utilities', 'Pompe centrifuge process pour applications chimiques et pétrochimiques.', 'Sur devis', '💧'
  FROM companies c WHERE c.name = 'Flowserve' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Débit', 'Jusqu''à 1 800 m³/h', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Hauteur', 'Jusqu''à 180 m', 2, FALSE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité', 90, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Performance', 85, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'API 610');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

-- ============ Moog Space & Defense ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Vanne de propulsion satellite' AND c.name = 'Moog Space & Defense') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Vanne de propulsion satellite', 'Vannes & Actionneurs', 'Spatial', 'Vanne de propulsion latch pour systèmes propulsifs de satellites et lanceurs.', 'Sur devis', '🛸'
  FROM companies c WHERE c.name = 'Moog Space & Defense' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Vanne latch bistable', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Pression de service', 'Jusqu''à 400 bar', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '< 0,3 kg', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité en vol', 97, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifié');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Actionneur de déploiement panneau solaire' AND c.name = 'Moog Space & Defense') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Actionneur de déploiement panneau solaire', 'Vannes & Actionneurs', 'Spatial', 'Actionneur électromécanique pour déploiement de panneaux solaires et antennes.', 'Sur devis', '🛸'
  FROM companies c WHERE c.name = 'Moog Space & Defense' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Actionneur électromécanique', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Couple', 'Jusqu''à 15 N·m', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cycle de vie mission', '> 15 ans', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité en vol', 96, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'NASA qualifié');
END $$;

-- ============ Saft (TotalEnergies) ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'MP 176065 — Li-ion Spatial' AND c.name = 'Saft (TotalEnergies)') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'MP 176065 — Li-ion Spatial', 'Batteries & Stockage', 'Spatial', 'Cellule Li-ion qualifiée spatial pour satellites et lanceurs, héritage Ariane.', 'Sur devis', '🇫🇷'
  FROM companies c WHERE c.name = 'Saft (TotalEnergies)' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Chimie', 'Li-ion', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Capacité', '6,8 Ah', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Qualification', 'ECSS', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité en vol', 98, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Densité énergie', 75, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECSS');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifié');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Intensium Max — ESS conteneurisé' AND c.name = 'Saft (TotalEnergies)') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Intensium Max — ESS conteneurisé', 'Batteries & Stockage', 'Énergie & Utilities', 'Système de stockage d''énergie conteneurisé pour réseaux et industries.', 'Sur devis', '🇫🇷'
  FROM companies c WHERE c.name = 'Saft (TotalEnergies)' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Énergie', '1 MWh / conteneur', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Chimie', 'Li-ion', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cycle de vie', '> 5 000 cycles', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durée de vie', 90, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité', 92, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'IEC 62619');
END $$;

-- ============ Forsee Power ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Pulse Pack — Camion électrique' AND c.name = 'Forsee Power') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Pulse Pack — Camion électrique', 'Batteries & Stockage', 'Automobile & Mobilité électrique', 'Pack batterie pour camions électriques lourds, intégration châssis optimisée.', 'Sur devis', '🚌'
  FROM companies c WHERE c.name = 'Forsee Power' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '700 V DC', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Énergie', '~250 kWh', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cycle de vie', '> 3 000 cycles', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Densité énergie', 80, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durée de vie', 85, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ECE R100');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Quantum Pack — Marine hybride' AND c.name = 'Forsee Power') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Quantum Pack — Marine hybride', 'Batteries & Stockage', 'Marine & Offshore', 'Pack batterie pour propulsion hybride marine, certifié classes navales.', 'Sur devis', '🚌'
  FROM companies c WHERE c.name = 'Forsee Power' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '620 V DC', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Énergie', '~100 kWh', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Certification', 'DNV', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse marine', 90, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durée de vie', 82, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'DNV');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

-- ============ Batconnect ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'LFP 12V 200Ah IoT' AND c.name = 'Batconnect') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'LFP 12V 200Ah IoT', 'Batteries & Stockage', 'Automobile & Mobilité électrique', 'Pack 12V connecté pour camping-cars et bateaux de plaisance, monitoring IoT.', 'Sur devis', '📶'
  FROM companies c WHERE c.name = 'Batconnect' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '12 V', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Capacité', '200 Ah', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Connectivité', '4G/BLE', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Connectivité', 92, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durée de vie', 90, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'UN38.3');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'LFP 24V 200Ah Fleet' AND c.name = 'Batconnect') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'LFP 24V 200Ah Fleet', 'Batteries & Stockage', 'Automobile & Mobilité électrique', 'Pack 24V pour flottes professionnelles avec gestion à distance multi-véhicules.', 'Sur devis', '📶'
  FROM companies c WHERE c.name = 'Batconnect' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '24 V', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Capacité', '200 Ah', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Gestion flotte', 'Dashboard web', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Connectivité', 94, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durée de vie', 92, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'UN38.3');
END $$;

-- ============ Corvus Energy ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Corvus Blue Whale — ESS modulaire' AND c.name = 'Corvus Energy') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Corvus Blue Whale — ESS modulaire', 'Batteries & Stockage', 'Marine & Offshore', 'Module ESS compact pour ferries et navires de petite à moyenne taille.', 'Sur devis', '⚓'
  FROM companies c WHERE c.name = 'Corvus Energy' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Énergie', '124 kWh / module', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '700 V DC', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Certification', 'DNV GL', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Modularité', 90, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité', 92, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'DNV GL');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ABS');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Corvus Dolphin — ESS haute densité' AND c.name = 'Corvus Energy') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Corvus Dolphin — ESS haute densité', 'Batteries & Stockage', 'Marine & Offshore', 'ESS haute densité énergétique pour applications marines à fort besoin de puissance.', 'Sur devis', '⚓'
  FROM companies c WHERE c.name = 'Corvus Energy' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Énergie', '152 kWh / module', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '700 V DC', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Refroidissement', 'Liquide', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Densité énergie', 88, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durée de vie', 85, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'DNV GL');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ABS');
END $$;

-- ============ Eaton ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'UPS 9395P 500kVA' AND c.name = 'Eaton') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'UPS 9395P 500kVA', 'Convertisseurs & Onduleurs', 'Industrie & Manufacturing', 'Onduleur UPS triphasé haute puissance pour datacenters et industries critiques.', 'Sur devis', '🔌'
  FROM companies c WHERE c.name = 'Eaton' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '500 kVA', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Rendement', '> 96 %', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Topologie', 'Double conversion', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Rendement', 96, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Disponibilité', 95, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'IEC 62040');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Disjoncteur basse tension PXR' AND c.name = 'Eaton') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Disjoncteur basse tension PXR', 'PDU (Power Distribution)', 'Industrie & Manufacturing', 'Disjoncteur ouvert basse tension avec protection électronique avancée.', 'Sur devis', '🔌'
  FROM companies c WHERE c.name = 'Eaton' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Courant', 'Jusqu''à 6 300 A', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', 'Jusqu''à 690 V', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Communication', 'Modbus', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Protection', 95, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Connectivité', 85, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'IEC 60947');
END $$;

-- ============ Safran Electrical & Power ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Générateur de puissance avionique' AND c.name = 'Safran Electrical & Power') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Générateur de puissance avionique', 'PDU (Power Distribution)', 'Aéronautique & Défense', 'Générateur électrique embarqué pour aéronefs commerciaux et militaires.', 'Sur devis', '🛩️'
  FROM companies c WHERE c.name = 'Safran Electrical & Power' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', 'Jusqu''à 250 kVA', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '115/230 V AC', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '~45 kg', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité', 96, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Densité puissance', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'DO-160G');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'EASA');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Harnais de câblage avionique' AND c.name = 'Safran Electrical & Power') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Harnais de câblage avionique', 'Câblage & Connecteurs', 'Aéronautique & Défense', 'Harnais de câblage sur-mesure pour systèmes électriques avioniques.', 'Sur devis', '🛩️'
  FROM companies c WHERE c.name = 'Safran Electrical & Power' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Conducteurs', 'Cuivre/aluminium aéronautique', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Certification', 'DO-160G', 2, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité', 95, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Légèreté', 85, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'DO-160G');
END $$;

-- ============ Delta Electronics ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Convertisseur DC/DC haute tension' AND c.name = 'Delta Electronics') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Convertisseur DC/DC haute tension', 'Convertisseurs & Onduleurs', 'Automobile & Mobilité électrique', 'Convertisseur DC/DC isolé pour architectures véhicules électriques 800V.', 'Sur devis', '△'
  FROM companies c WHERE c.name = 'Delta Electronics' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '3 kW', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension entrée', '550–930 V DC', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Rendement', '> 95 %', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Rendement', 95, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 85, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ISO 16750');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Onduleur solaire M70A' AND c.name = 'Delta Electronics') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Onduleur solaire M70A', 'Convertisseurs & Onduleurs', 'Énergie & Utilities', 'Onduleur solaire triphasé pour installations photovoltaïques commerciales.', 'Sur devis', '△'
  FROM companies c WHERE c.name = 'Delta Electronics' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', '70 kW', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Rendement', '> 98 %', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Entrées MPPT', '8', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Rendement', 98, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Flexibilité', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'IEC 62109');
END $$;

-- ============ Victron Energy ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Régulateur MPPT SmartSolar 250/100' AND c.name = 'Victron Energy') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Régulateur MPPT SmartSolar 250/100', 'Convertisseurs & Onduleurs', 'Énergie & Utilities', 'Régulateur de charge solaire MPPT haute puissance pour systèmes off-grid.', '~750 €', '☀️'
  FROM companies c WHERE c.name = 'Victron Energy' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension panneau max', '250 V', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Courant charge max', '100 A', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Rendement', '> 98 %', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Rendement', 98, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision MPPT', 92, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Moniteur batterie BMV-712' AND c.name = 'Victron Energy') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Moniteur batterie BMV-712', 'Capteurs & Instrumentation', 'Énergie & Utilities', 'Moniteur de batterie Bluetooth pour suivi précis de l''état de charge.', '~180 €', '☀️'
  FROM companies c WHERE c.name = 'Victron Energy' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision SOC', '± 1 %', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Connectivité', 'Bluetooth', 2, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '9–90 V DC', 3, FALSE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 92, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Connectivité', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

-- ============ Moog ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'EMA — Actionneur électromécanique' AND c.name = 'Moog') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'EMA — Actionneur électromécanique', 'Moteurs & Entraînements', 'Aéronautique & Défense', 'Actionneur électromécanique pour commandes de vol secondaires et primaires.', 'Sur devis', '✈️'
  FROM companies c WHERE c.name = 'Moog' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Force max', '12 kN', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Course', '150 mm', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Masse', '2,8 kg', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 95, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité', 94, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'EASA');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'AS9100D');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Servomoteur haute dynamique' AND c.name = 'Moog') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Servomoteur haute dynamique', 'Moteurs & Entraînements', 'Industrie & Manufacturing', 'Servomoteur haute dynamique pour simulateurs de vol et bancs d''essai.', 'Sur devis', '✈️'
  FROM companies c WHERE c.name = 'Moog' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', 'Jusqu''à 15 kW', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Bande passante', '> 100 Hz', 2, FALSE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Dynamique', 94, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 92, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

-- ============ Rotork ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Actionneur pneumatique série GP' AND c.name = 'Rotork') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Actionneur pneumatique série GP', 'Vannes & Actionneurs', 'Énergie & Utilities', 'Actionneur pneumatique double effet pour vannes tout ou rien.', '~600 €', '🔧'
  FROM companies c WHERE c.name = 'Rotork' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Couple', 'Jusqu''à 8 000 N·m', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Pression air', '4–8 bar', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Temps de manœuvre', '< 2 s', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Réactivité', 92, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse', 88, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ATEX');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Réducteur manuel série GD' AND c.name = 'Rotork') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Réducteur manuel série GD', 'Vannes & Actionneurs', 'Énergie & Utilities', 'Réducteur à engrenages pour manœuvre manuelle de vannes lourdes.', '~350 €', '🔧'
  FROM companies c WHERE c.name = 'Rotork' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Rapport de réduction', 'Jusqu''à 1500:1', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Couple max', '2 000 N·m', 2, FALSE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse', 90, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Simplicité', 95, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

-- ============ ABB ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Moteur HXR haute tension' AND c.name = 'ABB') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Moteur HXR haute tension', 'Moteurs & Entraînements', 'Industrie & Manufacturing', 'Moteur asynchrone haute tension pour applications industrielles lourdes.', 'Sur devis', '🔩'
  FROM companies c WHERE c.name = 'ABB' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Puissance', 'Jusqu''à 3 500 kW', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '6–13,8 kV', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Classe efficacité', 'IE3', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Efficacité', 92, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse', 90, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'IEC 60034');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Robot industriel IRB 6700' AND c.name = 'ABB') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Robot industriel IRB 6700', 'Moteurs & Entraînements', 'Industrie & Manufacturing', 'Robot industriel 6 axes pour manutention et soudure haute charge.', 'Sur devis', '🔩'
  FROM companies c WHERE c.name = 'ABB' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Charge utile', 'Jusqu''à 300 kg', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Portée', '2,6–3,2 m', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Répétabilité', '± 0,05 mm', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 94, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Charge utile', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ISO 10218');
END $$;

-- ============ TE Connectivity ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Capteur de pression HV' AND c.name = 'TE Connectivity') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Capteur de pression HV', 'Capteurs & Instrumentation', 'Automobile & Mobilité électrique', 'Capteur de pression robuste pour systèmes de freinage et batteries HV.', '~18 € / u', '🔗'
  FROM companies c WHERE c.name = 'TE Connectivity' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plage de mesure', '0–400 bar', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision', '± 0,5 %', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Étanchéité', 'IP67', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 90, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'AEC-Q100');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Connecteur MQS automobile' AND c.name = 'TE Connectivity') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Connecteur MQS automobile', 'Câblage & Connecteurs', 'Automobile & Mobilité électrique', 'Connecteur miniature étanche pour faisceaux automobiles basse tension.', '~2 € / u', '🔗'
  FROM companies c WHERE c.name = 'TE Connectivity' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Courant', 'Jusqu''à 8 A', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Étanchéité', 'IP67', 2, FALSE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 92, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Étanchéité', 90, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'USCAR-2');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

-- ============ Sensata Technologies ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Relais haute tension HVR300' AND c.name = 'Sensata Technologies') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Relais haute tension HVR300', 'Capteurs & Instrumentation', 'Automobile & Mobilité électrique', 'Relais de puissance haute tension pour déconnexion de packs batterie VE.', '~25 € / u', '📡'
  FROM companies c WHERE c.name = 'Sensata Technologies' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension max', '900 V DC', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Courant nominal', '300 A', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Cycles', '> 50 000', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durabilité', 90, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Tenue tension', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'AEC-Q200');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Capteur de pression CPS pour HVAC' AND c.name = 'Sensata Technologies') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Capteur de pression CPS pour HVAC', 'Capteurs & Instrumentation', 'Automobile & Mobilité électrique', 'Capteur de pression réfrigérant pour systèmes de climatisation VE.', '~12 € / u', '📡'
  FROM companies c WHERE c.name = 'Sensata Technologies' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Plage de mesure', '0–50 bar', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Précision', '± 1 %', 2, FALSE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision', 88, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 85, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'AEC-Q100');
END $$;

-- ============ Amphenol ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Connecteur fibre optique militaire' AND c.name = 'Amphenol') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Connecteur fibre optique militaire', 'Câblage & Connecteurs', 'Aéronautique & Défense', 'Connecteur fibre optique durci pour transmission de données haut débit défense.', '~80 € / u', '🔌'
  FROM companies c WHERE c.name = 'Amphenol' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type fibre', 'Monomode/multimode', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Étanchéité', 'IP68', 2, FALSE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Débit', 92, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse', 90, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-DTL-38999');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Connecteur RF SMA durci' AND c.name = 'Amphenol') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Connecteur RF SMA durci', 'Communication & RF', 'Aéronautique & Défense', 'Connecteur RF SMA pour applications radar et communication tactique.', '~15 € / u', '🔌'
  FROM companies c WHERE c.name = 'Amphenol' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Impédance', '50 Ω', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fréquence max', '18 GHz', 2, FALSE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité RF', 90, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durabilité', 88, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-348');
END $$;

-- ============ Infineon Technologies ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Module IGBT EasyPACK' AND c.name = 'Infineon Technologies') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Module IGBT EasyPACK', 'Convertisseurs & Onduleurs', 'Automobile & Mobilité électrique', 'Module IGBT pour onduleurs de traction et applications industrielles.', '20–280 € / module', '🔬'
  FROM companies c WHERE c.name = 'Infineon Technologies' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension', '650–1 700 V', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Courant', 'Jusqu''à 600 A', 2, FALSE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Efficacité', 90, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Densité puissance', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'AEC-Q101');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CE');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Driver de grille EiceDRIVER' AND c.name = 'Infineon Technologies') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Driver de grille EiceDRIVER', 'Convertisseurs & Onduleurs', 'Automobile & Mobilité électrique', 'Circuit driver de grille pour pilotage de modules SiC et IGBT.', '5–25 € / u', '🔬'
  FROM companies c WHERE c.name = 'Infineon Technologies' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Isolation', 'Jusqu''à 1 700 V', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Vitesse commutation', 'Élevée', 2, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité', 92, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Vitesse', 88, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'AEC-Q100');
END $$;

-- ============ GS Yuasa Technology (Space) ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'LSE112 — Cellule Li-ion Spatiale' AND c.name = 'GS Yuasa Technology (Space)') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'LSE112 — Cellule Li-ion Spatiale', 'Batteries & Stockage', 'Spatial', 'Cellule Li-ion grade spatial, format compact pour smallsats et cubesats.', 'Sur devis', '🇯🇵'
  FROM companies c WHERE c.name = 'GS Yuasa Technology (Space)' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Chimie', 'Li-ion NMC grade spatial', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Capacité', '90–112 Ah', 2, FALSE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Héritage en vol', 95, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité', 85, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'AS9100D');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'NASA qualifié');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Module batterie pour rover' AND c.name = 'GS Yuasa Technology (Space)') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Module batterie pour rover', 'Batteries & Stockage', 'Spatial', 'Module batterie qualifié pour rovers planétaires et missions d''exploration.', 'Sur devis', '🇯🇵'
  FROM companies c WHERE c.name = 'GS Yuasa Technology (Space)' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Chimie', 'Li-ion grade spatial', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Température opérationnelle', '-40 à +60 °C', 2, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Robustesse thermique', 94, '#3A5A78');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité', 96, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'NASA qualifié');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'ESA qualifié');
END $$;

-- ============ EaglePicher Technologies ============
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Batterie primaire Li-SOCl2 spatiale' AND c.name = 'EaglePicher Technologies') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Batterie primaire Li-SOCl2 spatiale', 'Batteries & Stockage', 'Spatial', 'Batterie primaire longue durée pour sondes et missions sans recharge.', 'Sur devis', '🦅'
  FROM companies c WHERE c.name = 'EaglePicher Technologies' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Chimie', 'Li-SOCl2', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Durée de vie', '> 15 ans en stockage', 2, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Durée de stockage', 97, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Densité énergie', 85, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'NASA GEVS');
END $$;

DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Batterie thermique pour défense' AND c.name = 'EaglePicher Technologies') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Batterie thermique pour défense', 'Batteries & Stockage', 'Aéronautique & Défense', 'Batterie thermique à activation instantanée pour systèmes de défense.', 'Sur devis', '🦅'
  FROM companies c WHERE c.name = 'EaglePicher Technologies' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Type', 'Batterie thermique', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Temps d''activation', '< 1 s', 2, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Réactivité', 98, '#D4500A');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Fiabilité', 95, '#2D6A4F');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'MIL-STD-1540');
END $$;
