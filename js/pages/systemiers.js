// ═══════════════════════════════
// PAGE SYSTÉMIERS — annuaire des entreprises qui livrent un système
// complet (plateforme satellite, lanceur...) plutôt qu'un composant
// isolé -- voir blog/articles/systemier-vs-equipementier.html.
// Sur le même modèle que js/pages/prestations.js, filtré sur
// company.isSystemier au lieu d'une liste de catégories de service.
// ═══════════════════════════════
let dirCurrentId = null;
const dirIsDesktop = () => window.matchMedia('(min-width:1100px)').matches;
let sysIndustry = 'all';
let sysCat = 'all';

// Categories de produits "systeme complet" -- memes valeurs que
// CATALOGUE_EXCLUDED_CATS côté catalogue (js/pages/catalogue.js) pour
// Plateformes satellites/Lanceurs : pas des composants comparables par
// caracteristiques, donc pas dans le catalogue produit, mais bien les
// "produits" d'un systemier a afficher ici.
const SYSTEMIER_CATS = ['Plateformes satellites', 'Lanceurs'];

document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  showLoading(['companies-list']);
  try {
    await loadTaxonomy();

    const systemiers = COMPANIES.filter(c => c.isSystemier);
    const industries = [...new Set(systemiers.flatMap(c => c.industries))].sort();
    // Types de systeme : deduit des categories de produits reellement
    // portees par des systemiers (Plateformes satellites, Lanceurs...) --
    // pas une liste figee, pour suivre automatiquement l'ajout de
    // nouveaux secteurs systemiers (auto, naval...) sans toucher ce fichier.
    const catsPresent = [...new Set(systemiers.flatMap(c => c.products.filter(p => SYSTEMIER_CATS.includes(p))))].sort();

    initChips('sys-industry-chips', industries, () => sysIndustry, v => { sysIndustry = v; renderSystemiers(); });
    initChips('sys-cat-chips', catsPresent, () => sysCat, v => { sysCat = v; renderSystemiers(); });
    document.getElementById('kpi-c').textContent = systemiers.length;
    document.getElementById('kpi-p').textContent = PRODUCTS.filter(p => SYSTEMIER_CATS.includes(p.cat)).length;

    window._systemierCompanies = systemiers;
    renderSystemiers();
  } catch (err) {
    console.error('Erreur Supabase:', err);
    showLoadError(['companies-list']);
  }
});

function filteredSystemiers() {
  const q = (document.getElementById('sys-search')?.value || '').toLowerCase();
  const base = window._systemierCompanies || [];
  return base.filter(c => {
    const ms = !q || c.name.toLowerCase().includes(q) || c.country.toLowerCase().includes(q) || c.tags.some(t => t.toLowerCase().includes(q)) || c.desc.toLowerCase().includes(q);
    return ms && (sysIndustry === 'all' || c.industries.includes(sysIndustry)) && (sysCat === 'all' || c.products.includes(sysCat));
  }).sort((a,b) => { if(a.premium && !b.premium) return -1; if(!a.premium && b.premium) return 1; return a.name.localeCompare(b.name,'fr'); });
}

function renderSystemiers() {
  const filtered = filteredSystemiers();

  const count = document.getElementById('sys-count');
  if(count) count.innerHTML = ' · <strong>' + filtered.length + '</strong> systémier' + (filtered.length !== 1 ? 's' : '');

  const list = document.getElementById('companies-list');
  const preview = document.getElementById('company-preview');
  if(!list) return;
  list.innerHTML = '';
  dirCurrentId = null;

  if(!filtered.length) {
    list.innerHTML = '<div class="dir-empty"><div style="font-size:28px;opacity:.4;margin-bottom:8px">🔍</div>Aucun systémier ne correspond.</div>';
    if(preview) preview.innerHTML = '';
    return;
  }

  filtered.forEach((c, i) => {
    const row = document.createElement('button');
    row.type = 'button';
    row.className = 'dir-row' + (c.premium ? ' is-premium' : '');
    row.setAttribute('role', 'option');
    row.style.animationDelay = (Math.min(i, 16) * 0.03) + 's';
    row.innerHTML = `
      <span class="dir-logo">${companyLogoHtml(c, 34)}</span>
      <span class="dir-row-main">
        <span class="dir-row-name">${c.name}</span>
        <span class="dir-row-sub">${c.country} · ${c.industries.join(', ')}</span>
      </span>
      <span class="dir-row-meta">${c.premium ? '<span class="star">★</span>' : ''}</span>`;

    const choose = () => {
      if (dirIsDesktop()) selectRow(row, c);
      else window.location.href = ROOT_PREFIX + 'pages/entreprise.html?id=' + encodeURIComponent(c.id);
    };
    row.addEventListener('click', choose);
    row.addEventListener('mouseenter', () => { if(dirIsDesktop()) selectRow(row, c); });
    row.addEventListener('focus',      () => { if(dirIsDesktop()) selectRow(row, c); });
    list.appendChild(row);
  });

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
    renderSystemierPreview(c);
  }
}

function renderSystemierPreview(c) {
  const el = document.getElementById('company-preview');
  if(!el) return;

  const details = [['Fondée', c.founded], ['Employés', c.employees], ['Secteur', c.industries.join(', ')], ['Siège', c.hq]]
    .map(([l,v]) => `<div class="detail-item"><div class="detail-label">${l}</div><div class="detail-value">${v || '—'}</div></div>`).join('');

  // Systemes references pour cette entreprise (produits "systeme
  // complet", pas les composants qu'elle vend par ailleurs) -- avec
  // leurs specs cles, pour donner du contenu reel plutot qu'un simple
  // tag de categorie.
  const systems = PRODUCTS.filter(p => p.companyId === c.id && SYSTEMIER_CATS.includes(p.cat));
  const systemsBlock = systems.length ? `
    <div class="dp-section-label">Systèmes référencés</div>
    <div style="display:flex;flex-direction:column;gap:10px;margin-top:8px">
      ${systems.map(s => `
        <div style="border:1px solid var(--border);border-radius:8px;padding:10px 12px">
          <div style="font-weight:600;font-size:13px;margin-bottom:2px">${s.icon || '🛰️'} ${s.name}</div>
          <div style="font-size:11px;color:var(--muted);margin-bottom:6px">${s.cat}</div>
          ${s.specs.length ? `<div style="font-size:11px;color:var(--muted);line-height:1.6">${s.specs.slice(0,4).map(sp => `${sp.l} : <strong style="color:var(--ink)">${sp.v}</strong>`).join(' · ')}</div>` : ''}
        </div>`).join('')}
    </div>` : '';

  el.innerHTML = `
    <div class="dir-preview-card">
      <div class="dp-head">
        <div class="dp-logo">${companyLogoHtml(c, 52)}</div>
        <div style="min-width:0">
          <div class="dp-name">${c.name}</div>
          <div class="dp-loc">${c.country} · ${c.hq}</div>
        </div>
      </div>
      <div class="dp-badges">
        ${c.premium ? '<span class="badge-premium">★ Premium</span>' : ''}
        ${c.verified ? '<span class="badge-verified">✓ Vérifié</span>' : ''}
        <span class="tag tag-industry">🔗 Systémier</span>
        ${c.industries.map(ind => `<span class="tag tag-industry">${ind}</span>`).join('')}
      </div>
      <p class="dp-desc">${c.desc}</p>
      <div class="dp-section-label">Informations</div>
      <div class="dp-details">${details}</div>
      ${systemsBlock}
      <div class="dp-actions">
        <a class="btn-fiche" href="${ROOT_PREFIX}pages/entreprise.html?id=${encodeURIComponent(c.id)}">Voir la fiche complète →</a>
        <a class="btn-visit" href="${c.site}" target="_blank" rel="noopener">Visiter le site →</a>
        <button class="btn-quote" id="dp-quote">📩 Demander un devis</button>
      </div>
    </div>`;

  const quote = el.querySelector('#dp-quote');
  if(quote) quote.onclick = () => openLeadModal(c.name, null, c.id);
}

function resetSystemiers() {
  document.getElementById('sys-search').value = '';
  sysIndustry = 'all'; sysCat = 'all';
  updateChips('sys-industry-chips', () => sysIndustry);
  updateChips('sys-cat-chips', () => sysCat);
  renderSystemiers();
}
