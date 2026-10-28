// ═══════════════════════════════
// API — couche d'accès à Supabase (le seul "backend" du site, voir /backend
// pour les scripts SQL). Chaque page n'appelle loadTaxonomy() que si elle
// affiche des entreprises/produits/filtres — voir le plan de refactor.
// ═══════════════════════════════

// Échappement HTML — à appliquer à TOUTE donnée venant de Supabase avant de
// l'injecter via innerHTML (RFQ, soumissions produit, comptes acheteur/
// fournisseur... tout ce qui transite par une table à INSERT anon/
// authenticated est une entrée utilisateur non fiable, même après relecture
// admin). Chargé avant les scripts de page (voir index.html / pages/*.html).
function escapeHtml(str) {
  if (str === null || str === undefined) return '';
  return String(str).replace(/[&<>"']/g, ch => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  }[ch]));
}

// Échappement pour une valeur passée en argument d'un onclick="fn('...')" —
// échappe d'abord pour la chaîne JS (guillemet simple, antislash), puis pour
// l'attribut HTML qui la contient. Nécessaire en plus de escapeHtml() dès
// qu'une valeur texte (nom produit, titre RFQ...) est réinjectée dans un
// gestionnaire d'évènement inline plutôt qu'affichée en simple texte.
function escapeJsAttr(str) {
  const jsSafe = String(str ?? '')
    .replace(/\\/g, '\\\\')
    .replace(/'/g, "\\'")
    .replace(/\r?\n/g, '\\n');
  return escapeHtml(jsSafe);
}

async function supabase(table, params = '') {
  const url = `${SUPABASE_URL}/rest/v1/${table}${params ? '?' + params : ''}`;
  const res = await fetch(url, {
    headers: {
      'apikey': SUPABASE_ANON,
      'Authorization': 'Bearer ' + SUPABASE_ANON,
      'Content-Type': 'application/json',
    }
  });
  if (!res.ok) throw new Error(`Supabase ${table}: HTTP ${res.status}`);
  return res.json();
}

// Récupère toutes les lignes d'une fonction RPC paginée (page par page),
// au lieu d'un GET direct sur la vue — voir backend/supabase_anti_scraping_pagination.sql.
// Le serveur plafonne chaque page à 50 lignes quoi qu'il arrive ; ça empêche
// un scraper de dumper tout le catalogue en une seule requête.
async function fetchAllPaged(rpcName, pageSize = 50) {
  let all = [];
  let offset = 0;
  while (true) {
    const res = await fetch(`${SUPABASE_URL}/rest/v1/rpc/${rpcName}`, {
      method: 'POST',
      headers: {
        'apikey': SUPABASE_ANON,
        'Authorization': 'Bearer ' + SUPABASE_ANON,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ p_limit: pageSize, p_offset: offset }),
    });
    if (!res.ok) throw new Error(`Supabase RPC ${rpcName}: HTTP ${res.status}`);
    const page = await res.json();
    all = all.concat(page);
    if (page.length < pageSize) break;
    offset += pageSize;
  }
  return all;
}

// Récupère toutes les lignes d'une TABLE (pas une RPC) en paginant avec
// offset/limit, pour contourner le plafond serveur PostgREST (db-max-rows)
// qui tronque silencieusement toute requête directe à 50 lignes — le
// paramètre `limit=` du client ne suffit pas à le dépasser. Voir
// backend/supabase_lock_base_tables.sql : companies/products avaient déjà
// ce traitement via fetchAllPaged() + RPC ; company_product_categories et
// company_tags ne l'avaient pas, d'où la troncature silencieuse une fois
// passé 50 lignes au total.
async function fetchAllPagedTable(table, selectParams, pageSize = 50) {
  let all = [];
  let offset = 0;
  while (true) {
    const page = await supabase(table, `${selectParams}&limit=${pageSize}&offset=${offset}`);
    all = all.concat(page);
    if (page.length < pageSize) break;
    offset += pageSize;
  }
  return all;
}

// Appelle une RPC Supabase et retourne ses lignes — voir
// backend/supabase_add_detail_page_rpcs.sql.
async function fetchRpc(rpcName, params) {
  const res = await fetch(`${SUPABASE_URL}/rest/v1/rpc/${rpcName}`, {
    method: 'POST',
    headers: {
      'apikey': SUPABASE_ANON,
      'Authorization': 'Bearer ' + SUPABASE_ANON,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(params),
  });
  if (!res.ok) throw new Error(`Supabase RPC ${rpcName}: HTTP ${res.status}`);
  return res.json();
}

// Variante pour les RPC qui retournent au plus une ligne (fiches dédiées).
async function fetchOne(rpcName, params) {
  const rows = await fetchRpc(rpcName, params);
  return rows[0] || null;
}

function mapCompany(row) {
  return {
    id:        row.id,
    name:      row.name,
    country:   row.country,
    hq:        row.hq        || '',
    city:      row.city       || '',
    department: row.department || '',
    region:    row.region     || '',
    lat:       typeof row.lat === 'number' ? row.lat : (row.lat != null ? Number(row.lat) : null),
    lng:       typeof row.lng === 'number' ? row.lng : (row.lng != null ? Number(row.lng) : null),
    // Implantations secondaires (autres pays/villes) — voir
    // backend/supabase_add_company_locations_2026_09.sql. Vide pour la
    // grande majorité des entreprises (un seul site) ; alimenté au fur et
    // à mesure pour celles réellement multi-sites (Beyond Gravity, etc.).
    locations: row.locations || [],
    isSystemier: row.is_systemier || false,
    industry:  row.industry,
    industries: (row.industries && row.industries.length) ? row.industries : (row.industry ? [row.industry] : []),
    products:  row.categories || [],
    tags:      row.tags       || [],
    desc:      row.description || '',
    // Traduction anglaise optionnelle (voir js/i18n.js localize()) — vide
    // pour la plupart des entreprises tant que la traduction n'a pas été
    // faite ; localize() retombe alors silencieusement sur `desc`.
    descEn:    row.description_en || '',
    site:      row.site       || '#',
    logo:      row.logo       || '🏭',
    verified:  row.verified   || false,
    premium:   row.premium    || false,
    claimed:   row.claimed    || false,
    employees: row.employees  || 'N/A',
    founded:   row.founded    || 'N/A',
    contact:   row.contact_email || '',
  };
}

// Pastille d'une entreprise dans les listes, les cartes et les fiches.
// Buy-inner n'affiche AUCUN logo de marque : les logos appartiennent aux entreprises référencées, et tant qu'elles
// n'ont pas donné leur accord, les montrer (même via un service tiers comme logo.dev) n'est pas acceptable. On affiche
// le pictogramme neutre enregistré sur la fiche (c.logo : un emoji, 🏭 par défaut).
// Pour afficher un logo avec l'accord de l'entreprise : déposer le fichier fourni par elle dans assets/ et l'ajouter ici,
// fiche par fiche. Jamais de récupération automatique depuis un service tiers.
// (Le second argument, ancienne taille demandée à logo.dev, est conservé pour ne pas modifier les appels.)
function companyLogoHtml(c) {
  return escapeHtml((c && c.logo) || '🏭');
}

function mapProduct(row) {
  return {
    id:       row.id,
    companyId: row.company_id,
    name:     row.name,
    nameEn:   row.name_en || '',
    maker:    row.company_name || '',
    cat:      row.category,
    industry: row.industry,
    icon:     row.icon        || '🔧',
    image:    SHOW_PRODUCT_PHOTOS ? (row.image_url || '') : '',   // voir js/data.js : affichage des photos suspendu
    desc:     row.description || '',
    // Voir js/i18n.js localize() et mapCompany() ci-dessus.
    descEn:   row.description_en || '',
    datasheetUrl: row.datasheet_url || '',
    // Caracteristiques electriques/mecaniques/environnementales normalisees
    // (filtre par plage numerique) — voir
    // backend/supabase_add_product_characteristics_2026_09.sql. Vide pour la
    // plupart des produits pour l'instant (pilote sur 3 secteurs).
    characteristics: row.characteristics || [],
    // Filtres catégoriels (cases à cocher, pas une plage numérique) — voir
    // backend/supabase_add_product_tags_2026_09.sql. tag_type='protection'
    // pour l'instant (indice IP) ; 'certs' ci-dessous sert de source pour le
    // filtre "Qualification" (déjà riche, pas besoin de le dupliquer ici).
    productTags: row.product_tags || [],
    specs:    (row.specs || []).map(s => ({ l: s.label, v: s.value, premium: s.is_premium, lEn: s.label_en, vEn: s.value_en })),
    bars:     (row.bars  || []).map(b => ({ l: b.label, v: b.value, c: b.color })),
    certs:    row.certs  || [],
    price:    row.price_label || 'Sur devis',
  };
}

// Mention sous les caractéristiques d'un produit : d'où viennent les données, et qu'elles sont reprises sans garantie.
// Buy-inner compose ces fiches à partir de la documentation publique des fabricants ; il en est l'éditeur et doit pouvoir
// indiquer la source (lien datasheet de la fiche, sinon « source non renseignée ») et recevoir les corrections.
// Le même texte est produit côté serveur par productContent() dans cloudflare/supabase-proxy-worker.js.
function specSourceHtml(p) {
  let host = '';
  try { host = new URL(p.datasheetUrl).hostname.replace(/^www\./, ''); } catch (e) { /* pas de lien exploitable */ }
  const src = host ? t('prod_source').replace('{host}', escapeHtml(host)) : t('prod_source_none');
  const subject = encodeURIComponent(t('prod_report_subject') + ' ' + p.name + ' (' + p.maker + ')');
  return `<p class="spec-source" style="font-size:11.5px;color:var(--muted);line-height:1.6;margin:10px 0 0">${src} ${t('prod_source_note')} <a href="mailto:contact@buy-inner.com?subject=${subject}">${t('prod_report')}</a></p>`;
}

// Charge COMPANIES/PRODUCTS/INDUSTRIES/PROD_CATS depuis Supabase.
// Appelé par les pages qui en ont besoin (annuaire, catalogue, submit, home) — pas par toutes.
async function loadTaxonomy() {
  const [companiesRaw, productsRaw, tagsRaw, catsRaw, indsRaw, locsRaw, charsRaw, prodTagsRaw] = await Promise.all([
    fetchAllPaged('get_companies_page'),
    fetchAllPaged('get_products_page'),
    fetchAllPagedTable('company_tags',               'select=company_id,tag'),
    fetchAllPagedTable('company_product_categories', 'select=company_id,category'),
    // .catch() dédié : tant que backend/supabase_add_company_industries.sql
    // n'a pas été exécuté en base, cette table n'existe pas encore — on ne
    // veut pas que loadTaxonomy() entier échoue pour autant (Promise.all
    // rejetterait sinon), donc on retombe simplement sur [] (mapCompany()
    // gère déjà ce cas en repliant sur l'industrie unique companies.industry).
    fetchAllPagedTable('company_industries', 'select=company_id,industry').catch(() => []),
    // Implantations secondaires — voir backend/supabase_add_company_locations_2026_09.sql.
    // Même repli que company_industries tant que la table n'existe pas encore en base.
    fetchAllPagedTable('company_locations', 'select=company_id,label,city,country,lat,lng').catch(() => []),
    // Caractéristiques électriques/mécaniques/environnementales normalisées
    // (filtre par plage) — voir backend/supabase_add_product_characteristics_2026_09.sql.
    // Pilote sur 3 secteurs pour l'instant ; même repli que les tables ci-dessus.
    fetchAllPagedTable('product_characteristics', 'select=product_id,axis,characteristic,label,unit,value_min,value_max').catch(() => []),
    // Filtres catégoriels (cases à cocher) — voir backend/supabase_add_product_tags_2026_09.sql.
    // 1ère brique : tag_type='protection' (indice IP). Même repli.
    fetchAllPagedTable('product_tags', 'select=product_id,tag_type,value').catch(() => []),
  ]);

  const tagsMap = {};
  tagsRaw.forEach(t => {
    if (!tagsMap[t.company_id]) tagsMap[t.company_id] = [];
    tagsMap[t.company_id].push(t.tag);
  });
  const catsMap = {};
  catsRaw.forEach(c => {
    if (!catsMap[c.company_id]) catsMap[c.company_id] = [];
    catsMap[c.company_id].push(c.category);
  });
  const indsMap = {};
  indsRaw.forEach(i => {
    if (!indsMap[i.company_id]) indsMap[i.company_id] = [];
    indsMap[i.company_id].push(i.industry);
  });
  const locsMap = {};
  locsRaw.forEach(l => {
    if (!locsMap[l.company_id]) locsMap[l.company_id] = [];
    locsMap[l.company_id].push({
      label:   l.label || '',
      city:    l.city  || '',
      country: l.country || '',
      lat:     typeof l.lat === 'number' ? l.lat : Number(l.lat),
      lng:     typeof l.lng === 'number' ? l.lng : Number(l.lng),
    });
  });
  const charsMap = {};
  charsRaw.forEach(c => {
    if (!charsMap[c.product_id]) charsMap[c.product_id] = [];
    charsMap[c.product_id].push({
      axis: c.axis, characteristic: c.characteristic, label: c.label, unit: c.unit,
      min: typeof c.value_min === 'number' ? c.value_min : Number(c.value_min),
      max: typeof c.value_max === 'number' ? c.value_max : Number(c.value_max),
    });
  });
  const prodTagsMap = {};
  prodTagsRaw.forEach(t => {
    if (!prodTagsMap[t.product_id]) prodTagsMap[t.product_id] = [];
    prodTagsMap[t.product_id].push({ type: t.tag_type, value: t.value });
  });

  COMPANIES = companiesRaw.map(row => {
    row.tags       = tagsMap[row.id]  || [];
    row.categories = catsMap[row.id]  || [];
    row.industries = indsMap[row.id]  || [];
    row.locations  = locsMap[row.id]  || [];
    return mapCompany(row);
  });

  PRODUCTS = productsRaw.map(row => {
    row.characteristics = charsMap[row.id] || [];
    row.product_tags    = prodTagsMap[row.id] || [];
    return mapProduct(row);
  });

  INDUSTRIES = [...new Set(COMPANIES.flatMap(c => c.industries))].sort();
  PROD_CATS  = [...new Set(COMPANIES.flatMap(c => c.products))].sort();
}

function showLoading(ids) {
  // Liste texte ajoutée par le Worker pour les robots sans JavaScript : retirée dès que la page prend la main,
  // mais gardée en mémoire pour être affichée si le chargement des données échoue (voir showLoadError).
  const ssr = document.getElementById('ssr-directory');
  if (ssr) { window._ssrDirectory = ssr.innerHTML; ssr.remove(); }
  const msg = '<div style="grid-column:1/-1;text-align:center;padding:60px 20px">' +
    '<div style="font-size:30px;display:inline-block;animation:spin 1s linear infinite">⚙️</div>' +
    '<p style="color:var(--muted);margin-top:12px;font-size:13px">' + (typeof t === 'function' ? t('loading') : 'Chargement des données…') + '</p></div>';
  ids.forEach(id => {
    const el = document.getElementById(id);
    if (el) el.innerHTML = msg;
  });
}

// Les textes sont ici (et non dans i18n.js) : ce message doit s'afficher correctement même si
// le fichier de traductions est encore en cache dans une ancienne version.
function showLoadError(ids, err) {
  const en = typeof getLang === 'function' && getLang() === 'en';
  const detail = err && err.message ? escapeHtml(String(err.message).slice(0, 160)) : '';
  const msg = '<div style="grid-column:1/-1;text-align:center;padding:60px 20px;background:var(--white);border:1px solid var(--border);border-radius:8px">' +
    '<div style="font-size:28px;margin-bottom:10px">⚠️</div>' +
    '<p style="color:var(--rust);font-weight:700;font-size:14px;margin-bottom:6px">' + (en ? 'Unable to load the data' : 'Impossible de charger les données') + '</p>' +
    '<p style="color:var(--muted);font-size:12px;line-height:1.7;max-width:520px;margin:0 auto">' +
    (en
      ? 'The connection to Buy-inner was interrupted. Please try again. If the problem persists, a corporate firewall or proxy may be blocking the requests: try another network, or ask your IT team to allow <strong>www.buy-inner.com</strong>.'
      : 'La connexion à Buy-inner a été interrompue. Réessayez. Si le problème persiste, un pare-feu ou un proxy d\'entreprise bloque peut-être les requêtes : essayez depuis un autre réseau, ou demandez à votre service informatique d\'autoriser <strong>www.buy-inner.com</strong>.') +
    (detail ? '<br><span style="font-size:11px;opacity:.8">' + (en ? 'Technical detail: ' : 'Détail technique : ') + detail + '</span>' : '') +
    '</p>' +
    '<button type="button" onclick="window.location.reload()" style="margin-top:14px;padding:9px 18px;border:none;border-radius:6px;background:var(--rust);color:#fff;font-weight:700;font-size:13px;cursor:pointer">' + (en ? 'Try again' : 'Réessayer') + '</button>' +
    // Liste fournie par le serveur : le visiteur peut quand même parcourir et ouvrir les fiches.
    (window._ssrDirectory ? '<div class="ssr-fallback">' + window._ssrDirectory + '</div>' : '') +
    '</div>';
  ids.forEach(id => {
    const el = document.getElementById(id);
    if (el) el.innerHTML = msg;
  });
}
