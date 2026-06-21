// ═══════════════════════════════
// ESPACE FOURNISSEUR (compte, revendication, tableau de bord)
// Toute modification passe par product_submissions — jamais d'écriture
// directe — et la revendication est toujours validée à la main par l'admin.
// ═══════════════════════════════
let supplierCompany = null; // entreprise revendiquée (si déjà approuvée)
let supplierEditingProductId = null; // null = ajout, sinon id du produit en cours d'édition

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
    throw new Error('Session expirée ou accès refusé — reconnecte-toi.');
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
  document.getElementById('sup-auth-box').style.display = 'block';
  document.getElementById('sup-claim-box').style.display = 'none';
  document.getElementById('sup-pending-box').style.display = 'none';
  document.getElementById('sup-dashboard').style.display = 'none';
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
      loadSupplierProducts();
      loadSupplierSubmissions();
      loadSupplierRfqs();
      return;
    }
    const claims = await supplierFetch(`company_claims?user_id=eq.${userId}&status=eq.pending&select=*,companies(name)&order=created_at.desc&limit=1`);
    if (claims && claims.length) {
      document.getElementById('sup-pending-company').textContent = (claims[0].companies && claims[0].companies.name) || '';
      document.getElementById('sup-claim-box').style.display = 'none';
      document.getElementById('sup-pending-box').style.display = 'block';
      document.getElementById('sup-dashboard').style.display = 'none';
      return;
    }
    document.getElementById('sup-claim-box').style.display = 'block';
    document.getElementById('sup-pending-box').style.display = 'none';
    document.getElementById('sup-dashboard').style.display = 'none';
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
  } catch (err) {
    alert('Erreur : ' + err.message);
  }
}

async function loadSupplierProducts() {
  const list = document.getElementById('sup-products-list');
  list.innerHTML = 'Chargement…';
  try {
    const products = await supplierFetch(`products?company_id=eq.${supplierCompany.id}&select=*`);
    if (!products || !products.length) { list.innerHTML = '<p style="font-size:13px;color:var(--muted)">Aucun produit pour le moment.</p>'; return; }
    list.innerHTML = products.map(p => `
      <div class="admin-field-row">
        <span>${p.name} — ${p.category}</span>
        <span>
          <button class="btn-add-product" style="padding:6px 14px;font-size:12px" onclick="openSupplierProductForm('${p.id}')">Modifier</button>
          <button class="btn-remove-product" onclick="requestDeleteProduct('${p.id}','${p.name.replace(/'/g, "\\'")}')">Supprimer</button>
        </span>
      </div>`).join('');
  } catch (err) {
    list.innerHTML = `<p style="color:#C0392B;font-size:13px">${err.message}</p>`;
  }
}

async function loadSupplierSubmissions() {
  const list = document.getElementById('sup-submissions-list');
  list.innerHTML = 'Chargement…';
  try {
    const rows = await supplierFetch(`product_submissions?company_id=eq.${supplierCompany.id}&order=created_at.desc&limit=20`);
    if (!rows || !rows.length) { list.innerHTML = '<p style="font-size:13px;color:var(--muted)">Aucune demande envoyée.</p>'; return; }
    const labels = { new: 'Ajout', update: 'Modification', delete: 'Suppression' };
    const statusLabels = { pending: '⏳ En attente', approved: '✓ Approuvée', rejected: '✕ Rejetée' };
    list.innerHTML = rows.map(r => `
      <div class="admin-field-row">
        <span>${labels[r.submission_type] || r.submission_type} — ${r.product_name || ''}</span>
        <span>${statusLabels[r.status] || r.status}</span>
      </div>`).join('');
  } catch (err) {
    list.innerHTML = `<p style="color:#C0392B;font-size:13px">${err.message}</p>`;
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

// ── RFQ/RFI — réservé aux fournisseurs Premium (companies.premium = true) ──
// Lecture de v_rfqs_public (anon/authenticated autorisés), écriture dans
// rfq_responses bloquée côté RLS si la société n'est pas Premium — voir
// supabase_add_rfq_feature.sql, policy "premium_owner_can_respond".
async function loadSupplierRfqs() {
  const note = document.getElementById('sup-rfq-premium-note');
  const list = document.getElementById('sup-rfq-list');
  note.textContent = supplierCompany.premium
    ? 'Vous pouvez répondre directement aux RFQ/RFI ouvertes ci-dessous.'
    : "Réservé aux fournisseurs Premium. Vous pouvez consulter les besoins ouverts, mais l'envoi d'une propale nécessite le plan Premium.";
  list.innerHTML = 'Chargement…';
  try {
    const rows = await supplierFetch('v_rfqs_public?order=created_at.desc');
    if (!rows || !rows.length) { list.innerHTML = '<p style="font-size:13px;color:var(--muted)">Aucune RFQ/RFI ouverte pour le moment.</p>'; return; }
    list.innerHTML = rows.map(r => `
      <div class="admin-card">
        <div class="admin-card-head">
          <div>
            <div class="admin-card-title">${r.rfq_type === 'RFI' ? '❔' : '📋'} ${r.title}</div>
            <div class="admin-card-meta">${r.rfq_type} ${r.industry ? '· ' + r.industry : ''} ${r.category ? '· ' + r.category : ''} · publiée le ${new Date(r.created_at).toLocaleDateString('fr-FR')}</div>
          </div>
        </div>
        <div class="admin-field-row"><span>Description</span><span>${r.description}</span></div>
        ${r.specs_needed ? `<div class="admin-field-row"><span>Specs souhaitées</span><span>${r.specs_needed}</span></div>` : ''}
        ${r.budget_range ? `<div class="admin-field-row"><span>Budget</span><span>${r.budget_range}</span></div>` : ''}
        <div class="admin-actions">
          ${supplierCompany.premium
            ? `<button class="btn-approve" onclick="openSupplierRfqResponseForm('${r.id}','${r.title.replace(/'/g, "\\'")}')">📩 Répondre</button>`
            : `<button class="btn-approve" onclick="showPage('pricing')" style="background:var(--muted)">★ Passer Premium pour répondre</button>`}
        </div>
      </div>`).join('');
  } catch (err) {
    list.innerHTML = `<p style="color:#C0392B;font-size:13px">${err.message}</p>`;
  }
}

function openSupplierRfqResponseForm(rfqId, rfqTitle) {
  const wrap = document.getElementById('sup-rfq-form-wrap');
  wrap.style.display = 'block';
  wrap.innerHTML = `
    <div class="submit-section-title">Propale — ${rfqTitle}</div>
    <form onsubmit="submitSupplierRfqResponse(event, '${rfqId}')">
      <div class="submit-grid">
        <div class="lead-field"><label>Prix proposé</label><input type="text" id="sup-rfq-price" placeholder="ex: 4 800 € HT ou Sur devis"/></div>
        <div class="lead-field"><label>Délai</label><input type="text" id="sup-rfq-leadtime" placeholder="ex: 6 semaines"/></div>
      </div>
      <div class="lead-field"><label>Message / propale</label><textarea id="sup-rfq-message" required placeholder="Décrivez votre offre, vos références, vos conditions…"></textarea></div>
      <div class="lead-field"><label>Document joint (URL, optionnel)</label><input type="url" id="sup-rfq-attachment" placeholder="https://…"/></div>
      <div class="submit-actions">
        <button type="submit" class="btn-submit-form">Envoyer ma propale</button>
        <button type="button" class="btn-remove-product" onclick="document.getElementById('sup-rfq-form-wrap').style.display='none'">Annuler</button>
      </div>
    </form>`;
}

async function submitSupplierRfqResponse(e, rfqId) {
  e.preventDefault();
  try {
    await supplierFetch('rfq_responses', {
      method: 'POST',
      headers: { 'Prefer': 'return=minimal' },
      body: JSON.stringify([{
        rfq_id: rfqId,
        company_id: supplierCompany.id,
        submitter_user_id: sessionStorage.getItem('sup_user_id'),
        quote_price: document.getElementById('sup-rfq-price').value || null,
        lead_time: document.getElementById('sup-rfq-leadtime').value || null,
        message: document.getElementById('sup-rfq-message').value,
        attachment_url: document.getElementById('sup-rfq-attachment').value || null,
      }]),
    });
    document.getElementById('sup-rfq-form-wrap').style.display = 'none';
    alert('Propale envoyée. L\'acheteur la consultera via son lien privé de suivi — vous ne recevrez jamais ses coordonnées directement.');
  } catch (err) {
    alert('Erreur : ' + err.message + (err.message.includes('403') ? ' (le plan Premium est requis pour répondre aux RFQ)' : ''));
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

