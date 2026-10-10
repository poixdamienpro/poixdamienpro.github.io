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
//  - /api/admin-users : gestion des comptes depuis pages/admin.html (liste,
//    creation de comptes fournisseur OU administrateur, lien de nouveau mot de
//    passe, desactivation, suppression). Verifie d'abord que l'appelant est
//    lui-meme admin avant de toucher a SUPABASE_SERVICE_ROLE_KEY.
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

// Invitation à rejoindre l'équipe d'une entreprise. Volontairement HORS de
// EMAIL_TEMPLATES : /api/send-email est public, alors que ce message contient
// un jeton d'accès. Il n'est envoyé que par /api/send-invite-email, qui relit
// l'invitation en base avec le jeton de l'inviteur (voir handleSendInviteEmail).
const INVITE_TEMPLATES = {
  fr: ({ inviterEmail, companyName, roleLabel, email, link, expires }) => ({
    subject: `Buy-inner — Invitation à rejoindre ${companyName}`,
    html: `<p>Bonjour,</p>
      <p><strong>${escapeHtml(inviterEmail)}</strong> vous invite à rejoindre l'espace fournisseur de <strong>${escapeHtml(companyName)}</strong> sur Buy-inner, en tant que <strong>${escapeHtml(roleLabel)}</strong>.</p>
      <p>Créez un compte (ou connectez-vous) avec cette adresse email : <strong>${escapeHtml(email)}</strong>, puis acceptez l'invitation :</p>
      <p><a href="${escapeHtml(link)}">Accepter l'invitation →</a></p>
      <p style="color:#666;font-size:13px">Ce lien est personnel et valable jusqu'au ${escapeHtml(expires)}. Si vous ne connaissez pas cette personne, ignorez simplement ce message.</p>
      <p>— L'équipe Buy-inner</p>`,
  }),
  en: ({ inviterEmail, companyName, roleLabel, email, link, expires }) => ({
    subject: `Buy-inner — Invitation to join ${companyName}`,
    html: `<p>Hello,</p>
      <p><strong>${escapeHtml(inviterEmail)}</strong> has invited you to join the supplier workspace of <strong>${escapeHtml(companyName)}</strong> on Buy-inner, as <strong>${escapeHtml(roleLabel)}</strong>.</p>
      <p>Create an account (or sign in) with this email address: <strong>${escapeHtml(email)}</strong>, then accept the invitation:</p>
      <p><a href="${escapeHtml(link)}">Accept the invitation →</a></p>
      <p style="color:#666;font-size:13px">This link is personal and valid until ${escapeHtml(expires)}. If you don't know this person, just ignore this message.</p>
      <p>— The Buy-inner team</p>`,
  }),
};
const INVITE_ROLE_LABELS = {
  fr: { owner: 'administrateur', member: 'collaborateur' },
  en: { owner: 'administrator', member: 'team member' },
};

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Stripe-Signature, Authorization',
};

function json(obj, status = 200) {
  return new Response(JSON.stringify(obj), {
    status,
    headers: { 'Content-Type': 'application/json', ...CORS_HEADERS },
  });
}

// ── Emails transactionnels (Resend) ──────────────────────────────────
const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

// Qui peut déclencher quel email via POST /api/send-email (route PUBLIQUE).
//   - submission_confirmation : visiteur anonyme qui vient de remplir le
//     formulaire de référencement -> vérifié contre la base (claimSubmissionConfirmation).
//   - submission_approved / claim_approved : réservés aux administrateurs.
//   - tout le reste (ex. premium_activated, envoyé par le webhook Stripe) n'est
//     PAS joignable par cette route : le Worker l'appelle en interne via sendTemplateEmail.
const ADMIN_EMAIL_TYPES = new Set(['submission_approved', 'claim_approved']);

// Envoi interne, SANS contrôle d'accès : ne jamais l'exposer tel quel à une route.
async function sendTemplateEmail(env, type, to, params) {
  const template = EMAIL_TEMPLATES[type];
  if (!template) return json({ error: 'type de template inconnu' }, 400);
  if (!to || typeof to !== 'string' || !EMAIL_RE.test(to)) {
    return json({ error: 'destinataire invalide' }, 400);
  }
  if (!env.RESEND_API_KEY) return json({ error: 'RESEND_API_KEY non configurée sur le Worker' }, 500);

  const { subject, html } = template(params || {});
  return sendViaResend(env, to, subject, html);
}

async function handleSendEmail(request, env) {
  let body;
  try { body = await request.json(); } catch { return json({ error: 'JSON invalide' }, 400); }

  const { type, to, params, submissionId } = body || {};
  if (!EMAIL_TEMPLATES[type]) return json({ error: 'type de template inconnu' }, 400);
  if (!to || typeof to !== 'string' || !EMAIL_RE.test(to)) {
    return json({ error: 'destinataire invalide' }, 400);
  }

  if (ADMIN_EMAIL_TYPES.has(type)) {
    const denied = await requireAdmin(request, env);
    if (denied) return denied;
    // Défense en profondeur : le lien doit pointer vers le site.
    const link = params && params.link;
    if (typeof link !== 'string' || !link.startsWith(SITE_URL + '/')) {
      return json({ error: 'lien invalide' }, 400);
    }
    return sendTemplateEmail(env, type, to, params);
  }

  if (type === 'submission_confirmation') {
    // Le contenu vient de la base, jamais du client.
    const claim = await claimSubmissionConfirmation(env, submissionId, to);
    if (claim.error) return claim.error;
    const res = await sendTemplateEmail(env, type, to, {
      submitterName: claim.row.submitter_name,
      companyName: claim.row.company_name,
    });
    if (!res.ok) await releaseSubmissionConfirmation(env, submissionId);
    return res;
  }

  return json({ error: 'type de template non autorisé' }, 403);
}

// ── Accès service_role (lecture/écriture des soumissions) ──
function serviceFetch(env, path, options = {}) {
  return fetch(`${SUPABASE_ORIGIN}/rest/v1/${path}`, {
    ...options,
    headers: {
      'apikey': env.SUPABASE_SERVICE_ROLE_KEY,
      'Authorization': `Bearer ${env.SUPABASE_SERVICE_ROLE_KEY}`,
      'Content-Type': 'application/json',
      ...(options.headers || {}),
    },
  });
}

// L'appelant doit être administrateur (table admins, lue avec la clé
// service_role — le token seul ne suffit pas). authenticateAdmin renvoie
// { caller } (id + email) ou { error: Response } ; requireAdmin renvoie
// seulement la Response d'erreur éventuelle (null si l'appelant est admin).
async function authenticateAdmin(request, env) {
  if (!env.SUPABASE_SERVICE_ROLE_KEY) {
    return { error: json({ error: 'SUPABASE_SERVICE_ROLE_KEY non configurée sur le Worker' }, 500) };
  }

  const authHeader = request.headers.get('Authorization') || '';
  const callerToken = authHeader.replace(/^Bearer\s+/i, '');
  if (!callerToken) return { error: json({ error: 'Non authentifié' }, 401) };

  // 1. Résout l'identité de l'appelant à partir de son propre token.
  const whoRes = await fetch(`${SUPABASE_ORIGIN}/auth/v1/user`, {
    headers: { 'apikey': SUPABASE_ANON, 'Authorization': `Bearer ${callerToken}` },
  });
  if (!whoRes.ok) return { error: json({ error: 'Session invalide' }, 401) };
  const caller = await whoRes.json();

  // 2. Vérifie que l'appelant est bien dans la table admins, et s'il est super-admin.
  //    Repli sans la colonne is_super tant que backend/supabase_admin_roles_2026_10.sql
  //    n'est pas exécuté : tout le monde est alors simple admin (rien ne casse).
  let checkRes = await serviceFetch(env, `admins?user_id=eq.${encodeURIComponent(caller.id)}&select=user_id,is_super`);
  if (!checkRes.ok) checkRes = await serviceFetch(env, `admins?user_id=eq.${encodeURIComponent(caller.id)}&select=user_id`);
  if (!checkRes.ok) {
    const detail = await checkRes.text();
    return { error: json({ error: 'Échec de la vérification admin', detail }, 502) };
  }
  const checkRows = await checkRes.json();
  if (!checkRows.length) return { error: json({ error: 'Accès refusé : tu n\'es pas administrateur' }, 403) };
  return { caller: { ...caller, isSuper: checkRows[0].is_super === true } };
}

async function requireAdmin(request, env) {
  const a = await authenticateAdmin(request, env);
  return a.error || null;
}

// ── Gestion des comptes depuis la page admin ─────────────────────────
// Un seul point d'entrée, réservé aux administrateurs (authenticateAdmin) :
//   list         : tous les comptes (+ entreprises, rôle, admin, désactivé)
//   create       : crée un compte SANS mot de passe connu de personne, le
//                  rattache à une entreprise, renvoie un lien « définir mon mot de
//                  passe » (et l'envoie par email si demandé)
//   reset_link   : nouveau lien de mot de passe pour un compte existant
//   set_disabled : désactive / réactive la connexion
//   delete       : supprime le compte (après nettoyage atomique, voir
//                  backend/supabase_admin_user_management_2026_10.sql)
// Les mots de passe ne transitent JAMAIS par l'admin : la personne choisit le
// sien sur la page pages/nouveau-mot-de-passe.html. Les comptes administrateurs
// sont protégés (pas de réinitialisation / désactivation / suppression ici).
const PASSWORD_PAGE = `${SITE_URL}/pages/nouveau-mot-de-passe.html`;
const BAN_FOREVER = '876000h';

const ACCOUNT_TEMPLATES = {
  fr: {
    created: ({ email, link, companyName, isAdmin }) => isAdmin ? ({
      subject: 'Buy-inner — Votre compte administrateur est prêt',
      html: `<p>Bonjour,</p>
      <p>Un compte <strong>administrateur</strong> Buy-inner vient d'être créé pour vous (<strong>${escapeHtml(email)}</strong>).</p>
      <p>Choisissez votre mot de passe pour y accéder :</p>
      <p><a href="${escapeHtml(link)}">Définir mon mot de passe →</a></p>
      <p>Vous pourrez ensuite vous connecter sur <a href="${SITE_URL}/pages/admin.html">${SITE_URL}/pages/admin.html</a>. Pensez à activer la double authentification dans l'onglet « Sécurité ».</p>
      <p style="color:#666;font-size:13px">Ce lien est personnel et expire rapidement. S'il a expiré, demandez-en un nouveau à un autre administrateur.</p>
      <p>— L'équipe Buy-inner</p>`,
    }) : ({
      subject: 'Buy-inner — Votre compte est prêt',
      html: `<p>Bonjour,</p>
      <p>Un compte Buy-inner vient d'être créé pour vous (<strong>${escapeHtml(email)}</strong>)${companyName ? ` pour l'entreprise <strong>${escapeHtml(companyName)}</strong>` : ''}.</p>
      <p>Choisissez votre mot de passe pour y accéder :</p>
      <p><a href="${escapeHtml(link)}">Définir mon mot de passe →</a></p>
      <p>Vous pourrez ensuite vous connecter sur <a href="${SITE_URL}/pages/supplier.html">${SITE_URL}/pages/supplier.html</a>.</p>
      <p style="color:#666;font-size:13px">Ce lien est personnel et expire rapidement. S'il a expiré, demandez-en un nouveau à l'équipe Buy-inner.</p>
      <p>— L'équipe Buy-inner</p>`,
    }),
    forgot: ({ email, link }) => ({
      subject: 'Buy-inner — Réinitialisation de votre mot de passe',
      html: `<p>Bonjour,</p>
      <p>Vous avez demandé à réinitialiser le mot de passe de votre compte Buy-inner (<strong>${escapeHtml(email)}</strong>).</p>
      <p><a href="${escapeHtml(link)}">Choisir un nouveau mot de passe →</a></p>
      <p style="color:#666;font-size:13px">Ce lien est personnel, expire rapidement et ne peut servir qu'une fois. Si vous n'êtes pas à l'origine de cette demande, ignorez simplement ce message : votre mot de passe actuel reste inchangé.</p>
      <p>— L'équipe Buy-inner</p>`,
    }),
    reset: ({ email, link }) => ({
      subject: 'Buy-inner — Définissez un nouveau mot de passe',
      html: `<p>Bonjour,</p>
      <p>Un nouveau mot de passe peut être défini pour votre compte Buy-inner (<strong>${escapeHtml(email)}</strong>).</p>
      <p><a href="${escapeHtml(link)}">Définir un nouveau mot de passe →</a></p>
      <p style="color:#666;font-size:13px">Ce lien est personnel et expire rapidement. Si vous n'êtes pas à l'origine de cette demande, contactez l'équipe Buy-inner.</p>
      <p>— L'équipe Buy-inner</p>`,
    }),
  },
  en: {
    created: ({ email, link, companyName, isAdmin }) => isAdmin ? ({
      subject: 'Buy-inner — Your administrator account is ready',
      html: `<p>Hello,</p>
      <p>A Buy-inner <strong>administrator</strong> account has just been created for you (<strong>${escapeHtml(email)}</strong>).</p>
      <p>Choose your password to access it:</p>
      <p><a href="${escapeHtml(link)}">Set my password →</a></p>
      <p>You can then sign in at <a href="${SITE_URL}/pages/admin.html">${SITE_URL}/pages/admin.html</a>. Remember to enable two-factor authentication in the “Security” tab.</p>
      <p style="color:#666;font-size:13px">This link is personal and expires quickly. If it has expired, ask another administrator for a new one.</p>
      <p>— The Buy-inner team</p>`,
    }) : ({
      subject: 'Buy-inner — Your account is ready',
      html: `<p>Hello,</p>
      <p>A Buy-inner account has just been created for you (<strong>${escapeHtml(email)}</strong>)${companyName ? ` for the company <strong>${escapeHtml(companyName)}</strong>` : ''}.</p>
      <p>Choose your password to access it:</p>
      <p><a href="${escapeHtml(link)}">Set my password →</a></p>
      <p>You can then sign in at <a href="${SITE_URL}/pages/supplier.html">${SITE_URL}/pages/supplier.html</a>.</p>
      <p style="color:#666;font-size:13px">This link is personal and expires quickly. If it has expired, ask the Buy-inner team for a new one.</p>
      <p>— The Buy-inner team</p>`,
    }),
    forgot: ({ email, link }) => ({
      subject: 'Buy-inner — Reset your password',
      html: `<p>Hello,</p>
      <p>You asked to reset the password of your Buy-inner account (<strong>${escapeHtml(email)}</strong>).</p>
      <p><a href="${escapeHtml(link)}">Choose a new password →</a></p>
      <p style="color:#666;font-size:13px">This link is personal, expires quickly and can only be used once. If you did not make this request, simply ignore this message: your current password stays unchanged.</p>
      <p>— The Buy-inner team</p>`,
    }),
    reset: ({ email, link }) => ({
      subject: 'Buy-inner — Set a new password',
      html: `<p>Hello,</p>
      <p>A new password can be set for your Buy-inner account (<strong>${escapeHtml(email)}</strong>).</p>
      <p><a href="${escapeHtml(link)}">Set a new password →</a></p>
      <p style="color:#666;font-size:13px">This link is personal and expires quickly. If you did not request this, contact the Buy-inner team.</p>
      <p>— The Buy-inner team</p>`,
    }),
  },
};

function authAdminFetch(env, path, options = {}) {
  return fetch(`${SUPABASE_ORIGIN}/auth/v1/admin/${path}`, {
    ...options,
    headers: {
      'apikey': env.SUPABASE_SERVICE_ROLE_KEY,
      'Authorization': `Bearer ${env.SUPABASE_SERVICE_ROLE_KEY}`,
      'Content-Type': 'application/json',
      ...(options.headers || {}),
    },
  });
}

// PostgREST plafonne les lectures à 50 lignes : on pagine.
async function serviceFetchAll(env, path) {
  const sep = path.includes('?') ? '&' : '?';
  const all = [];
  for (let offset = 0; offset < 5000; offset += 50) {
    const res = await serviceFetch(env, `${path}${sep}limit=50&offset=${offset}`);
    if (!res.ok) throw new Error('lecture impossible : ' + path.split('?')[0]);
    const rows = await res.json();
    all.push(...rows);
    if (rows.length < 50) break;
  }
  return all;
}

async function auditAdminAction(env, caller, action, targetEmail, details) {
  try {
    await serviceFetch(env, 'admin_audit_log', {
      method: 'POST',
      headers: { 'Prefer': 'return=minimal' },
      body: JSON.stringify([{ admin_email: caller.email || caller.id, action, target_email: targetEmail || null, details: details || null }]),
    });
  } catch { /* le journal ne doit jamais bloquer l'action */ }
}

async function listAdminUsers(env) {
  const users = [];
  for (let page = 1; page <= 10; page++) {
    const res = await authAdminFetch(env, `users?page=${page}&per_page=200`);
    if (!res.ok) throw new Error('liste des comptes impossible');
    const data = await res.json();
    const batch = (data && data.users) || [];
    users.push(...batch);
    if (batch.length < 200) break;
  }
  const [members, admins] = await Promise.all([
    serviceFetchAll(env, 'company_members?select=user_id,role,company_id,companies(name)'),
    serviceFetchAll(env, 'admins?select=user_id,is_super').catch(() => serviceFetchAll(env, 'admins?select=user_id')),
  ]);
  const adminIds = new Set(admins.map(a => a.user_id));
  const superIds = new Set(admins.filter(a => a.is_super === true).map(a => a.user_id));
  const byUser = {};
  for (const m of members) {
    (byUser[m.user_id] = byUser[m.user_id] || []).push({ id: m.company_id, name: (m.companies && m.companies.name) || '', role: m.role });
  }
  const now = Date.now();
  return users.map(u => ({
    id: u.id,
    email: u.email,
    created_at: u.created_at,
    last_sign_in_at: u.last_sign_in_at || null,
    confirmed: !!u.email_confirmed_at,
    disabled: !!(u.banned_until && new Date(u.banned_until).getTime() > now),
    is_admin: adminIds.has(u.id),
    is_super: superIds.has(u.id),
    companies: byUser[u.id] || [],
  }));
}

// Échec d'une écriture sur les comptes : le garde-fou « dernier super-admin » (base) a un message dédié.
async function adminWriteFailure(res, fallback) {
  const text = await res.text();
  return /LAST_SUPER/.test(text)
    ? json({ error: 'Il doit rester au moins un super-admin.', code: 'LAST_SUPER' }, 409)
    : json({ error: fallback }, 502);
}

async function getAuthUser(env, userId) {
  const res = await authAdminFetch(env, `users/${encodeURIComponent(userId)}`);
  if (!res.ok) return null;
  const u = await res.json();
  return u && u.id ? u : null;
}

async function isAdminUser(env, userId) {
  const res = await serviceFetch(env, `admins?user_id=eq.${encodeURIComponent(userId)}&select=user_id`);
  if (!res.ok) throw new Error('vérification admin impossible');
  return (await res.json()).length > 0;
}

// Jeton de récupération -> notre propre page (pas l'action_link de Supabase :
// il dépend des URL de redirection autorisées et peut être consommé par un
// scanner d'emails ; ici la page appelle /verify elle-même, en JavaScript).
async function generateRecoveryData(env, email) {
  const res = await authAdminFetch(env, 'generate_link', { method: 'POST', body: JSON.stringify({ type: 'recovery', email }) });
  const data = await res.json().catch(() => null);
  if (!res.ok || !data || !data.hashed_token) throw new Error((data && (data.msg || data.message)) || 'génération du lien impossible');
  return data;
}

function passwordLinkFromToken(hashedToken, lang, next) {
  return `${PASSWORD_PAGE}?token_hash=${encodeURIComponent(hashedToken)}&type=recovery&lang=${lang}${next === 'buyer' || next === 'admin' ? '&next=' + next : ''}`;
}

async function generatePasswordLink(env, email, lang, next) {
  const data = await generateRecoveryData(env, email);
  return passwordLinkFromToken(data.hashed_token, lang, next);
}

// ── « Mot de passe oublié » en libre-service (route PUBLIQUE) ─────────
// Principes :
//   * la réponse est IDENTIQUE que le compte existe ou non (pas d'énumération
//     de comptes), et le travail réel se fait après la réponse (ctx.waitUntil)
//     pour que le temps de réponse ne trahisse rien non plus ;
//   * 3 demandes par adresse et 10 par IP et par heure (table
//     password_reset_requests, backend/supabase_password_reset_requests_2026_10.sql) ;
//     si la table est absente on refuse (503) plutôt que de rester sans limite ;
//   * les comptes administrateurs et les comptes désactivés ne reçoivent rien ;
//   * seul un lien « personnel » est envoyé, vers notre page (jamais d'URL fournie par le client).
const FORGOT_MAX_PER_EMAIL = 3;
const FORGOT_MAX_PER_IP = 10;
async function handleRequestPasswordReset(request, env, ctx) {
  let body;
  try { body = await request.json(); } catch { return json({ error: 'JSON invalide' }, 400); }
  const email = String((body && body.email) || '').trim().toLowerCase();
  if (email.length > 254 || !EMAIL_RE.test(email)) return json({ error: 'Email invalide' }, 400);
  if (!env.SUPABASE_SERVICE_ROLE_KEY || !env.RESEND_API_KEY) return json({ error: 'Service temporairement indisponible' }, 503);

  const lang = body.lang === 'en' ? 'en' : 'fr';
  const scope = body.scope === 'buyer' ? 'buyer' : 'supplier';
  const ip = request.headers.get('CF-Connecting-IP') || 'unknown';
  const since = encodeURIComponent(new Date(Date.now() - 3600 * 1000).toISOString());

  try {
    const [byEmail, byIp] = await Promise.all([
      serviceFetch(env, `password_reset_requests?email=eq.${encodeURIComponent(email)}&created_at=gte.${since}&select=id&limit=${FORGOT_MAX_PER_EMAIL}`),
      serviceFetch(env, `password_reset_requests?ip=eq.${encodeURIComponent(ip)}&created_at=gte.${since}&select=id&limit=${FORGOT_MAX_PER_IP}`),
    ]);
    if (!byEmail.ok || !byIp.ok) return json({ error: 'Service temporairement indisponible' }, 503);
    if ((await byEmail.json()).length >= FORGOT_MAX_PER_EMAIL || (await byIp.json()).length >= FORGOT_MAX_PER_IP) {
      return json({ error: 'Trop de demandes. Réessayez dans une heure.' }, 429);
    }
    const ins = await serviceFetch(env, 'password_reset_requests', {
      method: 'POST', headers: { 'Prefer': 'return=minimal' }, body: JSON.stringify([{ email, ip }]),
    });
    if (!ins.ok) return json({ error: 'Service temporairement indisponible' }, 503);
  } catch {
    return json({ error: 'Service temporairement indisponible' }, 503);
  }

  ctx.waitUntil(processPasswordResetRequest(env, email, lang, scope));
  return json({ success: true });
}

async function processPasswordResetRequest(env, email, lang, scope) {
  try {
    // Purge des demandes de plus de 24 h (adresse + IP : durée de conservation annoncée
    // dans la politique de confidentialité). Exécutée à chaque demande : requête indexée, peu coûteuse.
    const old = encodeURIComponent(new Date(Date.now() - 24 * 3600 * 1000).toISOString());
    await serviceFetch(env, `password_reset_requests?created_at=lt.${old}`, { method: 'DELETE', headers: { 'Prefer': 'return=minimal' } });
    let data;
    try { data = await generateRecoveryData(env, email); } catch { return; } // compte inconnu : on ne dit rien
    const uid = data.id || (data.user && data.user.id);
    const banned = data.banned_until || (data.user && data.user.banned_until);
    if (banned && new Date(banned).getTime() > Date.now()) return;
    if (uid && await isAdminUser(env, uid)) return;
    await emailAccountLink(env, 'forgot', lang, email, passwordLinkFromToken(data.hashed_token, lang, scope));
  } catch { /* best-effort : jamais d'erreur visible côté appelant */ }
}

async function emailAccountLink(env, kind, lang, email, link, companyName, isAdmin) {
  const { subject, html } = ACCOUNT_TEMPLATES[lang][kind]({ email, link, companyName, isAdmin });
  if (!env.RESEND_API_KEY) return { sent: false, error: 'RESEND_API_KEY non configurée sur le Worker' };
  const res = await sendViaResend(env, email, subject, html);
  return res.ok ? { sent: true } : { sent: false, error: 'Échec de l\'envoi de l\'email' };
}

async function handleAdminUsers(request, env) {
  const auth = await authenticateAdmin(request, env);
  if (auth.error) return auth.error;
  const caller = auth.caller;

  let body;
  try { body = await request.json(); } catch { return json({ error: 'JSON invalide' }, 400); }
  const action = body && body.action;
  const lang = body && body.lang === 'en' ? 'en' : 'fr';

  try {
    if (action === 'list') {
      return json({ users: await listAdminUsers(env), me: { id: caller.id, isSuper: caller.isSuper } });
    }

    if (action === 'create') {
      const email = String(body.email || '').trim().toLowerCase();
      if (!EMAIL_RE.test(email)) return json({ error: 'Email invalide' }, 400);
      // Compte administrateur de la plateforme : sans entreprise (accès complet à l'admin).
      const makeAdmin = body.makeAdmin === true;
      if (makeAdmin && !caller.isSuper) return json({ error: 'Seul un super-admin peut créer un compte administrateur.', code: 'SUPER_REQUIRED' }, 403);
      if (makeAdmin && body.companyId) return json({ error: 'Un compte administrateur ne se rattache pas à une entreprise.' }, 400);
      let company = null;
      if (body.companyId) {
        if (!UUID_RE.test(String(body.companyId))) return json({ error: 'companyId invalide' }, 400);
        const cRes = await serviceFetch(env, `companies?id=eq.${body.companyId}&select=id,name,claimed_by_user_id`);
        const cRows = cRes.ok ? await cRes.json() : [];
        if (!cRows.length) return json({ error: 'Entreprise introuvable' }, 404);
        company = cRows[0];
      }

      // Mot de passe aléatoire que PERSONNE ne connaît : la personne choisira le sien.
      const createRes = await authAdminFetch(env, 'users', {
        method: 'POST',
        body: JSON.stringify({ email, password: generateTempPassword() + generateTempPassword(), email_confirm: true }),
      });
      const created = await createRes.json().catch(() => ({}));
      if (!createRes.ok) {
        const msg = created.msg || created.message || '';
        if (createRes.status === 422 || /already|exist/i.test(msg)) {
          return json({ error: 'Un compte existe déjà avec cette adresse. Retrouve-le dans la liste pour le rattacher à une entreprise.', code: 'EMAIL_EXISTS' }, 409);
        }
        return json({ error: msg || 'Échec de la création du compte' }, 502);
      }

      if (makeAdmin) {
        const addRes = await serviceFetch(env, 'admins', {
          method: 'POST', headers: { 'Prefer': 'return=minimal' },
          body: JSON.stringify([{ user_id: created.id, email }]),
        });
        if (!addRes.ok) {
          return json({ error: 'Compte créé mais l\'ajout comme administrateur a échoué : ne lui donne pas accès, supprime-le dans la liste puis recommence.', userId: created.id, email }, 502);
        }
      }

      if (company) {
        const role = !company.claimed_by_user_id ? 'owner' : (body.role === 'owner' ? 'owner' : 'member');
        const attach = await attachUserToCompany(env, created.id, company, role);
        if (!attach.ok) return json({ error: 'Compte créé mais rattachement à l\'entreprise impossible', userId: created.id, email }, 502);
      }

      const link = await generatePasswordLink(env, email, lang, makeAdmin ? 'admin' : undefined);
      const mail = body.sendEmail ? await emailAccountLink(env, 'created', lang, email, link, company && company.name, makeAdmin) : { sent: false };
      await auditAdminAction(env, caller, makeAdmin ? 'create_admin' : 'create_user', email, { company: company && company.name, emailSent: mail.sent });
      return json({ success: true, userId: created.id, email, isAdmin: makeAdmin, setupLink: link, emailSent: mail.sent, emailError: mail.error || null });
    }

    if (action === 'attach_company') {
      if (!UUID_RE.test(String(body.userId || '')) || !UUID_RE.test(String(body.companyId || ''))) return json({ error: 'Paramètres invalides' }, 400);
      const cRes = await serviceFetch(env, `companies?id=eq.${body.companyId}&select=id,name,claimed_by_user_id`);
      const cRows = cRes.ok ? await cRes.json() : [];
      if (!cRows.length) return json({ error: 'Entreprise introuvable' }, 404);
      const target = await getAuthUser(env, body.userId);
      if (!target) return json({ error: 'Compte introuvable' }, 404);
      if (target.id === caller.id) return json({ error: 'Tu ne peux pas modifier ton propre rattachement ici.', code: 'SELF' }, 400);
      const role = body.role === 'owner' ? 'owner' : 'member';
      const attach = await attachUserToCompany(env, target.id, cRows[0], role);
      if (!attach.ok) return json({ error: 'Rattachement impossible' }, 502);
      await auditAdminAction(env, caller, 'attach_company', target.email, { company: cRows[0].name, role });
      return json({ success: true });
    }

    if (action === 'detach_company') {
      if (!UUID_RE.test(String(body.userId || '')) || !UUID_RE.test(String(body.companyId || ''))) return json({ error: 'Paramètres invalides' }, 400);
      const target = await getAuthUser(env, body.userId);
      if (!target) return json({ error: 'Compte introuvable' }, 404);
      if (target.id === caller.id) return json({ error: 'Tu ne peux pas modifier ton propre rattachement ici.', code: 'SELF' }, 400);
      const cRes = await serviceFetch(env, `companies?id=eq.${body.companyId}&select=id,name,claimed_by_user_id`);
      const cRows = cRes.ok ? await cRes.json() : [];
      if (!cRows.length) return json({ error: 'Entreprise introuvable' }, 404);
      const delRes = await serviceFetch(env, `company_members?company_id=eq.${body.companyId}&user_id=eq.${encodeURIComponent(target.id)}`, {
        method: 'DELETE', headers: { 'Prefer': 'return=representation' },
      });
      if (!delRes.ok) return json({ error: 'Retrait impossible' }, 502);
      if (!(await delRes.json()).length) return json({ error: 'Ce compte n\'est pas rattaché à cette entreprise.' }, 404);
      // L'ancien champ « propriétaire » (encore lu par le repli de supplier.js) ne doit pas rester sur un compte retiré.
      if (cRows[0].claimed_by_user_id === target.id) {
        const ownerRes = await serviceFetch(env, `company_members?company_id=eq.${body.companyId}&role=eq.owner&select=user_id&limit=1`);
        const owners = ownerRes.ok ? await ownerRes.json() : [];
        await serviceFetch(env, `companies?id=eq.${body.companyId}`, {
          method: 'PATCH', headers: { 'Prefer': 'return=minimal' }, body: JSON.stringify({ claimed_by_user_id: owners.length ? owners[0].user_id : null }),
        });
      }
      await auditAdminAction(env, caller, 'detach_company', target.email, { company: cRows[0].name });
      return json({ success: true });
    }

    // Gestion des administrateurs : réservée aux super-admins, jamais sur soi-même.
    if (action === 'set_super' || action === 'revoke_admin') {
      if (!caller.isSuper) return json({ error: 'Réservé aux super-admins.', code: 'SUPER_REQUIRED' }, 403);
      if (!UUID_RE.test(String(body.userId || ''))) return json({ error: 'userId invalide' }, 400);
      if (body.userId === caller.id) return json({ error: 'Tu ne peux pas modifier ton propre statut.', code: 'SELF' }, 400);
      const target = await getAuthUser(env, body.userId);
      if (!target) return json({ error: 'Compte introuvable' }, 404);
      if (!(await isAdminUser(env, target.id))) return json({ error: 'Ce compte n\'est pas administrateur.', code: 'NOT_ADMIN' }, 400);

      if (action === 'set_super') {
        const isSuper = body.isSuper === true;
        const res = await serviceFetch(env, `admins?user_id=eq.${encodeURIComponent(target.id)}`, {
          method: 'PATCH', headers: { 'Prefer': 'return=representation' }, body: JSON.stringify({ is_super: isSuper }),
        });
        if (!res.ok) return adminWriteFailure(res, 'Modification impossible');
        await auditAdminAction(env, caller, isSuper ? 'set_super' : 'unset_super', target.email, null);
        return json({ success: true, isSuper });
      }

      const res = await serviceFetch(env, `admins?user_id=eq.${encodeURIComponent(target.id)}`, { method: 'DELETE', headers: { 'Prefer': 'return=minimal' } });
      if (!res.ok) return adminWriteFailure(res, 'Retrait impossible');
      await auditAdminAction(env, caller, 'revoke_admin', target.email, null);
      return json({ success: true });
    }

    if (action === 'reset_link' || action === 'set_disabled' || action === 'delete') {
      if (!UUID_RE.test(String(body.userId || ''))) return json({ error: 'userId invalide' }, 400);
      const target = await getAuthUser(env, body.userId);
      if (!target) return json({ error: 'Compte introuvable' }, 404);
      if (target.id === caller.id) return json({ error: 'Utilise l\'onglet Sécurité pour ton propre compte.' }, 400);
      const targetIsAdmin = await isAdminUser(env, target.id);
      if (targetIsAdmin && !caller.isSuper) {
        return json({ error: 'Compte administrateur : seul un super-admin peut agir dessus.', code: 'SUPER_REQUIRED' }, 403);
      }

      if (action === 'reset_link') {
        const link = await generatePasswordLink(env, target.email, lang);
        const mail = body.sendEmail ? await emailAccountLink(env, 'reset', lang, target.email, link) : { sent: false };
        await auditAdminAction(env, caller, 'reset_password_link', target.email, { emailSent: mail.sent });
        return json({ success: true, email: target.email, setupLink: link, emailSent: mail.sent, emailError: mail.error || null });
      }

      if (action === 'set_disabled') {
        const disabled = !!body.disabled;
        const res = await authAdminFetch(env, `users/${encodeURIComponent(target.id)}`, {
          method: 'PUT', body: JSON.stringify({ ban_duration: disabled ? BAN_FOREVER : 'none' }),
        });
        if (!res.ok) return json({ error: 'Modification impossible' }, 502);
        await auditAdminAction(env, caller, disabled ? 'disable_user' : 'enable_user', target.email, null);
        return json({ success: true, disabled });
      }

      // delete : la personne qui supprime retape l'adresse du compte pour confirmer.
      if (String(body.confirmEmail || '').trim().toLowerCase() !== String(target.email || '').toLowerCase()) {
        return json({ error: 'Adresse de confirmation incorrecte' }, 400);
      }
      const prep = await serviceFetch(env, 'rpc/admin_prepare_user_deletion', { method: 'POST', body: JSON.stringify({ p_user: target.id, p_allow_admin: targetIsAdmin }) });
      if (!prep.ok) {
        const detail = await prep.text();
        if (/HAS_RFQ_DATA/.test(detail)) {
          return json({ error: 'Ce compte a des dossiers ou réponses RFQ : désactive-le plutôt que de le supprimer.', code: 'HAS_RFQ_DATA' }, 409);
        }
        if (/IS_ADMIN/.test(detail)) return json({ error: 'Compte administrateur', code: 'IS_ADMIN' }, 403);
        return json({ error: 'Préparation de la suppression impossible', detail }, 502);
      }
      const del = await authAdminFetch(env, `users/${encodeURIComponent(target.id)}`, { method: 'DELETE' });
      if (!del.ok) return adminWriteFailure(del, 'Suppression impossible'); // le dernier super-admin ne peut pas disparaître (garde-fou en base)
      await auditAdminAction(env, caller, targetIsAdmin ? 'delete_admin' : 'delete_user', target.email, null);
      return json({ success: true });
    }

    return json({ error: 'action inconnue' }, 400);
  } catch (err) {
    return json({ error: 'Erreur : ' + (err && err.message ? err.message : 'inconnue') }, 502);
  }
}

// Rattache un compte à une entreprise (équipe). Premier compte d'une entreprise
// non revendiquée => administrateur, et on renseigne aussi claimed_by_user_id
// (l'ancien champ « propriétaire », encore lu par le repli de supplier.js).
async function attachUserToCompany(env, userId, company, role) {
  const res = await serviceFetch(env, 'company_members?on_conflict=company_id,user_id', {
    method: 'POST',
    headers: { 'Prefer': 'resolution=merge-duplicates,return=minimal' },
    body: JSON.stringify([{ company_id: company.id, user_id: userId, role }]),
  });
  if (!res.ok) return { ok: false };
  if (role === 'owner' && !company.claimed_by_user_id) {
    await serviceFetch(env, `companies?id=eq.${company.id}`, {
      method: 'PATCH', headers: { 'Prefer': 'return=minimal' }, body: JSON.stringify({ claimed_by_user_id: userId }),
    });
  }
  return { ok: true };
}

// Confirmation de soumission : une seule fois par soumission, pour l'adresse
// réellement saisie dans le formulaire, dans les 15 minutes, et au plus 3 par
// adresse et par jour. Le « claim » est atomique (PATCH conditionnel) : deux
// appels simultanés ne peuvent pas envoyer deux emails.
const CONFIRMATION_WINDOW_MS = 15 * 60 * 1000;
const CONFIRMATION_MAX_PER_DAY = 3;
async function claimSubmissionConfirmation(env, submissionId, to) {
  if (typeof submissionId !== 'string' || !UUID_RE.test(submissionId)) {
    return { error: json({ error: 'submissionId invalide' }, 400) };
  }
  if (!env.SUPABASE_SERVICE_ROLE_KEY) {
    return { error: json({ error: 'SUPABASE_SERVICE_ROLE_KEY non configurée sur le Worker' }, 500) };
  }

  const rowRes = await serviceFetch(env,
    `product_submissions?id=eq.${submissionId}&select=submitter_name,submitter_email,company_name,created_at,confirmation_sent_at`);
  if (!rowRes.ok) return { error: json({ error: 'Vérification impossible' }, 502) };
  const rows = await rowRes.json();
  const row = rows && rows[0];
  if (!row || String(row.submitter_email || '').toLowerCase() !== to.toLowerCase()) {
    return { error: json({ error: 'soumission introuvable pour cette adresse' }, 403) };
  }
  if (Date.now() - new Date(row.created_at).getTime() > CONFIRMATION_WINDOW_MS) {
    return { error: json({ error: 'soumission trop ancienne' }, 403) };
  }
  if (row.confirmation_sent_at) return { error: json({ error: 'confirmation déjà envoyée' }, 409) };

  const since = new Date(Date.now() - 24 * 3600 * 1000).toISOString();
  const recentRes = await serviceFetch(env,
    `product_submissions?submitter_email=ilike.${encodeURIComponent(to)}&confirmation_sent_at=gte.${encodeURIComponent(since)}&select=id`);
  if (recentRes.ok) {
    const recent = await recentRes.json();
    if (recent.length >= CONFIRMATION_MAX_PER_DAY) return { error: json({ error: 'trop de confirmations pour cette adresse' }, 429) };
  }

  const claimRes = await serviceFetch(env, `product_submissions?id=eq.${submissionId}&confirmation_sent_at=is.null`, {
    method: 'PATCH',
    headers: { 'Prefer': 'return=representation' },
    body: JSON.stringify({ confirmation_sent_at: new Date().toISOString() }),
  });
  if (!claimRes.ok) return { error: json({ error: 'Vérification impossible' }, 502) };
  const claimed = await claimRes.json();
  if (!claimed || !claimed.length) return { error: json({ error: 'confirmation déjà envoyée' }, 409) };
  return { row };
}

// Si l'envoi Resend échoue, on libère la place pour qu'un nouvel essai soit possible.
async function releaseSubmissionConfirmation(env, submissionId) {
  try {
    await serviceFetch(env, `product_submissions?id=eq.${submissionId}`, {
      method: 'PATCH',
      headers: { 'Prefer': 'return=minimal' },
      body: JSON.stringify({ confirmation_sent_at: null }),
    });
  } catch { /* best-effort */ }
}

async function sendViaResend(env, to, subject, html) {
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

// ── Invitation d'équipe : l'email est construit ICI à partir de la base ──
// Le client n'envoie que l'id d'invitation et son propre jeton de session ;
// le destinataire, le lien et le nom d'entreprise viennent de la RPC
// get_invite_email_payload (qui vérifie que l'appelant est administrateur de
// l'entreprise). Impossible donc d'utiliser ce point d'entrée pour écrire à
// une adresse arbitraire.
async function handleSendInviteEmail(request, env) {
  let body;
  try { body = await request.json(); } catch { return json({ error: 'JSON invalide' }, 400); }

  const { inviteId, lang } = body || {};
  const authorization = request.headers.get('Authorization') || '';
  if (!/^Bearer\s+\S+$/.test(authorization)) return json({ error: 'authentification requise' }, 401);
  if (typeof inviteId !== 'string' || !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(inviteId)) {
    return json({ error: 'inviteId invalide' }, 400);
  }
  if (!env.RESEND_API_KEY) return json({ error: 'RESEND_API_KEY non configurée sur le Worker' }, 500);

  const rpc = await fetch(`${SUPABASE_ORIGIN}/rest/v1/rpc/get_invite_email_payload`, {
    method: 'POST',
    headers: { 'apikey': SUPABASE_ANON, 'Authorization': authorization, 'Content-Type': 'application/json' },
    body: JSON.stringify({ p_invite: inviteId }),
  });
  if (!rpc.ok) return json({ error: 'invitation introuvable ou accès refusé' }, 403);
  const p = await rpc.json().catch(() => null);
  if (!p || !p.email || !p.token) return json({ error: 'invitation invalide' }, 403);

  const l = lang === 'en' ? 'en' : 'fr';
  const { subject, html } = INVITE_TEMPLATES[l]({
    inviterEmail: p.inviter_email || 'Buy-inner',
    companyName: p.company_name || '',
    roleLabel: INVITE_ROLE_LABELS[l][p.role] || INVITE_ROLE_LABELS[l].member,
    email: p.email,
    link: `${SITE_URL}/pages/supplier.html?invite=${encodeURIComponent(p.token)}`,
    expires: String(p.expires_at || '').slice(0, 10),
  });
  return sendViaResend(env, p.email, subject, html);
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
  'Prestation IA & data': 'AI & data services',
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
  const name = (en && p.name_en) ? p.name_en : p.name;   // name_en : voir backend/supabase_add_product_names_en_2026_10.sql
  const L = en
    ? { desc: 'Description', maker: 'Manufacturer', link: 'View company profile →', page: 'company.html', fallback: `${name} by ${p.company_name || ''}` }
    : { desc: 'Description', maker: 'Fabricant', link: 'Voir la fiche →', page: 'entreprise.html', fallback: `${name} par ${p.company_name || ''}` };
  return {
    title: `${name} — ${p.company_name || ''} — Buy-inner`,
    desc: (description || L.fallback).slice(0, 160),
    headerHtml: `<h1 class="page-title">${escapeHtml(p.icon || '')} ${escapeHtml(name)}</h1><p class="page-subtitle">${escapeHtml(p.company_name || '')} — ${escapeHtml(category)} ${industry ? '· ' + escapeHtml(industry) : ''}</p>`,
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
        sendTemplateEmail(env, 'premium_activated', session.customer_details.email,
          { companyName, link: `${SITE_URL}/pages/supplier.html` }).catch(() => {});
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

    if (url.pathname === '/api/request-password-reset') {
      if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: CORS_HEADERS });
      if (request.method === 'POST') return handleRequestPasswordReset(request, env, ctx);
      return json({ error: 'Method not allowed' }, 405);
    }

    if (url.pathname === '/api/admin-users') {
      if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: CORS_HEADERS });
      if (request.method === 'POST') return handleAdminUsers(request, env);
      return json({ error: 'Method not allowed' }, 405);
    }

    if (url.pathname === '/api/send-invite-email') {
      if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: CORS_HEADERS });
      if (request.method === 'POST') return handleSendInviteEmail(request, env);
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
