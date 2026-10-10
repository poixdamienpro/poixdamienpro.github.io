-- ============================================================
-- Sécurisation de /api/send-email — 2026-10
--
-- L'email « Nous avons bien reçu votre soumission » n'est plus envoyé sur
-- simple demande du navigateur : le Worker vérifie en base que la soumission
-- existe pour cette adresse, qu'elle date de moins de 15 minutes et que la
-- confirmation n'a pas déjà été envoyée. Cette colonne sert de verrou
-- « une seule confirmation par soumission » (et de compteur : 3 maximum par
-- adresse et par jour).
--
-- À exécuter AVANT de redéployer le Worker : sans cette colonne, le Worker
-- ne peut plus vérifier les soumissions et n'envoie plus aucune confirmation.
-- Sûr à relancer.
-- ============================================================

ALTER TABLE public.product_submissions
  ADD COLUMN IF NOT EXISTS confirmation_sent_at timestamptz;

-- Contrôle (doit renvoyer 1 ligne) :
SELECT column_name FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'product_submissions' AND column_name = 'confirmation_sent_at';
