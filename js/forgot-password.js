// ═══════════════════════════════
// « MOT DE PASSE OUBLIÉ » — lien ajouté sous le mot de passe des formulaires
// de connexion (espace fournisseur, RFQ, compte acheteur). Appelle le Worker
// (/api/request-password-reset) : la réponse est la même que l'adresse
// existe ou non, et un email avec un lien personnel est envoyé si un compte
// correspond. Le lien mène à pages/nouveau-mot-de-passe.html.
//
// Fichier autonome : ses textes FR/EN sont ici (et non dans i18n.js, que les
// navigateurs gardent en cache plusieurs heures).
// ═══════════════════════════════
(function () {
  const TXT = {
    fr: {
      link: 'Mot de passe oublié ?',
      intro: 'Saisissez l\'adresse de votre compte : nous vous envoyons un lien pour choisir un nouveau mot de passe.',
      email: 'Votre adresse email',
      send: 'Recevoir le lien',
      cancel: 'Annuler',
      sent: 'Si un compte existe pour cette adresse, un email avec un lien vient d\'être envoyé. Pensez à vérifier vos spams.',
      rate: 'Trop de demandes. Réessayez dans une heure.',
      invalid: 'Adresse email invalide.',
      error: 'Envoi impossible pour le moment. Réessayez plus tard.',
    },
    en: {
      link: 'Forgot your password?',
      intro: 'Enter your account email address: we will send you a link to choose a new password.',
      email: 'Your email address',
      send: 'Send me the link',
      cancel: 'Cancel',
      sent: 'If an account exists for this address, an email with a link has just been sent. Remember to check your spam folder.',
      rate: 'Too many requests. Please try again in an hour.',
      invalid: 'Invalid email address.',
      error: 'Could not send right now. Please try again later.',
    },
  };
  const lang = () => (typeof getLang === 'function' && getLang() === 'en') ? 'en' : 'fr';
  const T = k => TXT[lang()][k];
  const esc = s => String(s).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

  const FORMS = [
    { pw: 'sup-login-password', email: 'sup-login-email', scope: 'supplier' },
    { pw: 'acc-login-password', email: 'acc-login-email', scope: 'buyer' },
  ];

  function render(box, state) {
    const f = box._cfg;
    if (!state.open) {
      box.innerHTML = `<button type="button" class="forgot-pw-link" style="background:none;border:none;padding:0;color:var(--rust);font-size:12px;cursor:pointer;text-decoration:underline">${T('link')}</button>`;
      box.querySelector('button').onclick = () => { state.open = true; state.msg = ''; render(box, state); };
      return;
    }
    const emailField = document.getElementById(f.email);
    box.innerHTML = `
      <div style="padding:12px 14px;border:1px solid rgba(255,255,255,.18);border-radius:8px;margin-bottom:10px">
        <p style="font-size:12px;line-height:1.5;margin:0 0 10px;opacity:.85">${T('intro')}</p>
        <input type="email" class="forgot-pw-email" required placeholder="${esc(T('email'))}" value="${esc(state.email || (emailField && emailField.value) || '')}" style="width:100%;font-size:13px;padding:9px 12px;border-radius:6px;border:1px solid rgba(255,255,255,.2);background:rgba(255,255,255,.05);color:inherit;margin-bottom:8px"/>
        <div style="display:flex;gap:8px;flex-wrap:wrap">
          <button type="button" class="btn-add-product forgot-pw-send" style="width:auto;padding:8px 16px;font-size:12px;margin:0">${T('send')}</button>
          <button type="button" class="btn-remove-product forgot-pw-cancel">${T('cancel')}</button>
        </div>
        <p class="forgot-pw-msg" style="font-size:12px;line-height:1.5;margin:10px 0 0;${state.msgError ? 'color:#E06A52' : 'color:#86D6AC'}">${state.msg ? esc(state.msg) : ''}</p>
      </div>`;
    box.querySelector('.forgot-pw-cancel').onclick = () => { state.open = false; render(box, state); };
    box.querySelector('.forgot-pw-send').onclick = () => submit(box, state);
    box.querySelector('.forgot-pw-email').oninput = e => { state.email = e.target.value; };
    box.querySelector('.forgot-pw-email').onkeydown = e => { if (e.key === 'Enter') { e.preventDefault(); submit(box, state); } };
  }

  async function submit(box, state) {
    const input = box.querySelector('.forgot-pw-email');
    const btn = box.querySelector('.forgot-pw-send');
    const email = input.value.trim();
    state.email = email;
    const setMsg = (text, isError) => { state.msg = text; state.msgError = isError; box.querySelector('.forgot-pw-msg').textContent = text; box.querySelector('.forgot-pw-msg').style.color = isError ? '#E06A52' : '#86D6AC'; };
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) { setMsg(T('invalid'), true); return; }
    btn.disabled = true;
    try {
      const res = await fetch(`${SUPABASE_URL}/request-password-reset`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, lang: lang(), scope: box._cfg.scope }),
      });
      if (res.ok) setMsg(T('sent'), false);
      else if (res.status === 429) setMsg(T('rate'), true);
      else if (res.status === 400) setMsg(T('invalid'), true);
      else setMsg(T('error'), true);
    } catch (e) {
      setMsg(T('error'), true);
    }
    btn.disabled = false;
  }

  function init() {
    const boxes = [];
    FORMS.forEach(cfg => {
      const pw = document.getElementById(cfg.pw);
      if (!pw) return;
      const field = pw.closest('.lead-field') || pw.parentElement;
      const box = document.createElement('div');
      box.style.cssText = 'margin:-4px 0 14px';
      box._cfg = cfg;
      field.insertAdjacentElement('afterend', box);
      const state = { open: false };
      render(box, state);
      boxes.push({ box, state });
    });
    // Changement de langue : on réécrit les textes sans perdre l'état.
    new MutationObserver(() => boxes.forEach(b => render(b.box, b.state)))
      .observe(document.documentElement, { attributes: true, attributeFilter: ['lang'] });
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
  else init();
})();
