-- Vérifie s'il y a des entreprises en double (notamment les 5 fournisseurs Défense)
SELECT name, COUNT(*) AS nb
FROM companies
WHERE name IN ('Thales', 'Cobham', 'L3Harris Technologies', 'Rheinmetall', 'Honeywell Aerospace')
GROUP BY name
HAVING COUNT(*) > 1;
