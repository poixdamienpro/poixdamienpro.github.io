// ═══════════════════════════════
// CHIPS — filtres réutilisés par annuaire, catalogue
// ═══════════════════════════════
function initChips(containerId, items, getState, setState) {
  const el = document.getElementById(containerId);
  el.innerHTML = '';
  const allBtn = document.createElement('button');
  allBtn.className = 'chip active';
  allBtn.dataset.all = 'true';
  allBtn.textContent = typeof t === 'function' ? t('all_filter') : 'Tous';
  allBtn.onclick = () => { setState('all'); updateChips(containerId, getState); };
  el.appendChild(allBtn);
  items.forEach(item => {
    const btn = document.createElement('button');
    btn.className = 'chip';
    btn.textContent = item;
    btn.onclick = () => { setState(item); updateChips(containerId, getState); };
    el.appendChild(btn);
  });
}

function updateChips(containerId, getState) {
  document.querySelectorAll('#' + containerId + ' .chip').forEach(c => {
    c.classList.toggle('active', c.dataset.all === 'true' ? getState() === 'all' : c.textContent === getState());
  });
}
