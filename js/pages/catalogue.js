// ═══════════════════════════════
// PAGE CATALOGUE
// ═══════════════════════════════
document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  showLoading(['products-grid']);
  try {
    await loadTaxonomy();
    initChips('cat-cat-chips', PROD_CATS, () => catCat, v => { catCat = v; renderProducts(); });
    initChips('cat-ind-chips', INDUSTRIES, () => catInd, v => { catInd = v; renderProducts(); });

    const company = new URLSearchParams(window.location.search).get('company');
    if (company) document.getElementById('cat-search').value = company;

    renderProducts();
    updateCompareBanner();
  } catch (err) {
    console.error('Erreur Supabase:', err);
    showLoadError(['products-grid']);
  }
});

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
              <a class="prod-name" href="produit.html?id=${p.id}" style="text-decoration:none;color:inherit;display:block">${p.name}</a>
              <div class="prod-maker">
                <a href="entreprise.html?id=${p.companyId}" style="text-decoration:none;color:inherit">${p.maker}</a>
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

function resetCatalogue() {
  document.getElementById('cat-search').value = '';
  catCat = 'all'; catInd = 'all';
  updateChips('cat-cat-chips', () => catCat);
  updateChips('cat-ind-chips', () => catInd);
  renderProducts();
}
