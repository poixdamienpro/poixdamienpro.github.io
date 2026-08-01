// ═══════════════════════════════
// PAGE CARTE — carte interactive Leaflet des entreprises référencées
// (fabricants + prestataires), positionnées via lat/lng en base.
// ═══════════════════════════════
let map;
let markerCluster;
let mapIndustry = 'all';
let mapType = 'fournisseurs';

// Mêmes catégories que js/pages/prestations.js — une entreprise dont au moins
// une catégorie de produit tombe ici est comptée comme prestataire.
const SERVICE_CATS = ['Prestation de talents', 'Développement d\'équipements', 'Fabrication de faisceaux électriques', 'Essais & qualification', 'Usinage & fabrication mécanique', 'Intégration & assemblage système'];

const MAP_TYPE_LABELS = { fournisseurs: 'fournisseurs', prestataires: 'prestataires', systemiers: 'systémiers' };
const MAP_TYPE_EMPTY = {
  fournisseurs: 'Aucun fournisseur géolocalisé pour l\'instant.',
  prestataires: 'Aucun prestataire géolocalisé pour l\'instant.',
  systemiers: 'Aucun systémier géolocalisé pour l\'instant.',
};

document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  sizeMapWrap();
  window.addEventListener('resize', sizeMapWrap);
  initMap();
  try {
    await loadTaxonomy();
    window._allMappedCompanies = COMPANIES.filter(c => typeof c.lat === 'number' && typeof c.lng === 'number');
    document.getElementById('kpi-total').textContent = COMPANIES.length;
    applyMapType();
  } catch (err) {
    console.error('Erreur Supabase:', err);
  }
});

function isPrestataire(c) {
  return (c.products || []).some(p => SERVICE_CATS.includes(p));
}
function isFournisseur(c) {
  return (c.products || []).some(p => !SERVICE_CATS.includes(p));
}

function setMapType(type) {
  mapType = type;
  document.querySelectorAll('#map-type-chips .chip').forEach(c => c.classList.toggle('active', c.dataset.type === type));
  const title = document.getElementById('map-type-title');
  if (title) title.textContent = MAP_TYPE_LABELS[type];
  applyMapType();
}

function applyMapType() {
  const all = window._allMappedCompanies || [];
  const filtered = mapType === 'prestataires' ? all.filter(isPrestataire)
    : mapType === 'systemiers' ? all.filter(c => c.isSystemier)
    : all.filter(isFournisseur);

  window._mappedCompanies = filtered;
  document.getElementById('kpi-mapped').textContent = filtered.length;

  const emptyNote = document.getElementById('map-empty-note');
  if (emptyNote) {
    emptyNote.textContent = MAP_TYPE_EMPTY[mapType];
    emptyNote.style.display = filtered.length ? 'none' : 'block';
  }

  mapIndustry = 'all';
  const industries = [...new Set(filtered.map(c => c.industry))].sort();
  initChips('map-industry-chips', industries, () => mapIndustry, v => { mapIndustry = v; renderMarkers(); });

  renderMarkers();
}

// Dimensionne le conteneur de carte a l'espace vertical reellement
// disponible (nav + page-header mesures en vrai, pas une constante CSS
// figee qui casserait des que le header change de hauteur -- ex: kpi-row
// qui passe sur 2 lignes en dessous de 1100px).
function sizeMapWrap() {
  const wrap = document.querySelector('.map-wrap');
  if (!wrap) return;
  const nav = document.getElementById('nav-slot');
  const header = document.querySelector('.page-header');
  const offset = (nav ? nav.offsetHeight : 86) + (header ? header.offsetHeight : 106);
  wrap.style.height = `calc(100vh - ${offset}px)`;
  if (map) map.invalidateSize();
}

function initMap() {
  map = L.map('map-canvas', { worldCopyJump: true }).setView([50.5, 10], 4);

  // Fond de carte clair (CARTO light_all / Positron — gratuit, sans clé API)
  L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
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
  if (count) count.innerHTML = ' · <strong>' + filtered.length + '</strong> ' + MAP_TYPE_LABELS[mapType] + ' localisé' + (filtered.length !== 1 ? 's' : '');
}

function resetMap() {
  mapIndustry = 'all';
  updateChips('map-industry-chips', () => mapIndustry);
  renderMarkers();
  map.setView([50.5, 10], 4);
}
