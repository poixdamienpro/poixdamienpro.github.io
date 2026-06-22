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

function mapCompany(row) {
  return {
    name:      row.name,
    country:   row.country,
    hq:        row.hq        || '',
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
    supabase('v_companies_summary', 'order=premium.desc,name.asc'),
    supabase('v_products_full',     'order=company_name.asc,name.asc'),
    supabase('company_tags',         'select=company_id,tag'),
    supabase('company_product_categories', 'select=company_id,category'),
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
