// ═══════════════════════════════
// PAGES ACTUALITÉS — blog/actus.html (liste), blog/actu.html?slug=… (une actualité) et le bloc « Dernières
// actualités » de blog/index.html.
// Sur le site publié, le Worker (cloudflare/supabase-proxy-worker.js) a déjà rendu le contenu côté serveur : ce
// script ne fait alors rien de plus que de mettre à jour le lien de partage. Sans le Worker (aperçu local, route non
// configurée), il charge lui-même les actualités et les affiche avec le même rendu (js/news.js).
// ═══════════════════════════════
const NEWS_SSR = () => !!document.querySelector('script[type="application/ld+json"][data-ssr]');

async function newsFetchPage(limit) {
  return fetchRpc('get_news_page', { p_limit: limit, p_offset: 0 });
}

async function initNewsList() {
  const box = document.getElementById('news-list');
  if (!box || box.querySelector('.news-card')) return;          // déjà rendu par le serveur
  try {
    const rows = await newsFetchPage(50);
    box.innerHTML = rows.length ? rows.map(n => newsCardHtml(n, 'actu.html')).join('') : '<p class="news-empty">Les premières actualités arrivent bientôt.</p>';
  } catch (err) {
    console.error('Erreur chargement actualités:', err);
    box.innerHTML = '<p class="news-empty">Impossible de charger les actualités pour le moment. Réessayez dans un instant.</p>';
  }
}

async function initNewsLatest() {
  const box = document.getElementById('news-latest-list');
  if (!box) return;
  try {
    const rows = await newsFetchPage(3);
    if (!rows.length) { const sec = document.getElementById('news-latest'); if (sec) sec.remove(); return; }
    box.innerHTML = rows.map(n => newsCardHtml(n, 'actu.html')).join('');
    const shown = document.getElementById('news-latest'); if (shown) shown.hidden = false;
  } catch (err) {
    const sec = document.getElementById('news-latest'); if (sec) sec.remove();   // bloc facultatif : on le retire plutôt que d'afficher une erreur
  }
}

async function initNewsArticle() {
  const body = document.getElementById('news-body');
  if (!body) return;
  const slug = new URLSearchParams(window.location.search).get('slug') || '';
  const canonical = slug ? newsPageUrl(slug) : NEWS_SITE + '/blog/actus.html';
  const share = document.getElementById('news-share');
  if (share) share.href = 'https://www.linkedin.com/sharing/share-offsite/?url=' + encodeURIComponent(canonical);
  if (NEWS_SSR()) return;                                          // contenu déjà rendu par le serveur

  const notFound = () => {
    document.getElementById('news-header').innerHTML = '<div class="cat-eyebrow">Actualités</div><h1>Actualité introuvable</h1>';
    body.innerHTML = '<p>Cette actualité n\'existe pas ou n\'est plus en ligne. <a href="actus.html">Voir toutes les actualités</a>.</p>';
    document.title = 'Actualité introuvable | Buy-inner';
  };
  if (!/^[a-z0-9]+(-[a-z0-9]+)*$/.test(slug)) return notFound();
  try {
    const n = await fetchOne('get_news_by_slug', { p_slug: slug });
    if (!n) return notFound();
    const parts = newsArticleParts(n);
    document.title = parts.title;
    const meta = document.querySelector('meta[name="description"]'); if (meta) meta.setAttribute('content', parts.desc);
    document.getElementById('news-header').innerHTML = parts.headerHtml;
    body.innerHTML = parts.bodyHtml;
  } catch (err) {
    console.error('Erreur chargement actualité:', err);
    body.innerHTML = '<p>Impossible de charger cette actualité pour le moment. <a href="actus.html">Voir toutes les actualités</a>.</p>';
  }
}

document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  initNewsList();
  initNewsLatest();
  initNewsArticle();
});
