-- ============================================================
-- BUY-INNER — Renforce is_admin() pour exiger une session MFA (aal2)
-- À exécuter dans Supabase : SQL Editor → New query → Run
--
-- ⚠️ NE PAS EXÉCUTER TOUT DE SUITE. Étapes obligatoires avant :
--   1. Déployer le code du panneau admin avec la section "Sécurité du
--      compte" (js/pages/admin.js + pages/admin.html).
--   2. Te connecter au panneau admin (mot de passe seul, comme avant)
--      et cliquer "Activer" dans "Sécurité du compte" pour enrôler un
--      facteur TOTP (scanner le QR code, entrer le premier code).
--   3. Te déconnecter puis te reconnecter EN ENTIER (mot de passe +
--      code à 6 chiffres) et confirmer que le panneau s'affiche bien.
--
-- Si tu exécutes ce script AVANT d'avoir un facteur TOTP vérifié sur ton
-- compte, ta session n'atteindra jamais aal2 et is_admin() renverra
-- systématiquement false — TOUT accès admin sera bloqué, y compris pour
-- toi, jusqu'à annulation de ce script.
--
-- RÉCUPÉRATION si tu te bloques quand même : reviens dans ce même SQL
-- Editor (il tourne avec des droits qui contournent le RLS, indépendants
-- de la session du panneau admin) et exécute la requête de rollback tout
-- en bas de ce fichier, le temps de finir l'enrôlement MFA.
-- ============================================================

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.admins WHERE user_id = auth.uid()
  )
  AND coalesce(auth.jwt() ->> 'aal', 'aal1') = 'aal2';
$$;

-- ------------------------------------------------------------
-- VÉRIFICATION (à faire immédiatement après exécution)
-- ------------------------------------------------------------
-- 1. Bouton "Se déconnecter" dans le panneau admin.
-- 2. Reconnecte-toi : le code à 6 chiffres doit être demandé.
-- 3. Une fois le code saisi, le panneau (analytics, soumissions, RFQ...)
--    doit s'afficher normalement, comme avant ce script.
-- Si à l'étape 3 tu obtiens "Session expirée ou accès refusé" en boucle,
-- reviens ici et lance le rollback ci-dessous.

-- ------------------------------------------------------------
-- ROLLBACK — annule l'exigence aal2 (revient à la version posée par
-- backend/supabase_multi_admin.sql : appartenance à la table admins
-- uniquement, sans vérification du niveau MFA).
-- ------------------------------------------------------------
-- CREATE OR REPLACE FUNCTION public.is_admin()
-- RETURNS boolean
-- LANGUAGE sql
-- STABLE
-- SECURITY DEFINER
-- SET search_path = public
-- AS $$
--   SELECT EXISTS (
--     SELECT 1 FROM public.admins WHERE user_id = auth.uid()
--   );
-- $$;
