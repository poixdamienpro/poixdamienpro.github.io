-- ============================================================
-- « Mot de passe oublié » en libre-service — 2026-10
--
-- password_reset_requests : une ligne par demande (adresse + IP), uniquement
-- pour limiter les abus (3 demandes par adresse et par heure, 10 par IP et par
-- heure). Lue et écrite UNIQUEMENT par le Worker (clé service_role) : RLS
-- activée, aucune policy, aucun droit pour anon / authenticated. Les lignes de
-- plus de 24 heures sont purgées par le Worker à chaque nouvelle demande.
--
-- À exécuter AVANT de redéployer le Worker : sans cette table, le Worker
-- refuse toute demande (503) plutôt que de rester sans limite.
-- Sûr à relancer.
-- ============================================================

CREATE TABLE IF NOT EXISTS public.password_reset_requests (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at timestamptz NOT NULL DEFAULT now(),
  email      text NOT NULL,
  ip         text NOT NULL
);
CREATE INDEX IF NOT EXISTS password_reset_requests_email_idx ON public.password_reset_requests (email, created_at DESC);
CREATE INDEX IF NOT EXISTS password_reset_requests_ip_idx ON public.password_reset_requests (ip, created_at DESC);
CREATE INDEX IF NOT EXISTS password_reset_requests_created_idx ON public.password_reset_requests (created_at);
ALTER TABLE public.password_reset_requests ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public.password_reset_requests FROM PUBLIC, anon, authenticated;

-- Contrôle (doit renvoyer 1 ligne) :
SELECT 'password_reset_requests' AS table_creee
FROM information_schema.tables
WHERE table_schema = 'public' AND table_name = 'password_reset_requests';
