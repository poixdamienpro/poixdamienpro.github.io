// ═══════════════════════════════
// WORKER — relaie www.buy-inner.com/api/* vers Supabase, pour que le
// navigateur n'ait jamais besoin d'appeler *.supabase.co directement.
// Certains reseaux d'entreprise bloquent ce domaine par categorie ;
// passer par notre propre domaine contourne le probleme.
//
// Expose aussi :
//  - /api/send-email : emails transactionnels via Resend (confirmation
//    de soumission, publication, revendication approuvee, cf plus bas).
//  - /api/create-checkout-session : cree une session de paiement Stripe
//    (abonnement Premium 1500€/an) pour une entreprise deja revendiquee.
//  - /api/stripe-webhook : recoit les evenements Stripe (paiement reussi,
//    abonnement annule/impaye) et met a jour companies.premium en base.
//
// Toutes les cles secretes (RESEND_API_KEY, STRIPE_SECRET_KEY,
// STRIPE_WEBHOOK_SECRET, STRIPE_PRICE_ID, SUPABASE_SERVICE_ROLE_KEY)
// vivent UNIQUEMENT en variables secretes du Worker (Settings ->
// Variables and Secrets) — jamais exposees au navigateur. En particulier
// SUPABASE_SERVICE_ROLE_KEY contourne toute la RLS : elle ne doit
// JAMAIS atterrir dans un fichier du site, seulement ici.
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
const STRIPE_API = 'https://api.stripe.com/v1';
const SITE_URL = 'https://www.buy-inner.com';

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
  premium_activated: ({ companyName, link }) => ({
    subject: 'Buy-inner — Bienvenue dans Premium !',
    html: `<p>Bonjour,</p>
      <p>Votre abonnement <strong>Premium</strong> pour <strong>${escapeHtml(companyName)}</strong> est actif : badge ★ Premium, mise en avant prioritaire, profil enrichi.</p>
      <p><a href="${escapeHtml(link)}">Accéder à votre espace fournisseur →</a></p>
      <p>— L'équipe Buy-inner</p>`,
  }),
};

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Stripe-Signature',
};

function json(obj, status = 200) {
  return new Response(JSON.stringify(obj), {
    status,
    headers: { 'Content-Type': 'application/json', ...CORS_HEADERS },
  });
}

// ── Emails transactionnels (Resend) ──────────────────────────────────
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

// ── Stripe : création de la session de paiement Premium ─────────────
async function handleCreateCheckoutSession(request, env) {
  let body;
  try { body = await request.json(); } catch { return json({ error: 'JSON invalide' }, 400); }

  const { companyId, companyName, email } = body || {};
  if (!companyId || !email) return json({ error: 'companyId et email requis' }, 400);
  if (!env.STRIPE_SECRET_KEY || !env.STRIPE_PRICE_ID) {
    return json({ error: 'Stripe non configuré sur le Worker' }, 500);
  }

  const params = new URLSearchParams();
  params.set('mode', 'subscription');
  params.set('line_items[0][price]', env.STRIPE_PRICE_ID);
  params.set('line_items[0][quantity]', '1');
  params.set('client_reference_id', companyId);
  params.set('customer_email', email);
  params.set('metadata[company_id]', companyId);
  params.set('metadata[company_name]', companyName || '');
  params.set('subscription_data[metadata][company_id]', companyId);
  params.set('success_url', `${SITE_URL}/pages/supplier.html?premium=success`);
  params.set('cancel_url', `${SITE_URL}/pages/supplier.html?premium=cancelled`);

  const res = await fetch(`${STRIPE_API}/checkout/sessions`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${env.STRIPE_SECRET_KEY}`,
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: params.toString(),
  });
  const data = await res.json();
  if (!res.ok) return json({ error: data.error?.message || 'Erreur Stripe' }, 502);
  return json({ url: data.url });
}

// Vérifie la signature Stripe (HMAC-SHA256 sur "timestamp.rawBody"),
// voir https://docs.stripe.com/webhooks#verify-manually
async function verifyStripeSignature(rawBody, sigHeader, secret) {
  if (!sigHeader) return false;
  const parts = Object.fromEntries(sigHeader.split(',').map(p => p.split('=')));
  const timestamp = parts.t;
  const sig = parts.v1;
  if (!timestamp || !sig) return false;

  const encoder = new TextEncoder();
  const key = await crypto.subtle.importKey(
    'raw', encoder.encode(secret), { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']
  );
  const signatureBuffer = await crypto.subtle.sign('HMAC', key, encoder.encode(`${timestamp}.${rawBody}`));
  const computedSig = [...new Uint8Array(signatureBuffer)].map(b => b.toString(16).padStart(2, '0')).join('');
  return computedSig === sig;
}

async function patchCompanies(env, filterQuery, patchBody) {
  await fetch(`${SUPABASE_ORIGIN}/rest/v1/companies?${filterQuery}`, {
    method: 'PATCH',
    headers: {
      'apikey': env.SUPABASE_SERVICE_ROLE_KEY,
      'Authorization': `Bearer ${env.SUPABASE_SERVICE_ROLE_KEY}`,
      'Content-Type': 'application/json',
      'Prefer': 'return=minimal',
    },
    body: JSON.stringify(patchBody),
  });
}

async function handleStripeWebhook(request, env) {
  if (!env.STRIPE_WEBHOOK_SECRET || !env.SUPABASE_SERVICE_ROLE_KEY) {
    return json({ error: 'Webhook Stripe non configuré sur le Worker' }, 500);
  }
  const rawBody = await request.text();
  const sigHeader = request.headers.get('Stripe-Signature');
  const valid = await verifyStripeSignature(rawBody, sigHeader, env.STRIPE_WEBHOOK_SECRET);
  if (!valid) return json({ error: 'Signature invalide' }, 400);

  let event;
  try { event = JSON.parse(rawBody); } catch { return json({ error: 'JSON invalide' }, 400); }

  if (event.type === 'checkout.session.completed') {
    const session = event.data.object;
    const companyId = session.client_reference_id || (session.metadata && session.metadata.company_id);
    if (companyId) {
      await patchCompanies(env, `id=eq.${companyId}`, {
        premium: true,
        stripe_customer_id: session.customer || null,
        stripe_subscription_id: session.subscription || null,
      });
      const companyName = (session.metadata && session.metadata.company_name) || 'votre entreprise';
      if (session.customer_details && session.customer_details.email) {
        // best-effort, ne bloque jamais le traitement du webhook
        handleSendEmail(new Request('https://x/', {
          method: 'POST',
          body: JSON.stringify({
            type: 'premium_activated',
            to: session.customer_details.email,
            params: { companyName, link: `${SITE_URL}/pages/supplier.html` },
          }),
        }), env).catch(() => {});
      }
    }
  } else if (event.type === 'customer.subscription.deleted') {
    const sub = event.data.object;
    await patchCompanies(env, `stripe_subscription_id=eq.${sub.id}`, { premium: false });
  } else if (event.type === 'customer.subscription.updated') {
    const sub = event.data.object;
    if (sub.status === 'canceled' || sub.status === 'unpaid') {
      await patchCompanies(env, `stripe_subscription_id=eq.${sub.id}`, { premium: false });
    }
  }

  return json({ received: true });
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (url.pathname === '/api/send-email') {
      if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: CORS_HEADERS });
      if (request.method === 'POST') return handleSendEmail(request, env);
      return json({ error: 'Method not allowed' }, 405);
    }

    if (url.pathname === '/api/create-checkout-session') {
      if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: CORS_HEADERS });
      if (request.method === 'POST') return handleCreateCheckoutSession(request, env);
      return json({ error: 'Method not allowed' }, 405);
    }

    if (url.pathname === '/api/stripe-webhook') {
      if (request.method === 'POST') return handleStripeWebhook(request, env);
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
