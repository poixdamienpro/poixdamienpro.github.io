-- ============================================================
-- BUY-INNER -- AiFinity : prestataire IA & data, PREMIUM — 2026-10
--
-- Ajoute l'entreprise (société AIFINITY SOLUTIONS, Villeurbanne) comme
-- prestataire de services, catégorie « Prestation IA & data », avec une
-- prestation et leurs traductions anglaises. L'entreprise est mise en
-- Premium (partenariat croisé : pas de paiement Stripe).
--
-- Activité issue des registres publics (développement de solutions
-- technologiques d'IA et de big data pour la gestion de ressources
-- stratégiques) ; localisation : Villeurbanne (69100), confirmée par le dirigeant
-- de Buy-inner (les registres indiquaient auparavant Saint-Cloud).
-- verified = FALSE tant que le Kbis et le contact n'ont pas été confirmés ; employees et contact_email laissés vides (inconnus).
--
-- Prérequis : supabase_add_geo_columns.sql, descriptions_en et name_en en place.
-- Idempotent : peut être relancé sans créer de doublon (et remet Premium si besoin).
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, description_en, verified, premium, founded, city, department, region, lat, lng)
SELECT 'AiFinity', '🇫🇷 France', 'Villeurbanne', 'Industrie & Manufacturing', 'https://www.aifinity.fr', '🤖',
  'Société française spécialisée dans le développement de solutions technologiques d''intelligence artificielle et de traitement de données massives (big data) pour la gestion de ressources stratégiques. Basée à Villeurbanne (Rhône).',
  'French company specialising in the development of artificial intelligence and big-data technology solutions for the management of strategic resources. Based in Villeurbanne (Rhône).',
  FALSE, TRUE, '2025', 'Villeurbanne', 'Rhône', 'Auvergne-Rhône-Alpes', 45.7719, 4.8902
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'AiFinity');

-- Premium et localisation, même si la fiche existait déjà (corrige une fiche créée avec l'ancienne adresse).
UPDATE companies SET
  premium = TRUE,
  hq = 'Villeurbanne', city = 'Villeurbanne', department = 'Rhône', region = 'Auvergne-Rhône-Alpes',
  lat = 45.7719, lng = 4.8902,
  description = 'Société française spécialisée dans le développement de solutions technologiques d''intelligence artificielle et de traitement de données massives (big data) pour la gestion de ressources stratégiques. Basée à Villeurbanne (Rhône).',
  description_en = 'French company specialising in the development of artificial intelligence and big-data technology solutions for the management of strategic resources. Based in Villeurbanne (Rhône).'
WHERE name = 'AiFinity';

-- ============ PRESTATION ============
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM products p JOIN companies c ON c.id = p.company_id
             WHERE p.name = 'Développement de solutions IA et data' AND c.name = 'AiFinity') THEN RETURN; END IF;

  INSERT INTO products (company_id, name, name_en, category, industry, description, description_en, price_label, icon)
  SELECT c.id,
    'Développement de solutions IA et data',
    'AI and data solutions development',
    'Prestation IA & data',
    'Industrie & Manufacturing',
    'Conception et développement de solutions d''intelligence artificielle et de traitement de données massives (big data), appliquées à la gestion de ressources stratégiques. Prestation sur mesure, sur devis.',
    'Design and development of artificial intelligence and big-data processing solutions, applied to the management of strategic resources. Tailor-made service, on quote.',
    'Sur devis', '🤖'
  FROM companies c WHERE c.name = 'AiFinity' LIMIT 1;
END $$;

-- Catégorie de service de l'entreprise : le site lit les catégories d'une entreprise dans
-- company_product_categories (sans cette ligne, elle n'apparaît pas dans « Prestataires »).
-- AiFinity n'a qu'une prestation : on retire toute autre catégorie (ex. rattachement manuel antérieur).
DELETE FROM company_product_categories
WHERE company_id = (SELECT id FROM companies WHERE name = 'AiFinity' LIMIT 1)
  AND category <> 'Prestation IA & data';

INSERT INTO company_product_categories (company_id, category)
SELECT id, 'Prestation IA & data' FROM companies WHERE name = 'AiFinity' LIMIT 1
ON CONFLICT DO NOTHING;

-- Contrôle (doit renvoyer 1 ligne : premium = true, 1 prestation, 1 catégorie) :
SELECT c.name, c.premium, c.verified, c.city,
       (SELECT count(*) FROM products p WHERE p.company_id = c.id) AS prestations,
       (SELECT count(*) FROM company_product_categories cc WHERE cc.company_id = c.id) AS categories
FROM companies c
WHERE c.name = 'AiFinity';
