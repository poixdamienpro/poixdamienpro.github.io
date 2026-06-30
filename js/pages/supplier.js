// ═══════════════════════════════
// ESPACE FOURNISSEUR (compte, revendication, tableau de bord)
// Toute modification passe par product_submissions — jamais d'écriture
// directe — et la revendication est toujours validée à la main par l'admin.
// ═══════════════════════════════
let supplierCompany = null; // entreprise revendiquée (si déjà approuvée)
let supplierEditingProductId = null; // null = ajout, sinon id du produit en cours d'édition
let supStatProducts = null, supStatPending = null, supStatApproved = null; // compteurs du bandeau

document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  tryRestoreSupplierSession();
});

// Met en surbrillance l'étape courante du parcours (1 Compte, 2 Revendiquer, 3 Publier)
function setSupplierStep(step) {
  const el = document.getElementById('sup-steps');
  if (el) el.setAttribute('data-step', step);
}

// Bandeau de stats du tableau de bord (valeurs réelles calculées côté client)
function renderSupplierStats() {
  const el = document.getElementById('sup-stats');
  if (!el) return;
  const fmt = v => (v === null ? '—' : v);
  el.innerHTML = `
    <div class="sup-stat"><span class="sup-stat-n">${fmt(supStatProducts)}</span><span class="sup-stat-l">Produits publiés</span></div>
    <div class="sup-stat"><span class="sup-stat-n sup-stat-pending">${fmt(supStatPending)}</span><span class="sup-stat-l">Demandes en attente</span></div>
    <div class="sup-stat"><span class="sup-stat-n sup-stat-ok">${fmt(supStatApproved)}</span><span class="sup-stat-l">Demandes approuvées</span></div>`;
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
      loadSupplierProducts();
      loadSupplierSubmissions();
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

