// ═══════════════════════════════
// PAGE ANNUAIRE — vue split (liste + aperçu live)
// ═══════════════════════════════
let dirCurrentId = null;
const dirIsDesktop = () => window.matchMedia('(min-width:1100px)').matches;

document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  showLoading(['companies-list']);
  try {
    await loadTaxonomy();
    initChips('ann-industry-chips', INDUSTRIES, () => annIndustry, v => { annIndustry = v; renderCompanies(); });
    initChips('ann-cat-chips', PROD_CATS, () => annCat, v => { annCat = v; renderCompanies(); });
    document.getElementById('kpi-c').textContent = COMPANIES.length;
    document.getElementById('kpi-p').textContent = PRODUCTS.length;

    // Préremplissage de la recherche via ?q= (liens fabricants depuis les pages composants)
    const q = new URLSearchParams(window.location.search).get('q');
    if (q) document.getElementById('ann-search').value = q;

    renderCompanies();
  } catch (err) {
    console.error('Erreur Supabase:', err);
    showLoadError(['companies-list']);
  }
});

function filteredCompanies() {
  const q = (document.getElementById('ann-search')?.value || '').toLowerCase();
  return COMPANIES.filter(c => {
    const ms = !q || c.name.toLowerCase().includes(q) || c.country.toLowerCase().includes(q) || c.tags.some(t => t.toLowerCase().includes(q)) || c.desc.toLowerCase().includes(q);
    return ms && (annIndustry === 'all' || c.industry === annIndustry) && (annCat === 'all' || c.products.includes(annCat));
  }).sort((a,b) => { if(a.premium && !b.premium) return -1; if(!a.premium && b.premium) return 1; return a.name.localeCompare(b.name,'fr'); });
}

function renderCompanies() {
  const filtered = filteredCompanies();

  const count = document.getElementById('ann-count');
  if(count) count.innerHTML = ' · <strong>' + filtered.length + '</strong> entreprise' + (filtered.length !== 1 ? 's' : '');

  const list = document.getElementById('companies-list');
  const preview = document.getElementById('company-preview');
  if(!list) return;
  list.innerHTML = '';
  dirCurrentId = null;

  if(!filtered.length) {
    list.innerHTML = '<div class="dir-empty"><div style="font-size:28px;opacity:.4;margin-bottom:8px">🔍</div>' + (typeof t==='function'?t('ann_empty'):'Aucune entreprise ne correspond.') + '</div>';
    if(preview) preview.innerHTML = '';
    return;
  }

  filtered.forEach((c, i) => {
    const prodCount = PRODUCTS.filter(p => p.maker === c.name).length;
    const row = document.createElement('button');
    row.type = 'button';
    row.className = 'dir-row' + (c.premium ? ' is-premium' : '');
    row.setAttribute('role', 'option');
    row.style.animationDelay = (Math.min(i, 16) * 0.03) + 's';
    row.innerHTML = `
      <span class="dir-logo">${c.logo}</span>
      <span class="dir-row-main">
        <span class="dir-row-name">${c.name}</span>
        <span class="dir-row-sub">${c.country} · ${c.industry}</span>
      </span>
      <span class="dir-row-meta">${c.premium ? '<span class="star">★</span>' : ''}${prodCount ? '<span class="n">'+prodCount+'</span>' : ''}</span>`;

    const choose = () => { if(dirIsDesktop()) selectRow(row, c); else openCompanyModal(c); };
    row.addEventListener('click', choose);
    row.addEventListener('mouseenter', () => { if(dirIsDesktop()) selectRow(row, c); });
    row.addEventListener('focus',      () => { if(dirIsDesktop()) selectRow(row, c); });
    list.appendChild(row);
  });

  // sélection par défaut : 1er fabricant (desktop uniquement)
  if(dirIsDesktop()) {
    const first = list.querySelector('.dir-row');
    if(first) selectRow(first, filtered[0]);
  }
}

function selectRow(row, c) {
  const prev = document.querySelector('.dir-row.active');
  if(prev) prev.classList.remove('active');
  row.classList.add('active');
  if(dirCurrentId !== c.name) {
    dirCurrentId = c.name;
    renderCompanyPreview(c);
  }
}

function renderCompanyPreview(c) {
  const el = document.getElementById('company-preview');
  if(!el) return;
  const prods = PRODUCTS.filter(p => p.maker === c.name);

  const _t = typeof t==='function' ? t : k=>k;
  const details = [[_t('prev_founded'), c.founded], [_t('prev_employees'), c.employees], [_t('prev_sector'), c.industry], [_t('prev_hq'), c.hq]]
    .map(([l,v]) => `<div class="detail-item"><div class="detail-label">${l}</div><div class="detail-value">${v || '—'}</div></div>`).join('');

  const prodLabel = prods.length===1 ? _t('prev_products_1') : _t('prev_products_n');
  const prodsBlock = prods.length ? `
    <div class="dp-section-label">${prods.length} ${prodLabel}</div>
    <div class="dp-prods">
      ${prods.slice(0,4).map(p => `<div class="modal-prod-card"><div class="modal-prod-name">${p.icon} ${p.name}</div><div class="modal-prod-specs">${p.specs.slice(0,2).map(s => s.l+' : '+s.v).join(' · ')}</div><div class="modal-prod-price">💰 ${p.price}</div></div>`).join('')}
    </div>
    ${prods.length > 4 ? '<button class="btn-see-products" id="dp-see">'+_t('prev_see')+' '+prods.length+' '+_t('prev_see_suffix')+'</button>' : ''}` : '';

  el.innerHTML = `
    <div class="dir-preview-card">
      <div class="dp-head">
        <div class="dp-logo">${c.logo}</div>
        <div style="min-width:0">
          <div class="dp-name">${c.name}</div>
          <div class="dp-loc">${c.country} · ${c.hq}</div>
        </div>
      </div>
      <div class="dp-badges">
        ${c.premium ? '<span class="badge-premium">★ Premium</span>' : ''}
        ${c.verified ? '<span class="badge-verified">✓ Vérifié</span>' : ''}
        <span class="tag tag-industry">${c.industry}</span>
      </div>
      <p class="dp-desc">${c.desc}</p>
      <div class="dp-section-label">${_t('prev_info')}</div>
      <div class="dp-details">${details}</div>
      ${prodsBlock}
      <div class="dp-actions">
        <a class="btn-visit" href="${c.site}" target="_blank" rel="noopener">${_t('prev_visit')}</a>
        <button class="btn-quote" id="dp-quote">${_t('prev_quote')}</button>
      </div>
    </div>`;

  const quote = el.querySelector('#dp-quote');
  if(quote) quote.onclick = () => openLeadModal(c.name, null);
  const see = el.querySelector('#dp-see');
  if(see) see.onclick = () => { window.location.href = ROOT_PREFIX + 'pages/catalogue.html?company=' + encodeURIComponent(c.name); };
}

function resetAnnuaire() {
  document.getElementById('ann-search').value = '';
  annIndustry = 'all'; annCat = 'all';
  updateChips('ann-industry-chips', () => annIndustry);
  updateChips('ann-cat-chips', () => annCat);
  renderCompanies();
}
