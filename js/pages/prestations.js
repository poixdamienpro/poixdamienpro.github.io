// ═══════════════════════════════
// PAGE PRESTATIONS — annuaire des prestataires de services (talents,
// developpement d'equipements, faisceaux electriques, essais, usinage,
// integration), sur le meme modele que l'annuaire fabricants mais filtre
// aux categories de service uniquement.
// ═══════════════════════════════
const SERVICE_CATS = [
  'Prestation de talents',
  'Développement d\'équipements',
  'Fabrication de faisceaux électriques',
  'Essais & qualification',
  'Usinage & fabrication mécanique',
  'Intégration & assemblage système',
  // Ajoutee lors de la mise en place des grandes categories catalogue :
  // 1 des 3 produits (Spaceit) est explicitement un service ("controle de
  // mission en tant que service"), et les 2 autres (antenne/station sol
  // partagees) relevent plus de l'operation partagee que d'un composant
  // qu'un acheteur integre dans son propre systeme -- voir js/pages/catalogue.js.
  'Segment sol & opérations',
  // EMS = Electronics Manufacturing Services -- sous-traitance de
  // conception/fabrication de cartes et equipements electroniques pour
  // le compte d'autres entreprises (ex: Selha Group).
  'Sous-traitance électronique (EMS)',
];

let dirCurrentId = null;
const dirIsDesktop = () => window.matchMedia('(min-width:1100px)').matches;
let prestaIndustry = 'all';
let prestaCat = 'all';

document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  showLoading(['companies-list']);
  try {
    await loadTaxonomy();

    const serviceCompanies = COMPANIES.filter(c => c.products.some(cat => SERVICE_CATS.includes(cat)));
    const industries = [...new Set(serviceCompanies.flatMap(c => c.industries))].sort();
    const catsPresent = SERVICE_CATS.filter(cat => serviceCompanies.some(c => c.products.includes(cat)));

    initChips('presta-industry-chips', industries, () => prestaIndustry, v => { prestaIndustry = v; renderCompanies(); });
    initChips('presta-cat-chips', catsPresent, () => prestaCat, v => { prestaCat = v; renderCompanies(); });
    document.getElementById('kpi-c').textContent = serviceCompanies.length;

    const params = new URLSearchParams(window.location.search);
    const q = params.get('q');
    if (q) document.getElementById('presta-search').value = q;

    window._serviceCompanies = serviceCompanies;
    renderCompanies();
  } catch (err) {
    console.error('Erreur Supabase:', err);
    showLoadError(['companies-list']);
  }
});

function filteredCompanies() {
  const q = (document.getElementById('presta-search')?.value || '').toLowerCase();
  const base = window._serviceCompanies || [];
  return base.filter(c => {
    const ms = !q || c.name.toLowerCase().includes(q) || c.country.toLowerCase().includes(q) || c.tags.some(t => t.toLowerCase().includes(q)) || localize(c.desc, c.descEn).toLowerCase().includes(q);
    return ms && (prestaIndustry === 'all' || c.industries.includes(prestaIndustry)) && (prestaCat === 'all' || c.products.includes(prestaCat));
  }).sort((a,b) => { if(a.premium && !b.premium) return -1; if(!a.premium && b.premium) return 1; return a.name.localeCompare(b.name,'fr'); });
}

function renderCompanies() {
  const filtered = filteredCompanies();

  const count = document.getElementById('presta-count');
  if(count) count.innerHTML = ' · <strong>' + filtered.length + '</strong> ' + t(filtered.length !== 1 ? 'presta_count_many' : 'presta_count_one');

  const list = document.getElementById('companies-list');
  const preview = document.getElementById('company-preview');
  if(!list) return;
  list.innerHTML = '';
  dirCurrentId = null;

  if(!filtered.length) {
    list.innerHTML = '<div class="dir-empty"><div style="font-size:28px;opacity:.4;margin-bottom:8px">🔍</div>' + t('presta_empty') + '</div>';
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
    renderCompanyPreview(c);
  }
}

function renderCompanyPreview(c) {
  const el = document.getElementById('company-preview');
  if(!el) return;

  const details = [[t('prev_founded'), c.founded], [t('prev_employees'), c.employees], [t('prev_sector'), c.industries.join(', ')], [t('prev_hq'), c.hq]]
    .map(([l,v]) => `<div class="detail-item"><div class="detail-label">${l}</div><div class="detail-value">${v || '—'}</div></div>`).join('');

  const services = c.products.filter(cat => SERVICE_CATS.includes(cat));
  const servicesBlock = services.length ? `
    <div class="dp-section-label">${t('presta_services_label')}</div>
    <div class="cat-tags" style="margin-top:8px">${services.map(s => '<span class="cat-tag">'+s+'</span>').join('')}</div>` : '';

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
        ${c.premium ? `<span class="badge-premium">${t('badge_premium')}</span>` : ''}
        ${c.verified ? `<span class="badge-verified">${t('badge_verified')}</span>` : ''}
        ${c.industries.map(ind => `<span class="tag tag-industry">${ind}</span>`).join('')}
      </div>
      <p class="dp-desc">${localize(c.desc, c.descEn)}</p>
      <div class="dp-section-label">${t('lbl_info')}</div>
      <div class="dp-details">${details}</div>
      ${servicesBlock}
      <div class="dp-actions">
        <a class="btn-fiche" href="${ROOT_PREFIX}pages/entreprise.html?id=${encodeURIComponent(c.id)}">${t('btn_view_profile')}</a>
        <a class="btn-visit" href="${c.site}" target="_blank" rel="noopener">${t('btn_visit_short')}</a>
        <button class="btn-quote" id="dp-quote">${t('btn_request_quote')}</button>
      </div>
    </div>`;

  const quote = el.querySelector('#dp-quote');
  if(quote) quote.onclick = () => openLeadModal(c.name, null, c.id);
}

function resetPrestations() {
  document.getElementById('presta-search').value = '';
  prestaIndustry = 'all'; prestaCat = 'all';
  updateChips('presta-industry-chips', () => prestaIndustry);
  updateChips('presta-cat-chips', () => prestaCat);
  renderCompanies();
}

// Re-rendu au changement de langue (voir js/i18n.js applyLang()) : la fiche
// prestataire actuellement affichée (desc) est construite en JS, pas via
// data-i18n. Garde sur dirCurrentId : ne s'exécute qu'une fois une fiche
// déjà sélectionnée (donc COMPANIES forcément déjà chargé).
function onLangChange() {
  if (!dirCurrentId) return;
  const c = COMPANIES.find(x => x.name === dirCurrentId);
  if (c) renderCompanyPreview(c);
}
