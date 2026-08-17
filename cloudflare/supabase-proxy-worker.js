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
//  - /pages/entreprise.html et /pages/produit.html : injecte le vrai
//    contenu (nom, description, specs) dans le HTML AVANT de le servir,
//    pour tout le monde (pas seulement les robots — zero risque de
//    cloaking, et ca evite aussi le flash "Chargement..." pour un vrai
//    visiteur). Sans ca, ces ~550 pages partent avec un HTML quasi vide
//    ("Chargement...") tant que le JS client n'a pas fini d'aller
//    chercher les donnees chez Supabase — Google les classait en
//    soft-404 / "decouvertes, non indexees" a cause de ca (voir Search
//    Console, aout 2026). Le JS client continue de tourner par-dessus
//    normalement (hydratation), ce bloc ne fait qu'ameliorer le tout
//    premier rendu.
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
// Routes a configurer (Settings -> Domains & Routes) :
//   www.buy-inner.com/api/*
//   www.buy-inner.com/pages/entreprise.html*
//   www.buy-inner.com/pages/produit.html*
//
// Cote site : js/data.js doit avoir
//   const SUPABASE_URL = 'https://www.buy-inner.com/api';
// a la place de l'URL *.supabase.co directe.
// ═══════════════════════════════

const SUPABASE_ORIGIN = 'https://pzejxwrtsglmiitbhpjr.supabase.co';
// Cle publique "anon" — deliberement embarquable cote client (identique
// a celle deja presente en clair dans js/data.js), pas un secret.
const SUPABASE_ANON = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB6ZWp4d3J0c2dsbWlpdGJocGpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE0MTEwNTMsImV4cCI6MjA5Njk4NzA1M30.-SpxNs7G_5nEuZCXL68lNVcCzFTyiaZc93dViix76Ok';
const GITHUB_PAGES_ORIGIN = 'https://poixdamienpro.github.io';
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

// ── Pré-rendu : injection du vrai contenu dans entreprise.html / produit.html ──
async function fetchRpcRow(rpcName, params) {
  const res = await fetch(`${SUPABASE_ORIGIN}/rest/v1/rpc/${rpcName}`, {
    method: 'POST',
    headers: { 'apikey': SUPABASE_ANON, 'Authorization': 'Bearer ' + SUPABASE_ANON, 'Content-Type': 'application/json' },
    body: JSON.stringify(params),
  });
  if (!res.ok) return null;
  const rows = await res.json();
  return (rows && rows[0]) || null;
}

class SetHtml {
  constructor(html) { this.html = html; }
  element(el) { el.setInnerContent(this.html, { html: true }); }
}
class SetAttr {
  constructor(attr, value) { this.attr = attr; this.value = value; }
  element(el) { el.setAttribute(this.attr, this.value); }
}

async function handleEntreprisePage(request, env, ctx) {
  const url = new URL(request.url);
  const cache = caches.default;
  const cacheKey = new Request(url.toString(), request);
  const cached = await cache.match(cacheKey);
  if (cached) return cached;

  const originRes = await fetch(GITHUB_PAGES_ORIGIN + '/pages/entreprise.html' + url.search);
  const id = url.searchParams.get('id');
  if (!id) return originRes;

  const c = await fetchRpcRow('get_company_by_id', { p_id: id });
  if (!c) return originRes;

  const title = `${c.name} — ${c.industry || ''} — Buy-inner`;
  const desc = (c.description || `${c.name}, équipementier ${c.industry || ''}`).slice(0, 160);
  const headerHtml = `<h1 class="page-title">${escapeHtml(c.name)}</h1><p class="page-subtitle">${escapeHtml(c.country || '')} · ${escapeHtml(c.hq || '')} — ${escapeHtml(c.industry || '')}</p>`;
  const bodyHtml = `
    <div class="modal-section">
      <div class="modal-section-title">Description</div>
      <p style="font-size:13px;color:var(--text2);line-height:1.7;margin:0">${escapeHtml(c.description || '')}</p>
    </div>
    <div class="modal-section">
      <div class="modal-section-title">Informations société</div>
      <div class="detail-grid">
        <div class="detail-item"><div class="detail-label">Fondée en</div><div class="detail-value">${escapeHtml(c.founded || '—')}</div></div>
        <div class="detail-item"><div class="detail-label">Effectifs</div><div class="detail-value">${escapeHtml(c.employees || '—')}</div></div>
        <div class="detail-item"><div class="detail-label">Secteur</div><div class="detail-value">${escapeHtml(c.industry || '—')}</div></div>
        <div class="detail-item"><div class="detail-label">Siège</div><div class="detail-value">${escapeHtml(c.hq || '—')}</div></div>
      </div>
    </div>`;

  let response = new HTMLRewriter()
    .on('title', new SetHtml(escapeHtml(title)))
    .on('meta[name="description"]', new SetAttr('content', desc))
    .on('#ent-header', new SetHtml(headerHtml))
    .on('#ent-body', new SetHtml(bodyHtml))
    .transform(originRes);

  response = new Response(response.body, response);
  response.headers.set('Cache-Control', 'public, max-age=600');
  ctx.waitUntil(cache.put(cacheKey, response.clone()));
  return response;
}

async function handleProduitPage(request, env, ctx) {
  const url = new URL(request.url);
  const cache = caches.default;
  const cacheKey = new Request(url.toString(), request);
  const cached = await cache.match(cacheKey);
  if (cached) return cached;

  const originRes = await fetch(GITHUB_PAGES_ORIGIN + '/pages/produit.html' + url.search);
  const id = url.searchParams.get('id');
  if (!id) return originRes;

  const p = await fetchRpcRow('get_product_by_id', { p_id: id });
  if (!p) return originRes;

  const title = `${p.name} — ${p.company_name || ''} — Buy-inner`;
  const desc = (p.description || `${p.name} par ${p.company_name || ''}`).slice(0, 160);
  const headerHtml = `<h1 class="page-title">${escapeHtml(p.icon || '')} ${escapeHtml(p.name)}</h1><p class="page-subtitle">${escapeHtml(p.company_name || '')} — ${escapeHtml(p.category || '')} ${p.industry ? '· ' + escapeHtml(p.industry) : ''}</p>`;
  const bodyHtml = `
    <div class="modal-section">
      <div class="modal-section-title">Description</div>
      <p style="font-size:13px;color:var(--text2);line-height:1.7;margin:0">${escapeHtml(p.description || '')}</p>
    </div>
    <div class="modal-section">
      <div class="modal-section-title">Fabricant</div>
      <p style="font-size:13px;color:var(--text2);line-height:1.7;margin:0">${escapeHtml(p.company_name || '')} — <a href="entreprise.html?id=${escapeHtml(p.company_id || '')}">Voir la fiche →</a></p>
    </div>`;

  let response = new HTMLRewriter()
    .on('title', new SetHtml(escapeHtml(title)))
    .on('meta[name="description"]', new SetAttr('content', desc))
    .on('#prod-header', new SetHtml(headerHtml))
    .on('#prod-body', new SetHtml(bodyHtml))
    .transform(originRes);

  response = new Response(response.body, response);
  response.headers.set('Cache-Control', 'public, max-age=600');
  ctx.waitUntil(cache.put(cacheKey, response.clone()));
  return response;
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
  async fetch(request, env, ctx) {
    const url = new URL(request.url);

    if (url.pathname === '/pages/entreprise.html') {
      return handleEntreprisePage(request, env, ctx);
    }
    if (url.pathname === '/pages/produit.html') {
      return handleProduitPage(request, env, ctx);
    }

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
