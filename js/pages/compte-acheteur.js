// ═══════════════════════════════
// PAGE MON COMPTE (acheteur) — connexion/inscription + historique des
// demandes de devis. La logique de session vit dans js/buyer.js, chargée
// dynamiquement par loadLayout() (voir js/layout.js).
// ═══════════════════════════════
document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  renderAccountState();
});

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
  const esc = v => (v || '').replace(/"/g, '&quot;');
  view.style.display = 'none';
  wrap.style.display = 'block';
  wrap.innerHTML = `
    <form onsubmit="submitBuyerProfileForm(event)">
      <div class="lead-field"><label>Nom complet</label><input type="text" id="acc-p-name" value="${esc(p.name)}"/></div>
      <div class="lead-field"><label>Entreprise</label><input type="text" id="acc-p-company" value="${esc(p.company)}"/></div>
      <div class="submit-actions">
        <button type="submit" class="btn-submit-form">Enregistrer</button>
        <button type="button" class="btn-remove-product" onclick="closeBuyerProfileForm()">Annuler</button>
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
    alert('Erreur : ' + err.message);
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
    renderAccountState();
  } catch (err) {
    const confirmNeeded = err.message.includes('Vérifie ta boîte mail');
    showAccMessage(err.message, !confirmNeeded);
  }
}

function handleBuyerLogout() {
  buyerLogout();
  renderAccountState();
}

async function loadBuyerLeads() {
  const list = document.getElementById('acc-leads-list');
  list.innerHTML = 'Chargement…';
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
  if (!rows.length) { list.innerHTML = '<p class="sup-empty">Aucune demande envoyée pour le moment.</p>'; return; }
  const statusMap = {
    sent:     { cls: 'sup-pill-pending', txt: '⏳ En attente' },
    accepted: { cls: 'sup-pill-ok',      txt: '✓ Acceptée' },
    rejected: { cls: 'sup-pill-no',      txt: '✕ Refusée' },
  };
  list.innerHTML = rows.map(r => {
    const st = statusMap[r.status] || statusMap.sent;
    return `
      <div class="sup-lead">
        <div class="sup-lead-head">
          <span class="sup-lead-who">${r.company_name}${r.product_name ? ' · ' + r.product_name : ''}</span>
          <span class="sup-pill ${st.cls}">${st.txt}</span>
        </div>
        <div class="sup-lead-meta">${new Date(r.created_at).toLocaleDateString('fr-FR')}</div>
        <p class="sup-lead-msg">${r.message}</p>
      </div>`;
  }).join('');
}
