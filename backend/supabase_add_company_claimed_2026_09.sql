-- ============================================================
-- BUY-INNER — Distingue une fiche auto-soumise ("claimed") d'une
-- fiche construite par l'équipe Buy-inner à partir de données
-- publiques. Sert à ne plus afficher le bandeau "Fiche non
-- revendiquée" sur une entreprise qui s'est référencée elle-même
-- via le formulaire fournisseur (voir js/pages/admin.js
-- applyNewSubmission() et js/pages/entreprise.js).
-- À exécuter dans Supabase : SQL Editor → New query → Run
-- ============================================================

alter table public.companies add column if not exists claimed boolean not null default false;

-- ------------------------------------------------------------
-- IMPORTANT — comme pour image_url (voir supabase_product_images.sql),
-- la vue v_companies_summary doit aussi exposer "claimed", sinon le
-- site ne la verra jamais. Étapes :
--   1. Lance cette requête pour voir la définition actuelle de la vue :
--        select pg_get_viewdef('public.v_companies_summary'::regclass, true);
--   2. Copie le résultat, ajoute "c.claimed" (ou l'alias équivalent
--      utilisé pour la table companies dans cette vue) TOUT À LA FIN
--      de la liste des colonnes sélectionnées — CREATE OR REPLACE VIEW
--      n'autorise pas d'insérer une colonne au milieu, seulement de
--      l'ajouter en dernière position (sinon erreur 42P16).
--   3. Exécute : create or replace view public.v_companies_summary as <résultat modifié>;
-- (Je n'ai pas la définition exacte de cette vue, donc impossible de
-- l'écrire à l'avance sans risquer de casser une colonne existante.)
-- ------------------------------------------------------------
