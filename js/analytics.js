// ═══════════════════════════════════════════════════════════════════
// GOOGLE ANALYTICS 4 + BANDEAU DE CONSENTEMENT — chargement centralisé.
//
// GA4 ne se charge QUE si le visiteur l'a accepté : tant qu'il n'a pas
// répondu (ou s'il a refusé), aucun script Google n'est chargé, aucun
// cookie n'est déposé, window.gtag n'existe pas (les appels
// `if (typeof window.gtag === 'function')` du site sont alors ignorés).
//
// Le choix est mémorisé dans localStorage ('bi_consent_ga') : accepté 13 mois,
// refusé 6 mois, puis le bandeau est reproposé. Le lien « Gérer les cookies »
// du pied de page (window.biCookieSettings) permet de changer d'avis.
// ═══════════════════════════════════════════════════════════════════
(function () {
  var GA_ID = 'G-N1WD4461KL';
  var KEY = 'bi_consent_ga';
  var MONTH = 30 * 24 * 3600 * 1000;

  // Pas d'ID réel configuré → on ne charge pas GA et on n'affiche pas de bandeau.
  if (!GA_ID || GA_ID === 'G-XXXXXXXXXX') return;

  var TXT = {
    fr: {
      title: 'Cookies et mesure d’audience',
      body: 'Nous utilisons Google Analytics pour comprendre comment le site est utilisé. Ces cookies ne sont déposés qu’avec votre accord.',
      more: 'En savoir plus',
      refuse: 'Refuser',
      accept: 'Accepter',
      aria: 'Choix des cookies'
    },
    en: {
      title: 'Cookies and audience measurement',
      body: 'We use Google Analytics to understand how the site is used. These cookies are only set with your consent.',
      more: 'Learn more',
      refuse: 'Decline',
      accept: 'Accept',
      aria: 'Cookie choice'
    }
  };

  function lang() {
    var l = null;
    try { l = localStorage.getItem('bi_lang'); } catch (e) {}
    if (!l) l = document.documentElement.lang;
    return l === 'en' ? 'en' : 'fr';
  }

  function readChoice() {
    try {
      var c = JSON.parse(localStorage.getItem(KEY));
      if (!c || (c.v !== 'granted' && c.v !== 'denied')) return null;
      var ttl = c.v === 'granted' ? 13 * MONTH : 6 * MONTH;
      if (!c.t || Date.now() - c.t > ttl) return null;
      return c.v;
    } catch (e) { return null; }
  }

  function saveChoice(v) {
    try { localStorage.setItem(KEY, JSON.stringify({ v: v, t: Date.now() })); } catch (e) {}
  }

  var loaded = false;
  function loadGA() {
    if (loaded) return;
    loaded = true;
    window['ga-disable-' + GA_ID] = false;
    var s = document.createElement('script');
    s.async = true;
    s.src = 'https://www.googletagmanager.com/gtag/js?id=' + GA_ID;
    document.head.appendChild(s);
    window.dataLayer = window.dataLayer || [];
    function gtag() { window.dataLayer.push(arguments); }
    window.gtag = gtag;
    gtag('js', new Date());
    gtag('config', GA_ID);
  }

  // Supprime les cookies GA (_ga, _ga_<ID>) sur le domaine et ses parents.
  function clearGACookies() {
    window['ga-disable-' + GA_ID] = true;
    var names = ['_ga', '_ga_' + GA_ID.replace('G-', ''), '_gid', '_gat'];
    var host = location.hostname;
    var domains = ['', host, '.' + host];
    var parts = host.split('.');
    if (parts.length > 2) domains.push('.' + parts.slice(-2).join('.'));
    names.forEach(function (n) {
      domains.forEach(function (d) {
        document.cookie = n + '=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/' + (d ? '; domain=' + d : '');
      });
    });
  }

  function closeBanner() {
    var b = document.getElementById('bi-consent');
    if (b) b.remove();
  }

  function decide(v) {
    saveChoice(v);
    closeBanner();
    if (v === 'granted') loadGA();
    else { clearGACookies(); if (loaded) window.gtag = undefined; }
  }

  function injectStyle() {
    if (document.getElementById('bi-consent-style')) return;
    var st = document.createElement('style');
    st.id = 'bi-consent-style';
    st.textContent =
      '#bi-consent{position:fixed;left:16px;right:16px;bottom:16px;z-index:9999;max-width:560px;' +
      'background:var(--white,#fff);color:var(--ink,#1C2B3A);border:1px solid var(--border2,#C8C3B8);' +
      'border-radius:10px;box-shadow:0 12px 40px rgba(0,0,0,.22);padding:18px 20px;font-family:var(--sans,system-ui,sans-serif)}' +
      '#bi-consent .bi-c-title{font-size:14px;font-weight:700;margin:0 0 6px}' +
      '#bi-consent .bi-c-body{font-size:13px;line-height:1.55;color:var(--text2,#3D3A35);margin:0 0 14px}' +
      '#bi-consent .bi-c-body a{color:var(--rust,#D4500A);text-decoration:underline}' +
      '#bi-consent .bi-c-actions{display:flex;gap:10px}' +
      '#bi-consent button{flex:1;min-height:40px;padding:0 16px;border-radius:6px;font-size:13px;font-weight:600;' +
      'font-family:inherit;cursor:pointer;border:1px solid var(--ink,#1C2B3A);background:var(--ink,#1C2B3A);color:#fff}' +
      '#bi-consent button:hover{opacity:.88}' +
      '@media(min-width:640px){#bi-consent{left:24px;right:auto;bottom:24px}}';
    document.head.appendChild(st);
  }

  function showBanner() {
    if (document.getElementById('bi-consent')) return;
    injectStyle();
    var tx = TXT[lang()];
    var root = window.ROOT_PREFIX || '';
    var policy = root + (lang() === 'en' ? 'en/privacy-policy.html' : 'politique-confidentialite.html');
    var b = document.createElement('div');
    b.id = 'bi-consent';
    b.setAttribute('role', 'dialog');
    b.setAttribute('aria-label', tx.aria);
    b.innerHTML =
      '<p class="bi-c-title"></p><p class="bi-c-body"></p>' +
      '<div class="bi-c-actions"><button type="button" data-v="denied"></button><button type="button" data-v="granted"></button></div>';
    b.querySelector('.bi-c-title').textContent = tx.title;
    var body = b.querySelector('.bi-c-body');
    body.textContent = tx.body + ' ';
    var a = document.createElement('a');
    a.href = policy;
    a.textContent = tx.more;
    body.appendChild(a);
    b.querySelector('[data-v="denied"]').textContent = tx.refuse;
    b.querySelector('[data-v="granted"]').textContent = tx.accept;
    b.addEventListener('click', function (e) {
      var v = e.target && e.target.getAttribute && e.target.getAttribute('data-v');
      if (v) decide(v);
    });
    document.body.appendChild(b);
  }

  // Appelé par le lien « Gérer les cookies » du pied de page.
  window.biCookieSettings = function () { closeBanner(); showBanner(); return false; };

  var choice = readChoice();
  if (choice === 'granted') loadGA();
  else if (choice === 'denied') clearGACookies();
  else {
    // Pas encore de choix : on supprime d'éventuels cookies posés avant le bandeau.
    clearGACookies();
    if (document.body) showBanner();
    else document.addEventListener('DOMContentLoaded', showBanner);
  }
})();
