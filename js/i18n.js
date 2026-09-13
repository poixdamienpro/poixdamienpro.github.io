// ═══════════════════════════════
// i18n — dictionnaires FR / EN + helpers
// ═══════════════════════════════
const TRANSLATIONS = {
  fr: {
    // Nav
    nav_cat_annuaire:    'Annuaire',
    nav_annuaire:        'Fabricants',
    nav_systemiers:      'Systémiers',
    nav_carte:           'Carte de l\'écosystème',
    nav_cat_ressources:  'Ressources',
    nav_composants:      'Composants',
    nav_secteurs:        'Secteurs',
    nav_produits:        'Produits & Specs',
    nav_prestations:     'Prestations',
    nav_guides:          'Guides techniques',
    nav_cat_entreprise:  'Entreprise',
    nav_tarifs:          'Tarifs',
    nav_fournisseur:     'Espace fournisseur',
    nav_mon_compte:      'Mon compte',
    nav_referencer:      'Référencer mon entreprise',
    footer_cgv:          'CGV',
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

    // Libellés partagés (carte, prestations, systémiers, fiches entreprise/produit)
    lbl_search:          'Recherche',
    lbl_industry:        'Industrie',
    lbl_reset:           '↺ Réinitialiser',
    lbl_hint_preview:    'Survolez pour prévisualiser',
    lbl_info:            'Informations',
    lbl_description:     'Description',
    lbl_ranges_tech:     'Gammes & Technologies',
    lbl_products_referenced: 'Produits référencés sur Buy-inner',
    badge_premium:       '★ Premium',
    badge_verified:      '✓ Vérifié',
    tag_systemier:       '🔗 Systémier',
    tag_prestataire:     '🧑‍💼 Prestataire de service',
    btn_view_profile:    'Voir la fiche complète →',
    btn_visit_site:      '↗ Visiter le site officiel',
    btn_visit_short:     'Visiter le site →',
    btn_request_quote:   '📩 Demander un devis',
    btn_close:           '✕ Fermer',

    // Page carte
    map_title_prefix:    'Carte des',
    map_title_suffix:    'en Europe',
    map_subtitle:        'Localisez les fabricants, prestataires et systémiers référencés, ville par ville.',
    map_label_type:      'Type',
    map_fournisseurs:    'Fournisseurs',
    map_prestataires:    'Prestataires',
    map_systemiers:      'Systémiers',
    map_kpi_mapped:      'Localisées',
    map_kpi_total:       'Entreprises au total',
    map_toolbar:         '// CARTE',
    map_empty_fournisseurs: 'Aucun fournisseur géolocalisé pour l\'instant.',
    map_empty_prestataires: 'Aucun prestataire géolocalisé pour l\'instant.',
    map_empty_systemiers:   'Aucun systémier géolocalisé pour l\'instant.',
    map_popup_hq:        'Siège',
    map_popup_site:      'Site',
    map_popup_link:      'Voir la fiche →',
    map_located_one:     'localisé',
    map_located_many:    'localisés',

    // Page prestations
    presta_title_html:   'Prestataires de <span>services</span> industriels',
    presta_subtitle:      'Talents en régie, développement d\'équipements, fabrication de faisceaux électriques, essais & qualification, usinage, intégration système, segment sol & opérations.',
    presta_kpi_c:        'Prestataires',
    presta_kpi_types:    'Types de prestation',
    presta_placeholder:  'Nom, pays, prestation…',
    presta_label_type:   'Type de prestation',
    presta_toolbar:      '// PRESTATIONS',
    presta_empty:        'Aucun prestataire ne correspond.',
    presta_count_one:    'prestataire',
    presta_count_many:   'prestataires',
    presta_services_label: 'Prestations proposées',

    // Page systémiers
    sys_title_html:      'Systémiers <span>& intégrateurs système</span>',
    sys_subtitle_html:   'Ceux qui livrent un système complet — plateforme satellite, lanceur — pas un composant isolé. <a href="../blog/articles/systemier-vs-equipementier.html" style="color:inherit;text-decoration:underline">Systémier vs équipementier, quelle différence ?</a>',
    sys_kpi_c:           'Systémiers',
    sys_kpi_p:           'Systèmes référencés',
    sys_placeholder:     'Nom, pays, système…',
    sys_label_type:      'Type de système',
    sys_toolbar:         '// SYSTÉMIERS',
    sys_empty:           'Aucun systémier ne correspond.',
    sys_count_one:       'systémier',
    sys_count_many:      'systémiers',
    sys_systems_label:   'Systèmes référencés',

    // Fiches entreprise / produit
    ent_claim_text:      'Fiche non revendiquée — construite à partir de données publiques. Êtes-vous',
    ent_claim_link:      'Revendiquer',
    modal_see_products:  '🔧 Voir tous leurs produits →',
    prod_download_datasheet: '📄 Télécharger la datasheet',
    prod_view_maker_prefix:  '↗ Voir la fiche',

    // Modale devis
    lead_modal_title:    'Demander un devis',
    lead_intro:          'C\'est gratuit. Votre demande est transmise au fournisseur, qui choisit de vous recontacter ou non, vous ne serez jamais inscrit à une liste de diffusion.',
    lead_name:           'Nom complet',
    lead_email:          'Email professionnel',
    lead_company:        'Entreprise',
    lead_need:           'Votre besoin',
    lead_need_placeholder: 'Quantité, contraintes techniques, délai…',
    lead_submit:         '📩 Envoyer la demande',
    cmp_title:           'Comparaison technique',
    cmp_criteria:        'Critère',
    cmp_price_certs:     'Prix & Certifications',
    cmp_price_label:     'Prix indicatif',
    cmp_legend:          '🟢 Meilleure valeur · 🔴 Valeur la plus basse',
    lead_login_link:     'Se connecter',
    lead_login_suffix:   'pour préremplir vos infos et retrouver l\'historique de vos demandes.',
    lead_sending:        'Envoi en cours…',
    lead_success_title:  'Demande envoyée',
    lead_success_body:   'Votre demande pour <strong>{company}</strong> a été transmise. Le fournisseur sera informé et pourra vous recontacter directement, vous n\'avez rien à payer.',
    lbl_close:           'Fermer',
    lead_error_alert:    'Erreur lors de l\'envoi. Vérifiez votre connexion et réessayez, ou écrivez-nous directement à',

    // Preview produit
    prod_specs:          'Spécifications',
    prod_scores:         'Scores relatifs',
    prod_certs:          'Certifications',
    prod_compare_add:    '＋ Comparer',
    prod_compare_in:     '✓ Dans le comparateur',
    prod_quote:          '✉ Demander un devis',

    // Comparateur
    cmp_banner:          'produit(s) sélectionné(s)',
    cmp_compare:         'Comparer →',
    cmp_clear:           'Vider',

    // États
    loading:             'Chargement des données…',
    error_title:         'Impossible de se connecter à Supabase',
    all_filter:          'Tout',
  },

  en: {
    // Nav
    nav_cat_annuaire:    'Directory',
    nav_annuaire:        'Manufacturers',
    nav_systemiers:      'Systems integrators',
    nav_carte:           'Ecosystem map',
    nav_cat_ressources:  'Resources',
    nav_composants:      'Components',
    nav_secteurs:        'Industries',
    nav_produits:        'Products & Specs',
    nav_prestations:     'Services',
    nav_guides:          'Technical Guides',
    nav_cat_entreprise:  'Company',
    nav_tarifs:          'Pricing',
    nav_fournisseur:     'Supplier Portal',
    nav_mon_compte:      'My account',
    nav_referencer:      'List my company',
    footer_cgv:          'Terms of sale',
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

    // Libellés partagés (carte, prestations, systémiers, fiches entreprise/produit)
    lbl_search:          'Search',
    lbl_industry:        'Industry',
    lbl_reset:           '↺ Reset',
    lbl_hint_preview:    'Hover to preview',
    lbl_info:            'Information',
    lbl_description:     'Description',
    lbl_ranges_tech:     'Ranges & Technologies',
    lbl_products_referenced: 'Products listed on Buy-inner',
    badge_premium:       '★ Premium',
    badge_verified:      '✓ Verified',
    tag_systemier:       '🔗 Systems integrator',
    tag_prestataire:     '🧑‍💼 Service provider',
    btn_view_profile:    'View full profile →',
    btn_visit_site:      '↗ Visit official website',
    btn_visit_short:     'Visit website →',
    btn_request_quote:   '📩 Request a quote',
    btn_close:           '✕ Close',

    // Page carte
    map_title_prefix:    'Map of',
    map_title_suffix:    'in Europe',
    map_subtitle:        'Locate listed manufacturers, service providers and systems integrators, city by city.',
    map_label_type:      'Type',
    map_fournisseurs:    'Suppliers',
    map_prestataires:    'Service providers',
    map_systemiers:      'Systems integrators',
    map_kpi_mapped:      'Located',
    map_kpi_total:       'Total companies',
    map_toolbar:         '// MAP',
    map_empty_fournisseurs: 'No supplier located yet.',
    map_empty_prestataires: 'No service provider located yet.',
    map_empty_systemiers:   'No systems integrator located yet.',
    map_popup_hq:        'HQ',
    map_popup_site:      'Site',
    map_popup_link:      'View profile →',
    map_located_one:     'located',
    map_located_many:    'located',

    // Page prestations
    presta_title_html:   'Industrial <span>service</span> providers',
    presta_subtitle:      'Staffing, equipment development, wiring harness manufacturing, testing & qualification, machining, system integration, ground segment & operations.',
    presta_kpi_c:        'Service providers',
    presta_kpi_types:    'Service types',
    presta_placeholder:  'Name, country, service…',
    presta_label_type:   'Service type',
    presta_toolbar:      '// SERVICES',
    presta_empty:        'No matching service provider.',
    presta_count_one:    'service provider',
    presta_count_many:   'service providers',
    presta_services_label: 'Services offered',

    // Page systémiers
    sys_title_html:      'Systems integrators <span>& system builders</span>',
    sys_subtitle_html:   'Those who deliver a complete system — satellite platform, launch vehicle — not a standalone component. <a href="../blog/articles/systemier-vs-equipementier.html" style="color:inherit;text-decoration:underline">Systems integrator vs. component supplier, what\'s the difference?</a>',
    sys_kpi_c:           'Systems integrators',
    sys_kpi_p:           'Listed systems',
    sys_placeholder:     'Name, country, system…',
    sys_label_type:      'System type',
    sys_toolbar:         '// SYSTEMS INTEGRATORS',
    sys_empty:           'No matching systems integrator.',
    sys_count_one:       'systems integrator',
    sys_count_many:      'systems integrators',
    sys_systems_label:   'Listed systems',

    // Fiches entreprise / produit
    ent_claim_text:      'Unclaimed listing — built from public data. Are you',
    ent_claim_link:      'Claim it',
    modal_see_products:  '🔧 View all their products →',
    prod_download_datasheet: '📄 Download datasheet',
    prod_view_maker_prefix:  '↗ View',

    // Modale devis
    lead_modal_title:    'Request a quote',
    lead_intro:          'It\'s free. Your request is sent to the supplier, who chooses whether to contact you back — you will never be added to a mailing list.',
    lead_name:           'Full name',
    lead_email:          'Business email',
    lead_company:        'Company',
    lead_need:           'Your requirement',
    lead_need_placeholder: 'Quantity, technical constraints, timeline…',
    lead_submit:         '📩 Send request',
    cmp_title:           'Technical comparison',
    cmp_criteria:        'Criterion',
    cmp_price_certs:     'Price & Certifications',
    cmp_price_label:     'Indicative price',
    cmp_legend:          '🟢 Best value · 🔴 Lowest value',
    lead_login_link:     'Log in',
    lead_login_suffix:   'to prefill your info and find your request history.',
    lead_sending:        'Sending…',
    lead_success_title:  'Request sent',
    lead_success_body:   'Your request for <strong>{company}</strong> has been sent. The supplier will be notified and may contact you directly — you have nothing to pay.',
    lbl_close:           'Close',
    lead_error_alert:    'Something went wrong while sending. Check your connection and try again, or email us directly at',

    // Preview produit
    prod_specs:          'Specifications',
    prod_scores:         'Performance scores',
    prod_certs:          'Certifications',
    prod_compare_add:    '＋ Compare',
    prod_compare_in:     '✓ In comparator',
    prod_quote:          '✉ Request a quote',

    // Comparateur
    cmp_banner:          'product(s) selected',
    cmp_compare:         'Compare →',
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
  // Re-rendu du contenu dynamique (liste entreprises / produits) — chaque
  // page définit la fonction qui la concerne, les autres restent undefined.
  if (typeof renderCompanies === 'function') renderCompanies();
  if (typeof renderProducts === 'function') renderProducts();
  if (typeof renderSystemiers === 'function') renderSystemiers();
  // Point d'extension générique pour un re-rendu supplémentaire propre à
  // une page (ex: carte.js recalcule le titre/popup/carte, dont le texte
  // n'est pas capturé par un simple data-i18n).
  if (typeof onLangChange === 'function') onLangChange();
  // Mettre à jour le switcher
  document.querySelectorAll('.lang-btn').forEach(btn => {
    btn.classList.toggle('active', btn.dataset.lang === lang);
  });
}
