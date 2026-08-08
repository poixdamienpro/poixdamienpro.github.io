// ═══════════════════════════════
// PAGE FICHE ENTREPRISE — URL dédiée et crawlable (?id=<company_id>),
// remplace l'ancienne modale pour le SEO : chaque entreprise référencée
// devient une page indexable individuellement par Google.
// ═══════════════════════════════
// Memes categories que js/pages/prestations.js — une entreprise dont au
// moins une categorie de produit tombe ici est une prestataire de service.
const SERVICE_CATS = [
  'Prestation de talents',
  'Développement d\'équipements',
  'Fabrication de faisceaux électriques',
  'Essais & qualification',
  'Usinage & fabrication mécanique',
  'Intégration & assemblage système',
];

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
  const isPrestataire = c.products.some(cat => SERVICE_CATS.includes(cat));
  const services = c.products.filter(cat => SERVICE_CATS.includes(cat));
  const equipmentCats = c.products.filter(cat => !SERVICE_CATS.includes(cat));

  document.title = `${c.name} — ${c.industry} — Buy-inner`;
  const metaDesc = document.querySelector('meta[name="description"]');
  const metaFallback = isPrestataire ? `${c.name}, prestataire de services ${c.industry}` : `${c.name}, équipementier ${c.industry}`;
  if (metaDesc) metaDesc.setAttribute('content', (c.desc || metaFallback).slice(0, 160));

  document.getElementById('ent-header').innerHTML = `
    <h1 class="page-title"><span style="display:inline-flex;width:40px;height:40px;vertical-align:middle;align-items:center;justify-content:center;margin-right:10px;border-radius:9px;background:rgba(0,0,0,.04);overflow:hidden">${companyLogoHtml(c, 40)}</span>${c.name}</h1>
    <p class="page-subtitle">${c.country} · ${c.hq} — ${c.industry}</p>
  `;

  document.getElementById('ent-body').innerHTML = `
    <div style="display:flex;gap:6px;flex-wrap:wrap;margin-bottom:16px">
      ${c.premium ? '<span class="badge-premium">★ Premium</span>' : ''}
      ${c.verified ? '<span class="badge-verified">✓ Vérifié</span>' : ''}
      ${isPrestataire ? '<span class="tag tag-industry">🧑‍💼 Prestataire de service</span>' : ''}
      ${c.isSystemier ? '<span class="tag tag-industry">🔗 Systémier</span>' : ''}
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
        ${[['Fondée en', c.founded], ['Effectifs', c.employees], ['Secteur', c.industry], ['Siège', [c.city, c.region].filter(Boolean).join(' · ') || c.hq]]
          .map(([l, v]) => `<div class="detail-item"><div class="detail-label">${l}</div><div class="detail-value">${v}</div></div>`).join('')}
      </div>
    </div>
    ${services.length ? `
    <div class="modal-section">
      <div class="modal-section-title">Activités de prestation</div>
      <div class="modal-tags">${services.map(t => `<span class="tag">${t}</span>`).join('')}</div>
    </div>` : ''}
    ${equipmentCats.length || c.tags.length ? `
    <div class="modal-section">
      <div class="modal-section-title">Gammes & Technologies</div>
      <div class="modal-tags">${[...equipmentCats, ...c.tags].map(t => `<span class="tag">${t}</span>`).join('')}</div>
    </div>` : ''}
    ${products.length ? `
    <div class="modal-section">
      <div class="modal-section-title">${isPrestataire ? 'Prestations proposées sur Buy-inner' : 'Produits référencés sur Buy-inner'}</div>
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
