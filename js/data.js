// ═══════════════════════════════
// CONFIGURATION SUPABASE
// Passe par www.buy-inner.com/api (Worker Cloudflare, voir
// cloudflare/supabase-proxy-worker.js) au lieu de *.supabase.co direct —
// certains reseaux d'entreprise bloquent ce domaine par categorie.
// ═══════════════════════════════
const SUPABASE_URL    = 'https://www.buy-inner.com/api';
const SUPABASE_ANON   = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB6ZWp4d3J0c2dsbWlpdGJocGpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE0MTEwNTMsImV4cCI6MjA5Njk4NzA1M30.-SpxNs7G_5nEuZCXL68lNVcCzFTyiaZc93dViix76Ok';     // clé publique anon

// ═══════════════════════════════
// CONFIGURATION LOGO.DEV
// Vrais logos d'entreprise par domaine (img.logo.dev/:domain). Clé
// "publishable" — faite pour être exposée côté client, comme la clé
// anon Supabase ci-dessus. À remplacer par ta propre clé gratuite :
// https://www.logo.dev -> Get free API key
// ═══════════════════════════════
const LOGO_DEV_TOKEN  = 'pk_auyA2g6JQ6aVtkiqtPU2xg';

// ═══════════════════════════════
// EMAILS TRANSACTIONNELS — relayés par le Worker Cloudflare
// (/api/send-email -> Resend, clé secrète côté Worker, voir
// cloudflare/supabase-proxy-worker.js). Best-effort à chaque site
// d'appel : un échec ne doit jamais bloquer le flux principal (soumission,
// approbation...), on logue juste l'erreur en console.
//
// Le Worker contrôle QUI peut envoyer QUOI (route publique) :
//   * submission_confirmation : exige extra.submissionId (id de la soumission
//     qui vient d'être créée) ; le contenu de l'email vient de la base.
//   * submission_approved / claim_approved : exige extra.token (session admin).
// ═══════════════════════════════
async function sendTransactionalEmail(type, to, params, extra = {}) {
  try {
    const headers = { 'Content-Type': 'application/json' };
    if (extra.token) headers['Authorization'] = 'Bearer ' + extra.token;
    const res = await fetch(`${SUPABASE_URL}/send-email`, {
      method: 'POST',
      headers,
      body: JSON.stringify({ type, to, params, submissionId: extra.submissionId }),
    });
    if (!res.ok) throw new Error('HTTP ' + res.status);
  } catch (err) {
    console.error(`Erreur envoi email transactionnel (${type}):`, err);
  }
}

// ═══════════════════════════════
// DATA — chargée depuis Supabase
// ═══════════════════════════════
let INDUSTRIES = [];
let PROD_CATS  = [];
let COMPANIES  = [];
let PRODUCTS   = [];
const TICKER_ITEMS_EN = ["TYVA Energie · Moduloo Ax 48V 30Ah · €1,690 excl. VAT","CATL · LiFePO4 280Ah · ~€480/kWh","Delta Electronics · OBC 22 kW V2G · ~€3,800","Moog · D633 Servo valve · ~€8,500","Batconnect · LFP 48V 100Ah IoT · On request","Eaton · ePDU G3 32A · ~€1,200","ABB · ACS880 5,600 kW · €800–150,000","Airbus · COSMO-BATT GEO Satellite · On request","GS Yuasa · LSE134 Space Li-ion · On request","Bradford ECAPS · 1N HPGP Green thruster · On request"];
const TICKER_ITEMS = ["TYVA Energie · Moduloo Ax 48V 30Ah · 1 690 € HT","CATL · LiFePO4 280Ah · ~480 €/kWh","Delta Electronics · OBC 22 kW V2G · ~3 800 €","Moog · D633 Servovanne · ~8 500 €","Batconnect · LFP 48V 100Ah IoT · Sur devis","Eaton · ePDU G3 32A · ~1 200 €","ABB · ACS880 5 600 kW · 800–150 000 €","Airbus · COSMO-BATT Satellite GEO · Sur devis","GS Yuasa · LSE134 Li-ion Spatial · Sur devis","Bradford ECAPS · 1N HPGP Propulseur vert · Sur devis"];
const PLANS = [
  {name:"Acheteur",price:"0 €",period:"pour toujours",highlight:false,target:"annuaire",desc:"Pour les ingénieurs et acheteurs qui sourcent des équipements.",cta:"Explorer gratuitement",ctaClass:"secondary",features:[
    {ok:true, text:"Annuaire consultable sans compte"},
    {ok:true, text:"Specs complètes, datasheets et carte des fournisseurs avec un compte gratuit"},
    {ok:true, text:"Filtres par industrie et catégorie"},
    {ok:true, text:"Comparaison illimitée (4 produits)"},
    {ok:true, text:"Demandes de devis illimitées, formulaire prérempli"},
    {ok:true, text:"Aucune carte bancaire requise"}
  ]},
  {name:"Fournisseur · Référencement",price:"0 €",period:"pour toujours",highlight:true,target:"submit",desc:"Votre entreprise référencée gratuitement. Vous ne payez que sur résultat.",cta:"Référencer mon entreprise",ctaClass:"primary",features:[
    {ok:true, text:"Fiche entreprise et jusqu'à 2 produits dans l'annuaire"},
    {ok:true, text:"1 compte fournisseur"},
    {ok:true, text:"Aucun paiement pour être listé ou visible"},
    {ok:true, text:"Vous choisissez d'accepter ou refuser chaque demande de contact"},
    {ok:true, text:"Payez uniquement le lead accepté (~80 €/lead qualifié)"},
    {ok:false,text:"Badge Vérifié Premium"},
    {ok:false,text:"Priorité dans les résultats de recherche"},
    {ok:false,text:"Produits illimités"},
    {ok:false,text:"Plusieurs comptes pour votre équipe"},
    {ok:false,text:"Accès aux dossiers RFQ / RFI / RFP"}
  ]},
  {name:"Fournisseur Premium",price:"1 500 €",period:"/an",highlight:false,target:"supplier",desc:"Pour les fabricants qui veulent maximiser leur visibilité et leurs leads. Disponible une fois votre entreprise revendiquée.",cta:"Passer Premium",ctaClass:"secondary",features:[
    {ok:true, text:"Tout le plan Référencement"},
    {ok:true, text:"Badge ★ PREMIUM et mise en avant prioritaire"},
    {ok:true, text:"Profil enrichi : vidéo, datasheets, certifications"},
    {ok:true, text:"Dashboard analytics : vues, clics, demandes"},
    {ok:true, text:"Équipe : jusqu'à 20 comptes, invitations par email"},
    {ok:true, text:"Fiches produits illimitées (2 en gratuit)"},
    {ok:true, text:"Accès aux dossiers RFQ / RFI / RFP : consulter et répondre (déposer pour les systémiers)"},
    {ok:true, text:"Support dédié à l'intégration"}
  ]},
];

const PLANS_EN = [
  {name:"Buyer",price:"€0",period:"forever",highlight:false,target:"annuaire",desc:"For engineers and buyers sourcing equipment.",cta:"Explore for free",ctaClass:"secondary",features:[
    {ok:true, text:"Directory browsable without an account"},
    {ok:true, text:"Full specs, datasheets and supplier map with a free account"},
    {ok:true, text:"Filters by industry and category"},
    {ok:true, text:"Unlimited comparison (4 products)"},
    {ok:true, text:"Unlimited quote requests, prefilled form"},
    {ok:true, text:"No credit card required"}
  ]},
  {name:"Supplier · Listing",price:"€0",period:"forever",highlight:true,target:"submit",desc:"Your company listed for free. You only pay on results.",cta:"List my company",ctaClass:"primary",features:[
    {ok:true, text:"Company page and up to 2 products in the directory"},
    {ok:true, text:"1 supplier account"},
    {ok:true, text:"No payment to be listed or visible"},
    {ok:true, text:"You choose to accept or decline each contact request"},
    {ok:true, text:"Pay only for accepted leads (~€80 per qualified lead)"},
    {ok:false,text:"Verified Premium badge"},
    {ok:false,text:"Priority in search results"},
    {ok:false,text:"Unlimited products"},
    {ok:false,text:"Multiple accounts for your team"},
    {ok:false,text:"Access to RFQ / RFI / RFP files"}
  ]},
  {name:"Supplier Premium",price:"€1,500",period:"/year",highlight:false,target:"supplier",desc:"For manufacturers who want to maximize their visibility and leads. Available once your company has been claimed.",cta:"Go Premium",ctaClass:"secondary",features:[
    {ok:true, text:"Everything in the Listing plan"},
    {ok:true, text:"★ PREMIUM badge and priority placement"},
    {ok:true, text:"Enriched profile: video, datasheets, certifications"},
    {ok:true, text:"Analytics dashboard: views, clicks, requests"},
    {ok:true, text:"Team: up to 20 accounts, invitations by email"},
    {ok:true, text:"Unlimited product pages (2 on the free plan)"},
    {ok:true, text:"Access to RFQ / RFI / RFP files: browse and respond (post, for system integrators)"},
    {ok:true, text:"Dedicated onboarding support"}
  ]},
];
const FAQ_EN = [
  {q:"Do I have to pay to have my company listed?",a:"No. Basic listing is, and will always be, free: your company page and up to 2 products. You never pay to be listed or visible in the directory. Unlimited products, RFQ access and team accounts come with the Premium plan."},
  {q:"How does pay-per-lead work?",a:"When an engineer requests a quote on your page, we offer you the contact. You choose to accept it (~€80 per qualified lead) or decline it at no cost. No invoice is ever sent without your explicit agreement."},
  {q:"Do buyers have to pay to see specs or contact a supplier?",a:"No. Buyer access is entirely free. The directory can be browsed without an account; a free account unlocks full technical sheets, datasheets and the supplier map. Quote requests are unlimited, with no credit card."},
  {q:"How does the supplier Premium badge work?",a:"Your company appears at the top of relevant results, with a gold frame and the ★ PREMIUM badge, for €1,500/year."},
  {q:"Can several people from my company manage the listing?",a:"The free Listing plan includes one supplier account. With Premium, the company administrator can invite up to 20 colleagues (sales, management…) by email. They get the same access to products, quote requests and statistics, and the administrator can remove an account at any time."},
  {q:"Who can access RFQ / RFI / RFP files?",a:"Companies on the Premium plan: they can browse the files posted by system integrators, sign the confidentiality agreement and respond. Posting a file is also reserved for Premium system integrators."},
  {q:"What if my company is listed without my knowledge?",a:"Unclaimed profiles are built from public data (websites, datasheets). You can claim them for free at any time, or ask for their removal."},
  {q:"Is the site indexed on Google?",a:"Yes. Every company and product page is optimized for organic search (SEO)."},
];
const FAQ = [
  {q:"Dois-je payer pour que mon entreprise soit référencée ?",a:"Non. Le référencement de base est et restera toujours gratuit : votre fiche entreprise et jusqu'à 2 produits. Vous ne payez jamais pour être listé ou visible dans l'annuaire. Les produits illimités, l'accès aux RFQ et les comptes d'équipe sont inclus dans l'offre Premium."},
  {q:"Comment fonctionne le paiement par lead ?",a:"Quand un ingénieur demande un devis sur votre fiche, nous vous proposons le contact. Vous choisissez de l'accepter (paiement ~80 € par lead qualifié) ou de le refuser, sans frais. Aucune facture n'est jamais envoyée sans votre accord explicite."},
  {q:"Les acheteurs doivent-ils payer pour voir les specs ou contacter un fournisseur ?",a:"Non. L'accès acheteur est entièrement gratuit. L'annuaire se consulte sans compte ; un compte gratuit débloque les fiches techniques complètes, les datasheets et la carte des fournisseurs. Les demandes de devis sont illimitées, sans carte bancaire."},
  {q:"Comment fonctionne le badge Premium fournisseur ?",a:"Votre entreprise apparaît en tête des résultats pertinents, avec un encadré doré et le badge ★ PREMIUM, pour 1 500 €/an."},
  {q:"Plusieurs personnes de mon entreprise peuvent-elles gérer la fiche ?",a:"Le plan Référencement gratuit inclut un compte fournisseur. Avec Premium, l'administrateur de l'entreprise peut inviter jusqu'à 20 collègues (commerciaux, direction…) par email : ils accèdent aux mêmes produits, demandes de devis et statistiques, et l'administrateur peut retirer un accès à tout moment."},
  {q:"Qui peut accéder aux dossiers RFQ / RFI / RFP ?",a:"Les entreprises ayant l'offre Premium : elles consultent les dossiers déposés par les systémiers, signent l'accord de confidentialité et répondent. Le dépôt d'un dossier est aussi réservé aux systémiers Premium."},
  {q:"Que se passe-t-il si mon entreprise est listée sans que je le sache ?",a:"Les fiches non revendiquées sont construites à partir de données publiques (sites, datasheets). Vous pouvez les revendiquer gratuitement à tout moment, ou demander leur retrait."},
  {q:"Le site est-il indexé sur Google ?",a:"Oui. Chaque fiche entreprise et produit est optimisée pour le référencement naturel (SEO)."},
];


// ═══════════════════════════════
// STATE
// ═══════════════════════════════
const FOUNDER_EMAIL = 'poixdamien.pro@gmail.com'; // destinataire des demandes de devis, envoyées via Web3Forms (js/leads.js)
const WEB3FORMS_ACCESS_KEY = '42d71ca2-5e99-4737-927b-4e5e9eee3ba9'; // clé publique Web3Forms — sans risque d'être exposée côté client, par design (web3forms.com)
let annIndustry = 'all';
let annCat = 'all';
let catGroup = 'all';
let catSubCat = 'all';
let catInd = 'all';
let compareIds = [];
let currentPage = 'home';
let leadTarget = null;
