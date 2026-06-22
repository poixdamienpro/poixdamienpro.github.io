// ═══════════════════════════════
// COMPANY MODAL + COMPARE — réutilisés par annuaire et catalogue
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
      window.location.href = ROOT_PREFIX + 'pages/catalogue.html?company=' + encodeURIComponent(c.name);
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
  if (!banner) return;
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
