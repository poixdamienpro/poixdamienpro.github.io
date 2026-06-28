-- ============================================================
-- BUY-INEER — Fermeture du contournement anti-scraping
-- À exécuter dans Supabase : SQL Editor → New query → Run
-- ============================================================
--
-- CONTEXTE / PROBLÈME
-- -------------------
-- L'étape 2 de supabase_anti_scraping_pagination.sql a bien révoqué
-- l'accès direct aux VUES (v_companies_summary / v_products_full).
-- MAIS la clé anon (publique, visible dans js/data.js) conserve un
-- GRANT SELECT direct sur les TABLES DE BASE. Résultat : on contourne
-- entièrement les RPC paginées en tapant les tables directement, puis
-- en bouclant avec ?offset= (le plafond de 50 lignes est juste la
-- pagination par défaut de PostgREST, PAS une protection).
--
-- Vérifié en live (clé anon) le 2026-06-28 :
--   GET /rest/v1/companies?offset=0/50  -> 73 sociétés dumpées en 2 requêtes
--   GET /rest/v1/products?offset=...     -> 251 produits accessibles
--   product_specs / product_certs / product_bars -> lisibles directement
--
-- POURQUOI CE SCRIPT, ET PAS « JUSTE ACTIVER LA RLS »
-- --------------------------------------------------
-- La RLS FILTRE par règle, elle ne PLAFONNE jamais le nombre de lignes.
-- Tant que `anon` garde le privilège SELECT, le scraping reste possible.
-- C'est le REVOKE qui ferme la porte. Les RPC get_companies_page() /
-- get_products_page() tournent en SECURITY DEFINER : elles continuent
-- de lire les tables même après ce revoke, donc le site n'est pas cassé.
--
-- SÉCURITÉ DE DÉPLOIEMENT
-- ----------------------
-- Le front (js/api.js) lit companies/products/specs/bars/certs UNIQUEMENT
-- via les RPC. Aucune lecture directe de ces tables côté client.
-- => Ce revoke ne casse rien. Aucune coordination de déploiement requise.
-- ============================================================

-- ------------------------------------------------------------
-- 1. Couper l'accès direct en lecture aux tables du catalogue.
--    La lecture publique passe désormais EXCLUSIVEMENT par les RPC
--    paginées (max 50 lignes/page).
-- ------------------------------------------------------------
revoke select on public.companies     from anon, authenticated;
revoke select on public.products      from anon, authenticated;
revoke select on public.product_specs from anon, authenticated;
revoke select on public.product_bars  from anon, authenticated;
revoke select on public.product_certs from anon, authenticated;

-- ------------------------------------------------------------
-- 2. Filet de sécurité : empêcher qu'un futur `grant select ... to anon`
--    accidentel (ou un nouveau membre du rôle) ne rouvre la porte.
--    On verrouille aussi les privilèges par défaut.
-- ------------------------------------------------------------
alter default privileges in schema public revoke select on tables from anon, authenticated;

-- ------------------------------------------------------------
-- NOTES — ce qu'on NE touche pas, et pourquoi
-- ------------------------------------------------------------
-- • company_product_categories : lue EN DIRECT par le front (filtrage,
--   113 lignes). C'est une simple table de correspondance
--   (company_id -> catégorie), à faible valeur — l'info est déjà visible
--   société par société sur le site public. On la laisse lisible pour ne
--   pas casser le filtrage. Si tu veux la fermer aussi : crée une RPC
--   security-definer `get_company_categories()` et fais pointer
--   js/api.js (ligne ~88) dessus avant de révoquer.
--
-- • company_tags : table actuellement VIDE (0 ligne). Lue en direct par
--   le front mais sans impact tant qu'elle est vide. Même remarque que
--   ci-dessus si tu la remplis un jour.
--
-- • v_companies_summary / v_products_full : déjà révoquées (OK).
-- • product_submissions / company_claims / site_page_views : déjà
--   protégées par RLS (lecture anon renvoie 0 ligne). OK.

-- ------------------------------------------------------------
-- 3. VÉRIFICATION (à relancer avec la clé anon après exécution)
-- ------------------------------------------------------------
-- Attendu APRÈS ce script, avec la clé anon :
--   GET /rest/v1/companies?select=*        -> 401/403 (permission denied)
--   GET /rest/v1/products?select=*         -> 401/403
--   POST /rest/v1/rpc/get_companies_page   -> 200, <= 50 lignes  (OK, site marche)
--   POST /rest/v1/rpc/get_products_page    -> 200, <= 50 lignes  (OK, site marche)
