// ═══════════════════════════════
// ANIMATIONS — révélation au scroll des pages statiques (catégories,
// secteurs, info, blog). Tout est instrumenté ici en JS : le HTML reste
// propre et entièrement visible pour les crawlers / sans JS. Le CSS associé
// (.sr / .sr-in) vit en fin de css/styles.css.
//
// Chaque élément est observé individuellement : la cascade ne s'applique
// qu'aux éléments qui entrent ensemble dans l'écran, dans l'ordre du DOM,
// avec un budget total plafonné (STAGGER_MAX) pour que rien n'attende.
// ═══════════════════════════════
(function () {
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

  var STAGGER = 0.06;     // s entre deux éléments d'une même vague
  var STAGGER_MAX = 0.42; // s, délai maximal d'un élément dans sa vague

  var HEADER_SEL =
    '.page-header .cat-crumb, .page-header .page-title, .page-header .page-subtitle, ' +
    '.cat-hero .cat-breadcrumb, .cat-hero .cat-eyebrow, .cat-hero h1, ' +
    '.cat-hero .cat-hero-desc, .cat-hero .article-meta';

  // Articles du blog : seuls les blocs visuels entrent, jamais les paragraphes
  // (un texte qui apparaît pendant qu'on le lit gêne la lecture).
  var ITEM_SEL =
    '.cat-sec .section-eyebrow, .cat-sec .cat-h2, .cat-sec .cat-intro, .cat-crit > li, .cat-prod, ' +
    '.cat-maker, .hub-card, .cat-uc > li, .cat-final, .cat-sec .cat-cta, .blog-card, ' +
    '.cat-body .diagram-wrap, .cat-body .specs-table, .cat-body .chem-card, .cat-body .pros-cons, ' +
    '.cat-body .pitfall-box, .cat-body .example-box, .cat-body .checklist, .cat-body .series-list, ' +
    '.cat-body .next-part, .cat-body .related-links, .cat-body > .cat-cta';

  function arm(el, delay) {
    el.classList.add('sr');
    el.style.setProperty('--sr-d', delay.toFixed(2) + 's');
  }

  function reveal(el) {
    el.classList.add('sr-in');
    // entrée terminée : on retire .sr/.sr-in pour rendre la main aux transitions
    // de survol propres à l'élément (sinon elles hériteraient des 0,7 s d'entrée)
    var delay = parseFloat(el.style.getPropertyValue('--sr-d')) || 0;
    setTimeout(function () {
      el.classList.remove('sr', 'sr-in');
      el.style.removeProperty('--sr-d');
    }, (delay + 0.75) * 1000);
  }

  document.addEventListener('DOMContentLoaded', function () {
    // Entrée du header de page (fil d'ariane → titre → sous-titre)
    var headerBits = document.querySelectorAll(HEADER_SEL);
    headerBits.forEach(function (el, i) { arm(el, Math.min(i * 0.1, STAGGER_MAX)); });
    requestAnimationFrame(function () {
      requestAnimationFrame(function () { headerBits.forEach(reveal); });
    });

    // Éléments révélés au scroll ; on ignore ceux contenus dans un élément déjà armé
    var items = [];
    document.querySelectorAll(ITEM_SEL).forEach(function (el) {
      if (items.some(function (p) { return p.contains(el); })) return;
      items.push(el);
      arm(el, 0);
    });

    if (!('IntersectionObserver' in window)) {
      items.forEach(reveal);
      return;
    }

    var io = new IntersectionObserver(function (entries) {
      var wave = entries
        .filter(function (e) { return e.isIntersecting; })
        .map(function (e) { return e.target; })
        .sort(function (a, b) {
          return a.compareDocumentPosition(b) & Node.DOCUMENT_POSITION_FOLLOWING ? -1 : 1;
        });
      wave.forEach(function (el, i) {
        el.style.setProperty('--sr-d', Math.min(i * STAGGER, STAGGER_MAX).toFixed(2) + 's');
        reveal(el);
        io.unobserve(el);
      });
    }, { threshold: 0.12, rootMargin: '0px 0px -6% 0px' });

    items.forEach(function (el) { io.observe(el); });

    // Filet de sécurité : tout ce qui n'a pas été révélé après 6 s le devient
    setTimeout(function () {
      document.querySelectorAll('.sr:not(.sr-in)').forEach(reveal);
    }, 6000);
  });
})();
