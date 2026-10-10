// ═══════════════════════════════
// ADMIN — validation des soumissions fournisseur
// Accès via pages/admin.html. Connexion Supabase Auth (compte créé à la
// main dans le Dashboard, voir backend/supabase_admin_setup.sql). Les
// policies RLS restreignent l'écriture/lecture aux requêtes signées par is_admin().
// ═══════════════════════════════
let adminSubmissionsCache = {};
let adminAnalyticsRows = [];
let adminEntityViewRows = [];

// Plages du sélecteur temporel (voir #admin-range-filter, pages/admin.html)
// -- valeur = nombre de jours en arrière, label = libellé KPI/titre.
const ANALYTICS_RANGES = {
  1:   '1 jour',
  7:   '1 semaine',
  30:  '1 mois',
  90:  '3 mois',
  180: '6 mois',
  365: '1 an',
};

document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  tryRestoreAdminSession();
});

async function adminFetch(path, options = {}) {
  const token = sessionStorage.getItem('admin_access_token');
  const res = await fetch(`${SUPABASE_URL}/rest/v1/${path}`, {
    ...options,
    headers: {
      'apikey': SUPABASE_ANON,
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
      ...(options.headers || {}),
    },
  });
  if (res.status === 401 || res.status === 403) {
    adminLogout();
    throw new Error('Session expirée ou accès refusé, reconnecte-toi.');
  }
  if (!res.ok) {
    const body = await res.json().catch(() => null);
    const detail = body && (body.message || body.details || body.hint);
    throw new Error(`HTTP ${res.status} sur ${path}` + (detail ? ` — ${detail}` : ''));
  }
  if (res.status === 204) return null;
  return res.json().catch(() => null);
}

// PostgREST plafonne toute lecture directe de table à 50 lignes par
// requête (db-max-rows, voir backend/supabase_lock_base_tables.sql),
// quel que soit le `limit` demandé dans l'URL -- sans boucle sur
// `offset`, un compteur basé sur rows.length reste bloqué au plafond dès
// que la table dépasse 50 lignes (c'est ce qui bloquait "Vues · total
// enregistré" à 50 dans l'admin).
async function adminFetchAllPages(path) {
  let all = [];
  let offset = 0;
  while (true) {
    const sep = path.includes('?') ? '&' : '?';
    const page = await adminFetch(`${path}${sep}offset=${offset}`);
    if (!page || !page.length) break;
    all = all.concat(page);
    if (page.length < 50) break;
    offset += page.length;
  }
  return all;
}

// ── MFA (TOTP) ──────────────────────────────────────────────
// API brute Supabase Auth (aucun SDK JS chargé sur ce site, voir js/api.js) :
//   POST /auth/v1/factors                    → enrôle un nouveau facteur TOTP
//   POST /auth/v1/factors/{id}/challenge      → ouvre un défi (avant verify)
//   POST /auth/v1/factors/{id}/verify         → valide un code, renvoie une
//                                                nouvelle session au niveau aal2
//   DELETE /auth/v1/factors/{id}              → retire un facteur
// GET /auth/v1/user renvoie user.factors[] (status 'verified'/'unverified').
//
// Un mot de passe seul ne donne qu'une session aal1 : is_admin() ne
// vérifiera le niveau aal2 qu'après exécution manuelle de
// backend/supabase_enforce_mfa_aal2.sql — à ne lancer QU'UNE FOIS la MFA
// activée et testée sur ce compte, sinon accès admin bloqué pour tout le
// monde (voir avertissement en tête de ce fichier SQL).
let adminPendingAal1Token = null; // token aal1 en attente du code MFA pendant la connexion
let adminPendingFactorId = null;  // id du facteur ciblé par ce défi de connexion
let adminEnrollFactorId = null;   // id du facteur en cours d'enrôlement (avant confirmation)

async function authFetch(path, token, options = {}) {
  const res = await fetch(`${SUPABASE_URL}/auth/v1/${path}`, {
    ...options,
    headers: {
      'apikey': SUPABASE_ANON,
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
      ...(options.headers || {}),
    },
  });
  const data = await res.json().catch(() => null);
  if (!res.ok) throw new Error((data && (data.error_description || data.msg || data.message)) || `HTTP ${res.status}`);
  return data;
}

function verifiedTotpFactor(user) {
  return ((user && user.factors) || []).find(f => f.factor_type === 'totp' && f.status === 'verified') || null;
}

// Selon la version de l'API Auth, totp.qr_code est soit déjà une URL data:
// utilisable telle quelle en <img src>, soit du SVG brut (commence par "<")
// qu'il faut envelopper nous-mêmes -- sans ce cas, l'image ne charge pas.
function qrCodeDataUrl(qrCode) {
  if (!qrCode) return '';
  if (qrCode.startsWith('data:')) return qrCode;
  return 'data:image/svg+xml;utf8,' + encodeURIComponent(qrCode);
}

async function adminLogin(e) {
  e.preventDefault();
  const email = document.getElementById('admin-email').value;
  const password = document.getElementById('admin-password').value;
  const errBox = document.getElementById('admin-login-error');
  errBox.style.display = 'none';

  try {
    const res = await fetch(`${SUPABASE_URL}/auth/v1/token?grant_type=password`, {
      method: 'POST',
      headers: { 'apikey': SUPABASE_ANON, 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password }),
    });
    const data = await res.json();
    if (!res.ok || !data.access_token) {
      throw new Error(data.error_description || data.msg || 'Identifiants incorrects.');
    }

    const user = await authFetch('user', data.access_token);
    const factor = verifiedTotpFactor(user);
    if (factor) {
      // Double authentification active sur ce compte : on n'ouvre pas encore
      // le panneau, on attend le code à 6 chiffres (voir adminMfaVerify).
      adminPendingAal1Token = data.access_token;
      adminPendingFactorId = factor.id;
      sessionStorage.setItem('admin_email', email);
      document.getElementById('admin-login-box').style.display = 'none';
      document.getElementById('admin-mfa-box').style.display = 'block';
      document.getElementById('admin-mfa-code').focus();
      return;
    }

    completeAdminLogin(data.access_token, email);
  } catch (err) {
    errBox.textContent = err.message;
    errBox.style.display = 'block';
  }
}

async function adminMfaVerify(e) {
  e.preventDefault();
  const code = document.getElementById('admin-mfa-code').value.trim();
  const errBox = document.getElementById('admin-mfa-error');
  errBox.style.display = 'none';
  try {
    const challenge = await authFetch(`factors/${adminPendingFactorId}/challenge`, adminPendingAal1Token, {
      method: 'POST', body: JSON.stringify({}),
    });
    const verified = await authFetch(`factors/${adminPendingFactorId}/verify`, adminPendingAal1Token, {
      method: 'POST', body: JSON.stringify({ challenge_id: challenge.id, code }),
    });
    const email = sessionStorage.getItem('admin_email');
    adminPendingAal1Token = null;
    adminPendingFactorId = null;
    document.getElementById('admin-mfa-code').value = '';
    completeAdminLogin(verified.access_token, email);
  } catch (err) {
    errBox.textContent = 'Code invalide ou expiré : ' + err.message;
    errBox.style.display = 'block';
  }
}

function adminMfaCancel() {
  adminPendingAal1Token = null;
  adminPendingFactorId = null;
  document.getElementById('admin-mfa-code').value = '';
  document.getElementById('admin-mfa-box').style.display = 'none';
  document.getElementById('admin-login-box').style.display = 'block';
}

// Onglets du panneau admin — tout restait auparavant empilé sur une
// seule page qui s'allongeait à chaque nouvelle fonctionnalité. Le
// contenu de chaque onglet reste chargé en une fois à la connexion
// (voir completeAdminLogin/tryRestoreAdminSession) : seul l'affichage
// est découpé, pas le chargement des données.
function adminShowTab(name) {
  document.querySelectorAll('.admin-tab-btn').forEach(b => b.classList.toggle('active', b.dataset.tab === name));
  document.querySelectorAll('.admin-tab-panel').forEach(p => p.classList.toggle('active', p.dataset.tab === name));
  sessionStorage.setItem('admin_active_tab', name);
  if (name === 'users' && !adminUsersLoaded && typeof loadAdminUsers === 'function') loadAdminUsers();
}

function completeAdminLogin(accessToken, email) {
  sessionStorage.setItem('admin_access_token', accessToken);
  sessionStorage.setItem('admin_email', email);
  document.getElementById('admin-login-box').style.display = 'none';
  document.getElementById('admin-mfa-box').style.display = 'none';
  document.getElementById('admin-panel').style.display = 'block';
  adminShowTab(sessionStorage.getItem('admin_active_tab') || 'submissions');
  loadAdminMfaStatus();
  loadAnalytics();
  loadSignupStats();
  loadPendingSubmissions();
  loadPendingClaims();
  loadPendingRfqDossiers();
}

function adminLogout() {
  sessionStorage.removeItem('admin_access_token');
  sessionStorage.removeItem('admin_email');
  document.getElementById('admin-panel').style.display = 'none';
  document.getElementById('admin-login-box').style.display = 'block';
}

function tryRestoreAdminSession() {
  if (!sessionStorage.getItem('admin_access_token')) return;
  document.getElementById('admin-login-box').style.display = 'none';
  document.getElementById('admin-panel').style.display = 'block';
  adminShowTab(sessionStorage.getItem('admin_active_tab') || 'submissions');
  loadAdminMfaStatus();
  loadAnalytics();
  loadSignupStats();
  loadPendingSubmissions();
  loadPendingClaims();
  loadPendingRfqDossiers();
}

// ── Statut + enrôlement MFA, affiché en haut du panneau une fois connecté ──
async function loadAdminMfaStatus() {
  const box = document.getElementById('admin-mfa-status');
  if (!box) return;
  const token = sessionStorage.getItem('admin_access_token');
  try {
    const user = await authFetch('user', token);
    const factor = verifiedTotpFactor(user);
    box.innerHTML = factor ? `
      <div class="admin-field-row"><span>✓ Double authentification active</span>
        <button class="btn-remove-product" onclick="removeMfaFactor('${factor.id}')">Désactiver</button>
      </div>` : `
      <div class="admin-field-row"><span>⚠️ Double authentification non activée sur ce compte</span>
        <button class="btn-add-product" onclick="startMfaEnrollment()">Activer</button>
      </div>`;
  } catch (err) {
    box.innerHTML = `<p style="color:#C0392B;font-size:12px">${escapeHtml(err.message)}</p>`;
  }
}

async function startMfaEnrollment() {
  const box = document.getElementById('admin-mfa-status');
  const token = sessionStorage.getItem('admin_access_token');
  box.innerHTML = '<p style="font-size:12px;color:var(--muted)">Génération du QR code…</p>';
  try {
    // Nettoyage best-effort des tentatives précédentes non vérifiées (pure
    // hygiène du compte) -- volontairement SANS incidence sur la suite : la
    // création ci-dessous utilise un friendly_name unique (horodaté), donc
    // ne peut plus jamais entrer en collision avec un facteur abandonné,
    // même si ce nettoyage échoue ou ne trouve rien à supprimer.
    try {
      const existingUser = await authFetch('user', token);
      const abandoned = ((existingUser && existingUser.factors) || []).filter(f => f.status !== 'verified');
      for (const f of abandoned) {
        await authFetch(`factors/${f.id}`, token, { method: 'DELETE' });
      }
    } catch (cleanupErr) {
      console.warn('Nettoyage des facteurs MFA abandonnés ignoré :', cleanupErr.message);
    }

    const factor = await authFetch('factors', token, {
      method: 'POST',
      // issuer : nom affiché dans l'appli d'authentification (sinon, l'adresse du projet Supabase)
      body: JSON.stringify({ factor_type: 'totp', issuer: 'Buy-inner admin', friendly_name: `Authenticator-${Date.now()}` }),
    });
    adminEnrollFactorId = factor.id;
    const qrSrc = qrCodeDataUrl(factor.totp.qr_code);
    const otpUri = factor.totp.uri && factor.totp.uri.startsWith('otpauth://') ? factor.totp.uri : '';
    box.innerHTML = `
      <p style="font-size:12px;color:var(--text2);line-height:1.6">1. Scanne ce QR code avec ton application d'authentification (Google Authenticator, 1Password, Authy...) — ou si ça ne marche pas, choisis "Saisir une clé manuellement" dans l'appli et colle la clé ci-dessous.</p>
      <p style="font-size:12px;color:var(--text2);line-height:1.6"><strong>iPhone :</strong> l'appareil photo ouvre l'app <em>Mots de passe</em> (trousseau iCloud), qui sait aussi générer ces codes : choisis « Configurer le code de vérification » (ou « Ajouter à un identifiant »), puis recopie le code affiché. Si tu préfères une appli dédiée, ouvre Google Authenticator / Authy et scanne depuis l'appli. Le code est alors synchronisé avec le compte iCloud, qui doit donc être protégé.</p>
      ${qrSrc ? `<img src="${escapeHtml(qrSrc)}" alt="QR code MFA" style="width:180px;height:180px;border:1px solid var(--border);border-radius:8px;margin:10px 0"/>` : '<p style="font-size:12px;color:#C0392B">QR code indisponible, utilise la clé manuelle ci-dessous.</p>'}
      ${otpUri ? `<p style="font-size:12px;margin:0 0 8px"><a href="${escapeHtml(otpUri)}">📱 Déjà sur ton téléphone ? Ouvre directement dans ton appli d'authentification</a></p>` : ''}
      <p style="font-size:11px;color:var(--muted);word-break:break-all">Clé manuelle (si le QR code ne scanne pas) : <strong>${escapeHtml(factor.totp.secret)}</strong></p>
      <p style="font-size:12px;color:var(--text2);line-height:1.6;margin-top:10px">2. Une fois le compte ajouté dans l'appli, elle affiche un <strong>code à 6 chiffres qui change toutes les 30 secondes</strong> — recopie CE code ci-dessous (pas la clé manuelle).</p>
      <form onsubmit="confirmMfaEnrollment(event)">
        <div class="lead-field"><label>Code à 6 chiffres généré par l'appli</label><input type="text" id="admin-mfa-enroll-code" inputmode="numeric" pattern="[0-9]*" maxlength="6" autocomplete="one-time-code" placeholder="123456" required/></div>
        <button type="submit" class="btn-submit-form">Confirmer l'activation</button>
        <button type="button" class="btn-remove-product" style="margin-top:8px" onclick="loadAdminMfaStatus()">Annuler</button>
        <p id="admin-mfa-enroll-error" style="color:#C0392B;font-size:12px;margin-top:8px;display:none"></p>
      </form>`;
  } catch (err) {
    box.innerHTML = `<p style="color:#C0392B;font-size:12px">${escapeHtml(err.message)}</p>`;
  }
}

async function confirmMfaEnrollment(e) {
  e.preventDefault();
  const code = document.getElementById('admin-mfa-enroll-code').value.trim();
  const errBox = document.getElementById('admin-mfa-enroll-error');
  const token = sessionStorage.getItem('admin_access_token');
  try {
    const challenge = await authFetch(`factors/${adminEnrollFactorId}/challenge`, token, {
      method: 'POST', body: JSON.stringify({}),
    });
    await authFetch(`factors/${adminEnrollFactorId}/verify`, token, {
      method: 'POST', body: JSON.stringify({ challenge_id: challenge.id, code }),
    });
    adminEnrollFactorId = null;
    alert("Double authentification activée. Elle sera demandée à ta prochaine connexion — ne lance backend/supabase_enforce_mfa_aal2.sql qu'après avoir vérifié qu'une reconnexion complète fonctionne.");
    loadAdminMfaStatus();
  } catch (err) {
    errBox.textContent = 'Code invalide : ' + err.message;
    errBox.style.display = 'block';
  }
}

async function removeMfaFactor(factorId) {
  if (!confirm('Désactiver la double authentification sur ce compte ? Si backend/supabase_enforce_mfa_aal2.sql a déjà été exécuté, tu perdras l\'accès admin tant que tu ne réactives pas la MFA.')) return;
  const token = sessionStorage.getItem('admin_access_token');
  try {
    await authFetch(`factors/${factorId}`, token, { method: 'DELETE' });
    loadAdminMfaStatus();
  } catch (err) {
    alert('Erreur : ' + err.message);
  }
}

// ── Analytics — vues de page anonymes loggées par js/layout.js ──
async function loadAnalytics() {
  const kpis = document.getElementById('admin-analytics-kpis');
  const top = document.getElementById('admin-analytics-top');
  kpis.innerHTML = '<div class="admin-empty">Chargement…</div>';
  top.innerHTML = '';
  try {
    [adminAnalyticsRows, adminEntityViewRows] = await Promise.all([
      // user_agent sert uniquement à écarter les robots déjà enregistrés (voir isBotUserAgent, js/layout.js)
      adminFetchAllPages('site_page_views?select=page,user_agent,created_at&order=created_at.desc')
        .then(rows => rows.filter(r => !isBotUserAgent(r.user_agent) && !r.page.endsWith('/admin.html'))),
      adminFetchAllPages('entity_views?select=entity_type,product_id,product_name,category,company_id,company_name,industry,created_at&order=created_at.desc'),
    ]);

    const select = document.getElementById('admin-chart-page-filter');
    const allPages = [...new Set(adminAnalyticsRows.map(r => r.page))].sort();
    select.innerHTML = '<option value="__all__">Toutes les pages</option>' +
      allPages.map(p => `<option value="${escapeHtml(p)}">${escapeHtml(p)}</option>`).join('');

    renderAnalyticsForRange();
  } catch (err) {
    kpis.innerHTML = `<div class="admin-empty">${err.message}</div>`;
  }
}

// Rappelé au changement de #admin-range-filter -- toutes les lignes sont
// déjà en mémoire (adminAnalyticsRows), donc pas de nouvel appel réseau.
function onAnalyticsRangeChange() {
  renderAnalyticsForRange();
}

// Rendu générique d'un bloc "top N" (pages/produits/catégories/domaines) --
// même structure `.admin-field-row` que le reste du panel admin.
function renderTopList(elId, title, entries, emptyMsg) {
  const el = document.getElementById(elId);
  if (!el) return;
  el.innerHTML = !entries.length
    ? `<div class="admin-empty">${emptyMsg}</div>`
    : `<div class="submit-section-title" style="margin-top:0">${title}</div>` +
      entries.map(([label, n]) => `<div class="admin-field-row"><span>${escapeHtml(label)}</span><span>${n} vue${n > 1 ? 's' : ''}</span></div>`).join('');
}

// ── KPIs + top pages/produits/catégories/domaines pour la plage
// sélectionnée (#admin-range-filter) ──
function renderAnalyticsForRange() {
  const kpis = document.getElementById('admin-analytics-kpis');
  const rangeDays = Number(document.getElementById('admin-range-filter').value) || 30;
  const rangeLabel = ANALYTICS_RANGES[rangeDays] || `${rangeDays} j`;

  const now = Date.now();
  const DAY = 24 * 60 * 60 * 1000;
  const within = (r, days) => now - new Date(r.created_at).getTime() <= days * DAY;

  const rows = adminAnalyticsRows;
  const inRange = rows.filter(r => within(r, rangeDays));

  kpis.innerHTML = [
    [`Vues · ${rangeLabel}`, inRange.length],
    ['Vues · total enregistré', rows.length],
  ].map(([label, n]) => `<div class="kpi"><div><div class="kpi-n">${n}</div><div class="kpi-l">${label}</div></div></div>`).join('');

  const pageCounts = {};
  inRange.forEach(r => { pageCounts[r.page] = (pageCounts[r.page] || 0) + 1; });
  const topPages = Object.entries(pageCounts).sort((a, b) => b[1] - a[1]).slice(0, 10);
  renderTopList('admin-analytics-top', `Pages les plus vues (${rangeLabel})`, topPages,
    `Aucune vue enregistrée sur cette période (${rangeLabel}).`);

  // Vues par fiche produit/entreprise (voir backend/supabase_add_entity_views_2026_09.sql
  // -- table séparée de site_page_views, alimentée uniquement par
  // pages/produit.html et pages/entreprise.html).
  const entityInRange = adminEntityViewRows.filter(r => within(r, rangeDays));

  const productCounts = {};
  entityInRange.filter(r => r.entity_type === 'product' && r.product_id).forEach(r => {
    if (!productCounts[r.product_id]) productCounts[r.product_id] = { name: r.product_name || r.product_id, n: 0 };
    productCounts[r.product_id].n++;
  });
  const topProducts = Object.values(productCounts).sort((a, b) => b.n - a.n).slice(0, 10).map(p => [p.name, p.n]);
  renderTopList('admin-analytics-top-products', `Produits les plus vus (${rangeLabel})`, topProducts,
    `Aucune vue produit sur cette période (${rangeLabel}).`);

  const categoryCounts = {};
  entityInRange.filter(r => r.category).forEach(r => { categoryCounts[r.category] = (categoryCounts[r.category] || 0) + 1; });
  const topCategories = Object.entries(categoryCounts).sort((a, b) => b[1] - a[1]).slice(0, 10);
  renderTopList('admin-analytics-top-categories', `Catégories les plus vues (${rangeLabel})`, topCategories,
    `Aucune vue sur cette période (${rangeLabel}).`);

  const domainCounts = {};
  entityInRange.filter(r => r.industry).forEach(r => { domainCounts[r.industry] = (domainCounts[r.industry] || 0) + 1; });
  const topDomains = Object.entries(domainCounts).sort((a, b) => b[1] - a[1]).slice(0, 10);
  renderTopList('admin-analytics-top-domains', `Domaines les plus vus (${rangeLabel})`, topDomains,
    `Aucune vue sur cette période (${rangeLabel}).`);

  renderAnalyticsChart();
}

// ── Graphique courbe — visites sur la plage sélectionnée, filtrable par
// page. Granularité horaire pour "1 jour" (24 points), journalière sinon
// (un point par jour de la plage) — au-delà de 60 points, les puces par
// point sont masquées pour rester lisible (la courbe suffit).
function renderAnalyticsChart() {
  const wrap = document.getElementById('admin-analytics-chart');
  const filter = document.getElementById('admin-chart-page-filter').value;
  const rangeDays = Number(document.getElementById('admin-range-filter').value) || 30;
  const rows = filter === '__all__' ? adminAnalyticsRows : adminAnalyticsRows.filter(r => r.page === filter);

  const HOUR = 60 * 60 * 1000, DAY = 24 * HOUR;
  const hourly = rangeDays === 1;

  let buckets, counts, labelFor;
  if (hourly) {
    const now = new Date(); now.setMinutes(0, 0, 0);
    buckets = [];
    for (let i = 23; i >= 0; i--) buckets.push(new Date(now.getTime() - i * HOUR));
    counts = buckets.map(b => rows.filter(r => {
      const t = new Date(r.created_at).getTime();
      return t >= b.getTime() && t < b.getTime() + HOUR;
    }).length);
    labelFor = b => `${b.getHours()}h`;
  } else {
    const today = new Date(); today.setHours(0, 0, 0, 0);
    buckets = [];
    for (let i = rangeDays - 1; i >= 0; i--) buckets.push(new Date(today.getTime() - i * DAY));
    counts = buckets.map(b => {
      const dayStr = b.toISOString().slice(0, 10);
      return rows.filter(r => r.created_at.slice(0, 10) === dayStr).length;
    });
    labelFor = b => `${b.getDate()}/${b.getMonth() + 1}`;
  }

  if (!rows.length) {
    wrap.innerHTML = '<div class="admin-empty">Aucune vue enregistrée pour cette sélection.</div>';
    return;
  }

  const W = 760, H = 220, padL = 36, padB = 26, padT = 10, padR = 10;
  const chartW = W - padL - padR, chartH = H - padT - padB;
  const max = Math.max(1, ...counts);

  const x = i => padL + (counts.length === 1 ? chartW / 2 : (i / (counts.length - 1)) * chartW);
  const y = v => padT + chartH - (v / max) * chartH;

  const points = counts.map((v, i) => `${x(i)},${y(v)}`).join(' ');
  const areaPoints = `${padL},${padT + chartH} ${points} ${padL + chartW},${padT + chartH}`;

  const gridLines = [0, 0.5, 1].map(f => {
    const yy = padT + chartH - f * chartH;
    return `<line x1="${padL}" y1="${yy}" x2="${padL + chartW}" y2="${yy}" stroke="var(--border)" stroke-width="1"/>
            <text x="${padL - 8}" y="${yy + 4}" font-size="10" fill="var(--muted)" text-anchor="end">${Math.round(f * max)}</text>`;
  }).join('');

  // Espace les labels de l'axe X pour rester lisible quelle que soit la
  // plage (24 points horaires jusqu'à 365 points journaliers).
  const labelStride = Math.max(1, Math.ceil(counts.length / 8));
  const xLabels = counts.map((v, i) => {
    if (i % labelStride !== 0 && i !== counts.length - 1) return '';
    return `<text x="${x(i)}" y="${H - 6}" font-size="9" fill="var(--muted)" text-anchor="middle">${labelFor(buckets[i])}</text>`;
  }).join('');

  const dateFmt = hourly
    ? b => b.toLocaleDateString('fr-FR') + ' ' + labelFor(b)
    : b => b.toLocaleDateString('fr-FR');
  const dots = counts.length > 60 ? '' : counts.map((v, i) => `<circle cx="${x(i)}" cy="${y(v)}" r="2.5" fill="var(--accent, #2563eb)"><title>${dateFmt(buckets[i])} : ${v} vue${v !== 1 ? 's' : ''}</title></circle>`).join('');

  wrap.innerHTML = `
    <svg viewBox="0 0 ${W} ${H}" style="width:100%;height:auto;background:var(--white);border:1px solid var(--border);border-radius:8px">
      ${gridLines}
      <polygon points="${areaPoints}" fill="var(--accent, #2563eb)" opacity="0.08"/>
      <polyline points="${points}" fill="none" stroke="var(--accent, #2563eb)" stroke-width="2"/>
      ${dots}
      ${xLabels}
    </svg>`;
}

// ── Inscrits — courbes du nombre de comptes créés dans le temps ──
// Données : RPC admin-only get_signup_stats (voir
// backend/supabase_add_signup_stats_2026_10.sql), un agrégat par jour.
let adminSignupRows = [];

async function loadSignupStats() {
  const kpis = document.getElementById('admin-signups-kpis');
  if (!kpis) return;
  kpis.innerHTML = '<div class="admin-empty">Chargement…</div>';
  try {
    adminSignupRows = (await adminFetch('rpc/get_signup_stats', { method: 'POST', body: '{}' })) || [];
    renderSignups();
  } catch (err) {
    kpis.innerHTML = `<div class="admin-empty">${escapeHtml(err.message)} (backend/supabase_add_signup_stats_2026_10.sql exécuté ?)</div>`;
  }
}

function signupDayString(offsetFromToday = 0) {
  const parisToday = new Date().toLocaleDateString('sv-SE', { timeZone: 'Europe/Paris' });
  const d = new Date(parisToday + 'T00:00:00Z');
  d.setUTCDate(d.getUTCDate() + offsetFromToday);
  return d.toISOString().slice(0, 10);
}

function renderSignups() {
  const kpis = document.getElementById('admin-signups-kpis');
  if (!kpis) return;
  const rows = adminSignupRows;
  const rangeDays = Number(document.getElementById('admin-signups-range').value);
  const today = signupDayString(0);
  const firstDay = rows.length ? rows[0].day : today;
  const startDay = rangeDays === 0 ? firstDay : signupDayString(-(rangeDays - 1));

  const byDay = {};
  rows.forEach(r => { byDay[r.day] = r; });

  // Liste continue des jours de la plage (les jours sans inscription valent 0).
  const days = [];
  for (let d = new Date(startDay + 'T00:00:00Z'); d.toISOString().slice(0, 10) <= today; d.setUTCDate(d.getUTCDate() + 1)) {
    days.push(d.toISOString().slice(0, 10));
  }
  const daily = days.map(d => (byDay[d] ? byDay[d].signups : 0));
  const baseline = rows.filter(r => r.day < startDay).reduce((n, r) => n + r.signups, 0);
  let running = baseline;
  const cumulative = daily.map(n => (running += n));

  const total = rows.reduce((n, r) => n + r.signups, 0);
  const totalConfirmed = rows.reduce((n, r) => n + r.confirmed, 0);
  const inRange = daily.reduce((a, b) => a + b, 0);
  const rangeLabel = rangeDays === 0 ? 'depuis le début' : (ANALYTICS_RANGES[rangeDays] || `${rangeDays} j`);
  const last7 = days.slice(-7).reduce((n, d) => n + (byDay[d] ? byDay[d].signups : 0), 0);

  kpis.innerHTML = [
    ['Inscrits · total', total],
    ['dont e-mail confirmé', totalConfirmed],
    [`Nouveaux · ${rangeLabel}`, inRange],
    ['Nouveaux · 7 derniers jours', last7],
  ].map(([label, n]) => `<div class="kpi"><div><div class="kpi-n">${n}</div><div class="kpi-l">${label}</div></div></div>`).join('');

  const fmt = d => new Date(d + 'T00:00:00Z').toLocaleDateString('fr-FR', { timeZone: 'UTC' });
  renderSeriesChart('admin-signups-total-chart', days, cumulative, 'line', fmt, 'inscrit');
  renderSeriesChart('admin-signups-daily-chart', days, daily, 'bar', fmt, 'inscription');
}

// Graphique SVG générique (courbe ou barres) : mêmes dimensions/style que
// renderAnalyticsChart.
function renderSeriesChart(elId, days, values, kind, fmt, unit) {
  const wrap = document.getElementById(elId);
  if (!wrap) return;
  if (!values.length) { wrap.innerHTML = '<div class="admin-empty">Aucune donnée.</div>'; return; }

  const W = 760, H = 220, padL = 36, padB = 26, padT = 10, padR = 10;
  const chartW = W - padL - padR, chartH = H - padT - padB;
  const max = Math.max(1, ...values);
  const n = values.length;
  const x = i => padL + (n === 1 ? chartW / 2 : (i / (n - 1)) * chartW);
  const y = v => padT + chartH - (v / max) * chartH;

  const gridLines = [0, 0.5, 1].map(f => {
    const yy = padT + chartH - f * chartH;
    return `<line x1="${padL}" y1="${yy}" x2="${padL + chartW}" y2="${yy}" stroke="var(--border)" stroke-width="1"/>
            <text x="${padL - 8}" y="${yy + 4}" font-size="10" fill="var(--muted)" text-anchor="end">${Math.round(f * max)}</text>`;
  }).join('');

  const stride = Math.max(1, Math.ceil(n / 8));
  const xLabels = days.map((d, i) => {
    if (i % stride !== 0 && i !== n - 1) return '';
    const [, m, dd] = d.split('-');
    return `<text x="${x(i)}" y="${H - 6}" font-size="9" fill="var(--muted)" text-anchor="middle">${Number(dd)}/${Number(m)}</text>`;
  }).join('');

  const title = (i) => `<title>${fmt(days[i])} : ${values[i]} ${unit}${values[i] !== 1 ? 's' : ''}</title>`;
  let body;
  if (kind === 'bar') {
    const bw = Math.max(1, Math.min(18, chartW / n - 2));
    body = values.map((v, i) => `<rect x="${x(i) - bw / 2}" y="${y(v)}" width="${bw}" height="${padT + chartH - y(v)}" fill="var(--accent, #2563eb)" opacity="0.75">${title(i)}</rect>`).join('');
  } else {
    const points = values.map((v, i) => `${x(i)},${y(v)}`).join(' ');
    const area = `${padL},${padT + chartH} ${points} ${padL + chartW},${padT + chartH}`;
    const dots = n > 60 ? '' : values.map((v, i) => `<circle cx="${x(i)}" cy="${y(v)}" r="2.5" fill="var(--accent, #2563eb)">${title(i)}</circle>`).join('');
    body = `<polygon points="${area}" fill="var(--accent, #2563eb)" opacity="0.08"/>
      <polyline points="${points}" fill="none" stroke="var(--accent, #2563eb)" stroke-width="2"/>${dots}`;
  }

  wrap.innerHTML = `<svg viewBox="0 0 ${W} ${H}" style="width:100%;height:auto;background:var(--white);border:1px solid var(--border);border-radius:8px">
    ${gridLines}${body}${xLabels}</svg>`;
}

async function loadPendingSubmissions() {
  const list = document.getElementById('admin-submissions-list');
  list.innerHTML = '<div class="admin-empty">Chargement…</div>';
  try {
    const rows = await adminFetch('product_submissions?status=eq.pending&order=created_at.asc');
    adminSubmissionsCache = {};
    (rows || []).forEach(r => { adminSubmissionsCache[r.id] = r; });
    renderAdminSubmissions(rows || []);
  } catch (err) {
    list.innerHTML = `<div class="admin-empty">${err.message}</div>`;
  }
}

function renderAdminSubmissions(rows) {
  const list = document.getElementById('admin-submissions-list');
  if (!rows.length) {
    list.innerHTML = '<div class="admin-empty">Aucune soumission en attente. 🎉</div>';
    return;
  }
  list.innerHTML = rows.map(r => r.submission_type === 'company_update' ? `
    <div class="admin-card" id="admin-card-${r.id}">
      <div class="admin-card-head">
        <div>
          <div class="admin-card-title">🏢 Modification fiche entreprise · ${escapeHtml(r.company_name || '')}</div>
          <div class="admin-card-meta">Soumis par ${escapeHtml(r.submitter_name || r.submitter_email)} (${escapeHtml(r.submitter_email)}) le ${new Date(r.created_at).toLocaleDateString('fr-FR')}</div>
        </div>
      </div>
      <div class="admin-field-row"><span>Description</span><span>${escapeHtml(r.company_description || '—')}</span></div>
      <div class="admin-field-row"><span>Site web</span><span>${escapeHtml(r.company_site || '—')}</span></div>
      <div class="admin-field-row"><span>Siège</span><span>${escapeHtml(r.company_hq || '—')}</span></div>
      <div class="admin-field-row"><span>Pays</span><span>${escapeHtml(r.company_country || '—')}</span></div>
      <div class="admin-field-row"><span>Industrie</span><span>${escapeHtml(r.company_industry || '—')}</span></div>
      <div class="admin-field-row"><span>Email de contact</span><span>${escapeHtml(r.company_contact_email || '—')}</span></div>
      <div class="admin-actions">
        <button class="btn-approve" onclick="approveSubmission('${r.id}')">✓ Approuver et publier</button>
        <button class="btn-reject" onclick="rejectSubmission('${r.id}')">✕ Rejeter</button>
      </div>
    </div>` : `
    <div class="admin-card" id="admin-card-${r.id}">
      <div class="admin-card-head">
        <div>
          <div class="admin-card-title">${{new:'🆕',update:'✏️',delete:'🗑️'}[r.submission_type] || '🆕'} ${escapeHtml(r.product_name || '(produit supprimé)')} · ${escapeHtml(r.company_name || '')}</div>
          <div class="admin-card-meta">Soumis par ${escapeHtml(r.submitter_name || r.submitter_email)} (${escapeHtml(r.submitter_email)}) le ${new Date(r.created_at).toLocaleDateString('fr-FR')} ${r.submission_type !== 'new' ? ' · type: ' + escapeHtml(r.submission_type) : ''}</div>
        </div>
        ${r.product_image_url ? `<img src="${escapeHtml(r.product_image_url)}" alt="" style="width:60px;height:60px;object-fit:cover;border-radius:6px;border:1px solid var(--border);flex-shrink:0"/>` : ''}
      </div>
      <div class="admin-field-row"><span>Catégorie</span><span>${escapeHtml(r.product_category)}</span></div>
      <div class="admin-field-row"><span>Industrie</span><span>${escapeHtml(r.product_industry || r.company_industry || '—')}</span></div>
      <div class="admin-field-row"><span>Prix</span><span>${escapeHtml(r.product_price_label || '—')}</span></div>
      <div class="admin-field-row"><span>Description produit</span><span>${escapeHtml(r.product_description || '—')}</span></div>
      <div class="admin-field-row"><span>Pays / Siège</span><span>${escapeHtml(r.company_country || '—')} · ${escapeHtml(r.company_hq || '—')}</span></div>
      <div class="admin-field-row"><span>Site / Contact</span><span>${escapeHtml(r.company_site || '—')} · ${escapeHtml(r.company_contact_email || '—')}</span></div>
      <div class="admin-specs-list">
        ${(r.product_specs || []).map(s => `<div>• ${escapeHtml(s.label)} : ${escapeHtml(s.value)}</div>`).join('') || '<div>Aucune spec renseignée</div>'}
        ${(r.product_certs && r.product_certs.length) ? `<div style="margin-top:4px">Certs : ${r.product_certs.map(escapeHtml).join(', ')}</div>` : ''}
      </div>
      <div class="admin-actions">
        <button class="btn-approve" onclick="approveSubmission('${r.id}')">✓ Approuver et publier</button>
        <button class="btn-reject" onclick="rejectSubmission('${r.id}')">✕ Rejeter</button>
      </div>
    </div>`).join('');
}

async function approveSubmission(id) {
  const sub = adminSubmissionsCache[id];
  if (!sub) return;
  const card = document.getElementById(`admin-card-${id}`);
  const buttons = card.querySelectorAll('button');
  buttons.forEach(b => b.disabled = true);

  try {
    let companyId = sub.company_id || null;
    if (sub.submission_type === 'update') {
      await applyUpdateSubmission(sub);
    } else if (sub.submission_type === 'delete') {
      await applyDeleteSubmission(sub);
    } else if (sub.submission_type === 'company_update') {
      companyId = await applyCompanyUpdateSubmission(sub);
    } else {
      companyId = await applyNewSubmission(sub);
    }

    await adminFetch(`product_submissions?id=eq.${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ status: 'approved' }),
    });

    // "Votre fiche est publiée" n'a de sens que pour une toute nouvelle
    // entreprise — pas pour une mise à jour produit ou fiche entreprise.
    if (sub.submission_type === 'new' && sub.submitter_email && companyId) {
      sendTransactionalEmail('submission_approved', sub.submitter_email, {
        submitterName: sub.submitter_name || sub.submitter_email,
        companyName: sub.company_name,
        link: `https://www.buy-inner.com/pages/entreprise.html?id=${companyId}`,
      }, { token: sessionStorage.getItem('admin_access_token') });
    }

    card.remove();
    delete adminSubmissionsCache[id];
    if (!Object.keys(adminSubmissionsCache).length) {
      document.getElementById('admin-submissions-list').innerHTML = '<div class="admin-empty">Aucune soumission en attente. 🎉</div>';
    }
  } catch (err) {
    alert('Erreur lors de la publication : ' + err.message);
    buttons.forEach(b => b.disabled = false);
  }
}

// Changement du mot de passe de son propre compte — passe directement
// par l'API Auth de Supabase (PUT /auth/v1/user avec le propre token de
// la personne connectée), pas besoin de la clé service_role ni du Worker :
// cet endpoint n'autorise de toute façon qu'à modifier SON PROPRE compte.
async function adminChangePassword(event) {
  event.preventDefault();
  const pw1 = document.getElementById('admin-change-pw1');
  const pw2 = document.getElementById('admin-change-pw2');
  const errorEl = document.getElementById('admin-change-password-error');
  const successEl = document.getElementById('admin-change-password-success');
  const btn = event.target.querySelector('button[type="submit"]');
  errorEl.style.display = 'none';
  successEl.style.display = 'none';

  if (pw1.value !== pw2.value) {
    errorEl.textContent = 'Les deux mots de passe ne correspondent pas.';
    errorEl.style.display = 'block';
    return;
  }

  btn.disabled = true;
  try {
    const token = sessionStorage.getItem('admin_access_token');
    const res = await fetch(`${SUPABASE_URL}/auth/v1/user`, {
      method: 'PUT',
      headers: {
        'apikey': SUPABASE_ANON,
        'Authorization': 'Bearer ' + token,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ password: pw1.value }),
    });
    const data = await res.json().catch(() => null);
    if (!res.ok) throw new Error((data && (data.msg || data.message || data.error_description)) || `HTTP ${res.status}`);

    successEl.style.display = 'block';
    pw1.value = '';
    pw2.value = '';
  } catch (err) {
    errorEl.textContent = err.message;
    errorEl.style.display = 'block';
  } finally {
    btn.disabled = false;
  }
}

// Création d'un nouveau compte admin — voir
// cloudflare/supabase-proxy-worker.js /api/admin-create-user : le Worker
// vérifie lui-même que l'appelant est admin avant de toucher à la clé
// service_role, donc pas besoin de dupliquer cette vérification ici.
async function adminCreateUser(event) {
  event.preventDefault();
  const emailInput = document.getElementById('admin-new-email');
  const makeAdminInput = document.getElementById('admin-new-is-admin');
  const errorEl = document.getElementById('admin-create-user-error');
  const resultEl = document.getElementById('admin-create-user-result');
  const btn = event.target.querySelector('button[type="submit"]');
  errorEl.style.display = 'none';
  resultEl.style.display = 'none';
  btn.disabled = true;

  try {
    const token = sessionStorage.getItem('admin_access_token');
    const res = await fetch(`${SUPABASE_URL}/admin-create-user`, {
      method: 'POST',
      headers: { 'Authorization': 'Bearer ' + token, 'Content-Type': 'application/json' },
      body: JSON.stringify({
        newEmail: emailInput.value.trim(),
        makeAdmin: makeAdminInput.checked,
      }),
    });
    const data = await res.json().catch(() => null);
    if (!res.ok) throw new Error((data && data.error) || `HTTP ${res.status}`);

    resultEl.style.display = 'block';
    resultEl.innerHTML = `
      <p style="margin:0 0 6px"><strong>Compte créé${data.isAdmin ? ' (administrateur)' : ''} :</strong> ${escapeHtml(data.email)}</p>
      <p style="margin:0">Mot de passe temporaire (à transmettre toi-même — il ne sera plus jamais affiché) :</p>
      <code style="display:block;margin-top:6px;padding:8px;background:var(--white);border:1px solid var(--border);border-radius:4px;font-size:13px;word-break:break-all">${escapeHtml(data.tempPassword)}</code>`;
    emailInput.value = '';
    makeAdminInput.checked = false;
  } catch (err) {
    errorEl.textContent = err.message;
    errorEl.style.display = 'block';
  } finally {
    btn.disabled = false;
  }
}

// ── Utilisateurs : création, mot de passe, désactivation, suppression ──
// Tout passe par le Worker (/api/admin-users, réservé aux admins) : la clé
// service_role n'est jamais côté navigateur, et AUCUN mot de passe ne transite
// par l'admin — la personne le choisit via pages/nouveau-mot-de-passe.html.
let adminUsersCache = [];
let adminUsersLoaded = false;
let adminCompanySearchTimer = null;

async function adminUsersCall(body) {
  const token = sessionStorage.getItem('admin_access_token');
  const res = await fetch(`${SUPABASE_URL}/admin-users`, {
    method: 'POST',
    headers: { 'Authorization': 'Bearer ' + token, 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });
  const data = await res.json().catch(() => null);
  if (!res.ok) { const e = new Error((data && data.error) || `HTTP ${res.status}`); e.code = data && data.code; throw e; }
  return data;
}

async function loadAdminUsers() {
  const list = document.getElementById('admin-users-list');
  if (!list) return;
  list.innerHTML = '<div class="admin-empty">Chargement…</div>';
  try {
    const data = await adminUsersCall({ action: 'list' });
    adminUsersCache = (data.users || []).sort((a, b) => String(b.created_at).localeCompare(String(a.created_at)));
    adminUsersLoaded = true;
    renderAdminUsers();
  } catch (err) {
    list.innerHTML = `<div class="admin-empty" style="color:#C0392B">${escapeHtml(err.message)}</div>`;
  }
  loadAdminAuditLog();
}

async function loadAdminAuditLog() {
  const box = document.getElementById('admin-users-audit');
  if (!box) return;
  try {
    const rows = await adminFetch('admin_audit_log?select=created_at,admin_email,action,target_email,details&order=created_at.desc&limit=15');
    const labels = { create_user: 'a créé le compte', delete_user: 'a supprimé le compte', disable_user: 'a désactivé le compte', enable_user: 'a réactivé le compte', reset_password_link: 'a généré un lien de mot de passe pour', attach_company: 'a rattaché à une entreprise' };
    box.innerHTML = !rows || !rows.length
      ? '<div class="admin-empty">Aucune action enregistrée.</div>'
      : rows.map(r => `<div class="admin-field-row" style="font-size:12px"><span>${escapeHtml(new Date(r.created_at).toLocaleString('fr-FR'))} · <strong>${escapeHtml(r.admin_email)}</strong> ${escapeHtml(labels[r.action] || r.action)} ${escapeHtml(r.target_email || '')}</span></div>`).join('');
  } catch (err) {
    box.innerHTML = '<div class="admin-empty">Journal indisponible (exécute backend/supabase_admin_user_management_2026_10.sql).</div>';
  }
}

function adminUserPills(u) {
  const pills = [];
  if (u.is_admin) pills.push('<span class="sup-pill sup-pill-ok" style="font-size:10px">Admin</span>');
  if (u.disabled) pills.push('<span class="sup-pill sup-pill-no" style="font-size:10px">Désactivé</span>');
  if (!u.confirmed) pills.push('<span class="sup-pill sup-pill-pending" style="font-size:10px">Email non confirmé</span>');
  return pills.join(' ');
}

function renderAdminUsers() {
  const list = document.getElementById('admin-users-list');
  if (!list) return;
  const q = ((document.getElementById('admin-users-search') || {}).value || '').trim().toLowerCase();
  const rows = adminUsersCache.filter(u => !q || (u.email || '').toLowerCase().includes(q) ||
    u.companies.some(c => (c.name || '').toLowerCase().includes(q)));
  if (!rows.length) { list.innerHTML = '<div class="admin-empty">Aucun compte.</div>'; return; }
  const fmt = d => d ? new Date(d).toLocaleDateString('fr-FR') : '—';
  list.innerHTML = `<p style="font-size:11px;color:var(--muted);margin:0 0 8px">${rows.length} compte${rows.length > 1 ? 's' : ''}${rows.length > 100 ? ' (100 premiers affichés, affine la recherche)' : ''}</p>` +
    rows.slice(0, 100).map(u => {
      const co = u.companies.map(c => `${escapeHtml(c.name)} <em style="color:var(--muted)">(${c.role === 'owner' ? 'admin' : 'collaborateur'})</em>`).join(', ');
      const locked = u.is_admin;
      const e = escapeJsAttr(u.email);
      return `
      <div id="admin-user-${u.id}" style="display:flex;flex-wrap:wrap;gap:8px 14px;align-items:flex-start;padding:14px 0;border-bottom:1px solid var(--border)">
        <div style="flex:1 1 280px;min-width:0">
          <div style="font-size:13px;font-weight:600;word-break:break-all;margin-bottom:3px">${escapeHtml(u.email)} ${adminUserPills(u)}</div>
          <div style="font-size:12px;color:var(--muted)">${co || 'Aucune entreprise'} · créé le ${fmt(u.created_at)} · dernière connexion ${fmt(u.last_sign_in_at)}</div>
          <div id="admin-user-panel-${u.id}" style="display:none;margin-top:10px"></div>
        </div>
        <div style="display:flex;gap:6px;flex-wrap:wrap;align-items:center">
          ${locked ? '<span style="font-size:11px;color:var(--muted)">Compte admin protégé</span>' : `
          <button class="btn-add-product sup-btn-sm" onclick="adminUserShowPasswordPanel('${u.id}','${e}')">Mot de passe</button>
          <button class="btn-add-product sup-btn-sm" onclick="adminUserAttachPrompt('${u.id}','${e}')">Entreprise</button>
          <button class="btn-remove-product" onclick="adminUserToggleDisabled('${u.id}','${e}',${u.disabled ? 'false' : 'true'})">${u.disabled ? 'Réactiver' : 'Désactiver'}</button>
          <button class="btn-remove-product" onclick="adminUserDelete('${u.id}','${e}')">Supprimer</button>`}
        </div>
      </div>`;
    }).join('');
}

// Lien affiché à l'admin : à copier pour transmettre toi-même, ou déjà envoyé par email.
function adminUserLinkBox(data, intro) {
  const sent = data.emailSent ? `<p style="margin:0 0 8px;color:#2D6A4F">✓ Email envoyé à ${escapeHtml(data.email)}.</p>` : (data.emailError ? `<p style="margin:0 0 8px;color:#C0392B">Email non envoyé : ${escapeHtml(data.emailError)}. Utilise le lien ci-dessous.</p>` : '');
  return `<div style="padding:12px;background:var(--paper);border:1px solid var(--border);border-radius:6px;font-size:12px">
    <p style="margin:0 0 8px"><strong>${escapeHtml(intro)}</strong></p>${sent}
    <p style="margin:0 0 6px;color:var(--muted)">Lien pour définir le mot de passe (personnel, valable peu de temps — à ne partager qu'avec la personne concernée) :</p>
    <input type="text" readonly value="${escapeHtml(data.setupLink)}" onclick="this.select()" style="width:100%;font-size:11px;padding:6px;border:1px solid var(--border);border-radius:4px;font-family:var(--mono)"/>
    <button type="button" class="btn-add-product sup-btn-sm" style="margin-top:8px" onclick="navigator.clipboard.writeText('${escapeJsAttr(data.setupLink)}').then(() => { this.textContent = 'Copié ✓'; })">Copier le lien</button>
  </div>`;
}

function adminUserSearchCompanyDebounced() {
  clearTimeout(adminCompanySearchTimer);
  adminCompanySearchTimer = setTimeout(adminUserSearchCompany, 250);
}

async function adminUserSearchCompany() {
  const q = document.getElementById('admin-user-company-q').value.trim();
  const sel = document.getElementById('admin-user-company');
  if (q.length < 2) { sel.style.display = 'none'; sel.innerHTML = ''; return; }
  try {
    const rows = await adminFetch(`companies?name=ilike.*${encodeURIComponent(q)}*&select=id,name&order=name&limit=15`);
    sel.innerHTML = (rows || []).map(c => `<option value="${c.id}">${escapeHtml(c.name)}</option>`).join('') || '<option value="">Aucune entreprise trouvée</option>';
    sel.style.display = 'block';
  } catch (err) {
    sel.style.display = 'none';
  }
}

async function adminUserCreate(event) {
  event.preventDefault();
  const errEl = document.getElementById('admin-user-create-error');
  const resEl = document.getElementById('admin-user-create-result');
  const btn = event.target.querySelector('button[type="submit"]');
  errEl.style.display = 'none'; resEl.style.display = 'none';
  const sel = document.getElementById('admin-user-company');
  const companyId = sel.style.display !== 'none' ? sel.value : '';
  btn.disabled = true;
  try {
    const data = await adminUsersCall({
      action: 'create',
      email: document.getElementById('admin-user-email').value.trim(),
      companyId: companyId || undefined,
      role: document.getElementById('admin-user-role').value,
      lang: document.getElementById('admin-user-lang').value,
      sendEmail: document.getElementById('admin-user-send').checked,
    });
    resEl.style.display = 'block';
    resEl.innerHTML = adminUserLinkBox(data, `Compte créé : ${data.email}`);
    document.getElementById('admin-user-email').value = '';
    await loadAdminUsers();
  } catch (err) {
    errEl.textContent = err.message;
    errEl.style.display = 'block';
  } finally {
    btn.disabled = false;
  }
}

function adminUserShowPasswordPanel(id, email) {
  const panel = document.getElementById(`admin-user-panel-${id}`);
  if (!panel) return;
  if (panel.style.display === 'block') { panel.style.display = 'none'; return; }
  panel.style.display = 'block';
  panel.innerHTML = `<div style="padding:12px;background:var(--paper);border:1px solid var(--border);border-radius:6px;font-size:12px">
    <p style="margin:0 0 8px">Nouveau mot de passe pour <strong>${escapeHtml(email)}</strong> : un lien est généré, la personne choisit elle-même son mot de passe.</p>
    <button type="button" class="btn-approve sup-btn-sm" onclick="adminUserResetLink('${id}', true)">Envoyer par email</button>
    <button type="button" class="btn-add-product sup-btn-sm" onclick="adminUserResetLink('${id}', false)">Afficher le lien</button>
    <div id="admin-user-link-${id}" style="margin-top:10px"></div>
  </div>`;
}

async function adminUserResetLink(id, sendEmail) {
  const out = document.getElementById(`admin-user-link-${id}`);
  out.innerHTML = '<span style="color:var(--muted)">Génération…</span>';
  try {
    const data = await adminUsersCall({ action: 'reset_link', userId: id, sendEmail, lang: 'fr' });
    out.innerHTML = adminUserLinkBox(data, 'Lien généré');
    loadAdminAuditLog();
  } catch (err) {
    out.innerHTML = `<span style="color:#C0392B">${escapeHtml(err.message)}</span>`;
  }
}

async function adminUserToggleDisabled(id, email, disabled) {
  const msg = disabled
    ? `Désactiver ${email} ? La personne ne pourra plus se connecter (ses données sont conservées, tu peux réactiver à tout moment).`
    : `Réactiver ${email} ?`;
  if (!confirm(msg)) return;
  try {
    await adminUsersCall({ action: 'set_disabled', userId: id, disabled });
    await loadAdminUsers();
  } catch (err) { alert('Erreur : ' + err.message); }
}

async function adminUserDelete(id, email) {
  const typed = prompt(`Supprimer définitivement le compte ${email} ?\n\nLa personne perd son accès, et l'entreprise redevient sans administrateur. Pour confirmer, retape l'adresse email du compte :`);
  if (typed === null) return;
  try {
    await adminUsersCall({ action: 'delete', userId: id, confirmEmail: typed });
    await loadAdminUsers();
  } catch (err) {
    alert(err.code === 'HAS_RFQ_DATA' ? err.message + '\n\nUtilise « Désactiver » à la place.' : 'Erreur : ' + err.message);
  }
}

async function adminUserAttachPrompt(id, email) {
  const q = prompt(`Rattacher ${email} à quelle entreprise ?\nTape le début de son nom :`);
  if (!q || q.trim().length < 2) return;
  try {
    const rows = await adminFetch(`companies?name=ilike.*${encodeURIComponent(q.trim())}*&select=id,name&order=name&limit=9`);
    if (!rows || !rows.length) { alert('Aucune entreprise trouvée.'); return; }
    let company = rows[0];
    if (rows.length > 1) {
      const pick = prompt('Plusieurs entreprises trouvées, tape le numéro :\n' + rows.map((c, i) => `${i + 1}. ${c.name}`).join('\n'));
      company = rows[Number(pick) - 1];
      if (!company) return;
    }
    const asOwner = confirm(`Rattacher ${email} à « ${company.name} ».\n\nOK = administrateur de l'entreprise (gère l'équipe)\nAnnuler = collaborateur`);
    await adminUsersCall({ action: 'attach_company', userId: id, companyId: company.id, role: asOwner ? 'owner' : 'member' });
    await loadAdminUsers();
  } catch (err) { alert('Erreur : ' + err.message); }
}

async function applyDeleteSubmission(sub) {
  const productId = sub.target_product_id;
  if (!productId) return;
  await adminFetch(`product_specs?product_id=eq.${productId}`, { method: 'DELETE' });
  await adminFetch(`product_certs?product_id=eq.${productId}`, { method: 'DELETE' });
  await adminFetch(`product_bars?product_id=eq.${productId}`, { method: 'DELETE' });
  await adminFetch(`products?id=eq.${productId}`, { method: 'DELETE' });
}

async function applyUpdateSubmission(sub) {
  const productId = sub.target_product_id;
  if (!productId) return;
  await adminFetch(`products?id=eq.${productId}`, {
    method: 'PATCH',
    body: JSON.stringify({
      name: sub.product_name,
      category: sub.product_category,
      industry: sub.product_industry || sub.company_industry,
      description: sub.product_description,
      price_label: sub.product_price_label || 'Sur devis',
      image_url: sub.product_image_url || null,
    }),
  });
  await adminFetch(`product_specs?product_id=eq.${productId}`, { method: 'DELETE' });
  await adminFetch(`product_certs?product_id=eq.${productId}`, { method: 'DELETE' });
  if (sub.product_specs && sub.product_specs.length) {
    await adminFetch('product_specs', {
      method: 'POST',
      body: JSON.stringify(sub.product_specs.map((s, i) => ({
        product_id: productId, label: s.label, value: s.value, sort_order: i + 1, is_premium: i >= 3,
      }))),
    });
  }
  if (sub.product_certs && sub.product_certs.length) {
    await adminFetch('product_certs', {
      method: 'POST',
      body: JSON.stringify(sub.product_certs.map(c => ({ product_id: productId, cert_name: c }))),
    });
  }
}

async function applyCompanyUpdateSubmission(sub) {
  const companyId = sub.company_id;
  if (!companyId) return null;
  await adminFetch(`companies?id=eq.${companyId}`, {
    method: 'PATCH',
    body: JSON.stringify({
      description: sub.company_description,
      site: sub.company_site,
      hq: sub.company_hq,
      country: sub.company_country,
      industry: sub.company_industry,
      contact_email: sub.company_contact_email,
    }),
  });
  return companyId;
}

async function applyNewSubmission(sub) {
    // 1. Entreprise existante ou nouvelle
    let companyId;
    const existing = await adminFetch(`companies?select=id&name=eq.${encodeURIComponent(sub.company_name)}&limit=1`);
    if (existing && existing.length) {
      companyId = existing[0].id;
    } else {
      const created = await adminFetch('companies', {
        method: 'POST',
        headers: { 'Prefer': 'return=representation' },
        body: JSON.stringify([{
          name: sub.company_name,
          country: sub.company_country,
          hq: sub.company_hq,
          industry: sub.company_industry || sub.product_industry,
          site: sub.company_site,
          logo: '🏭',
          description: sub.company_description,
          verified: false,
          premium: false,
          claimed: true,
          employees: null,
          founded: null,
          contact_email: sub.company_contact_email,
        }]),
      });
      companyId = created[0].id;
    }

    // 2. Produit
    const createdProduct = await adminFetch('products', {
      method: 'POST',
      headers: { 'Prefer': 'return=representation' },
      body: JSON.stringify([{
        company_id: companyId,
        name: sub.product_name,
        category: sub.product_category,
        industry: sub.product_industry || sub.company_industry,
        description: sub.product_description,
        price_label: sub.product_price_label || 'Sur devis',
        icon: '🔧',
        image_url: sub.product_image_url || null,
      }]),
    });
    const productId = createdProduct[0].id;

    // 3. Specs
    if (sub.product_specs && sub.product_specs.length) {
      await adminFetch('product_specs', {
        method: 'POST',
        body: JSON.stringify(sub.product_specs.map((s, i) => ({
          product_id: productId, label: s.label, value: s.value, sort_order: i + 1, is_premium: i >= 3,
        }))),
      });
    }

    // 4. Certifications
    if (sub.product_certs && sub.product_certs.length) {
      await adminFetch('product_certs', {
        method: 'POST',
        body: JSON.stringify(sub.product_certs.map(c => ({ product_id: productId, cert_name: c }))),
      });
    }

    // 5. Catégorie produit rattachée à l'entreprise (pour les filtres annuaire)
    await adminFetch('company_product_categories', {
      method: 'POST',
      body: JSON.stringify([{ company_id: companyId, category: sub.product_category }]),
    });

    return companyId;
}

async function rejectSubmission(id) {
  const card = document.getElementById(`admin-card-${id}`);
  card.querySelectorAll('button').forEach(b => b.disabled = true);
  try {
    await adminFetch(`product_submissions?id=eq.${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ status: 'rejected' }),
    });
    card.remove();
    delete adminSubmissionsCache[id];
    if (!Object.keys(adminSubmissionsCache).length) {
      document.getElementById('admin-submissions-list').innerHTML = '<div class="admin-empty">Aucune soumission en attente. 🎉</div>';
    }
  } catch (err) {
    alert('Erreur : ' + err.message);
    card.querySelectorAll('button').forEach(b => b.disabled = false);
  }
}

let adminClaimsCache = {};

async function loadPendingClaims() {
  const list = document.getElementById('admin-claims-list');
  list.innerHTML = '<div class="admin-empty">Chargement…</div>';
  try {
    const rows = await adminFetch('company_claims?status=eq.pending&select=*,companies(name)&order=created_at.asc');
    adminClaimsCache = {};
    (rows || []).forEach(r => { adminClaimsCache[r.id] = r; });
    renderAdminClaims(rows || []);
  } catch (err) {
    list.innerHTML = `<div class="admin-empty">${err.message}</div>`;
  }
}

function renderAdminClaims(rows) {
  const list = document.getElementById('admin-claims-list');
  if (!rows.length) {
    list.innerHTML = '<div class="admin-empty">Aucune revendication en attente.</div>';
    return;
  }
  list.innerHTML = rows.map(r => `
    <div class="admin-card" id="admin-claim-${r.id}">
      <div class="admin-card-head">
        <div>
          <div class="admin-card-title">${escapeHtml((r.companies && r.companies.name) || 'Entreprise inconnue')}</div>
          <div class="admin-card-meta">Demandée par ${escapeHtml(r.user_email)} le ${new Date(r.created_at).toLocaleDateString('fr-FR')}</div>
        </div>
      </div>
      <div class="admin-actions">
        <button class="btn-approve" onclick="approveClaim('${r.id}')">✓ Approuver la revendication</button>
        <button class="btn-reject" onclick="rejectClaim('${r.id}')">✕ Rejeter</button>
      </div>
    </div>`).join('');
}

async function approveClaim(id) {
  const claim = adminClaimsCache[id];
  if (!claim) return;
  const card = document.getElementById(`admin-claim-${id}`);
  card.querySelectorAll('button').forEach(b => b.disabled = true);
  try {
    // Entreprise déjà revendiquée : on rattache ce compte comme membre de
    // l'équipe (company_members) au lieu d'écraser le propriétaire existant.
    // Sinon (première revendication), le trigger de la base crée le 'owner'.
    const current = await adminFetch(`companies?id=eq.${claim.company_id}&select=claimed_by_user_id`);
    if (current && current[0] && current[0].claimed_by_user_id && current[0].claimed_by_user_id !== claim.user_id) {
      await adminFetch('company_members?on_conflict=company_id,user_id', {
        method: 'POST',
        headers: { 'Prefer': 'resolution=ignore-duplicates,return=minimal' },
        body: JSON.stringify([{ company_id: claim.company_id, user_id: claim.user_id, role: 'member' }]),
      });
    } else {
      await adminFetch(`companies?id=eq.${claim.company_id}`, {
        method: 'PATCH',
        body: JSON.stringify({ claimed_by_user_id: claim.user_id }),
      });
    }
    await adminFetch(`company_claims?id=eq.${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ status: 'approved' }),
    });

    if (claim.user_email) {
      sendTransactionalEmail('claim_approved', claim.user_email, {
        companyName: (claim.companies && claim.companies.name) || 'votre entreprise',
        link: `https://www.buy-inner.com/pages/supplier.html`,
      }, { token: sessionStorage.getItem('admin_access_token') });
    }

    card.remove();
    delete adminClaimsCache[id];
    if (!Object.keys(adminClaimsCache).length) {
      document.getElementById('admin-claims-list').innerHTML = '<div class="admin-empty">Aucune revendication en attente.</div>';
    }
  } catch (err) {
    alert('Erreur : ' + err.message);
    card.querySelectorAll('button').forEach(b => b.disabled = false);
  }
}

async function rejectClaim(id) {
  const card = document.getElementById(`admin-claim-${id}`);
  card.querySelectorAll('button').forEach(b => b.disabled = true);
  try {
    await adminFetch(`company_claims?id=eq.${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ status: 'rejected' }),
    });
    card.remove();
    delete adminClaimsCache[id];
    if (!Object.keys(adminClaimsCache).length) {
      document.getElementById('admin-claims-list').innerHTML = '<div class="admin-empty">Aucune revendication en attente.</div>';
    }
  } catch (err) {
    alert('Erreur : ' + err.message);
    card.querySelectorAll('button').forEach(b => b.disabled = false);
  }
}

// ── Modération des dossiers RFQ/RFI/RFP (voir
// backend/supabase_add_rfq_system_2026_09.sql) -- même schéma que les
// revendications ci-dessus : liste "pending", approuver bascule le
// statut à 'published' (visible des fournisseurs via get_rfq_dossiers_page),
// rejeter enregistre un motif affiché au systémier dans son dashboard.
let adminRfqCache = {};

async function loadPendingRfqDossiers() {
  const list = document.getElementById('admin-rfq-list');
  if (!list) return;
  list.innerHTML = '<div class="admin-empty">Chargement…</div>';
  try {
    const rows = await adminFetch('rfq_dossiers?status=eq.pending&select=*,companies(name)&order=created_at.asc');
    adminRfqCache = {};
    (rows || []).forEach(r => { adminRfqCache[r.id] = r; });
    renderAdminRfqDossiers(rows || []);
  } catch (err) {
    list.innerHTML = `<div class="admin-empty">${err.message}</div>`;
  }
}

function renderAdminRfqDossiers(rows) {
  const list = document.getElementById('admin-rfq-list');
  if (!rows.length) {
    list.innerHTML = '<div class="admin-empty">Aucun dossier RFQ en attente.</div>';
    return;
  }
  list.innerHTML = rows.map(r => `
    <div class="admin-card" id="admin-rfq-${r.id}">
      <div class="admin-card-head">
        <div>
          <div class="admin-card-title">${escapeHtml(r.rfq_type)} — ${escapeHtml(r.title)}${r.requires_custom_nda ? ' 🔒 NDA personnalisé' : ''}</div>
          <div class="admin-card-meta">${escapeHtml((r.companies && r.companies.name) || 'Entreprise inconnue')} · ${escapeHtml(r.category || '—')} · déposé le ${new Date(r.created_at).toLocaleDateString('fr-FR')}${r.deadline ? ' · réponses avant le ' + new Date(r.deadline).toLocaleDateString('fr-FR') : ''}</div>
        </div>
      </div>
      <p style="font-size:12px;color:var(--muted);white-space:pre-wrap;margin:8px 0">${escapeHtml(r.description)}</p>
      ${r.attachment_path ? `<button type="button" class="btn-approve" style="margin-bottom:8px" onclick="downloadRfqAttachmentAdmin('${escapeJsAttr(r.attachment_path)}','${escapeJsAttr(r.attachment_path.split('/').pop())}')">📄 Télécharger la pièce jointe</button>` : ''}
      ${r.custom_nda_template_path ? `<button type="button" class="btn-approve" style="margin-bottom:8px;margin-left:8px" onclick="downloadRfqAttachmentAdmin('${escapeJsAttr(r.custom_nda_template_path)}','${escapeJsAttr(r.custom_nda_template_path.split('/').pop())}')">📄 Télécharger le gabarit NDA</button>` : ''}
      <div class="admin-actions">
        <button class="btn-approve" onclick="approveRfqDossier('${r.id}')">✓ Publier</button>
        <button class="btn-reject" onclick="rejectRfqDossier('${r.id}')">✕ Rejeter</button>
      </div>
    </div>`).join('');
}

// Bucket privé (voir backend/supabase_add_rfq_system_2026_09.sql
// SECTION 6) -- l'admin y a accès via sa propre policy storage
// (is_admin()), même principe de téléchargement authentifié que
// js/pages/rfq.js downloadRfqAttachment côté fournisseur.
async function downloadRfqAttachmentAdmin(path, filename) {
  try {
    const token = sessionStorage.getItem('admin_access_token');
    const res = await fetch(`${SUPABASE_URL}/storage/v1/object/rfq-attachments/${path}`, {
      headers: { 'apikey': SUPABASE_ANON, 'Authorization': 'Bearer ' + token },
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const blob = await res.blob();
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url; a.download = filename;
    document.body.appendChild(a); a.click(); a.remove();
    URL.revokeObjectURL(url);
  } catch (err) {
    alert('Impossible de télécharger le fichier : ' + err.message);
  }
}

async function approveRfqDossier(id) {
  const card = document.getElementById(`admin-rfq-${id}`);
  card.querySelectorAll('button').forEach(b => b.disabled = true);
  try {
    await adminFetch(`rfq_dossiers?id=eq.${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ status: 'published' }),
    });
    card.remove();
    delete adminRfqCache[id];
    if (!Object.keys(adminRfqCache).length) {
      document.getElementById('admin-rfq-list').innerHTML = '<div class="admin-empty">Aucun dossier RFQ en attente.</div>';
    }
  } catch (err) {
    alert('Erreur : ' + err.message);
    card.querySelectorAll('button').forEach(b => b.disabled = false);
  }
}

async function rejectRfqDossier(id) {
  const reason = prompt('Motif du refus (affiché au systémier) :') || null;
  const card = document.getElementById(`admin-rfq-${id}`);
  card.querySelectorAll('button').forEach(b => b.disabled = true);
  try {
    await adminFetch(`rfq_dossiers?id=eq.${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ status: 'rejected', rejection_reason: reason }),
    });
    card.remove();
    delete adminRfqCache[id];
    if (!Object.keys(adminRfqCache).length) {
      document.getElementById('admin-rfq-list').innerHTML = '<div class="admin-empty">Aucun dossier RFQ en attente.</div>';
    }
  } catch (err) {
    alert('Erreur : ' + err.message);
    card.querySelectorAll('button').forEach(b => b.disabled = false);
  }
}

