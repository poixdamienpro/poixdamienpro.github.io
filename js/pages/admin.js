// ═══════════════════════════════
// ADMIN — validation des soumissions fournisseur
// Accès via pages/admin.html. Connexion Supabase Auth (compte créé à la
// main dans le Dashboard, voir backend/supabase_admin_setup.sql). Les
// policies RLS restreignent l'écriture/lecture aux requêtes signées par is_admin().
// ═══════════════════════════════
let adminSubmissionsCache = {};
let adminAnalyticsRows = [];

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
  if (!res.ok) throw new Error(`HTTP ${res.status} sur ${path}`);
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
    loadAnalytics();
    loadPendingSubmissions();
    loadPendingClaims();
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
  loadAnalytics();
  loadPendingSubmissions();
  loadPendingClaims();
}

// ── Analytics — vues de page anonymes loggées par js/layout.js ──
async function loadAnalytics() {
  const kpis = document.getElementById('admin-analytics-kpis');
  const top = document.getElementById('admin-analytics-top');
  kpis.innerHTML = '<div class="admin-empty">Chargement…</div>';
  top.innerHTML = '';
  try {
    adminAnalyticsRows = await adminFetchAllPages('site_page_views?select=page,created_at&order=created_at.desc');

    const select = document.getElementById('admin-chart-page-filter');
    const allPages = [...new Set(adminAnalyticsRows.map(r => r.page))].sort();
    select.innerHTML = '<option value="__all__">Toutes les pages</option>' +
      allPages.map(p => `<option value="${p}">${p}</option>`).join('');

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

// ── KPIs + top pages pour la plage sélectionnée (#admin-range-filter) ──
function renderAnalyticsForRange() {
  const kpis = document.getElementById('admin-analytics-kpis');
  const top = document.getElementById('admin-analytics-top');
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

  top.innerHTML = !topPages.length
    ? `<div class="admin-empty">Aucune vue enregistrée sur cette période (${rangeLabel}).</div>`
    : `<div class="submit-section-title" style="margin-top:0">Pages les plus vues (${rangeLabel})</div>` +
      topPages.map(([page, n]) => `<div class="admin-field-row"><span>${page}</span><span>${n} vue${n > 1 ? 's' : ''}</span></div>`).join('');

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
          <div class="admin-card-title">🏢 Modification fiche entreprise · ${r.company_name || ''}</div>
          <div class="admin-card-meta">Soumis par ${r.submitter_name || r.submitter_email} (${r.submitter_email}) le ${new Date(r.created_at).toLocaleDateString('fr-FR')}</div>
        </div>
      </div>
      <div class="admin-field-row"><span>Description</span><span>${r.company_description || '—'}</span></div>
      <div class="admin-field-row"><span>Site web</span><span>${r.company_site || '—'}</span></div>
      <div class="admin-field-row"><span>Siège</span><span>${r.company_hq || '—'}</span></div>
      <div class="admin-field-row"><span>Pays</span><span>${r.company_country || '—'}</span></div>
      <div class="admin-field-row"><span>Industrie</span><span>${r.company_industry || '—'}</span></div>
      <div class="admin-field-row"><span>Email de contact</span><span>${r.company_contact_email || '—'}</span></div>
      <div class="admin-actions">
        <button class="btn-approve" onclick="approveSubmission('${r.id}')">✓ Approuver et publier</button>
        <button class="btn-reject" onclick="rejectSubmission('${r.id}')">✕ Rejeter</button>
      </div>
    </div>` : `
    <div class="admin-card" id="admin-card-${r.id}">
      <div class="admin-card-head">
        <div>
          <div class="admin-card-title">${{new:'🆕',update:'✏️',delete:'🗑️'}[r.submission_type] || '🆕'} ${r.product_name || '(produit supprimé)'} · ${r.company_name || ''}</div>
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
      });
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

    if (claim.user_email) {
      sendTransactionalEmail('claim_approved', claim.user_email, {
        companyName: (claim.companies && claim.companies.name) || 'votre entreprise',
        link: `https://www.buy-inner.com/pages/supplier.html`,
      });
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

