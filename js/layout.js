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
  initMobileNav();
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

// Menu hamburger mobile — le nav bar déborde à droite sous ~900px avec
// 8 liens + bouton + switch de langue, donc on le replie derrière un
// bouton et on l'étend en colonne au clic.
function initMobileNav() {
  const nav = document.querySelector('nav.main');
  const toggle = document.getElementById('navToggle');
  if (!nav || !toggle) return;
  toggle.addEventListener('click', () => {
    const isOpen = nav.classList.toggle('nav-open');
    toggle.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
  });
  nav.querySelectorAll('.nav-link, .btn-signup').forEach(el => {
    el.addEventListener('click', () => {
      nav.classList.remove('nav-open');
      toggle.setAttribute('aria-expanded', 'false');
    });
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
