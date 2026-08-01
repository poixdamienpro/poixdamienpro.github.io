// ═══════════════════════════════
// i18n — dictionnaires FR / EN + helpers
// ═══════════════════════════════
const TRANSLATIONS = {
  fr: {
    // Nav
    nav_annuaire:        'Annuaire',
    nav_carte:           'Carte de l\'écosystème',
    nav_composants:      'Composants',
    nav_secteurs:        'Secteurs',
    nav_produits:        'Produits & Specs',
    nav_prestations:     'Prestations',
    nav_guides:          'Guides techniques',
    nav_tarifs:          'Tarifs',
    nav_fournisseur:     'Espace fournisseur',
    nav_referencer:      'Référencer mon entreprise',
    nav_pill:            '✓ Annuaire & specs 100% gratuits',
    ticker_label:        '// NOUVEAU',

    // Footer
    footer_about:        'Qui sommes-nous',
    footer_industries:   'Secteurs',
    footer_how:          'Comment ça marche',
    footer_quote:        'Demande de devis',
    footer_supplier:     'Devenir fournisseur',
    footer_legal:        'Mentions légales',
    footer_privacy:      'Politique de confidentialité',

    // Index HUD
    hud_tagline:         'SOURCER EN MINUTES, PAS EN SEMAINES',
    hud_submit:          'Référencer mon entreprise',
    hud_explore:         'Explorer l\'annuaire',

    // Index hero
    hero_eyebrow:        'Référentiel équipementiers · Le Circuit',
    hero_l1:             'Suivez le courant',
    hero_l2:             'au cœur des',
    hero_l3:             '<em>systèmes industriels.</em>',
    hero_p:              'De la cellule batterie à la servovanne, chaque composant a son fabricant, ses specs, son contact. Descendez le câble, on vous montre où sourcer.',
    hero_meta:           '05 stations · Source → Régulation',
    hero_scroll:         'Descendez le circuit',

    // Statband
    stat_makers:         'Fabricants référencés',
    stat_products:       'Fiches produits',
    stat_categories:     'Catégories produits',
    stat_industries:     'Industries couvertes',

    // Stations
    st1_tag:             'Source',
    st1_h2:              'Tout part de la <em>cellule</em>.',
    st1_p:               'Batteries LFP, Li-ion, packs spatiaux. On référence les fabricants à la source (TYVA, CATL, Saft, GS Yuasa) avec la chimie, la tension et la densité réelles.',
    st1_link:            'Voir les batteries →',
    st1_guide:           'Comment choisir une batterie ?',

    st2_tag:             'Distribution',
    st2_h2:              'Le courant se <em>répartit</em>.',
    st2_p:               'Unités de distribution (PDU), bornes, contacteurs. Comparez les specs côte à côte, ampérage, nombre de sorties, protocole, sans ouvrir dix fiches PDF.',
    st2_link:            'Comparer les PDU →',
    st2_guide:           'Comment choisir un PDU ?',

    st3_tag:             'Contrôle',
    st3_h2:              'L\'intelligence <em>embarquée</em>.',
    st3_p:               'Calculateurs, OBC, cartes de gestion. Les specs au détail près (FPGA, tension d\'entrée, normes) pour choisir le bon cerveau sans appeler trois commerciaux.',
    st3_link:            'Voir les calculateurs →',
    st3_guide:           'Comment choisir un OBC ?',

    st4_tag:             'Action',
    st4_h2:              'La puissance passe à <em>l\'acte</em>.',
    st4_p:               'Actionneurs, vérins, eAxles. Quand vous avez trouvé le bon, demandez un devis en un clic, gratuitement, sans compte, directement au fabricant.',
    st4_link:            'Voir les actionneurs →',
    st4_guide:           'Comment choisir un actionneur ?',

    st5_tag:             'Régulation',
    st5_h2:              'Le flux, <em>maîtrisé</em>.',
    st5_p:               'Vannes, servovalves, régulateurs. Contacts vérifiés et fiches certifiées (Moog, Bürkert) pour fermer la boucle avec le bon partenaire, en confiance.',
    st5_link:            'Voir les fournisseurs →',
    st5_guide:           'Comment choisir une vanne ?',

    // Outro
    outro_eyebrow:       'Fin du circuit',
    outro_h2:            'Le système complet vous <em>attend</em>.',
    outro_p:             'Vous avez suivi le courant. Maintenant, parcourez les fabricants et fiches produits : filtrez, comparez, contactez. Gratuit pour les acheteurs.',
    outro_btn1:          'Explorer l\'annuaire complet',
    outro_btn2:          'Parcourir le catalogue',

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
    nav_carte:           'Ecosystem map',
    nav_composants:      'Components',
    nav_secteurs:        'Industries',
    nav_produits:        'Products & Specs',
    nav_prestations:     'Services',
    nav_guides:          'Technical Guides',
    nav_tarifs:          'Pricing',
    nav_fournisseur:     'Supplier Portal',
    nav_referencer:      'List my company',
    nav_pill:            '✓ Directory & specs 100% free',
    ticker_label:        '// NEW',

    // Footer
    footer_about:        'About us',
    footer_industries:   'Industries',
    footer_how:          'How it works',
    footer_quote:        'Request a quote',
    footer_supplier:     'Become a supplier',
    footer_legal:        'Legal notice',
    footer_privacy:      'Privacy policy',

    // Index HUD
    hud_tagline:         'SOURCE IN MINUTES, NOT WEEKS',
    hud_submit:          'List my company',
    hud_explore:         'Explore directory',

    // Index hero
    hero_eyebrow:        'OEM Reference · The Circuit',
    hero_l1:             'Follow the current',
    hero_l2:             'through the heart of',
    hero_l3:             '<em>industrial systems.</em>',
    hero_p:              'From the battery cell to the servo valve, every component has its manufacturer, specs, and contact. Follow the wire — we show you where to source.',
    hero_meta:           '05 stations · Source → Regulation',
    hero_scroll:         'Scroll down the circuit',

    // Statband
    stat_makers:         'Listed manufacturers',
    stat_products:       'Product datasheets',
    stat_categories:     'Product categories',
    stat_industries:     'Industries covered',

    // Stations
    st1_tag:             'Source',
    st1_h2:              'Everything starts at the <em>cell</em>.',
    st1_p:               'LFP, Li-ion, space packs. We list manufacturers at the source (TYVA, CATL, Saft, GS Yuasa) with real chemistry, voltage, and energy density.',
    st1_link:            'Browse batteries →',
    st1_guide:           'How to choose a battery?',

    st2_tag:             'Distribution',
    st2_h2:              'Current gets <em>distributed</em>.',
    st2_p:               'Power distribution units (PDU), terminals, contactors. Compare specs side by side — amperage, number of outputs, protocol — without opening ten PDF datasheets.',
    st2_link:            'Compare PDUs →',
    st2_guide:           'How to choose a PDU?',

    st3_tag:             'Control',
    st3_h2:              '<em>Embedded</em> intelligence.',
    st3_p:               'OBCs, controllers, management boards. Specs down to the last detail (FPGA, input voltage, standards) to pick the right brain without calling three sales reps.',
    st3_link:            'Browse OBCs →',
    st3_guide:           'How to choose an OBC?',

    st4_tag:             'Action',
    st4_h2:              'Power becomes <em>action</em>.',
    st4_p:               'Actuators, cylinders, eAxles. Once you\'ve found the right one, request a quote in one click, for free, no account needed, directly from the manufacturer.',
    st4_link:            'Browse actuators →',
    st4_guide:           'How to choose an actuator?',

    st5_tag:             'Regulation',
    st5_h2:              'Flow, <em>mastered</em>.',
    st5_p:               'Valves, servo valves, regulators. Verified contacts and certified datasheets (Moog, Bürkert) to close the loop with the right partner, with confidence.',
    st5_link:            'Browse suppliers →',
    st5_guide:           'How to choose a valve?',

    // Outro
    outro_eyebrow:       'End of circuit',
    outro_h2:            'The complete system <em>awaits</em>.',
    outro_p:             'You\'ve followed the current. Now browse manufacturers and product datasheets: filter, compare, contact. Free for buyers.',
    outro_btn1:          'Explore the full directory',
    outro_btn2:          'Browse catalogue',

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

  // Si la page a une version dédiée dans la langue demandée (balise hreflang,
  // présente sur les pages statiques traduites), on y navigue au lieu de
  // traduire sur place — le contenu de ces pages est écrit en dur.
  const alt = document.querySelector('link[rel="alternate"][hreflang="' + lang + '"]');
  if (alt) {
    const target = new URL(alt.href).pathname;
    if (target !== window.location.pathname) {
      window.location.href = target;
      return;
    }
  }

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
  document.querySelectorAll('[data-i18n-html]').forEach(el => {
    const key = el.dataset.i18nHtml;
    const val = (TRANSLATIONS[lang] && TRANSLATIONS[lang][key]) || TRANSLATIONS['fr'][key];
    if (val !== undefined) el.innerHTML = val;
  });
  document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
    const key = el.dataset.i18nPlaceholder;
    const val = (TRANSLATIONS[lang] && TRANSLATIONS[lang][key]) || TRANSLATIONS['fr'][key];
    if (val !== undefined) el.placeholder = val;
  });
  // Re-rendu du contenu dynamique (liste entreprises / produits)
  if (typeof renderCompanies === 'function') renderCompanies();
  if (typeof renderProducts === 'function') renderProducts();
  // Mettre à jour le switcher
  document.querySelectorAll('.lang-btn').forEach(btn => {
    btn.classList.toggle('active', btn.dataset.lang === lang);
  });
}
