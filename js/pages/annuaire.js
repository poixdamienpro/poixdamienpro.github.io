// ═══════════════════════════════
// PAGE ANNUAIRE
// ═══════════════════════════════
document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  showLoading(['companies-grid']);
  try {
    await loadTaxonomy();
    initChips('ann-industry-chips', INDUSTRIES, () => annIndustry, v => { annIndustry = v; renderCompanies(); });
    initChips('ann-cat-chips', PROD_CATS, () => annCat, v => { annCat = v; renderCompanies(); });
    document.getElementById('kpi-c').textContent = COMPANIES.length;
    document.getElementById('kpi-p').textContent = PRODUCTS.length;
    renderCompanies();
  } catch (err) {
    console.error('Erreur Supabase:', err);
    showLoadError(['companies-grid']);
  }
});

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

function resetAnnuaire() {
  document.getElementById('ann-search').value = '';
  annIndustry = 'all'; annCat = 'all';
  updateChips('ann-industry-chips', () => annIndustry);
  updateChips('ann-cat-chips', () => annCat);
  renderCompanies();
}
