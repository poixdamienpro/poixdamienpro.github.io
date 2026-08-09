// ═══════════════════════════════
// WORKER — relaie www.buy-inner.com/api/* vers Supabase, pour que le
// navigateur n'ait jamais besoin d'appeler *.supabase.co directement.
// Certains reseaux d'entreprise bloquent ce domaine par categorie ;
// passer par notre propre domaine contourne le probleme.
//
// Expose aussi /api/send-email : emails transactionnels via Resend
// (confirmation de soumission, publication, revendication approuvee).
// La cle Resend reste secrete cote Worker (variable RESEND_API_KEY,
// Settings -> Variables and Secrets) — jamais exposee au navigateur,
// contrairement a la cle Web3Forms (publique par design, voir
// js/leads.js) qui elle ne peut pas envoyer vers un destinataire
// arbitraire. Le contenu des emails est fixe (3 templates ci-dessous) :
// le client ne peut choisir QUE le destinataire et quelques parametres
// de personnalisation, jamais le sujet/corps libre — ca evite que cette
// route publique serve de relai spam generique.
//
// Deploiement : colle ce fichier tel quel dans l'editeur du Worker sur
// le dashboard Cloudflare (Workers & Pages -> ton worker -> Edit code).
// Route a configurer : www.buy-inner.com/api/*
// (voir Settings -> Domains & Routes sur le Worker)
//
// Cote site : js/data.js doit avoir
//   const SUPABASE_URL = 'https://www.buy-inner.com/api';
// a la place de l'URL *.supabase.co directe.
// ═══════════════════════════════

const SUPABASE_ORIGIN = 'https://pzejxwrtsglmiitbhpjr.supabase.co';
const RESEND_FROM = 'Buy-inner <noreply@buy-inner.com>';

function escapeHtml(s) {
  return String(s == null ? '' : s).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
}

const EMAIL_TEMPLATES = {
  submission_confirmation: ({ submitterName, companyName }) => ({
    subject: 'Buy-inner — Confirmation de votre soumission',
    html: `<p>Bonjour ${escapeHtml(submitterName)},</p>
      <p>Nous avons bien reçu votre soumission pour <strong>${escapeHtml(companyName)}</strong>.</p>
      <p>Elle va être examinée par notre équipe, et vous serez recontacté à cette adresse dès que la fiche sera publiée sur Buy-inner.</p>
      <p>— L'équipe Buy-inner</p>`,
  }),
  submission_approved: ({ submitterName, companyName, link }) => ({
    subject: 'Buy-inner — Votre fiche est publiée !',
    html: `<p>Bonjour ${escapeHtml(submitterName)},</p>
      <p>Bonne nouvelle : <strong>${escapeHtml(companyName)}</strong> est maintenant visible sur Buy-inner.</p>
      <p><a href="${escapeHtml(link)}">Consulter votre fiche →</a></p>
      <p>— L'équipe Buy-inner</p>`,
  }),
  claim_approved: ({ companyName, link }) => ({
    subject: 'Buy-inner — Votre revendication est approuvée',
    html: `<p>Bonjour,</p>
      <p>Votre demande de revendication pour <strong>${escapeHtml(companyName)}</strong> a été approuvée.</p>
      <p><a href="${escapeHtml(link)}">Accéder à votre espace fournisseur →</a></p>
      <p>— L'équipe Buy-inner</p>`,
  }),
};

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};

function json(obj, status = 200) {
  return new Response(JSON.stringify(obj), {
    status,
    headers: { 'Content-Type': 'application/json', ...CORS_HEADERS },
  });
}

async function handleSendEmail(request, env) {
  let body;
  try { body = await request.json(); } catch { return json({ error: 'JSON invalide' }, 400); }

  const { type, to, params } = body || {};
  const template = EMAIL_TEMPLATES[type];
  if (!template) return json({ error: 'type de template inconnu' }, 400);
  if (!to || typeof to !== 'string' || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(to)) {
    return json({ error: 'destinataire invalide' }, 400);
  }
  if (!env.RESEND_API_KEY) return json({ error: 'RESEND_API_KEY non configurée sur le Worker' }, 500);

  const { subject, html } = template(params || {});

  const res = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${env.RESEND_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ from: RESEND_FROM, to: [to], subject, html }),
  });

  if (!res.ok) {
    const detail = await res.text();
    return json({ error: 'Échec envoi Resend', detail }, 502);
  }
  return json({ success: true });
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (url.pathname === '/api/send-email') {
      if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: CORS_HEADERS });
      if (request.method === 'POST') return handleSendEmail(request, env);
      return json({ error: 'Method not allowed' }, 405);
    }

    if (!url.pathname.startsWith('/api/')) {
      return new Response('Not found', { status: 404 });
    }

    // /api/rest/v1/... -> https://xxx.supabase.co/rest/v1/...
    const target = SUPABASE_ORIGIN + url.pathname.slice('/api'.length) + url.search;

    const proxied = new Request(target, {
      method: request.method,
      headers: request.headers,
      body: (request.method === 'GET' || request.method === 'HEAD') ? undefined : request.body,
    });

    return fetch(proxied);
  },
};
