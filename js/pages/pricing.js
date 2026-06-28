// ═══════════════════════════════
// PAGE PRICING — données statiques (PLANS/FAQ dans data.js), aucun appel Supabase.
// Thème sombre + narratif "pay-on-result" animé + FAQ accordéon.
// ═══════════════════════════════
document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  renderPlans();
  renderFAQ();
  initFlowReveal();
});

function renderPlans() {
  const grid = document.getElementById('plans-grid');
  if(!grid) return;
  grid.innerHTML = PLANS.map((plan, i) => `
    <div class="plan-card ${plan.highlight ? 'highlight' : ''}" style="--i:${i}">
      ${plan.highlight ? '<div class="plan-popular">LE PLUS POPULAIRE</div>' : ''}
      <div class="plan-name">${plan.name}</div>
      <div class="plan-price">${plan.price}</div>
      <div class="plan-period">${plan.period}</div>
      <p class="plan-desc">${plan.desc}</p>
      <a class="plan-cta ${plan.ctaClass}" href="${ROOT_PREFIX}${plan.target === 'annuaire' || !plan.target ? 'pages/annuaire.html' : 'pages/' + plan.target + '.html'}">${plan.cta}</a>
      <div class="plan-divider"></div>
      <div class="plan-features">
        ${plan.features.map(f => `<div class="plan-feature ${f.ok ? 'ok' : 'no'}"><span class="plan-feature-icon">${f.ok ? '✓' : '✕'}</span><span>${f.text}</span></div>`).join('')}
      </div>
    </div>`).join('');
}

function renderFAQ() {
  const el = document.getElementById('faq-list');
  if(!el) return;
  el.innerHTML = FAQ.map((f, i) => `
    <div class="faq-item${i === 0 ? ' open' : ''}">
      <button class="faq-q" type="button" aria-expanded="${i === 0}">
        <span>${f.q}</span><span class="faq-toggle" aria-hidden="true">+</span>
      </button>
      <div class="faq-a-wrap"><div class="faq-a">${f.a}</div></div>
    </div>`).join('');

  el.querySelectorAll('.faq-q').forEach(btn => {
    btn.addEventListener('click', () => {
      const item = btn.closest('.faq-item');
      const isOpen = item.classList.toggle('open');
      btn.setAttribute('aria-expanded', isOpen);
    });
  });
}

// Révèle le rail (nœuds + câbles) quand il entre dans le viewport.
function initFlowReveal() {
  const rail = document.getElementById('flow-rail');
  if(!rail) return;
  const reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  if(reduce || !('IntersectionObserver' in window)) { rail.classList.add('in'); return; }

  const io = new IntersectionObserver((entries, obs) => {
    entries.forEach(e => {
      if(e.isIntersecting) { e.target.classList.add('in'); obs.unobserve(e.target); }
    });
  }, { threshold: 0.35 });
  io.observe(rail);
}
