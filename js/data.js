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
// ═══════════════════════════════
async function sendTransactionalEmail(type, to, params) {
  try {
    const res = await fetch(`${SUPABASE_URL}/send-email`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ type, to, params }),
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
const TICKER_ITEMS = ["TYVA Energie · Moduloo Ax 48V 30Ah · 1 690 € HT","CATL · LiFePO4 280Ah · ~480 €/kWh","Delta Electronics · OBC 22 kW V2G · ~3 800 €","Moog · D633 Servovanne · ~8 500 €","Batconnect · LFP 48V 100Ah IoT · Sur devis","Eaton · ePDU G3 32A · ~1 200 €","ABB · ACS880 5 600 kW · 800–150 000 €","Airbus · COSMO-BATT Satellite GEO · Sur devis","GS Yuasa · LSE134 Li-ion Spatial · Sur devis","Bradford ECAPS · 1N HPGP Propulseur vert · Sur devis"];
const PLANS = [
  {name:"Acheteur",price:"0 €",period:"pour toujours",highlight:false,target:"annuaire",desc:"Pour les ingénieurs et acheteurs qui sourcent des équipements.",cta:"Explorer gratuitement",ctaClass:"secondary",features:[
    {ok:true, text:"Annuaire complet"},
    {ok:true, text:"Fiches produits, specs techniques complètes"},
    {ok:true, text:"Filtres par industrie et catégorie"},
    {ok:true, text:"Comparaison illimitée (4 produits)"},
    {ok:true, text:"Demandes de devis illimitées"},
    {ok:true, text:"Aucune carte bancaire requise"}
  ]},
  {name:"Fournisseur · Référencement",price:"0 €",period:"pour toujours",highlight:true,target:"submit",desc:"Votre entreprise référencée gratuitement. Vous ne payez que sur résultat.",cta:"Référencer mon entreprise",ctaClass:"primary",features:[
    {ok:true, text:"Fiche entreprise et produits dans l'annuaire"},
    {ok:true, text:"Aucun paiement pour être listé ou visible"},
    {ok:true, text:"Vous choisissez d'accepter ou refuser chaque demande de contact"},
    {ok:true, text:"Payez uniquement le lead accepté (~80 €/lead qualifié)"},
    {ok:false,text:"Badge Vérifié Premium"},
    {ok:false,text:"Priorité dans les résultats de recherche"}
  ]},
  {name:"Fournisseur Premium",price:"1 500 €",period:"/an",highlight:false,target:"submit",desc:"Pour les fabricants qui veulent maximiser leur visibilité et leurs leads.",cta:"Devenir Premium",ctaClass:"secondary",features:[
    {ok:true, text:"Tout le plan Référencement"},
    {ok:true, text:"Badge ★ PREMIUM et mise en avant prioritaire"},
    {ok:true, text:"Profil enrichi : vidéo, datasheets, certifications"},
    {ok:true, text:"Dashboard analytics : vues, clics, demandes"},
    {ok:true, text:"Fiches produits illimitées"},
    {ok:true, text:"Support dédié à l'intégration"}
  ]},
];

const FAQ = [
  {q:"Dois-je payer pour que mon entreprise soit référencée ?",a:"Non. Le référencement de base est et restera toujours gratuit. Vous ne payez jamais pour être listé ou visible dans l'annuaire."},
  {q:"Comment fonctionne le paiement par lead ?",a:"Quand un ingénieur demande un devis sur votre fiche, nous vous proposons le contact. Vous choisissez de l'accepter (paiement ~80 € par lead qualifié) ou de le refuser, sans frais. Aucune facture n'est jamais envoyée sans votre accord explicite."},
  {q:"Les acheteurs doivent-ils payer pour voir les specs ou contacter un fournisseur ?",a:"Non. L'accès acheteur est entièrement gratuit : annuaire, fiches techniques complètes et demandes de devis illimitées, sans carte bancaire."},
  {q:"Comment fonctionne le badge Premium fournisseur ?",a:"Votre entreprise apparaît en tête des résultats pertinents, avec un encadré doré et le badge ★ PREMIUM, pour 1 500 €/an."},
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
let catCat = 'all';
let catInd = 'all';
let compareIds = [];
let currentPage = 'home';
let leadTarget = null;
