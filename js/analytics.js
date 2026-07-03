// ═══════════════════════════════════════════════════════════════════
// GOOGLE ANALYTICS 4 — chargement centralisé pour tout le site.
//
// ▶ POUR ACTIVER LE SUIVI : remplace 'G-XXXXXXXXXX' ci-dessous par ton
//   ID de mesure GA4 (Google Analytics → Admin → Flux de données → Web →
//   « ID de mesure », format G-XXXXXXXXXX).
//
// Tant que la valeur reste le placeholder, RIEN n'est chargé (aucune
// requête réseau, aucun cookie) : le site fonctionne normalement.
// ═══════════════════════════════════════════════════════════════════
(function () {
  var GA_ID = 'G-N1WD4461KL';

  // Pas d'ID réel configuré → on ne charge pas GA.
  if (!GA_ID || GA_ID === 'G-XXXXXXXXXX') return;

  // Charge le script gtag.js de Google.
  var s = document.createElement('script');
  s.async = true;
  s.src = 'https://www.googletagmanager.com/gtag/js?id=' + GA_ID;
  document.head.appendChild(s);

  // Initialise la couche de données GA4.
  window.dataLayer = window.dataLayer || [];
  function gtag() { window.dataLayer.push(arguments); }
  window.gtag = gtag;
  gtag('js', new Date());
  gtag('config', GA_ID);
})();
