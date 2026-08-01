// ═══════════════════════════════
// API — couche d'accès à Supabase (le seul "backend" du site, voir /backend
// pour les scripts SQL). Chaque page n'appelle loadTaxonomy() que si elle
// affiche des entreprises/produits/filtres — voir le plan de refactor.
// ═══════════════════════════════
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
    industry:  row.industry,
    products:  row.categories || [],
    tags:      row.tags       || [],
    desc:      row.description || '',
    site:      row.site       || '#',
    logo:      row.logo       || '🏭',
    verified:  row.verified   || false,
    premium:   row.premium    || false,
    employees: row.employees  || 'N/A',
    founded:   row.founded    || 'N/A',
    contact:   row.contact_email || '',
  };
}

function mapProduct(row) {
  return {
    id:       row.id,
    companyId: row.company_id,
    name:     row.name,
    maker:    row.company_name || '',
    cat:      row.category,
    industry: row.industry,
    icon:     row.icon        || '🔧',
    image:    row.image_url   || '',
    desc:     row.description || '',
    specs:    (row.specs || []).map(s => ({ l: s.label, v: s.value, premium: s.is_premium })),
    bars:     (row.bars  || []).map(b => ({ l: b.label, v: b.value, c: b.color })),
    certs:    row.certs  || [],
    price:    row.price_label || 'Sur devis',
  };
}

// Charge COMPANIES/PRODUCTS/INDUSTRIES/PROD_CATS depuis Supabase.
// Appelé par les pages qui en ont besoin (annuaire, catalogue, submit, home) — pas par toutes.
async function loadTaxonomy() {
  const [companiesRaw, productsRaw, tagsRaw, catsRaw] = await Promise.all([
    fetchAllPaged('get_companies_page'),
    fetchAllPaged('get_products_page'),
    fetchAllPagedTable('company_tags',               'select=company_id,tag'),
    fetchAllPagedTable('company_product_categories', 'select=company_id,category'),
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

  COMPANIES = companiesRaw.map(row => {
    row.tags       = tagsMap[row.id]  || [];
    row.categories = catsMap[row.id]  || [];
    return mapCompany(row);
  });

  PRODUCTS = productsRaw.map(mapProduct);

  INDUSTRIES = [...new Set(COMPANIES.map(c => c.industry))].sort();
  PROD_CATS  = [...new Set(COMPANIES.flatMap(c => c.products))].sort();
}

function showLoading(ids) {
  const msg = '<div style="grid-column:1/-1;text-align:center;padding:60px 20px">' +
    '<div style="font-size:30px;display:inline-block;animation:spin 1s linear infinite">⚙️</div>' +
    '<p style="color:var(--muted);margin-top:12px;font-size:13px">Chargement des données…</p></div>';
  ids.forEach(id => {
    const el = document.getElementById(id);
    if (el) el.innerHTML = msg;
  });
}

function showLoadError(ids) {
  const msg = '<div style="grid-column:1/-1;text-align:center;padding:60px 20px;background:var(--white);border:1px solid var(--border);border-radius:8px">' +
    '<div style="font-size:28px;margin-bottom:10px">⚠️</div>' +
    '<p style="color:var(--rust);font-weight:700;font-size:14px;margin-bottom:6px">Impossible de se connecter à Supabase</p>' +
    '<p style="color:var(--muted);font-size:12px;line-height:1.7">' +
    'Vérifie que <code>SUPABASE_URL</code> et <code>SUPABASE_ANON</code> sont correctement renseignés dans le code.<br><br>' +
    'Dans Supabase : <strong>Settings → API</strong> → copie le <em>Project URL</em> et la clé <em>anon public</em>.<br><br>' +
    'Vérifie aussi que les politiques RLS autorisent la lecture publique (policy <em>companies_read_all</em>).' +
    '</p></div>';
  ids.forEach(id => {
    const el = document.getElementById(id);
    if (el) el.innerHTML = msg;
  });
}
