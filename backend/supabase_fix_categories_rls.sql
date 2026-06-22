-- Fix : autorise la lecture publique (anon) de company_product_categories
-- RLS est activé sur cette table (confirmé) mais aucune policy de lecture
-- publique n'existe probablement -> le site reçoit un tableau vide en
-- silence (pas d'erreur réseau), donc PROD_CATS reste vide et les
-- catégories ne s'affichent jamais.
-- Idempotent : peut être relancé sans erreur.

DROP POLICY IF EXISTS company_product_categories_read_all ON company_product_categories;

CREATE POLICY company_product_categories_read_all
  ON company_product_categories
  FOR SELECT
  TO anon, authenticated
  USING (true);

-- Vérification : la policy doit apparaître ci-dessous après exécution
SELECT schemaname, tablename, policyname, roles, cmd
FROM pg_policies
WHERE tablename = 'company_product_categories';
