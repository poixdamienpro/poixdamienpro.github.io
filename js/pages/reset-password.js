// ═══════════════════════════════
// NOUVEAU MOT DE PASSE (lien reçu par email : création de compte par l'admin
// ou réinitialisation). Le lien contient un jeton « token_hash » que la page
// échange elle-même (POST /auth/v1/verify) contre une session, puis la
// personne choisit son mot de passe (PUT /auth/v1/user). Rien n'est envoyé
// tant que le JavaScript ne s'exécute pas : un scanner d'emails qui ouvre
// simplement le lien ne consomme donc pas le jeton.
// ═══════════════════════════════
const PW_TOKEN_KEY = 'pw_reset_token';
const PW_ALLOWED_TYPES = ['recovery', 'invite'];

function pwShowMessage(text, isError) {
  const el = document.getElementById('pw-message');
  el.textContent = text;
  el.style.color = isError ? '#E06A52' : '#86D6AC';
  el.style.display = 'block';
}

document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  const params = new URLSearchParams(window.location.search);
  const lang = params.get('lang');
  if ((lang === 'fr' || lang === 'en') && typeof setLang === 'function') setLang(lang);

  const tokenHash = params.get('token_hash');
  // next=buyer / next=admin : on renvoie vers la bonne page de connexion après l'enregistrement.
  if (params.get('next') === 'buyer' || params.get('next') === 'admin') {
    try { sessionStorage.setItem('pw_reset_next', params.get('next')); } catch (e) { /* ignore */ }
  }
  const type = PW_ALLOWED_TYPES.includes(params.get('type')) ? params.get('type') : 'recovery';
  // Le jeton ne doit pas rester dans la barre d'adresse (historique, captures d'écran).
  history.replaceState(null, '', window.location.pathname);

  let token = null;
  try { token = sessionStorage.getItem(PW_TOKEN_KEY); } catch (e) { /* ignore */ }

  if (tokenHash) {
    try {
      const res = await fetch(`${SUPABASE_URL}/auth/v1/verify`, {
        method: 'POST',
        headers: { 'apikey': SUPABASE_ANON, 'Content-Type': 'application/json' },
        body: JSON.stringify({ type, token_hash: tokenHash }),
      });
      const data = await res.json().catch(() => null);
      if (res.ok && data && data.access_token) {
        token = data.access_token;
        try { sessionStorage.setItem(PW_TOKEN_KEY, token); } catch (e) { /* ignore */ }
      } else {
        token = null;
      }
    } catch (e) { token = null; }
  }

  document.getElementById('pw-checking').style.display = 'none';
  if (!token) {
    pwShowMessage(t('pw_err_link'), true);
    return;
  }
  document.getElementById('pw-form').style.display = 'block';
});

async function submitNewPassword(e) {
  e.preventDefault();
  const p1 = document.getElementById('pw-1').value;
  const p2 = document.getElementById('pw-2').value;
  const btn = document.getElementById('pw-btn');
  if (p1.length < 8) { pwShowMessage(t('pw_err_short'), true); return; }
  if (p1 !== p2) { pwShowMessage(t('pw_err_mismatch'), true); return; }

  let token = null;
  try { token = sessionStorage.getItem(PW_TOKEN_KEY); } catch (err) { /* ignore */ }
  if (!token) { pwShowMessage(t('pw_err_link'), true); return; }

  btn.disabled = true;
  try {
    const res = await fetch(`${SUPABASE_URL}/auth/v1/user`, {
      method: 'PUT',
      headers: { 'apikey': SUPABASE_ANON, 'Authorization': 'Bearer ' + token, 'Content-Type': 'application/json' },
      body: JSON.stringify({ password: p1 }),
    });
    const data = await res.json().catch(() => null);
    if (!res.ok) {
      if (res.status === 401 || res.status === 403) throw new Error(t('pw_err_link'));
      throw new Error((data && (data.msg || data.message || data.error_description)) || ('HTTP ' + res.status));
    }
    try { sessionStorage.removeItem(PW_TOKEN_KEY); } catch (err) { /* ignore */ }
    document.getElementById('pw-form').style.display = 'none';
    pwShowMessage(t('pw_done'), false);
    const loginLink = document.getElementById('pw-login');
    let next = null;
    try { next = sessionStorage.getItem('pw_reset_next'); sessionStorage.removeItem('pw_reset_next'); } catch (err) { /* ignore */ }
    if (next === 'buyer' || next === 'admin') {
      loginLink.href = next === 'admin' ? 'admin.html' : 'compte-acheteur.html';
      loginLink.removeAttribute('data-i18n');
      loginLink.textContent = t('acc_login');
    }
    loginLink.style.display = 'block';
  } catch (err) {
    pwShowMessage(t('pw_err_generic') + err.message, true);
    btn.disabled = false;
  }
}
