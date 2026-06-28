// ═══════════════════════════════
// SUPPLIER SELF-SERVICE SUBMISSION
// Écrit dans product_submissions (file d'attente, pas dans companies/products
// directement) — chaque ligne est relue avant publication. Voir
// supabase_product_submissions.sql pour la table et la policy RLS.
// ═══════════════════════════════
let productBlockCount = 0;
let productImageUrls = {};

document.addEventListener('DOMContentLoaded', async () => {
  await loadLayout();
  try {
    await loadTaxonomy();
    const indList = document.getElementById('industry-list');
    if (indList) indList.innerHTML = INDUSTRIES.map(i => `<option value="${i}">`).join('');
  } catch (err) {
    console.error('Erreur Supabase:', err);
  }
  addProductBlock();
});

async function handleImageSelect(e, idx) {
  const file = e.target.files[0];
  const status = document.getElementById('image-status-' + idx);
  const preview = document.getElementById('image-preview-' + idx);
  if (!file) return;

  if (file.size > 5 * 1024 * 1024) {
    status.textContent = 'Fichier trop lourd (max 5 Mo).';
    status.style.color = '#C0392B';
    e.target.value = '';
    return;
  }

  status.textContent = 'Envoi en cours…';
  status.style.color = 'var(--muted)';
  try {
    const ext = file.name.split('.').pop().replace(/[^a-zA-Z0-9]/g, '') || 'jpg';
    const path = `submissions/${Date.now()}-${Math.random().toString(36).slice(2, 8)}.${ext}`;
    const res = await fetch(`${SUPABASE_URL}/storage/v1/object/product-images/${path}`, {
      method: 'POST',
      headers: {
        'apikey': SUPABASE_ANON,
        'Authorization': 'Bearer ' + SUPABASE_ANON,
        'Content-Type': file.type || 'application/octet-stream',
      },
      body: file,
    });
    if (!res.ok) throw new Error('HTTP ' + res.status);

    const publicUrl = `${SUPABASE_URL}/storage/v1/object/public/product-images/${path}`;
    productImageUrls[idx] = publicUrl;
    preview.src = publicUrl;
    preview.style.display = 'block';
    status.textContent = '✓ Photo envoyée.';
    status.style.color = 'var(--sage)';
  } catch (err) {
    console.error('Erreur upload image:', err);
    status.textContent = "Échec de l'envoi de la photo. Le produit peut quand même être soumis sans elle.";
    status.style.color = '#C0392B';
  }
}

function addProductBlock() {
  productBlockCount++;
  const idx = productBlockCount;
  const block = document.createElement('div');
  block.className = 'product-block';
  block.id = 'product-block-' + idx;
  block.innerHTML = `
    <div class="product-block-header">
      <span class="product-block-title">Produit ${idx}</span>
      <button type="button" class="btn-remove-product" onclick="removeProductBlock(${idx})">✕ Retirer</button>
    </div>
    <div class="submit-grid">
      <div class="lead-field"><label>Nom du produit</label><input type="text" class="p-name" required/></div>
      <div class="lead-field"><label>Catégorie</label><input type="text" class="p-category" required placeholder="ex: Batteries & Stockage"/></div>
      <div class="lead-field"><label>Industrie</label><input type="text" class="p-industry" list="industry-list"/></div>
      <div class="lead-field"><label>Prix indicatif</label><input type="text" class="p-price" placeholder="ex: ~500 € ou Sur devis"/></div>
    </div>
    <div class="lead-field"><label>Description</label><textarea class="p-desc"></textarea></div>
    <div class="lead-field"><label>Certifications (séparées par des virgules)</label><input type="text" class="p-certs" placeholder="CE, UN38.3, ..."/></div>
    <div class="lead-field">
      <label>Photo du produit (optionnel, 5 Mo max)</label>
      <input type="file" class="p-image" accept="image/*" onchange="handleImageSelect(event, ${idx})"/>
      <img class="p-image-preview" id="image-preview-${idx}" style="display:none;max-width:160px;border-radius:6px;margin-top:8px;border:1px solid var(--border)"/>
      <p class="p-image-status" id="image-status-${idx}" style="font-size:11px;color:var(--muted);margin-top:4px"></p>
    </div>
    <div class="lead-field">
      <label>Specs techniques</label>
      <div class="spec-rows" id="spec-rows-${idx}"></div>
      <button type="button" class="btn-add-spec" onclick="addSpecRow(${idx})">+ Ajouter une spec</button>
    </div>`;
  document.getElementById('product-blocks').appendChild(block);
  addSpecRow(idx);
}

function removeProductBlock(idx) {
  const block = document.getElementById('product-block-' + idx);
  if (block) block.remove();
  delete productImageUrls[idx];
}

function addSpecRow(blockIdx) {
  const rows = document.getElementById('spec-rows-' + blockIdx);
  const row = document.createElement('div');
  row.className = 'spec-row';
  row.innerHTML = `<input type="text" class="spec-label" placeholder="Label (ex: Tension)"/><input type="text" class="spec-value" placeholder="Valeur (ex: 48 V)"/><button type="button" class="btn-remove-spec" onclick="this.parentElement.remove()">✕</button>`;
  rows.appendChild(row);
}

async function submitSupplierForm(e) {
  e.preventDefault();

  const submitterName = document.getElementById('sub-submitter-name').value;
  const submitterEmail = document.getElementById('sub-submitter-email').value;
  const companyName = document.getElementById('sub-company-name').value;
  const companyCountry = document.getElementById('sub-company-country').value || null;
  const companyHq = document.getElementById('sub-company-hq').value || null;
  const companyIndustry = document.getElementById('sub-company-industry').value || null;
  const companySite = document.getElementById('sub-company-site').value || null;
  const companyContact = document.getElementById('sub-company-contact').value || null;
  const companyDesc = document.getElementById('sub-company-desc').value || null;

  const blocks = document.querySelectorAll('#product-blocks .product-block');
  if (blocks.length === 0) { alert('Ajoutez au moins un produit.'); return; }

  const rows = [];
  blocks.forEach(block => {
    const specs = [];
    block.querySelectorAll('.spec-row').forEach(r => {
      const l = r.querySelector('.spec-label').value.trim();
      const v = r.querySelector('.spec-value').value.trim();
      if (l && v) specs.push({ label: l, value: v });
    });
    const certs = block.querySelector('.p-certs').value.split(',').map(c => c.trim()).filter(Boolean);
    const blockIdx = block.id.replace('product-block-', '');
    rows.push({
      product_image_url: productImageUrls[blockIdx] || null,
      status: 'pending',
      submitter_name: submitterName,
      submitter_email: submitterEmail,
      company_name: companyName,
      company_country: companyCountry,
      company_hq: companyHq,
      company_industry: companyIndustry,
      company_site: companySite,
      company_description: companyDesc,
      company_contact_email: companyContact,
      product_name: block.querySelector('.p-name').value,
      product_category: block.querySelector('.p-category').value,
      product_industry: companyIndustry,
      product_description: block.querySelector('.p-desc').value || null,
      product_price_label: block.querySelector('.p-price').value || null,
      product_specs: specs,
      product_certs: certs,
    });
  });

  const submitBtn = document.querySelector('#submit-form .btn-submit-form');
  if (submitBtn) { submitBtn.disabled = true; submitBtn.textContent = 'Envoi en cours…'; }

  try {
    const res = await fetch(`${SUPABASE_URL}/rest/v1/product_submissions`, {
      method: 'POST',
      headers: {
        'apikey': SUPABASE_ANON,
        'Authorization': 'Bearer ' + SUPABASE_ANON,
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      body: JSON.stringify(rows),
    });
    if (!res.ok) throw new Error('HTTP ' + res.status);

    document.getElementById('submit-wrap').innerHTML = `
      <div class="lead-success">
        <div class="icon">✅</div>
        <h3>Merci !</h3>
        <p>${rows.length} produit(s) envoyé(s) pour validation. Vous serez recontacté à <strong>${submitterEmail}</strong> une fois la fiche publiée, gratuitement, aucune carte bancaire n'a été demandée.</p>
        <a class="btn-quote" href="${ROOT_PREFIX}index.html" style="width:100%;justify-content:center">Retour à l'accueil</a>
      </div>`;
  } catch (err) {
    console.error('Erreur soumission Supabase:', err);
    if (submitBtn) { submitBtn.disabled = false; submitBtn.textContent = '📩 Envoyer pour validation'; }
    alert(`Erreur lors de l'envoi. Vérifiez votre connexion et réessayez, ou écrivez-nous directement à ${FOUNDER_EMAIL}.`);
  }
}

