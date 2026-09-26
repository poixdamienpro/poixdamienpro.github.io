-- ============================================================
-- BUY-INNER — Passage à une gestion multi-comptes admin
-- À exécuter dans Supabase : SQL Editor → New query → Run
-- ============================================================
--
-- CONTEXTE
-- --------
-- is_admin() (voir backend/supabase_admin_setup.sql) vérifiait jusqu'ici
-- un email en dur dans le code SQL :
--   select auth.jwt() ->> 'email' = 'poixdamien.pro@gmail.com';
-- Impossible d'ajouter un deuxième admin sans modifier cette fonction.
--
-- Ce script remplace la vérification par une vraie table `admins`.
-- Point important : TOUTES les policies existantes (companies, products,
-- product_specs/bars/certs, company_tags, company_product_categories,
-- product_submissions, company_claims, leads...) appellent déjà
-- is_admin() PAR SON NOM — Postgres résout ce nom à chaque appel, donc
-- remplacer uniquement le corps de la fonction ci-dessous suffit à
-- mettre à jour TOUT le contrôle d'accès admin du site, sans toucher à
-- une seule policy existante.
-- ============================================================

-- ------------------------------------------------------------
-- 1. Table des admins
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.admins (
  user_id  uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email    text NOT NULL,
  added_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.admins ENABLE ROW LEVEL SECURITY;

GRANT SELECT, INSERT, UPDATE, DELETE ON public.admins TO authenticated;

-- Seuls les admins peuvent voir/gérer la liste des admins (sans quoi
-- n'importe quel compte fournisseur pourrait découvrir — ou pire,
-- manipuler — qui a les droits d'administration).
DROP POLICY IF EXISTS admin_can_view_admins ON public.admins;
CREATE POLICY admin_can_view_admins ON public.admins
  FOR SELECT TO authenticated USING (is_admin());

DROP POLICY IF EXISTS admin_can_manage_admins ON public.admins;
CREATE POLICY admin_can_manage_admins ON public.admins
  FOR ALL TO authenticated USING (is_admin()) WITH CHECK (is_admin());

-- ------------------------------------------------------------
-- 2. Migre l'admin actuel (email en dur) vers la table
-- ------------------------------------------------------------
INSERT INTO public.admins (user_id, email)
SELECT id, email FROM auth.users WHERE email = 'poixdamien.pro@gmail.com'
ON CONFLICT (user_id) DO NOTHING;

-- ------------------------------------------------------------
-- 3. Remplace is_admin() — vérifie l'appartenance à la table plutôt
--    qu'un email en dur. SECURITY DEFINER est nécessaire ici (contrairement
--    à l'ancienne version) : sans ça, la policy RLS de `admins` elle-même
--    rappellerait is_admin() en boucle infinie pour évaluer sa propre
--    visibilité. En SECURITY DEFINER, la requête interne à admins
--    s'exécute avec les droits du propriétaire de la fonction et
--    contourne la RLS — auth.uid() reste bien celui de l'utilisateur
--    réellement connecté, ce n'est que la vérification qui est court-
--    circuitée. Pattern standard recommandé par Supabase pour ce cas.
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.admins WHERE user_id = auth.uid()
  );
$$;

-- ------------------------------------------------------------
-- POUR AJOUTER UN NOUVEL ADMIN PLUS TARD
-- ------------------------------------------------------------
-- 1. Crée-lui un compte : Authentication → Users → Add user (comme pour
--    le premier admin, voir backend/supabase_admin_setup.sql étape 1).
-- 2. Puis, dans le SQL Editor :
--
--   INSERT INTO public.admins (user_id, email)
--   SELECT id, email FROM auth.users WHERE email = 'nouvel.admin@exemple.com'
--   ON CONFLICT (user_id) DO NOTHING;
--
-- Pour retirer un admin :
--   DELETE FROM public.admins WHERE email = 'ancien.admin@exemple.com';
--
-- ------------------------------------------------------------
-- VÉRIFICATION (à relancer après exécution)
-- ------------------------------------------------------------
-- SELECT email, added_at FROM admins ORDER BY added_at;
-- -> doit montrer poixdamien.pro@gmail.com au minimum.
