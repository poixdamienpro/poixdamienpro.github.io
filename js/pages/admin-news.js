// ═══════════════════════════════
// ADMIN — onglet « Actualités » (blog > Actualités).
// Rédaction, brouillons, publication immédiate ou programmée, et « kit LinkedIn » proposé après chaque publication :
// texte du post prêt à copier + bouton qui ouvre le partage LinkedIn avec le lien du site (suivi par des paramètres
// utm). Rien n'est publié sur LinkedIn automatiquement : c'est la personne connectée qui clique « Publier » là-bas.
// Table : news_posts (backend/supabase_news_2026_10.sql). Utilise adminFetch / adminFetchAllPages (admin.js) et le
// rendu partagé de js/news.js (le même que celui des pages publiques, pour une prévisualisation fidèle).
// ═══════════════════════════════
let adminNewsRows = [];
let adminNewsEditingId = null;     // null = nouvelle actualité
let adminNewsKitId = null;         // actualité dont le kit LinkedIn est ouvert
const NEWS_BODY_LIMIT = { company: 8000, watch: 1500 };

const newsIsLive = r => r.status === 'published' && r.published_at && new Date(r.published_at) <= new Date();
const newsIsScheduled = r => r.status === 'published' && r.published_at && new Date(r.published_at) > new Date();
const newsFmt = iso => iso ? new Date(iso).toLocaleString('fr-FR', { dateStyle: 'medium', timeStyle: 'short' }) : '';
const newsToLocalInput = iso => { if (!iso) return ''; const d = new Date(iso); d.setMinutes(d.getMinutes() - d.getTimezoneOffset()); return d.toISOString().slice(0, 16); };

async function loadAdminNews() {
  const list = document.getElementById('admin-news-list');
  if (!list) return;
  if (!adminNewsRows.length) list.innerHTML = '<div class="admin-empty">Chargement…</div>';
  try {
    adminNewsRows = await adminFetchAllPages('news_posts?select=*&order=created_at.desc,id.asc');
    renderAdminNews();
  } catch (err) {
    list.innerHTML = `<div class="admin-empty">${escapeHtml(err.message)}${/42P01|does not exist|schema cache|PGRST205/i.test(err.message) ? '<br>La table n\'existe pas encore : exécute backend/supabase_news_2026_10.sql dans Supabase.' : ''}</div>`;
  }
}

// Pastille sur l'onglet : actualités en ligne qui n'ont pas encore leur post LinkedIn.
function updateNewsBadge() {
  const badge = document.getElementById('admin-news-badge');
  if (!badge) return;
  const n = adminNewsRows.filter(r => newsIsLive(r) && !r.linkedin_posted_at).length;
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
    const li = r.linkedin_posted_at ? `<span style="color:#2D6A4F">✓ Posté sur LinkedIn le ${escapeHtml(newsFmt(r.linkedin_posted_at))}</span>` : (live ? '<span style="color:#C0392B">Pas encore posté sur LinkedIn</span>' : '');
    return `
    <div class="admin-card" id="admin-news-${r.id}">
      <div class="admin-card-head">
        <div>
          <div class="admin-card-title">${escapeHtml(r.title)}</div>
          <div class="admin-card-meta">${escapeHtml(NEWS_KIND_LABEL[r.kind] || r.kind)} · ${escapeHtml(newsStatusLabel(r))}${r.kind === 'watch' && r.source_name ? ' · Source : ' + escapeHtml(r.source_name) : ''}</div>
          <div class="admin-card-meta">${li}</div>
        </div>
        <span class="tag" style="white-space:nowrap">${live ? 'En ligne' : (newsIsScheduled(r) ? 'Programmée' : 'Brouillon')}</span>
      </div>
      <p style="font-size:12px;color:var(--text2);margin:8px 0">${escapeHtml(r.summary)}</p>
      <div class="admin-actions" style="flex-wrap:wrap">
        <button class="btn-approve" style="background:var(--steel)" onclick="newsEditorOpen('${r.id}')">Modifier</button>
        ${live ? `<a class="btn-approve" style="text-align:center;text-decoration:none;background:var(--steel)" href="${escapeHtml(newsPageUrl(r.slug))}" target="_blank" rel="noopener">Voir la page</a>` : ''}
        ${live ? `<button class="btn-approve" onclick="newsKitToggle('${r.id}')">${r.linkedin_posted_at ? 'Kit LinkedIn' : 'Post LinkedIn →'}</button>` : ''}
        <button class="btn-reject" onclick="newsDelete('${r.id}')">Supprimer</button>
      </div>
      <div id="admin-news-kit-${r.id}"></div>
    </div>`;
  }).join('');
  if (adminNewsKitId) newsKitRender(adminNewsKitId);
}

// ── Éditeur ───────────────────────────────────────────────────────────
function newsEditorOpen(id) {
  adminNewsEditingId = id;
  const r = id ? adminNewsRows.find(x => x.id === id) : null;
  const box = document.getElementById('admin-news-editor');
  const v = r || { kind: 'company', title: '', slug: '', summary: '', body: '', source_name: '', source_url: '', image_url: '', tags: [], published_at: null, status: 'draft' };
  box.hidden = false;
  box.innerHTML = `
    <div class="admin-card" style="border:2px solid var(--rust)">
      <div class="admin-card-head"><div class="admin-card-title">${r ? 'Modifier l\'actualité' : 'Nouvelle actualité'}</div></div>
      <div class="lead-field" style="max-width:320px"><label>Type</label>
        <select id="nw-kind" onchange="newsEditorKindChanged()">
          <option value="company"${v.kind === 'company' ? ' selected' : ''}>Actu Buy-inner (annonce, nouveauté, partenariat…)</option>
          <option value="watch"${v.kind === 'watch' ? ' selected' : ''}>Veille sectorielle (résumé d'un article tiers)</option>
        </select></div>
      <div class="lead-field"><label>Titre</label><input type="text" id="nw-title" maxlength="160" value="${escapeHtml(v.title)}" oninput="newsEditorTitleChanged()"/></div>
      <div class="lead-field"><label>Adresse de la page (générée depuis le titre)</label>
        <input type="text" id="nw-slug" maxlength="90" value="${escapeHtml(v.slug)}" ${r && newsIsLive(r) ? 'readonly title="Adresse figée : l\'actualité est en ligne et déjà partageable"' : ''} oninput="document.getElementById('nw-slug').dataset.touched='1'"/>
        <div style="font-size:11px;color:var(--muted);margin-top:4px" id="nw-slug-url"></div></div>
      <div class="lead-field"><label>Résumé (affiché dans les listes, les aperçus de partage et le post LinkedIn) <span id="nw-summary-count" style="color:var(--muted)"></span></label>
        <textarea id="nw-summary" rows="2" maxlength="300" oninput="newsEditorCounters()">${escapeHtml(v.summary)}</textarea></div>
      <div class="lead-field"><label>Texte <span id="nw-body-count" style="color:var(--muted)"></span></label>
        <textarea id="nw-body" rows="9" maxlength="8000" oninput="newsEditorCounters()">${escapeHtml(v.body)}</textarea>
        <div style="font-size:11px;color:var(--muted);margin-top:4px">Une ligne vide = nouveau paragraphe · <code>## Titre</code> = intertitre · lignes commençant par <code>- </code> = liste · <code>**gras**</code> · <code>[texte](https://lien)</code>. Le HTML n'est jamais interprété.</div></div>
      <div id="nw-watch-box">
        <div style="background:rgba(63,154,114,.08);border:1px solid rgba(63,154,114,.3);border-radius:6px;padding:10px 12px;font-size:12px;color:var(--text2);margin-bottom:12px">
          <strong>Veille : résumez avec vos propres mots</strong> (1 500 caractères maximum). Ne recopiez pas le texte de l'article d'origine : citez la source et renvoyez vers elle. Le nom et le lien de la source sont obligatoires.</div>
        <div class="lead-field"><label>Nom de la source (ex. ESA, Les Échos, Saft)</label><input type="text" id="nw-source-name" maxlength="120" value="${escapeHtml(v.source_name || '')}"/></div>
        <div class="lead-field"><label>Lien de l'article d'origine</label><input type="url" id="nw-source-url" placeholder="https://…" value="${escapeHtml(v.source_url || '')}"/></div>
      </div>
      <div class="lead-field"><label>Image (lien https, facultatif — sert d'aperçu sur LinkedIn ; à défaut, le logo Buy-inner)</label><input type="url" id="nw-image" placeholder="https://…" value="${escapeHtml(v.image_url || '')}"/></div>
      <div class="lead-field"><label>Thèmes (séparés par des virgules, 8 maximum — deviennent des hashtags LinkedIn)</label><input type="text" id="nw-tags" value="${escapeHtml((v.tags || []).join(', '))}" placeholder="Spatial, Batteries, Partenariat"/></div>
      <div class="lead-field" style="max-width:320px"><label>Date de publication (vide = au moment de publier ; dans le futur = programmée)</label><input type="datetime-local" id="nw-date" value="${escapeHtml(newsToLocalInput(v.published_at))}"/></div>
      <p id="nw-error" style="color:#C0392B;font-size:12px;margin:8px 0;display:none"></p>
      <div class="admin-actions" style="flex-wrap:wrap">
        <button class="btn-approve" onclick="newsSave(false)">${r && r.status === 'published' ? 'Enregistrer (reste publiée)' : 'Enregistrer le brouillon'}</button>
        ${r && r.status === 'published' ? `<button class="btn-reject" style="flex:none" onclick="newsSave('unpublish')">Dépublier</button>` : '<button class="btn-approve" style="background:var(--rust)" onclick="newsSave(true)">Publier</button>'}
        <button class="btn-approve" style="background:var(--steel)" onclick="newsPreviewToggle()">Prévisualiser</button>
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
  const box = document.getElementById('admin-news-editor'); box.hidden = true; box.innerHTML = '';
}

function newsEditorKindChanged() {
  const watch = document.getElementById('nw-kind').value === 'watch';
  document.getElementById('nw-watch-box').style.display = watch ? 'block' : 'none';
  document.getElementById('nw-body').maxLength = NEWS_BODY_LIMIT[watch ? 'watch' : 'company'];
  newsEditorCounters();
}
function newsEditorTitleChanged() {
  const slug = document.getElementById('nw-slug');
  if (slug.dataset.touched !== '1' && !slug.readOnly) slug.value = newsSlugify(document.getElementById('nw-title').value);
  newsEditorUrlHint();
}
function newsEditorUrlHint() {
  const el = document.getElementById('nw-slug-url');
  if (el) el.textContent = newsPageUrl(document.getElementById('nw-slug').value || '…');
}
function newsEditorCounters() {
  const watch = document.getElementById('nw-kind').value === 'watch';
  const s = document.getElementById('nw-summary').value.length, b = document.getElementById('nw-body').value.length, max = NEWS_BODY_LIMIT[watch ? 'watch' : 'company'];
  document.getElementById('nw-summary-count').textContent = `(${s}/300, 20 minimum)`;
  const bc = document.getElementById('nw-body-count'); bc.textContent = `(${b}/${max})`; bc.style.color = b > max ? '#C0392B' : 'var(--muted)';
}

// Valeurs du formulaire, validées comme le fait la base (même règles que backend/supabase_news_2026_10.sql).
function newsEditorRead() {
  const g = id => document.getElementById(id).value.trim();
  const kind = g('nw-kind');
  const tags = g('nw-tags').split(',').map(t => t.trim()).filter(Boolean);
  const o = { kind, title: g('nw-title'), slug: g('nw-slug') || newsSlugify(g('nw-title')), summary: g('nw-summary'), body: g('nw-body'),
              source_name: kind === 'watch' ? g('nw-source-name') || null : null, source_url: kind === 'watch' ? g('nw-source-url') || null : null,
              image_url: g('nw-image') || null, tags };
  const url = u => !u || /^https?:\/\/\S+$/i.test(u);
  let err = null;
  if (o.title.length < 5 || o.title.length > 160) err = 'Le titre doit faire entre 5 et 160 caractères.';
  else if (!/^[a-z0-9]+(-[a-z0-9]+)*$/.test(o.slug) || o.slug.length > 90) err = 'L\'adresse ne peut contenir que des minuscules, des chiffres et des tirets.';
  else if (o.summary.length < 20 || o.summary.length > 300) err = 'Le résumé doit faire entre 20 et 300 caractères.';
  else if (o.body.length < 20) err = 'Le texte est trop court (20 caractères minimum).';
  else if (o.body.length > NEWS_BODY_LIMIT[kind]) err = kind === 'watch' ? 'Une veille est un résumé : 1 500 caractères maximum.' : 'Le texte dépasse 8 000 caractères.';
  else if (kind === 'watch' && (!o.source_name || !o.source_url)) err = 'Une veille doit citer sa source : renseigne le nom et le lien de l\'article d\'origine.';
  else if (!url(o.source_url) || !url(o.image_url)) err = 'Les liens doivent commencer par http:// ou https://.';
  else if (tags.length > 8) err = '8 thèmes maximum.';
  return { o, err };
}

function newsPreviewToggle() {
  const box = document.getElementById('nw-preview');
  if (!box.hidden) { box.hidden = true; return; }
  const { o } = newsEditorRead();
  const p = newsArticleParts({ ...o, published_at: new Date().toISOString() });
  box.innerHTML = `<div style="font-size:11px;color:var(--muted);margin-bottom:8px">Aperçu de la page publique</div>${p.headerHtml}<div class="cat-section">${p.bodyHtml}</div>`;
  box.hidden = false;
}

function newsErrorText(msg) {
  if (/news_posts_slug_uniq/.test(msg)) return 'Cette adresse est déjà utilisée par une autre actualité : modifie-la.';
  if (/news_posts_watch_chk/.test(msg)) return 'Une veille doit citer sa source (nom et lien) et rester un résumé de 1 500 caractères maximum.';
  if (/news_posts_len_chk/.test(msg)) return 'Longueur invalide : titre 5–160, résumé 20–300, texte 20–8 000 caractères.';
  if (/news_posts_urls_chk/.test(msg)) return 'Les liens doivent commencer par http:// ou https://.';
  return msg;
}

// mode : false = enregistrer tel quel ; true = publier ; 'unpublish' = repasser en brouillon.
async function newsSave(mode) {
  const err = document.getElementById('nw-error'); err.style.display = 'none';
  const { o, err: invalid } = newsEditorRead();
  if (invalid) { err.textContent = invalid; err.style.display = 'block'; return; }
  const existing = adminNewsEditingId ? adminNewsRows.find(x => x.id === adminNewsEditingId) : null;
  const dateRaw = document.getElementById('nw-date').value;
  const row = { ...o };
  if (mode === true) { row.status = 'published'; row.published_at = dateRaw ? new Date(dateRaw).toISOString() : new Date().toISOString(); }
  else if (mode === 'unpublish') { row.status = 'draft'; }
  else if (existing && existing.status === 'published') { row.published_at = dateRaw ? new Date(dateRaw).toISOString() : existing.published_at; }
  else if (dateRaw) { row.published_at = new Date(dateRaw).toISOString(); }
  if (mode === true && newsIsScheduled({ status: 'published', published_at: row.published_at }) && !confirm('Cette actualité sera mise en ligne le ' + newsFmt(row.published_at) + '. Confirmer la programmation ?')) return;
  try {
    const saved = await adminFetch(existing ? `news_posts?id=eq.${existing.id}` : 'news_posts', {
      method: existing ? 'PATCH' : 'POST', headers: { 'Prefer': 'return=representation' }, body: JSON.stringify(row),
    });
    const rec = Array.isArray(saved) ? saved[0] : saved;
    newsEditorClose();
    await loadAdminNews();
    if (mode === true && rec && newsIsLive(rec)) { adminNewsKitId = rec.id; renderAdminNews(); newsKitFocus(rec.id, 'Actualité publiée ✓ — étape suivante : le post LinkedIn.'); }
    else if (mode === true) alert('Actualité programmée. Le kit LinkedIn sera disponible une fois qu\'elle sera en ligne.');
  } catch (e) {
    err.textContent = newsErrorText(e.message); err.style.display = 'block';
  }
}

async function newsDelete(id) {
  const r = adminNewsRows.find(x => x.id === id);
  if (!r || !confirm('Supprimer définitivement « ' + r.title + ' » ?' + (newsIsLive(r) ? '\n\nLa page publique disparaîtra (le lien déjà partagé ne fonctionnera plus).' : ''))) return;
  try {
    await adminFetch(`news_posts?id=eq.${id}`, { method: 'DELETE', headers: { 'Prefer': 'return=minimal' } });
    if (adminNewsKitId === id) adminNewsKitId = null;
    adminNewsRows = adminNewsRows.filter(x => x.id !== id);
    renderAdminNews();
  } catch (e) { alert('Erreur : ' + e.message); }
}

// ── Kit LinkedIn ──────────────────────────────────────────────────────
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
function newsKitRender(id, message) {
  const r = adminNewsRows.find(x => x.id === id);
  const box = document.getElementById('admin-news-kit-' + id);
  if (!r || !box) return;
  box.innerHTML = `
    <div style="margin-top:14px;padding:14px;border:1px solid var(--border);border-radius:8px;background:var(--paper)">
      ${message ? `<div style="color:#2D6A4F;font-weight:700;font-size:13px;margin-bottom:8px">${escapeHtml(message)}</div>` : ''}
      <div style="font-weight:700;font-size:13px;margin-bottom:6px">Post LinkedIn</div>
      <textarea id="nw-li-text-${id}" rows="9" style="width:100%;font-size:12px;padding:8px;border:1px solid var(--border);border-radius:4px;font-family:var(--sans)">${escapeHtml(newsLinkedinText(r))}</textarea>
      <div style="font-size:11px;color:var(--muted);margin:6px 0 10px">Modifie le texte si besoin. « Ouvrir LinkedIn » prépare le partage avec le lien de la page (LinkedIn n'accepte plus de texte dans l'adresse) : colle ensuite le texte copié et clique sur « Publier » dans LinkedIn. Le lien est suivi (utm) pour retrouver ces visites dans Analytics.</div>
      <div class="admin-actions" style="flex-wrap:wrap;margin-top:0">
        <button class="btn-approve" onclick="newsKitCopy('${id}', this)">1. Copier le texte</button>
        <a class="btn-approve" style="text-align:center;text-decoration:none;background:var(--steel)" href="${escapeHtml(newsShareUrl(r))}" target="_blank" rel="noopener">2. Ouvrir LinkedIn</a>
        ${r.linkedin_posted_at ? `<span style="font-size:12px;color:#2D6A4F;align-self:center">✓ Marqué comme posté le ${escapeHtml(newsFmt(r.linkedin_posted_at))}</span>` : `<button class="btn-approve" style="background:#2D6A4F" onclick="newsKitMarkPosted('${id}')">3. J'ai posté : marquer</button>`}
      </div>
    </div>`;
}
async function newsKitCopy(id, btn) {
  const ta = document.getElementById('nw-li-text-' + id);
  try { await navigator.clipboard.writeText(ta.value); btn.textContent = 'Copié ✓'; } catch (e) { ta.select(); btn.textContent = 'Sélectionné : Ctrl+C'; }
}
async function newsKitMarkPosted(id) {
  try {
    const saved = await adminFetch(`news_posts?id=eq.${id}`, { method: 'PATCH', headers: { 'Prefer': 'return=representation' }, body: JSON.stringify({ linkedin_posted_at: new Date().toISOString() }) });
    const rec = Array.isArray(saved) ? saved[0] : saved;
    const row = adminNewsRows.find(x => x.id === id); if (row && rec) row.linkedin_posted_at = rec.linkedin_posted_at;
    renderAdminNews();
  } catch (e) { alert('Erreur : ' + e.message); }
}
