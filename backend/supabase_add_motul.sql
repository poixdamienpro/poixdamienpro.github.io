-- ============================================================
-- BUY-INEER — Motul (lubrifiants compétition) — vérifié sur motul.com
-- Mis en attente pendant que le sport automobile français est repoussé
-- (priorité donnée au naval) — à exécuter quand tu veux.
-- Idempotent : peut être relancé sans créer de doublons.
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, verified, premium, employees, founded, contact_email)
SELECT 'Motul', '🇫🇷 France', 'Aubervilliers', 'Sport automobile', 'https://www.motul.com', '🏎️',
  'Fabricant français de lubrifiants haute performance, partenaire historique de la compétition automobile et moto (24h du Mans, MotoGP, WRC...).',
  TRUE, TRUE, '700+', '1853', 'contact@motul.com'
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'Motul');

-- Motul 300V — huile moteur compétition
DO $$
DECLARE
  pid UUID;
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id WHERE p.name = 'Motul 300V — Huile moteur compétition' AND c.name = 'Motul') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, category, industry, description, price_label, icon)
  SELECT c.id, 'Motul 300V — Huile moteur compétition', 'Lubrifiants', 'Sport automobile', 'Huile moteur 100% synthétique technologie ester, produit phare de Motul pour la compétition automobile et moto. Utilisée par de nombreuses écuries en circuit, rallye et endurance.', 'Sur devis', '🏎️'
  FROM companies c WHERE c.name = 'Motul' LIMIT 1
  RETURNING id INTO pid;

  IF pid IS NULL THEN RETURN; END IF;

  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Technologie', '100% synthèse ester', 1, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Application', 'Compétition automobile et moto', 2, FALSE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Gammes de viscosité', 'Multiples grades disponibles', 3, TRUE);
  INSERT INTO product_specs (product_id, label, value, sort_order, is_premium) VALUES (pid, 'Usage', 'Circuit, rallye, endurance', 4, TRUE);

  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Performance haute température', 95, '#2D6A4F');
  INSERT INTO product_bars (product_id, label, value, color_hex) VALUES (pid, 'Protection moteur', 93, '#3A5A78');

  INSERT INTO product_certs (product_id, cert_name) VALUES (pid, 'Utilisé en compétition officielle');
END $$;

INSERT INTO company_product_categories (company_id, category) SELECT id, 'Lubrifiants' FROM companies WHERE name = 'Motul' LIMIT 1 ON CONFLICT DO NOTHING;
