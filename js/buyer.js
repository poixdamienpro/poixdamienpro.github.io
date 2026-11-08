// ═══════════════════════════════
// COMPTE ACHETEUR — donne accès au catalogue (annuaire, catalogue, fiches,
// carte : voir le verrou plus bas), préremplit le formulaire "Demander un
// devis" et garde un historique des demandes envoyées (voir
// backend/supabase_add_buyer_accounts.sql). La demande de devis générale
// et le référencement fournisseur restent ouverts sans compte.
//
// Session en localStorage (pas sessionStorage comme fournisseur/admin) :
// c'est un compte de confort à faible enjeu, on veut qu'il survive à la
// fermeture de l'onglet plutôt que d'obliger à se reconnecter à chaque
// visite. Rafraîchi via le refresh_token Supabase au chargement de
// chaque page (voir initBuyerSession, appelé depuis js/layout.js).
// ═══════════════════════════════
let buyerProfile = null; // { user_id, name, email, company } si connecté

function buyerSession() {
  const token = localStorage.getItem('buyer_access_token');
  const userId = localStorage.getItem('buyer_user_id');
  return token && userId ? { token, userId } : null;
}

async function buyerFetch(path, options = {}) {
  const session = buyerSession();
  const res = await fetch(`${SUPABASE_URL}/rest/v1/${path}`, {
    ...options,
    headers: {
      'apikey': SUPABASE_ANON,
      'Authorization': 'Bearer ' + (session ? session.token : SUPABASE_ANON),
      'Content-Type': 'application/json',
      ...(options.headers || {}),
    },
  });
  if (!res.ok) throw new Error(`HTTP ${res.status} sur ${path}`);
  if (res.status === 204) return null;
  return res.json().catch(() => null);
}

async function loadBuyerProfile() {
  const session = buyerSession();
  if (!session) { buyerProfile = null; return; }
  try {
    const rows = await buyerFetch(`buyer_profiles?user_id=eq.${session.userId}&select=*`);
    buyerProfile = (rows && rows.length) ? rows[0] : null;
  } catch {
    buyerProfile = null;
  }
}

// Tente de rafraîchir la session via le refresh_token stocké — appelé à
// chaque chargement de page puisque l'access_token expire (~1h) bien
// avant qu'on veuille forcer une reconnexion.
async function buyerRefreshSession() {
  const refreshToken = localStorage.getItem('buyer_refresh_token');
  if (!refreshToken) return false;
  try {
    const res = await fetch(`${SUPABASE_URL}/auth/v1/token?grant_type=refresh_token`, {
      method: 'POST',
      headers: { 'apikey': SUPABASE_ANON, 'Content-Type': 'application/json' },
      body: JSON.stringify({ refresh_token: refreshToken }),
    });
    const data = await res.json();
    if (!res.ok || !data.access_token) return false;
    localStorage.setItem('buyer_access_token', data.access_token);
    localStorage.setItem('buyer_refresh_token', data.refresh_token);
    return true;
  } catch {
    return false;
  }
}

// Atterrissage après le clic sur le lien « Confirmer mon adresse » de l'email Supabase :
// Supabase renvoie vers le site avec la session dans le fragment d'URL (#access_token=…&type=signup).
// On ne s'en sert pas pour connecter (le visiteur se connecte avec son mot de passe) : on retire
// le jeton de la barre d'adresse et on affiche une confirmation, sur n'importe quelle page.
function handleSignupConfirmationLanding() {
  const h = window.location.hash || '';
  if (!/[#&]type=signup(&|$)/.test(h) || !/access_token=/.test(h)) return;
  try { history.replaceState(null, '', window.location.pathname + window.location.search); } catch (e) {}
  const en = typeof getLang === 'function' && getLang() === 'en';
  const bar = document.createElement('div');
  bar.setAttribute('role', 'status');
  bar.style.cssText = 'position:fixed;top:68px;left:50%;transform:translateX(-50%);z-index:300;max-width:calc(100vw - 32px);background:#1F5D44;color:#fff;padding:12px 18px;border-radius:8px;font:600 13px/1.4 "Public Sans",sans-serif;box-shadow:0 8px 24px rgba(0,0,0,.3);display:flex;gap:12px;align-items:center';
  bar.innerHTML = '<span>' + (en ? '✓ Email address confirmed. You can now log in with your password.' : '✓ Adresse email confirmée. Vous pouvez maintenant vous connecter avec votre mot de passe.') + '</span><button type="button" aria-label="Close" style="background:none;border:none;color:#fff;font-size:16px;cursor:pointer">✕</button>';
  bar.querySelector('button').onclick = () => bar.remove();
  document.body.appendChild(bar);
  setTimeout(() => bar.remove(), 15000);
}

async function initBuyerSession() {
  handleSignupConfirmationLanding();
  if (localStorage.getItem('buyer_refresh_token')) {
    const ok = await buyerRefreshSession();
    if (ok) await loadBuyerProfile();
    else buyerLogout();
  }
  updateBuyerNavUI();
}

function updateBuyerNavUI() {
  const link = document.getElementById('buyer-account-link');
  if (!link) return;
  const href = ROOT_PREFIX + 'pages/compte-acheteur.html';
  link.href = href;
  link.textContent = buyerProfile && buyerProfile.name
    ? `👤 ${buyerProfile.name.split(' ')[0]}`
    : (typeof t === 'function' ? t('nav_mon_compte') : 'Mon compte');
}

async function buyerSignup(email, password, name, company) {
  const res = await fetch(`${SUPABASE_URL}/auth/v1/signup?redirect_to=${encodeURIComponent(new URL(ROOT_PREFIX + 'pages/compte-acheteur.html', window.location.href).href)}`, {
    method: 'POST',
    headers: { 'apikey': SUPABASE_ANON, 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password, data: (typeof consentProof === 'function' ? consentProof() : {}) }),
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.error_description || data.msg || t('acc_err_signup'));
  if (!data.access_token) { const e = new Error(t('acc_err_confirm')); e.code = 'confirm_email'; throw e; }

  localStorage.setItem('buyer_access_token', data.access_token);
  localStorage.setItem('buyer_refresh_token', data.refresh_token);
  localStorage.setItem('buyer_user_id', data.user.id);

  await fetch(`${SUPABASE_URL}/rest/v1/buyer_profiles`, {
    method: 'POST',
    headers: {
      'apikey': SUPABASE_ANON,
      'Authorization': 'Bearer ' + data.access_token,
      'Content-Type': 'application/json',
      'Prefer': 'return=minimal',
    },
    body: JSON.stringify([{ user_id: data.user.id, name, email, company }]),
  });
  buyerProfile = { user_id: data.user.id, name, email, company };
  updateBuyerNavUI();
}

async function buyerLogin(email, password) {
  const res = await fetch(`${SUPABASE_URL}/auth/v1/token?grant_type=password`, {
    method: 'POST',
    headers: { 'apikey': SUPABASE_ANON, 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password }),
  });
  const data = await res.json();
  if (!res.ok || !data.access_token) throw new Error(data.error_description || data.msg || t('acc_err_login'));
  localStorage.setItem('buyer_access_token', data.access_token);
  localStorage.setItem('buyer_refresh_token', data.refresh_token);
  localStorage.setItem('buyer_user_id', data.user.id);
  await loadBuyerProfile();

  // Compte auth.users existant sans ligne buyer_profiles (ex. un compte
  // admin ou fournisseur qui se connecte ici pour la première fois avec
  // les mêmes identifiants) — on crée un profil minimal plutôt que de
  // laisser un état "connecté mais vide".
  if (!buyerProfile) {
    try {
      await fetch(`${SUPABASE_URL}/rest/v1/buyer_profiles`, {
        method: 'POST',
        headers: {
          'apikey': SUPABASE_ANON,
          'Authorization': 'Bearer ' + data.access_token,
          'Content-Type': 'application/json',
          'Prefer': 'return=minimal',
        },
        body: JSON.stringify([{ user_id: data.user.id, name: '', email, company: '' }]),
      });
      buyerProfile = { user_id: data.user.id, name: '', email, company: '' };
    } catch { /* pas bloquant, le profil restera vide et éditable plus tard */ }
  }

  updateBuyerNavUI();
}

function buyerLogout() {
  localStorage.removeItem('buyer_access_token');
  localStorage.removeItem('buyer_refresh_token');
  localStorage.removeItem('buyer_user_id');
  buyerProfile = null;
  updateBuyerNavUI();
}

// ── Verrou « compte gratuit » ─────────────────────────────────────────────────────────────────────────
// Le catalogue (annuaire, catalogue, systémiers, prestations, fiches entreprise et produit, carte) est réservé aux comptes
// inscrits, acheteurs ou fournisseurs. Le verrou est réel : sans compte, la base de données refuse de répondre (voir
// backend/supabase_members_only_catalogue_2026_11.sql). Sans compte, ces pages affichent la page fermée ci-dessous.
function isMember() {
  try { return !!(buyerSession() || sessionStorage.getItem('sup_access_token') || sessionStorage.getItem('admin_access_token')); } catch (e) { return !!buyerSession(); }
}
function isBuyerLoggedIn() {
  return isMember();
}

// Lien vers la page compte, qui renvoie ensuite l'utilisateur ici (?next=).
function lockAccountHref() {
  const next = window.location.pathname + window.location.search;
  return ROOT_PREFIX + 'pages/compte-acheteur.html?src=lock&next=' + encodeURIComponent(next);
}

function trackLockEvent(name, page) {
  if (typeof window.gtag === 'function') window.gtag('event', name, { page_type: page });
}

// ── Page fermée affichée aux visiteurs sans compte ───────────────────────────────────────────────────
// Présentation de Buy-inner, pourquoi, fondateurs, quelques exemples de fiches SANS nom de fabricant ni de produit,
// et le lien pour s'inscrire ou se connecter. Les exemples sont volontairement génériques et qualitatifs : ils ne
// permettent pas de retrouver un fabricant. Textes à relire par les fondateurs.
const GATE_TEXT = {
  fr: {
    eyebrow: 'Base réservée aux membres',
    title: 'La base de données Buy-inner est réservée aux comptes inscrits',
    lead: 'Buy-inner rassemble des fabricants et des équipementiers du spatial, de l’aéronautique, de l’énergie, de la mobilité électrique et du maritime, avec des fiches techniques comparables. La consultation est gratuite pour les acheteurs et les ingénieurs : il suffit de créer un compte.',
    expired: 'Votre session a expiré ou votre compte n’est pas reconnu. Reconnectez-vous pour continuer.',
    signup: 'Créer un compte gratuit', login: 'Se connecter', free: 'Gratuit pour les acheteurs et les ingénieurs. Aucune carte bancaire.',
    whyH: 'Pourquoi Buy-inner',
    whyP: 'Trouver le bon fournisseur d’un sous-système prend des semaines : chercher entreprise par entreprise, comparer des fiches techniques qui n’ont ni le même format ni les mêmes unités, attendre des réponses. Buy-inner réunit ces informations au même endroit, avec leurs sources, pour que les équipes d’ingénierie passent leur temps sur leur produit.',
    getH: 'Avec un compte gratuit',
    get: ['Les fiches techniques complètes et les datasheets', 'La comparaison de produits côte à côte', 'La carte des fournisseurs', 'Les demandes de devis, sans limite'],
    teamH: 'Qui sommes-nous',
    teamP: 'Buy-inner est fondée par Damien Poix (CEO) et Faez Abdou (CTO), ingénieurs du spatial et des systèmes embarqués.',
    teamMore: 'En savoir plus',
    exH: 'Exemples de fiches', exNote: 'Les noms des fabricants et des produits sont visibles après connexion.', exMaker: 'Fabricant : réservé aux membres',
    supplier: 'Vous êtes fabricant ? Référencez gratuitement votre entreprise',
    teaser: 'Les produits référencés sont réservés aux comptes inscrits.',
  },
  en: {
    eyebrow: 'Members-only database',
    title: 'The Buy-inner database is reserved for registered accounts',
    lead: 'Buy-inner brings together manufacturers and equipment suppliers for space, aerospace, energy, electric mobility and marine, with comparable technical sheets. Browsing is free for buyers and engineers: you only need to create an account.',
    expired: 'Your session has expired or your account is not recognised. Please sign in again to continue.',
    signup: 'Create a free account', login: 'Sign in', free: 'Free for buyers and engineers. No credit card.',
    whyH: 'Why Buy-inner',
    whyP: 'Finding the right supplier for a subsystem takes weeks: searching company by company, comparing technical sheets that share neither format nor units, waiting for answers. Buy-inner gathers this information in one place, with its sources, so engineering teams can spend their time on their product.',
    getH: 'With a free account',
    get: ['Full technical sheets and datasheets', 'Side-by-side product comparison', 'The supplier map', 'Unlimited quote requests'],
    teamH: 'Who we are',
    teamP: 'Buy-inner is founded by Damien Poix (CEO) and Faez Abdou (CTO), engineers in space and embedded systems.',
    teamMore: 'Learn more',
    exH: 'Example listings', exNote: 'Manufacturer and product names are visible once you sign in.', exMaker: 'Manufacturer: members only',
    supplier: 'Are you a manufacturer? List your company for free',
    teaser: 'Listed products are reserved for registered accounts.',
  },
};
const GATE_EXAMPLES = [
  { ico: '🛰️',
    fr: { t: 'Ordinateur de bord pour nanosatellite', s: 'Spatial · Calculateurs embarqués', d: 'Format compact, processeur de type système sur puce, interfaces adaptées aux bus spatiaux, mémoire non volatile.' },
    en: { t: 'Onboard computer for nanosatellites', s: 'Space · Onboard computers', d: 'Compact format, system-on-chip processor, interfaces suited to spacecraft buses, non-volatile memory.' } },
  { ico: '🔋',
    fr: { t: 'Batterie lithium modulaire', s: 'Énergie et maritime · Batteries et stockage', d: 'Modules associables, système de gestion intégré, certifications de la filière.' },
    en: { t: 'Modular lithium battery', s: 'Energy and marine · Batteries and storage', d: 'Stackable modules, built-in management system, sector certifications.' } },
  { ico: '⚡',
    fr: { t: 'Unité de distribution de puissance', s: 'Aéronautique et défense · Distribution électrique', d: 'Protection électronique des sorties, supervision à distance, conçue pour les environnements sévères.' },
    en: { t: 'Power distribution unit', s: 'Aerospace and defence · Power distribution', d: 'Electronic output protection, remote monitoring, designed for harsh environments.' } },
  { ico: '🔧',
    fr: { t: 'Servovalve de régulation', s: 'Vannes et actionneurs', d: 'Pilotage électrique, bonne précision de positionnement, utilisée pour réguler des fluides.' },
    en: { t: 'Control servo valve', s: 'Valves and actuators', d: 'Electrical control, good positioning accuracy, used to regulate fluids.' } },
  { ico: '🔌',
    fr: { t: 'Convertisseur de puissance bidirectionnel', s: 'Énergie et mobilité électrique · Convertisseurs', d: 'Flux d’énergie entre batterie et réseau, compatible avec les protocoles de recharge.' },
    en: { t: 'Bidirectional power converter', s: 'Energy and e-mobility · Converters', d: 'Energy flows between battery and grid, compatible with charging protocols.' } },
  { ico: '📡',
    fr: { t: 'Amplificateur radiofréquence pour liaison satellite', s: 'Communication et radiofréquence', d: 'Bande de fréquence élevée, redondance, boîtier résistant aux intempéries.' },
    en: { t: 'Satellite-link RF amplifier', s: 'Communication and RF', d: 'High frequency band, redundancy, weather-resistant enclosure.' } },
];

// Langue de la page fermée : celle de la page (les pages anglaises statiques déclarent lang="en") ou le choix du visiteur.
function gateLang() {
  return (document.documentElement.lang === 'en' || (typeof getLang === 'function' && getLang() === 'en')) ? 'en' : 'fr';
}

function membersGateHtml(expired) {
  const lang = gateLang();
  const T = GATE_TEXT[lang];
  const href = lockAccountHref();
  const about = ROOT_PREFIX + (lang === 'en' ? 'en/about.html' : 'pages/qui-sommes-nous.html');
  return `
    <div class="gate-card">
      <div class="gate-eyebrow">🔒 ${T.eyebrow}</div>
      ${expired ? `<div class="gate-expired">${T.expired}</div>` : ''}
      <h1 class="gate-title">${T.title}</h1>
      <p class="gate-lead">${T.lead}</p>
      <div class="gate-actions">
        <a class="gate-btn primary" href="${href}" onclick="trackLockEvent('lock_cta_click','gate')">${T.signup}</a>
        <a class="gate-btn" href="${href}" onclick="trackLockEvent('lock_cta_click','gate')">${T.login}</a>
      </div>
      <p class="gate-note">${T.free}</p>
    </div>
    <div class="gate-cols">
      <div class="gate-col"><h2>${T.whyH}</h2><p>${T.whyP}</p></div>
      <div class="gate-col"><h2>${T.getH}</h2><ul>${T.get.map(x => `<li>${x}</li>`).join('')}</ul></div>
      <div class="gate-col"><h2>${T.teamH}</h2><p>${T.teamP}</p><p><a href="${about}">${T.teamMore} →</a></p></div>
    </div>
    <div class="gate-examples">
      <h2>${T.exH}</h2>
      <div class="gate-exgrid">
        ${GATE_EXAMPLES.map(e => `
          <div class="gate-ex">
            <div class="gate-ex-ico">${e.ico}</div>
            <div class="gate-ex-t">${e[lang].t}</div>
            <div class="gate-ex-s">${e[lang].s}</div>
            <div class="gate-ex-d">${e[lang].d}</div>
            <div class="gate-ex-lock">🔒 ${T.exMaker}</div>
          </div>`).join('')}
      </div>
      <p class="gate-ex-note">${T.exNote}</p>
    </div>
    <div class="gate-supplier"><a href="${ROOT_PREFIX}pages/submit.html">${T.supplier} →</a></div>`;
}

function showMembersGate(pageKey, opts = {}) {
  const slot = document.getElementById('nav-slot');
  if (!slot) return;
  let el = document.getElementById('members-gate');
  if (!el) {
    el = document.createElement('section');
    el.id = 'members-gate';
    el.className = 'members-gate';
    slot.insertAdjacentElement('afterend', el);
  }
  el.dataset.page = pageKey;
  el.dataset.expired = opts.expired ? '1' : '';
  el.innerHTML = membersGateHtml(!!opts.expired);
  document.documentElement.classList.add('members-closed');
  if (!window._gateTracked) { window._gateTracked = true; trackLockEvent('lock_view', pageKey); }
}

// Message court à la place d'une liste de produits intégrée à une page publique (pages de catégories).
function membersTeaserHtml() {
  const lang = gateLang();
  const T = GATE_TEXT[lang];
  const href = lockAccountHref();
  return `<div class="prod-loading">🔒 ${T.teaser} <a href="${href}" style="color:var(--rust)">${T.signup}</a> · <a href="${href}" style="color:var(--rust)">${T.login}</a></div>`;
}

// Re-rendu au changement de langue (appelé par applyLang dans js/i18n.js).
function refreshMembersGate() {
  const el = document.getElementById('members-gate');
  if (el) showMembersGate(el.dataset.page, { expired: el.dataset.expired === '1' });
}

// À appeler au début de chaque page du catalogue : false = la page fermée est affichée, il faut s'arrêter là.
function requireMember(pageKey) {
  if (isMember()) return true;
  showMembersGate(pageKey);
  return false;
}

// Un 401 ou 403 de la base (compte absent, session expirée) rend la page fermée au lieu d'un message d'erreur.
function handleMembersError(err, pageKey) {
  if (err && (err.status === 401 || err.status === 403)) { showMembersGate(pageKey, { expired: true }); return true; }
  return false;
}

// Bloc d'invitation affiché à la place des infos verrouillées. Les lignes
// "fantômes" sont de simples barres factices : aucune vraie donnée verrouillée
// n'est mise dans le DOM.
function lockBoxHtml(extraLine) {
  const tr = typeof t === 'function' ? t : k => k;
  const href = lockAccountHref();
  return `
    <div class="lock-box">
      <div class="lock-ghost"><span style="width:90%"></span><span style="width:70%"></span><span style="width:80%"></span></div>
      <div class="lock-title">🔒 ${tr('lock_title')}</div>
      <p class="lock-text">${extraLine ? extraLine + ' — ' : ''}${tr('lock_text')}</p>
      <div class="lock-actions">
        <a class="lock-signup" href="${href}" onclick="trackLockEvent('lock_cta_click','${window.CURRENT_PAGE || ''}')">${tr('lock_cta_signup')}</a>
        <a class="lock-login" href="${href}" onclick="trackLockEvent('lock_cta_click','${window.CURRENT_PAGE || ''}')">${tr('lock_cta_login')}</a>
      </div>
    </div>`;
}
