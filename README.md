# Buy-ineer

Référentiel des équipementiers industriels — batteries, PDU, OBC, vannes, actionneurs, composants électriques et électromécaniques.

## Structure du projet

```
buyineer/
├── index.html     ← Site web complet (renommer buyineer-final.html → index.html)
├── data.json      ← Base de données : entreprises et produits
└── README.md
```

## Lancer le site en local

Le site utilise `fetch()` pour charger `data.json`, ce qui nécessite un serveur HTTP (pas un simple double-clic sur le HTML).

```bash
# Python 3
python3 -m http.server 8000

# Node.js
npx serve .
```

Puis ouvrir **http://localhost:8000**

## Hébergement sur GitHub Pages

1. Créer un repo GitHub (ex : `buyineer`)
2. Renommer `buyineer-final.html` en `index.html`
3. Pusher les deux fichiers (`index.html` + `data.json`)
4. Dans Settings → Pages → Source : `main` / `root`
5. Le site sera disponible sur `https://USERNAME.github.io/buyineer`

## Modifier les données

Toutes les entreprises et produits sont dans **`data.json`**. Structure :

```json
{
  "meta": { "version": "1.0", "last_updated": "2026-06-14" },
  "industries": ["Automobile & Mobilité électrique", ...],
  "product_categories": ["Batteries & Stockage", ...],
  "companies": [
    {
      "name": "CATL",
      "country": "🇨🇳 Chine",
      "hq": "Ningde",
      "industry": "Automobile & Mobilité électrique",
      "products": ["Batteries & Stockage"],
      "tags": ["LiFePO4", "NMC", "Pack 800V", "BMS"],
      "desc": "Description...",
      "site": "https://www.catl.com",
      "logo": "⚡",
      "verified": true,
      "premium": true,
      "employees": "100 000+",
      "founded": "2011",
      "contact": "contact@catl.com"
    }
  ],
  "products": [
    {
      "id": "p1",
      "name": "LiFePO4 Pack 280Ah",
      "maker": "CATL",
      "cat": "Batteries & Stockage",
      "industry": "Automobile & Mobilité électrique",
      "icon": "⚡",
      "desc": "Description...",
      "specs": [{"l": "Chimie", "v": "LiFePO4"}, ...],
      "bars": [{"l": "Densité énergie", "v": 78, "c": "#3A5A78"}, ...],
      "certs": ["CE", "UN38.3"],
      "price": "~480 € / kWh"
    }
  ]
}
```

## Évolution vers Supabase

Quand le projet grandira, migrer vers Supabase (PostgreSQL) :
- Remplacer `fetch('data.json')` par `fetch('https://[project].supabase.co/rest/v1/companies')`
- Ajouter l'authentification pour les comptes Pro et Premium Fournisseur
- Connecter Stripe pour les abonnements

