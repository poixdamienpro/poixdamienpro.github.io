-- ============================================================
-- BUY-INEER — Photos produits
-- À exécuter dans Supabase : SQL Editor → New query → Run
-- Prérequis : avoir déjà exécuté supabase_product_submissions.sql
--             et supabase_admin_setup.sql
-- ============================================================

-- ------------------------------------------------------------
-- 1. Colonnes pour stocker l'URL de l'image
-- ------------------------------------------------------------
alter table public.products add column if not exists image_url text;
alter table public.product_submissions add column if not exists product_image_url text;

-- ------------------------------------------------------------
-- 1bis. IMPORTANT — la vue v_products_full doit aussi exposer image_url,
-- sinon le site ne la verra jamais (les vues ne suivent pas automatiquement
-- les nouvelles colonnes de la table). Étapes :
--   1. Lance cette requête pour voir la définition actuelle de la vue :
--        select pg_get_viewdef('public.v_products_full'::regclass, true);
--   2. Copie le résultat, ajoute "p.image_url," dans la liste des colonnes
--      sélectionnées (juste après p.icon ou p.price_label, par exemple).
--   3. Exécute : create or replace view public.v_products_full as <résultat modifié>;
-- (Je n'ai pas la définition exacte de cette vue, donc impossible de
-- l'écrire à l'avance sans risquer de casser une colonne existante.)
-- ------------------------------------------------------------

-- ------------------------------------------------------------
-- 2. Bucket de stockage "product-images" (public en lecture)
-- ------------------------------------------------------------
insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do nothing;

-- ------------------------------------------------------------
-- 3. Policies sur storage.objects pour ce bucket
--    - tout le monde peut lire (nécessaire pour afficher les photos sur le site)
--    - le public (anon) peut UNIQUEMENT déposer des fichiers dans le
--      dossier "submissions/" — pas modifier ni supprimer
--    - l'admin peut tout faire dans le bucket (ménage, déplacement, etc.)
-- ------------------------------------------------------------
drop policy if exists "public_read_product_images" on storage.objects;
create policy "public_read_product_images"
  on storage.objects for select
  using (bucket_id = 'product-images');

drop policy if exists "anon_upload_submissions_images" on storage.objects;
create policy "anon_upload_submissions_images"
  on storage.objects for insert
  to anon
  with check (
    bucket_id = 'product-images'
    and (storage.foldername(name))[1] = 'submissions'
  );

drop policy if exists "admin_manage_product_images" on storage.objects;
create policy "admin_manage_product_images"
  on storage.objects for all
  to authenticated
  using (bucket_id = 'product-images' and is_admin())
  with check (bucket_id = 'product-images' and is_admin());

-- ------------------------------------------------------------
-- Note : si tu veux limiter la taille max ou les types de fichiers
-- acceptés, fais-le dans Dashboard → Storage → product-images →
-- Configuration (ex: 5 MB max, image/* uniquement).
-- ------------------------------------------------------------
