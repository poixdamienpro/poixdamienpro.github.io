// ═══════════════════════════════
// i18n — dictionnaires FR / EN + helpers
// ═══════════════════════════════
const TRANSLATIONS = {
  fr: {
    // Nav
    nav_annuaire:        'Annuaire',
    nav_produits:        'Produits & Specs',
    nav_tarifs:          'Tarifs',
    nav_fournisseur:     'Espace fournisseur',
    nav_referencer:      'Référencer mon entreprise',
    nav_pill:            '✓ Annuaire & specs 100% gratuits',
    ticker_label:        '// NOUVEAU',

    // Index HUD
    hud_tagline:         'SOURCER EN MINUTES, PAS EN SEMAINES',
    hud_submit:          'Référencer mon entreprise',
    hud_explore:         'Explorer l\'annuaire',

    // Page annuaire
    ann_title:           'Annuaire des fabricants industriels',
    ann_subtitle:        'Sourcez et évaluez les équipementiers mondiaux : batteries, PDU, OBC, vannes, actionneurs.',
    ann_kpi_companies:   'Entreprises',
    ann_kpi_products:    'Produits',
    ann_kpi_industries:  'Industries',
    ann_label_search:    'Recherche',
    ann_placeholder:     'Nom, pays, produit…',
    ann_label_industry:  'Industrie',
    ann_label_category:  'Catégorie produit',
    ann_reset:           '↺ Réinitialiser',
    ann_toolbar:         '// ANNUAIRE',
    ann_hint:            'Survolez pour prévisualiser',
    ann_empty:           'Aucune entreprise ne correspond.',

    // Page catalogue
    cat_title:           'Catalogue produits & specs',
    cat_subtitle:        'Fiches techniques détaillées. Cochez jusqu\'à 4 produits et comparez-les côte-à-côte.',
    cat_label_search:    'Recherche',
    cat_placeholder:     'Produit, fabricant…',
    cat_label_category:  'Catégorie',
    cat_label_industry:  'Industrie',
    cat_reset:           '↺ Réinitialiser',
    cat_toolbar:         '// CATALOGUE',
    cat_hint:            'Survolez pour la fiche · ＋ pour comparer',
    cat_empty:           'Aucun produit ne correspond.',
    cat_upsell_title:    '★ Vous êtes fournisseur ?',
    cat_upsell_body:     'Référencement gratuit. Vous ne payez que si on vous transmet un contact qualifié.',
    cat_upsell_btn:      'Référencer mon entreprise →',

    // Preview entreprise
    prev_founded:        'Fondée en',
    prev_employees:      'Effectifs',
    prev_sector:         'Secteur',
    prev_hq:             'Siège',
    prev_info:           'Informations société',
    prev_products_1:     'produit référencé',
    prev_products_n:     'produits référencés',
    prev_see:            'Voir les',
    prev_see_suffix:     'produits →',
    prev_visit:          '↗ Visiter le site',
    prev_quote:          '✉ Demander un devis',

    // Preview produit
    prod_specs:          'Spécifications',
    prod_scores:         'Scores relatifs',
    prod_certs:          'Certifications',
    prod_compare_add:    '＋ Comparer',
    prod_compare_in:     '✓ Dans le comparateur',
    prod_quote:          '✉ Demander un devis',

    // Comparateur
    cmp_banner:          'produit(s) sélectionné(s)',
    cmp_compare:         'Comparer',
    cmp_clear:           'Vider',

    // États
    loading:             'Chargement des données…',
    error_title:         'Impossible de se connecter à Supabase',
    all_filter:          'Tout',
  },

  en: {
    // Nav
    nav_annuaire:        'Directory',
    nav_produits:        'Products & Specs',
    nav_tarifs:          'Pricing',
    nav_fournisseur:     'Supplier Portal',
    nav_referencer:      'List my company',
    nav_pill:            '✓ Directory & specs 100% free',
    ticker_label:        '// NEW',

    // Index HUD
    hud_tagline:         'SOURCE IN MINUTES, NOT WEEKS',
    hud_submit:          'List my company',
    hud_explore:         'Explore directory',

    // Page annuaire
    ann_title:           'Industrial Manufacturer Directory',
    ann_subtitle:        'Source and evaluate global OEMs: batteries, PDUs, OBCs, valves, actuators.',
    ann_kpi_companies:   'Companies',
    ann_kpi_products:    'Products',
    ann_kpi_industries:  'Industries',
    ann_label_search:    'Search',
    ann_placeholder:     'Name, country, product…',
    ann_label_industry:  'Industry',
    ann_label_category:  'Product category',
    ann_reset:           '↺ Reset',
    ann_toolbar:         '// DIRECTORY',
    ann_hint:            'Hover to preview',
    ann_empty:           'No matching company.',

    // Page catalogue
    cat_title:           'Products & Specs Catalogue',
    cat_subtitle:        'Detailed technical datasheets. Select up to 4 products and compare side-by-side.',
    cat_label_search:    'Search',
    cat_placeholder:     'Product, manufacturer…',
    cat_label_category:  'Category',
    cat_label_industry:  'Industry',
    cat_reset:           '↺ Reset',
    cat_toolbar:         '// CATALOGUE',
    cat_hint:            'Hover for datasheet · ＋ to compare',
    cat_empty:           'No matching product.',
    cat_upsell_title:    '★ Are you a supplier?',
    cat_upsell_body:     'Free listing. You only pay when we send you a qualified lead.',
    cat_upsell_btn:      'List my company →',

    // Preview entreprise
    prev_founded:        'Founded',
    prev_employees:      'Employees',
    prev_sector:         'Sector',
    prev_hq:             'HQ',
    prev_info:           'Company info',
    prev_products_1:     'listed product',
    prev_products_n:     'listed products',
    prev_see:            'View all',
    prev_see_suffix:     'products →',
    prev_visit:          '↗ Visit website',
    prev_quote:          '✉ Request a quote',

    // Preview produit
    prod_specs:          'Specifications',
    prod_scores:         'Performance scores',
    prod_certs:          'Certifications',
    prod_compare_add:    '＋ Compare',
    prod_compare_in:     '✓ In comparator',
    prod_quote:          '✉ Request a quote',

    // Comparateur
    cmp_banner:          'product(s) selected',
    cmp_compare:         'Compare',
    cmp_clear:           'Clear',

    // États
    loading:             'Loading data…',
    error_title:         'Cannot connect to Supabase',
    all_filter:          'All',
  },
};

function getLang() {
  return localStorage.getItem('bi_lang') || 'fr';
}

function setLang(lang) {
  localStorage.setItem('bi_lang', lang);
  document.documentElement.lang = lang;
  applyLang();
  // Mettre à jour le visuel du switcher
  document.querySelectorAll('.lang-btn').forEach(btn => {
    btn.classList.toggle('active', btn.dataset.lang === lang);
  });
}

function t(key) {
  const lang = getLang();
  return (TRANSLATIONS[lang] && TRANSLATIONS[lang][key]) || TRANSLATIONS['fr'][key] || key;
}

function applyLang() {
  const lang = getLang();
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.dataset.i18n;
    const val = (TRANSLATIONS[lang] && TRANSLATIONS[lang][key]) || TRANSLATIONS['fr'][key];
    if (val !== undefined) el.textContent = val;
  });
  document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
    const key = el.dataset.i18nPlaceholder;
    const val = (TRANSLATIONS[lang] && TRANSLATIONS[lang][key]) || TRANSLATIONS['fr'][key];
    if (val !== undefined) el.placeholder = val;
  });
  // Mettre à jour le switcher
  document.querySelectorAll('.lang-btn').forEach(btn => {
    btn.classList.toggle('active', btn.dataset.lang === lang);
  });
}
