// ═══════════════════════════════
// LAYOUT — injecte le nav et les modals partagés dans chaque page.
// rootPrefix vaut '' sur index.html (racine) et '../' depuis /pages/*.html —
// chaque page définit window.ROOT_PREFIX avant de charger ce script.
// ═══════════════════════════════
const ROOT_PREFIX = window.ROOT_PREFIX || '';

async function loadLayout() {
  const [navHtml, modalsHtml, footerHtml] = await Promise.all([
    fetch(ROOT_PREFIX + 'partials/nav.html').then(r => r.text()),
    fetch(ROOT_PREFIX + 'partials/modals.html').then(r => r.text()),
    fetch(ROOT_PREFIX + 'partials/footer.html').then(r => r.text()),
  ]);
  document.getElementById('nav-slot').innerHTML = navHtml.replace(/\{\{root\}\}/g, ROOT_PREFIX);
  const modalsSlot = document.getElementById('modals-slot');
  if (modalsSlot) modalsSlot.innerHTML = modalsHtml.replace(/\{\{root\}\}/g, ROOT_PREFIX);
  const footerSlot = document.getElementById('footer-slot');
  if (footerSlot) {
    footerSlot.innerHTML = footerHtml.replace(/\{\{root\}\}/g, ROOT_PREFIX);
    const yearEl = document.getElementById('footer-year');
    if (yearEl) yearEl.textContent = new Date().getFullYear();
  }
  markActiveNavLink();
  initTicker();
  if (typeof applyLang === 'function') applyLang();
  document.querySelectorAll('.overlay').forEach(o => {
    o.addEventListener('click', e => { if (e.target === o) o.classList.remove('open'); });
  });
  logPageView();
}

// Log anonyme d'une vue de page (compté côté admin) — fire-and-forget,
// pas de cookie, pas d'IP stockée. Voir backend/supabase_add_page_views.sql.
function logPageView() {
  fetch(`${SUPABASE_URL}/rest/v1/site_page_views`, {
    method: 'POST',
    headers: {
      'apikey': SUPABASE_ANON,
      'Authorization': 'Bearer ' + SUPABASE_ANON,
      'Content-Type': 'application/json',
      'Prefer': 'return=minimal',
    },
    body: JSON.stringify([{
      page: window.location.pathname,
      referrer: document.referrer || null,
      user_agent: navigator.userAgent,
    }]),
  }).catch(() => {});
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
