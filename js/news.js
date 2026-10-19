// ═══════════════════════════════
// ACTUALITÉS — fonctions partagées par les pages blog/actus.html, blog/actu.html et l'onglet « Actualités » de
// pages/admin.html : rendu sécurisé du texte, cartes, dates, texte du post LinkedIn.
//
// Le texte d'une actualité s'écrit en balisage minimal (toujours échappé, jamais de HTML libre) :
//   - un paragraphe = un bloc séparé du suivant par une ligne vide ;
//   - « ## Titre » sur une ligne seule : intertitre ;
//   - des lignes commençant par « - » : liste à puces ;
//   - **gras** et [libellé](https://lien) dans le texte.
// Le Worker (cloudflare/supabase-proxy-worker.js) contient la MÊME logique pour le rendu côté serveur : toute
// modification ici doit y être reportée (un test compare les deux sorties).
// ═══════════════════════════════
const NEWS_SITE = 'https://www.buy-inner.com';
const NEWS_KIND_LABEL = { company: 'Actu Buy-inner', watch: 'Veille sectorielle' };

function newsEsc(s) {
  return String(s == null ? '' : s).replace(/[&<>"']/g, ch => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[ch]));
}

// Mise en forme dans une ligne : on échappe d'abord, puis on reconnaît le balisage (liens http(s) uniquement).
function newsInline(s) {
  return newsEsc(s)
    .replace(/\[([^\]]+)\]\((https?:\/\/[^\s)]+)\)/g, '<a href="$2" target="_blank" rel="noopener">$1</a>')
    .replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
}

function renderNewsBody(text) {
  return String(text || '').replace(/\r\n?/g, '\n').split(/\n[ \t]*\n/).map(b => b.trim()).filter(Boolean).map(block => {
    const lines = block.split('\n').map(l => l.trim()).filter(Boolean);
    if (lines.length === 1 && lines[0].startsWith('## ')) return '<h3>' + newsInline(lines[0].slice(3)) + '</h3>';
    if (lines.every(l => l.startsWith('- '))) return '<ul>' + lines.map(l => '<li>' + newsInline(l.slice(2)) + '</li>').join('') + '</ul>';
    return '<p>' + lines.map(newsInline).join('<br>') + '</p>';
  }).join('\n');
}

// « Titre d'une actu » -> « titre-d-une-actu » (sans accents, 80 caractères maximum, coupé sur un tiret).
function newsSlugify(title) {
  const s = String(title || '').normalize('NFD').replace(/[̀-ͯ]/g, '').toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '');
  return s.length > 80 ? s.slice(0, 80).replace(/-[^-]*$/, '') || s.slice(0, 80) : s;
}

const newsDate = iso => iso ? new Date(iso).toLocaleDateString('fr-FR', { day: 'numeric', month: 'long', year: 'numeric', timeZone: 'Europe/Paris' }) : '';
const newsPageUrl = (slug, base) => (base == null ? NEWS_SITE : base) + '/blog/actu.html?slug=' + encodeURIComponent(slug);

// Carte d'une actualité dans une liste. `hrefBase` : préfixe des liens (« actu.html » depuis blog/).
function newsCardHtml(n, hrefBase) {
  const href = (hrefBase || 'actu.html') + '?slug=' + encodeURIComponent(n.slug);
  const kind = n.kind === 'watch' ? 'watch' : 'company';
  return '<article class="news-card" data-kind="' + kind + '">' +
    '<div class="news-card-meta"><span class="news-tag news-tag-' + kind + '">' + NEWS_KIND_LABEL[kind] + '</span>' +
    '<time datetime="' + newsEsc(n.published_at) + '">' + newsEsc(newsDate(n.published_at)) + '</time></div>' +
    '<h2><a href="' + newsEsc(href) + '">' + newsEsc(n.title) + '</a></h2>' +
    '<p>' + newsEsc(n.summary) + '</p>' +
    (kind === 'watch' && n.source_name ? '<div class="news-card-source">Source : ' + newsEsc(n.source_name) + '</div>' : '') +
    '</article>';
}

// En-tête et corps d'une page d'actualité (titre, résumé, date, source, texte, image). MÊME rendu que le Worker.
const newsIsUrl = u => /^https?:\/\//i.test(u || '');
function newsArticleParts(n) {
  const watch = n.kind === 'watch';
  const label = NEWS_KIND_LABEL[watch ? 'watch' : 'company'];
  return {
    title: n.title + ' — Actualités Buy-inner',
    desc: String(n.summary || '').slice(0, 200),
    headerHtml: '<div class="cat-eyebrow">' + newsEsc(label) + '</div><h1>' + newsEsc(n.title) + '</h1><p class="cat-hero-desc">' + newsEsc(n.summary) + '</p>' +
      '<div class="article-meta"><time datetime="' + newsEsc(n.published_at) + '">' + newsEsc(newsDate(n.published_at)) + '</time>' + (watch && n.source_name ? '<span>Source : ' + newsEsc(n.source_name) + '</span>' : '') + '</div>',
    bodyHtml: (newsIsUrl(n.image_url) ? '<img class="news-image" src="' + newsEsc(n.image_url) + '" alt="' + newsEsc(n.title) + '"/>' : '') +
      renderNewsBody(n.body) +
      (watch && newsIsUrl(n.source_url) ? '<p class="news-source">Source originale : <a href="' + newsEsc(n.source_url) + '" target="_blank" rel="noopener">' + newsEsc(n.source_name || n.source_url) + '</a>. Résumé rédigé par Buy-inner : pour le texte complet, consultez l\'article d\'origine.</p>' : ''),
  };
}

// ── Post LinkedIn ──────────────────────────────────────────────────────
const newsHashtag = t => '#' + String(t || '').normalize('NFD').replace(/[̀-ͯ]/g, '').replace(/[^A-Za-z0-9]+/g, '');
function newsTrackedUrl(n) { return newsPageUrl(n.slug) + '&utm_source=linkedin&utm_medium=social&utm_campaign=actus'; }

// Texte proposé (modifiable) : le lien vers le site est toujours présent. Pour une veille, la source est citée.
function newsLinkedinText(n) {
  const tags = [...new Set([...(n.tags || []).map(newsHashtag).filter(t => t.length > 1), '#BuyInner'])].slice(0, 6).join(' ');
  const link = newsTrackedUrl(n);
  if (n.kind === 'watch') {
    return n.title + '\n\n' + n.summary + '\n\nSource : ' + (n.source_name || '') + '\nNotre résumé, avec le lien vers l\'article d\'origine : ' + link + '\n\n' + tags;
  }
  return '📣 ' + n.title + '\n\n' + n.summary + '\n\n👉 La suite : ' + link + '\n\n' + tags;
}
// Ouvre la fenêtre de partage LinkedIn avec le lien prérempli (LinkedIn n'accepte plus de texte dans l'adresse :
// le texte se colle depuis le presse-papiers).
const newsShareUrl = n => 'https://www.linkedin.com/sharing/share-offsite/?url=' + encodeURIComponent(newsTrackedUrl(n));

if (typeof module !== 'undefined') module.exports = { newsArticleParts, newsIsUrl, newsEsc, newsInline, renderNewsBody, newsSlugify, newsDate, newsPageUrl, newsCardHtml, newsLinkedinText, newsShareUrl, newsTrackedUrl, newsHashtag, NEWS_KIND_LABEL };
