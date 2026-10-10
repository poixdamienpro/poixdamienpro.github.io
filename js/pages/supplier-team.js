// ═══════════════════════════════
// ÉQUIPE DE L'ENTREPRISE (comptes multiples + invitations)
// Chargé après supplier.js (voir pages/supplier.html). Toute la logique
// d'accès est côté base (backend/supabase_company_members_2026_10.sql) :
// ici on ne fait qu'appeler les RPC et afficher le résultat.
//   administrateur ('owner')  : gère l'équipe + tout le reste
//   collaborateur  ('member') : mêmes droits produits / devis / stats / RFQ,
//                               mais ne gère pas l'équipe
// Plan gratuit : 1 compte. Premium : jusqu'à 20 (limite appliquée en base).
// ═══════════════════════════════
let supplierMyRole = 'member';
let supplierTeam = { members: [], invites: [], seats: null };

const INVITE_STORE_KEY = 'bi_invite';

// Le lien reçu par email est pages/supplier.html?invite=<jeton>. On le garde
// (le visiteur doit d'abord se connecter, parfois confirmer son email puis
// revenir) et on le retire de la barre d'adresse.
(function captureInviteToken() {
  try {
    const params = new URLSearchParams(window.location.search);
    const token = params.get('invite');
    if (!token) return;
    try { localStorage.setItem(INVITE_STORE_KEY, token); } catch (e) { sessionStorage.setItem(INVITE_STORE_KEY, token); }
    params.delete('invite');
    const qs = params.toString();
    history.replaceState(null, '', window.location.pathname + (qs ? '?' + qs : ''));
  } catch (e) { /* sans jeton, le flux normal continue */ }
})();

function getPendingInvite() {
  try { return localStorage.getItem(INVITE_STORE_KEY) || sessionStorage.getItem(INVITE_STORE_KEY); } catch (e) { return null; }
}
function clearPendingInvite() {
  try { localStorage.removeItem(INVITE_STORE_KEY); } catch (e) { /* ignore */ }
  try { sessionStorage.removeItem(INVITE_STORE_KEY); } catch (e) { /* ignore */ }
}

// Visiteur pas encore connecté avec une invitation en poche : on l'explique.
document.addEventListener('DOMContentLoaded', () => {
  if (getPendingInvite() && !sessionStorage.getItem('sup_access_token') && typeof showSupplierNotice === 'function') {
    showSupplierNotice(t('team_invite_login'), false, true);
  }
});

function supplierRpc(name, args) {
  return supplierFetch(`rpc/${name}`, { method: 'POST', body: JSON.stringify(args || {}) });
}

// Codes d'erreur stables levés par la base (RAISE EXCEPTION 'SEAT_LIMIT'...)
function teamErrorMessage(err) {
  const m = String((err && err.message) || '').match(/[A-Z][A-Z_]{4,}/);
  const key = m ? 'team_err_' + m[0] : null;
  return key && TRANSLATIONS[getLang()][key] ? t(key) : ((err && err.message) || t('team_err_generic'));
}

function showSupplierNotice(msg, isError, sticky) {
  const box = document.getElementById('sup-notice');
  if (!box) { if (isError) alert(msg); return; }
  box.textContent = msg;
  box.className = 'sup-notice ' + (isError ? 'sup-notice-err' : 'sup-notice-ok');
  box.style.display = 'block';
  if (!isError && !sticky) setTimeout(() => { if (box.textContent === msg) box.style.display = 'none'; }, 8000);
}

// Appelée par supplierRouteAfterAuth() juste après la connexion.
async function acceptPendingInvite() {
  const token = getPendingInvite();
  if (!token) return;
  clearPendingInvite(); // une seule tentative : un lien périmé ne doit pas bloquer à chaque visite
  try {
    const res = await supplierRpc('accept_company_invite', { p_token: token });
    showSupplierNotice(t('team_joined').replace('{company}', (res && res.company_name) || ''), false);
  } catch (err) {
    showSupplierNotice(teamErrorMessage(err), true);
  }
}

async function loadSupplierTeam() {
  const wrap = document.getElementById('sup-team-list');
  if (!wrap || !supplierCompany) return;
  wrap.innerHTML = `<p class="sup-empty">${t('acc_loading')}</p>`;
  try {
    const [members, seats] = await Promise.all([
      supplierRpc('list_company_members', { p_company: supplierCompany.id }),
      supplierRpc('get_company_seats', { p_company: supplierCompany.id }),
    ]);
    supplierMyRole = seats && seats.is_owner ? 'owner' : 'member';
    const invites = supplierMyRole === 'owner'
      ? await supplierRpc('list_company_invites', { p_company: supplierCompany.id })
      : [];
    supplierTeam = { members: members || [], invites: invites || [], seats };
    renderSupplierTeam();
  } catch (err) {
    // Migration pas encore exécutée (fonctions absentes) : on masque le panneau
    // plutôt que d'afficher une erreur technique à un fournisseur.
    if (/Could not find the function|HTTP 404|PGRST202/i.test(String(err && err.message))) {
      const panel = document.getElementById('sup-team-panel');
      if (panel) panel.style.display = 'none';
      return;
    }
    wrap.innerHTML = `<p style="color:#E06A52;font-size:13px">${escapeHtml(teamErrorMessage(err))}</p>`;
  }
}

const teamRoleLabel = role => t(role === 'owner' ? 'team_role_owner' : 'team_role_member');
const teamDate = iso => new Date(iso).toLocaleDateString(supLocale());

function renderSupplierTeam() {
  const wrap = document.getElementById('sup-team-list');
  const badge = document.getElementById('sup-team-seats');
  if (!wrap) return;
  const { members, invites, seats } = supplierTeam;
  const isOwner = supplierMyRole === 'owner';
  const ownersCount = members.filter(m => m.role === 'owner').length;

  if (badge && seats) {
    badge.textContent = t('team_seats').replace('{used}', seats.used).replace('{limit}', seats.limit);
  }

  const memberRows = members.map(m => {
    const me = m.is_me ? ` <span class="sup-team-me">(${t('team_you')})</span>` : '';
    let actions = '';
    if (isOwner && !m.is_me) {
      actions = `
        <select class="sup-team-role" onchange="changeMemberRole('${m.user_id}', this.value)" aria-label="${escapeHtml(t('team_invite_role'))}">
          <option value="owner"${m.role === 'owner' ? ' selected' : ''}>${t('team_role_owner')}</option>
          <option value="member"${m.role === 'member' ? ' selected' : ''}>${t('team_role_member')}</option>
        </select>
        <button class="btn-remove-product" onclick="removeTeamMember('${m.user_id}','${escapeJsAttr(m.email)}')">${t('team_remove')}</button>`;
    } else if (m.is_me && !(m.role === 'owner' && ownersCount <= 1)) {
      actions = `<button class="btn-remove-product" onclick="removeTeamMember('${m.user_id}','${escapeJsAttr(m.email)}')">${t('team_leave')}</button>`;
    }
    return `
      <div class="sup-prod">
        <div class="sup-prod-main">
          <span class="sup-prod-name">${escapeHtml(m.email)}${me}</span>
          <span class="sup-prod-cat">${teamRoleLabel(m.role)}</span>
        </div>
        <div class="sup-prod-actions">${actions}</div>
      </div>`;
  }).join('');

  let inviteRows = '';
  if (isOwner && invites.length) {
    inviteRows = `
      <div class="sup-team-sub">${t('team_pending_h')}</div>
      ${invites.map(i => `
      <div class="sup-prod">
        <div class="sup-prod-main">
          <span class="sup-prod-name">${escapeHtml(i.email)}</span>
          <span class="sup-prod-cat">${teamRoleLabel(i.role)} · ${t('team_expires').replace('{date}', teamDate(i.expires_at))}</span>
        </div>
        <div class="sup-prod-actions">
          <button class="btn-add-product sup-btn-sm" onclick="resendTeamInvite('${i.id}','${escapeJsAttr(i.email)}')">${t('team_resend')}</button>
          <button class="btn-remove-product" onclick="revokeTeamInvite('${i.id}')">${t('team_cancel_invite')}</button>
        </div>
      </div>`).join('')}`;
  }

  let inviteBox = '';
  if (!isOwner) {
    inviteBox = `<p class="sup-team-note">${t('team_only_admin')}</p>`;
  } else if (seats && seats.used >= seats.limit) {
    const isFree = !supplierCompany.premium;
    inviteBox = `
      <div class="sup-team-note">
        ${t(isFree ? 'team_free_limit' : 'team_full')}
        ${isFree ? `<button class="btn-add-product sup-btn-sm" style="margin-left:8px" onclick="startPremiumCheckout()">${t('sp_premium_btn')}</button>` : ''}
      </div>`;
  } else {
    inviteBox = `
      <div class="sup-team-sub">${t('team_invite_h')}</div>
      <form class="sup-team-form" onsubmit="inviteTeamMember(event)">
        <input type="email" id="sup-team-email" required placeholder="${escapeHtml(t('team_invite_email'))}" aria-label="${escapeHtml(t('team_invite_email'))}"/>
        <select id="sup-team-new-role" aria-label="${escapeHtml(t('team_invite_role'))}">
          <option value="member">${t('team_role_member')}</option>
          <option value="owner">${t('team_role_owner')}</option>
        </select>
        <button type="submit" class="btn-add-product" id="sup-team-send">${t('team_invite_btn')}</button>
      </form>
      <p class="sup-team-note">${t('team_role_hint')}</p>`;
  }

  wrap.innerHTML = memberRows + inviteRows + inviteBox;
}

// Envoie l'email via le Worker, qui relit l'invitation en base avec NOTRE jeton
// de session : le client ne choisit ni le destinataire ni le lien.
async function sendInviteEmail(inviteId) {
  const res = await fetch(`${SUPABASE_URL}/send-invite-email`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer ' + sessionStorage.getItem('sup_access_token') },
    body: JSON.stringify({ inviteId, lang: getLang() }),
  });
  if (!res.ok) throw new Error('HTTP ' + res.status);
}

async function inviteTeamMember(e) {
  e.preventDefault();
  const email = document.getElementById('sup-team-email').value.trim();
  const role = document.getElementById('sup-team-new-role').value;
  const btn = document.getElementById('sup-team-send');
  btn.disabled = true;
  try {
    const res = await supplierRpc('invite_company_member', { p_company: supplierCompany.id, p_email: email, p_role: role });
    try {
      await sendInviteEmail(res.invite_id);
      showSupplierNotice(t('team_sent').replace('{email}', email), false);
    } catch (mailErr) {
      showSupplierNotice(t('team_sent_noemail').replace('{email}', email), true);
    }
  } catch (err) {
    showSupplierNotice(teamErrorMessage(err), true);
  }
  await loadSupplierTeam();
}

async function resendTeamInvite(inviteId, email) {
  try {
    await sendInviteEmail(inviteId);
    showSupplierNotice(t('team_sent').replace('{email}', email), false);
  } catch (err) {
    showSupplierNotice(t('team_sent_noemail').replace('{email}', email), true);
  }
}

async function revokeTeamInvite(inviteId) {
  try {
    await supplierRpc('revoke_company_invite', { p_invite: inviteId });
  } catch (err) {
    showSupplierNotice(teamErrorMessage(err), true);
  }
  await loadSupplierTeam();
}

async function changeMemberRole(userId, role) {
  try {
    await supplierRpc('set_company_member_role', { p_company: supplierCompany.id, p_user: userId, p_role: role });
  } catch (err) {
    showSupplierNotice(teamErrorMessage(err), true);
  }
  await loadSupplierTeam();
}

async function removeTeamMember(userId, email) {
  const me = userId === sessionStorage.getItem('sup_user_id');
  const msg = me
    ? t('team_confirm_leave').replace('{company}', supplierCompany.name)
    : t('team_confirm_remove').replace('{email}', email);
  if (!confirm(msg)) return;
  try {
    await supplierRpc('remove_company_member', { p_company: supplierCompany.id, p_user: userId });
    if (me) { supplierLogout(); return; }
  } catch (err) {
    showSupplierNotice(teamErrorMessage(err), true);
  }
  await loadSupplierTeam();
}
