// ═══════════════════════════════
// PAGE CARTE — carte interactive Leaflet des entreprises référencées
// (fabricants + prestataires), positionnées via lat/lng en base.
// ═══════════════════════════════
let map;
let markerCluster;
let mapIndustry = 'all';

document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  initMap();
  try {
    await loadTaxonomy();
    const withCoords = COMPANIES.filter(c => typeof c.lat === 'number' && typeof c.lng === 'number');
    document.getElementById('kpi-mapped').textContent = withCoords.length;
    document.getElementById('kpi-total').textContent = COMPANIES.length;

    if (!withCoords.length) {
      document.getElementById('map-empty-note').style.display = 'block';
    }

    const industries = [...new Set(withCoords.map(c => c.industry))].sort();
    initChips('map-industry-chips', industries, () => mapIndustry, v => { mapIndustry = v; renderMarkers(); });

    window._mappedCompanies = withCoords;
    renderMarkers();
  } catch (err) {
    console.error('Erreur Supabase:', err);
  }
});

function initMap() {
  map = L.map('map-canvas', { worldCopyJump: true }).setView([50.5, 10], 4);

  // Fond de carte sombre (CARTO dark_all — gratuit, sans clé API)
  L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>',
    subdomains: 'abcd',
    maxZoom: 19,
  }).addTo(map);

  markerCluster = L.markerClusterGroup({
    maxClusterRadius: 40,
    iconCreateFunction: cluster => L.divIcon({
      html: `<div class="map-cluster">${cluster.getChildCount()}</div>`,
      className: '',
      iconSize: [36, 36],
    }),
  });
  map.addLayer(markerCluster);
}

function renderMarkers() {
  markerCluster.clearLayers();
  const base = window._mappedCompanies || [];
  const filtered = mapIndustry === 'all' ? base : base.filter(c => c.industry === mapIndustry);

  const dot = L.divIcon({ className: 'map-dot', iconSize: [14, 14] });

  filtered.forEach(c => {
    const marker = L.marker([c.lat, c.lng], { icon: dot });
    const loc = [c.city, c.department, c.region].filter(Boolean).join(' · ') || c.hq || c.country;
    marker.bindPopup(`
      <div class="map-popup">
        <div class="map-popup-name">${c.logo || '🏭'} ${c.name}</div>
        <div class="map-popup-loc">${loc}</div>
        <div class="map-popup-industry">${c.industry}</div>
        <a class="map-popup-link" href="entreprise.html?id=${encodeURIComponent(c.id)}">Voir la fiche →</a>
      </div>
    `);
    markerCluster.addLayer(marker);
  });

  const count = document.getElementById('map-count');
  if (count) count.innerHTML = ' · <strong>' + filtered.length + '</strong> entreprise' + (filtered.length !== 1 ? 's' : '') + ' localisée' + (filtered.length !== 1 ? 's' : '');
}

function resetMap() {
  mapIndustry = 'all';
  updateChips('map-industry-chips', () => mapIndustry);
  renderMarkers();
  map.setView([50.5, 10], 4);
}
