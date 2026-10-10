// ═══════════════════════════════
// ESPACE FOURNISSEUR (compte, revendication, tableau de bord)
// Toute modification passe par product_submissions — jamais d'écriture
// directe — et la revendication est toujours validée à la main par l'admin.
// ═══════════════════════════════
let supplierCompany = null; // entreprise revendiquée (si déjà approuvée)
let supplierEditingProductId = null; // null = ajout, sinon id du produit en cours d'édition
let supStatProducts = null, supStatPending = null, supStatApproved = null, supStatLeadsPending = null; // compteurs du bandeau
// Plan gratuit : 2 produits (publiés + demandes d'ajout en attente). Règle appliquée en base
// (backend/supabase_plan_limits_2026_10.sql, erreur PRODUCT_LIMIT) ; ici on l'explique à l'écran.
const FREE_PRODUCT_LIMIT = 2;
let supStatPendingNew = null;
// Texte traduit avec repli intégré : i18n.js peut rester en cache plusieurs heures chez un
// visiteur de retour, sans les clés récentes -- jamais de clé technique à l'écran.
const tf = (key, fr, en) => ((TRANSLATIONS[getLang()] || {})[key]) || (getLang() === 'en' ? en : fr);
let supplierViewRows = []; // vues produit (entity_views), stats premium -- voir loadSupplierViews()
let supplierAllProducts = []; // catalogue complet (mapProduct), pour la comparaison concurrentielle premium

// Plages du sélecteur temporel des stats de vues (même liste que
// js/pages/admin.js ANALYTICS_RANGES, pour une expérience cohérente).
const supplierRangeLabel = d => (TRANSLATIONS[getLang()]['sp_rng_' + d] ? t('sp_rng_' + d) : null);
const supLocale = () => (getLang() === 'en' ? 'en-GB' : 'fr-FR');

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
    <div class="sup-stat"><span class="sup-stat-n ${supStatLeadsPending ? 'sup-stat-pending' : ''}">${fmt(supStatLeadsPending)}</span><span class="sup-stat-l">${t('sp_stat_leads')}</span></div>
    <div class="sup-stat"><span class="sup-stat-n">${fmt(supStatProducts)}</span><span class="sup-stat-l">${t('sp_stat_products')}</span></div>
    <div class="sup-stat"><span class="sup-stat-n sup-stat-pending">${fmt(supStatPending)}</span><span class="sup-stat-l">${t('sp_stat_pending')}</span></div>
    <div class="sup-stat"><span class="sup-stat-n sup-stat-ok">${fmt(supStatApproved)}</span><span class="sup-stat-l">${t('sp_stat_approved')}</span></div>`;
}

// Bandeau Premium : bouton d'abonnement, ou confirmation si déjà actif.
// L'activation réelle se fait côté Worker (/api/create-checkout-session
// + /api/stripe-webhook), jamais en écrivant premium=true depuis le
// client — voir cloudflare/supabase-proxy-worker.js.
function renderPremiumBox() {
  const el = document.getElementById('sup-premium-box');
  if (!el || !supplierCompany) return;
  if (supplierCompany.premium) {
    el.innerHTML = `<div class="sup-premium-active">${t('sp_premium_active')}</div>`;
  } else {
    el.innerHTML = `
      <div class="sup-premium-upsell">
        <span>${t('sp_premium_upsell')}</span>
        <button id="sup-premium-btn" class="btn-add-product" onclick="startPremiumCheckout()">${t('sp_premium_btn')}</button>
      </div>`;
  }
}

async function startPremiumCheckout() {
  if (!supplierCompany) return;
  const btn = document.getElementById('sup-premium-btn');
  if (btn) { btn.disabled = true; btn.textContent = t('sp_redirecting'); }
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
    if (!res.ok || !data.url) throw new Error(data.error || t('sp_pay_err'));
    window.location.href = data.url;
  } catch (err) {
    alert(t('acc_err_prefix') + err.message);
    if (btn) { btn.disabled = false; btn.textContent = t('sp_premium_btn'); }
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
    if (banner) banner.innerHTML = `<div class="sup-premium-active">${t('sp_pay_received')}</div>`;
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
  wrap.style.display = 'block';
  wrap.innerHTML = `
    <div class="sup-panel">
      <div class="submit-section-title">${t('sp_ce_title')}</div>
      <p style="font-size:12px;color:var(--muted);margin:-8px 0 14px">${t('sp_ce_note')}</p>
      <form onsubmit="submitCompanyEditForm(event)">
        <div class="lead-field"><label>${t('lbl_description')}</label><textarea id="sup-c-desc" rows="3">${escapeHtml(c.desc || '')}</textarea></div>
        <div class="lead-field"><label>${t('sp_c_site')}</label><input type="url" id="sup-c-site" value="${escapeHtml(c.site !== '#' ? c.site : '')}" placeholder="https://…"/></div>
        <div class="lead-field"><label>${t('sp_c_hq')}</label><input type="text" id="sup-c-hq" value="${escapeHtml(c.hq)}"/></div>
        <div class="lead-field"><label>${t('sp_c_country')}</label><input type="text" id="sup-c-country" value="${escapeHtml(c.country)}"/></div>
        <div class="lead-field"><label>${t('lbl_industry')}</label><input type="text" id="sup-c-industry" value="${escapeHtml(c.industry)}"/></div>
        <div class="lead-field"><label>${t('sp_c_contact')}</label><input type="email" id="sup-c-contact" value="${escapeHtml(c.contact)}"/></div>
        <div class="submit-actions">
          <button type="submit" class="btn-submit-form">${t('sp_submit_val')}</button>
          <button type="button" class="btn-remove-product" onclick="document.getElementById('sup-company-form-wrap').style.display='none'">${t('acc_cancel')}</button>
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
    alert(t('sp_req_sent'));
    loadSupplierSubmissions();
  } catch (err) {
    alert(t('acc_err_prefix') + err.message);
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
    throw new Error(t('sp_session_exp'));
  }
  if (!res.ok) {
    // Remonte le vrai message Postgres (ex: RAISE EXCEPTION 'nda_required'
    // dans get_rfq_dossier_detail, voir js/pages/rfq.js) plutôt qu'un
    // simple code HTTP -- utile pour distinguer les erreurs "attendues"
    // (à intercepter côté UI) des vraies pannes.
    const body = await res.json().catch(() => null);
    throw new Error((body && body.message) || `HTTP ${res.status} sur ${path}`);
  }
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
    if (!res.ok) throw new Error(data.error_description || data.msg || t('acc_err_signup'));
    if (data.access_token) {
      sessionStorage.setItem('sup_access_token', data.access_token);
      sessionStorage.setItem('sup_email', email);
      sessionStorage.setItem('sup_user_id', data.user.id);
      await supplierRouteAfterAuth();
    } else {
      showSupplierMessage(t('acc_err_confirm'));
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
    if (!res.ok || !data.access_token) throw new Error(data.error_description || data.msg || t('acc_err_login'));
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
  supStatProducts = supStatPending = supStatApproved = supStatPendingNew = null;
  supplierViewRows = [];
  supplierAllProducts = [];
  supplierRfqDossiers = [];
  supplierRfqResponsesByDossier = {};
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
    // Invitation reçue par email : on la valide d'abord (js/pages/supplier-team.js).
    if (typeof acceptPendingInvite === 'function') await acceptPendingInvite();
    // L'entreprise = celle dont on est membre (company_members). Repli sur
    // l'ancien propriétaire unique tant que la migration
    // backend/supabase_company_members_2026_10.sql n'est pas exécutée.
    let companies = [];
    try {
      // fetch direct (pas supplierFetch) : un refus d'accès sur cette table ne doit
      // jamais déclencher la déconnexion automatique, juste le repli ci-dessous.
      const mres = await fetch(`${SUPABASE_URL}/rest/v1/company_members?user_id=eq.${userId}&select=company_id,role&order=created_at.asc`, {
        headers: { 'apikey': SUPABASE_ANON, 'Authorization': 'Bearer ' + sessionStorage.getItem('sup_access_token') },
      });
      if (!mres.ok) throw new Error('HTTP ' + mres.status);
      const memberships = await mres.json();
      if (memberships && memberships.length) {
        companies = await supplierFetch(`companies?id=eq.${memberships[0].company_id}&select=*`);
      }
    } catch (memberErr) {
      companies = await supplierFetch(`companies?claimed_by_user_id=eq.${userId}&select=*`);
    }
    if (companies && companies.length) {
      supplierCompany = companies[0];
      document.getElementById('sup-claim-box').style.display = 'none';
      document.getElementById('sup-pending-box').style.display = 'none';
      document.getElementById('sup-dashboard').style.display = 'block';
      const title = document.getElementById('sup-dash-title');
      if (title) title.textContent = supplierCompany.name;
      setSupplierStep(3);
      renderSupplierStats();
      renderPremiumBox();
      // RFQ réservés aux fournisseurs Premium : pas de lien d'accès pour les autres.
      const rfqLink = document.getElementById('sup-rfq-link');
      if (rfqLink) rfqLink.style.display = supplierCompany.premium ? '' : 'none';
      loadSupplierProducts();
      loadSupplierSubmissions();
      if (typeof loadSupplierTeam === 'function') loadSupplierTeam();
      loadSupplierLeads();
      loadSupplierViews();
      loadSupplierComparison();
      loadSupplierRfqDossiers();
      handlePremiumReturn();
      // pages/rfq.html uniquement -- voir js/pages/rfq.js (non défini sur supplier.html).
      if (typeof loadRfqBrowse === 'function') loadRfqBrowse();
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
  box.innerHTML = t('sp_searching');
  try {
    const rows = await supplierFetch(`companies?name=ilike.*${encodeURIComponent(q)}*&select=id,name,country&limit=10`);
    if (!rows || !rows.length) { box.innerHTML = `<p style="font-size:13px;color:var(--muted)">${t('sp_no_result')}</p>`; return; }
    box.innerHTML = rows.map(c => `
      <div class="admin-field-row">
        <span>${escapeHtml(c.name)} (${escapeHtml(c.country || '—')})</span>
        <button class="btn-add-product" onclick="requestCompanyClaim('${c.id}','${escapeJsAttr(c.name)}')" style="padding:6px 14px;font-size:12px">${t('ent_claim_link')}</button>
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
    alert(t('acc_err_prefix') + err.message);
  }
}

async function loadSupplierProducts() {
  const list = document.getElementById('sup-products-list');
  if (!list) return;
  list.innerHTML = t('acc_loading');
  try {
    const products = await supplierFetch(`products?company_id=eq.${supplierCompany.id}&select=*`);
    supStatProducts = (products && products.length) || 0;
    renderSupplierStats();
    renderProductLimit();
    if (!products || !products.length) { list.innerHTML = `<p class="sup-empty">${t('sp_no_products')}</p>`; return; }
    list.innerHTML = products.map(p => `
      <div class="sup-prod">
        <div class="sup-prod-main">
          <span class="sup-prod-name">${escapeHtml(p.name)}</span>
          <span class="sup-prod-cat">${escapeHtml(p.category)}</span>
        </div>
        <span class="sup-pill sup-pill-ok">${t('sp_published')}</span>
        <div class="sup-prod-actions">
          <button class="btn-add-product sup-btn-sm" onclick="openSupplierProductForm('${p.id}')">${t('acc_edit')}</button>
          <button class="btn-remove-product" onclick="requestDeleteProduct('${p.id}','${escapeJsAttr(p.name)}')">${t('sp_delete')}</button>
        </div>
      </div>`).join('');
  } catch (err) {
    list.innerHTML = `<p style="color:#E06A52;font-size:13px">${err.message}</p>`;
  }
}

async function loadSupplierSubmissions() {
  const list = document.getElementById('sup-submissions-list');
  if (!list) return;
  list.innerHTML = t('acc_loading');
  try {
    const rows = await supplierFetch(`product_submissions?company_id=eq.${supplierCompany.id}&order=created_at.desc&limit=20`);
    supStatPending = (rows || []).filter(r => r.status === 'pending').length;
    supStatApproved = (rows || []).filter(r => r.status === 'approved').length;
    supStatPendingNew = (rows || []).filter(r => r.status === 'pending' && r.submission_type === 'new').length;
    renderSupplierStats();
    renderProductLimit();
    if (!rows || !rows.length) { list.innerHTML = `<p class="sup-empty">${t('sp_no_subs')}</p>`; return; }
    const labels = { new: t('sp_sub_new'), update: t('sp_sub_update'), delete: t('sp_sub_delete') };
    const statusMap = {
      pending:  { cls: 'sup-pill-pending', txt: t('acc_st_sent') },
      approved: { cls: 'sup-pill-ok',      txt: t('sp_st_approved') },
      rejected: { cls: 'sup-pill-no',      txt: t('sp_st_rejected') },
    };
    list.innerHTML = `<div class="sup-timeline">` + rows.map(r => {
      const st = statusMap[r.status] || { cls: '', txt: r.status };
      return `
      <div class="sup-tl-row">
        <span class="sup-tl-dot ${st.cls}"></span>
        <span class="sup-tl-main"><strong>${escapeHtml(labels[r.submission_type] || r.submission_type)}</strong> · ${escapeHtml(r.product_name || '')}</span>
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
  list.innerHTML = t('acc_loading');
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
  if (!range || !chart || !list) return;
  if (!supplierCompany.premium) {
    range.style.display = 'none';
    chart.innerHTML = '';
    list.innerHTML = `
      <div class="sup-premium-upsell">
        <span>${t('sp_views_upsell')}</span>
        <button class="btn-add-product" onclick="startPremiumCheckout()">${t('sp_premium_btn')}</button>
      </div>`;
    return;
  }
  range.style.display = '';
  list.innerHTML = t('acc_loading');
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
  const rangeLabel = supplierRangeLabel(rangeDays) || `${rangeDays} d`;

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
    ? `<p class="sup-empty">${t('sp_views_none')}</p>`
    : `<div class="admin-field-row" style="font-weight:600;color:var(--muted);font-size:11px;text-transform:uppercase"><span>${t('sp_product')}</span><span>${rangeLabel} · Total</span></div>` +
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
  if (!rows.length) { list.innerHTML = `<p class="sup-empty">${t('sp_no_leads')}</p>`; return; }
  const statusMap = {
    sent:     { cls: 'sup-pill-pending', txt: t('sp_st_todo') },
    accepted: { cls: 'sup-pill-ok',      txt: t('acc_st_accepted') },
    rejected: { cls: 'sup-pill-no',      txt: t('acc_st_rejected') },
  };
  list.innerHTML = rows.map(r => {
    const st = statusMap[r.status] || statusMap.sent;
    return `
      <div class="sup-lead">
        <div class="sup-lead-head">
          <span class="sup-lead-who">${escapeHtml(r.buyer_name)} · ${escapeHtml(r.buyer_company)}</span>
          <span class="sup-pill ${st.cls}">${st.txt}</span>
        </div>
        <div class="sup-lead-meta">${escapeHtml(r.buyer_email)} · ${r.product_name ? escapeHtml(r.product_name) + ' · ' : ''}${new Date(r.created_at).toLocaleDateString(supLocale())}</div>
        <p class="sup-lead-msg">${escapeHtml(r.message)}</p>
        ${r.status === 'sent' ? `
        <div class="sup-lead-actions">
          <button class="btn-add-product sup-btn-sm" onclick="respondToLead('${r.id}','accepted')">${t('sp_accept')}</button>
          <button class="btn-remove-product" onclick="respondToLead('${r.id}','rejected')">${t('sp_refuse')}</button>
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
    alert(t('acc_err_prefix') + err.message);
  }
}

async function requestDeleteProduct(productId, productName) {
  if (!confirm(`${t('sp_confirm_delete_a')}${productName}${t('sp_confirm_delete_b')}`)) return;
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
    alert(t('sp_delete_sent'));
    loadSupplierSubmissions();
  } catch (err) {
    alert(t('acc_err_prefix') + err.message);
  }
}

// Plan gratuit : avertit et bloque l'ajout au-delà de FREE_PRODUCT_LIMIT. Le blocage réel est en base.
function productLimitState() {
  if (!supplierCompany || supplierCompany.premium || supStatProducts === null || supStatPendingNew === null) return { limited: false };
  const used = supStatProducts + supStatPendingNew;
  return { limited: true, used, atLimit: used >= FREE_PRODUCT_LIMIT };
}

function renderProductLimit() {
  const note = document.getElementById('sup-product-limit');
  const btn = document.getElementById('sup-add-product-btn');
  if (!note || !btn) return;
  const s = productLimitState();
  if (!s.limited) { note.style.display = 'none'; btn.disabled = false; return; }
  const msg = s.used > FREE_PRODUCT_LIMIT
    ? tf('sp_product_limit_over', 'Plan gratuit : {limit} produits maximum. Vos {used} produits actuels sont conservés ; passez en Premium pour en ajouter.', 'Free plan: {limit} products maximum. Your {used} current products are kept; go Premium to add more.')
    : tf('sp_product_limit_note', 'Plan gratuit : {used} / {limit} produits. Passez en Premium pour en publier davantage.', 'Free plan: {used} / {limit} products. Go Premium to publish more.');
  note.innerHTML = `${escapeHtml(msg.replace('{used}', s.used).replace('{limit}', FREE_PRODUCT_LIMIT))}` +
    (s.atLimit ? ` <button type="button" class="btn-add-product sup-btn-sm" style="margin-left:8px" onclick="startPremiumCheckout()">${t('sp_premium_btn')}</button>` : '');
  note.style.display = 'block';
  btn.disabled = s.atLimit;
}

function openSupplierProductForm(productId) {
  if (!productId) {
    const s = productLimitState();
    if (s.limited && s.atLimit) {
      alert(tf('sp_err_product_limit', 'Limite du plan gratuit atteinte (2 produits). Passez en Premium pour publier davantage de produits.', 'Free plan limit reached (2 products). Go Premium to publish more products.'));
      return;
    }
  }
  supplierEditingProductId = productId || null;
  const wrap = document.getElementById('sup-product-form-wrap');
  wrap.style.display = 'block';
  wrap.innerHTML = `
    <div class="submit-section-title">${productId ? t('sp_p_edit') : t('sp_p_new')}</div>
    <form onsubmit="submitSupplierProductForm(event)">
      <div class="lead-field"><label>${t('sp_p_name')}</label><input type="text" id="sup-p-name" required/></div>
      <div class="lead-field"><label>${t('sp_category')}</label><input type="text" id="sup-p-category" required/></div>
      <div class="lead-field"><label>${t('lbl_description')}</label><textarea id="sup-p-desc" rows="3"></textarea></div>
      <div class="lead-field"><label>${t('sp_p_price')}</label><input type="text" id="sup-p-price" placeholder="${t('rq_price_ph')}"/></div>
      <div class="submit-actions">
        <button type="submit" class="btn-submit-form">${t('sp_submit_val')}</button>
        <button type="button" class="btn-remove-product" onclick="document.getElementById('sup-product-form-wrap').style.display='none'">${t('acc_cancel')}</button>
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
    alert(t('sp_req_sent'));
    loadSupplierSubmissions();
  } catch (err) {
    if (/PRODUCT_LIMIT/.test(err.message)) {
      alert(tf('sp_err_product_limit', 'Limite du plan gratuit atteinte (2 produits). Passez en Premium pour publier davantage de produits.', 'Free plan limit reached (2 products). Go Premium to publish more products.'));
      loadSupplierSubmissions();
      return;
    }
    alert(t('acc_err_prefix') + err.message);
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
  if (!select || !table) return;
  if (!supplierCompany.premium) {
    select.style.display = 'none';
    table.innerHTML = `
      <div class="sup-premium-upsell">
        <span>${t('sp_cmp_upsell')}</span>
        <button class="btn-add-product" onclick="startPremiumCheckout()">${t('sp_premium_btn')}</button>
      </div>`;
    return;
  }
  table.innerHTML = t('sp_cmp_loading');
  try {
    const rows = await fetchAllPaged('get_products_page');
    supplierAllProducts = rows.map(mapProduct);
    const ownProducts = supplierAllProducts.filter(p => p.companyId === supplierCompany.id);
    if (!ownProducts.length) {
      select.style.display = 'none';
      table.innerHTML = `<p class="sup-empty">${t('sp_cmp_add_first')}</p>`;
      return;
    }
    select.style.display = '';
    select.innerHTML = ownProducts.map(p => `<option value="${p.id}">${escapeHtml(p.name)}</option>`).join('');
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
    table.innerHTML = `<p class="sup-empty">${t('sp_cmp_none_a')}${escapeHtml(own.cat)}${t('sp_cmp_none_b')}</p>`;
    return;
  }

  const prods = [own, ...competitors];
  const allLabels = [...new Set(prods.flatMap(p => p.specs.map(s => s.l)))];

  const hCols = prods.map((p, i) => `
    <th class="prod-col">
      <div style="display:flex;flex-direction:column;align-items:center;gap:3px">
        <span style="font-size:18px">${escapeHtml(p.icon)}</span>
        <strong style="font-size:11px">${escapeHtml(p.name)}</strong>
        <span style="font-size:10px;opacity:.8">${i === 0 ? t('sp_your_product') : escapeHtml(p.maker)}</span>
      </div>
    </th>`).join('');

  const specRows = allLabels.map(label => {
    const cells = prods.map(p => {
      const s = p.specs.find(x => x.l === label);
      return `<td>${s ? escapeHtml(s.v) : '—'}</td>`;
    }).join('');
    return `<tr><td class="row-label">${escapeHtml(label)}</td>${cells}</tr>`;
  }).join('');

  const priceRow = `<tr><td class="row-label">${t('sp_price')}</td>${prods.map(p => `<td style="font-weight:700;color:var(--sage)">${escapeHtml(p.price)}</td>`).join('')}</tr>`;

  table.innerHTML = `
    <div style="overflow-x:auto">
      <table class="cmp-table">
        <thead><tr><th style="min-width:120px">${t('sp_characteristic')}</th>${hCols}</tr></thead>
        <tbody>${specRows}${priceRow}</tbody>
      </table>
    </div>`;
}

// ── Dépôt et suivi des dossiers RFQ/RFI/RFP côté systémier -- réservé aux
// entreprises is_systemier=true ET premium (voir
// backend/supabase_add_rfq_system_2026_09.sql, policy
// systemier_premium_can_submit_rfq). Les réponses reçues des fournisseurs
// se gèrent ici aussi (accepter/refuser), même logique que
// loadSupplierLeads/respondToLead.
let supplierRfqDossiers = [];
let supplierRfqResponsesByDossier = {};
let supplierRfqNdaSignaturesByDossier = {};
let rfqEditingAttachmentDossierId = null;

async function loadSupplierRfqDossiers() {
  const panel = document.getElementById('sup-rfq-panel');
  const list = document.getElementById('sup-rfq-list');
  if (!panel || !list) return;
  if (!supplierCompany.is_systemier) { panel.style.display = 'none'; return; }
  panel.style.display = 'block';
  if (!supplierCompany.premium) {
    list.innerHTML = `
      <div class="sup-premium-upsell">
        <span>${t('sp_rfq_upsell')}</span>
        <button class="btn-add-product" onclick="startPremiumCheckout()">${t('sp_premium_btn')}</button>
      </div>`;
    document.querySelector('#sup-rfq-panel .sup-add-inline').style.display = 'none';
    return;
  }
  document.querySelector('#sup-rfq-panel .sup-add-inline').style.display = '';
  list.innerHTML = t('acc_loading');
  try {
    supplierRfqDossiers = await supplierFetch(`rfq_dossiers?company_id=eq.${supplierCompany.id}&select=*&order=created_at.desc`) || [];
    if (!supplierRfqDossiers.length) {
      supplierRfqResponsesByDossier = {};
      supplierRfqNdaSignaturesByDossier = {};
      list.innerHTML = `<p class="sup-empty">${t('sp_rfq_none')}</p>`;
      return;
    }
    const ids = supplierRfqDossiers.map(d => d.id).join(',');
    const [responses, ndaSignatures] = await Promise.all([
      supplierFetch(`rfq_responses?rfq_id=in.(${ids})&select=*&order=created_at.desc`),
      supplierFetch(`rfq_custom_nda_signatures?rfq_id=in.(${ids})&select=*&order=created_at.desc`),
    ]);
    supplierRfqResponsesByDossier = {};
    (responses || []).forEach(r => { (supplierRfqResponsesByDossier[r.rfq_id] ||= []).push(r); });
    supplierRfqNdaSignaturesByDossier = {};
    (ndaSignatures || []).forEach(s => { (supplierRfqNdaSignaturesByDossier[s.rfq_id] ||= []).push(s); });
    renderSupplierRfqDossiers();
  } catch (err) {
    list.innerHTML = `<p style="color:#E06A52;font-size:13px">${err.message}</p>`;
  }
}

function renderSupplierRfqDossiers() {
  const list = document.getElementById('sup-rfq-list');
  const statusMap = {
    pending:   { cls: 'sup-pill-pending', txt: t('sp_rfq_st_pending') },
    published: { cls: 'sup-pill-ok',      txt: t('sp_published') },
    rejected:  { cls: 'sup-pill-no',      txt: t('sp_rfq_st_rejected') },
    closed:    { cls: '',                 txt: t('sp_rfq_st_closed') },
  };
  list.innerHTML = supplierRfqDossiers.map(d => {
    const st = statusMap[d.status] || { cls: '', txt: d.status };
    const nResp = (supplierRfqResponsesByDossier[d.id] || []).length;
    const nNdaPending = (supplierRfqNdaSignaturesByDossier[d.id] || []).filter(s => s.status === 'pending').length;
    return `
      <div class="sup-prod">
        <div class="sup-prod-main">
          <span class="sup-prod-name">${escapeHtml(d.rfq_type)} — ${escapeHtml(d.title)}${d.requires_custom_nda ? ' 🔒' : ''}</span>
          <span class="sup-prod-cat">${escapeHtml(d.category || '—')}</span>
        </div>
        <span class="sup-pill ${st.cls}">${st.txt}</span>
        <div class="sup-prod-actions">
          ${d.status === 'published' ? `<button class="btn-add-product sup-btn-sm" onclick="viewRfqResponses('${d.id}')">${t('sp_rfq_responses')} (${nResp})</button>` : ''}
          ${d.status === 'published' && d.requires_custom_nda ? `<button class="btn-add-product sup-btn-sm" onclick="viewRfqNdaSignatures('${d.id}')">${t('sp_rfq_nda_sigs')} (${nNdaPending})</button>` : ''}
          ${d.status === 'published' ? `<button class="btn-remove-product" onclick="closeRfqDossier('${d.id}')">${t('sp_rfq_close')}</button>` : ''}
        </div>
      </div>
      ${d.status === 'rejected' && d.rejection_reason ? `<p style="font-size:12px;color:#E06A52;margin:-4px 0 10px">${t('sp_reject_reason')}${escapeHtml(d.rejection_reason)}</p>` : ''}`;
  }).join('');
}

function openRfqDossierForm() {
  rfqEditingAttachmentDossierId = null;
  const wrap = document.getElementById('sup-rfq-form-wrap');
  wrap.style.display = 'block';
  wrap.innerHTML = `
    <div class="submit-section-title">${t('sp_rf_title')}</div>
    <p style="font-size:12px;color:var(--muted);margin:-8px 0 14px">${t('sp_rf_note')}</p>
    <form onsubmit="submitRfqDossierForm(event)">
      <div class="lead-field"><label>${t('sp_rf_type')}</label>
        <select id="sup-rfq-type"><option value="RFQ">${t('sp_rf_opt_rfq')}</option><option value="RFI">${t('sp_rf_opt_rfi')}</option><option value="RFP">${t('sp_rf_opt_rfp')}</option></select>
      </div>
      <div class="lead-field"><label>${t('sp_rf_titre')}</label><input type="text" id="sup-rfq-title" required/></div>
      <div class="lead-field"><label>${t('sp_category')}</label><input type="text" id="sup-rfq-category" placeholder="${t('sp_rf_cat_ph')}"/></div>
      <div class="lead-field"><label>${t('sp_rf_domain')}</label><input type="text" id="sup-rfq-industry" placeholder="${t('sp_rf_domain_ph')}"/></div>
      <div class="lead-field"><label>${t('sp_rf_desc')}</label><textarea id="sup-rfq-desc" rows="5" required></textarea></div>
      <div class="lead-field"><label>${t('sp_rf_deadline')}</label><input type="date" id="sup-rfq-deadline"/></div>
      <div class="lead-field"><label>${t('sp_rf_file')}</label><input type="file" id="sup-rfq-file"/></div>
      <div class="lead-field">
        <label style="display:flex;align-items:center;gap:8px;cursor:pointer">
          <input type="checkbox" id="sup-rfq-custom-nda" onchange="document.getElementById('sup-rfq-nda-template-wrap').style.display=this.checked?'block':'none'" style="width:auto"/>
          ${t('sp_rf_custom_nda')}
        </label>
      </div>
      <div id="sup-rfq-nda-template-wrap" style="display:none">
        <div class="lead-field"><label>${t('sp_rf_nda_file')}</label><input type="file" id="sup-rfq-nda-file" accept=".pdf"/></div>
        <p style="font-size:12px;color:var(--muted);margin:-8px 0 14px">${t('sp_rf_nda_note')}</p>
      </div>
      <div class="submit-actions">
        <button type="submit" class="btn-submit-form">${t('sp_submit_val')}</button>
        <button type="button" class="btn-remove-product" onclick="document.getElementById('sup-rfq-form-wrap').style.display='none'">${t('acc_cancel')}</button>
      </div>
    </form>`;
}

async function submitRfqDossierForm(e) {
  e.preventDefault();
  const btn = e.target.querySelector('button[type="submit"]');
  btn.disabled = true;
  try {
    const created = await supplierFetch('rfq_dossiers', {
      method: 'POST',
      headers: { 'Prefer': 'return=representation' },
      body: JSON.stringify([{
        company_id: supplierCompany.id,
        submitter_user_id: sessionStorage.getItem('sup_user_id'),
        submitter_name: supplierCompany.name,
        submitter_email: sessionStorage.getItem('sup_email'),
        title: document.getElementById('sup-rfq-title').value,
        rfq_type: document.getElementById('sup-rfq-type').value,
        category: document.getElementById('sup-rfq-category').value || null,
        industry: document.getElementById('sup-rfq-industry').value || null,
        description: document.getElementById('sup-rfq-desc').value,
        deadline: document.getElementById('sup-rfq-deadline').value || null,
      }]),
    });
    const rfqId = created[0].id;

    const fileInput = document.getElementById('sup-rfq-file');
    if (fileInput.files[0]) {
      const path = await uploadRfqFile(rfqId, fileInput.files[0]);
      await supplierFetch(`rfq_dossiers?id=eq.${rfqId}`, {
        method: 'PATCH',
        headers: { 'Prefer': 'return=minimal' },
        body: JSON.stringify({ attachment_path: path }),
      });
    }

    const ndaFileInput = document.getElementById('sup-rfq-nda-file');
    if (document.getElementById('sup-rfq-custom-nda').checked && ndaFileInput.files[0]) {
      // Voir backend/supabase_add_rfq_custom_nda_2026_09.sql -- convention
      // de chemin <rfq_id>/nda-template/<filename>, distincte du cahier
      // des charges, pour que les policies storage puissent traiter ce
      // fichier différemment (lisible dès le NDA standard accepté).
      const ndaPath = await uploadRfqFile(rfqId, ndaFileInput.files[0], 'nda-template');
      await supplierFetch(`rfq_dossiers?id=eq.${rfqId}`, {
        method: 'PATCH',
        headers: { 'Prefer': 'return=minimal' },
        body: JSON.stringify({ requires_custom_nda: true, custom_nda_template_path: ndaPath }),
      });
    }

    document.getElementById('sup-rfq-form-wrap').style.display = 'none';
    alert(t('sp_rf_sent'));
    loadSupplierRfqDossiers();
  } catch (err) {
    alert(t('acc_err_prefix') + err.message);
  } finally {
    btn.disabled = false;
  }
}

// Upload direct dans le bucket privé rfq-attachments (voir
// backend/supabase_add_rfq_system_2026_09.sql SECTION 6 et
// supabase_add_rfq_custom_nda_2026_09.sql SECTION 5 pour la convention de
// chemins) -- autorisé par la policy storage INSERT tant que le dossier
// appartient bien à l'entreprise de l'utilisateur connecté. Retourne le
// chemin uploadé, à enregistrer soi-même sur la bonne colonne ensuite.
async function uploadRfqFile(rfqId, file, subfolder) {
  const token = sessionStorage.getItem('sup_access_token');
  const path = subfolder ? `${rfqId}/${subfolder}/${encodeURIComponent(file.name)}` : `${rfqId}/${encodeURIComponent(file.name)}`;
  const res = await fetch(`${SUPABASE_URL}/storage/v1/object/rfq-attachments/${path}`, {
    method: 'POST',
    headers: {
      'apikey': SUPABASE_ANON,
      'Authorization': 'Bearer ' + token,
      'Content-Type': file.type || 'application/octet-stream',
      'x-upsert': 'true',
    },
    body: file,
  });
  if (!res.ok) throw new Error(`${t('rq_upload_fail')} (HTTP ${res.status})`);
  return path;
}

async function closeRfqDossier(rfqId) {
  if (!confirm(t('sp_rf_confirm_close'))) return;
  try {
    await supplierFetch(`rfq_dossiers?id=eq.${rfqId}`, {
      method: 'PATCH',
      headers: { 'Prefer': 'return=minimal' },
      body: JSON.stringify({ status: 'closed' }),
    });
    loadSupplierRfqDossiers();
  } catch (err) {
    alert(t('acc_err_prefix') + err.message);
  }
}

function viewRfqResponses(rfqId) {
  const wrap = document.getElementById('sup-rfq-responses-wrap');
  const dossier = supplierRfqDossiers.find(d => d.id === rfqId);
  const responses = supplierRfqResponsesByDossier[rfqId] || [];
  const statusMap = {
    sent:     { cls: 'sup-pill-pending', txt: t('sp_st_todo') },
    accepted: { cls: 'sup-pill-ok',      txt: t('acc_st_accepted') },
    rejected: { cls: 'sup-pill-no',      txt: t('acc_st_rejected') },
    invoiced: { cls: 'sup-pill-ok',      txt: t('rq_st_invoiced') },
  };
  wrap.style.display = 'block';
  wrap.innerHTML = `
    <div class="submit-section-title">${t('sp_rr_title')}${escapeHtml(dossier ? dossier.title : '')}</div>
    ${!responses.length ? `<p class="sup-empty">${t('sp_rr_none')}</p>` : responses.map(r => {
      const st = statusMap[r.status] || statusMap.sent;
      return `
      <div class="sup-lead">
        <div class="sup-lead-head">
          <span class="sup-lead-who">${escapeHtml(r.submitter_name)}</span>
          <span class="sup-pill ${st.cls}">${st.txt}</span>
        </div>
        <div class="sup-lead-meta">${escapeHtml(r.submitter_email)} · ${r.price_label ? escapeHtml(r.price_label) + ' · ' : ''}${new Date(r.created_at).toLocaleDateString(supLocale())}</div>
        <p class="sup-lead-msg">${escapeHtml(r.message)}</p>
        ${r.status === 'sent' ? `
        <div class="sup-lead-actions">
          <button class="btn-add-product sup-btn-sm" onclick="respondToRfqResponse('${r.id}','accepted','${rfqId}')">${t('sp_accept')}</button>
          <button class="btn-remove-product" onclick="respondToRfqResponse('${r.id}','rejected','${rfqId}')">${t('sp_refuse')}</button>
        </div>` : ''}
      </div>`;
    }).join('')}
    <button type="button" class="btn-remove-product" style="margin-top:10px" onclick="document.getElementById('sup-rfq-responses-wrap').style.display='none'">${t('rq_close')}</button>`;
}

async function respondToRfqResponse(id, status, rfqId) {
  try {
    await supplierFetch(`rfq_responses?id=eq.${id}`, {
      method: 'PATCH',
      headers: { 'Prefer': 'return=minimal' },
      body: JSON.stringify({ status }),
    });
    await loadSupplierRfqDossiers();
    viewRfqResponses(rfqId);
  } catch (err) {
    alert(t('acc_err_prefix') + err.message);
  }
}

// ── Vérification des NDA personnalisés reçus (voir
// backend/supabase_add_rfq_custom_nda_2026_09.sql) -- une demande par
// fournisseur, le systémier télécharge la copie signée et
// approuve/rejette. Seule une signature 'approved' débloque le contenu
// détaillé du dossier pour ce fournisseur (voir get_rfq_dossier_detail).
function viewRfqNdaSignatures(rfqId) {
  const wrap = document.getElementById('sup-rfq-nda-wrap');
  const dossier = supplierRfqDossiers.find(d => d.id === rfqId);
  const signatures = supplierRfqNdaSignaturesByDossier[rfqId] || [];
  const statusMap = {
    pending:  { cls: 'sup-pill-pending', txt: t('sp_ns_pending') },
    approved: { cls: 'sup-pill-ok',      txt: t('sp_st_approved') },
    rejected: { cls: 'sup-pill-no',      txt: t('sp_st_rejected') },
  };
  wrap.style.display = 'block';
  wrap.innerHTML = `
    <div class="submit-section-title">${t('sp_ns_title')}${escapeHtml(dossier ? dossier.title : '')}</div>
    ${!signatures.length ? `<p class="sup-empty">${t('sp_ns_none')}</p>` : signatures.map(s => {
      const st = statusMap[s.status] || statusMap.pending;
      const filename = s.signed_document_path ? s.signed_document_path.split('/').pop() : null;
      return `
      <div class="sup-lead">
        <div class="sup-lead-head">
          <span class="sup-lead-who">${escapeHtml(s.submitter_name)}</span>
          <span class="sup-pill ${st.cls}">${st.txt}</span>
        </div>
        <div class="sup-lead-meta">${escapeHtml(s.submitter_email)} · ${new Date(s.created_at).toLocaleDateString(supLocale())}</div>
        ${filename ? `<button type="button" class="btn-add-product sup-btn-sm" style="margin:6px 0" onclick="downloadRfqFileSupplier('${escapeJsAttr(s.signed_document_path)}','${escapeJsAttr(filename)}')">${t('sp_ns_dl')}</button>` : `<p style="font-size:12px;color:var(--muted)">${t('sp_ns_nodoc')}</p>`}
        ${s.status === 'pending' ? `
        <div class="sup-lead-actions">
          <button class="btn-add-product sup-btn-sm" onclick="reviewRfqNdaSignature('${s.id}','approved','${rfqId}')">${t('sp_ns_approve')}</button>
          <button class="btn-remove-product" onclick="reviewRfqNdaSignature('${s.id}','rejected','${rfqId}')">${t('sp_ns_reject')}</button>
        </div>` : ''}
      </div>`;
    }).join('')}
    <button type="button" class="btn-remove-product" style="margin-top:10px" onclick="document.getElementById('sup-rfq-nda-wrap').style.display='none'">${t('rq_close')}</button>`;
}

async function reviewRfqNdaSignature(id, status, rfqId) {
  const reason = status === 'rejected' ? (prompt(t('sp_ns_prompt')) || null) : null;
  try {
    await supplierFetch(`rfq_custom_nda_signatures?id=eq.${id}`, {
      method: 'PATCH',
      headers: { 'Prefer': 'return=minimal' },
      body: JSON.stringify({ status, rejection_reason: reason, reviewed_at: new Date().toISOString() }),
    });
    await loadSupplierRfqDossiers();
    viewRfqNdaSignatures(rfqId);
  } catch (err) {
    alert(t('acc_err_prefix') + err.message);
  }
}

// Bucket privé -- même principe de téléchargement authentifié que côté
// admin/fournisseur (voir js/pages/admin.js downloadRfqAttachmentAdmin,
// js/pages/rfq.js downloadRfqAttachment).
async function downloadRfqFileSupplier(path, filename) {
  try {
    const token = sessionStorage.getItem('sup_access_token');
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
    alert(t('rq_dl_fail') + err.message);
  }
}

// Re-rendu au changement de langue (voir js/i18n.js applyLang()) : tout le
// tableau de bord est construit en JS. Sans entreprise chargée, rien à faire.
function supplierOnLangChange() {
  if (!supplierCompany) return;
  renderSupplierStats();
  renderPremiumBox();
  loadSupplierProducts();
  loadSupplierSubmissions();
  loadSupplierLeads();
  loadSupplierViews();
  loadSupplierComparison();
  loadSupplierRfqDossiers();
}
function onLangChange() { supplierOnLangChange(); }
