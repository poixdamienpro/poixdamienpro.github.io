// ═══════════════════════════════
// PAGE CATALOGUE — vue split (liste + fiche live), comparateur élevé
// ═══════════════════════════════
let catCurrentId = null;
const catIsDesktop = () => window.matchMedia('(min-width:1100px)').matches;

// Filtres par caractéristique (électrique/mécanique/environnemental) — voir
// backend/supabase_add_product_characteristics_2026_09.sql. charFilters ne
// contient une entrée pour une caractéristique que lorsque l'utilisateur a
// resserré la plage par rapport aux bornes réelles des données (sinon le
// filtre est un no-op et n'exclut aucun produit sans cette caractéristique).
let charFilters = {};

const AXIS_LABELS = { electrique: 'Électrique', mecanique: 'Mécanique', environnemental: 'Environnemental' };

document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  showLoading(['products-list']);
  try {
    await loadTaxonomy();
    initChips('cat-cat-chips', PROD_CATS, () => catCat, v => { catCat = v; charFilters = {}; renderCharFilters(); renderProducts(); });
    initChips('cat-ind-chips', INDUSTRIES, () => catInd, v => { catInd = v; charFilters = {}; renderCharFilters(); renderProducts(); });

    const params = new URLSearchParams(window.location.search);
    const company = params.get('company');
    if (company) document.getElementById('cat-search').value = company;

    // Préselection de catégorie via ?cat= (liens depuis les pages composants)
    const cat = params.get('cat');
    if (cat && PROD_CATS.includes(cat)) { catCat = cat; updateChips('cat-cat-chips', () => catCat); }

    renderCharFilters();
    renderProducts();
    updateCompareBanner();
  } catch (err) {
    console.error('Erreur Supabase:', err);
    showLoadError(['products-list']);
  }
});

// Produits filtrés par recherche/catégorie/industrie SEULEMENT (sans les
// filtres de caractéristiques) — sert de base stable pour savoir quelles
// caractéristiques proposer dans le panneau de filtres, sans que celui-ci
// ne se vide au fur et à mesure qu'on resserre les curseurs.
function baseFilteredProducts() {
  const q = (document.getElementById('cat-search')?.value || '').toLowerCase();
  return PRODUCTS.filter(p => {
    const ms = !q || p.name.toLowerCase().includes(q) || p.maker.toLowerCase().includes(q) || p.desc.toLowerCase().includes(q);
    return ms && (catCat === 'all' || p.cat === catCat) && (catInd === 'all' || p.industry === catInd);
  });
}

function matchesCharFilters(p) {
  const keys = Object.keys(charFilters);
  if (!keys.length) return true;
  return keys.every(key => {
    const f = charFilters[key];
    const c = (p.characteristics || []).find(x => x.characteristic === key);
    if (!c) return false; // caractéristique non renseignée pour ce produit → exclu si un filtre actif la cible
    return c.max >= f.min && c.min <= f.max; // chevauchement de plages
  });
}

function filteredProducts() {
  return baseFilteredProducts().filter(matchesCharFilters);
}

// Construit, pour chaque caractéristique présente parmi les produits
// actuellement visibles (hors filtres de caractéristiques eux-mêmes), les
// bornes réelles [min,max] observées dans les données — utilisées comme
// bornes du curseur.
function computeCharBounds() {
  const base = baseFilteredProducts();
  const bounds = {};
  base.forEach(p => {
    (p.characteristics || []).forEach(c => {
      if (!bounds[c.characteristic]) {
        bounds[c.characteristic] = { axis: c.axis, label: c.label, unit: c.unit, dataMin: c.min, dataMax: c.max };
      } else {
        const b = bounds[c.characteristic];
        if (c.min < b.dataMin) b.dataMin = c.min;
        if (c.max > b.dataMax) b.dataMax = c.max;
      }
    });
  });
  return bounds;
}

function niceStep(range) {
  if (!isFinite(range) || range <= 0) return 1;
  const raw = range / 200;
  const pow = Math.pow(10, Math.floor(Math.log10(raw)));
  const n = raw / pow;
  const step = (n <= 1 ? 1 : n <= 2 ? 2 : n <= 5 ? 5 : 10) * pow;
  return step;
}

function fmtCharVal(v) {
  if (Math.abs(v) >= 100) return Math.round(v).toLocaleString('fr-FR');
  if (Math.abs(v) >= 10) return (Math.round(v * 10) / 10).toLocaleString('fr-FR');
  return (Math.round(v * 1000) / 1000).toLocaleString('fr-FR');
}

function renderCharFilters() {
  const wrap = document.getElementById('cat-char-filters');
  if (!wrap) return;
  const bounds = computeCharBounds();
  const keys = Object.keys(bounds);

  if (!keys.length) { wrap.innerHTML = ''; return; }

  const byAxis = {};
  keys.forEach(k => { (byAxis[bounds[k].axis] = byAxis[bounds[k].axis] || []).push(k); });

  wrap.innerHTML = Object.keys(byAxis).map(axis => `
    <div class="sidebar-divider"></div>
    <div class="sidebar-section">
      <div class="sidebar-label">${AXIS_LABELS[axis] || axis}</div>
      ${byAxis[axis].map(key => {
        const b = bounds[key];
        const cur = charFilters[key] || { min: b.dataMin, max: b.dataMax };
        const step = niceStep(b.dataMax - b.dataMin) || 1;
        return `
        <div class="range-filter" data-char="${key}">
          <div class="range-filter-head">
            <span>${b.label} (${b.unit})</span>
            <span class="range-filter-vals"><span class="rf-min">${fmtCharVal(cur.min)}</span> – <span class="rf-max">${fmtCharVal(cur.max)}</span></span>
          </div>
          <div class="range-track">
            <input type="range" class="range-input range-min" min="${b.dataMin}" max="${b.dataMax}" step="${step}" value="${cur.min}">
            <input type="range" class="range-input range-max" min="${b.dataMin}" max="${b.dataMax}" step="${step}" value="${cur.max}">
          </div>
        </div>`;
      }).join('')}
    </div>
  `).join('');

  wrap.querySelectorAll('.range-filter').forEach(box => {
    const key = box.dataset.char;
    const b = bounds[key];
    const minInput = box.querySelector('.range-min');
    const maxInput = box.querySelector('.range-max');
    const rfMin = box.querySelector('.rf-min');
    const rfMax = box.querySelector('.rf-max');

    const apply = () => {
      let vMin = parseFloat(minInput.value);
      let vMax = parseFloat(maxInput.value);
      if (vMin > vMax) { [vMin, vMax] = [vMax, vMin]; minInput.value = vMin; maxInput.value = vMax; }
      rfMin.textContent = fmtCharVal(vMin);
      rfMax.textContent = fmtCharVal(vMax);
      if (vMin <= b.dataMin && vMax >= b.dataMax) delete charFilters[key];
      else charFilters[key] = { min: vMin, max: vMax };
      renderProducts();
    };
    minInput.addEventListener('input', apply);
    maxInput.addEventListener('input', apply);
  });
}

function renderProducts() {
  const filtered = filteredProducts();

  const count = document.getElementById('cat-count');
  if(count) count.innerHTML = ' · <strong>' + filtered.length + '</strong> produit' + (filtered.length !== 1 ? 's' : '');

  const list = document.getElementById('products-list');
  const preview = document.getElementById('product-preview');
  if(!list) return;
  list.innerHTML = '';
  catCurrentId = null;

  if(!filtered.length) {
    list.innerHTML = '<div class="dir-empty"><div style="font-size:28px;opacity:.4;margin-bottom:8px">🔍</div>' + (typeof t==='function'?t('cat_empty'):'Aucun produit ne correspond.') + '</div>';
    if(preview) preview.innerHTML = '';
    return;
  }

  filtered.forEach((p, i) => {
    const inCompare = compareIds.includes(p.id);
    const row = document.createElement('button');
    row.type = 'button';
    row.className = 'dir-row';
    row.setAttribute('role', 'option');
    row.style.animationDelay = (Math.min(i, 16) * 0.03) + 's';
    row.innerHTML = `
      <span class="dir-logo">${p.image ? `<img src="${p.image}" alt="" style="width:100%;height:100%;object-fit:cover;border-radius:6px"/>` : p.icon}</span>
      <span class="dir-row-main">
        <span class="dir-row-name">${p.name}</span>
        <span class="dir-row-sub">${p.maker} · ${p.cat}</span>
      </span>
      <button class="dir-cmp ${inCompare ? 'on' : ''}" data-cmp="${p.id}" title="Ajouter au comparateur">${inCompare ? '✓' : '＋'}</button>`;

    row.addEventListener('click', () => selectRow(row, p));
    row.addEventListener('mouseenter', () => { if(catIsDesktop()) selectRow(row, p); });
    row.addEventListener('focus',      () => { if(catIsDesktop()) selectRow(row, p); });
    const cmp = row.querySelector('.dir-cmp');
    cmp.addEventListener('click', e => { e.stopPropagation(); toggleCompare(p.id, cmp); });
    list.appendChild(row);
  });

  if(catIsDesktop()) {
    const first = list.querySelector('.dir-row');
    if(first) selectRow(first, filtered[0]);
  }
}

function selectRow(row, p) {
  const prev = document.querySelector('.dir-row.active');
  if(prev) prev.classList.remove('active');
  row.classList.add('active');
  if(catCurrentId !== p.id) {
    catCurrentId = p.id;
    renderProductPreview(p);
  }
  if(!catIsDesktop()) document.getElementById('product-preview').classList.add('open');
}

function renderProductPreview(p) {
  const el = document.getElementById('product-preview');
  if(!el) return;
  const inCompare = compareIds.includes(p.id);

  const specs = p.specs.map(s => `<tr><td>${s.l}</td><td>${s.v}</td></tr>`).join('');

  const _t = typeof t==='function' ? t : k=>k;
  const bars = (p.bars || []).length ? `
    <div class="dp-section-label">${_t('prod_scores')}</div>
    <div class="dir-bars">
      ${p.bars.map(b => `
        <div class="dir-bar">
          <div class="dir-bar-top"><span>${b.l}</span><span class="dir-bar-val">${b.v}%</span></div>
          <div class="dir-bar-track"><div class="dir-bar-fill" style="--w:${b.v}%;background:${b.c}"></div></div>
        </div>`).join('')}
    </div>` : '';

  const certs = (p.certs || []).length ? `
    <div class="dp-section-label">${_t('prod_certs')}</div>
    <div class="cert-row" style="margin-bottom:14px">${p.certs.map(c => '<span class="tag tag-sage">'+c+'</span>').join('')}</div>` : '';

  el.innerHTML = `
    <div class="dir-preview-card">
      <button class="dir-close" aria-label="Fermer l'aperçu">✕</button>
      <div class="dp-head">
        <div class="dp-logo">${p.image ? `<img src="${p.image}" alt="" style="width:100%;height:100%;object-fit:cover;border-radius:9px"/>` : p.icon}</div>
        <div style="min-width:0">
          <div class="dp-name">${p.name}</div>
          <div class="dp-loc">${p.maker} · ${p.cat}</div>
        </div>
      </div>
      <div class="dp-badges"><span class="tag tag-industry">${p.industry}</span></div>
      <p class="dp-desc">${p.desc}</p>
      <div class="dp-section-label">${_t('prod_specs')}</div>
      <table class="spec-table"><tbody>${specs}</tbody></table>
      ${bars}
      ${certs}
      <div class="dp-price"><span class="price-tag">💰 ${p.price}</span></div>
      <div class="dp-actions">
        <a class="btn-fiche" href="produit.html?id=${p.id}">Voir la fiche complète →</a>
        ${p.datasheetUrl ? `<a class="btn-datasheet-dark" href="${p.datasheetUrl}" target="_blank" rel="noopener">📄 Datasheet</a>` : ''}
        <button class="btn-cmp-add ${inCompare ? 'on' : ''}" data-cmp="${p.id}">${inCompare ? _t('prod_compare_in') : _t('prod_compare_add')}</button>
        <button class="btn-quote" id="dp-quote">${_t('prod_quote')}</button>
      </div>
    </div>`;

  // animation des barres : on part de 0 puis on remplit vers la cible
  requestAnimationFrame(() => requestAnimationFrame(() => {
    el.querySelectorAll('.dir-bar-fill').forEach(f => { f.style.width = f.style.getPropertyValue('--w'); });
  }));

  el.querySelector('#dp-quote').onclick = () => openLeadModal(p.maker, p.name, p.companyId);
  el.querySelector('.btn-cmp-add').onclick = function() { toggleCompare(p.id, this); };
  const close = el.querySelector('.dir-close');
  if(close) close.onclick = () => el.classList.remove('open');
}

function onCatSearchInput() {
  charFilters = {};
  renderCharFilters();
  renderProducts();
}

function resetCatalogue() {
  document.getElementById('cat-search').value = '';
  catCat = 'all'; catInd = 'all';
  charFilters = {};
  updateChips('cat-cat-chips', () => catCat);
  updateChips('cat-ind-chips', () => catInd);
  renderCharFilters();
  renderProducts();
}
