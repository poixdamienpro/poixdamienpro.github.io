// ═══════════════════════════════
// PAGE HOME
// ═══════════════════════════════
document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  try {
    const stats = await fetchPublicStats();   // totaux publics, sans nom d'entreprise
    document.getElementById('stat-c').textContent = stats.n_companies;
    document.getElementById('stat-p').textContent = stats.n_products;
  } catch (err) {
    console.error('Erreur Supabase:', err);
  }
});
