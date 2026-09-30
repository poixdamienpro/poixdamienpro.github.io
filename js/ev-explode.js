// ═══════════════════════════════
// VUE ÉCLATÉE — section « anatomie » des pages secteur (véhicule, satellite,
// navire, avion, conteneur de stockage).
// Desktop : la section reste épinglée pendant le scroll, la vidéo (encodée
// tout-intra pour un seek fluide) avance avec la progression, puis les
// repères numérotés apparaissent sur la vue éclatée.
// Mobile, prefers-reduced-motion ou vidéo indisponible : image éclatée fixe,
// repères et menu visibles d'emblée. Le menu (<ol class="evx-menu">) est la
// navigation accessible ; les repères sur l'image en sont le doublon visuel.
// ═══════════════════════════════
(function () {
  var OPEN_AT = 0.82; // progression à partir de laquelle la voiture est « éclatée »

  function init(root) {
    var track = root.querySelector('.evx-track');
    var video = root.querySelector('.evx-video');
    var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    var wide = window.matchMedia('(min-width: 900px)');

    // Survol croisé menu ↔ repères
    root.querySelectorAll('[data-part]').forEach(function (el) {
      var id = el.getAttribute('data-part');
      function hl(on) {
        root.querySelectorAll('[data-part="' + id + '"]').forEach(function (x) {
          x.classList.toggle('is-hl', on);
        });
      }
      el.addEventListener('mouseenter', function () { hl(true); });
      el.addEventListener('mouseleave', function () { hl(false); });
      el.addEventListener('focus', function () { hl(true); });
      el.addEventListener('blur', function () { hl(false); });
    });

    function staticMode() {
      root.classList.remove('is-scrub');
      root.classList.add('is-open');
    }

    if (reduce || !video || !wide.matches || !video.canPlayType('video/mp4')) {
      staticMode();
      return;
    }

    root.classList.add('is-scrub');
    var duration = 0, target = 0, current = 0, raf = 0, ready = false;

    // Chargement de la vidéo seulement à l'approche de la section
    var io = new IntersectionObserver(function (entries) {
      if (!entries[0].isIntersecting) return;
      io.disconnect();
      video.src = video.getAttribute('data-src');
      video.load();
    }, { rootMargin: '600px 0px' });
    io.observe(root);

    video.addEventListener('loadedmetadata', function () {
      duration = video.duration || 0;
      ready = duration > 0;
      onScroll();
    });
    video.addEventListener('error', staticMode);

    function progress() {
      var r = track.getBoundingClientRect();
      var run = track.offsetHeight - window.innerHeight;
      if (run <= 0) return 1;
      return Math.min(1, Math.max(0, -r.top / run));
    }

    function tick() {
      raf = 0;
      // lissage : la vidéo rattrape la position de scroll sans à-coups
      current += (target - current) * 0.18;
      if (Math.abs(target - current) < 0.001) current = target;
      if (ready) {
        var t = Math.min(duration - 0.05, current * duration);
        if (Math.abs(video.currentTime - t) > 0.01) video.currentTime = t;
      }
      if (current !== target) raf = requestAnimationFrame(tick);
    }

    function onScroll() {
      var p = progress();
      target = Math.min(1, p / OPEN_AT);
      root.classList.toggle('is-open', p >= OPEN_AT);
      if (!raf) raf = requestAnimationFrame(tick);
    }

    window.addEventListener('scroll', onScroll, { passive: true });
    window.addEventListener('resize', onScroll);
    wide.addEventListener('change', function (e) { if (!e.matches) staticMode(); });
    onScroll();
  }

  document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.evx').forEach(init);
  });
})();
