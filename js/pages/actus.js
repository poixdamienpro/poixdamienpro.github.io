// ═══════════════════════════════
// PAGES ACTUALITÉS — blog/actus.html et blog/actu.html?slug=… (français), en/news.html et en/news-item.html?slug=…
// (anglais), plus le bloc « Dernières actualités » de blog/index.html.
// La langue est celle de la page (<html lang>). Sur le site publié, le Worker (cloudflare/supabase-proxy-worker.js) a
// déjà rendu le contenu côté serveur : ce script ne fait alors rien de plus que de mettre à jour le lien de partage.
// Sans le Worker (aperçu local, route non configurée), il charge lui-même les actualités et les affiche avec le même
// rendu (js/news.js).
// ═══════════════════════════════
const NEWS_PAGE_LANG = ((document.documentElement.lang || 'fr').toLowerCase().startsWith('en')) ? 'en' : 'fr';
const NEWS_TXT = {
  fr: { empty: 'Les premières actualités arrivent bientôt.', loadErr: 'Impossible de charger les actualités pour le moment. Réessayez dans un instant.',
        gone: 'Cette actualité n\'existe pas ou n\'est plus en ligne.', all: 'Voir toutes les actualités', goneTitle: 'Actualité introuvable', goneTab: 'Actualité introuvable | Buy-inner',
        itemErr: 'Impossible de charger cette actualité pour le moment.', eyebrow: 'Actualités' },
  en: { empty: 'The first news items are coming soon.', loadErr: 'Unable to load the news right now. Please try again in a moment.',
        gone: 'This news item does not exist or is no longer online.', all: 'See all news', goneTitle: 'News item not found', goneTab: 'News item not found | Buy-inner',
        itemErr: 'Unable to load this news item right now.', eyebrow: 'News' },
}[NEWS_PAGE_LANG];
const NEWS_SSR = () => !!document.querySelector('script[type="application/ld+json"][data-ssr]');

async function newsFetchPage(limit) {
  return fetchRpc('get_news_page', { p_limit: limit, p_offset: 0 });
}

async function initNewsList() {
  const box = document.getElementById('news-list');
  if (!box || box.querySelector('.news-card')) return;          // déjà rendu par le serveur
  try {
    const rows = (await newsFetchPage(50)).filter(n => newsHasLang(n, NEWS_PAGE_LANG));
    box.innerHTML = rows.length ? rows.map(n => newsCardHtml(n, undefined, NEWS_PAGE_LANG)).join('') : '<p class="news-empty">' + NEWS_TXT.empty + '</p>';
  } catch (err) {
    console.error('Erreur chargement actualités:', err);
    box.innerHTML = '<p class="news-empty">' + NEWS_TXT.loadErr + '</p>';
  }
}

async function initNewsLatest() {
  const box = document.getElementById('news-latest-list');
  if (!box) return;
  const sec = document.getElementById('news-latest');
  try {
    const rows = (await newsFetchPage(6)).filter(n => newsHasLang(n, NEWS_PAGE_LANG)).slice(0, 3);
    if (!rows.length) { if (sec) sec.remove(); return; }
    box.innerHTML = rows.map(n => newsCardHtml(n, undefined, NEWS_PAGE_LANG)).join('');
    if (sec) sec.hidden = false;
  } catch (err) {
    if (sec) sec.remove();   // bloc facultatif : on le retire plutôt que d'afficher une erreur
  }
}

async function initNewsArticle() {
  const body = document.getElementById('news-body');
  if (!body) return;
  const slug = new URLSearchParams(window.location.search).get('slug') || '';
  const canonical = slug ? newsPageUrl(slug, NEWS_PAGE_LANG) : NEWS_SITE + NEWS_I18N[NEWS_PAGE_LANG].listPath;
  const share = document.getElementById('news-share');
  if (share) share.href = 'https://www.linkedin.com/sharing/share-offsite/?url=' + encodeURIComponent(canonical);
  if (NEWS_SSR()) return;                                          // contenu déjà rendu par le serveur

  const listHref = NEWS_PAGE_LANG === 'en' ? 'news.html' : 'actus.html';
  const notFound = () => {
    document.getElementById('news-header').innerHTML = '<div class="cat-eyebrow">' + NEWS_TXT.eyebrow + '</div><h1>' + NEWS_TXT.goneTitle + '</h1>';
    body.innerHTML = '<p>' + NEWS_TXT.gone + ' <a href="' + listHref + '">' + NEWS_TXT.all + '</a>.</p>';
    document.title = NEWS_TXT.goneTab;
  };
  if (!/^[a-z0-9]+(-[a-z0-9]+)*$/.test(slug)) return notFound();
  try {
    const n = await fetchOne('get_news_by_slug', { p_slug: slug });
    if (!n || !newsHasLang(n, NEWS_PAGE_LANG) || !newsField(n, NEWS_PAGE_LANG).body) return notFound();
    const parts = newsArticleParts(n, NEWS_PAGE_LANG);
    document.title = parts.title;
    const meta = document.querySelector('meta[name="description"]'); if (meta) meta.setAttribute('content', parts.desc);
    document.getElementById('news-header').innerHTML = parts.headerHtml;
    body.innerHTML = parts.bodyHtml;
  } catch (err) {
    console.error('Erreur chargement actualité:', err);
    body.innerHTML = '<p>' + NEWS_TXT.itemErr + ' <a href="' + listHref + '">' + NEWS_TXT.all + '</a>.</p>';
  }
}

document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  initNewsList();
  initNewsLatest();
  initNewsArticle();
});
