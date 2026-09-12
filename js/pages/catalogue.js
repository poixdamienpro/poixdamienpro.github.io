// ═══════════════════════════════
// PAGE CATALOGUE — vue split (liste + fiche live), comparateur élevé
// ═══════════════════════════════
let catCurrentId = null;
const catIsDesktop = () => window.matchMedia('(min-width:1100px)').matches;

// Hierarchie grandes categories / sous-categories (demande client 2026-09).
// Chaque sous-categorie est la vraie valeur products.category en base —
// aucune donnee n'est renommee pour construire cette hierarchie (à
// quelques exceptions pres, scindees en amont côté SQL parce qu'elles
// melangeaient des produits de nature differente : voir
// backend/supabase_reorganize_categories_2026_09.sql — "Infrastructure
// SpaceVPX" -> Routers/Traitement de données, "Stockage de données
// spatiales" -> Mémoires, "Traitement charge utile" -> Traitement de
// données — et backend/supabase_split_batteries_subcategories_2026_09.sql
// — "Batteries & Stockage" (56 produits, un seul bloc) -> Cellules
// accumulateurs / BMS / Modules batteries). Le regroupement en grande
// categorie, lui, est purement cote frontend.
const CATEGORY_GROUPS = [
  { group: 'Battery & stockage d\'énergie', cats: ['Cellules accumulateurs', 'BMS', 'Modules batteries', 'OBC (On-Board Charger)'] },
  { group: 'RF', cats: ['Communication & RF', 'Amplificateurs RF'] },
  { group: 'Intelligence embarquée', cats: ['Calculateurs embarqués', 'Calculateurs embarqués Edge IA', 'Mémoires', 'Routers', 'Traitement de données'] },
  { group: 'Capteurs & instrumentation', cats: ['Capteurs & Instrumentation', 'Capteurs ADAS', 'Navigation inertielle'] },
  { group: 'Power & distribution', cats: ['Convertisseurs & Onduleurs', 'DC/DC Converters', 'Power Supplies', 'PDU (Power Distribution)', 'Panneaux solaires'] },
  { group: 'Mobilité', cats: ['Moteurs & Entraînements', 'Électrification'] },
  { group: 'Vannes & Actionneurs', cats: ['Vannes & Actionneurs', 'Actionneurs & GNC'] },
  { group: 'Câblage & Connectique', cats: ['Câblage & Connecteurs', 'Connecteurs sous-marins'] },
  { group: 'Software', cats: ['Logiciels & Systèmes MRO', 'Logiciels de supervision'] },
  { group: 'Thermique', cats: ['Contrôle thermique'] },
  { group: 'Autres', cats: ['Manipulateurs sous-marins', 'Pièces & MRO'] },
];

// Categories exclues du catalogue produit : prestations de service (memes
// categories que js/pages/prestations.js et js/pages/carte.js — elles
// apparaissent sur la page Prestataires, pas ici) + Plateformes satellites
// et Lanceurs (ce sont des systemes complets, pas des composants
// comparables par caracteristiques ; visibles via la fiche entreprise /
// carte en attendant un onglet Systemiers dedie).
const CATALOGUE_EXCLUDED_CATS = [
  'Prestation de talents', 'Développement d\'équipements', 'Fabrication de faisceaux électriques',
  'Essais & qualification', 'Usinage & fabrication mécanique', 'Intégration & assemblage système',
  'Segment sol & opérations',
  'Lanceurs',
  'Plateformes satellites',
];

function groupOfCat(cat) {
  const g = CATEGORY_GROUPS.find(g => g.cats.includes(cat));
  return g ? g.group : null;
}

// Filtres par caractéristique (électrique/mécanique/environnemental) — voir
// backend/supabase_add_product_characteristics_2026_09.sql. charFilters ne
// contient une entrée pour une caractéristique que lorsque l'utilisateur a
// resserré la plage par rapport aux bornes réelles des données (sinon le
// filtre est un no-op et n'exclut aucun produit sans cette caractéristique).
let charFilters = {};

const AXIS_LABELS = { electrique: 'Électrique', mecanique: 'Mécanique', environnemental: 'Environnemental' };

// Filtres catégoriels (cases à cocher, pas une plage numérique) — voir
// backend/supabase_add_product_tags_2026_09.sql. "Qualification" réutilise
// le champ certs déjà riche (250/437 produits) plutôt qu'une nouvelle table ;
// "Protection" (indice IP) vient de product_tags. tagFilters[groupKey] est un
// Set des valeurs cochées ; une valeur cochée dans un groupe matche en OU, les
// groupes entre eux matchent en ET (facette classique).
let tagFilters = { qualification: new Set(), protection: new Set() };
const TAG_GROUPS = [
  { key: 'qualification', label: 'Qualification', values: p => p.certs || [] },
  { key: 'protection',    label: 'Protection (IP)', values: p => (p.productTags || []).filter(t => t.type === 'protection').map(t => t.value) },
];

document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  showLoading(['products-list']);
  try {
    await loadTaxonomy();

    const groupNames = CATEGORY_GROUPS.map(g => g.group).filter(g => CATEGORY_GROUPS.find(x => x.group === g).cats.some(c => PROD_CATS.includes(c)));
    initChips('cat-cat-chips', groupNames, () => catGroup, v => {
      catGroup = v; catSubCat = 'all'; charFilters = {}; resetTagFilters();
      renderSubCatChips(); renderCharFilters(); renderTagFilters(); renderProducts();
    });
    initChips('cat-ind-chips', INDUSTRIES, () => catInd, v => { catInd = v; charFilters = {}; resetTagFilters(); renderCharFilters(); renderTagFilters(); renderProducts(); });

    const params = new URLSearchParams(window.location.search);
    const company = params.get('company');
    if (company) document.getElementById('cat-search').value = company;

    // Préselection de catégorie via ?cat= (liens depuis les pages composants)
    // — le paramètre porte soit le nom d'une grande catégorie (ex. liens qui
    // pointaient vers "Batteries & Stockage" avant son éclatement en
    // sous-catégories), soit le nom d'une sous-catégorie (valeur réelle
    // products.category), dont on déduit alors la grande catégorie parente.
    const cat = params.get('cat');
    if (cat && CATEGORY_GROUPS.some(g => g.group === cat)) {
      catGroup = cat;
      updateChips('cat-cat-chips', () => catGroup);
    } else if (cat && !CATALOGUE_EXCLUDED_CATS.includes(cat) && PROD_CATS.includes(cat)) {
      catSubCat = cat;
      catGroup = groupOfCat(cat) || 'all';
      updateChips('cat-cat-chips', () => catGroup);
    }

    renderSubCatChips();
    renderCharFilters();
    renderTagFilters();
    renderProducts();
    updateCompareBanner();
  } catch (err) {
    console.error('Erreur Supabase:', err);
    showLoadError(['products-list']);
  }
});

// Chips de sous-catégorie (niveau 2), affichées seulement une fois une
// grande catégorie choisie — sinon mélange de sous-catégories sans rapport
// (ex. "Tous" mélangerait des vannes et des batteries).
function renderSubCatChips() {
  const wrap = document.getElementById('cat-subcat-chips');
  if (!wrap) return;
  if (catGroup === 'all') { wrap.innerHTML = ''; return; }
  const g = CATEGORY_GROUPS.find(g => g.group === catGroup);
  const subCats = (g ? g.cats : []).filter(c => PROD_CATS.includes(c));
  // Groupe à sous-catégorie unique (ex. Thermique) : pas besoin de chips de
  // niveau 2, mais on considère la sous-catégorie comme déjà sélectionnée
  // (déjà aussi précis que possible) pour que les filtres caractéristiques
  // s'affichent directement.
  if (subCats.length <= 1) { wrap.innerHTML = ''; catSubCat = subCats.length === 1 ? subCats[0] : 'all'; return; }
  wrap.innerHTML = '<div class="chip-group" id="cat-subcat-chip-group"></div>';
  initChips('cat-subcat-chip-group', subCats, () => catSubCat, v => {
    catSubCat = v; charFilters = {}; resetTagFilters();
    renderCharFilters(); renderTagFilters(); renderProducts();
  });
  updateChips('cat-subcat-chip-group', () => catSubCat);
}

// Produits filtrés par recherche/catégorie/industrie SEULEMENT (sans les
// filtres de caractéristiques) — sert de base stable pour savoir quelles
// caractéristiques proposer dans le panneau de filtres, sans que celui-ci
// ne se vide au fur et à mesure qu'on resserre les curseurs.
function baseFilteredProducts() {
  const q = (document.getElementById('cat-search')?.value || '').toLowerCase();
  return PRODUCTS.filter(p => {
    if (CATALOGUE_EXCLUDED_CATS.includes(p.cat)) return false;
    const ms = !q || p.name.toLowerCase().includes(q) || p.maker.toLowerCase().includes(q) || p.desc.toLowerCase().includes(q);
    const matchesGroup = catGroup === 'all' || groupOfCat(p.cat) === catGroup;
    const matchesSub = catSubCat === 'all' || p.cat === catSubCat;
    return ms && matchesGroup && matchesSub && (catInd === 'all' || p.industry === catInd);
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

function matchesTagFilters(p) {
  return TAG_GROUPS.every(g => {
    const selected = tagFilters[g.key];
    if (!selected || !selected.size) return true;
    const have = g.values(p);
    return have.some(v => selected.has(v));
  });
}

function resetTagFilters() {
  TAG_GROUPS.forEach(g => tagFilters[g.key].clear());
}

function filteredProducts() {
  return baseFilteredProducts().filter(p => matchesCharFilters(p) && matchesTagFilters(p));
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

  // Sur "Tous" (ou une grande catégorie encore non affinée), les
  // caractéristiques de sous-catégories très différentes (tension d'un
  // micromoteur vs d'un moteur industriel, par ex.) se mélangent en une
  // seule plage géante et perdent tout sens — on n'affiche donc le panneau
  // qu'une fois une sous-catégorie précise choisie, pour avoir des filtres
  // qui correspondent réellement au type d'équipement sélectionné.
  if (catSubCat === 'all') {
    wrap.innerHTML = `
      <div class="sidebar-divider"></div>
      <div class="sidebar-section">
        <div class="sidebar-label">Caractéristiques</div>
        <p class="char-filters-hint">Choisissez une catégorie précise ci-dessus pour filtrer par tension, masse, température…</p>
      </div>`;
    return;
  }

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

// Compte, pour chaque groupe de tags (Qualification/Protection), combien de
// produits actuellement visibles (hors filtres à tags eux-mêmes) portent
// chaque valeur — sert à afficher les cases à cocher avec un compteur et à
// ne proposer que des valeurs pertinentes pour la sélection en cours.
function computeTagFacets() {
  const base = baseFilteredProducts();
  const facets = {};
  TAG_GROUPS.forEach(g => {
    const counts = {};
    base.forEach(p => { g.values(p).forEach(v => { counts[v] = (counts[v] || 0) + 1; }); });
    facets[g.key] = counts;
  });
  return facets;
}

function renderTagFilters() {
  const wrap = document.getElementById('cat-tag-filters');
  if (!wrap) return;
  const facets = computeTagFacets();

  // Un tag porté par 1-2 produits seulement n'aide pas à filtrer (et la liste
  // de certifications a une très longue traîne de valeurs quasi uniques) —
  // on ne propose que celles qui regroupent au moins 3 produits, sauf si
  // déjà cochée (pour ne pas faire disparaître une sélection active).
  const MIN_TAG_COUNT = 3;
  const groupsHtml = TAG_GROUPS.map(g => {
    const counts = facets[g.key];
    const values = Object.keys(counts)
      .filter(v => counts[v] >= MIN_TAG_COUNT || tagFilters[g.key].has(v))
      .sort((a, b) => counts[b] - counts[a]);
    if (!values.length) return '';
    return `
    <div class="sidebar-divider"></div>
    <div class="sidebar-section">
      <div class="sidebar-label">${g.label}</div>
      <div class="tag-filter-list" data-group="${g.key}">
        ${values.map(v => `
          <label class="tag-filter-item">
            <input type="checkbox" value="${v}" ${tagFilters[g.key].has(v) ? 'checked' : ''}>
            <span>${v}</span>
            <span class="tag-filter-count">${counts[v]}</span>
          </label>`).join('')}
      </div>
    </div>`;
  }).join('');

  wrap.innerHTML = groupsHtml;

  wrap.querySelectorAll('.tag-filter-list').forEach(list => {
    const key = list.dataset.group;
    list.querySelectorAll('input[type="checkbox"]').forEach(cb => {
      cb.addEventListener('change', () => {
        if (cb.checked) tagFilters[key].add(cb.value);
        else tagFilters[key].delete(cb.value);
        renderProducts();
      });
    });
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
        <a class="btn-fiche" href="produit.html?id=${p.id}">${_t('btn_view_profile')}</a>
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
  resetTagFilters();
  renderCharFilters();
  renderTagFilters();
  renderProducts();
}

function resetCatalogue() {
  document.getElementById('cat-search').value = '';
  catGroup = 'all'; catSubCat = 'all'; catInd = 'all';
  charFilters = {};
  resetTagFilters();
  updateChips('cat-cat-chips', () => catGroup);
  updateChips('cat-ind-chips', () => catInd);
  renderSubCatChips();
  renderCharFilters();
  renderTagFilters();
  renderProducts();
}
