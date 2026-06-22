-- Vérifie quelles entreprises attendues n'existent pas (ou existent avec un nom légèrement différent)
WITH expected(name) AS (
  VALUES
    ('Samsung SDI'), ('LG Energy Solution'), ('Blue Solutions'), ('Verkor'),
    ('Schneider Electric'), ('Brusa Elektronik'), ('Parker Hannifin'), ('Bürkert'),
    ('Siemens'), ('Nidec'), ('Danfoss'), ('Emerson (Fisher)'), ('Neogy'), ('Lemo'),
    ('Flowserve'), ('Moog Space & Defense'), ('Saft (TotalEnergies)'), ('Forsee Power'),
    ('Batconnect'), ('Corvus Energy'), ('Eaton'), ('Safran Electrical & Power'),
    ('Delta Electronics'), ('Victron Energy'), ('Moog'), ('Rotork'), ('ABB'), ('Alstom'),
    ('TE Connectivity'), ('Sensata Technologies'), ('Amphenol'), ('Infineon Technologies'),
    ('GS Yuasa Technology (Space)'), ('EaglePicher Technologies')
)
SELECT e.name AS attendu, c.name AS trouve_en_base
FROM expected e
LEFT JOIN companies c ON c.name = e.name
WHERE c.id IS NULL;

-- Si la requête ci-dessus retourne des lignes, compare avec les noms réels en base :
SELECT name FROM companies ORDER BY name;
