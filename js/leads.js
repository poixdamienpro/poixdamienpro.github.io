// ═══════════════════════════════
// LEAD / REQUEST QUOTE
// (Étape manuelle : la demande part vers FOUNDER_EMAIL, qui la relaie au
//  fournisseur et ne facture le lead que si le fournisseur l'accepte —
//  jamais de facturation sans accord préalable.)
// ═══════════════════════════════
function openLeadModal(targetName, productName) {
  leadTarget = { company: targetName, product: productName };
  document.getElementById('lead-target').textContent = productName
    ? `${productName} — ${targetName}`
    : targetName;
  resetLeadForm();
  document.getElementById('lead-overlay').classList.add('open');
}

function resetLeadForm() {
  document.getElementById('lead-body').innerHTML = `
    <p class="lead-intro">C'est gratuit. Votre demande est transmise au fournisseur, qui choisit de vous recontacter ou non — vous ne serez jamais inscrit à une liste de diffusion.</p>
    <form id="lead-form" onsubmit="submitLeadForm(event)">
      <div class="lead-field"><label>Nom complet</label><input type="text" id="lead-name" required/></div>
      <div class="lead-field"><label>Email professionnel</label><input type="email" id="lead-email" required/></div>
      <div class="lead-field"><label>Entreprise</label><input type="text" id="lead-company" required/></div>
      <div class="lead-field"><label>Votre besoin</label><textarea id="lead-need" required placeholder="Quantité, contraintes techniques, délai…"></textarea></div>
      <button type="submit" class="btn-quote" style="width:100%;justify-content:center">📩 Envoyer la demande</button>
    </form>`;
}

function submitLeadForm(e) {
  e.preventDefault();
  const name = document.getElementById('lead-name').value;
  const email = document.getElementById('lead-email').value;
  const company = document.getElementById('lead-company').value;
  const need = document.getElementById('lead-need').value;

  const subject = encodeURIComponent(`Demande de devis Buy-ineer — ${leadTarget.company}`);
  const body = encodeURIComponent(
    `Nouvelle demande de devis sur Buy-ineer.\n\n` +
    `Fournisseur visé : ${leadTarget.company}${leadTarget.product ? '\nProduit : ' + leadTarget.product : ''}\n\n` +
    `Contact acheteur :\n- Nom : ${name}\n- Email : ${email}\n- Entreprise : ${company}\n\n` +
    `Besoin :\n${need}\n\n` +
    `— Rappel process : transmettre ce lead à ${leadTarget.company} et ne facturer le lead fee que s'il l'accepte.`
  );
  // Étape 1 (manuelle) : ouvre un email pré-rempli vers le founder, qui relaie au fournisseur.
  window.location.href = `mailto:${FOUNDER_EMAIL}?subject=${subject}&body=${body}`;

  document.getElementById('lead-body').innerHTML = `
    <div class="lead-success">
      <div class="icon">✅</div>
      <h3>Demande envoyée</h3>
      <p>Votre demande pour <strong>${leadTarget.company}</strong> a été transmise. Le fournisseur sera informé et pourra vous recontacter directement — vous n'avez rien à payer.</p>
      <button class="btn-quote" onclick="closeModal('lead-overlay')" style="width:100%;justify-content:center">Fermer</button>
    </div>`;
}

