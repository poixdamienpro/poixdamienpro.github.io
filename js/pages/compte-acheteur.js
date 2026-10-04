// ═══════════════════════════════
// PAGE MON COMPTE (acheteur) — connexion/inscription + historique des
// demandes de devis. La logique de session vit dans js/buyer.js, chargée
// dynamiquement par loadLayout() (voir js/layout.js).
// ═══════════════════════════════
document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  renderAccountState();
});

// Retour vers la page d'où vient le visiteur (verrou "compte gratuit") —
// uniquement une URL du même site, jamais un lien externe.
function buyerNextUrl() {
  const next = new URLSearchParams(window.location.search).get('next');
  if (!next) return null;
  try {
    const u = new URL(next, window.location.origin);
    return u.origin === window.location.origin ? u.pathname + u.search : null;
  } catch { return null; }
}

function renderAccountState() {
  const session = buyerSession();
  document.getElementById('acc-auth-box').style.display = session ? 'none' : 'block';
  document.getElementById('acc-dashboard').style.display = session ? 'block' : 'none';
  if (session) {
    document.getElementById('acc-name').textContent = (buyerProfile && buyerProfile.name) || '—';
    document.getElementById('acc-email').textContent = (buyerProfile && buyerProfile.email) || '—';
    document.getElementById('acc-company').textContent = (buyerProfile && buyerProfile.company) || '—';
    loadBuyerLeads();
  }
}

function openBuyerProfileForm() {
  const wrap = document.getElementById('acc-profile-form-wrap');
  const view = document.getElementById('acc-profile-view');
  const p = buyerProfile || {};
  view.style.display = 'none';
  wrap.style.display = 'block';
  wrap.innerHTML = `
    <form onsubmit="submitBuyerProfileForm(event)">
      <div class="lead-field"><label>${t('acc_fullname')}</label><input type="text" id="acc-p-name" value="${escapeHtml(p.name)}"/></div>
      <div class="lead-field"><label>${t('acc_company')}</label><input type="text" id="acc-p-company" value="${escapeHtml(p.company)}"/></div>
      <div class="submit-actions">
        <button type="submit" class="btn-submit-form">${t('acc_save')}</button>
        <button type="button" class="btn-remove-product" onclick="closeBuyerProfileForm()">${t('acc_cancel')}</button>
      </div>
    </form>`;
}

function closeBuyerProfileForm() {
  document.getElementById('acc-profile-form-wrap').style.display = 'none';
  document.getElementById('acc-profile-view').style.display = '';
}

async function submitBuyerProfileForm(e) {
  e.preventDefault();
  const name = document.getElementById('acc-p-name').value;
  const company = document.getElementById('acc-p-company').value;
  try {
    const session = buyerSession();
    await buyerFetch(`buyer_profiles?user_id=eq.${session.userId}`, {
      method: 'PATCH',
      headers: { 'Prefer': 'return=minimal' },
      body: JSON.stringify({ name, company }),
    });
    buyerProfile = { ...(buyerProfile || {}), name, company };
    closeBuyerProfileForm();
    renderAccountState();
  } catch (err) {
    alert(t('acc_err_prefix') + err.message);
  }
}

function showAccMessage(msg, isError) {
  const box = document.getElementById('acc-auth-message');
  box.textContent = msg;
  box.style.color = isError ? '#C0392B' : 'var(--steel)';
  box.style.display = 'block';
}

async function handleBuyerLogin(e) {
  e.preventDefault();
  const email = document.getElementById('acc-login-email').value;
  const password = document.getElementById('acc-login-password').value;
  try {
    await buyerLogin(email, password);
    const next = buyerNextUrl();
    if (next) { window.location.href = next; return; }
    renderAccountState();
  } catch (err) {
    showAccMessage(err.message, true);
  }
}

async function handleBuyerSignup(e) {
  e.preventDefault();
  const name = document.getElementById('acc-signup-name').value;
  const company = document.getElementById('acc-signup-company').value;
  const email = document.getElementById('acc-signup-email').value;
  const password = document.getElementById('acc-signup-password').value;
  try {
    await buyerSignup(email, password, name, company);
    if (typeof window.gtag === 'function' && new URLSearchParams(window.location.search).get('src') === 'lock') {
      window.gtag('event', 'sign_up', { method: 'lock_wall' });
    }
    const next = buyerNextUrl();
    if (next) { window.location.href = next; return; }
    renderAccountState();
  } catch (err) {
    const confirmNeeded = err.code === 'confirm_email';
    showAccMessage(err.message, !confirmNeeded);
  }
}

function handleBuyerLogout() {
  buyerLogout();
  renderAccountState();
}

async function loadBuyerLeads() {
  const list = document.getElementById('acc-leads-list');
  list.innerHTML = t('acc_loading');
  try {
    const session = buyerSession();
    const rows = await buyerFetch(`leads?buyer_user_id=eq.${session.userId}&order=created_at.desc&limit=50`);
    renderBuyerLeads(rows || []);
  } catch (err) {
    list.innerHTML = `<p style="color:#E06A52;font-size:13px">${err.message}</p>`;
  }
}

function renderBuyerLeads(rows) {
  const list = document.getElementById('acc-leads-list');
  if (!rows.length) { list.innerHTML = `<p class="sup-empty">${t('acc_no_requests')}</p>`; return; }
  const statusMap = {
    sent:     { cls: 'sup-pill-pending', txt: t('acc_st_sent') },
    accepted: { cls: 'sup-pill-ok',      txt: t('acc_st_accepted') },
    rejected: { cls: 'sup-pill-no',      txt: t('acc_st_rejected') },
  };
  list.innerHTML = rows.map(r => {
    const st = statusMap[r.status] || statusMap.sent;
    return `
      <div class="sup-lead">
        <div class="sup-lead-head">
          <span class="sup-lead-who">${escapeHtml(r.company_name)}${r.product_name ? ' · ' + escapeHtml(r.product_name) : ''}</span>
          <span class="sup-pill ${st.cls}">${st.txt}</span>
        </div>
        <div class="sup-lead-meta">${new Date(r.created_at).toLocaleDateString(getLang() === 'en' ? 'en-GB' : 'fr-FR')}</div>
        <p class="sup-lead-msg">${escapeHtml(r.message)}</p>
      </div>`;
  }).join('');
}

// Re-rendu au changement de langue (voir js/i18n.js applyLang()) : l'historique
// des demandes est construit en JS, pas via data-i18n.
function onLangChange() {
  if (typeof buyerSession === 'function' && buyerSession() && document.getElementById('acc-leads-list')) loadBuyerLeads();
}
