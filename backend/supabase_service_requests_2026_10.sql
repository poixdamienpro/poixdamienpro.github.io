-- ============================================================
-- BUY-INNER — Demandes de devis « Accompagnement à la transformation des équipements » — 2026-10
--
-- Service proposé par Buy-inner lui-même (qualification ou transformation d'un équipement
-- pour l'adapter à un autre domaine), vendu sur devis. Cette table reçoit les demandes du
-- formulaire public (pages/accompagnement-transformation-equipements.html et sa version
-- anglaise) ; les administrateurs les suivent dans l'onglet « Accompagnement » de
-- pages/admin.html.
--
--   * Visiteur anonyme : peut CRÉER une demande, jamais la relire.
--   * Administrateurs (is_admin()) : lisent, changent le statut, annotent, suppriment.
--   * Anti-abus : 5 demandes / 24 h par adresse email, 200 / heure au total.
--
-- Prérequis : is_admin() (supabase_admin_setup.sql / supabase_multi_admin.sql).
-- Idempotent : peut être relancé sans risque.
-- ============================================================

CREATE TABLE IF NOT EXISTS public.service_requests (
  id             uuid primary key default gen_random_uuid(),
  service        text not null default 'equipment_transformation',
  contact_name   text not null,
  contact_email  text not null,
  contact_phone  text,
  company        text not null,
  equipment      text not null,          -- l'équipement concerné
  source_domain  text,                   -- domaine d'origine de l'équipement
  target_domain  text,                   -- domaine visé
  objective      text,                   -- qualification | transformation | both | unsure
  message        text not null,
  lang           text not null default 'fr',
  status         text not null default 'new',   -- new | in_progress | quoted | closed
  admin_note     text,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),
  CONSTRAINT service_requests_status_chk    CHECK (status IN ('new','in_progress','quoted','closed')),
  CONSTRAINT service_requests_objective_chk CHECK (objective IS NULL OR objective IN ('qualification','transformation','both','unsure')),
  CONSTRAINT service_requests_lang_chk      CHECK (lang IN ('fr','en')),
  CONSTRAINT service_requests_email_chk     CHECK (contact_email ~ '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$' AND char_length(contact_email) <= 254),
  CONSTRAINT service_requests_len_chk       CHECK (
    char_length(contact_name) BETWEEN 1 AND 120
    AND char_length(company) BETWEEN 1 AND 160
    AND char_length(equipment) BETWEEN 1 AND 300
    AND char_length(message) BETWEEN 10 AND 5000
    AND (contact_phone IS NULL OR char_length(contact_phone) <= 40)
    AND (source_domain IS NULL OR char_length(source_domain) <= 120)
    AND (target_domain IS NULL OR char_length(target_domain) <= 120)
    AND (admin_note IS NULL OR char_length(admin_note) <= 5000)
  )
);

CREATE INDEX IF NOT EXISTS service_requests_status_created_idx ON public.service_requests (status, created_at DESC);

ALTER TABLE public.service_requests ENABLE ROW LEVEL SECURITY;

-- Un visiteur ne peut créer qu'une demande « neuve » et sans note interne.
DROP POLICY IF EXISTS anon_can_insert_service_requests ON public.service_requests;
CREATE POLICY anon_can_insert_service_requests ON public.service_requests
  FOR INSERT TO anon, authenticated
  WITH CHECK (status = 'new' AND admin_note IS NULL);

DROP POLICY IF EXISTS admin_all_service_requests ON public.service_requests;
CREATE POLICY admin_all_service_requests ON public.service_requests
  FOR ALL TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- Le projet retire les droits par défaut : on les accorde explicitement.
REVOKE ALL ON public.service_requests FROM anon, authenticated;
GRANT INSERT ON public.service_requests TO anon, authenticated;
GRANT SELECT, UPDATE, DELETE ON public.service_requests TO authenticated;

-- Anti-abus + horodatage (SECURITY DEFINER : le visiteur ne peut pas lire la table, mais le
-- contrôle doit pouvoir compter les demandes déjà reçues).
CREATE OR REPLACE FUNCTION public._service_requests_guard()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    NEW.contact_email := lower(btrim(NEW.contact_email));
    IF (SELECT count(*) FROM public.service_requests
         WHERE contact_email = NEW.contact_email AND created_at > now() - interval '24 hours') >= 5 THEN
      RAISE EXCEPTION 'SERVICE_REQUEST_RATE_LIMIT' USING ERRCODE = 'P0001';
    END IF;
    IF (SELECT count(*) FROM public.service_requests WHERE created_at > now() - interval '1 hour') >= 200 THEN
      RAISE EXCEPTION 'SERVICE_REQUEST_RATE_LIMIT' USING ERRCODE = 'P0001';
    END IF;
  ELSE
    NEW.updated_at := now();
  END IF;
  RETURN NEW;
END;
$$;
REVOKE ALL ON FUNCTION public._service_requests_guard() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS service_requests_guard ON public.service_requests;
CREATE TRIGGER service_requests_guard
  BEFORE INSERT OR UPDATE ON public.service_requests
  FOR EACH ROW EXECUTE FUNCTION public._service_requests_guard();

-- Contrôle : doit renvoyer la table, RLS actif, 2 policies.
SELECT c.relname, c.relrowsecurity AS rls,
       (SELECT count(*) FROM pg_policies p WHERE p.schemaname = 'public' AND p.tablename = 'service_requests') AS policies
FROM pg_class c
WHERE c.oid = 'public.service_requests'::regclass;
