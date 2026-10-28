// ═══════════════════════════════
// SERVICE « Accompagnement à la transformation des équipements » — formulaire de demande de devis.
// Page FR : pages/accompagnement-transformation-equipements.html
// Page EN : en/equipment-transformation-support.html
// La demande est enregistrée dans la table `service_requests` (voir
// backend/supabase_service_requests_2026_10.sql), que les administrateurs suivent dans l'onglet
// « Accompagnement » de pages/admin.html. Un email d'alerte part en plus vers FOUNDER_EMAIL via
// Web3Forms (même canal que les demandes de devis : js/leads.js), en best-effort.
// Les textes sont dans ce fichier (pas dans i18n.js) : la langue est celle de la page, et le
// formulaire ne dépend donc d'aucune clé de traduction mise en cache ailleurs.
// ═══════════════════════════════
const SVC_LANG = (document.documentElement.lang || 'fr').toLowerCase().startsWith('en') ? 'en' : 'fr';

const SVC_TEXT = {
  fr: {
    title: 'Demander un devis',
    intro: 'Décrivez votre équipement et le domaine visé. Nous revenons vers vous pour préciser le besoin, puis nous vous adressons un devis. Sans engagement.',
    name: 'Nom et prénom', email: 'Email professionnel', phone: 'Téléphone (facultatif)', company: 'Entreprise',
    equipment: 'Équipement concerné', equipmentPh: 'ex : chargeur embarqué 3,3 kW, calculateur, motorisation, batterie…',
    sourceDomain: 'Domaine d\'origine de l\'équipement', sourcePh: 'ex : automobile, industrie…',
    targetDomain: 'Domaine visé', targetChoose: 'Choisir…',
    objective: 'Votre besoin',
    objectives: { qualification: 'Qualification de l\'équipement', transformation: 'Transformation de l\'équipement', both: 'Les deux', unsure: 'Je ne sais pas encore' },
    message: 'Décrivez votre projet', messagePh: 'Contexte, exigences ou normes connues, état d\'avancement, échéance souhaitée…',
    submit: 'Envoyer ma demande', sending: 'Envoi…',
    okTitle: 'Demande bien reçue', okBody: 'Merci, nous revenons vers vous à l\'adresse indiquée pour préciser votre besoin. Aucun engagement de votre part.',
    errRate: 'Trop de demandes envoyées depuis cette adresse. Réessayez demain ou écrivez-nous à ',
    err: 'L\'envoi a échoué. Réessayez ou écrivez-nous à ',
    domains: { 'Spatial': 'Spatial', 'Aéronautique & Défense': 'Aéronautique & Défense', 'Automobile & Mobilité électrique': 'Automobile & Mobilité électrique', 'Ferroviaire': 'Ferroviaire', 'Énergie & Utilities': 'Énergie & Utilities', 'Industrie & Manufacturing': 'Industrie & Manufacturing', 'Autre': 'Autre' },
  },
  en: {
    title: 'Request a quote',
    intro: 'Describe your equipment and the target domain. We will get back to you to clarify the need, then send you a quote. No commitment.',
    name: 'Full name', email: 'Business email', phone: 'Phone (optional)', company: 'Company',
    equipment: 'Equipment concerned', equipmentPh: 'e.g. 3.3 kW on-board charger, computer, motor drive, battery…',
    sourceDomain: 'Equipment\'s original domain', sourcePh: 'e.g. automotive, industrial…',
    targetDomain: 'Target domain', targetChoose: 'Choose…',
    objective: 'What you need',
    objectives: { qualification: 'Equipment qualification', transformation: 'Equipment transformation', both: 'Both', unsure: 'Not sure yet' },
    message: 'Describe your project', messagePh: 'Background, known requirements or standards, current status, desired timeline…',
    submit: 'Send my request', sending: 'Sending…',
    okTitle: 'Request received', okBody: 'Thank you, we will get back to you at the address provided to clarify your need. No commitment on your side.',
    errRate: 'Too many requests sent from this address. Please try again tomorrow or write to us at ',
    err: 'Sending failed. Please try again or write to us at ',
    domains: { 'Spatial': 'Space', 'Aéronautique & Défense': 'Aerospace & Defense', 'Automobile & Mobilité électrique': 'Automotive & E-mobility', 'Ferroviaire': 'Rail', 'Énergie & Utilities': 'Energy & Utilities', 'Industrie & Manufacturing': 'Industry & Manufacturing', 'Autre': 'Other' },
  },
};

function svcRender() {
  const root = document.getElementById('svc-form-root');
  if (!root) return;
  const T = SVC_TEXT[SVC_LANG];
  const esc = s => String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
  root.innerHTML = `
    <div class="svc-card">
      <h2 class="cat-h2" style="margin-bottom:8px">${T.title}</h2>
      <p class="cat-intro" style="margin-bottom:18px;font-size:14px">${T.intro}</p>
      <form id="svc-form" novalidate>
        <div class="svc-grid">
          <div class="lead-field"><label for="svc-name">${T.name}</label><input type="text" id="svc-name" maxlength="120" autocomplete="name" required/></div>
          <div class="lead-field"><label for="svc-email">${T.email}</label><input type="email" id="svc-email" maxlength="254" autocomplete="email" required/></div>
          <div class="lead-field"><label for="svc-company">${T.company}</label><input type="text" id="svc-company" maxlength="160" autocomplete="organization" required/></div>
          <div class="lead-field"><label for="svc-phone">${T.phone}</label><input type="tel" id="svc-phone" maxlength="40" autocomplete="tel"/></div>
        </div>
        <div class="lead-field"><label for="svc-equipment">${T.equipment}</label><input type="text" id="svc-equipment" maxlength="300" placeholder="${esc(T.equipmentPh)}" required/></div>
        <div class="svc-grid">
          <div class="lead-field"><label for="svc-source">${T.sourceDomain}</label><input type="text" id="svc-source" maxlength="120" placeholder="${esc(T.sourcePh)}"/></div>
          <div class="lead-field"><label for="svc-target">${T.targetDomain}</label>
            <select id="svc-target"><option value="">${T.targetChoose}</option>${Object.keys(T.domains).map(k => `<option value="${esc(k)}">${esc(T.domains[k])}</option>`).join('')}</select></div>
        </div>
        <div class="lead-field"><label for="svc-objective">${T.objective}</label>
          <select id="svc-objective">${Object.keys(T.objectives).map(k => `<option value="${k}"${k === 'unsure' ? ' selected' : ''}>${esc(T.objectives[k])}</option>`).join('')}</select></div>
        <div class="lead-field"><label for="svc-message">${T.message}</label><textarea id="svc-message" rows="5" maxlength="5000" placeholder="${esc(T.messagePh)}" required></textarea></div>
        <div class="svc-hp" aria-hidden="true"><label>Website<input type="text" id="svc-website" tabindex="-1" autocomplete="off"/></label></div>
        <div data-consent="service"></div>
        <button type="submit" class="btn-submit-form" id="svc-submit">${T.submit}</button>
        <p id="svc-error" class="svc-error" role="alert" hidden></p>
      </form>
    </div>`;
  if (typeof renderConsentSlots === 'function') renderConsentSlots();
  document.getElementById('svc-form').addEventListener('submit', svcSubmit);
}

async function svcSubmit(e) {
  e.preventDefault();
  const T = SVC_TEXT[SVC_LANG];
  const v = id => document.getElementById(id).value.trim();
  const errEl = document.getElementById('svc-error');
  errEl.hidden = true;

  // Champ piège : un humain ne le voit pas ; un robot le remplit. On fait semblant de réussir.
  if (v('svc-website')) { svcShowSuccess(); return; }

  const form = document.getElementById('svc-form');
  if (!form.checkValidity()) { form.reportValidity(); return; }
  if (v('svc-message').length < 10) { document.getElementById('svc-message').focus(); return; }

  const row = {
    contact_name: v('svc-name'),
    contact_email: v('svc-email'),
    contact_phone: v('svc-phone') || null,
    company: v('svc-company'),
    equipment: v('svc-equipment'),
    source_domain: v('svc-source') || null,
    target_domain: v('svc-target') || null,
    objective: v('svc-objective') || null,
    message: v('svc-message'),
    lang: SVC_LANG,
  };

  const btn = document.getElementById('svc-submit');
  btn.disabled = true; btn.textContent = T.sending;
  try {
    const res = await fetch(`${SUPABASE_URL}/rest/v1/service_requests`, {
      method: 'POST',
      headers: {
        'apikey': SUPABASE_ANON,
        'Authorization': 'Bearer ' + SUPABASE_ANON,
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      body: JSON.stringify(row),
    });
    if (!res.ok) {
      const body = await res.json().catch(() => null);
      throw new Error((body && (body.message || body.hint)) || ('HTTP ' + res.status));
    }
    svcNotifyFounder(row); // alerte email, best-effort : la demande est déjà enregistrée
    svcShowSuccess();
  } catch (err) {
    console.error('Erreur demande de service:', err);
    btn.disabled = false; btn.textContent = T.submit;
    errEl.textContent = (/RATE_LIMIT/.test(err.message) ? T.errRate : T.err) + FOUNDER_EMAIL + '.';
    errEl.hidden = false;
  }
}

function svcNotifyFounder(r) {
  fetch('https://api.web3forms.com/submit', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
    body: JSON.stringify({
      access_key: WEB3FORMS_ACCESS_KEY,
      subject: `Demande d'accompagnement équipements · ${r.company}`,
      from_name: 'Buy-inner',
      to: FOUNDER_EMAIL,
      name: r.contact_name,
      email: r.contact_email,
      company: r.company,
      message:
        `Service : Accompagnement à la transformation des équipements\n` +
        `Équipement : ${r.equipment}\n` +
        `Domaine d'origine : ${r.source_domain || '—'}\nDomaine visé : ${r.target_domain || '—'}\n` +
        `Besoin : ${r.objective || '—'}\nTéléphone : ${r.contact_phone || '—'}\nLangue : ${r.lang}\n\n` +
        `${r.message}\n\nÀ suivre dans l'onglet « Accompagnement » de pages/admin.html.` + consentLine(),
    }),
  }).catch(() => {});
}

function svcShowSuccess() {
  const T = SVC_TEXT[SVC_LANG];
  document.getElementById('svc-form-root').innerHTML = `
    <div class="svc-card"><div class="lead-success">
      <div class="icon">✅</div>
      <h3>${T.okTitle}</h3>
      <p>${T.okBody}</p>
    </div></div>`;
}

document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  svcRender();
});
