// ═══════════════════════════════
// PAGE FICHE ENTREPRISE — URL dédiée et crawlable (?id=<company_id>),
// remplace l'ancienne modale pour le SEO : chaque entreprise référencée
// devient une page indexable individuellement par Google.
// ═══════════════════════════════
document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  const id = new URLSearchParams(window.location.search).get('id');
  if (!id) {
    document.getElementById('ent-body').innerHTML = '<p style="color:#C0392B">Fiche introuvable — identifiant manquant dans l\'URL.</p>';
    return;
  }
  try {
    const [companyRow, tagsRaw, catsRaw] = await Promise.all([
      fetchOne('get_company_by_id', { p_id: id }),
      supabase('company_tags', `select=tag&company_id=eq.${id}`),
      supabase('company_product_categories', `select=category&company_id=eq.${id}`),
    ]);
    if (!companyRow) throw new Error('not found');
    companyRow.tags = tagsRaw.map(t => t.tag);
    companyRow.categories = catsRaw.map(c => c.category);
    const c = mapCompany(companyRow);

    const productsRows = await fetchRpc('get_products_by_company', { p_company_id: id });
    const products = productsRows.map(mapProduct);

    renderCompany(c, products);
  } catch (err) {
    console.error('Erreur chargement fiche entreprise:', err);
    document.getElementById('ent-body').innerHTML = '<p style="color:#C0392B">Cette fiche entreprise n\'existe pas ou plus.</p>';
  }
});

function renderCompany(c, products) {
  document.title = `${c.name} — ${c.industry} — Buy-ineer`;
  const metaDesc = document.querySelector('meta[name="description"]');
  if (metaDesc) metaDesc.setAttribute('content', (c.desc || `${c.name}, équipementier ${c.industry}`).slice(0, 160));

  document.getElementById('ent-header').innerHTML = `
    <h1 class="page-title">${c.logo} ${c.name}</h1>
    <p class="page-subtitle">${c.country} · ${c.hq} — ${c.industry}</p>
  `;

  document.getElementById('ent-body').innerHTML = `
    <div style="display:flex;gap:6px;flex-wrap:wrap;margin-bottom:16px">
      ${c.premium ? '<span class="badge-premium">★ Premium</span>' : ''}
      ${c.verified ? '<span class="badge-verified">✓ Vérifié</span>' : ''}
      <span class="tag tag-industry">${c.industry}</span>
    </div>
    ${!c.premium ? `
    <div class="claim-banner">
      <span style="font-size:16px">ℹ️</span>
      <p>Fiche non revendiquée — construite à partir de données publiques. Êtes-vous <strong>${c.name}</strong> ?</p>
      <a href="supplier.html">Revendiquer</a>
    </div>` : ''}
    <div class="modal-section">
      <div class="modal-section-title">Description</div>
      <p style="font-size:13px;color:var(--text2);line-height:1.7;margin:0">${c.desc}</p>
    </div>
    <div class="modal-section">
      <div class="modal-section-title">Informations société</div>
      <div class="detail-grid">
        ${[['Fondée en', c.founded], ['Effectifs', c.employees], ['Secteur', c.industry], ['Siège', c.hq]]
          .map(([l, v]) => `<div class="detail-item"><div class="detail-label">${l}</div><div class="detail-value">${v}</div></div>`).join('')}
      </div>
    </div>
    <div class="modal-section">
      <div class="modal-section-title">Gammes & Technologies</div>
      <div class="modal-tags">${[...c.products, ...c.tags].map(t => `<span class="tag">${t}</span>`).join('')}</div>
    </div>
    ${products.length ? `
    <div class="modal-section">
      <div class="modal-section-title">Produits référencés sur Buy-ineer</div>
      <div class="modal-prod-grid">
        ${products.map(p => `
          <a class="modal-prod-card" href="produit.html?id=${p.id}" style="text-decoration:none;color:inherit;display:block">
            <div class="modal-prod-name">${p.icon} ${p.name}</div>
            <div class="modal-prod-specs">${p.specs.slice(0, 2).map(s => s.l + ' : ' + s.v).join(' · ')}</div>
            <div class="modal-prod-price">💰 ${p.price}</div>
          </a>`).join('')}
      </div>
    </div>` : ''}
    <div class="modal-actions">
      <a class="btn-visit" href="${c.site}" target="_blank" rel="noopener">↗ Visiter le site officiel</a>
      <button class="btn-quote" onclick="openLeadModal('${c.name.replace(/'/g, "\\'")}', null)">📩 Demander un devis</button>
    </div>
  `;

  injectCompanyJsonLd(c);
}

function injectCompanyJsonLd(c) {
  const script = document.createElement('script');
  script.type = 'application/ld+json';
  script.textContent = JSON.stringify({
    '@context': 'https://schema.org',
    '@type': 'Organization',
    name: c.name,
    description: c.desc,
    url: c.site !== '#' ? c.site : undefined,
    address: { '@type': 'PostalAddress', addressLocality: c.hq, addressCountry: c.country },
    industry: c.industry,
  });
  document.head.appendChild(script);
}
