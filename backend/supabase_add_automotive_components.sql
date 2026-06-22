-- ============================================================
-- BUY-INEER -- Automobile : equipements composants (Valeo)
-- Composants verifies sur valeo.com (LiDAR, electrification, eclairage)
-- Idempotent
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Valeo', '🇫🇷 France', 'Paris', 'Automobile', 'https://www.valeo.com', '🚗',
  'Equipementier automobile français de premier plan, concepteur de composants pour l''électrification, l''aide à la conduite (ADAS) et l''éclairage, intégrés par les principaux constructeurs mondiaux.',
  TRUE, TRUE, '100 000+', '1923', 'contact@valeo.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Valeo');

-- Valeo SCALA 3 LiDAR
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Valeo SCALA™ LiDAR' AND c.name = 'Valeo') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Valeo SCALA™ LiDAR', 'Capteurs ADAS', 'Automobile', 'Capteur laser LiDAR 3D destiné à l''intégration dans les systèmes d''aide à la conduite (ADAS) et de conduite autonome. Premier LiDAR automobile produit en série au monde, équipant notamment la Honda Legend et la Mercedes-Benz Classe S (niveau d''autonomie 3).', 'Sur devis', '🚗'
  FROM companies c WHERE c.name = 'Valeo' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Portée de détection', '> 200 m', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Fréquence de scan', '25 fois par seconde', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Génération', '3ème génération (SCALA 3)', 3, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Unités produites', '> 150 000 (depuis 2017)', 4, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Lieu de production', 'Wemding, Allemagne', 5, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Brevets', '> 560 brevets déposés', 6, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Précision de détection', 95, '#1B4965');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Conditions de faible luminosité', 90, '#1B4965');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Equipe les véhicules certifiés niveau d''autonomie 3');
  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'CES 2024 Innovation Award');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'Capteurs ADAS' FROM companies WHERE name = 'Valeo' LIMIT 1 ON CONFLICT DO NOTHING;

-- Valeo BISG (Belt-driven Integrated Starter-Generator)
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Valeo BISG — Démarreur-générateur intégré 48V' AND c.name = 'Valeo') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Valeo BISG — Démarreur-générateur intégré 48V', 'Électrification', 'Automobile', 'Démarreur-générateur intégré entraîné par courroie (Belt-driven Integrated Starter-Generator), composant central du système d''hybridation légère 48V de Valeo, à intégrer avec une batterie lithium-ion 48V et un convertisseur DC/DC pour constituer une chaîne de traction hybride complète.', 'Sur devis', '🔋'
  FROM companies c WHERE c.name = 'Valeo' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Tension du système', '48 V', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Architecture', 'Entraînement par courroie (BISG)', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Composants associés requis', 'Batterie lithium-ion 48V, convertisseur DC/DC', 3, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Réduction de consommation/CO2', 85, '#1B4965');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Compacité (vs hybride complet)', 90, '#1B4965');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Compatible objectifs de réduction CO2 2030');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'Électrification' FROM companies WHERE name = 'Valeo' LIMIT 1 ON CONFLICT DO NOTHING;
