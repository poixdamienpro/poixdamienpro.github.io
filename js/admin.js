// ═══════════════════════════════
// ADMIN — validation des soumissions fournisseur
// Accès via index.html#admin. Connexion Supabase Auth (compte créé à la
// main dans le Dashboard, voir supabase_admin_setup.sql). Les policies RLS
// restreignent l'écriture/lecture aux requêtes signées par is_admin().
// ═══════════════════════════════
let adminSubmissionsCache = {};

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
    throw new Error('Session expirée ou accès refusé — reconnecte-toi.');
  }
  if (!res.ok) throw new Error(`HTTP ${res.status} sur ${path}`);
  if (res.status === 204) return null;
  return res.json().catch(() => null);
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
    sessionStorage.setItem('admin_access_token', data.access_token);
    sessionStorage.setItem('admin_email', email);
    document.getElementById('admin-login-box').style.display = 'none';
    document.getElementById('admin-panel').style.display = 'block';
    loadPendingSubmissions();
    loadPendingClaims();
    loadPendingRfqs();
  } catch (err) {
    errBox.textContent = err.message;
    errBox.style.display = 'block';
  }
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
  loadPendingSubmissions();
  loadPendingClaims();
  loadPendingRfqs();
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
  list.innerHTML = rows.map(r => `
    <div class="admin-card" id="admin-card-${r.id}">
      <div class="admin-card-head">
        <div>
          <div class="admin-card-title">${{new:'🆕',update:'✏️',delete:'🗑️'}[r.submission_type] || '🆕'} ${r.product_name || '(produit supprimé)'} — ${r.company_name || ''}</div>
          <div class="admin-card-meta">Soumis par ${r.submitter_name || r.submitter_email} (${r.submitter_email}) le ${new Date(r.created_at).toLocaleDateString('fr-FR')} ${r.submission_type !== 'new' ? ' · type: ' + r.submission_type : ''}</div>
        </div>
        ${r.product_image_url ? `<img src="${r.product_image_url}" alt="" style="width:60px;height:60px;object-fit:cover;border-radius:6px;border:1px solid var(--border);flex-shrink:0"/>` : ''}
      </div>
      <div class="admin-field-row"><span>Catégorie</span><span>${r.product_category}</span></div>
      <div class="admin-field-row"><span>Industrie</span><span>${r.product_industry || r.company_industry || '—'}</span></div>
      <div class="admin-field-row"><span>Prix</span><span>${r.product_price_label || '—'}</span></div>
      <div class="admin-field-row"><span>Description produit</span><span>${r.product_description || '—'}</span></div>
      <div class="admin-field-row"><span>Pays / Siège</span><span>${r.company_country || '—'} · ${r.company_hq || '—'}</span></div>
      <div class="admin-field-row"><span>Site / Contact</span><span>${r.company_site || '—'} · ${r.company_contact_email || '—'}</span></div>
      <div class="admin-specs-list">
        ${(r.product_specs || []).map(s => `<div>• ${s.label} : ${s.value}</div>`).join('') || '<div>Aucune spec renseignée</div>'}
        ${(r.product_certs && r.product_certs.length) ? `<div style="margin-top:4px">Certs : ${r.product_certs.join(', ')}</div>` : ''}
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
    if (sub.submission_type === 'update') {
      await applyUpdateSubmission(sub);
    } else if (sub.submission_type === 'delete') {
      await applyDeleteSubmission(sub);
    } else {
      await applyNewSubmission(sub);
    }

    await adminFetch(`product_submissions?id=eq.${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ status: 'approved' }),
    });

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
          <div class="admin-card-title">${(r.companies && r.companies.name) || 'Entreprise inconnue'}</div>
          <div class="admin-card-meta">Demandée par ${r.user_email} le ${new Date(r.created_at).toLocaleDateString('fr-FR')}</div>
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
    await adminFetch(`companies?id=eq.${claim.company_id}`, {
      method: 'PATCH',
      body: JSON.stringify({ claimed_by_user_id: claim.user_id }),
    });
    await adminFetch(`company_claims?id=eq.${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ status: 'approved' }),
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

// ── Modération RFQ/RFI — seul l'admin lit buyer_name/email/company ──
let adminRfqsCache = {};

async function loadPendingRfqs() {
  const list = document.getElementById('admin-rfqs-list');
  list.innerHTML = '<div class="admin-empty">Chargement…</div>';
  try {
    const rows = await adminFetch('rfqs?status=eq.pending_review&order=created_at.asc');
    adminRfqsCache = {};
    (rows || []).forEach(r => { adminRfqsCache[r.id] = r; });
    renderAdminRfqs(rows || []);
  } catch (err) {
    list.innerHTML = `<div class="admin-empty">${err.message}</div>`;
  }
}

function renderAdminRfqs(rows) {
  const list = document.getElementById('admin-rfqs-list');
  if (!rows.length) {
    list.innerHTML = '<div class="admin-empty">Aucune RFQ/RFI en attente. 🎉</div>';
    return;
  }
  list.innerHTML = rows.map(r => `
    <div class="admin-card" id="admin-rfq-${r.id}">
      <div class="admin-card-head">
        <div>
          <div class="admin-card-title">${r.rfq_type === 'RFI' ? '❔' : '📋'} ${r.title}</div>
          <div class="admin-card-meta">Posté par ${r.buyer_name} (${r.buyer_email})${r.buyer_company ? ' — ' + r.buyer_company : ''} le ${new Date(r.created_at).toLocaleDateString('fr-FR')}</div>
        </div>
      </div>
      <div class="admin-field-row"><span>Industrie / Catégorie</span><span>${r.industry || '—'} / ${r.category || '—'}</span></div>
      <div class="admin-field-row"><span>Description</span><span>${r.description}</span></div>
      <div class="admin-field-row"><span>Specs souhaitées</span><span>${r.specs_needed || '—'}</span></div>
      <div class="admin-field-row"><span>Budget / Échéance</span><span>${r.budget_range || '—'} / ${r.deadline || '—'}</span></div>
      <div class="admin-actions">
        <button class="btn-approve" onclick="approveRfq('${r.id}')">✓ Publier (ouvrir aux fournisseurs)</button>
        <button class="btn-reject" onclick="rejectRfq('${r.id}')">✕ Rejeter</button>
      </div>
    </div>`).join('');
}

async function approveRfq(id) {
  const card = document.getElementById(`admin-rfq-${id}`);
  card.querySelectorAll('button').forEach(b => b.disabled = true);
  try {
    await adminFetch(`rfqs?id=eq.${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ status: 'open' }),
    });
    card.remove();
    delete adminRfqsCache[id];
    if (!Object.keys(adminRfqsCache).length) {
      document.getElementById('admin-rfqs-list').innerHTML = '<div class="admin-empty">Aucune RFQ/RFI en attente. 🎉</div>';
    }
  } catch (err) {
    alert('Erreur : ' + err.message);
    card.querySelectorAll('button').forEach(b => b.disabled = false);
  }
}

async function rejectRfq(id) {
  const card = document.getElementById(`admin-rfq-${id}`);
  card.querySelectorAll('button').forEach(b => b.disabled = true);
  try {
    await adminFetch(`rfqs?id=eq.${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ status: 'closed' }),
    });
    card.remove();
    delete adminRfqsCache[id];
    if (!Object.keys(adminRfqsCache).length) {
      document.getElementById('admin-rfqs-list').innerHTML = '<div class="admin-empty">Aucune RFQ/RFI en attente. 🎉</div>';
    }
  } catch (err) {
    alert('Erreur : ' + err.message);
    card.querySelectorAll('button').forEach(b => b.disabled = false);
  }
}

