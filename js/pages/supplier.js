// ═══════════════════════════════
// ESPACE FOURNISSEUR (compte, revendication, tableau de bord)
// Toute modification passe par product_submissions — jamais d'écriture
// directe — et la revendication est toujours validée à la main par l'admin.
// ═══════════════════════════════
let supplierCompany = null; // entreprise revendiquée (si déjà approuvée)
let supplierEditingProductId = null; // null = ajout, sinon id du produit en cours d'édition
let supStatProducts = null, supStatPending = null, supStatApproved = null, supStatLeadsPending = null; // compteurs du bandeau
let supplierViewRows = []; // vues produit (entity_views), stats premium -- voir loadSupplierViews()
let supplierAllProducts = []; // catalogue complet (mapProduct), pour la comparaison concurrentielle premium

// Plages du sélecteur temporel des stats de vues (même liste que
// js/pages/admin.js ANALYTICS_RANGES, pour une expérience cohérente).
const SUPPLIER_VIEW_RANGES = {
  1: '1 jour', 7: '1 semaine', 30: '1 mois', 90: '3 mois', 180: '6 mois', 365: '1 an',
};

document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  tryRestoreSupplierSession();
});

// Met en surbrillance l'étape courante du parcours (1 Compte, 2 Revendiquer,
// 3 Publier) — n'a de sens que pendant l'onboarding : une fois le dashboard
// atteint (étape 3), le stepper n'apporte plus rien en permanence, on le masque.
function setSupplierStep(step) {
  const el = document.getElementById('sup-steps');
  if (!el) return;
  el.setAttribute('data-step', step);
  el.style.display = step >= 3 ? 'none' : '';
}

// Bandeau de stats du tableau de bord (valeurs réelles calculées côté client).
// "Leads à traiter" en premier : c'est le plus actionnable/urgent des 4 —
// distinct des soumissions produit ("Soumissions...") pour éviter toute
// confusion entre les deux notions de "demande" sur la même page.
function renderSupplierStats() {
  const el = document.getElementById('sup-stats');
  if (!el) return;
  const fmt = v => (v === null ? '—' : v);
  el.innerHTML = `
    <div class="sup-stat"><span class="sup-stat-n ${supStatLeadsPending ? 'sup-stat-pending' : ''}">${fmt(supStatLeadsPending)}</span><span class="sup-stat-l">Leads à traiter</span></div>
    <div class="sup-stat"><span class="sup-stat-n">${fmt(supStatProducts)}</span><span class="sup-stat-l">Produits publiés</span></div>
    <div class="sup-stat"><span class="sup-stat-n sup-stat-pending">${fmt(supStatPending)}</span><span class="sup-stat-l">Soumissions en attente</span></div>
    <div class="sup-stat"><span class="sup-stat-n sup-stat-ok">${fmt(supStatApproved)}</span><span class="sup-stat-l">Soumissions approuvées</span></div>`;
}

// Bandeau Premium : bouton d'abonnement, ou confirmation si déjà actif.
// L'activation réelle se fait côté Worker (/api/create-checkout-session
// + /api/stripe-webhook), jamais en écrivant premium=true depuis le
// client — voir cloudflare/supabase-proxy-worker.js.
function renderPremiumBox() {
  const el = document.getElementById('sup-premium-box');
  if (!el || !supplierCompany) return;
  if (supplierCompany.premium) {
    el.innerHTML = `<div class="sup-premium-active">★ Votre entreprise est <strong>Premium</strong> — badge et mise en avant prioritaire actifs.</div>`;
  } else {
    el.innerHTML = `
      <div class="sup-premium-upsell">
        <span>Passez Premium pour le badge ★, la mise en avant prioritaire et le profil enrichi — 1 500 €/an, résiliable à tout moment.</span>
        <button id="sup-premium-btn" class="btn-add-product" onclick="startPremiumCheckout()">★ Passer Premium — 1 500 €/an</button>
      </div>`;
  }
}

async function startPremiumCheckout() {
  if (!supplierCompany) return;
  const btn = document.getElementById('sup-premium-btn');
  if (btn) { btn.disabled = true; btn.textContent = 'Redirection…'; }
  try {
    const res = await fetch(`${SUPABASE_URL}/create-checkout-session`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        companyId: supplierCompany.id,
        companyName: supplierCompany.name,
        email: sessionStorage.getItem('sup_email'),
      }),
    });
    const data = await res.json();
    if (!res.ok || !data.url) throw new Error(data.error || 'Erreur lors de la création du paiement.');
    window.location.href = data.url;
  } catch (err) {
    alert('Erreur : ' + err.message);
    if (btn) { btn.disabled = false; btn.textContent = '★ Passer Premium — 1 500 €/an'; }
  }
}

// Après retour depuis Stripe Checkout (success_url/cancel_url) : le
// webhook a normalement déjà traité l'événement, mais on relit quand
// même la fiche pour refléter le vrai statut sans attendre un reload.
async function handlePremiumReturn() {
  const status = new URLSearchParams(window.location.search).get('premium');
  if (!status) return;
  history.replaceState(null, '', window.location.pathname);
  if (status === 'cancelled') return;
  if (status === 'success') {
    const banner = document.getElementById('sup-premium-box');
    if (banner) banner.innerHTML = `<div class="sup-premium-active">Paiement reçu, activation en cours…</div>`;
    try {
      const rows = await supplierFetch(`companies?id=eq.${supplierCompany.id}&select=*`);
      if (rows && rows.length) supplierCompany = rows[0];
    } catch { /* le webhook peut avoir une seconde de retard, pas grave */ }
    renderPremiumBox();
  }
}

// Modification de la fiche entreprise — comme les produits, ça passe par
// product_submissions (submission_type: 'company_update') et validation
// admin, jamais d'écriture directe. Voir js/pages/admin.js pour le
// traitement côté validation (applyCompanyUpdateSubmission).
function openCompanyEditForm() {
  const wrap = document.getElementById('sup-company-form-wrap');
  if (!wrap || !supplierCompany) return;
  const c = supplierCompany;
  const esc = v => (v || '').replace(/"/g, '&quot;');
  wrap.style.display = 'block';
  wrap.innerHTML = `
    <div class="sup-panel">
      <div class="submit-section-title">Modifier la fiche entreprise</div>
      <p style="font-size:12px;color:var(--muted);margin:-8px 0 14px">Comme pour les produits, la modification est soumise à validation avant d'être publiée.</p>
      <form onsubmit="submitCompanyEditForm(event)">
        <div class="lead-field"><label>Description</label><textarea id="sup-c-desc" rows="3">${c.desc || ''}</textarea></div>
        <div class="lead-field"><label>Site web</label><input type="url" id="sup-c-site" value="${esc(c.site !== '#' ? c.site : '')}" placeholder="https://…"/></div>
        <div class="lead-field"><label>Siège (ville)</label><input type="text" id="sup-c-hq" value="${esc(c.hq)}"/></div>
        <div class="lead-field"><label>Pays</label><input type="text" id="sup-c-country" value="${esc(c.country)}"/></div>
        <div class="lead-field"><label>Industrie</label><input type="text" id="sup-c-industry" value="${esc(c.industry)}"/></div>
        <div class="lead-field"><label>Email de contact</label><input type="email" id="sup-c-contact" value="${esc(c.contact)}"/></div>
        <div class="submit-actions">
          <button type="submit" class="btn-submit-form">Envoyer pour validation</button>
          <button type="button" class="btn-remove-product" onclick="document.getElementById('sup-company-form-wrap').style.display='none'">Annuler</button>
        </div>
      </form>`;
}

async function submitCompanyEditForm(e) {
  e.preventDefault();
  try {
    await supplierFetch('product_submissions', {
      method: 'POST',
      headers: { 'Prefer': 'return=minimal' },
      body: JSON.stringify([{
        submission_type: 'company_update',
        company_id: supplierCompany.id,
        submitter_user_id: sessionStorage.getItem('sup_user_id'),
        submitter_name: supplierCompany.name,
        submitter_email: sessionStorage.getItem('sup_email'),
        company_name: supplierCompany.name,
        company_description: document.getElementById('sup-c-desc').value || null,
        company_site: document.getElementById('sup-c-site').value || null,
        company_hq: document.getElementById('sup-c-hq').value || null,
        company_country: document.getElementById('sup-c-country').value || null,
        company_industry: document.getElementById('sup-c-industry').value || null,
        company_contact_email: document.getElementById('sup-c-contact').value || null,
        product_name: 'Fiche entreprise',
        product_category: '—',
      }]),
    });
    document.getElementById('sup-company-form-wrap').style.display = 'none';
    alert('Demande envoyée, en attente de validation admin.');
    loadSupplierSubmissions();
  } catch (err) {
    alert('Erreur : ' + err.message);
  }
}

async function supplierFetch(path, options = {}) {
  const token = sessionStorage.getItem('sup_access_token');
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
    supplierLogout();
    throw new Error('Session expirée ou accès refusé, reconnecte-toi.');
  }
  if (!res.ok) throw new Error(`HTTP ${res.status} sur ${path}`);
  if (res.status === 204) return null;
  return res.json().catch(() => null);
}

// PostgREST plafonne les lectures directes à 50 lignes par requête
// (db-max-rows, voir backend/supabase_lock_base_tables.sql) -- même
// correctif que adminFetchAllPages (js/pages/admin.js), nécessaire dès
// qu'un fournisseur premium dépasse 50 vues enregistrées.
async function supplierFetchAllPages(path) {
  let all = [];
  let offset = 0;
  while (true) {
    const sep = path.includes('?') ? '&' : '?';
    const page = await supplierFetch(`${path}${sep}offset=${offset}`);
    if (!page || !page.length) break;
    all = all.concat(page);
    if (page.length < 50) break;
    offset += page.length;
  }
  return all;
}

function showSupplierMessage(msg, isError) {
  const box = document.getElementById('sup-auth-message');
  box.textContent = msg;
  box.style.color = isError ? '#C0392B' : 'var(--steel)';
  box.style.display = 'block';
}

async function supplierSignup(e) {
  e.preventDefault();
  const email = document.getElementById('sup-signup-email').value;
  const password = document.getElementById('sup-signup-password').value;
  try {
    const res = await fetch(`${SUPABASE_URL}/auth/v1/signup`, {
      method: 'POST',
      headers: { 'apikey': SUPABASE_ANON, 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password }),
    });
    const data = await res.json();
    if (!res.ok) throw new Error(data.error_description || data.msg || 'Inscription impossible.');
    if (data.access_token) {
      sessionStorage.setItem('sup_access_token', data.access_token);
      sessionStorage.setItem('sup_email', email);
      sessionStorage.setItem('sup_user_id', data.user.id);
      await supplierRouteAfterAuth();
    } else {
      showSupplierMessage('Compte créé. Vérifie ta boîte mail pour confirmer ton adresse, puis connecte-toi.');
    }
  } catch (err) {
    showSupplierMessage(err.message, true);
  }
}

async function supplierLogin(e) {
  e.preventDefault();
  const email = document.getElementById('sup-login-email').value;
  const password = document.getElementById('sup-login-password').value;
  try {
    const res = await fetch(`${SUPABASE_URL}/auth/v1/token?grant_type=password`, {
      method: 'POST',
      headers: { 'apikey': SUPABASE_ANON, 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password }),
    });
    const data = await res.json();
    if (!res.ok || !data.access_token) throw new Error(data.error_description || data.msg || 'Identifiants incorrects.');
    sessionStorage.setItem('sup_access_token', data.access_token);
    sessionStorage.setItem('sup_email', email);
    sessionStorage.setItem('sup_user_id', data.user.id);
    await supplierRouteAfterAuth();
  } catch (err) {
    showSupplierMessage(err.message, true);
  }
}

function supplierLogout() {
  sessionStorage.removeItem('sup_access_token');
  sessionStorage.removeItem('sup_email');
  sessionStorage.removeItem('sup_user_id');
  supplierCompany = null;
  supStatProducts = supStatPending = supStatApproved = null;
  supplierViewRows = [];
  supplierAllProducts = [];
  document.getElementById('sup-auth-box').style.display = 'block';
  document.getElementById('sup-claim-box').style.display = 'none';
  document.getElementById('sup-pending-box').style.display = 'none';
  document.getElementById('sup-dashboard').style.display = 'none';
  setSupplierStep(1);
}

function tryRestoreSupplierSession() {
  if (!sessionStorage.getItem('sup_access_token')) return;
  supplierRouteAfterAuth();
}

async function supplierRouteAfterAuth() {
  document.getElementById('sup-auth-box').style.display = 'none';
  try {
    const userId = sessionStorage.getItem('sup_user_id');
    const companies = await supplierFetch(`companies?claimed_by_user_id=eq.${userId}&select=*`);
    if (companies && companies.length) {
      supplierCompany = companies[0];
      document.getElementById('sup-claim-box').style.display = 'none';
      document.getElementById('sup-pending-box').style.display = 'none';
      document.getElementById('sup-dashboard').style.display = 'block';
      document.getElementById('sup-dash-title').textContent = supplierCompany.name;
      setSupplierStep(3);
      renderSupplierStats();
      renderPremiumBox();
      loadSupplierProducts();
      loadSupplierSubmissions();
      loadSupplierLeads();
      loadSupplierViews();
      loadSupplierComparison();
      handlePremiumReturn();
      return;
    }
    const claims = await supplierFetch(`company_claims?user_id=eq.${userId}&status=eq.pending&select=*,companies(name)&order=created_at.desc&limit=1`);
    if (claims && claims.length) {
      document.getElementById('sup-pending-company').textContent = (claims[0].companies && claims[0].companies.name) || '';
      document.getElementById('sup-claim-box').style.display = 'none';
      document.getElementById('sup-pending-box').style.display = 'block';
      document.getElementById('sup-dashboard').style.display = 'none';
      setSupplierStep(2);
      return;
    }
    document.getElementById('sup-claim-box').style.display = 'block';
    document.getElementById('sup-pending-box').style.display = 'none';
    document.getElementById('sup-dashboard').style.display = 'none';
    setSupplierStep(2);
  } catch (err) {
    showSupplierMessage(err.message, true);
  }
}

async function searchCompanyToClaim() {
  const q = document.getElementById('sup-claim-search').value.trim();
  const box = document.getElementById('sup-claim-results');
  if (!q) { box.innerHTML = ''; return; }
  box.innerHTML = 'Recherche…';
  try {
    const rows = await supplierFetch(`companies?name=ilike.*${encodeURIComponent(q)}*&select=id,name,country&limit=10`);
    if (!rows || !rows.length) { box.innerHTML = '<p style="font-size:13px;color:var(--muted)">Aucun résultat.</p>'; return; }
    box.innerHTML = rows.map(c => `
      <div class="admin-field-row">
        <span>${c.name} (${c.country || '—'})</span>
        <button class="btn-add-product" onclick="requestCompanyClaim('${c.id}','${c.name.replace(/'/g, "\\'")}')" style="padding:6px 14px;font-size:12px">Revendiquer</button>
      </div>`).join('');
  } catch (err) {
    box.innerHTML = `<p style="color:#C0392B;font-size:13px">${err.message}</p>`;
  }
}

async function requestCompanyClaim(companyId, companyName) {
  try {
    await supplierFetch('company_claims', {
      method: 'POST',
      body: JSON.stringify([{
        user_id: sessionStorage.getItem('sup_user_id'),
        user_email: sessionStorage.getItem('sup_email'),
        company_id: companyId,
      }]),
    });
    document.getElementById('sup-pending-company').textContent = companyName;
    document.getElementById('sup-claim-box').style.display = 'none';
    document.getElementById('sup-pending-box').style.display = 'block';
    setSupplierStep(2);
  } catch (err) {
    alert('Erreur : ' + err.message);
  }
}

async function loadSupplierProducts() {
  const list = document.getElementById('sup-products-list');
  list.innerHTML = 'Chargement…';
  try {
    const products = await supplierFetch(`products?company_id=eq.${supplierCompany.id}&select=*`);
    supStatProducts = (products && products.length) || 0;
    renderSupplierStats();
    if (!products || !products.length) { list.innerHTML = '<p class="sup-empty">Aucun produit pour le moment. Ajoutez-en un, il sera publié après validation.</p>'; return; }
    list.innerHTML = products.map(p => `
      <div class="sup-prod">
        <div class="sup-prod-main">
          <span class="sup-prod-name">${p.name}</span>
          <span class="sup-prod-cat">${p.category}</span>
        </div>
        <span class="sup-pill sup-pill-ok">● Publié</span>
        <div class="sup-prod-actions">
          <button class="btn-add-product sup-btn-sm" onclick="openSupplierProductForm('${p.id}')">Modifier</button>
          <button class="btn-remove-product" onclick="requestDeleteProduct('${p.id}','${p.name.replace(/'/g, "\\'")}')">Supprimer</button>
        </div>
      </div>`).join('');
  } catch (err) {
    list.innerHTML = `<p style="color:#E06A52;font-size:13px">${err.message}</p>`;
  }
}

async function loadSupplierSubmissions() {
  const list = document.getElementById('sup-submissions-list');
  list.innerHTML = 'Chargement…';
  try {
    const rows = await supplierFetch(`product_submissions?company_id=eq.${supplierCompany.id}&order=created_at.desc&limit=20`);
    supStatPending = (rows || []).filter(r => r.status === 'pending').length;
    supStatApproved = (rows || []).filter(r => r.status === 'approved').length;
    renderSupplierStats();
    if (!rows || !rows.length) { list.innerHTML = '<p class="sup-empty">Aucune demande envoyée.</p>'; return; }
    const labels = { new: 'Ajout', update: 'Modification', delete: 'Suppression' };
    const statusMap = {
      pending:  { cls: 'sup-pill-pending', txt: '⏳ En attente' },
      approved: { cls: 'sup-pill-ok',      txt: '✓ Approuvée' },
      rejected: { cls: 'sup-pill-no',      txt: '✕ Rejetée' },
    };
    list.innerHTML = `<div class="sup-timeline">` + rows.map(r => {
      const st = statusMap[r.status] || { cls: '', txt: r.status };
      return `
      <div class="sup-tl-row">
        <span class="sup-tl-dot ${st.cls}"></span>
        <span class="sup-tl-main"><strong>${labels[r.submission_type] || r.submission_type}</strong> · ${r.product_name || ''}</span>
        <span class="sup-pill ${st.cls}">${st.txt}</span>
      </div>`;
    }).join('') + `</div>`;
  } catch (err) {
    list.innerHTML = `<p style="color:#E06A52;font-size:13px">${err.message}</p>`;
  }
}

// Demandes de devis reçues sur l'entreprise revendiquée (table `leads`,
// voir backend/supabase_add_leads.sql — RLS scopée à claimed_by_user_id).
async function loadSupplierLeads() {
  const list = document.getElementById('sup-leads-list');
  if (!list) return;
  list.innerHTML = 'Chargement…';
  try {
    const rows = await supplierFetch(`leads?company_id=eq.${supplierCompany.id}&order=created_at.desc&limit=50`);
    supStatLeadsPending = (rows || []).filter(r => r.status === 'sent').length;
    renderSupplierStats();
    renderSupplierLeads(rows || []);
  } catch (err) {
    list.innerHTML = `<p style="color:#E06A52;font-size:13px">${err.message}</p>`;
  }
}

// ── Stats de vues (produits + fiche entreprise) — réservées aux
// fournisseurs premium (voir backend/supabase_add_supplier_view_stats_2026_09.sql :
// RLS sur entity_views, un non-premium récupère 0 ligne côté serveur même
// s'il force la requête). Table alimentée par pages/produit.html et
// pages/entreprise.html — voir backend/supabase_add_entity_views_2026_09.sql.
async function loadSupplierViews() {
  const range = document.getElementById('sup-views-range');
  const chart = document.getElementById('sup-views-chart');
  const list = document.getElementById('sup-views-products');
  if (!supplierCompany.premium) {
    range.style.display = 'none';
    chart.innerHTML = '';
    list.innerHTML = `
      <div class="sup-premium-upsell">
        <span>Les statistiques de vues détaillées par produit sont réservées aux entreprises Premium.</span>
        <button class="btn-add-product" onclick="startPremiumCheckout()">★ Passer Premium — 1 500 €/an</button>
      </div>`;
    return;
  }
  range.style.display = '';
  list.innerHTML = 'Chargement…';
  try {
    supplierViewRows = await supplierFetchAllPages(
      `entity_views?company_id=eq.${supplierCompany.id}&entity_type=eq.product&select=product_id,product_name,created_at&order=created_at.desc`
    );
    renderSupplierViewsForRange();
  } catch (err) {
    list.innerHTML = `<p style="color:#E06A52;font-size:13px">${err.message}</p>`;
  }
}

function renderSupplierViewsForRange() {
  const chart = document.getElementById('sup-views-chart');
  const list = document.getElementById('sup-views-products');
  const rangeDays = Number(document.getElementById('sup-views-range').value) || 30;
  const rangeLabel = SUPPLIER_VIEW_RANGES[rangeDays] || `${rangeDays} j`;

  const now = Date.now();
  const DAY = 24 * 60 * 60 * 1000;
  const within = (r, days) => now - new Date(r.created_at).getTime() <= days * DAY;
  const inRange = supplierViewRows.filter(r => within(r, rangeDays));

  // Table par produit : vues sur la plage + total toutes périodes confondues.
  const byProduct = {};
  supplierViewRows.forEach(r => {
    if (!r.product_id) return;
    if (!byProduct[r.product_id]) byProduct[r.product_id] = { name: r.product_name || r.product_id, inRange: 0, total: 0 };
    byProduct[r.product_id].total++;
  });
  inRange.forEach(r => { if (r.product_id && byProduct[r.product_id]) byProduct[r.product_id].inRange++; });
  const rows = Object.values(byProduct).sort((a, b) => b.inRange - a.inRange);

  list.innerHTML = !rows.length
    ? `<p class="sup-empty">Aucune vue enregistrée sur vos produits pour le moment.</p>`
    : `<div class="admin-field-row" style="font-weight:600;color:var(--muted);font-size:11px;text-transform:uppercase"><span>Produit</span><span>${rangeLabel} · Total</span></div>` +
      rows.map(p => `<div class="admin-field-row"><span>${p.name}</span><span>${p.inRange} · ${p.total}</span></div>`).join('');

  renderSupplierViewsChart(chart, inRange, rangeDays);
}

// Graphique courbe simplifié (une seule série : toutes vos vues produit) --
// même logique horaire/journalière que js/pages/admin.js renderAnalyticsChart(),
// réduite pour un usage fournisseur (pas de filtre par page).
function renderSupplierViewsChart(wrap, rows, rangeDays) {
  if (!rows.length) { wrap.innerHTML = ''; return; }

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

  const W = 700, H = 160, padL = 30, padB = 22, padT = 10, padR = 10;
  const chartW = W - padL - padR, chartH = H - padT - padB;
  const max = Math.max(1, ...counts);
  const x = i => padL + (counts.length === 1 ? chartW / 2 : (i / (counts.length - 1)) * chartW);
  const y = v => padT + chartH - (v / max) * chartH;
  const points = counts.map((v, i) => `${x(i)},${y(v)}`).join(' ');
  const areaPoints = `${padL},${padT + chartH} ${points} ${padL + chartW},${padT + chartH}`;

  const labelStride = Math.max(1, Math.ceil(counts.length / 8));
  const xLabels = counts.map((v, i) => {
    if (i % labelStride !== 0 && i !== counts.length - 1) return '';
    return `<text x="${x(i)}" y="${H - 5}" font-size="9" fill="var(--muted)" text-anchor="middle">${labelFor(buckets[i])}</text>`;
  }).join('');

  wrap.innerHTML = `
    <svg viewBox="0 0 ${W} ${H}" style="width:100%;height:auto;background:var(--white);border:1px solid var(--border);border-radius:8px;margin-bottom:14px">
      <polygon points="${areaPoints}" fill="var(--accent, #2563eb)" opacity="0.08"/>
      <polyline points="${points}" fill="none" stroke="var(--accent, #2563eb)" stroke-width="2"/>
      ${xLabels}
    </svg>`;
}

function renderSupplierLeads(rows) {
  const list = document.getElementById('sup-leads-list');
  if (!rows.length) { list.innerHTML = '<p class="sup-empty">Aucune demande de devis pour le moment.</p>'; return; }
  const statusMap = {
    sent:     { cls: 'sup-pill-pending', txt: '⏳ À traiter' },
    accepted: { cls: 'sup-pill-ok',      txt: '✓ Acceptée' },
    rejected: { cls: 'sup-pill-no',      txt: '✕ Refusée' },
  };
  list.innerHTML = rows.map(r => {
    const st = statusMap[r.status] || statusMap.sent;
    return `
      <div class="sup-lead">
        <div class="sup-lead-head">
          <span class="sup-lead-who">${r.buyer_name} · ${r.buyer_company}</span>
          <span class="sup-pill ${st.cls}">${st.txt}</span>
        </div>
        <div class="sup-lead-meta">${r.buyer_email} · ${r.product_name ? r.product_name + ' · ' : ''}${new Date(r.created_at).toLocaleDateString('fr-FR')}</div>
        <p class="sup-lead-msg">${r.message}</p>
        ${r.status === 'sent' ? `
        <div class="sup-lead-actions">
          <button class="btn-add-product sup-btn-sm" onclick="respondToLead('${r.id}','accepted')">✓ Accepter</button>
          <button class="btn-remove-product" onclick="respondToLead('${r.id}','rejected')">✕ Refuser</button>
        </div>` : ''}
      </div>`;
  }).join('');
}

async function respondToLead(id, status) {
  try {
    await supplierFetch(`leads?id=eq.${id}`, {
      method: 'PATCH',
      headers: { 'Prefer': 'return=minimal' },
      body: JSON.stringify({ status }),
    });
    loadSupplierLeads();
  } catch (err) {
    alert('Erreur : ' + err.message);
  }
}

async function requestDeleteProduct(productId, productName) {
  if (!confirm(`Demander la suppression de "${productName}" ? Cette action sera soumise à validation admin.`)) return;
  try {
    await supplierFetch('product_submissions', {
      method: 'POST',
      headers: { 'Prefer': 'return=minimal' },
      body: JSON.stringify([{
        submission_type: 'delete',
        target_product_id: productId,
        company_id: supplierCompany.id,
        submitter_user_id: sessionStorage.getItem('sup_user_id'),
        submitter_name: supplierCompany.name,
        submitter_email: sessionStorage.getItem('sup_email'),
        company_name: supplierCompany.name,
        product_name: productName,
        product_category: '—',
      }]),
    });
    alert('Demande de suppression envoyée, en attente de validation admin.');
    loadSupplierSubmissions();
  } catch (err) {
    alert('Erreur : ' + err.message);
  }
}

function openSupplierProductForm(productId) {
  supplierEditingProductId = productId || null;
  const wrap = document.getElementById('sup-product-form-wrap');
  wrap.style.display = 'block';
  wrap.innerHTML = `
    <div class="submit-section-title">${productId ? 'Modifier le produit' : 'Nouveau produit'}</div>
    <form onsubmit="submitSupplierProductForm(event)">
      <div class="lead-field"><label>Nom du produit</label><input type="text" id="sup-p-name" required/></div>
      <div class="lead-field"><label>Catégorie</label><input type="text" id="sup-p-category" required/></div>
      <div class="lead-field"><label>Description</label><textarea id="sup-p-desc" rows="3"></textarea></div>
      <div class="lead-field"><label>Prix (libellé)</label><input type="text" id="sup-p-price" placeholder="Sur devis"/></div>
      <div class="submit-actions">
        <button type="submit" class="btn-submit-form">Envoyer pour validation</button>
        <button type="button" class="btn-remove-product" onclick="document.getElementById('sup-product-form-wrap').style.display='none'">Annuler</button>
      </div>
    </form>`;
  if (productId) {
    supplierFetch(`products?id=eq.${productId}&select=*`).then(rows => {
      if (!rows || !rows.length) return;
      const p = rows[0];
      document.getElementById('sup-p-name').value = p.name || '';
      document.getElementById('sup-p-category').value = p.category || '';
      document.getElementById('sup-p-desc').value = p.description || '';
      document.getElementById('sup-p-price').value = p.price_label || '';
    });
  }
}

async function submitSupplierProductForm(e) {
  e.preventDefault();
  const name = document.getElementById('sup-p-name').value;
  const category = document.getElementById('sup-p-category').value;
  const description = document.getElementById('sup-p-desc').value;
  const price_label = document.getElementById('sup-p-price').value;
  try {
    await supplierFetch('product_submissions', {
      method: 'POST',
      headers: { 'Prefer': 'return=minimal' },
      body: JSON.stringify([{
        submission_type: supplierEditingProductId ? 'update' : 'new',
        target_product_id: supplierEditingProductId,
        company_id: supplierCompany.id,
        submitter_user_id: sessionStorage.getItem('sup_user_id'),
        submitter_name: supplierCompany.name,
        submitter_email: sessionStorage.getItem('sup_email'),
        company_name: supplierCompany.name,
        company_country: supplierCompany.country,
        company_hq: supplierCompany.hq,
        company_industry: supplierCompany.industry,
        product_name: name,
        product_category: category,
        product_description: description,
        product_price_label: price_label || 'Sur devis',
      }]),
    });
    document.getElementById('sup-product-form-wrap').style.display = 'none';
    alert('Demande envoyée, en attente de validation admin.');
    loadSupplierSubmissions();
  } catch (err) {
    alert('Erreur : ' + err.message);
  }
}

// ── Comparaison concurrentielle — réservée aux fournisseurs premium.
// Contrairement aux stats de vues, la donnée sous-jacente (le catalogue
// public) n'a rien de confidentiel : n'importe quel visiteur peut déjà
// comparer ces mêmes produits sur pages/catalogue.html. Le gate premium
// ici est une restriction d'usage côté client (valeur ajoutée du
// dashboard), pas une protection RLS. Nécessite js/api.js (fetchAllPaged,
// mapProduct) chargé sur pages/supplier.html.
async function loadSupplierComparison() {
  const select = document.getElementById('sup-compare-product');
  const table = document.getElementById('sup-compare-table');
  if (!supplierCompany.premium) {
    select.style.display = 'none';
    table.innerHTML = `
      <div class="sup-premium-upsell">
        <span>La comparaison de vos produits avec la concurrence est réservée aux entreprises Premium.</span>
        <button class="btn-add-product" onclick="startPremiumCheckout()">★ Passer Premium — 1 500 €/an</button>
      </div>`;
    return;
  }
  table.innerHTML = 'Chargement du catalogue…';
  try {
    const rows = await fetchAllPaged('get_products_page');
    supplierAllProducts = rows.map(mapProduct);
    const ownProducts = supplierAllProducts.filter(p => p.companyId === supplierCompany.id);
    if (!ownProducts.length) {
      select.style.display = 'none';
      table.innerHTML = '<p class="sup-empty">Ajoutez d\'abord un produit pour le comparer à la concurrence.</p>';
      return;
    }
    select.style.display = '';
    select.innerHTML = ownProducts.map(p => `<option value="${p.id}">${p.name}</option>`).join('');
    renderSupplierComparison();
  } catch (err) {
    table.innerHTML = `<p style="color:#E06A52;font-size:13px">${err.message}</p>`;
  }
}

function renderSupplierComparison() {
  const table = document.getElementById('sup-compare-table');
  const selectedId = document.getElementById('sup-compare-product').value;
  const own = supplierAllProducts.find(p => p.id === selectedId);
  if (!own) return;

  // Même catégorie, autre entreprise -- 4 concurrents max, comme le
  // comparateur du catalogue (voir js/modal.js openCompareModal).
  const competitors = supplierAllProducts
    .filter(p => p.cat === own.cat && p.companyId !== own.companyId)
    .slice(0, 4);

  if (!competitors.length) {
    table.innerHTML = `<p class="sup-empty">Aucun autre produit référencé dans la catégorie « ${own.cat} » pour l'instant.</p>`;
    return;
  }

  const prods = [own, ...competitors];
  const allLabels = [...new Set(prods.flatMap(p => p.specs.map(s => s.l)))];

  const hCols = prods.map((p, i) => `
    <th class="prod-col">
      <div style="display:flex;flex-direction:column;align-items:center;gap:3px">
        <span style="font-size:18px">${p.icon}</span>
        <strong style="font-size:11px">${p.name}</strong>
        <span style="font-size:10px;opacity:.8">${i === 0 ? '★ Votre produit' : p.maker}</span>
      </div>
    </th>`).join('');

  const specRows = allLabels.map(label => {
    const cells = prods.map(p => {
      const s = p.specs.find(x => x.l === label);
      return `<td>${s ? s.v : '—'}</td>`;
    }).join('');
    return `<tr><td class="row-label">${label}</td>${cells}</tr>`;
  }).join('');

  const priceRow = `<tr><td class="row-label">Prix</td>${prods.map(p => `<td style="font-weight:700;color:var(--sage)">${p.price}</td>`).join('')}</tr>`;

  table.innerHTML = `
    <div style="overflow-x:auto">
      <table class="cmp-table">
        <thead><tr><th style="min-width:120px">Caractéristique</th>${hCols}</tr></thead>
        <tbody>${specRows}${priceRow}</tbody>
      </table>
    </div>`;
}

