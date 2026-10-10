const rfqLocale = () => (getLang() === 'en' ? 'en-GB' : 'fr-FR');
// ═══════════════════════════════
// PAGE DOSSIERS RFQ/RFI/RFP — consultation et réponse côté fournisseur.
// Réutilise l'authentification/session de js/pages/supplier.js (même
// comptes, même sessionStorage) -- voir le hook `loadRfqBrowse` appelé
// depuis supplierRouteAfterAuth() une fois l'entreprise revendiquée.
// ═══════════════════════════════
let rfqDossierRows = [];
let pendingRfqDetailId = null; // id du dossier à ré-ouvrir après acceptation de l'accord de confidentialité

// RFQ / RFI / RFP : réservés aux fournisseurs Premium (consulter ET répondre). Règle appliquée en
// base (exception 'premium_required', backend/supabase_plan_limits_2026_10.sql) ; ici on explique.
function showRfqPremiumGate() {
  ['rfq-list-panel', 'rfq-detail-panel', 'rfq-my-responses-panel', 'rfq-nda-gate'].forEach(id => {
    const el = document.getElementById(id); if (el) el.style.display = 'none';
  });
  document.getElementById('rfq-premium-h').textContent = tf('rq_premium_h', 'Réservé aux fournisseurs Premium', 'Reserved for Premium suppliers');
  document.getElementById('rfq-premium-p').textContent = tf('rq_premium_p',
    'Les dossiers RFQ / RFI / RFP déposés par les systémiers sont accessibles aux entreprises ayant l\'abonnement Premium : consultation, accord de confidentialité et réponse.',
    'The RFQ / RFI / RFP files posted by systems integrators are available to companies on the Premium plan: browsing, confidentiality agreement and responses.');
  document.getElementById('rfq-premium-btn').textContent = t('sp_premium_btn');
  document.getElementById('rfq-premium-gate').style.display = 'block';
}

async function loadRfqBrowse() {
  if (typeof supplierCompany !== 'undefined' && supplierCompany && !supplierCompany.premium) { showRfqPremiumGate(); return; }
  document.getElementById('rfq-premium-gate').style.display = 'none';
  const listPanel = document.getElementById('rfq-list-panel');
  const list = document.getElementById('rfq-list');
  const gate = document.getElementById('rfq-nda-gate');
  const myResponsesPanel = document.getElementById('rfq-my-responses-panel');
  if (!list) return;
  document.getElementById('rfq-detail-panel').style.display = 'none';
  gate.style.display = 'none';
  listPanel.style.display = 'block';
  myResponsesPanel.style.display = 'block';
  list.innerHTML = t('acc_loading');
  try {
    // La liste elle-même est verrouillée par accord de confidentialité
    // (voir backend/supabase_rfq_gate_list_by_nda_2026_09.sql) : un
    // dossier RFQ ne doit être visible sous AUCUNE forme, pas même son
    // titre, avant acceptation -- get_rfq_dossiers_page() lève
    // 'nda_required' comme get_rfq_dossier_detail() ci-dessous.
    rfqDossierRows = await fetchAllRfqDossiers();
    renderRfqList();
    loadRfqMyResponses();
  } catch (err) {
    if (err.message === 'premium_required') { showRfqPremiumGate(); return; }
    if (err.message === 'nda_required') {
      listPanel.style.display = 'none';
      myResponsesPanel.style.display = 'none';
      gate.style.display = 'block';
      return;
    }
    list.innerHTML = `<p style="color:#E06A52;font-size:13px">${err.message}</p>`;
  }
}

// Même plafond de 50 lignes/requête que le reste du site (db-max-rows) --
// mais ici via une RPC (POST + p_offset dans le body), pas un GET direct
// avec ?offset=, d'où un paginateur dédié plutôt que
// adminFetchAllPages/supplierFetchAllPages.
async function fetchAllRfqDossiers() {
  let all = [];
  let offset = 0;
  while (true) {
    const page = await supplierFetch('rpc/get_rfq_dossiers_page', {
      method: 'POST',
      body: JSON.stringify({ p_limit: 50, p_offset: offset }),
    });
    if (!page || !page.length) break;
    all = all.concat(page);
    if (page.length < 50) break;
    offset += page.length;
  }
  return all;
}

function renderRfqList() {
  const list = document.getElementById('rfq-list');
  if (!rfqDossierRows.length) { list.innerHTML = `<p class="sup-empty">${t('rq_empty_list')}</p>`; return; }
  list.innerHTML = rfqDossierRows.map(d => `
    <div class="sup-prod">
      <div class="sup-prod-main">
        <span class="sup-prod-name">${escapeHtml(d.rfq_type)} — ${escapeHtml(d.title)}${d.requires_custom_nda ? ' 🔒' : ''}</span>
        <span class="sup-prod-cat">${escapeHtml(d.company_name)}${d.category ? ' · ' + escapeHtml(d.category) : ''}${d.deadline ? t('rq_before') + new Date(d.deadline).toLocaleDateString(rfqLocale()) : ''}${d.requires_custom_nda ? t('rq_custom_nda') : ''}</span>
      </div>
      <button class="btn-add-product sup-btn-sm" onclick="openRfqDetail('${d.id}')">${t('rq_view')}</button>
    </div>`).join('');
}

// Le détail complet (description + pièce jointe) n'est renvoyé par la RPC
// que si l'accord de confidentialité a été accepté -- sinon elle lève
// l'exception 'nda_required' (voir backend/supabase_add_rfq_system_2026_09.sql),
// qu'on intercepte ici pour afficher l'écran d'acceptation plutôt qu'une
// erreur générique.
async function openRfqDetail(id) {
  const panel = document.getElementById('rfq-detail-panel');
  const gate = document.getElementById('rfq-nda-gate');
  gate.style.display = 'none';
  panel.style.display = 'block';
  panel.innerHTML = t('acc_loading');
  try {
    const rows = await supplierFetch('rpc/get_rfq_dossier_detail', {
      method: 'POST',
      body: JSON.stringify({ p_id: id }),
    });
    const d = rows && rows[0];
    if (!d) { panel.innerHTML = '<p class="sup-empty">Ce dossier n\'est plus disponible.</p>'; return; }
    renderRfqDetail(d);
  } catch (err) {
    if (err.message === 'premium_required') { showRfqPremiumGate(); return; }
    if (err.message === 'nda_required') {
      panel.style.display = 'none';
      gate.style.display = 'block';
      pendingRfqDetailId = id;
      return;
    }
    panel.innerHTML = `<p style="color:#E06A52;font-size:13px">${err.message}</p>`;
  }
}

async function acceptRfqNda() {
  try {
    await supplierFetch('rfq_nda_acceptances', {
      method: 'POST',
      headers: { 'Prefer': 'return=minimal' },
      body: JSON.stringify([{ user_id: sessionStorage.getItem('sup_user_id') }]),
    });
    document.getElementById('rfq-nda-gate').style.display = 'none';
    // La liste elle-même était masquée en attendant la signature (voir
    // loadRfqBrowse) -- on la (re)charge maintenant qu'elle est débloquée.
    if (pendingRfqDetailId) { openRfqDetail(pendingRfqDetailId); pendingRfqDetailId = null; }
    else loadRfqBrowse();
  } catch (err) {
    alert(t('acc_err_prefix') + err.message);
  }
}

function renderRfqDetail(d) {
  const panel = document.getElementById('rfq-detail-panel');

  // Dossier avec NDA personnalisé, pas encore approuvé pour notre
  // entreprise : la RPC a déjà rédigé description/attachment_path (NULL),
  // on affiche l'écran de signature au lieu du contenu.
  if (d.requires_custom_nda && d.custom_nda_status !== 'approved') {
    renderCustomNdaPanel(d);
    return;
  }

  const filename = d.attachment_path ? d.attachment_path.split('/').pop() : null;
  panel.innerHTML = `
    <div class="sup-panel-head">
      <span class="submit-section-title" style="margin:0;border:none;padding:0">${escapeHtml(d.rfq_type)} — ${escapeHtml(d.title)}</span>
      <button type="button" class="btn-remove-product" onclick="document.getElementById('rfq-detail-panel').style.display='none'">${t('rq_close')}</button>
    </div>
    <p style="font-size:12px;color:var(--muted);margin:-6px 0 14px">
      ${escapeHtml(d.company_name)}${d.category ? ' · ' + escapeHtml(d.category) : ''}${d.industry ? ' · ' + escapeHtml(d.industry) : ''}${d.deadline ? t('rq_reply_before') + new Date(d.deadline).toLocaleDateString(rfqLocale()) : ''}
    </p>
    <p style="font-size:13px;color:var(--text2);line-height:1.7;white-space:pre-wrap">${escapeHtml(d.description)}</p>
    ${filename ? `<button type="button" class="btn-add-product sup-btn-sm" style="margin:10px 0" onclick="downloadRfqAttachment('${escapeJsAttr(d.attachment_path)}','${escapeJsAttr(filename)}')">${t('rq_dl_spec')}</button>` : ''}
    <div class="submit-section-title" style="margin-top:20px">${t('rq_reply_h')}</div>
    <form onsubmit="submitRfqResponse(event,'${d.id}')">
      <div class="lead-field"><label>${t('rq_msg')}</label><textarea id="rfq-resp-message" rows="4" required></textarea></div>
      <div class="lead-field"><label>${t('rq_price')}</label><input type="text" id="rfq-resp-price" placeholder="${t('rq_price_ph')}"/></div>
      <button type="submit" class="btn-submit-form">${t('rq_send')}</button>
    </form>`;
}

// ── NDA personnalisé (voir backend/supabase_add_rfq_custom_nda_2026_09.sql) --
// écran affiché tant que le systémier n'a pas approuvé notre signature
// pour CE dossier précis. custom_nda_status vaut 'none' (jamais soumis),
// 'pending' (en attente de vérification) ou 'rejected' (à corriger).
function renderCustomNdaPanel(d) {
  const panel = document.getElementById('rfq-detail-panel');
  const templateFilename = d.custom_nda_template_path ? d.custom_nda_template_path.split('/').pop() : null;

  const statusBlock = {
    none: `<p style="font-size:13px;color:var(--text2)">${t('rq_nda_none')}</p>`,
    pending: `<p style="font-size:13px;color:var(--text2)">${t('rq_nda_pending')}</p>`,
    rejected: `<p style="font-size:13px;color:#E06A52">${t('rq_nda_rejected_a')}${d.custom_nda_rejection_reason ? ' : ' + escapeHtml(d.custom_nda_rejection_reason) : ''}${t('rq_nda_rejected_b')}</p>`,
  }[d.custom_nda_status] || '';

  panel.innerHTML = `
    <div class="sup-panel-head">
      <span class="submit-section-title" style="margin:0;border:none;padding:0">${escapeHtml(d.rfq_type)} — ${escapeHtml(d.title)} 🔒</span>
      <button type="button" class="btn-remove-product" onclick="document.getElementById('rfq-detail-panel').style.display='none'">${t('rq_close')}</button>
    </div>
    <p style="font-size:12px;color:var(--muted);margin:-6px 0 14px">${escapeHtml(d.company_name)}${d.category ? ' · ' + escapeHtml(d.category) : ''}</p>
    ${statusBlock}
    ${templateFilename ? `<button type="button" class="btn-add-product sup-btn-sm" style="margin:10px 0" onclick="downloadRfqAttachment('${escapeJsAttr(d.custom_nda_template_path)}','${escapeJsAttr(templateFilename)}')">${t('rq_dl_nda')}</button>` : ''}
    ${d.custom_nda_status !== 'pending' ? `
    <div class="submit-section-title" style="margin-top:20px">${t('rq_nda_send_h')}</div>
    <form onsubmit="submitSignedNda(event,'${d.id}')">
      <div class="lead-field"><label>${t('rq_nda_file')}</label><input type="file" id="rfq-nda-signed-file" accept=".pdf" required/></div>
      <button type="submit" class="btn-submit-form">${t('rq_nda_send_btn')}</button>
    </form>` : ''}`;
}

async function submitSignedNda(e, rfqId) {
  e.preventDefault();
  const fileInput = document.getElementById('rfq-nda-signed-file');
  const file = fileInput.files[0];
  if (!file) return;
  const btn = e.target.querySelector('button[type="submit"]');
  btn.disabled = true;
  try {
    const token = sessionStorage.getItem('sup_access_token');
    const path = `${rfqId}/nda-signed/${supplierCompany.id}/${encodeURIComponent(file.name)}`;
    const res = await fetch(`${SUPABASE_URL}/storage/v1/object/rfq-attachments/${path}`, {
      method: 'POST',
      headers: { 'apikey': SUPABASE_ANON, 'Authorization': 'Bearer ' + token, 'Content-Type': file.type || 'application/octet-stream', 'x-upsert': 'true' },
      body: file,
    });
    if (!res.ok) throw new Error(`${t('rq_upload_fail')} (HTTP ${res.status})`);

    // Existe-t-il déjà une demande (rejetée) pour ce dossier ? Sinon on en
    // crée une nouvelle -- la contrainte unique (rfq_id, company_id) impose
    // une mise à jour plutôt qu'un second INSERT.
    const existing = await supplierFetch(`rfq_custom_nda_signatures?rfq_id=eq.${rfqId}&company_id=eq.${supplierCompany.id}&select=id`);
    if (existing && existing.length) {
      await supplierFetch(`rfq_custom_nda_signatures?id=eq.${existing[0].id}`, {
        method: 'PATCH',
        headers: { 'Prefer': 'return=minimal' },
        body: JSON.stringify({ signed_document_path: path, status: 'pending', rejection_reason: null }),
      });
    } else {
      await supplierFetch('rfq_custom_nda_signatures', {
        method: 'POST',
        headers: { 'Prefer': 'return=minimal' },
        body: JSON.stringify([{
          rfq_id: rfqId,
          company_id: supplierCompany.id,
          submitter_user_id: sessionStorage.getItem('sup_user_id'),
          submitter_name: supplierCompany.name,
          submitter_email: sessionStorage.getItem('sup_email'),
          signed_document_path: path,
        }]),
      });
    }

    alert(t('rq_nda_sent'));
    openRfqDetail(rfqId);
  } catch (err) {
    alert(t('acc_err_prefix') + err.message);
  } finally {
    btn.disabled = false;
  }
}

async function submitRfqResponse(e, rfqId) {
  e.preventDefault();
  const btn = e.target.querySelector('button[type="submit"]');
  btn.disabled = true;
  try {
    await supplierFetch('rfq_responses', {
      method: 'POST',
      headers: { 'Prefer': 'return=minimal' },
      body: JSON.stringify([{
        rfq_id: rfqId,
        company_id: supplierCompany.id,
        submitter_user_id: sessionStorage.getItem('sup_user_id'),
        submitter_name: supplierCompany.name,
        submitter_email: sessionStorage.getItem('sup_email'),
        message: document.getElementById('rfq-resp-message').value,
        price_label: document.getElementById('rfq-resp-price').value || null,
      }]),
    });
    alert(t('rq_resp_sent'));
    document.getElementById('rfq-detail-panel').style.display = 'none';
    loadRfqMyResponses();
  } catch (err) {
    alert(t('acc_err_prefix') + err.message);
  } finally {
    btn.disabled = false;
  }
}

// Téléchargement authentifié -- le bucket rfq-attachments est privé
// (voir backend/supabase_add_rfq_system_2026_09.sql SECTION 6), un lien
// <a href> classique n'enverrait pas le token ; on récupère le fichier en
// Blob puis on déclenche le téléchargement nous-mêmes.
async function downloadRfqAttachment(path, filename) {
  try {
    const token = sessionStorage.getItem('sup_access_token');
    const res = await fetch(`${SUPABASE_URL}/storage/v1/object/rfq-attachments/${path}`, {
      headers: { 'apikey': SUPABASE_ANON, 'Authorization': 'Bearer ' + token },
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const blob = await res.blob();
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url; a.download = filename;
    document.body.appendChild(a); a.click(); a.remove();
    URL.revokeObjectURL(url);
  } catch (err) {
    alert(t('rq_dl_fail') + err.message);
  }
}

async function loadRfqMyResponses() {
  const list = document.getElementById('rfq-my-responses-list');
  if (!list) return;
  list.innerHTML = t('acc_loading');
  try {
    const uid = sessionStorage.getItem('sup_user_id');
    const rows = await supplierFetch(`rfq_responses?submitter_user_id=eq.${uid}&select=*&order=created_at.desc`) || [];
    if (!rows.length) { list.innerHTML = `<p class="sup-empty">${t('rq_no_resp')}</p>`; return; }
    const statusMap = {
      sent:     { cls: 'sup-pill-pending', txt: t('rq_st_sent') },
      accepted: { cls: 'sup-pill-ok',      txt: t('acc_st_accepted') },
      rejected: { cls: 'sup-pill-no',      txt: t('acc_st_rejected') },
      invoiced: { cls: 'sup-pill-ok',      txt: t('rq_st_invoiced') },
    };
    list.innerHTML = rows.map(r => {
      const st = statusMap[r.status] || statusMap.sent;
      const preview = r.message.length > 70 ? r.message.slice(0, 70) + '…' : r.message;
      return `<div class="admin-field-row"><span>${escapeHtml(preview)}</span><span class="sup-pill ${st.cls}">${st.txt}</span></div>`;
    }).join('');
  } catch (err) {
    list.innerHTML = `<p style="color:#E06A52;font-size:13px">${err.message}</p>`;
  }
}

// Re-rendu au changement de langue : surcharge celle de supplier.js (chargé
// avant) -- on enchaîne donc les deux.
function onLangChange() {
  if (typeof supplierOnLangChange === 'function') supplierOnLangChange();
  if (typeof rfqDossierRows !== 'undefined' && rfqDossierRows.length && document.getElementById('rfq-list')) renderRfqList();
  if (typeof supplierCompany !== 'undefined' && supplierCompany && typeof loadRfqMyResponses === 'function') loadRfqMyResponses();
}
