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
  'Segment sol & opérations',
  'Sous-traitance électronique (EMS)',
];

document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  const id = new URLSearchParams(window.location.search).get('id');
  if (!id) {
    document.getElementById('ent-body').innerHTML = '<p style="color:#C0392B">Fiche introuvable — identifiant manquant dans l\'URL.</p>';
    return;
  }
  try {
    const [companyRow, tagsRaw, catsRaw, indsRaw] = await Promise.all([
      fetchOne('get_company_by_id', { p_id: id }),
      supabase('company_tags', `select=tag&company_id=eq.${id}`),
      supabase('company_product_categories', `select=category&company_id=eq.${id}`),
      // Voir backend/supabase_add_company_industries.sql — .catch() dédié
      // tant que la migration n'a pas encore été exécutée en base.
      supabase('company_industries', `select=industry&company_id=eq.${id}`).catch(() => []),
    ]);
    if (!companyRow) throw new Error('not found');
    companyRow.tags = tagsRaw.map(t => t.tag);
    companyRow.categories = catsRaw.map(c => c.category);
    companyRow.industries = indsRaw.map(i => i.industry);
    const c = mapCompany(companyRow);

    const productsRows = await fetchRpc('get_products_by_company', { p_company_id: id });
    const products = productsRows.map(mapProduct);

    // Caches pour re-rendu au changement de langue (voir onLangChange plus bas).
    window._entCompany = c;
    window._entProducts = products;
    renderCompany(c, products);
    logEntityView({ type: 'company', companyId: c.id, companyName: c.name, industry: c.industry });
  } catch (err) {
    console.error('Erreur chargement fiche entreprise:', err);
    document.getElementById('ent-body').innerHTML = '<p style="color:#C0392B">Cette fiche entreprise n\'existe pas ou plus.</p>';
  }
});

function renderCompany(c, products) {
  const isPrestataire = c.products.some(cat => SERVICE_CATS.includes(cat));
  const services = c.products.filter(cat => SERVICE_CATS.includes(cat));
  const equipmentCats = c.products.filter(cat => !SERVICE_CATS.includes(cat));

  const industryLabel = c.industries.join(' & ');
  document.title = `${c.name} — ${industryLabel} — Buy-inner`;
  const metaDesc = document.querySelector('meta[name="description"]');
  const metaFallback = isPrestataire ? `${c.name}, prestataire de services ${industryLabel}` : `${c.name}, équipementier ${industryLabel}`;
  if (metaDesc) metaDesc.setAttribute('content', (localize(c.desc, c.descEn) || metaFallback).slice(0, 160));

  document.getElementById('ent-header').innerHTML = `
    <h1 class="page-title"><span style="display:inline-flex;width:40px;height:40px;vertical-align:middle;align-items:center;justify-content:center;margin-right:10px;border-radius:9px;background:rgba(0,0,0,.04);overflow:hidden">${companyLogoHtml(c, 40)}</span>${c.name}</h1>
    <p class="page-subtitle">${c.country} · ${c.hq} — ${industryLabel}</p>
  `;

  document.getElementById('ent-body').innerHTML = `
    <div style="display:flex;gap:6px;flex-wrap:wrap;margin-bottom:16px">
      ${c.premium ? `<span class="badge-premium">${t('badge_premium')}</span>` : ''}
      ${c.verified ? `<span class="badge-verified">${t('badge_verified')}</span>` : ''}
      ${isPrestataire ? `<span class="tag tag-industry">${t('tag_prestataire')}</span>` : ''}
      ${c.isSystemier ? `<span class="tag tag-industry">${t('tag_systemier')}</span>` : ''}
      ${c.industries.map(ind => `<span class="tag tag-industry">${ind}</span>`).join('')}
    </div>
    ${!c.premium ? `
    <div class="claim-banner">
      <span style="font-size:16px">ℹ️</span>
      <p>${t('ent_claim_text')} <strong>${c.name}</strong> ?</p>
      <a href="supplier.html">${t('ent_claim_link')}</a>
    </div>` : ''}
    <div class="modal-section">
      <div class="modal-section-title">${t('lbl_description')}</div>
      <p style="font-size:13px;color:var(--text2);line-height:1.7;margin:0">${localize(c.desc, c.descEn)}</p>
    </div>
    <div class="modal-section">
      <div class="modal-section-title">${t('prev_info')}</div>
      <div class="detail-grid">
        ${[[t('prev_founded'), c.founded], [t('prev_employees'), c.employees], [t('prev_sector'), industryLabel], [t('prev_hq'), [c.city, c.region].filter(Boolean).join(' · ') || c.hq]]
          .map(([l, v]) => `<div class="detail-item"><div class="detail-label">${l}</div><div class="detail-value">${v}</div></div>`).join('')}
      </div>
    </div>
    ${services.length ? `
    <div class="modal-section">
      <div class="modal-section-title">${t('presta_services_label')}</div>
      <div class="modal-tags">${services.map(s => `<span class="tag">${s}</span>`).join('')}</div>
    </div>` : ''}
    ${equipmentCats.length || c.tags.length ? `
    <div class="modal-section">
      <div class="modal-section-title">${t('lbl_ranges_tech')}</div>
      <div class="modal-tags">${[...equipmentCats, ...c.tags].map(g => `<span class="tag">${g}</span>`).join('')}</div>
    </div>` : ''}
    ${products.length ? `
    <div class="modal-section">
      <div class="modal-section-title">${isPrestataire ? t('presta_services_label') : t('lbl_products_referenced')}</div>
      <div class="modal-prod-grid">
        ${products.map(p => `
          <a class="modal-prod-card" href="produit.html?id=${p.id}" style="text-decoration:none;color:inherit;display:block">
            <div class="modal-prod-name">${p.icon} ${p.name}</div>
            <div class="modal-prod-specs">${p.specs.slice(0, 2).map(s => localize(s.l, s.lEn) + ' : ' + localize(s.v, s.vEn)).join(' · ')}</div>
            <div class="modal-prod-price">💰 ${p.price}</div>
          </a>`).join('')}
      </div>
    </div>` : ''}
    <div class="modal-actions">
      <a class="btn-visit" href="${c.site}" target="_blank" rel="noopener">${t('btn_visit_site')}</a>
      <button class="btn-quote" onclick="openLeadModal('${c.name.replace(/'/g, "\\'")}', null, '${c.id}')">${t('btn_request_quote')}</button>
    </div>
  `;

  injectCompanyJsonLd(c);
}

// Re-rendu au changement de langue (voir js/i18n.js applyLang()) : le corps
// de la fiche est construit en JS, pas via data-i18n.
function onLangChange() {
  if (window._entCompany) renderCompany(window._entCompany, window._entProducts);
}

function injectCompanyJsonLd(c) {
  const script = document.createElement('script');
  script.type = 'application/ld+json';
  script.textContent = JSON.stringify({
    '@context': 'https://schema.org',
    '@type': 'Organization',
    name: c.name,
    description: localize(c.desc, c.descEn),
    url: c.site !== '#' ? c.site : undefined,
    address: { '@type': 'PostalAddress', addressLocality: c.hq, addressCountry: c.country },
    industry: c.industries.join(', '),
  });
  document.head.appendChild(script);
}
