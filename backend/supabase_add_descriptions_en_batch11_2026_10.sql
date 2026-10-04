-- ============================================================
-- Traductions anglaises (description_en) — lot « batch11 », 2026-10
-- Entreprises : Samlex Europe, SC45, Scavolt, SCHURTER, SEF Power, Segula Technologies, Sensordin, SHERPA Engineering, SIREPE, Sirius Space Services, Skeleton Technologies, Skyroot Aerospace, SNEES, Spaceit, SpaceX, Stellantis, STI GENLIS, Stoke Space, Swissfluid AG, Synergie Engineering, Tehtris, Terran Orbital, Tesla, TESVOLT, Thales Alenia Space, Toyota, TT Electronics, Turgis & Gaillard, United Launch Alliance, Unseenlabs, Volkswagen Group, Vulcain Ingénierie, WATTALPS, Xsens, XtreeE, York Space Systems
--
-- Sûr à relancer : ne remplit que les champs encore vides (IS NULL).
-- ============================================================

-- ---- Samlex Europe ----
UPDATE companies SET description_en = 'ISO 9001-certified Dutch manufacturer of inverters, battery chargers and DC/DC converters, for marine, solar and backup applications.'
WHERE name = 'Samlex Europe' AND description_en IS NULL;

UPDATE products SET description_en = 'ISO 9001-certified inverter, battery charger and DC/DC converter, for marine, solar and backup applications.'
WHERE name = 'Onduleur et chargeur DC-DC' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Samlex Europe');

-- ---- SC45 ----
UPDATE companies SET description_en = 'French subcontractor specializing in harnesses, electrical and electronic wiring and assembly integration, one-off or in small/medium series.'
WHERE name = 'SC45' AND description_en IS NULL;

UPDATE products SET description_en = 'Manufacture of harnesses, electrical and electronic wiring and assembly integration, one-off or in small/medium series.'
WHERE name = 'Faisceaux et câblage sur mesure' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'SC45');

-- ---- Scavolt ----
UPDATE companies SET description_en = 'Polish manufacturer of energy storage systems, from portable to industrial solutions, with 20 years of experience in electrical engineering.'
WHERE name = 'Scavolt' AND description_en IS NULL;

UPDATE products SET description_en = 'Modular battery storage system, from portable to industrial, with associated technical advice and service.'
WHERE name = 'Système de stockage d''énergie industriel' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Scavolt');

-- ---- SCHURTER ----
UPDATE companies SET description_en = 'Swiss manufacturer of connectors, circuit protection components and custom wiring harnesses for industrial electronics.'
WHERE name = 'SCHURTER' AND description_en IS NULL;

UPDATE products SET description_en = 'Range of connectors and circuit protection components (fuses, filters) for industrial electronics, with custom wiring harnesses.'
WHERE name = 'Connecteur et protection de circuit' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'SCHURTER');

-- ---- SEF Power ----
UPDATE companies SET description_en = 'French manufacturer of custom power converters for defense, rail and aeronautics, with integrated electronic wiring services.'
WHERE name = 'SEF Power' AND description_en IS NULL;

UPDATE products SET description_en = 'Power converter designed to order for defense, rail and aeronautics, with integrated electronic wiring.'
WHERE name = 'Convertisseur de puissance sur mesure' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'SEF Power');

-- ---- Segula Technologies ----
UPDATE companies SET description_en = 'French engineering group present worldwide, serving industrial competitiveness in automotive, aeronautics, energy, rail, naval and life sciences.'
WHERE name = 'Segula Technologies' AND description_en IS NULL;

UPDATE products SET description_en = 'Project teams and technical assistance in engineering, from concept to industrialization, for automotive, aeronautics, energy, rail and naval.'
WHERE name = 'Ingénierie et assistance technique multi-sectorielle' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Segula Technologies');

-- ---- Sensordin ----
UPDATE companies SET description_en = 'Portuguese supplier of industrial automation solutions and sensors for industry and machine builders.'
WHERE name = 'Sensordin' AND description_en IS NULL;

UPDATE products SET description_en = 'Industrial automation solutions and sensors for industry and machine builders.'
WHERE name = 'Solution d''automatisation et capteurs industriels' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Sensordin');

-- ---- SHERPA Engineering ----
UPDATE companies SET description_en = 'French systems engineering services company, specializing in modeling and control for automotive, aeronautics, energy, naval and space.'
WHERE name = 'SHERPA Engineering' AND description_en IS NULL;

UPDATE products SET description_en = 'Study, design and validation of technical systems: modeling and control for ADAS, autonomous vehicles and complex multi-domain systems.'
WHERE name = 'Ingénierie système et modélisation' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'SHERPA Engineering');

-- ---- SIREPE ----
UPDATE companies SET description_en = 'French design office in power electronics and conversion systems, working from space and aeronautics to rail and automotive.'
WHERE name = 'SIREPE' AND description_en IS NULL;

UPDATE products SET description_en = 'Design of custom energy conversion systems, from space and aeronautics to rail and automotive.'
WHERE name = 'Étude électronique de puissance sur mesure' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'SIREPE');

-- ---- Sirius Space Services ----
UPDATE companies SET description_en = 'French launch company developing a range of 3 rockets (Sirius 1/13/15) with STAR-1 engines, with a launch agreement from the Arnhem Space Centre in Australia from 2026.'
WHERE name = 'Sirius Space Services' AND description_en IS NULL;

UPDATE products SET description_en = 'French light launch vehicle with STAR-1 engines, second in Sirius Space Services'' range of 3 launchers (Sirius 1/13/15). Launch planned from the Arnhem Space Centre (Australia) from 2026.'
WHERE name = 'Sirius 13' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Sirius Space Services');

-- ---- Skeleton Technologies ----
UPDATE companies SET description_en = 'Estonian manufacturer of curved-graphene-based supercapacitors, for rail, power grid and critical infrastructure applications.'
WHERE name = 'Skeleton Technologies' AND description_en IS NULL;

UPDATE products SET description_en = 'Supercapacitor based on patented curved graphene, for stabilizing dynamic electrical loads in critical applications.'
WHERE name = 'Supercondensateur graphène courbé' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Skeleton Technologies');

-- ---- Skyroot Aerospace ----
UPDATE companies SET description_en = 'India''s first private launch company, Vikram range (Vikram-S suborbital already flown in 2022, orbital Vikram-1), in-house solid and liquid propellant engines.'
WHERE name = 'Skyroot Aerospace' AND description_en IS NULL;

UPDATE products SET description_en = 'India''s first private orbital launch vehicle, 4 stages (3 solid-propellant + a precision liquid stage). Developed by Skyroot Aerospace, Kalam and Raman engines.'
WHERE name = 'Vikram-1' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Skyroot Aerospace');

-- ---- SNEES ----
UPDATE companies SET description_en = 'French manufacturer of electronic boards in series (EMS): SMT assembly, soldering, conformal coating and integration of subassemblies and finished electronic products.'
WHERE name = 'SNEES' AND description_en IS NULL;

UPDATE products SET description_en = 'SMT assembly, soldering, conformal coating and integration of subassemblies and finished electronic products, in a 5,000 m² factory.'
WHERE name = 'Assemblage et intégration électronique en série' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'SNEES');

-- ---- Spaceit ----
UPDATE companies SET description_en = 'Estonian spin-off of the ESTCube-1 mission, offering mission control as a service and a ground station marketplace for satellite operators.'
WHERE name = 'Spaceit' AND description_en IS NULL;

UPDATE products SET description_en = 'Mission control service and ground station marketplace, connecting satellite operators to a network of shared ground stations.'
WHERE name = 'Contrôle de mission en tant que service' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Spaceit');

-- ---- SpaceX ----
UPDATE companies SET description_en = 'US launch company, the world''s first operator of reusable rockets (Falcon 9, Falcon Heavy, Starship), also operator of the Starlink constellation.'
WHERE name = 'SpaceX' AND description_en IS NULL;

UPDATE products SET description_en = 'SpaceX reusable orbital launch vehicle, the world''s first reusable orbital launcher (first stage recoverable by vertical landing). 9 Merlin engines, RP-1/LOX propellants.'
WHERE name = 'Falcon 9' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'SpaceX');

-- ---- Stellantis ----
UPDATE companies SET description_en = 'Multi-brand automotive group (Peugeot, Citroën, Opel, Fiat, Jeep, Chrysler...), electric platform maker with the modular STLA architecture (Small/Medium/Large/Frame).'
WHERE name = 'Stellantis' AND description_en IS NULL;

UPDATE products SET description_en = 'Stellantis modular electric platform for C/D segment vehicles, 400V architecture scalable to 800V, up to 2 million vehicles/year across several sites.'
WHERE name = 'Plateforme STLA Medium' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Stellantis');

-- ---- STI GENLIS ----
UPDATE companies SET description_en = 'French subcontractor for electrical wiring, cabling, wiring harnesses and cabinet wiring, active since 1988.'
WHERE name = 'STI GENLIS' AND description_en IS NULL;

UPDATE products SET description_en = 'Electrical wiring, cabling, wiring harnesses and cabinet wiring for industrial applications.'
WHERE name = 'Câblage et faisceaux électriques' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'STI GENLIS');

-- ---- Stoke Space ----
UPDATE companies SET description_en = 'US launch company designing Nova, a fully reusable launch vehicle (upper stage recovered via an actively cooled metallic heat shield), with no expended component.'
WHERE name = 'Stoke Space' AND description_en IS NULL;

UPDATE products SET description_en = 'Stoke Space''s fully reusable launch vehicle (no expended component, fairing included). Upper stage with an actively cooled metallic heat shield, recovered and reused.'
WHERE name = 'Nova' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Stoke Space');

-- ---- Swissfluid AG ----
UPDATE companies SET description_en = 'Swiss manufacturer of lined valves and sampling systems for highly corrosive applications (chemicals, pharma, petrochemicals).'
WHERE name = 'Swissfluid AG' AND description_en IS NULL;

UPDATE products SET description_en = 'Lined valve and sampling system for highly corrosive applications in chemicals, pharmaceuticals and petrochemicals.'
WHERE name = 'Vanne revêtue anticorrosion' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Swissfluid AG');

-- ---- Synergie Engineering ----
UPDATE companies SET description_en = 'Engineering division of the Synergie group, specializing in the placement of engineers and technicians on time-and-materials and temporary contracts for industry.'
WHERE name = 'Synergie Engineering' AND description_en IS NULL;

UPDATE products SET description_en = 'Placement of engineers and technicians on time-and-materials and temporary contracts, for industrial engineering assignments.'
WHERE name = 'Intérim et régie ingénierie industrielle' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Synergie Engineering');

-- ---- Tehtris ----
UPDATE companies SET description_en = 'French cybersecurity startup (Pessac, Bordeaux), publisher of the Tehtris XDR platform (EDR/EPP/MTD/SIEM/Honeypots/NTA), entirely developed and hosted in France/Europe, ISO 27001 certified.'
WHERE name = 'Tehtris' AND description_en IS NULL;

UPDATE products SET description_en = 'Automated, real-time cyber defense platform (EDR, EPP, MTD, SIEM, honeypots, NTA, DNS firewall), neutralizing attacks without human intervention.'
WHERE name = 'TEHTRIS XDR Platform' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Tehtris');

-- ---- Terran Orbital ----
UPDATE companies SET description_en = 'US platform maker (acquired by Lockheed Martin in 2024), with a range of 7 standardized satellite buses (14 to 1,000+ kg wet mass), used notably for the US Space Development Agency.'
WHERE name = 'Terran Orbital' AND description_en IS NULL;

UPDATE products SET description_en = 'The largest of Terran Orbital''s 7 standardized platforms, "flat-pack" design allowing up to 24 satellites to be carried per launch.'
WHERE name = 'Enterprise' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Terran Orbital');

-- ---- Tesla ----
UPDATE companies SET description_en = 'US carmaker, pioneer of the mass-market electric vehicle (Model 3, Model Y, Model S, Cybertruck), also a manufacturer of stationary batteries and solar systems.'
WHERE name = 'Tesla' AND description_en IS NULL;

UPDATE products SET description_en = 'Tesla compact electric SUV, the segment''s global best-seller. Standard Range version with an LFP battery, Long Range/Performance versions with an NMC battery.'
WHERE name = 'Model Y' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Tesla');

-- ---- TESVOLT ----
UPDATE companies SET description_en = 'German manufacturer of battery storage systems for commercial and industrial applications, produced in its own gigafactory in Wittenberg. German leader in the commercial storage segment.'
WHERE name = 'TESVOLT' AND description_en IS NULL;

UPDATE products SET description_en = 'Modular battery storage system for commercial and industrial applications, produced in a gigafactory. Used for self-consumption and energy grids.'
WHERE name = 'PowerCore — système de stockage batterie' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'TESVOLT');

-- ---- Thales Alenia Space ----
UPDATE companies SET description_en = 'Joint venture of Thales (67%) / Leonardo (33%), one of the world''s largest makers of geostationary and LEO satellite platforms, known for the Spacebus range. A separate entity from the Thales defense/RF division already listed.'
WHERE name = 'Thales Alenia Space' AND description_en IS NULL;

UPDATE products SET description_en = 'Thales Alenia Space range of geostationary telecommunications platforms, available in all-electric, hybrid or all-chemical versions, from the smallest to the largest format. Developed under an ESA program.'
WHERE name = 'Spacebus NEO' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Thales Alenia Space');

-- ---- Toyota ----
UPDATE companies SET description_en = 'World''s largest carmaker by volume, electric platform maker with the e-TNGA architecture (bZ4X), jointly developed with Subaru.'
WHERE name = 'Toyota' AND description_en IS NULL;

UPDATE products SET description_en = 'Toyota electric SUV on the e-TNGA platform (co-developed with Subaru), flat battery under the floor for a low center of gravity.'
WHERE name = 'bZ4X' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Toyota');

-- ---- TT Electronics ----
UPDATE companies SET description_en = 'British precision electronics group, whose Fairford site (1978) manufactures military wiring harnesses for harsh environments — land vehicles, aircraft, naval and defense systems.'
WHERE name = 'TT Electronics' AND description_en IS NULL;

UPDATE products SET description_en = 'Complex wiring harnesses for harsh environments, air combat platforms and missile defense systems. Custom multi-conductor cables, machine/hand braiding, various terminations.'
WHERE name = 'Harnais de câblage militaire haute fiabilité' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'TT Electronics');

-- ---- Turgis & Gaillard ----
UPDATE companies SET description_en = 'French defense startup, designer of the Aarok MALE drone (France''s largest drone), shown at the Paris Air Show in 2023.'
WHERE name = 'Turgis & Gaillard' AND description_en IS NULL;

UPDATE products SET description_en = 'Turgis & Gaillard MALE (Medium Altitude Long Endurance) drone, the largest drone designed in France, compatible with standard NATO hangars, turboprop engine.'
WHERE name = 'Aarok' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Turgis & Gaillard');

-- ---- United Launch Alliance ----
UPDATE companies SET description_en = 'Boeing / Lockheed Martin joint venture, historic launcher for US government missions (national security, NASA), Vulcan Centaur range.'
WHERE name = 'United Launch Alliance' AND description_en IS NULL;

UPDATE products SET description_en = 'United Launch Alliance''s new-generation heavy launch vehicle, 2 Blue Origin BE-4 engines (LOX/liquid methane) on the first stage and a Centaur V upper stage, up to 6 strap-on boosters.'
WHERE name = 'Vulcan Centaur' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'United Launch Alliance');

-- ---- Unseenlabs ----
UPDATE companies SET description_en = 'French startup (Rennes), world leader in maritime surveillance by space-based RF detection: BRO nanosatellite constellation detecting and geolocating ship radio emissions, including those that have switched off their AIS.'
WHERE name = 'Unseenlabs' AND description_en IS NULL;

UPDATE products SET description_en = 'Unseenlabs 6U-8U nanosatellite with single-satellite technology, detecting and geolocating ship RF emissions day and night, whatever the weather. Constellation set to reach 20 satellites.'
WHERE name = 'BRO (Breizh Reconnaissance Orbiter)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Unseenlabs');

-- ---- Volkswagen Group ----
UPDATE companies SET description_en = 'German automotive group, electric platform maker with the MEB architecture (ID.3, ID.4, ID.7), also used by Audi, Skoda and Cupra within the group.'
WHERE name = 'Volkswagen Group' AND description_en IS NULL;

UPDATE products SET description_en = 'Volkswagen electric SUV on the MEB platform, available with rear-wheel or all-wheel drive, several battery sizes.'
WHERE name = 'ID.4' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Volkswagen Group');

-- ---- Vulcain Ingénierie ----
UPDATE companies SET description_en = 'French engineering group working in nuclear, renewable energy, hydrogen and transport infrastructure, from reactor development to waste management.'
WHERE name = 'Vulcain Ingénierie' AND description_en IS NULL;

UPDATE products SET description_en = 'Project engineering and technical assistance for nuclear, renewable energy, hydrogen and transport infrastructure.'
WHERE name = 'Ingénierie nucléaire et énergie' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Vulcain Ingénierie');

-- ---- WATTALPS ----
UPDATE companies SET description_en = 'French manufacturer of high-performance battery packs for demanding applications (industrial vehicles, motorsport), with an in-house ISO 26262-certified BMS and immersion cooling.'
WHERE name = 'WATTALPS' AND description_en IS NULL;

UPDATE products SET description_en = 'Immersion-cooled battery pack for demanding applications (industrial vehicles, motorsport), with an in-house ISO 26262-certified BMS.'
WHERE name = 'Pack batterie haute performance' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'WATTALPS');

-- ---- Xsens ----
UPDATE companies SET description_en = 'Dutch manufacturer of 3D motion sensors and inertial measurement units (IMUs), used in robotics, aerospace and professional motion-tracking applications.'
WHERE name = 'Xsens' AND description_en IS NULL;

UPDATE products SET description_en = 'Inertial measurement unit (IMU) for 3D motion tracking, used in robotics, aerospace and professional applications.'
WHERE name = 'MTi — centrale inertielle (IMU)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Xsens');

-- ---- XtreeE ----
UPDATE companies SET description_en = 'French startup (Rungis) in large-scale concrete 3D printing for construction, more than 25 industrial installations in 10+ countries, multiple materials (concrete, plaster, raw earth, geopolymers).'
WHERE name = 'XtreeE' AND description_en IS NULL;

UPDATE products SET description_en = 'XtreeE large-scale 3D printing system for construction (printers, print heads, robotic arms + software suite), multiple materials (concrete, plaster, raw earth, geopolymers).'
WHERE name = 'Imprimante 3D béton' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'XtreeE');

-- ---- York Space Systems ----
UPDATE companies SET description_en = 'US platform maker standardizing satellite bus production (S-CLASS and LX-CLASS ranges) to reduce manufacturing cost by an order of magnitude, government and commercial customers.'
WHERE name = 'York Space Systems' AND description_en IS NULL;

UPDATE products SET description_en = 'York Space Systems standardized 3-axis satellite bus, designed to reduce manufacturing cost by an order of magnitude. ISR, proximity, weather and communications missions.'
WHERE name = 'S-CLASS' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'York Space Systems');

-- Contrôle : produits de ces entreprises encore sans description anglaise (doit être 0).
SELECT c.name AS entreprise, count(*) FILTER (WHERE p.description_en IS NULL) AS sans_anglais, count(*) AS total
FROM companies c LEFT JOIN products p ON p.company_id = c.id
WHERE c.name IN ('Samlex Europe', 'SC45', 'Scavolt', 'SCHURTER', 'SEF Power', 'Segula Technologies', 'Sensordin', 'SHERPA Engineering', 'SIREPE', 'Sirius Space Services', 'Skeleton Technologies', 'Skyroot Aerospace', 'SNEES', 'Spaceit', 'SpaceX', 'Stellantis', 'STI GENLIS', 'Stoke Space', 'Swissfluid AG', 'Synergie Engineering', 'Tehtris', 'Terran Orbital', 'Tesla', 'TESVOLT', 'Thales Alenia Space', 'Toyota', 'TT Electronics', 'Turgis & Gaillard', 'United Launch Alliance', 'Unseenlabs', 'Volkswagen Group', 'Vulcain Ingénierie', 'WATTALPS', 'Xsens', 'XtreeE', 'York Space Systems')
GROUP BY c.name ORDER BY c.name;
