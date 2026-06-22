// ═══════════════════════════════
// PAGE PRICING — données statiques (PLANS/FAQ dans data.js), aucun appel Supabase.
// ═══════════════════════════════
document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  renderPlans();
  renderFAQ();
});

function renderPlans() {
  const grid = document.getElementById('plans-grid');
  if(!grid) return;
  grid.innerHTML = PLANS.map(plan => `
    <div class="plan-card ${plan.highlight ? 'highlight' : ''}">
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
  el.innerHTML = FAQ.map(f => `
    <div class="faq-item">
      <div class="faq-q">${f.q}</div>
      <div class="faq-a">${f.a}</div>
    </div>`).join('');
}
