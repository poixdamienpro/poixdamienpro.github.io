// ═══════════════════════════════
// LAYOUT — injecte le nav et les modals partagés dans chaque page.
// rootPrefix vaut '' sur index.html (racine) et '../' depuis /pages/*.html —
// chaque page définit window.ROOT_PREFIX avant de charger ce script.
// ═══════════════════════════════
const ROOT_PREFIX = window.ROOT_PREFIX || '';

async function loadLayout() {
  const [navHtml, modalsHtml] = await Promise.all([
    fetch(ROOT_PREFIX + 'partials/nav.html').then(r => r.text()),
    fetch(ROOT_PREFIX + 'partials/modals.html').then(r => r.text()),
  ]);
  document.getElementById('nav-slot').innerHTML = navHtml.replace(/\{\{root\}\}/g, ROOT_PREFIX);
  document.getElementById('modals-slot').innerHTML = modalsHtml.replace(/\{\{root\}\}/g, ROOT_PREFIX);
  markActiveNavLink();
  initTicker();
  document.querySelectorAll('.overlay').forEach(o => {
    o.addEventListener('click', e => { if (e.target === o) o.classList.remove('open'); });
  });
}

function markActiveNavLink() {
  const link = document.querySelector('[data-page="' + (window.CURRENT_PAGE || 'home') + '"]');
  if (link) link.classList.add('active');
}

function closeModal(id) {
  document.getElementById(id).classList.remove('open');
}

function initTicker() {
  const text = TICKER_ITEMS.join('   ·   ');
  const el = document.getElementById('tickerText');
  if (el) el.textContent = text + '     ' + text;
}
