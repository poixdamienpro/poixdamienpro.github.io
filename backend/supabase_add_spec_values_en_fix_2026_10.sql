-- ============================================================
-- Rattrapage : 13 valeurs de caractéristiques restées en français
-- (durées en « ans », « (option) ») après supabase_add_spec_values_en_2026_10.sql.
-- Trouvées par l'audit en ligne du 2026-10-06.
-- Sûr à relancer : ne remplit que les lignes où value_en IS NULL.
-- ============================================================

UPDATE product_specs AS s
SET value_en = v.en
FROM (VALUES
  ('UART RS422, CAN (option)', 'UART RS422, CAN (optional)'),
  ('15 ans GEO', '15 years GEO'),
  ('> 10 ans LEO', '> 10 years LEO'),
  ('> 15 ans', '> 15 years'),
  ('5 ans (LEO)', '5 years (LEO)'),
  ('≥ 2 ans', '≥ 2 years'),
  ('≥ 5 ans', '≥ 5 years'),
  ('15 ans', '15 years'),
  ('5 ans+', '5+ years'),
  ('> 3 ans', '> 3 years'),
  ('30 ans', '30 years'),
  ('7 ans', '7 years'),
  ('10 ans', '10 years')
) AS v(fr, en)
WHERE s.value = v.fr
  AND s.value_en IS NULL;

-- Contrôle : doit renvoyer 0 ligne.
SELECT value FROM product_specs WHERE value_en IS NULL AND value ~* '\mans\M';
