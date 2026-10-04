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
//  - /api/admin-create-user : cree un compte Supabase Auth (et
//    eventuellement l'ajoute a la table admins), appele depuis
//    pages/admin.html. Verifie d'abord que l'appelant est lui-meme
//    admin avant de toucher a SUPABASE_SERVICE_ROLE_KEY.
//  - /en/company.html et /en/product.html : versions anglaises des deux
//    pages ci-dessous (mêmes données, description_en, catégories/pays
//    traduits). Une fiche anglaise n'est indexable (robots index,follow +
//    balises hreflang fr/en/x-default sur les DEUX versions) que si elle
//    a une description_en ; sinon elle reste noindex et aucune balise
//    hreflang n'est émise, pour ne jamais présenter à Google une page
//    « anglaise » qui serait en fait du français.
//  - /sitemap-fr.xml et /sitemap-en.xml : sitemaps dynamiques des fiches
//    (toutes les fiches visibles en FR ; seulement les fiches traduites en
//    EN), déclarés dans robots.txt, régénérés depuis la base (cache 1 h).
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
//   www.buy-inner.com/en/company.html*
//   www.buy-inner.com/en/product.html*
//   www.buy-inner.com/sitemap-en.xml
//   www.buy-inner.com/sitemap-fr.xml
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

// Génère un mot de passe temporaire aléatoire (affiché une seule fois
// à l'admin appelant, qui le transmet lui-même à la nouvelle personne).
function generateTempPassword() {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789!@#$%';
  const bytes = new Uint8Array(20);
  crypto.getRandomValues(bytes);
  return Array.from(bytes, b => chars[b % chars.length]).join('');
}

// ── Admin : création d'un nouveau compte (et éventuellement admin) ──
// Nécessite SUPABASE_SERVICE_ROLE_KEY (contourne toute la RLS) : on
// vérifie donc nous-mêmes, ici, que l'appelant est déjà un admin
// authentifié AVANT de faire quoi que ce soit avec cette clé.
async function handleAdminCreateUser(request, env) {
  if (!env.SUPABASE_SERVICE_ROLE_KEY) {
    return json({ error: 'SUPABASE_SERVICE_ROLE_KEY non configurée sur le Worker' }, 500);
  }

  const authHeader = request.headers.get('Authorization') || '';
  const callerToken = authHeader.replace(/^Bearer\s+/i, '');
  if (!callerToken) return json({ error: 'Non authentifié' }, 401);

  // 1. Résout l'identité de l'appelant à partir de son propre token.
  const whoRes = await fetch(`${SUPABASE_ORIGIN}/auth/v1/user`, {
    headers: { 'apikey': SUPABASE_ANON, 'Authorization': `Bearer ${callerToken}` },
  });
  if (!whoRes.ok) return json({ error: 'Session invalide' }, 401);
  const caller = await whoRes.json();

  // 2. Vérifie que l'appelant est bien dans la table admins (lecture
  //    avec la clé service_role, qui ignore la RLS — c'est la seule
  //    source de vérité ici, pas confiance dans le token seul).
  const checkRes = await fetch(`${SUPABASE_ORIGIN}/rest/v1/admins?user_id=eq.${caller.id}&select=user_id`, {
    headers: { 'apikey': env.SUPABASE_SERVICE_ROLE_KEY, 'Authorization': `Bearer ${env.SUPABASE_SERVICE_ROLE_KEY}` },
  });
  if (!checkRes.ok) {
    const detail = await checkRes.text();
    return json({ error: 'Échec de la vérification admin', detail }, 502);
  }
  const checkRows = await checkRes.json();
  if (!checkRows.length) return json({ error: 'Accès refusé : tu n\'es pas administrateur' }, 403);

  // 3. Crée le compte Supabase Auth.
  let body;
  try { body = await request.json(); } catch { return json({ error: 'JSON invalide' }, 400); }
  const newEmail = (body && body.newEmail || '').trim().toLowerCase();
  const makeAdmin = !!(body && body.makeAdmin);
  if (!newEmail || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(newEmail)) {
    return json({ error: 'Email invalide' }, 400);
  }

  const tempPassword = generateTempPassword();
  const createRes = await fetch(`${SUPABASE_ORIGIN}/auth/v1/admin/users`, {
    method: 'POST',
    headers: {
      'apikey': env.SUPABASE_SERVICE_ROLE_KEY,
      'Authorization': `Bearer ${env.SUPABASE_SERVICE_ROLE_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ email: newEmail, password: tempPassword, email_confirm: true }),
  });
  const created = await createRes.json();
  if (!createRes.ok) {
    return json({ error: created.msg || created.message || 'Échec de la création du compte' }, 502);
  }

  // 4. Si demandé, ajoute le nouveau compte à la table admins.
  if (makeAdmin) {
    const addRes = await fetch(`${SUPABASE_ORIGIN}/rest/v1/admins`, {
      method: 'POST',
      headers: {
        'apikey': env.SUPABASE_SERVICE_ROLE_KEY,
        'Authorization': `Bearer ${env.SUPABASE_SERVICE_ROLE_KEY}`,
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      body: JSON.stringify({ user_id: created.id, email: newEmail }),
    });
    if (!addRes.ok) {
      const detail = await addRes.text();
      return json({ error: 'Compte créé mais échec de l\'ajout comme admin', detail }, 502);
    }
  }

  return json({ success: true, email: newEmail, tempPassword, isAdmin: makeAdmin });
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

// ── Pré-rendu bilingue ──────────────────────────────────────────────
// Dictionnaires EN : copie de TAXONOMY_EN / COUNTRY_EN de js/i18n.js — à
// remettre à jour ici quand une catégorie, une industrie ou un pays est
// ajouté côté site (sinon le nom français reste affiché, sans casser).
const TAXONOMY_EN = {
  'Actionneurs & GNC': 'Actuators & GNC',
  'Amplificateurs RF': 'RF amplifiers',
  'Batteries & Stockage': 'Batteries & Storage',
  'BMS': 'BMS',
  'Bornes de recharge': 'Charging stations',
  'Calculateurs embarqués': 'Onboard computers',
  'Calculateurs embarqués Edge IA': 'Onboard Edge AI computers',
  'Capteurs & Instrumentation': 'Sensors & Instrumentation',
  'Capteurs ADAS': 'ADAS sensors',
  'Cellules accumulateurs': 'Battery cells',
  'Chargeur embarqué': 'Onboard charger',
  'Connecteurs sous-marins': 'Underwater connectors',
  'Contrôle thermique': 'Thermal control',
  'Convertisseurs & Onduleurs': 'Converters & Inverters',
  'Câblage & Connecteurs': 'Cabling & Connectors',
  'Distribution de composants': 'Component distribution',
  'Drones & UAV': 'Drones & UAVs',
  'Développement d\'équipements': 'Equipment development',
  'Essais & qualification': 'Testing & qualification',
  'Fabrication de faisceaux électriques': 'Wiring harness manufacturing',
  'Hydrogène & Énergie': 'Hydrogen & Energy',
  'Impression 3D béton': 'Concrete 3D printing',
  'Impression 3D métal': 'Metal 3D printing',
  'Informatique quantique': 'Quantum computing',
  'Infrastructure SpaceVPX': 'SpaceVPX infrastructure',
  'Intégration & assemblage système': 'System integration & assembly',
  'Lanceurs': 'Launch vehicles',
  'Logiciels & Systèmes MRO': 'MRO software & systems',
  'Logiciels de cybersécurité': 'Cybersecurity software',
  'Logiciels de supervision': 'Monitoring software',
  'MGSE & Outillage sol': 'MGSE & ground tooling',
  'Manipulateurs sous-marins': 'Underwater manipulators',
  'Modules batteries': 'Battery modules',
  'Moteurs & Entraînements': 'Motors & Drives',
  'Mémoires': 'Memory',
  'Navigation inertielle': 'Inertial navigation',
  'Panneaux solaires': 'Solar panels',
  'Photonique & Optique': 'Photonics & Optics',
  'Pièces & MRO': 'Parts & MRO',
  'Plateformes satellites': 'Satellite platforms',
  'Prestation de talents': 'Contract talent',
  'Recyclage & Économie circulaire': 'Recycling & Circular economy',
  'Robotique & Automatisation': 'Robotics & Automation',
  'Segment sol & opérations': 'Ground segment & operations',
  'Sous-traitance électronique (EMS)': 'Electronics contract manufacturing (EMS)',
  'Stockage de données spatiales': 'Space data storage',
  'Traitement charge utile': 'Payload processing',
  'Traitement de données': 'Data processing',
  'Usinage & fabrication mécanique': 'Machining & mechanical manufacturing',
  'Vannes & Actionneurs': 'Valves & Actuators',
  'Véhicules': 'Vehicles',
  'Électrification': 'Electrification',
  'Battery & stockage d\'énergie': 'Battery & energy storage',
  'Intelligence embarquée': 'Embedded intelligence',
  'Capteurs & instrumentation': 'Sensors & instrumentation',
  'Mobilité': 'Mobility',
  'Câblage & Connectique': 'Cabling & Connectivity',
  'Thermique': 'Thermal',
  'Photonique & Quantique': 'Photonics & Quantum',
  'Autres': 'Other',
  'Automobile & Mobilité électrique': 'Automotive & E-mobility',
  'Aéronautique & Défense': 'Aerospace & Defense',
  'Ferroviaire': 'Rail',
  'Industrie & Manufacturing': 'Industry & Manufacturing',
  'Spatial': 'Space',
  'Énergie & Utilities': 'Energy & Utilities',
};
const COUNTRY_EN = {
  'Autriche': 'Austria',
  'Bulgarie': 'Bulgaria',
  'Suisse': 'Switzerland',
  'Chine': 'China',
  'République tchèque': 'Czech Republic',
  'Allemagne': 'Germany',
  'Danemark': 'Denmark',
  'Estonie': 'Estonia',
  'Espagne': 'Spain',
  'Royaume-Uni': 'United Kingdom',
  'Irlande': 'Ireland',
  'Inde': 'India',
  'Italie': 'Italy',
  'Japon': 'Japan',
  'Corée du Sud': 'South Korea',
  'Lituanie': 'Lithuania',
  'Pays-Bas': 'Netherlands',
  'Norvège': 'Norway',
  'Nouvelle-Zélande': 'New Zealand',
  'Pologne': 'Poland',
  'Suède': 'Sweden',
  'Slovénie': 'Slovenia',
  'Slovaquie': 'Slovakia',
  'Taïwan': 'Taiwan',
  'États-Unis': 'United States',
  'Afrique du Sud': 'South Africa',
};
const COUNTRY_EN_RE = new RegExp(Object.keys(COUNTRY_EN).join('|'), 'g');
const taxEn = name => TAXONOMY_EN[name] || name;
const countryEn = str => String(str || '').replace(COUNTRY_EN_RE, m => COUNTRY_EN[m]);

const ENTITY_PATHS = {
  company: { fr: '/pages/entreprise.html', en: '/en/company.html' },
  product: { fr: '/pages/produit.html',    en: '/en/product.html' },
};
const entityUrlAbs = (kind, lang, id) => SITE_URL + ENTITY_PATHS[kind][lang] + '?id=' + encodeURIComponent(id);
const hasEnglish = row => !!(row && row.description_en && String(row.description_en).trim()) && !row.hidden;

function hreflangTags(kind, id) {
  const fr = escapeHtml(entityUrlAbs(kind, 'fr', id));
  const en = escapeHtml(entityUrlAbs(kind, 'en', id));
  return `<link rel="alternate" hreflang="fr" href="${fr}"/><link rel="alternate" hreflang="en" href="${en}"/><link rel="alternate" hreflang="x-default" href="${fr}"/>`;
}

class AppendHtml {
  constructor(html) { this.html = html; }
  element(el) { el.append(this.html, { html: true }); }
}

// Contenu (titre, description, en-tête, corps) d'une fiche dans une langue.
// Le français reproduit exactement l'ancien rendu ; l'anglais utilise
// description_en (repli sur le français si vide) et les libellés traduits.
function companyContent(c, lang) {
  const en = lang === 'en';
  const industry = en ? taxEn(c.industry || '') : (c.industry || '');
  const country = en ? countryEn(c.country) : (c.country || '');
  const description = (en && c.description_en) ? c.description_en : (c.description || '');
  const L = en
    ? { desc: 'Description', info: 'Company information', founded: 'Founded', employees: 'Employees', sector: 'Sector', hq: 'Headquarters', fallback: `${c.name}, ${industry} equipment manufacturer` }
    : { desc: 'Description', info: 'Informations société', founded: 'Fondée en', employees: 'Effectifs', sector: 'Secteur', hq: 'Siège', fallback: `${c.name}, équipementier ${industry}` };
  return {
    title: `${c.name} — ${industry} — Buy-inner`,
    desc: (description || L.fallback).slice(0, 160),
    headerHtml: `<h1 class="page-title">${escapeHtml(c.name)}</h1><p class="page-subtitle">${escapeHtml(country)} · ${escapeHtml(c.hq || '')} — ${escapeHtml(industry)}</p>`,
    bodyHtml: `
    <div class="modal-section">
      <div class="modal-section-title">${L.desc}</div>
      <p style="font-size:13px;color:var(--text2);line-height:1.7;margin:0">${escapeHtml(description)}</p>
    </div>
    <div class="modal-section">
      <div class="modal-section-title">${L.info}</div>
      <div class="detail-grid">
        <div class="detail-item"><div class="detail-label">${L.founded}</div><div class="detail-value">${escapeHtml(c.founded || '—')}</div></div>
        <div class="detail-item"><div class="detail-label">${L.employees}</div><div class="detail-value">${escapeHtml(c.employees || '—')}</div></div>
        <div class="detail-item"><div class="detail-label">${L.sector}</div><div class="detail-value">${escapeHtml(industry || '—')}</div></div>
        <div class="detail-item"><div class="detail-label">${L.hq}</div><div class="detail-value">${escapeHtml(c.hq || '—')}</div></div>
      </div>
    </div>`,
  };
}

function productContent(p, lang) {
  const en = lang === 'en';
  const category = en ? taxEn(p.category || '') : (p.category || '');
  const industry = en ? taxEn(p.industry || '') : (p.industry || '');
  const description = (en && p.description_en) ? p.description_en : (p.description || '');
  const L = en
    ? { desc: 'Description', maker: 'Manufacturer', link: 'View company profile →', page: 'company.html', fallback: `${p.name} by ${p.company_name || ''}` }
    : { desc: 'Description', maker: 'Fabricant', link: 'Voir la fiche →', page: 'entreprise.html', fallback: `${p.name} par ${p.company_name || ''}` };
  return {
    title: `${p.name} — ${p.company_name || ''} — Buy-inner`,
    desc: (description || L.fallback).slice(0, 160),
    headerHtml: `<h1 class="page-title">${escapeHtml(p.icon || '')} ${escapeHtml(p.name)}</h1><p class="page-subtitle">${escapeHtml(p.company_name || '')} — ${escapeHtml(category)} ${industry ? '· ' + escapeHtml(industry) : ''}</p>`,
    bodyHtml: `
    <div class="modal-section">
      <div class="modal-section-title">${L.desc}</div>
      <p style="font-size:13px;color:var(--text2);line-height:1.7;margin:0">${escapeHtml(description)}</p>
    </div>
    <div class="modal-section">
      <div class="modal-section-title">${L.maker}</div>
      <p style="font-size:13px;color:var(--text2);line-height:1.7;margin:0">${escapeHtml(p.company_name || '')} — <a href="${L.page}?id=${escapeHtml(p.company_id || '')}">${L.link}</a></p>
    </div>`,
  };
}

async function handleEntityPage(kind, lang, request, env, ctx) {
  const url = new URL(request.url);
  const cache = caches.default;
  const cacheKey = new Request(url.toString(), request);
  const cached = await cache.match(cacheKey);
  if (cached) return cached;

  const originRes = await fetch(GITHUB_PAGES_ORIGIN + ENTITY_PATHS[kind][lang] + url.search);
  const id = url.searchParams.get('id');
  if (!id) return originRes;

  const row = await fetchRpcRow(kind === 'company' ? 'get_company_by_id' : 'get_product_by_id', { p_id: id });
  if (!row) return originRes;

  const content = (kind === 'company' ? companyContent : productContent)(row, lang);
  const [headerSel, bodySel] = kind === 'company' ? ['#ent-header', '#ent-body'] : ['#prod-header', '#prod-body'];
  const translated = hasEnglish(row);

  let rewriter = new HTMLRewriter()
    .on('title', new SetHtml(escapeHtml(content.title)))
    .on('meta[name="description"]', new SetAttr('content', content.desc))
    .on('link[rel="canonical"]', new SetAttr('href', entityUrlAbs(kind, lang, id)))
    .on(headerSel, new SetHtml(content.headerHtml))
    .on(bodySel, new SetHtml(content.bodyHtml));
  // Version anglaise : indexable seulement si traduite (sinon noindex, déjà
  // la valeur par défaut de en/company.html et en/product.html).
  if (lang === 'en') rewriter = rewriter.on('meta[name="robots"]', new SetAttr('content', translated ? 'index,follow' : 'noindex,follow'));
  // hreflang réciproque sur les deux versions, uniquement si l'anglais existe.
  if (translated) rewriter = rewriter.on('head', new AppendHtml(hreflangTags(kind, id)));

  let response = rewriter.transform(originRes);
  response = new Response(response.body, response);
  response.headers.set('Cache-Control', 'public, max-age=600');
  ctx.waitUntil(cache.put(cacheKey, response.clone()));
  return response;
}

// Toutes les lignes d'une RPC paginée (plafond serveur de 50 par page).
async function fetchAllRpc(rpcName) {
  let all = [];
  for (let offset = 0; ; offset += 50) {
    const res = await fetch(`${SUPABASE_ORIGIN}/rest/v1/rpc/${rpcName}`, {
      method: 'POST',
      headers: { 'apikey': SUPABASE_ANON, 'Authorization': 'Bearer ' + SUPABASE_ANON, 'Content-Type': 'application/json' },
      body: JSON.stringify({ p_limit: 50, p_offset: offset }),
    });
    if (!res.ok) throw new Error(`${rpcName}: HTTP ${res.status}`);
    const page = await res.json();
    all = all.concat(page);
    if (page.length < 50) break;
  }
  return all;
}

// Sitemaps dynamiques des fiches entreprise/produit, régénérés depuis la
// base (cache 1 h) :
//  - /sitemap-fr.xml : TOUTES les fiches visibles en français (une fiche
//    supprimée ou masquée disparaît toute seule), avec les alternates EN
//    pour celles qui sont traduites ;
//  - /sitemap-en.xml : seulement les fiches anglaises traduites, avec leurs
//    alternates FR.
const lastmod = row => {
  const d = row && row.updated_at ? new Date(row.updated_at) : null;
  return d && !isNaN(d) ? `<lastmod>${d.toISOString().slice(0, 10)}</lastmod>` : '';
};

async function handleSitemap(lang, request, env, ctx) {
  const cache = caches.default;
  const cacheKey = new Request(new URL(request.url).toString(), request);
  const cached = await cache.match(cacheKey);
  if (cached) return cached;

  let companies, products;
  try {
    [companies, products] = await Promise.all([fetchAllRpc('get_companies_page'), fetchAllRpc('get_products_page')]);
  } catch (err) {
    return new Response('Sitemap temporarily unavailable', { status: 503 });
  }
  const visible = companies.filter(c => !c.hidden);
  const visibleIds = new Set(visible.map(c => c.id));
  const entry = (kind, row) => {
    const fr = escapeHtml(entityUrlAbs(kind, 'fr', row.id));
    const en = escapeHtml(entityUrlAbs(kind, 'en', row.id));
    const alternates = hasEnglish(row)
      ? `<xhtml:link rel="alternate" hreflang="fr" href="${fr}"/><xhtml:link rel="alternate" hreflang="en" href="${en}"/><xhtml:link rel="alternate" hreflang="x-default" href="${fr}"/>`
      : '';
    return `  <url><loc>${lang === 'en' ? en : fr}</loc>${lastmod(row)}${alternates}</url>`;
  };
  const keep = row => lang === 'fr' || hasEnglish(row);
  const urls = [
    ...visible.filter(keep).map(c => entry('company', c)),
    ...products.filter(p => visibleIds.has(p.company_id) && keep(p)).map(p => entry('product', p)),
  ];
  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">
${urls.join('\n')}
</urlset>
`;
  const response = new Response(xml, { headers: { 'Content-Type': 'application/xml; charset=utf-8', 'Cache-Control': 'public, max-age=3600' } });
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
      return handleEntityPage('company', 'fr', request, env, ctx);
    }
    if (url.pathname === '/pages/produit.html') {
      return handleEntityPage('product', 'fr', request, env, ctx);
    }
    if (url.pathname === '/en/company.html') {
      return handleEntityPage('company', 'en', request, env, ctx);
    }
    if (url.pathname === '/en/product.html') {
      return handleEntityPage('product', 'en', request, env, ctx);
    }
    if (url.pathname === '/sitemap-en.xml') {
      return handleSitemap('en', request, env, ctx);
    }
    if (url.pathname === '/sitemap-fr.xml') {
      return handleSitemap('fr', request, env, ctx);
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

    if (url.pathname === '/api/admin-create-user') {
      if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: CORS_HEADERS });
      if (request.method === 'POST') return handleAdminCreateUser(request, env);
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
