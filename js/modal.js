// ═══════════════════════════════
// COMPARE — réutilisé par catalogue (la fiche entreprise détaillée vit
// maintenant sur sa propre page, pages/entreprise.html — voir
// js/pages/entreprise.js — donc plus de modale company-overlay ici).
// ═══════════════════════════════
function toggleCompare(id, btn) {
  if(compareIds.includes(id)) {
    compareIds = compareIds.filter(x => x !== id);
  } else {
    if(compareIds.length >= 4) { flashCompareLimit(); return; }
    compareIds.push(id);
  }
  syncCompareButtons();   // pas de rebuild de la liste → l'aperçu/les animations restent
  updateCompareBanner();
}

// met à jour tous les boutons "comparer" (lignes + aperçu) sans reconstruire la liste
function syncCompareButtons() {
  document.querySelectorAll('[data-cmp]').forEach(b => {
    const on = compareIds.includes(b.dataset.cmp);
    b.classList.toggle('on', on);
    if(b.classList.contains('btn-cmp-add')) b.textContent = on ? '✓ Dans le comparateur' : '＋ Comparer';
    else if(b.classList.contains('dir-cmp')) b.textContent = on ? '✓' : '＋';
  });
}

// flash non-bloquant quand on dépasse 4 produits (au lieu d'un alert qui gèle la page)
function flashCompareLimit() {
  const banner = document.getElementById('compare-banner');
  if(!banner) return;
  banner.classList.add('limit');
  setTimeout(() => banner.classList.remove('limit'), 500);
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
