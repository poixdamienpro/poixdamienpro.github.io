
// Requête générique vers l'API Supabase REST
async function supabase(table, params = '') {
  const url = `${SUPABASE_URL}/rest/v1/${table}${params ? '?' + params : ''}`;
  const res = await fetch(url, {
    headers: {
      'apikey': SUPABASE_ANON,
      'Authorization': 'Bearer ' + SUPABASE_ANON,
      'Content-Type': 'application/json',
    }
  });
  if (!res.ok) throw new Error(`Supabase ${table}: HTTP ${res.status}`);
  return res.json();
}

// Transforme une ligne company Supabase → format attendu par le HTML
function mapCompany(row) {
  return {
    name:      row.name,
    country:   row.country,
    hq:        row.hq        || '',
    industry:  row.industry,
    products:  row.categories || [],
    tags:      row.tags       || [],
    desc:      row.description || '',
    site:      row.site       || '#',
    logo:      row.logo       || '🏭',
    verified:  row.verified   || false,
    premium:   row.premium    || false,
    employees: row.employees  || 'N/A',
    founded:   row.founded    || 'N/A',
    contact:   row.contact_email || '',
  };
}

// Transforme une ligne product Supabase → format attendu par le HTML
function mapProduct(row) {
  return {
    id:       row.id,
    name:     row.name,
    maker:    row.company_name || '',
    cat:      row.category,
    industry: row.industry,
    icon:     row.icon        || '🔧',
    image:    row.image_url   || '',
    desc:     row.description || '',
    specs:    (row.specs || []).map(s => ({ l: s.label, v: s.value, premium: s.is_premium })),
    bars:     (row.bars  || []).map(b => ({ l: b.label, v: b.value, c: b.color })),
    certs:    row.certs  || [],
    price:    row.price_label || 'Sur devis',
  };
}

// ═══════════════════════════════
// CHARGEMENT DES DONNÉES
// ═══════════════════════════════
document.addEventListener('DOMContentLoaded', async () => {
  initTicker();
  showLoading();
  try {
    // Charger en parallèle les entreprises et les produits
    const [companiesRaw, productsRaw, tagsRaw, catsRaw] = await Promise.all([
      supabase('v_companies_summary', 'order=premium.desc,name.asc'),
      supabase('v_products_full',     'order=company_name.asc,name.asc'),
      supabase('company_tags',         'select=company_id,tag'),
      supabase('company_product_categories', 'select=company_id,category'),
    ]);

    // Grouper tags et catégories par company_id
    const tagsMap = {};
    tagsRaw.forEach(t => {
      if (!tagsMap[t.company_id]) tagsMap[t.company_id] = [];
      tagsMap[t.company_id].push(t.tag);
    });
    const catsMap = {};
    catsRaw.forEach(c => {
      if (!catsMap[c.company_id]) catsMap[c.company_id] = [];
      catsMap[c.company_id].push(c.category);
    });

    // Enrichir les entreprises avec leurs tags et catégories
    COMPANIES = companiesRaw.map(row => {
      row.tags       = tagsMap[row.id]  || [];
      row.categories = catsMap[row.id]  || [];
      return mapCompany(row);
    });

    PRODUCTS = productsRaw.map(mapProduct);

    // Extraire dynamiquement les listes de filtres depuis les données
    INDUSTRIES = [...new Set(COMPANIES.map(c => c.industry))].sort();
    PROD_CATS  = [...new Set(COMPANIES.flatMap(c => c.products))].sort();

    initApp();

  } catch (err) {
    console.error('Erreur Supabase:', err);
    showLoadError();
  }
});

function showLoading() {
  const msg = '<div style="grid-column:1/-1;text-align:center;padding:60px 20px">' +
    '<div style="font-size:30px;display:inline-block;animation:spin 1s linear infinite">⚙️</div>' +
    '<p style="color:var(--muted);margin-top:12px;font-size:13px">Chargement des données…</p></div>';
  ['companies-grid','products-grid'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.innerHTML = msg;
  });
}

function showLoadError() {
  const msg = '<div style="grid-column:1/-1;text-align:center;padding:60px 20px;background:var(--white);border:1px solid var(--border);border-radius:8px">' +
    '<div style="font-size:28px;margin-bottom:10px">⚠️</div>' +
    '<p style="color:var(--rust);font-weight:700;font-size:14px;margin-bottom:6px">Impossible de se connecter à Supabase</p>' +
    '<p style="color:var(--muted);font-size:12px;line-height:1.7">' +
    'Vérifie que <code>SUPABASE_URL</code> et <code>SUPABASE_ANON</code> sont correctement renseignés dans le code.<br><br>' +
    'Dans Supabase : <strong>Settings → API</strong> → copie le <em>Project URL</em> et la clé <em>anon public</em>.<br><br>' +
    'Vérifie aussi que les politiques RLS autorisent la lecture publique (policy <em>companies_read_all</em>).' +
    '</p></div>';
  ['companies-grid','products-grid'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.innerHTML = msg;
  });
}

function initApp() {
  initChips('ann-industry-chips', INDUSTRIES, () => annIndustry, v => { annIndustry = v; renderCompanies(); });
  initChips('ann-cat-chips', PROD_CATS, () => annCat, v => { annCat = v; renderCompanies(); });
  initChips('cat-cat-chips', PROD_CATS, () => catCat, v => { catCat = v; renderProducts(); });
  initChips('cat-ind-chips', INDUSTRIES, () => catInd, v => { catInd = v; renderProducts(); });
  renderCompanies();
  renderProducts();
  renderPlans();
  renderFAQ();
  document.getElementById('stat-c').textContent = COMPANIES.length;
  document.getElementById('stat-p').textContent = PRODUCTS.length;
  document.getElementById('kpi-c').textContent = COMPANIES.length;
  document.getElementById('kpi-p').textContent = PRODUCTS.length;
  document.querySelectorAll('.overlay').forEach(o => {
    o.addEventListener('click', e => { if (e.target === o) o.classList.remove('open'); });
  });

  const indList = document.getElementById('industry-list');
  if (indList) indList.innerHTML = INDUSTRIES.map(i => `<option value="${i}">`).join('');
  addProductBlock();

  if (window.location.hash === '#admin') {
    showPage('admin');
    tryRestoreAdminSession();
  }
  if (window.location.hash === '#supplier') {
    showPage('supplier');
    tryRestoreSupplierSession();
  }
}

function initTicker() {
  const text = TICKER_ITEMS.join('   ·   ');
  const el = document.getElementById('tickerText');
  el.textContent = text + '     ' + text;
}

function initChips(containerId, items, getState, setState) {
  const el = document.getElementById(containerId);
  el.innerHTML = '';
  const allBtn = document.createElement('button');
  allBtn.className = 'chip active';
  allBtn.textContent = 'Tous';
  allBtn.onclick = () => { setState('all'); updateChips(containerId, getState); };
  el.appendChild(allBtn);
  items.forEach(item => {
    const btn = document.createElement('button');
    btn.className = 'chip';
    btn.textContent = item;
    btn.onclick = () => { setState(item); updateChips(containerId, getState); };
    el.appendChild(btn);
  });
}

function updateChips(containerId, getState) {
  document.querySelectorAll('#' + containerId + ' .chip').forEach(c => {
    const isAll = c.textContent === 'Tous';
    c.classList.toggle('active', isAll ? getState() === 'all' : c.textContent === getState());
  });
}

// ═══════════════════════════════
// NAVIGATION
// ═══════════════════════════════
function showPage(pageId) {
  document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
  document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
  document.getElementById('page-' + pageId).classList.add('active');
  const link = document.querySelector('[data-page="'+pageId+'"]');
  if(link) link.classList.add('active');
  currentPage = pageId;
  window.scrollTo({top:0,behavior:'smooth'});
}

// ═══════════════════════════════
// RENDER COMPANIES
// ═══════════════════════════════
function renderCompanies() {
  const q = (document.getElementById('ann-search')?.value || '').toLowerCase();
  const filtered = COMPANIES.filter(c => {
    const ms = !q || c.name.toLowerCase().includes(q) || c.country.toLowerCase().includes(q) || c.tags.some(t => t.toLowerCase().includes(q)) || c.desc.toLowerCase().includes(q);
    return ms && (annIndustry === 'all' || c.industry === annIndustry) && (annCat === 'all' || c.products.includes(annCat));
  }).sort((a,b) => { if(a.premium && !b.premium) return -1; if(!a.premium && b.premium) return 1; return a.name.localeCompare(b.name,'fr'); });

  const count = document.getElementById('ann-count');
  if(count) count.innerHTML = ' — <strong>' + filtered.length + '</strong> entreprise' + (filtered.length !== 1 ? 's' : '');

  const grid = document.getElementById('companies-grid');
  if(!grid) return;
  grid.innerHTML = '';

  if(!filtered.length) {
    grid.innerHTML = '<div style="grid-column:1/-1;text-align:center;padding:48px;background:var(--white);border:1px solid var(--border);border-radius:8px"><div style="font-size:32px;margin-bottom:10px;opacity:.3">🔍</div><p style="color:var(--muted)">Aucune entreprise ne correspond.</p></div>';
    return;
  }

  filtered.forEach(c => {
    const prodCount = PRODUCTS.filter(p => p.maker === c.name).length;
    const card = document.createElement('div');
    card.className = 'company-card' + (c.premium ? ' premium' : '');
    card.innerHTML = `
      <div class="card-header">
        <div style="display:flex;align-items:center;gap:10px">
          <div class="card-logo">${c.logo}</div>
          <div>
            <div class="card-name">${c.name}</div>
            <div class="card-meta">${c.country} · ${c.hq}</div>
          </div>
        </div>
        <div class="card-badges">
          ${c.premium ? '<span class="badge-premium">★ Premium</span>' : ''}
          ${c.verified ? '<span class="badge-verified">✓ Vérifié</span>' : ''}
        </div>
      </div>
      <span class="tag tag-industry">${c.industry}</span>
      <p class="card-desc">${c.desc}</p>
      <div class="card-tags">${c.tags.slice(0,4).map(t => '<span class="tag">'+t+'</span>').join('')}</div>
      <div class="card-footer">
        <span class="card-site">↗ ${c.site.replace('https://','').replace('www.','')}</span>
        ${prodCount > 0 ? '<span class="card-prod-count">'+prodCount+' produit'+(prodCount>1?'s':'')+'</span>' : ''}
      </div>`;
    card.onclick = () => openCompanyModal(c);
    grid.appendChild(card);
  });
}

// ═══════════════════════════════
// RENDER PRODUCTS
// ═══════════════════════════════
function renderProducts() {
  const q = (document.getElementById('cat-search')?.value || '').toLowerCase();
  const filtered = PRODUCTS.filter(p => {
    const ms = !q || p.name.toLowerCase().includes(q) || p.maker.toLowerCase().includes(q) || p.desc.toLowerCase().includes(q);
    return ms && (catCat === 'all' || p.cat === catCat) && (catInd === 'all' || p.industry === catInd);
  });

  const count = document.getElementById('cat-count');
  if(count) count.innerHTML = ' — <strong>' + filtered.length + '</strong> produit' + (filtered.length !== 1 ? 's' : '');

  const grid = document.getElementById('products-grid');
  if(!grid) return;
  grid.innerHTML = '';

  if(!filtered.length) {
    grid.innerHTML = '<div style="grid-column:1/-1;text-align:center;padding:48px;background:var(--white);border:1px solid var(--border);border-radius:8px"><div style="font-size:32px;margin-bottom:10px;opacity:.3">🔍</div><p style="color:var(--muted)">Aucun produit ne correspond.</p></div>';
    return;
  }

  filtered.forEach(p => {
    const isSelected = compareIds.includes(p.id);

    const card = document.createElement('div');
    card.className = 'prod-card';
    card.innerHTML = `
      ${p.image ? `<img class="prod-image" src="${p.image}" alt="${p.name}" loading="lazy"/>` : ''}
      <div class="prod-card-top">
        <div class="prod-card-header">
          <div style="display:flex;align-items:flex-start;gap:10px">
            <div class="prod-icon-wrap">${p.image ? `<img src="${p.image}" alt=""/>` : p.icon}</div>
            <div>
              <div class="prod-name">${p.name}</div>
              <div class="prod-maker">
                ${p.maker}
                <span class="tag tag-industry" style="font-size:10px">${p.cat}</span>
              </div>
            </div>
          </div>
          <button class="compare-cb ${isSelected ? 'selected' : ''}" onclick="toggleCompare('${p.id}',this)" title="Comparer">${isSelected ? '✓' : ''}</button>
        </div>
        <p class="prod-desc">${p.desc}</p>
      </div>
      <div class="prod-card-body">
        <table class="spec-table">
          <tbody>
            ${p.specs.map(s => `<tr><td>${s.l}</td><td>${s.v}</td></tr>`).join('')}
          </tbody>
        </table>
        ${p.bars.map(b => `
          <div class="bar-row">
            <div class="bar-labels"><span>${b.l}</span><span style="font-weight:700">${b.v}%</span></div>
            <div class="bar-track"><div class="bar-fill" style="width:${b.v}%;background:${b.c}"></div></div>
          </div>`).join('')}
        <div class="cert-row">${p.certs.map(c => '<span class="tag tag-sage">'+c+'</span>').join('')}</div>
      </div>
      <div class="prod-card-footer">
        <span class="price-tag">💰 ${p.price}</span>
        <button class="btn-quote-sm" onclick="openLeadModal('${p.name.replace(/'/g,"\\'")}',  '${p.maker.replace(/'/g,"\\'")}')">📩 Demander un devis</button>
      </div>`;
    grid.appendChild(card);
  });
}

// ═══════════════════════════════
// COMPARE
// ═══════════════════════════════
function toggleCompare(id, btn) {
  if(compareIds.includes(id)) {
    compareIds = compareIds.filter(x => x !== id);
  } else {
    if(compareIds.length >= 4) { alert('Maximum 4 produits à la fois.'); return; }
    compareIds.push(id);
  }
  renderProducts();
  updateCompareBanner();
}

function updateCompareBanner() {
  const banner = document.getElementById('compare-banner');
  const n = compareIds.length;
  document.getElementById('compare-count').textContent = n+'/4';
  const pills = document.getElementById('compare-pills');
  pills.innerHTML = compareIds.map(id => {
    const p = PRODUCTS.find(x => x.id === id);
    if(!p) return '';
    const label = p.name.length > 20 ? p.name.slice(0,20)+'…' : p.name;
    return `<div class="compare-pill">${p.icon} ${label}<button onclick="toggleCompare('${id}')">✕</button></div>`;
  }).join('');
  banner.classList.toggle('visible', n >= 2);
}

function openCompareModal() {
  const prods = compareIds.map(id => PRODUCTS.find(p => p.id === id)).filter(Boolean);
  const allLabels = [...new Set(prods.flatMap(p => p.specs.map(s => s.l)))];
  const allBars   = [...new Set(prods.flatMap(p => p.bars.map(b => b.l)))];

  const hCols = prods.map(p => `<th class="prod-col"><div style="display:flex;flex-direction:column;align-items:center;gap:3px"><span style="font-size:18px">${p.icon}</span><strong style="font-size:11px">${p.name}</strong><span style="font-size:10px;opacity:.8">${p.maker}</span></div></th>`).join('');

  const specRows = allLabels.map((label) => {
    const cells = prods.map(p => {
      const s = p.specs.find(x => x.l === label);
      return `<td>${s ? s.v : '—'}</td>`;
    }).join('');
    return `<tr><td class="row-label">${label}</td>${cells}</tr>`;
  }).join('');

  const barRows = allBars.map(label => {
    const vals = prods.map(p => { const b = p.bars.find(x => x.l === label); return b ? b.v : null; });
    const max = Math.max(...vals.filter(v => v !== null));
    const min = Math.min(...vals.filter(v => v !== null));
    const cells = prods.map((p,i) => {
      const v = vals[i];
      const cls = v === max ? 'cmp-best' : v === min ? 'cmp-worst' : '';
      return `<td class="${cls}">${v !== null ? v+'%' : '—'}</td>`;
    }).join('');
    return `<tr><td class="row-label">📊 ${label}</td>${cells}</tr>`;
  }).join('');

  const certRow = `<tr><td class="row-label">Certifications</td>${prods.map(p => '<td style="font-size:11px">'+p.certs.join(', ')+'</td>').join('')}</tr>`;
  const priceRow = `<tr><td class="row-label">Prix indicatif</td>${prods.map(p => '<td style="font-weight:700;color:var(--sage)">'+p.price+'</td>').join('')}</tr>`;

  document.getElementById('compare-table-wrap').innerHTML = `
    <table class="cmp-table">
      <thead><tr><th style="min-width:150px">Critère</th>${hCols}</tr></thead>
      <tbody>
        <tr><td class="row-label cmp-section" colspan="${prods.length+1}">Spécifications techniques</td></tr>
        ${specRows}
        <tr><td class="row-label cmp-section" colspan="${prods.length+1}">Scores relatifs</td></tr>
        ${barRows}
        <tr><td class="row-label cmp-section" colspan="${prods.length+1}">Prix & Certifications</td></tr>
        ${priceRow}${certRow}
      </tbody>
    </table>
    <p style="font-size:11px;color:var(--muted);margin-top:10px">🟢 Meilleure valeur · 🔴 Valeur la plus basse</p>`;

  document.getElementById('compare-overlay').classList.add('open');
}

// ═══════════════════════════════
// COMPANY MODAL
// ═══════════════════════════════
function openCompanyModal(c) {
  document.getElementById('m-logo').textContent = c.logo;
  document.getElementById('m-name').textContent = c.name;
  document.getElementById('m-location').textContent = c.country + ' · ' + c.hq;

  const badges = document.getElementById('m-badges');
  badges.innerHTML = (c.premium ? '<span class="badge-premium">★ Premium</span>' : '') +
    (c.verified ? '<span class="badge-verified">✓ Vérifié</span>' : '') +
    '<span class="tag tag-industry">'+c.industry+'</span>';

  const claimBanner = document.getElementById('m-claim-banner');
  if(!c.premium) {
    document.getElementById('m-claim-name').textContent = c.name;
    claimBanner.style.display = 'flex';
  } else {
    claimBanner.style.display = 'none';
  }

  document.getElementById('m-desc').textContent = c.desc;

  document.getElementById('m-details').innerHTML = [
    ['Fondée en', c.founded], ['Effectifs', c.employees],
    ['Secteur', c.industry], ['Siège', c.hq]
  ].map(([l,v]) => `<div class="detail-item"><div class="detail-label">${l}</div><div class="detail-value">${v}</div></div>`).join('');

  document.getElementById('m-tags').innerHTML =
    [...c.products, ...c.tags].map(t => '<span class="tag">'+t+'</span>').join('');

  const compProds = PRODUCTS.filter(p => p.maker === c.name);
  const prodsSection = document.getElementById('m-prods-section');
  const prodsGrid = document.getElementById('m-prods');
  const seeBtn = document.getElementById('m-see-products-btn');

  if(compProds.length === 0) {
    prodsSection.style.display = 'none';
  } else {
    prodsSection.style.display = 'block';
    prodsGrid.innerHTML = compProds.map(p => `
      <div class="modal-prod-card">
        <div class="modal-prod-name">${p.icon} ${p.name}</div>
        <div class="modal-prod-specs">${p.specs.slice(0,2).map(s => s.l+' : '+s.v).join(' · ')}</div>
        <div class="modal-prod-price">💰 ${p.price}</div>
      </div>`).join('');
    seeBtn.onclick = () => {
      closeModal('company-overlay');
      document.getElementById('cat-search').value = c.name;
      catCat = 'all'; catInd = 'all';
      renderProducts();
      showPage('catalogue');
    };
  }

  document.getElementById('m-site').href = c.site;
  document.getElementById('m-site').textContent = '↗ Visiter le site officiel';

  document.getElementById('m-quote-btn').onclick = () => {
    closeModal('company-overlay');
    openLeadModal(c.name, null);
  };

  document.getElementById('company-overlay').classList.add('open');
}

function closeModal(id) {
  document.getElementById(id).classList.remove('open');
}
// ═══════════════════════════════
// RENDER PLANS
// ═══════════════════════════════
function renderPlans() {
  const grid = document.getElementById('plans-grid');
  if(!grid) return;
  grid.innerHTML = PLANS.map(plan => `
    <div class="plan-card ${plan.highlight ? 'highlight' : ''}">
      ${plan.highlight ? '<div class="plan-popular">LE PLUS POPULAIRE</div>' : ''}
      <div class="plan-name">${plan.name}</div>
      <div class="plan-price">${plan.price}</div>
      <div class="plan-period">${plan.period}</div>
      <p class="plan-desc">${plan.desc}</p>
      <button class="plan-cta ${plan.ctaClass}" onclick="showPage('${plan.target || 'annuaire'}')">${plan.cta}</button>
      <div class="plan-divider"></div>
      <div class="plan-features">
        ${plan.features.map(f => `<div class="plan-feature ${f.ok ? 'ok' : 'no'}"><span class="plan-feature-icon">${f.ok ? '✓' : '✕'}</span><span>${f.text}</span></div>`).join('')}
      </div>
    </div>`).join('');
}

function renderFAQ() {
  const el = document.getElementById('faq-list');
  if(!el) return;
  el.innerHTML = FAQ.map(f => `
    <div class="faq-item">
      <div class="faq-q">${f.q}</div>
      <div class="faq-a">${f.a}</div>
    </div>`).join('');
}

function resetAnnuaire() {
  document.getElementById('ann-search').value = '';
  annIndustry = 'all'; annCat = 'all';
  updateChips('ann-industry-chips', () => annIndustry);
  updateChips('ann-cat-chips', () => annCat);
  renderCompanies();
}

function resetCatalogue() {
  document.getElementById('cat-search').value = '';
  catCat = 'all'; catInd = 'all';
  updateChips('cat-cat-chips', () => catCat);
  updateChips('cat-ind-chips', () => catInd);
  renderProducts();
}
