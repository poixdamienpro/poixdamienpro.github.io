// ═══════════════════════════════
// ADMIN — onglet « Actualités » (blog > Actualités), bilingue français / anglais.
// Rédaction, brouillons, publication immédiate ou programmée, et « kit LinkedIn » proposé après chaque publication :
// pour chaque langue, texte du post prêt à copier + bouton qui ouvre le partage LinkedIn avec le lien de la page dans
// cette langue (suivi par des paramètres utm). Rien n'est publié sur LinkedIn automatiquement : c'est la personne
// connectée qui clique « Publier » là-bas.
// Chaque actualité doit exister dans les DEUX langues pour être publiée (la base l'impose) ; un brouillon peut n'avoir
// que le français.
// Propositions de Claude : la routine de veille dépose 2-3 brouillons d'actualités déjà rédigés (FR + EN) dans
// news_suggestions (backend/supabase_news_suggestions_2026_10.sql, via /api/news-ingest du Worker). Quand on veut créer
// une actualité, on en choisit une, on la modifie librement, puis on la publie comme n'importe quelle autre : rien
// n'est publié sans validation humaine.
// Tables : news_posts (backend/supabase_news_2026_10.sql et supabase_news_en_2026_10.sql). Utilise
// adminFetch / adminFetchAllPages (admin.js) et le rendu partagé de js/news.js (le même que celui des pages publiques,
// pour une prévisualisation fidèle).
// ═══════════════════════════════
let adminNewsRows = [];
let adminNewsEditingId = null;     // null = nouvelle actualité
let adminNewsKitId = null;         // actualité dont le kit LinkedIn est ouvert
let adminNewsSuggestions = [];     // propositions de Claude en attente (les 3 plus récentes)
let adminNewsFromSuggestion = null; // proposition en cours de modification dans l'éditeur
const NEWS_BODY_LIMIT = { company: 8000, watch: 1500 };
const NEWS_LANGS = [['fr', 'Français'], ['en', 'English']];
const NEWS_KIND_FR = NEWS_I18N.fr.kind;

const newsIsLive = r => r.status === 'published' && r.published_at && new Date(r.published_at) <= new Date();
const newsIsScheduled = r => r.status === 'published' && r.published_at && new Date(r.published_at) > new Date();
const newsFmt = iso => iso ? new Date(iso).toLocaleString('fr-FR', { dateStyle: 'medium', timeStyle: 'short' }) : '';
const newsToLocalInput = iso => { if (!iso) return ''; const d = new Date(iso); d.setMinutes(d.getMinutes() - d.getTimezoneOffset()); return d.toISOString().slice(0, 16); };
const newsPostedAt = (r, lang) => lang === 'en' ? r.linkedin_posted_en_at : r.linkedin_posted_at;

async function loadAdminNews() {
  const list = document.getElementById('admin-news-list');
  if (!list) return;
  if (!adminNewsRows.length) list.innerHTML = '<div class="admin-empty">Chargement…</div>';
  try {
    adminNewsRows = await adminFetchAllPages('news_posts?select=*&order=created_at.desc,id.asc');
    renderAdminNews();
    loadNewsSuggestions();
  } catch (err) {
    list.innerHTML = `<div class="admin-empty">${escapeHtml(err.message)}${/42P01|does not exist|schema cache|PGRST205/i.test(err.message) ? '<br>La table n\'existe pas encore : exécute backend/supabase_news_2026_10.sql puis backend/supabase_news_en_2026_10.sql dans Supabase.' : ''}</div>`;
  }
}

// Pastille sur l'onglet : actualités en ligne qui n'ont encore aucun post LinkedIn (ni français, ni anglais).
function updateNewsBadge() {
  const badge = document.getElementById('admin-news-badge');
  if (!badge) return;
  const n = adminNewsRows.filter(r => newsIsLive(r) && !r.linkedin_posted_at && !r.linkedin_posted_en_at).length;
  badge.textContent = n; badge.hidden = n === 0;
  badge.title = n ? n + ' actualité(s) en ligne sans post LinkedIn' : '';
}

function newsStatusLabel(r) {
  if (newsIsLive(r)) return 'Publiée le ' + newsFmt(r.published_at);
  if (newsIsScheduled(r)) return 'Programmée le ' + newsFmt(r.published_at);
  return 'Brouillon';
}

function renderAdminNews() {
  updateNewsBadge();
  const list = document.getElementById('admin-news-list');
  if (!list) return;
  if (!adminNewsRows.length) { list.innerHTML = '<div class="admin-empty">Aucune actualité pour le moment. Clique sur « Nouvelle actualité ».</div>'; return; }
  list.innerHTML = adminNewsRows.map(r => {
    const live = newsIsLive(r);
    const hasEn = newsHasLang(r, 'en') && !!r.body_en;
    const enBadge = hasEn ? '<span style="color:#2D6A4F">FR + EN ✓</span>' : '<span style="color:#C0392B">Version anglaise manquante</span>';
    const posted = NEWS_LANGS.map(([l]) => newsPostedAt(r, l) ? `<span style="color:#2D6A4F">✓ ${l.toUpperCase()} posté le ${escapeHtml(newsFmt(newsPostedAt(r, l)))}</span>` : '').filter(Boolean).join(' · ');
    const li = posted || (live ? '<span style="color:#C0392B">Pas encore posté sur LinkedIn</span>' : '');
    const anyPosted = !!(r.linkedin_posted_at || r.linkedin_posted_en_at);
    return `
    <div class="admin-card" id="admin-news-${r.id}">
      <div class="admin-card-head">
        <div>
          <div class="admin-card-title">${escapeHtml(r.title)}</div>
          <div class="admin-card-meta">${escapeHtml(NEWS_KIND_FR[r.kind] || r.kind)} · ${escapeHtml(newsStatusLabel(r))}${r.kind === 'watch' && r.source_name ? ' · Source : ' + escapeHtml(r.source_name) : ''} · ${enBadge}</div>
          <div class="admin-card-meta">${li}</div>
        </div>
        <span class="tag" style="white-space:nowrap">${live ? 'En ligne' : (newsIsScheduled(r) ? 'Programmée' : 'Brouillon')}</span>
      </div>
      <p style="font-size:12px;color:var(--text2);margin:8px 0">${escapeHtml(r.summary)}</p>
      ${hasEn ? `<p style="font-size:12px;color:var(--muted);margin:0 0 8px"><strong>EN</strong> · ${escapeHtml(r.title_en)}</p>` : ''}
      <div class="admin-actions" style="flex-wrap:wrap">
        <button class="btn-approve" style="background:var(--steel)" onclick="newsEditorOpen('${r.id}')">Modifier</button>
        ${live ? `<a class="btn-approve" style="text-align:center;text-decoration:none;background:var(--steel)" href="${escapeHtml(newsPageUrl(r.slug, 'fr'))}" target="_blank" rel="noopener">Voir FR</a>` : ''}
        ${live && hasEn ? `<a class="btn-approve" style="text-align:center;text-decoration:none;background:var(--steel)" href="${escapeHtml(newsPageUrl(r.slug, 'en'))}" target="_blank" rel="noopener">Voir EN</a>` : ''}
        ${live ? `<button class="btn-approve" onclick="newsKitToggle('${r.id}')">${anyPosted ? 'Kit LinkedIn' : 'Post LinkedIn →'}</button>` : ''}
        <button class="btn-reject" onclick="newsDelete('${r.id}')">Supprimer</button>
      </div>
      <div id="admin-news-kit-${r.id}"></div>
    </div>`;
  }).join('');
  if (adminNewsKitId) newsKitRender(adminNewsKitId);
}

// ── Éditeur ───────────────────────────────────────────────────────────
function newsEditorOpen(id, prefill) {
  adminNewsEditingId = id;
  if (id) adminNewsFromSuggestion = null;
  const r = id ? adminNewsRows.find(x => x.id === id) : null;
  const box = document.getElementById('admin-news-editor');
  const v = r || prefill || { kind: 'company', title: '', slug: '', summary: '', body: '', title_en: '', summary_en: '', body_en: '', source_name: '', source_url: '', image_url: '', tags: [], published_at: null, status: 'draft' };
  box.hidden = false;
  const field = (lang, suffix) => (lang === 'en' ? v[suffix + '_en'] : v[suffix]) || '';
  const langBlock = ([lang, name]) => {
    const p = lang === 'en' ? 'nw-en-' : 'nw-';
    const sfx = lang === 'en' ? '-en' : '';
    return `
      <div style="border:1px solid var(--border);border-radius:8px;padding:14px;margin-bottom:14px;${lang === 'en' ? 'background:rgba(91,139,181,.05)' : ''}">
        <div style="font-weight:700;font-size:13px;margin-bottom:10px">${lang === 'fr' ? '🇫🇷 Version française' : '🇬🇧 English version <span style="font-weight:400;color:var(--muted)">(obligatoire pour publier)</span>'}</div>
        <div class="lead-field"><label>${lang === 'fr' ? 'Titre' : 'Title'}</label><input type="text" id="nw-title${sfx}" maxlength="160" value="${escapeHtml(field(lang, 'title'))}"${lang === 'fr' ? ' oninput="newsEditorTitleChanged()"' : ''}/></div>
        <div class="lead-field"><label>${lang === 'fr' ? 'Résumé' : 'Summary'} (affiché dans les listes, les aperçus de partage et le post LinkedIn) <span id="nw-summary${sfx}-count" style="color:var(--muted)"></span></label>
          <textarea id="nw-summary${sfx}" rows="2" maxlength="300" oninput="newsEditorCounters()">${escapeHtml(field(lang, 'summary'))}</textarea></div>
        <div class="lead-field"><label>${lang === 'fr' ? 'Texte' : 'Text'} <span id="nw-body${sfx}-count" style="color:var(--muted)"></span></label>
          <textarea id="nw-body${sfx}" rows="8" maxlength="8000" oninput="newsEditorCounters()">${escapeHtml(field(lang, 'body'))}</textarea></div>
      </div>`;
  };
  box.innerHTML = `
    <div class="admin-card" style="border:2px solid var(--rust)">
      <div class="admin-card-head"><div class="admin-card-title">${r ? 'Modifier l\'actualité' : 'Nouvelle actualité'}</div></div>
      ${adminNewsFromSuggestion ? newsFromSuggestionBanner() : ''}
      <div class="lead-field" style="max-width:320px"><label>Type</label>
        <select id="nw-kind" onchange="newsEditorKindChanged()">
          <option value="company"${v.kind === 'company' ? ' selected' : ''}>Actu Buy-inner (annonce, nouveauté, partenariat…)</option>
          <option value="watch"${v.kind === 'watch' ? ' selected' : ''}>Veille sectorielle (résumé d'un article tiers)</option>
        </select></div>
      <div class="lead-field"><label>Adresse de la page (générée depuis le titre français, identique dans les deux langues)</label>
        <input type="text" id="nw-slug" maxlength="90" value="${escapeHtml(v.slug)}" ${r && newsIsLive(r) ? 'readonly title="Adresse figée : l\'actualité est en ligne et déjà partageable"' : ''} oninput="document.getElementById('nw-slug').dataset.touched='1'; newsEditorUrlHint()"/>
        <div style="font-size:11px;color:var(--muted);margin-top:4px" id="nw-slug-url"></div></div>
      ${NEWS_LANGS.map(langBlock).join('')}
      <div style="font-size:11px;color:var(--muted);margin:-6px 0 14px">Mise en forme du texte : une ligne vide = nouveau paragraphe · <code>## Titre</code> = intertitre · lignes commençant par <code>- </code> = liste · <code>**gras**</code> · <code>[texte](https://lien)</code>. Le HTML n'est jamais interprété.</div>
      <div id="nw-watch-box">
        <div style="background:rgba(63,154,114,.08);border:1px solid rgba(63,154,114,.3);border-radius:6px;padding:10px 12px;font-size:12px;color:var(--text2);margin-bottom:12px">
          <strong>Veille : résumez avec vos propres mots</strong> (1 500 caractères maximum par langue). Ne recopiez pas le texte de l'article d'origine : citez la source et renvoyez vers elle. Le nom et le lien de la source sont obligatoires.</div>
        <div class="lead-field"><label>Nom de la source (ex. ESA, Les Échos, Saft)</label><input type="text" id="nw-source-name" maxlength="120" value="${escapeHtml(v.source_name || '')}"/></div>
        <div class="lead-field"><label>Lien de l'article d'origine</label><input type="url" id="nw-source-url" placeholder="https://…" value="${escapeHtml(v.source_url || '')}"/></div>
      </div>
      <div class="lead-field"><label>Image (lien https, facultatif — sert d'aperçu sur LinkedIn ; à défaut, le logo Buy-inner)</label><input type="url" id="nw-image" placeholder="https://…" value="${escapeHtml(v.image_url || '')}"/></div>
      <div class="lead-field"><label>Thèmes (séparés par des virgules, 8 maximum — deviennent des hashtags LinkedIn, communs aux deux langues)</label><input type="text" id="nw-tags" value="${escapeHtml((v.tags || []).join(', '))}" placeholder="Spatial, Batteries, Partenariat"/></div>
      <div class="lead-field" style="max-width:320px"><label>Date de publication (vide = au moment de publier ; dans le futur = programmée)</label><input type="datetime-local" id="nw-date" value="${escapeHtml(newsToLocalInput(v.published_at))}"/></div>
      <p id="nw-error" style="color:#C0392B;font-size:12px;margin:8px 0;display:none"></p>
      <div class="admin-actions" style="flex-wrap:wrap">
        <button class="btn-approve" onclick="newsSave(false)">${r && r.status === 'published' ? 'Enregistrer (reste publiée)' : 'Enregistrer le brouillon'}</button>
        ${r && r.status === 'published' ? `<button class="btn-reject" style="flex:none" onclick="newsSave('unpublish')">Dépublier</button>` : '<button class="btn-approve" style="background:var(--rust)" onclick="newsSave(true)">Publier (FR + EN)</button>'}
        <button class="btn-approve" style="background:var(--steel)" onclick="newsPreviewToggle('fr')">Aperçu FR</button>
        <button class="btn-approve" style="background:var(--steel)" onclick="newsPreviewToggle('en')">Aperçu EN</button>
        <button class="btn-reject" style="flex:none" onclick="newsEditorClose()">Fermer</button>
      </div>
      <div id="nw-preview" class="news-preview" hidden></div>
    </div>`;
  document.getElementById('nw-slug').dataset.touched = r ? '1' : '';
  newsEditorKindChanged(); newsEditorCounters(); newsEditorUrlHint();
  box.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

function newsEditorClose() {
  adminNewsEditingId = null;
  adminNewsFromSuggestion = null;
  const box = document.getElementById('admin-news-editor'); box.hidden = true; box.innerHTML = '';
}

function newsEditorKindChanged() {
  const watch = document.getElementById('nw-kind').value === 'watch';
  document.getElementById('nw-watch-box').style.display = watch ? 'block' : 'none';
  const max = NEWS_BODY_LIMIT[watch ? 'watch' : 'company'];
  document.getElementById('nw-body').maxLength = max; document.getElementById('nw-body-en').maxLength = max;
  newsEditorCounters();
}
function newsEditorTitleChanged() {
  const slug = document.getElementById('nw-slug');
  if (slug.dataset.touched !== '1' && !slug.readOnly) slug.value = newsSlugify(document.getElementById('nw-title').value);
  newsEditorUrlHint();
}
function newsEditorUrlHint() {
  const el = document.getElementById('nw-slug-url'); if (!el) return;
  const slug = document.getElementById('nw-slug').value || '…';
  el.innerHTML = 'FR : ' + escapeHtml(newsPageUrl(slug, 'fr')) + '<br>EN : ' + escapeHtml(newsPageUrl(slug, 'en'));
}
function newsEditorCounters() {
  const watch = document.getElementById('nw-kind').value === 'watch', max = NEWS_BODY_LIMIT[watch ? 'watch' : 'company'];
  for (const sfx of ['', '-en']) {
    const s = document.getElementById('nw-summary' + sfx).value.length, b = document.getElementById('nw-body' + sfx).value.length;
    document.getElementById('nw-summary' + sfx + '-count').textContent = `(${s}/300, 20 minimum)`;
    const bc = document.getElementById('nw-body' + sfx + '-count'); bc.textContent = `(${b}/${max})`; bc.style.color = b > max ? '#C0392B' : 'var(--muted)';
  }
}

// Valeurs du formulaire, validées comme le fait la base (mêmes règles que backend/supabase_news_2026_10.sql et
// supabase_news_en_2026_10.sql). `needEn` : l'anglais est obligatoire (publication, ou actualité déjà publiée).
function newsEditorRead(needEn) {
  const g = id => document.getElementById(id).value.trim();
  const kind = g('nw-kind');
  const tags = g('nw-tags').split(',').map(t => t.trim()).filter(Boolean);
  const o = { kind, title: g('nw-title'), slug: g('nw-slug') || newsSlugify(g('nw-title')), summary: g('nw-summary'), body: g('nw-body'),
              title_en: g('nw-title-en') || null, summary_en: g('nw-summary-en') || null, body_en: g('nw-body-en') || null,
              source_name: kind === 'watch' ? g('nw-source-name') || null : null, source_url: kind === 'watch' ? g('nw-source-url') || null : null,
              image_url: g('nw-image') || null, tags };
  const url = u => !u || /^https?:\/\/\S+$/i.test(u);
  const max = NEWS_BODY_LIMIT[kind];
  const anyEn = !!(o.title_en || o.summary_en || o.body_en);
  let err = null;
  if (o.title.length < 5 || o.title.length > 160) err = 'Le titre français doit faire entre 5 et 160 caractères.';
  else if (!/^[a-z0-9]+(-[a-z0-9]+)*$/.test(o.slug) || o.slug.length > 90) err = 'L\'adresse ne peut contenir que des minuscules, des chiffres et des tirets.';
  else if (o.summary.length < 20 || o.summary.length > 300) err = 'Le résumé français doit faire entre 20 et 300 caractères.';
  else if (o.body.length < 20) err = 'Le texte français est trop court (20 caractères minimum).';
  else if (o.body.length > max) err = kind === 'watch' ? 'Une veille est un résumé : 1 500 caractères maximum.' : 'Le texte français dépasse 8 000 caractères.';
  else if (needEn && !(o.title_en && o.summary_en && o.body_en)) err = 'La version anglaise est obligatoire pour publier : titre, résumé et texte.';
  else if (anyEn && (!o.title_en || o.title_en.length < 5 || o.title_en.length > 160)) err = 'English title: between 5 and 160 characters (titre anglais : 5 à 160 caractères).';
  else if (anyEn && (!o.summary_en || o.summary_en.length < 20 || o.summary_en.length > 300)) err = 'English summary: between 20 and 300 characters (résumé anglais : 20 à 300 caractères).';
  else if (anyEn && (!o.body_en || o.body_en.length < 20 || o.body_en.length > max)) err = kind === 'watch' ? 'English text: 1,500 characters maximum for a watch item (texte anglais : 1 500 caractères maximum).' : 'English text: 20 to 8,000 characters (texte anglais : 20 à 8 000 caractères).';
  else if (kind === 'watch' && (!o.source_name || !o.source_url)) err = 'Une veille doit citer sa source : renseigne le nom et le lien de l\'article d\'origine.';
  else if (!url(o.source_url) || !url(o.image_url)) err = 'Les liens doivent commencer par http:// ou https://.';
  else if (tags.length > 8) err = '8 thèmes maximum.';
  return { o, err };
}

function newsPreviewToggle(lang) {
  const box = document.getElementById('nw-preview');
  if (!box.hidden && box.dataset.lang === lang) { box.hidden = true; return; }
  const { o } = newsEditorRead(false);
  if (lang === 'en' && !(o.title_en && o.summary_en)) { box.innerHTML = '<div style="font-size:12px;color:#C0392B">La version anglaise est vide : remplis d\'abord le titre, le résumé et le texte anglais.</div>'; box.dataset.lang = lang; box.hidden = false; return; }
  const p = newsArticleParts({ ...o, published_at: new Date().toISOString() }, lang);
  box.innerHTML = `<div style="font-size:11px;color:var(--muted);margin-bottom:8px">Aperçu de la page publique — ${lang === 'en' ? 'English' : 'français'}</div>${p.headerHtml}<div class="cat-section">${p.bodyHtml}</div>`;
  box.dataset.lang = lang; box.hidden = false;
}

function newsErrorText(msg) {
  if (/news_posts_slug_uniq/.test(msg)) return 'Cette adresse est déjà utilisée par une autre actualité : modifie-la.';
  if (/news_posts_en_required_chk/.test(msg)) return 'La version anglaise est obligatoire pour publier : titre, résumé et texte.';
  if (/news_posts_watch_chk/.test(msg)) return 'Une veille doit citer sa source (nom et lien) et rester un résumé de 1 500 caractères maximum.';
  if (/news_posts_len_en_chk/.test(msg)) return 'Longueur invalide en anglais : titre 5–160, résumé 20–300, texte 20–8 000 caractères (1 500 pour une veille).';
  if (/news_posts_len_chk/.test(msg)) return 'Longueur invalide : titre 5–160, résumé 20–300, texte 20–8 000 caractères.';
  if (/news_posts_urls_chk/.test(msg)) return 'Les liens doivent commencer par http:// ou https://.';
  return msg;
}

// mode : false = enregistrer tel quel ; true = publier ; 'unpublish' = repasser en brouillon.
async function newsSave(mode) {
  const err = document.getElementById('nw-error'); err.style.display = 'none';
  const existing = adminNewsEditingId ? adminNewsRows.find(x => x.id === adminNewsEditingId) : null;
  const needEn = mode === true || (mode !== 'unpublish' && !!existing && existing.status === 'published');
  const { o, err: invalid } = newsEditorRead(needEn);
  if (invalid) { err.textContent = invalid; err.style.display = 'block'; return; }
  const dateRaw = document.getElementById('nw-date').value;
  const row = { ...o };
  if (mode === true) { row.status = 'published'; row.published_at = dateRaw ? new Date(dateRaw).toISOString() : new Date().toISOString(); }
  else if (mode === 'unpublish') { row.status = 'draft'; }
  else if (existing && existing.status === 'published') { row.published_at = dateRaw ? new Date(dateRaw).toISOString() : existing.published_at; }
  else if (dateRaw) { row.published_at = new Date(dateRaw).toISOString(); }
  if (mode === true && newsIsScheduled({ status: 'published', published_at: row.published_at }) && !confirm('Cette actualité sera mise en ligne le ' + newsFmt(row.published_at) + ' en français et en anglais. Confirmer la programmation ?')) return;
  try {
    const saved = await adminFetch(existing ? `news_posts?id=eq.${existing.id}` : 'news_posts', {
      method: existing ? 'PATCH' : 'POST', headers: { 'Prefer': 'return=representation' }, body: JSON.stringify(row),
    });
    const rec = Array.isArray(saved) ? saved[0] : saved;
    if (!existing && adminNewsFromSuggestion && rec) await newsSuggestMarkUsed(adminNewsFromSuggestion, rec.id);
    newsEditorClose();
    await loadAdminNews();
    if (mode === true && rec && newsIsLive(rec)) { adminNewsKitId = rec.id; renderAdminNews(); newsKitFocus(rec.id, 'Actualité publiée en français et en anglais ✓ — étape suivante : les posts LinkedIn.'); }
    else if (mode === true) alert('Actualité programmée (FR + EN). Le kit LinkedIn sera disponible une fois qu\'elle sera en ligne.');
  } catch (e) {
    err.textContent = newsErrorText(e.message); err.style.display = 'block';
  }
}

async function newsDelete(id) {
  const r = adminNewsRows.find(x => x.id === id);
  if (!r || !confirm('Supprimer définitivement « ' + r.title + ' » (FR + EN) ?' + (newsIsLive(r) ? '\n\nLes pages publiques disparaîtront (les liens déjà partagés ne fonctionneront plus).' : ''))) return;
  try {
    await adminFetch(`news_posts?id=eq.${id}`, { method: 'DELETE', headers: { 'Prefer': 'return=minimal' } });
    if (adminNewsKitId === id) adminNewsKitId = null;
    adminNewsRows = adminNewsRows.filter(x => x.id !== id);
    renderAdminNews();
  } catch (e) { alert('Erreur : ' + e.message); }
}

// ── Kit LinkedIn (un bloc par langue) ───────────────────────────────────
function newsKitToggle(id) {
  const open = adminNewsKitId === id;
  if (adminNewsKitId) { const old = document.getElementById('admin-news-kit-' + adminNewsKitId); if (old) old.innerHTML = ''; }
  adminNewsKitId = open ? null : id;
  if (!open) newsKitRender(id);
}
function newsKitFocus(id, message) {
  newsKitRender(id, message);
  const el = document.getElementById('admin-news-' + id); if (el) el.scrollIntoView({ behavior: 'smooth', block: 'center' });
}
function newsKitBlock(r, lang) {
  const id = r.id, name = lang === 'en' ? '🇬🇧 LinkedIn post — English' : '🇫🇷 Post LinkedIn — français';
  const posted = newsPostedAt(r, lang);
  if (lang === 'en' && !newsHasLang(r, 'en')) return `<div style="flex:1;min-width:280px"><div style="font-weight:700;font-size:13px;margin-bottom:6px">${name}</div><div style="font-size:12px;color:#C0392B">Pas de version anglaise : modifie l'actualité pour l'ajouter.</div></div>`;
  return `
    <div style="flex:1;min-width:300px">
      <div style="font-weight:700;font-size:13px;margin-bottom:6px">${name}</div>
      <textarea id="nw-li-text-${lang}-${id}" rows="9" style="width:100%;font-size:12px;padding:8px;border:1px solid var(--border);border-radius:4px;font-family:var(--sans)">${escapeHtml(newsLinkedinText(r, lang))}</textarea>
      <div class="admin-actions" style="flex-wrap:wrap;margin-top:8px">
        <button class="btn-approve" onclick="newsKitCopy('${id}', '${lang}', this)">1. Copier le texte</button>
        <a class="btn-approve" style="text-align:center;text-decoration:none;background:var(--steel)" href="${escapeHtml(newsShareUrl(r, lang))}" target="_blank" rel="noopener">2. Ouvrir LinkedIn</a>
        ${posted ? `<span style="font-size:12px;color:#2D6A4F;align-self:center">✓ Posté le ${escapeHtml(newsFmt(posted))}</span>` : `<button class="btn-approve" style="background:#2D6A4F" onclick="newsKitMarkPosted('${id}', '${lang}')">3. J'ai posté : marquer</button>`}
      </div>
    </div>`;
}
function newsKitRender(id, message) {
  const r = adminNewsRows.find(x => x.id === id);
  const box = document.getElementById('admin-news-kit-' + id);
  if (!r || !box) return;
  box.innerHTML = `
    <div style="margin-top:14px;padding:14px;border:1px solid var(--border);border-radius:8px;background:var(--paper)">
      ${message ? `<div style="color:#2D6A4F;font-weight:700;font-size:13px;margin-bottom:8px">${escapeHtml(message)}</div>` : ''}
      <div style="display:flex;gap:18px;flex-wrap:wrap">${NEWS_LANGS.map(([l]) => newsKitBlock(r, l)).join('')}</div>
      <div style="font-size:11px;color:var(--muted);margin-top:10px">Modifie le texte si besoin. « Ouvrir LinkedIn » prépare le partage avec le lien de la page dans la langue choisie (LinkedIn n'accepte plus de texte dans l'adresse) : colle ensuite le texte copié et clique sur « Publier » dans LinkedIn. Tu peux publier dans une seule langue ou dans les deux. Les liens sont suivis (utm) pour retrouver ces visites dans Analytics.</div>
    </div>`;
}
async function newsKitCopy(id, lang, btn) {
  const ta = document.getElementById(`nw-li-text-${lang}-${id}`);
  try { await navigator.clipboard.writeText(ta.value); btn.textContent = 'Copié ✓'; } catch (e) { ta.select(); btn.textContent = 'Sélectionné : Ctrl+C'; }
}
async function newsKitMarkPosted(id, lang) {
  const col = lang === 'en' ? 'linkedin_posted_en_at' : 'linkedin_posted_at';
  try {
    const saved = await adminFetch(`news_posts?id=eq.${id}`, { method: 'PATCH', headers: { 'Prefer': 'return=representation' }, body: JSON.stringify({ [col]: new Date().toISOString() }) });
    const rec = Array.isArray(saved) ? saved[0] : saved;
    const row = adminNewsRows.find(x => x.id === id); if (row && rec) row[col] = rec[col];
    renderAdminNews();
  } catch (e) { alert('Erreur : ' + e.message); }
}

// ── Propositions de Claude ───────────────────────────────────────────────
const newsAgo = days => new Date(Date.now() - days * 86400000).toISOString();

async function loadNewsSuggestions() {
  const box = document.getElementById('admin-news-suggest');
  if (!box) return;
  try {
    // 3 propositions au plus, des 3 dernières semaines ; la table peut ne pas exister encore (script SQL pas exécuté).
    adminNewsSuggestions = await adminFetch(`news_suggestions?status=eq.new&created_at=gte.${encodeURIComponent(newsAgo(21))}&order=created_at.desc&limit=3&select=*`) || [];
  } catch (e) { adminNewsSuggestions = []; }
  renderNewsSuggestions(false);
}

function newsSuggestCard(s) {
  const watch = s.kind === 'watch';
  return `
    <div id="admin-sugg-${s.id}" style="background:var(--white);border:1px solid var(--border);border-radius:8px;padding:14px;display:flex;flex-direction:column;gap:6px">
      <div class="admin-card-meta"><span class="tag">${escapeHtml(NEWS_KIND_FR[watch ? 'watch' : 'company'])}</span> · reçue le ${escapeHtml(newsFmt(s.created_at))}</div>
      <div class="admin-card-title" style="font-size:14px">${escapeHtml(s.title)}</div>
      <div style="font-size:12px;color:var(--text2)">${escapeHtml(s.summary)}</div>
      <div style="font-size:11px;color:var(--muted)"><strong>EN</strong> · ${escapeHtml(s.title_en)}</div>
      ${watch && s.source_url ? `<div style="font-size:11px;color:var(--muted)">Source : <a href="${escapeHtml(s.source_url)}" target="_blank" rel="noopener" style="color:var(--rust)">${escapeHtml(s.source_name || s.source_url)}</a> (à vérifier avant de publier)</div>` : ''}
      ${s.angle ? `<div style="font-size:11px;color:var(--muted);font-style:italic">${escapeHtml(s.angle)}</div>` : ''}
      <div class="admin-actions" style="margin-top:auto;padding-top:8px">
        <button class="btn-approve" onclick="newsSuggestPick('${s.id}')">Choisir et modifier</button>
        <button class="btn-reject" style="flex:none;padding:9px 12px" onclick="newsSuggestDismiss('${s.id}')">Ignorer</button>
      </div>
    </div>`;
}

// `chooser` : l'utilisateur vient de cliquer « Nouvelle actualité » et doit choisir une proposition ou partir d'une page blanche.
function renderNewsSuggestions(chooser) {
  const box = document.getElementById('admin-news-suggest');
  if (!box) return;
  if (!adminNewsSuggestions.length) { box.innerHTML = ''; return; }
  const n = adminNewsSuggestions.length;
  box.innerHTML = `
    <div style="border:2px solid ${chooser ? 'var(--rust)' : 'var(--border)'};border-radius:10px;padding:16px;background:rgba(91,139,181,.05)">
      <div style="display:flex;align-items:center;justify-content:space-between;gap:10px;flex-wrap:wrap;margin-bottom:12px">
        <div style="font-weight:700;font-size:14px">🤖 ${chooser ? 'Partir d\'une proposition de Claude ?' : 'Propositions de Claude'} <span style="font-weight:400;color:var(--muted)">(${n} prête${n > 1 ? 's' : ''}, rédigée${n > 1 ? 's' : ''} en français et en anglais)</span></div>
        ${chooser ? '<button class="btn-approve" style="flex:none;background:var(--steel);padding:8px 14px" onclick="newsEditorOpen(null)">Écrire moi-même (page blanche)</button>' : ''}
      </div>
      <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:12px">${adminNewsSuggestions.map(newsSuggestCard).join('')}</div>
      <div style="font-size:11px;color:var(--muted);margin-top:10px">Issues de la routine de veille : rien n'est publié sans ta validation. Vérifie les faits et la source, modifie le texte à ta guise, puis publie.</div>
    </div>`;
}

// « + Nouvelle actualité » : s'il y a des propositions, on les présente d'abord ; sinon éditeur vide.
async function newsNewOpen() {
  await loadNewsSuggestions();
  if (!adminNewsSuggestions.length) { newsEditorOpen(null); return; }
  newsEditorClose();
  renderNewsSuggestions(true);
  document.getElementById('admin-news-suggest').scrollIntoView({ behavior: 'smooth', block: 'start' });
}

function newsSuggestPick(id) {
  const s = adminNewsSuggestions.find(x => x.id === id);
  if (!s) return;
  adminNewsFromSuggestion = id;
  newsEditorOpen(null, {
    kind: s.kind, title: s.title, slug: '', summary: s.summary, body: s.body, title_en: s.title_en, summary_en: s.summary_en, body_en: s.body_en,
    source_name: s.source_name || '', source_url: s.source_url || '', image_url: s.image_url || '', tags: s.tags || [], published_at: null, status: 'draft',
  });
  newsEditorTitleChanged();
  renderNewsSuggestions(false);
}

function newsFromSuggestionBanner() {
  const s = adminNewsSuggestions.find(x => x.id === adminNewsFromSuggestion);
  if (!s) return '';
  return `<div style="background:rgba(91,139,181,.1);border:1px solid rgba(91,139,181,.35);border-radius:6px;padding:10px 12px;font-size:12px;color:var(--text2);margin-bottom:12px">
    🤖 <strong>Proposition de Claude</strong> — relis, corrige et adapte librement (FR et EN).${s.source_url ? ` Source à vérifier : <a href="${escapeHtml(s.source_url)}" target="_blank" rel="noopener" style="color:var(--rust)">${escapeHtml(s.source_name || s.source_url)}</a>.` : ''}${s.angle ? `<br><em>${escapeHtml(s.angle)}</em>` : ''}</div>`;
}

async function newsSuggestMarkUsed(suggId, newsId) {
  try { await adminFetch(`news_suggestions?id=eq.${suggId}`, { method: 'PATCH', headers: { 'Prefer': 'return=minimal' }, body: JSON.stringify({ status: 'used', news_id: newsId }) }); }
  catch (e) { console.error('Proposition non marquée comme utilisée :', e); }
  adminNewsFromSuggestion = null;
}

async function newsSuggestDismiss(id) {
  if (!confirm('Ignorer cette proposition ? Elle ne sera plus affichée.')) return;
  try {
    await adminFetch(`news_suggestions?id=eq.${id}`, { method: 'PATCH', headers: { 'Prefer': 'return=minimal' }, body: JSON.stringify({ status: 'dismissed' }) });
    adminNewsSuggestions = adminNewsSuggestions.filter(x => x.id !== id);
    renderNewsSuggestions(false);
    if (adminNewsSuggestions.length < 3) loadNewsSuggestions();   // la suivante prend sa place
  } catch (e) { alert('Erreur : ' + e.message); }
}
