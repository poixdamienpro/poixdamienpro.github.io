// ═══════════════════════════════
// RFQ / RFI — publication publique, liste ouverte, suivi par lien privé
// L'acheteur n'a jamais de compte : son identité reste dans la table
// rfqs (RLS : INSERT anon possible, SELECT anon impossible). Le suivi
// de ses propales passe par le RPC get_rfq_responses(rfq_id, token),
// jamais par une lecture directe de table. Voir supabase_add_rfq_feature.sql.
// ═══════════════════════════════
let RFQS = [];
let rfqInd = 'all';
let rfqCat = 'all';

async function loadRfqs() {
  try {
    RFQS = await supabase('v_rfqs_public', 'order=created_at.desc');
  } catch (err) {
    console.error('Erreur chargement RFQ:', err);
    RFQS = [];
  }
  initChips('rfq-ind-chips', INDUSTRIES, () => rfqInd, v => { rfqInd = v; renderRfqList(); });
  initChips('rfq-cat-chips', PROD_CATS, () => rfqCat, v => { rfqCat = v; renderRfqList(); });
  renderRfqList();
}

function renderRfqList() {
  const grid = document.getElementById('rfq-grid');
  if (!grid) return;
  const filtered = RFQS.filter(r =>
    (rfqInd === 'all' || r.industry === rfqInd) && (rfqCat === 'all' || r.category === rfqCat)
  );
  const count = document.getElementById('rfq-count');
  if (count) count.innerHTML = ' — <strong>' + filtered.length + '</strong> besoin' + (filtered.length !== 1 ? 's' : '') + ' ouvert' + (filtered.length !== 1 ? 's' : '');

  if (!filtered.length) {
    grid.innerHTML = '<div style="grid-column:1/-1;text-align:center;padding:48px;background:var(--white);border:1px solid var(--border);border-radius:8px"><div style="font-size:32px;margin-bottom:10px;opacity:.3">📋</div><p style="color:var(--muted)">Aucune RFQ/RFI ouverte pour le moment.</p></div>';
    return;
  }

  grid.innerHTML = filtered.map(r => `
    <div class="company-card">
      <div class="card-header">
        <div style="display:flex;align-items:center;gap:10px">
          <div class="card-logo">${r.rfq_type === 'RFI' ? '❔' : '📋'}</div>
          <div>
            <div class="card-name">${r.title}</div>
            <div class="card-meta">${r.rfq_type} ${r.industry ? '· ' + r.industry : ''} ${r.category ? '· ' + r.category : ''}</div>
          </div>
        </div>
      </div>
      <p style="font-size:13px;color:var(--text2);line-height:1.6;margin:10px 0">${r.description}</p>
      ${r.specs_needed ? `<p style="font-size:12px;color:var(--muted);margin-bottom:6px"><strong>Specs souhaitées :</strong> ${r.specs_needed}</p>` : ''}
      <div style="display:flex;gap:14px;font-size:12px;color:var(--muted);flex-wrap:wrap">
        ${r.budget_range ? `<span>💰 ${r.budget_range}</span>` : ''}
        ${r.deadline ? `<span>📅 Échéance : ${new Date(r.deadline).toLocaleDateString('fr-FR')}</span>` : ''}
        <span>🕓 Publiée le ${new Date(r.created_at).toLocaleDateString('fr-FR')}</span>
      </div>
    </div>`).join('');
}

function openRfqModal() {
  resetRfqForm();
  document.getElementById('rfq-overlay').classList.add('open');
}

function resetRfqForm() {
  document.getElementById('rfq-body').innerHTML = `
    <p class="lead-intro">Gratuit et illimité. Votre identité ne sera jamais transmise aux fournisseurs — seuls votre besoin et ses specs leur sont montrés. Vous suivrez les propales reçues via un lien privé, sans créer de compte.</p>
    <form id="rfq-form" onsubmit="submitRfqForm(event)">
      <div class="submit-grid">
        <div class="lead-field"><label>Type de demande</label>
          <select id="rfq-type" required>
            <option value="RFQ">RFQ — Request For Quotation</option>
            <option value="RFI">RFI — Request For Information</option>
          </select>
        </div>
        <div class="lead-field"><label>Titre du besoin</label><input type="text" id="rfq-title" required placeholder="ex: PCDU 28V pour microsatellite 50kg"/></div>
      </div>
      <div class="submit-grid">
        <div class="lead-field"><label>Industrie</label><input type="text" id="rfq-industry" list="industry-list"/></div>
        <div class="lead-field"><label>Catégorie</label><input type="text" id="rfq-category" placeholder="ex: PDU (Power Distribution)"/></div>
      </div>
      <div class="lead-field"><label>Description du besoin</label><textarea id="rfq-description" required placeholder="Contexte, contraintes, volumes, environnement d'utilisation…"></textarea></div>
      <div class="lead-field"><label>Specs techniques souhaitées</label><textarea id="rfq-specs" placeholder="ex: 28V régulé, 500W, -40°C à +85°C, interface CAN…"></textarea></div>
      <div class="submit-grid">
        <div class="lead-field"><label>Budget indicatif (optionnel)</label><input type="text" id="rfq-budget" placeholder="ex: 5 000-10 000 €"/></div>
        <div class="lead-field"><label>Échéance souhaitée (optionnel)</label><input type="date" id="rfq-deadline"/></div>
      </div>
      <div class="submit-section-title" style="margin-top:20px">Vos coordonnées (jamais visibles des fournisseurs)</div>
      <div class="submit-grid">
        <div class="lead-field"><label>Nom complet</label><input type="text" id="rfq-buyer-name" required/></div>
        <div class="lead-field"><label>Email professionnel</label><input type="email" id="rfq-buyer-email" required/></div>
        <div class="lead-field"><label>Entreprise (optionnel)</label><input type="text" id="rfq-buyer-company"/></div>
      </div>
      <button type="submit" class="btn-quote" style="width:100%;justify-content:center">📩 Publier ma RFQ/RFI</button>
    </form>`;
}

async function submitRfqForm(e) {
  e.preventDefault();
  const row = {
    rfq_type: document.getElementById('rfq-type').value,
    title: document.getElementById('rfq-title').value,
    industry: document.getElementById('rfq-industry').value || null,
    category: document.getElementById('rfq-category').value || null,
    description: document.getElementById('rfq-description').value,
    specs_needed: document.getElementById('rfq-specs').value || null,
    budget_range: document.getElementById('rfq-budget').value || null,
    deadline: document.getElementById('rfq-deadline').value || null,
    buyer_name: document.getElementById('rfq-buyer-name').value,
    buyer_email: document.getElementById('rfq-buyer-email').value,
    buyer_company: document.getElementById('rfq-buyer-company').value || null,
  };

  const submitBtn = document.querySelector('#rfq-form button[type=submit]');
  if (submitBtn) { submitBtn.disabled = true; submitBtn.textContent = 'Envoi en cours…'; }

  try {
    const res = await fetch(`${SUPABASE_URL}/rest/v1/rfqs`, {
      method: 'POST',
      headers: {
        'apikey': SUPABASE_ANON,
        'Authorization': 'Bearer ' + SUPABASE_ANON,
        'Content-Type': 'application/json',
        'Prefer': 'return=representation',
      },
      body: JSON.stringify([row]),
    });
    if (!res.ok) throw new Error('HTTP ' + res.status);
    const created = await res.json();
    const rfq = created[0];
    const trackingUrl = `${window.location.origin}${window.location.pathname}?rfq=${rfq.id}&token=${rfq.access_token}`;

    document.getElementById('rfq-body').innerHTML = `
      <div class="lead-success">
        <div class="icon">✅</div>
        <h3>Demande envoyée</h3>
        <p>Votre ${row.rfq_type} a été soumise et sera publiée après relecture (quelques heures à quelques jours). Gardez précieusement ce lien — c'est le seul moyen de consulter les propales reçues, votre identité ne sera jamais communiquée aux fournisseurs :</p>
        <p style="word-break:break-all;background:var(--bg2);padding:10px;border-radius:6px;font-size:12px;margin:10px 0"><a href="${trackingUrl}">${trackingUrl}</a></p>
        <button class="btn-quote" onclick="closeModal('rfq-overlay')" style="width:100%;justify-content:center">Fermer</button>
      </div>`;
  } catch (err) {
    console.error('Erreur soumission RFQ:', err);
    if (submitBtn) { submitBtn.disabled = false; submitBtn.textContent = '📩 Publier ma RFQ/RFI'; }
    alert(`Erreur lors de l'envoi. Vérifiez votre connexion et réessayez, ou écrivez-nous directement à ${FOUNDER_EMAIL}.`);
  }
}

// ── Page de suivi acheteur (lien privé ?rfq=<id>&token=<access_token>) ──
async function tryShowRfqTrackingPage() {
  const params = new URLSearchParams(window.location.search);
  const rfqId = params.get('rfq');
  const token = params.get('token');
  if (!rfqId || !token) return;

  showPage('rfq-tracking');
  const wrap = document.getElementById('rfq-tracking-body');
  wrap.innerHTML = '<p style="color:var(--muted)">Chargement de vos propales…</p>';

  try {
    const res = await fetch(`${SUPABASE_URL}/rest/v1/rpc/get_rfq_responses`, {
      method: 'POST',
      headers: {
        'apikey': SUPABASE_ANON,
        'Authorization': 'Bearer ' + SUPABASE_ANON,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ p_rfq_id: rfqId, p_token: token }),
    });
    if (!res.ok) throw new Error('HTTP ' + res.status);
    const responses = await res.json();

    if (!responses || !responses.length) {
      wrap.innerHTML = '<div class="lead-success"><div class="icon">⏳</div><h3>Pas encore de propale</h3><p>Aucun fournisseur n\'a encore répondu à votre demande. Revenez consulter ce lien plus tard.</p></div>';
      return;
    }

    wrap.innerHTML = responses.map(r => `
      <div class="admin-card">
        <div class="admin-card-head">
          <div>
            <div class="admin-card-title">🏭 ${r.company_name}</div>
            <div class="admin-card-meta">Propale reçue le ${new Date(r.created_at).toLocaleDateString('fr-FR')}</div>
          </div>
        </div>
        <div class="admin-field-row"><span>Prix proposé</span><span>${r.quote_price || 'Sur devis'}</span></div>
        ${r.lead_time ? `<div class="admin-field-row"><span>Délai</span><span>${r.lead_time}</span></div>` : ''}
        <div class="admin-specs-list"><div>${r.message}</div></div>
        ${r.attachment_url ? `<a class="btn-visit" href="${r.attachment_url}" target="_blank" rel="noopener" style="margin-top:10px;display:inline-block">📎 Voir le document joint</a>` : ''}
      </div>`).join('');
  } catch (err) {
    console.error('Erreur chargement propales:', err);
    wrap.innerHTML = '<p style="color:#C0392B">Lien invalide ou expiré. Vérifiez que vous avez copié l\'URL complète.</p>';
  }
}
