// ═══════════════════════════════
// LEAD / REQUEST QUOTE
// L'email part automatiquement vers FOUNDER_EMAIL via Web3Forms (API
// publique conçue pour être appelée depuis du JS client, comme la clé
// anon Supabase). Le founder relaie ensuite au fournisseur et ne
// facture le lead que si le fournisseur l'accepte — jamais de
// facturation sans accord préalable. En parallèle, chaque lead est aussi
// enregistré dans la table `leads` (voir backend/supabase_add_leads.sql)
// pour garder une trace exploitable — l'email reste le canal principal,
// l'enregistrement en base est best-effort et ne bloque jamais l'envoi.
// ═══════════════════════════════
function openLeadModal(targetName, productName, companyId) {
  leadTarget = { company: targetName, product: productName, companyId: companyId || null };
  document.getElementById('lead-target').textContent = productName
    ? `${productName} · ${targetName}`
    : targetName;
  resetLeadForm();
  document.getElementById('lead-overlay').classList.add('open');
}

function resetLeadForm() {
  document.getElementById('lead-body').innerHTML = `
    <p class="lead-intro">C'est gratuit. Votre demande est transmise au fournisseur, qui choisit de vous recontacter ou non, vous ne serez jamais inscrit à une liste de diffusion.</p>
    <form id="lead-form" onsubmit="submitLeadForm(event)">
      <div class="lead-field"><label>Nom complet</label><input type="text" id="lead-name" required/></div>
      <div class="lead-field"><label>Email professionnel</label><input type="email" id="lead-email" required/></div>
      <div class="lead-field"><label>Entreprise</label><input type="text" id="lead-company" required/></div>
      <div class="lead-field"><label>Votre besoin</label><textarea id="lead-need" required placeholder="Quantité, contraintes techniques, délai…"></textarea></div>
      <button type="submit" class="btn-quote" style="width:100%;justify-content:center">📩 Envoyer la demande</button>
    </form>`;
}

async function submitLeadForm(e) {
  e.preventDefault();
  const name = document.getElementById('lead-name').value;
  const email = document.getElementById('lead-email').value;
  const company = document.getElementById('lead-company').value;
  const need = document.getElementById('lead-need').value;

  const submitBtn = document.querySelector('#lead-form button[type=submit]');
  if (submitBtn) { submitBtn.disabled = true; submitBtn.textContent = 'Envoi en cours…'; }

  try {
    const res = await fetch('https://api.web3forms.com/submit', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
      body: JSON.stringify({
        access_key: WEB3FORMS_ACCESS_KEY,
        subject: `Demande de devis Buy-inner · ${leadTarget.company}`,
        from_name: 'Buy-inner',
        to: FOUNDER_EMAIL,
        name,
        email,
        company,
        message:
          `Fournisseur visé : ${leadTarget.company}${leadTarget.product ? '\nProduit : ' + leadTarget.product : ''}\n\n` +
          `Besoin :\n${need}\n\n` +
          `Rappel process : transmettre ce lead à ${leadTarget.company} et ne facturer le lead fee que s'il l'accepte.`,
      }),
    });
    const data = await res.json();
    if (!data.success) throw new Error(data.message || 'Échec de l\'envoi.');

    // Trace en base, best-effort : l'email ci-dessus est le canal
    // critique et vient de réussir — si Supabase est indisponible, on ne
    // bloque jamais le buyer pour autant, on logue juste l'échec.
    fetch(`${SUPABASE_URL}/rest/v1/leads`, {
      method: 'POST',
      headers: {
        'apikey': SUPABASE_ANON,
        'Authorization': 'Bearer ' + SUPABASE_ANON,
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      body: JSON.stringify({
        company_id: leadTarget.companyId,
        company_name: leadTarget.company,
        product_name: leadTarget.product,
        buyer_name: name,
        buyer_email: email,
        buyer_company: company,
        message: need,
      }),
    }).then(r => { if (!r.ok) throw new Error('HTTP ' + r.status); })
      .catch(err => console.error('Erreur enregistrement lead en base (email envoyé quand même) :', err));

    document.getElementById('lead-body').innerHTML = `
      <div class="lead-success">
        <div class="icon">✅</div>
        <h3>Demande envoyée</h3>
        <p>Votre demande pour <strong>${leadTarget.company}</strong> a été transmise. Le fournisseur sera informé et pourra vous recontacter directement, vous n'avez rien à payer.</p>
        <button class="btn-quote" onclick="closeModal('lead-overlay')" style="width:100%;justify-content:center">Fermer</button>
      </div>`;
  } catch (err) {
    console.error('Erreur envoi lead:', err);
    if (submitBtn) { submitBtn.disabled = false; submitBtn.textContent = '📩 Envoyer la demande'; }
    alert(`Erreur lors de l'envoi. Vérifiez votre connexion et réessayez, ou écrivez-nous directement à ${FOUNDER_EMAIL}.`);
  }
}

