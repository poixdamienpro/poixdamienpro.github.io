// ═══════════════════════════════
// PAGE HOME
// ═══════════════════════════════
document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  try {
    await loadTaxonomy();
    document.getElementById('stat-c').textContent = COMPANIES.length;
    document.getElementById('stat-p').textContent = PRODUCTS.length;
  } catch (err) {
    console.error('Erreur Supabase:', err);
  }
});
