// ═══════════════════════════════
// COMPTE ACHETEUR (optionnel) — préremplit le formulaire "Demander un
// devis" et garde un historique des demandes envoyées (voir
// backend/supabase_add_buyer_accounts.sql). Le parcours anonyme reste
// inchangé pour qui ne se connecte pas : ceci n'ajoute rien d'obligatoire.
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

async function initBuyerSession() {
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
  const res = await fetch(`${SUPABASE_URL}/auth/v1/signup`, {
    method: 'POST',
    headers: { 'apikey': SUPABASE_ANON, 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password }),
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.error_description || data.msg || 'Inscription impossible.');
  if (!data.access_token) throw new Error('Compte créé. Vérifie ta boîte mail pour confirmer ton adresse, puis connecte-toi.');

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
  if (!res.ok || !data.access_token) throw new Error(data.error_description || data.msg || 'Identifiants incorrects.');
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

// ── Verrou "compte gratuit" (fiches produit / entreprise) ─────────────
// Verrou VISUEL uniquement (phase 1) : les données restent servies par
// les RPC publiques, voir js/pages/produit.js / entreprise.js.
function isBuyerLoggedIn() {
  return !!buyerSession();
}

// Lien vers la page compte, qui renvoie ensuite l'utilisateur ici (?next=).
function lockAccountHref() {
  const next = window.location.pathname + window.location.search;
  return ROOT_PREFIX + 'pages/compte-acheteur.html?src=lock&next=' + encodeURIComponent(next);
}

function trackLockEvent(name, page) {
  if (typeof window.gtag === 'function') window.gtag('event', name, { page_type: page });
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
