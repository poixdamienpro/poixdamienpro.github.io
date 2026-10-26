// ═══════════════════════════════
// ACTUALITÉS — fonctions partagées par les pages blog/actus.html, blog/actu.html (français), en/news.html,
// en/news-item.html (anglais) et l'onglet « Actualités » de pages/admin.html : rendu sécurisé du texte, cartes,
// dates, texte du post LinkedIn.
//
// Chaque actualité existe en français et en anglais (colonnes title/summary/body et title_en/summary_en/body_en) ;
// la source d'une veille, l'image, les thèmes et l'adresse (slug) sont communs. `lang` vaut 'fr' (défaut) ou 'en'.
//
// Le texte d'une actualité s'écrit en balisage minimal (toujours échappé, jamais de HTML libre) :
//   - un paragraphe = un bloc séparé du suivant par une ligne vide ;
//   - « ## Titre » sur une ligne seule : intertitre ; « ### Titre » : sous-intertitre ;
//   - des lignes commençant par « - » : liste à puces ; par « 1. », « 2. » : liste numérotée ;
//   - des lignes commençant par « > » : encadré (point clé) ;
//   - un tableau : première ligne « | A | B | », deuxième « |---|---| », puis une ligne par rangée ;
//   - **gras** et [libellé](https://lien) dans le texte.
// Le Worker (cloudflare/supabase-proxy-worker.js) contient la MÊME logique pour le rendu côté serveur : toute
// modification ici doit y être reportée (un test compare les deux sorties).
// ═══════════════════════════════
const NEWS_SITE = 'https://www.buy-inner.com';
const NEWS_I18N = {
  fr: {
    locale: 'fr-FR', kind: { company: 'Actu Buy-inner', watch: 'Veille sectorielle' }, analysis: 'Analyse technique', read: m => '≈ ' + m + ' min de lecture',
    source: 'Source : ', suffix: ' — Actualités Buy-inner',
    original: (a) => 'Source originale : ' + a + '. Texte rédigé par Buy-inner à partir de cette source ; pour aller plus loin, consultez l\'article d\'origine.',
    itemPath: '/blog/actu.html', listPath: '/blog/actus.html', hrefBase: 'actu.html',
    more: '👉 La suite : ', sourceLine: 'Source : ', summaryLine: 'Notre résumé, avec le lien vers l\'article d\'origine : ',
  },
  en: {
    locale: 'en-GB', kind: { company: 'Buy-inner news', watch: 'Industry watch' }, analysis: 'Technical analysis', read: m => '≈ ' + m + ' min read',
    source: 'Source: ', suffix: ' — Buy-inner News',
    original: (a) => 'Original source: ' + a + '. Text written by Buy-inner based on this source; for more detail, see the original article.',
    itemPath: '/en/news-item.html', listPath: '/en/news.html', hrefBase: 'news-item.html',
    more: '👉 Read more: ', sourceLine: 'Source: ', summaryLine: 'Our summary, with a link to the original article: ',
  },
};
const newsLang = l => (l === 'en' ? 'en' : 'fr');
// Champs de l'actualité dans la langue demandée.
const newsField = (n, lang) => (newsLang(lang) === 'en'
  ? { title: n.title_en, summary: n.summary_en, body: n.body_en }
  : { title: n.title, summary: n.summary, body: n.body });
// Une actualité n'est proposée en anglais que si sa version anglaise existe.
const newsHasLang = (n, lang) => { const f = newsField(n, lang); return !!(f.title && f.summary); };

function newsEsc(s) {
  return String(s == null ? '' : s).replace(/[&<>"']/g, ch => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[ch]));
}

// Mise en forme dans une ligne : on échappe d'abord, puis on reconnaît le balisage (liens http(s) uniquement).
function newsInline(s) {
  return newsEsc(s)
    .replace(/\[([^\]]+)\]\((https?:\/\/[^\s)]+)\)/g, '<a href="$2" target="_blank" rel="noopener">$1</a>')
    .replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
}

// Une ligne de tableau « | a | b | » donne ['a', 'b'] ; la 2e ligne d'un tableau est « |---|---| ».
const newsTableCells = l => l.replace(/^\|/, '').replace(/\|$/, '').split('|').map(c => c.trim());
const newsIsTableSep = l => /^\|?[\s:|-]+\|?$/.test(l) && l.includes('-') && l.includes('|');

function renderNewsBody(text) {
  return String(text || '').replace(/\r\n?/g, '\n').split(/\n[ \t]*\n/).map(b => b.trim()).filter(Boolean).map(block => {
    const lines = block.split('\n').map(l => l.trim()).filter(Boolean);
    if (lines.length === 1 && lines[0].startsWith('### ')) return '<h4>' + newsInline(lines[0].slice(4)) + '</h4>';
    if (lines.length === 1 && lines[0].startsWith('## ')) return '<h3>' + newsInline(lines[0].slice(3)) + '</h3>';
    if (lines.every(l => l.startsWith('- '))) return '<ul>' + lines.map(l => '<li>' + newsInline(l.slice(2)) + '</li>').join('') + '</ul>';
    if (lines.every(l => /^\d+[.)]\s+/.test(l))) return '<ol>' + lines.map(l => '<li>' + newsInline(l.replace(/^\d+[.)]\s+/, '')) + '</li>').join('') + '</ol>';
    if (lines.every(l => l.startsWith('>'))) return '<blockquote>' + lines.map(l => newsInline(l.replace(/^>\s?/, ''))).join('<br>') + '</blockquote>';
    if (lines.length >= 3 && lines.every(l => l.startsWith('|')) && newsIsTableSep(lines[1])) {
      const head = newsTableCells(lines[0]), n = head.length;
      const row = l => { const c = newsTableCells(l).slice(0, n); while (c.length < n) c.push(''); return c; };
      return '<div class="news-table"><table><thead><tr>' + head.map(c => '<th>' + newsInline(c) + '</th>').join('') + '</tr></thead><tbody>' +
        lines.slice(2).map(l => '<tr>' + row(l).map(c => '<td>' + newsInline(c) + '</td>').join('') + '</tr>').join('') + '</tbody></table></div>';
    }
    return '<p>' + lines.map(newsInline).join('<br>') + '</p>';
  }).join('\n');
}

// Un texte de veille d'au moins 3 000 caractères est présenté comme une « analyse technique ».
const NEWS_ANALYSIS_MIN = 3000;
const newsIsAnalysis = (n, lang) => n.kind === 'watch' && String(newsField(n, lang).body || '').length >= NEWS_ANALYSIS_MIN;
const newsKindLabel = (n, lang) => { const L = NEWS_I18N[newsLang(lang)]; return newsIsAnalysis(n, lang) ? L.analysis : L.kind[n.kind === 'watch' ? 'watch' : 'company']; };
// Temps de lecture (≈ 220 mots par minute), affiché à partir de 2 minutes.
const newsReadMinutes = text => Math.max(1, Math.round(String(text || '').trim().split(/\s+/).filter(Boolean).length / 220));

// « Titre d'une actu » -> « titre-d-une-actu » (sans accents, 80 caractères maximum, coupé sur un tiret).
function newsSlugify(title) {
  const s = String(title || '').normalize('NFD').replace(/[̀-ͯ]/g, '').toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '');
  return s.length > 80 ? s.slice(0, 80).replace(/-[^-]*$/, '') || s.slice(0, 80) : s;
}

const newsDate = (iso, lang) => iso ? new Date(iso).toLocaleDateString(NEWS_I18N[newsLang(lang)].locale, { day: 'numeric', month: 'long', year: 'numeric', timeZone: 'Europe/Paris' }) : '';
const newsPageUrl = (slug, lang, base) => (base == null ? NEWS_SITE : base) + NEWS_I18N[newsLang(lang)].itemPath + '?slug=' + encodeURIComponent(slug);

// Carte d'une actualité dans une liste. `hrefBase` : préfixe des liens (par défaut la page de la langue).
function newsCardHtml(n, hrefBase, lang) {
  const L = NEWS_I18N[newsLang(lang)], f = newsField(n, lang);
  const href = (hrefBase || L.hrefBase) + '?slug=' + encodeURIComponent(n.slug);
  const kind = n.kind === 'watch' ? 'watch' : 'company';
  return '<article class="news-card" data-kind="' + kind + '">' +
    '<div class="news-card-meta"><span class="news-tag news-tag-' + kind + '">' + newsKindLabel(n, lang) + '</span>' +
    '<time datetime="' + newsEsc(n.published_at) + '">' + newsEsc(newsDate(n.published_at, lang)) + '</time></div>' +
    '<h2><a href="' + newsEsc(href) + '">' + newsEsc(f.title) + '</a></h2>' +
    '<p>' + newsEsc(f.summary) + '</p>' +
    (kind === 'watch' && n.source_name ? '<div class="news-card-source">' + L.source + newsEsc(n.source_name) + '</div>' : '') +
    '</article>';
}

// En-tête et corps d'une page d'actualité (titre, résumé, date, source, texte, image). MÊME rendu que le Worker.
const newsIsUrl = u => /^https?:\/\//i.test(u || '');
function newsArticleParts(n, lang) {
  const L = NEWS_I18N[newsLang(lang)], f = newsField(n, lang);
  const watch = n.kind === 'watch';
  return {
    title: f.title + L.suffix,
    desc: String(f.summary || '').slice(0, 200),
    headerHtml: '<div class="cat-eyebrow">' + newsEsc(newsKindLabel(n, lang)) + '</div><h1>' + newsEsc(f.title) + '</h1><p class="cat-hero-desc">' + newsEsc(f.summary) + '</p>' +
      '<div class="article-meta"><time datetime="' + newsEsc(n.published_at) + '">' + newsEsc(newsDate(n.published_at, lang)) + '</time>' + (watch && n.source_name ? '<span>' + L.source + newsEsc(n.source_name) + '</span>' : '') + (newsReadMinutes(f.body) >= 2 ? '<span>' + L.read(newsReadMinutes(f.body)) + '</span>' : '') + '</div>',
    bodyHtml: (newsIsUrl(n.image_url) ? '<img class="news-image" src="' + newsEsc(n.image_url) + '" alt="' + newsEsc(f.title) + '"/>' : '') +
      renderNewsBody(f.body) +
      (watch && newsIsUrl(n.source_url) ? '<p class="news-source">' + L.original('<a href="' + newsEsc(n.source_url) + '" target="_blank" rel="noopener">' + newsEsc(n.source_name || n.source_url) + '</a>') + '</p>' : ''),
  };
}

// ── Post LinkedIn ──────────────────────────────────────────────────────
const newsHashtag = t => '#' + String(t || '').normalize('NFD').replace(/[̀-ͯ]/g, '').replace(/[^A-Za-z0-9]+/g, '');
function newsTrackedUrl(n, lang) { return newsPageUrl(n.slug, lang) + '&utm_source=linkedin&utm_medium=social&utm_campaign=actus'; }

// Texte proposé (modifiable), dans la langue demandée : le lien vers la page de cette langue est toujours présent.
// Pour une veille, la source est citée.
function newsLinkedinText(n, lang) {
  const L = NEWS_I18N[newsLang(lang)], f = newsField(n, lang);
  const tags = [...new Set([...(n.tags || []).map(newsHashtag).filter(t => t.length > 1), '#BuyInner'])].slice(0, 6).join(' ');
  const link = newsTrackedUrl(n, lang);
  if (n.kind === 'watch') {
    return f.title + '\n\n' + f.summary + '\n\n' + L.sourceLine + (n.source_name || '') + '\n' + L.summaryLine + link + '\n\n' + tags;
  }
  return '📣 ' + f.title + '\n\n' + f.summary + '\n\n' + L.more + link + '\n\n' + tags;
}
// Ouvre la fenêtre de partage LinkedIn avec le lien prérempli (LinkedIn n'accepte plus de texte dans l'adresse :
// le texte se colle depuis le presse-papiers).
const newsShareUrl = (n, lang) => 'https://www.linkedin.com/sharing/share-offsite/?url=' + encodeURIComponent(newsTrackedUrl(n, lang));

if (typeof module !== 'undefined') module.exports = { newsArticleParts, newsIsUrl, newsEsc, newsInline, renderNewsBody, newsSlugify, newsDate, newsPageUrl, newsCardHtml, newsLinkedinText, newsShareUrl, newsTrackedUrl, newsHashtag, newsLang, newsField, newsHasLang, NEWS_I18N, newsKindLabel, newsIsAnalysis, newsReadMinutes };
