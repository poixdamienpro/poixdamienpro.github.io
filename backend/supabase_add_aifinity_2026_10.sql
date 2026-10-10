-- ============================================================
-- BUY-INNER -- AiFinity : prestataire IA & data, PREMIUM — 2026-10
--
-- Ajoute l'entreprise (société AIFINITY SOLUTIONS, Saint-Cloud) comme
-- prestataire de services, catégorie « Prestation IA & data », avec une
-- prestation et leurs traductions anglaises. L'entreprise est mise en
-- Premium (partenariat croisé : pas de paiement Stripe).
--
-- Informations issues des registres publics (activité : développement de
-- solutions technologiques d'IA et de big data pour la gestion de ressources
-- stratégiques). verified = FALSE tant que le Kbis et le contact n'ont pas été
-- confirmés ; employees et contact_email laissés vides (inconnus).
--
-- Prérequis : supabase_add_geo_columns.sql, descriptions_en et name_en en place.
-- Idempotent : peut être relancé sans créer de doublon (et remet Premium si besoin).
-- ============================================================

INSERT INTO companies (name, country, hq, industry, site, logo, description, description_en, verified, premium, founded, city, department, region, lat, lng)
SELECT 'AiFinity', '🇫🇷 France', 'Saint-Cloud', 'Industrie & Manufacturing', 'https://www.aifinity.fr', '🤖',
  'Société française spécialisée dans le développement de solutions technologiques d''intelligence artificielle et de traitement de données massives (big data) pour la gestion de ressources stratégiques. Basée à Saint-Cloud (Hauts-de-Seine).',
  'French company specialising in the development of artificial intelligence and big-data technology solutions for the management of strategic resources. Based in Saint-Cloud (Hauts-de-Seine).',
  FALSE, TRUE, '2025', 'Saint-Cloud', 'Hauts-de-Seine', 'Île-de-France', 48.8449, 2.2178
WHERE NOT EXISTS (SELECT 1 FROM companies WHERE name = 'AiFinity');

-- Premium, même si la fiche existait déjà.
UPDATE companies SET premium = TRUE WHERE name = 'AiFinity';

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

-- Contrôle (doit renvoyer 1 ligne : premium = true, 1 prestation) :
SELECT c.name, c.premium, c.verified, count(p.id) AS prestations
FROM companies c LEFT JOIN products p ON p.company_id = c.id
WHERE c.name = 'AiFinity'
GROUP BY c.name, c.premium, c.verified;
