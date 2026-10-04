// ═══════════════════════════════
// PAGE FICHE PRODUIT — URL dédiée et crawlable (?id=<product_id>),
// remplace l'affichage carte-seule pour le SEO : chaque produit
// référencé devient une page indexable individuellement par Google.
// ═══════════════════════════════
document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  const id = new URLSearchParams(window.location.search).get('id');
  if (!id) {
    document.getElementById('prod-body').innerHTML = `<p style="color:#C0392B">${t('ent_err_noid')}</p>`;
    return;
  }
  try {
    const row = await fetchOne('get_product_by_id', { p_id: id });
    if (!row) throw new Error('not found');
    // Cache pour re-rendu au changement de langue (voir onLangChange plus bas).
    window._prodItem = mapProduct(row);
    renderProduct(window._prodItem);
    logEntityView({
      type: 'product',
      productId: window._prodItem.id, productName: window._prodItem.name, category: window._prodItem.cat,
      companyId: window._prodItem.companyId, companyName: window._prodItem.maker, industry: window._prodItem.industry,
    });
  } catch (err) {
    console.error('Erreur chargement fiche produit:', err);
    document.getElementById('prod-body').innerHTML = `<p style="color:#C0392B">${t('prod_err_gone')}</p>`;
  }
});

// Nombre de caractéristiques visibles sans compte (le reste, les barres de
// performance, la datasheet et la demande de devis sont réservés aux
// comptes gratuits — verrou visuel, voir js/buyer.js lockBoxHtml).
const FREE_SPEC_COUNT = 3;

function renderProduct(p) {
  const loggedIn = typeof isBuyerLoggedIn === 'function' && isBuyerLoggedIn();
  // Hors connexion : les specs non-premium d'abord, puis tronqué à FREE_SPEC_COUNT.
  const specs = loggedIn ? p.specs : [...p.specs].sort((a, b) => (a.premium ? 1 : 0) - (b.premium ? 1 : 0)).slice(0, FREE_SPEC_COUNT);
  const hiddenSpecs = loggedIn ? 0 : Math.max(0, p.specs.length - FREE_SPEC_COUNT);
  if (!loggedIn && !window._lockViewTracked) { window._lockViewTracked = true; trackLockEvent('lock_view', 'produit'); }

  document.title = `${p.name} — ${p.maker} — Buy-inner`;
  const metaDesc = document.querySelector('meta[name="description"]');
  if (metaDesc) metaDesc.setAttribute('content', (localize(p.desc, p.descEn) || `${p.name} par ${p.maker}`).slice(0, 160));

  document.getElementById('prod-header').innerHTML = `
    <h1 class="page-title">${escapeHtml(p.icon)} ${escapeHtml(p.name)}</h1>
    <p class="page-subtitle">${escapeHtml(p.maker)} — ${escapeHtml(taxLabel(p.cat))} ${p.industry ? '· ' + escapeHtml(taxLabel(p.industry)) : ''}</p>
  `;

  document.getElementById('prod-body').innerHTML = `
    ${p.image ? `<img src="${escapeHtml(p.image)}" alt="${escapeHtml(p.name)}" style="max-width:280px;border-radius:8px;border:1px solid var(--border);margin-bottom:16px"/>` : ''}
    <div class="modal-section">
      <div class="modal-section-title">${t('lbl_description')}</div>
      <p style="font-size:13px;color:var(--text2);line-height:1.7;margin:0">${escapeHtml(localize(p.desc, p.descEn))}</p>
    </div>
    <div class="modal-section">
      <div class="modal-section-title">${t('prod_specs')}</div>
      <table class="spec-table">
        <tbody>${specs.map(s => `<tr><td>${escapeHtml(localize(s.l, s.lEn))}</td><td>${escapeHtml(localize(s.v, s.vEn))}</td></tr>`).join('')}</tbody>
      </table>
      ${loggedIn ? p.bars.map(b => `
        <div class="bar-row">
          <div class="bar-labels"><span>${escapeHtml(b.l)}</span><span style="font-weight:700">${escapeHtml(b.v)}%</span></div>
          <div class="bar-track"><div class="bar-fill" style="width:${escapeHtml(b.v)}%;background:${escapeHtml(b.c)}"></div></div>
        </div>`).join('') : ''}
      ${p.certs.length ? `<div class="cert-row" style="margin-top:10px">${p.certs.map(c => '<span class="tag tag-sage">' + escapeHtml(c) + '</span>').join('')}</div>` : ''}
    </div>
    ${loggedIn ? '' : lockBoxHtml(hiddenSpecs ? `+${hiddenSpecs} ${t('lock_more_specs')}` : '')}
    <div class="modal-actions">
      <a class="btn-visit" href="entreprise.html?id=${p.companyId}">${t('prod_view_maker_prefix')} ${escapeHtml(p.maker)}</a>
      ${p.datasheetUrl ? (loggedIn
        ? `<a class="btn-datasheet" href="${escapeHtml(p.datasheetUrl)}" target="_blank" rel="noopener">${t('prod_download_datasheet')}</a>`
        : `<a class="btn-locked" href="${lockAccountHref()}">${t('lock_datasheet')}</a>`) : ''}
      ${loggedIn
        ? `<button class="btn-quote" id="prod-quote-btn">${t('btn_request_quote')} — 💰 ${escapeHtml(p.price)}</button>`
        : `<a class="btn-locked" href="${lockAccountHref()}">${t('lock_quote')}</a>`}
    </div>
  `;
  const quoteBtn = document.getElementById('prod-quote-btn');
  if (quoteBtn) quoteBtn.onclick = () => openLeadModal(p.maker, p.name, p.companyId);

  injectProductJsonLd(p);
}

// Re-rendu au changement de langue (voir js/i18n.js applyLang()).
function onLangChange() {
  if (window._prodItem) renderProduct(window._prodItem);
}

// "Thing" plutôt que "Product" : la plupart des fiches sont "Sur devis"
// (pas de prix fixe) et sans avis clients — un vrai schema.org Product
// exige offers/review/aggregateRating, que Google signale en erreur
// (Search Console) s'ils sont absents. "Thing" décrit correctement la
// fiche sans revendiquer une éligibilité aux résultats enrichis Produit
// qu'on ne peut pas honnêtement remplir.
function injectProductJsonLd(p) {
  const script = document.createElement('script');
  script.type = 'application/ld+json';
  script.textContent = JSON.stringify({
    '@context': 'https://schema.org',
    '@type': 'Thing',
    name: p.name,
    description: localize(p.desc, p.descEn),
    additionalType: p.cat,
  });
  document.head.appendChild(script);
}
