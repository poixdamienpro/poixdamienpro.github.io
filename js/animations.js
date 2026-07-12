// ═══════════════════════════════
// ANIMATIONS — révélation au scroll des pages statiques (catégories,
// secteurs, info). Tout est instrumenté ici en JS : le HTML reste propre
// et entièrement visible pour les crawlers / sans JS. Le CSS associé
// (.sr / .sr-in) vit en fin de css/styles.css.
// ═══════════════════════════════
(function () {
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

  function arm(el, delay) {
    el.classList.add('sr');
    el.style.setProperty('--sr-d', delay.toFixed(2) + 's');
  }

  document.addEventListener('DOMContentLoaded', function () {
    // Entrée du header de page (fil d'ariane → titre → sous-titre)
    var headerBits = document.querySelectorAll(
      '.page-header .cat-crumb, .page-header .page-title, .page-header .page-subtitle'
    );
    headerBits.forEach(function (el, i) { arm(el, i * 0.1); });
    requestAnimationFrame(function () {
      requestAnimationFrame(function () {
        headerBits.forEach(function (el) { el.classList.add('sr-in'); });
      });
    });

    // Sections révélées au scroll, avec cascade sur leurs éléments
    var sections = document.querySelectorAll('.cat-sec');
    sections.forEach(function (sec) {
      var items = sec.querySelectorAll(
        '.section-eyebrow, .cat-h2, .cat-intro, .cat-crit > li, .cat-prod, ' +
        '.cat-maker, .hub-card, .cat-uc > li, .cat-final, .cat-sec > .cat-cta, .cat-cta'
      );
      var seen = [];
      items.forEach(function (el) {
        // évite de doubler un élément contenu dans un autre déjà armé (ex. cta dans cat-final)
        if (seen.some(function (p) { return p.contains(el); })) return;
        seen.push(el);
      });
      if (!seen.length) seen = [sec];
      seen.forEach(function (el, i) { arm(el, Math.min(i * 0.07, 0.75)); });
      sec.__srItems = seen;
    });

    if (!('IntersectionObserver' in window)) {
      document.querySelectorAll('.sr').forEach(function (el) { el.classList.add('sr-in'); });
      return;
    }

    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (!entry.isIntersecting) return;
        (entry.target.__srItems || []).forEach(function (el) { el.classList.add('sr-in'); });
        io.unobserve(entry.target);
      });
    }, { threshold: 0.12, rootMargin: '0px 0px -8% 0px' });

    sections.forEach(function (sec) { io.observe(sec); });

    // Filet de sécurité : tout ce qui n'a pas été révélé après 6 s le devient
    setTimeout(function () {
      document.querySelectorAll('.sr:not(.sr-in)').forEach(function (el) { el.classList.add('sr-in'); });
    }, 6000);
  });
})();
