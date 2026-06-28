// ═══════════════════════════════
// PAGE FICHE PRODUIT — URL dédiée et crawlable (?id=<product_id>),
// remplace l'affichage carte-seule pour le SEO : chaque produit
// référencé devient une page indexable individuellement par Google.
// ═══════════════════════════════
document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  const id = new URLSearchParams(window.location.search).get('id');
  if (!id) {
    document.getElementById('prod-body').innerHTML = '<p style="color:#C0392B">Fiche introuvable — identifiant manquant dans l\'URL.</p>';
    return;
  }
  try {
    const row = await fetchOne('get_product_by_id', { p_id: id });
    if (!row) throw new Error('not found');
    renderProduct(mapProduct(row));
  } catch (err) {
    console.error('Erreur chargement fiche produit:', err);
    document.getElementById('prod-body').innerHTML = '<p style="color:#C0392B">Cette fiche produit n\'existe pas ou plus.</p>';
  }
});

function renderProduct(p) {
  document.title = `${p.name} — ${p.maker} — Buy-ineer`;
  const metaDesc = document.querySelector('meta[name="description"]');
  if (metaDesc) metaDesc.setAttribute('content', (p.desc || `${p.name} par ${p.maker}`).slice(0, 160));

  document.getElementById('prod-header').innerHTML = `
    <h1 class="page-title">${p.icon} ${p.name}</h1>
    <p class="page-subtitle">${p.maker} — ${p.cat} ${p.industry ? '· ' + p.industry : ''}</p>
  `;

  document.getElementById('prod-body').innerHTML = `
    ${p.image ? `<img src="${p.image}" alt="${p.name}" style="max-width:280px;border-radius:8px;border:1px solid var(--border);margin-bottom:16px"/>` : ''}
    <div class="modal-section">
      <div class="modal-section-title">Description</div>
      <p style="font-size:13px;color:var(--text2);line-height:1.7;margin:0">${p.desc}</p>
    </div>
    <div class="modal-section">
      <div class="modal-section-title">Spécifications techniques</div>
      <table class="spec-table">
        <tbody>${p.specs.map(s => `<tr><td>${s.l}</td><td>${s.v}</td></tr>`).join('')}</tbody>
      </table>
      ${p.bars.map(b => `
        <div class="bar-row">
          <div class="bar-labels"><span>${b.l}</span><span style="font-weight:700">${b.v}%</span></div>
          <div class="bar-track"><div class="bar-fill" style="width:${b.v}%;background:${b.c}"></div></div>
        </div>`).join('')}
      ${p.certs.length ? `<div class="cert-row" style="margin-top:10px">${p.certs.map(c => '<span class="tag tag-sage">' + c + '</span>').join('')}</div>` : ''}
    </div>
    <div class="modal-actions">
      <a class="btn-visit" href="entreprise.html?id=${p.companyId}">↗ Voir la fiche ${p.maker}</a>
      <button class="btn-quote" id="prod-quote-btn">📩 Demander un devis — 💰 ${p.price}</button>
    </div>
  `;
  document.getElementById('prod-quote-btn').onclick = () => openLeadModal(p.maker, p.name);

  injectProductJsonLd(p);
}

function injectProductJsonLd(p) {
  const script = document.createElement('script');
  script.type = 'application/ld+json';
  script.textContent = JSON.stringify({
    '@context': 'https://schema.org',
    '@type': 'Product',
    name: p.name,
    description: p.desc,
    category: p.cat,
    brand: { '@type': 'Brand', name: p.maker },
  });
  document.head.appendChild(script);
}
