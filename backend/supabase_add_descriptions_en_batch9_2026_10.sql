-- ============================================================
-- Traductions anglaises (description_en) — lot « batch9 », 2026-10
-- Entreprises : BYD, CAEN ELS, Cailabs, Carbios, Cavok Engineering, CDETECH, CETIM, Cicor, CRIT, CT Ingénierie, Delair, Disruptive Technologies, DualSun, E-Space, Ekium, Ekyrail, Electra, Elithion, ELMECH-ASE, Eltorque, ENAG, Engix, EODev, Eutelsat OneWeb, Ewattch, Ewert Energy Systems, Exotec, Expleo France, Figeac Aéro, Firefly Aerospace, Fives, GAIA Converter, Galactic Energy, GIF Emploi, GISMA Steckverbinder, Glass-Link, GPV, Groundcom, Groupe REEL, Hedon Technologies, Hensoldt Nexeya France, Institut de Soudure, Instrumia, Isar Aerospace, KickMaker
--
-- Sûr à relancer : ne remplit que les champs encore vides (IS NULL).
-- ============================================================

-- ---- BYD ----
UPDATE companies SET description_en = 'Chinese carmaker, world''s top seller of electrified vehicles, platform maker with the e-Platform 3.0 architecture and its in-house LFP Blade Battery.'
WHERE name = 'BYD' AND description_en IS NULL;

UPDATE products SET description_en = 'BYD electric sedan, the first built on the e-Platform 3.0 architecture, with an LFP Blade Battery integrated into the structure.'
WHERE name = 'Seal' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'BYD');

-- ---- CAEN ELS ----
UPDATE companies SET description_en = 'Italian manufacturer of precision power supplies and programmable power distribution systems, for particle accelerators, scientific instrumentation and high-precision industrial applications.'
WHERE name = 'CAEN ELS' AND description_en IS NULL;

UPDATE products SET description_en = 'CAEN ELS four-quadrant bipolar, bidirectional and regenerative power supply, to be integrated into power distribution systems for particle accelerators and precision instrumentation.'
WHERE name = 'FAST-Bi-1K5' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAEN ELS');

-- ---- Cailabs ----
UPDATE companies SET description_en = 'French photonics startup (Rennes), proprietary laser beam shaping technology (MPLC, 22 patents), for space laser communications, industrial laser machining and defense.'
WHERE name = 'Cailabs' AND description_en IS NULL;

UPDATE products SET description_en = 'Cailabs optical ground station for space laser communications, compliant with SDA and CCSDS standards, proprietary beam-shaping (MPLC) technology.'
WHERE name = 'Optical Ground Station' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Cailabs');

-- ---- Carbios ----
UPDATE companies SET description_en = 'French biorecycling startup, enzymatic PET depolymerization process (bottles, textiles), first European biorecycling plant planned in France from 2028.'
WHERE name = 'Carbios' AND description_en IS NULL;

UPDATE products SET description_en = 'Carbios enzymatic PET depolymerization process, breaking plastic down into terephthalic acid and monoethylene glycol that can be fed back into the production of new polymers.'
WHERE name = 'Procédé de biorecyclage PET' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Carbios');

-- ---- Cavok Engineering ----
UPDATE companies SET description_en = 'French aeronautical consulting, study and engineering firm: recruitment assistance, project management assistance and time-and-materials technical assistance.'
WHERE name = 'Cavok Engineering' AND description_en IS NULL;

UPDATE products SET description_en = 'Recruitment assistance, project management assistance and time-and-materials technical assistance for aeronautical projects.'
WHERE name = 'Assistance technique et recrutement ingénieurs' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Cavok Engineering');

-- ---- CDETECH ----
UPDATE companies SET description_en = 'French vibration testing laboratory serving aeronautics (DO-160), space (ECSS), automotive and rail.'
WHERE name = 'CDETECH' AND description_en IS NULL;

UPDATE products SET description_en = 'Vibration testing and qualification for aeronautics (DO-160), space (ECSS), automotive and rail.'
WHERE name = 'Essais vibratoires multi-secteurs' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CDETECH');

-- ---- CETIM ----
UPDATE companies SET description_en = 'French technical center for the mechanical industries: testing, inspection, product and process engineering, and technology transfer to manufacturers.'
WHERE name = 'CETIM' AND description_en IS NULL;

UPDATE products SET description_en = 'Testing, inspection and product/process engineering for mechanical manufacturers, with technology transfer from research.'
WHERE name = 'Essais et ingénierie mécanique' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CETIM');

-- ---- Cicor ----
UPDATE companies SET description_en = 'Swiss electronics contract manufacturing (EMS) group, with two wiring harness manufacturing sites in France (Combrée, Neuilly-en-Thelle) for industry, rail, defense, nuclear and medical.'
WHERE name = 'Cicor' AND description_en IS NULL;

UPDATE products SET description_en = 'Manufacture of custom wiring harnesses for complex electronic systems, French sites dedicated to rail/transport/medical (Neuilly-en-Thelle) and defense/nuclear/medical (Combrée).'
WHERE name = 'Harnais de câblage industriel et défense' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Cicor');

-- ---- CRIT ----
UPDATE companies SET description_en = 'French temporary staffing and recruitment group, with a national network of branches specialized in aeronautics and industry, from technician to engineer.'
WHERE name = 'CRIT' AND description_en IS NULL;

UPDATE products SET description_en = 'Provision of technicians and engineers on temporary and recruitment contracts, with a national network of branches specialized in aeronautics and industry.'
WHERE name = 'Intérim et recrutement technique multi-secteurs' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CRIT');

-- ---- CT Ingénierie ----
UPDATE companies SET description_en = 'French engineering group for aeronautics, space, rail and automotive: design of test benches, prototypes, tooling and production industrialization.'
WHERE name = 'CT Ingénierie' AND description_en IS NULL;

UPDATE products SET description_en = 'Design of test benches, prototypes and tooling, and support for production industrialization for aeronautics, space and rail.'
WHERE name = 'Conception de bancs d''essais et industrialisation' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CT Ingénierie');

-- ---- Delair ----
UPDATE companies SET description_en = 'French startup (Toulouse region) designing fixed-wing and VTOL drones for industry, surveillance and defense, already tested by the French Navy.'
WHERE name = 'Delair' AND description_en IS NULL;

UPDATE products SET description_en = 'Delair fixed-wing VTOL drone, for aerial reconnaissance missions, deployment in 15 minutes over a 20 m² area.'
WHERE name = 'DT46' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Delair');

-- ---- Disruptive Technologies ----
UPDATE companies SET description_en = 'Norwegian manufacturer of miniature wireless IoT sensors (temperature, proximity, humidity) for industrial and building monitoring.'
WHERE name = 'Disruptive Technologies' AND description_en IS NULL;

UPDATE products SET description_en = 'Miniature wireless sensor (temperature, proximity, humidity) with long battery life, for industrial and building monitoring.'
WHERE name = 'Capteur IoT sans fil miniature' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Disruptive Technologies');

-- ---- DualSun ----
UPDATE companies SET description_en = 'French startup (Marseille), designer of the first hybrid solar panel certified "Made in France" (simultaneous photovoltaic + thermal).'
WHERE name = 'DualSun' AND description_en IS NULL;

UPDATE products SET description_en = 'DualSun hybrid photovoltaic/thermal (PVT) solar panel, producing electricity and hot water simultaneously through an integrated heat exchanger. 70% of the value produced in Europe.'
WHERE name = 'SPRING' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'DualSun');

-- ---- E-Space ----
UPDATE companies SET description_en = 'Operator founded in 2022 by Greg Wyler (founder of O3b Networks and OneWeb), which designs and operates its own constellation of small LEO satellites designed to resist fragmentation in the event of a collision.'
WHERE name = 'E-Space' AND description_en IS NULL;

UPDATE products SET description_en = 'Small LEO satellite designed to resist fragmentation in the event of a collision and to deorbit automatically in case of failure, intended for E-Space''s own constellation (a connectivity service, not a platform sold to third parties). First demonstrators launched in May 2022; operational status not publicly confirmed.'
WHERE name = 'Satellite E-Space (constellation propre)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'E-Space');

-- ---- Ekium ----
UPDATE companies SET description_en = 'French multi-discipline engineering company (automation, electrical, instrumentation) working in industry, naval and energy, subsidiary of the SNEF group.'
WHERE name = 'Ekium' AND description_en IS NULL;

UPDATE products SET description_en = 'Study, design and integration of automation, electrical and instrumentation systems for industry, naval and energy.'
WHERE name = 'Ingénierie et automatisme industriel' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Ekium');

-- ---- Ekyrail ----
UPDATE companies SET description_en = 'Canadian manufacturer of power conversion systems for locomotives and trains: inverters, boosters and power supplies designed for demanding rail environments.'
WHERE name = 'Ekyrail' AND description_en IS NULL;

UPDATE products SET description_en = 'Inverter and power conversion system for locomotives and trains, designed for demanding rail environments.'
WHERE name = 'Onduleur locomotive' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Ekyrail');

-- ---- Electra ----
UPDATE companies SET description_en = 'French startup in ultra-fast EV charging, more than 400 stations in service in Europe, 100% renewable energy, no subscription.'
WHERE name = 'Electra' AND description_en IS NULL;

UPDATE products SET description_en = 'Electra fast-charging station for electric vehicles, CCS and Type 2 connectors, 100% renewable energy, available 24/7 in cities and on motorways.'
WHERE name = 'Borne de recharge ultra-rapide' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Electra');

-- ---- Elithion ----
UPDATE companies SET description_en = 'US manufacturer founded in 2008 by Davide Andrea, one of the first to offer an off-the-shelf lithium-ion battery management system (BMS), with the Lithiumate range with distributed architecture for large packs.'
WHERE name = 'Elithion' AND description_en IS NULL;

UPDATE products SET description_en = 'Distributed-architecture battery management system (BMS) for large lithium-ion packs, with one measurement and balancing board per cell, compatible with the main chemistries (LiFePO4, NMC, LCO, LMO, NCA) and with prismatic, cylindrical and pouch cells.'
WHERE name = 'Lithiumate — Système de gestion de batterie' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Elithion');

-- ---- ELMECH-ASE ----
UPDATE companies SET description_en = 'Polish power electronics manufacturer since 1987: industrial energy storage, active filters and uninterruptible power supplies.'
WHERE name = 'ELMECH-ASE' AND description_en IS NULL;

UPDATE products SET description_en = 'Uninterruptible power supply and active filtering system to improve power quality at industrial sites.'
WHERE name = 'Onduleur et filtre actif industriel' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ELMECH-ASE');

-- ---- Eltorque ----
UPDATE companies SET description_en = 'Norwegian manufacturer of electric valve actuators for the maritime and naval industry, replacing traditional pneumatic and hydraulic solutions.'
WHERE name = 'Eltorque' AND description_en IS NULL;

UPDATE products SET description_en = 'Intelligent electric actuator for valve control in marine environments, an alternative to pneumatic and hydraulic solutions.'
WHERE name = 'Actionneur électrique de vanne marine' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Eltorque');

-- ---- ENAG ----
UPDATE companies SET description_en = 'French manufacturer of energy conversion equipment for severe environments: modular rail inverters (up to 80 kVA), industrial and defense.'
WHERE name = 'ENAG' AND description_en IS NULL;

UPDATE products SET description_en = 'Modular DC/AC inverter for rail applications, up to 80 kVA, designed for module-level redundancy.'
WHERE name = 'Onduleur modulaire ONS' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ENAG');

-- ---- Engix ----
UPDATE companies SET description_en = 'Irish manufacturer of wireless laser sensors for level monitoring of silos and industrial bulk storage bins.'
WHERE name = 'Engix' AND description_en IS NULL;

UPDATE products SET description_en = 'Wireless laser sensor for monitoring the level of silos, bins and tanks of bulk materials, with AI predictions.'
WHERE name = 'Capteur laser de niveau pour silo' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Engix');

-- ---- EODev ----
UPDATE companies SET description_en = 'French startup spun out of the Energy Observer project, designs hybrid electric generators combining a hydrogen fuel cell and a battery (GEH2), for construction sites, events, marine and microgrids.'
WHERE name = 'EODev' AND description_en IS NULL;

UPDATE products SET description_en = 'EODev hybrid hydrogen electric generator: 70 kW Toyota fuel cell + backup LFP battery, zero emissions at point of use, for construction sites, events, marine and microgrids.'
WHERE name = 'GEH2' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EODev');

-- ---- Eutelsat OneWeb ----
UPDATE companies SET description_en = 'LEO broadband constellation (648 satellites, 1,200 km orbit), operated by the Eutelsat group since the 2023 merger. The satellites are built by Airbus Defence and Space through the OneWeb Satellites joint venture.'
WHERE name = 'Eutelsat OneWeb' AND description_en IS NULL;

UPDATE products SET description_en = 'Satellite of the OneWeb LEO broadband constellation (648 units), built by Airbus Defence and Space through the OneWeb Satellites joint venture. Represents Eutelsat OneWeb''s own fleet, not sold to third parties -- the operator sells connectivity, not the platform itself.'
WHERE name = 'Satellite OneWeb Gen1' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Eutelsat OneWeb');

-- ---- Ewattch ----
UPDATE companies SET description_en = 'French designer of LoRaWAN IoT sensors and a monitoring platform for Industry 4.0 and smart buildings: consumption tracking, electrical sub-metering, ambient sensors.'
WHERE name = 'Ewattch' AND description_en IS NULL;

UPDATE products SET description_en = 'Modular wireless LoRaWAN IoT sensor for industrial performance monitoring: measurement and control, long battery life.'
WHERE name = 'TYNESS Performance' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Ewattch');

-- ---- Ewert Energy Systems ----
UPDATE companies SET description_en = 'US R&D company specializing in battery management systems (BMS) for electric, hybrid and hydrogen vehicles, behind the Orion BMS range widely used in EV/PHEV/HEV conversions and integrations.'
WHERE name = 'Ewert Energy Systems' AND description_en IS NULL;

UPDATE products SET description_en = 'Automotive battery management system (BMS) from the Orion range, designed for protecting and managing lithium-ion packs on electric and hybrid vehicles (EV conversions, PHEV, HEV), with dual CAN interface and OBD2 compatibility.'
WHERE name = 'Orion BMS 2 — Système de gestion de batterie' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Ewert Energy Systems');

-- ---- Exotec ----
UPDATE companies SET description_en = 'French logistics robotics startup (Lille), publisher of the Skypod system (autonomous climbing robots for high-density storage), more than 10,000 robots deployed worldwide, >$1bn revenue in 2024.'
WHERE name = 'Exotec' AND description_en IS NULL;

UPDATE products SET description_en = 'Exotec robotic storage and order-picking system (AS/RS): autonomous climbing robots moving in 3 dimensions on high-density racks.'
WHERE name = 'Skypod System' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Exotec');

-- ---- Expleo France ----
UPDATE companies SET description_en = 'Engineering and technology consulting group born from the merger of Assystem and Altran Technologies, specializing in industrial testing, qualification and quality assurance.'
WHERE name = 'Expleo France' AND description_en IS NULL;

UPDATE products SET description_en = 'Testing, qualification and quality assurance campaigns for aeronautics, automotive and energy, from the test plan to certification.'
WHERE name = 'Essais, qualification et assurance qualité industrielle' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Expleo France');

-- ---- Figeac Aéro ----
UPDATE companies SET description_en = 'French aeronautical subcontractor specializing in machining of structural, engine and precision parts in light alloys and hard metals, and airframe assembly.'
WHERE name = 'Figeac Aéro' AND description_en IS NULL;

UPDATE products SET description_en = 'Machining of structural and engine parts in light alloys and hard metals, and airframe assembly for civil and military programs.'
WHERE name = 'Usinage de pièces structurales aéronautiques' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Figeac Aéro');

-- ---- Firefly Aerospace ----
UPDATE companies SET description_en = 'US light-launch company, Alpha range (all-carbon-fiber structure), also builder of the Blue Ghost lunar lander.'
WHERE name = 'Firefly Aerospace' AND description_en IS NULL;

UPDATE products SET description_en = 'Firefly Aerospace''s US light launch vehicle, all-carbon-composite structure. 4 Reaver engines on the first stage, 1 Lightning engine on the upper stage, RP-1/LOX propellants.'
WHERE name = 'Alpha' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Firefly Aerospace');

-- ---- Fives ----
UPDATE companies SET description_en = 'French industrial group founded in 1812, designing and integrating machines, equipment and turnkey production lines for steel, aluminum, cement, automotive and aeronautics.'
WHERE name = 'Fives' AND description_en IS NULL;

UPDATE products SET description_en = 'Turnkey design, manufacture and integration of machines, process equipment and production lines for heavy industry and manufacturing.'
WHERE name = 'Intégration de lignes de production industrielles' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Fives');

-- ---- GAIA Converter ----
UPDATE companies SET description_en = 'French manufacturer of isolated and non-isolated DC/DC converters, front-end modules and power distribution boards, for the avionics, defense, rail and industrial markets.'
WHERE name = 'GAIA Converter' AND description_en IS NULL;

UPDATE products SET description_en = 'GAIA Converter reference board with multiple configurable outputs, based on COTS modules of the MGDD series. Distributes up to 120W over 3 main channels and 2 auxiliary channels, compliant with military standards Mil-Std-1275/704/461.'
WHERE name = 'GRD-12A' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'GAIA Converter');

-- ---- Galactic Energy ----
UPDATE companies SET description_en = 'Chinese commercial launch company, Ceres-1 range (solid-stage) already operational with more than 20 successful launches, also developing Pallas-1 and Ceres-2.'
WHERE name = 'Galactic Energy' AND description_en IS NULL;

UPDATE products SET description_en = 'Chinese 4-stage light launch vehicle (first 3 stages solid propellant, last stage hydrazine), already more than 20 successful launches.'
WHERE name = 'Ceres-1' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Galactic Energy');

-- ---- GIF Emploi ----
UPDATE companies SET description_en = 'French temporary staffing and recruitment group specializing in engineering, mechanics, electricity and industrial IT, with 19 branches dedicated by specialty.'
WHERE name = 'GIF Emploi' AND description_en IS NULL;

UPDATE products SET description_en = 'Provision of technical staff on temporary, fixed-term and permanent contracts for engineering, mechanics, electricity and industrial IT.'
WHERE name = 'Intérim et recrutement ingénierie/technique' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'GIF Emploi');

-- ---- GISMA Steckverbinder ----
UPDATE companies SET description_en = 'Independent German manufacturer of underwater and industrial circular connectors, a recognized specialist since 1983, with its own production in Neumünster.'
WHERE name = 'GISMA Steckverbinder' AND description_en IS NULL;

UPDATE products SET description_en = 'Sealed circular connector for underwater and industrial applications, designed and manufactured in Germany.'
WHERE name = 'Connecteur circulaire sous-marin' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'GISMA Steckverbinder');

-- ---- Glass-Link ----
UPDATE companies SET description_en = 'Irish manufacturer of long-range IIoT connectivity nodes and gateways for demanding industrial and maritime environments.'
WHERE name = 'Glass-Link' AND description_en IS NULL;

UPDATE products SET description_en = 'Long-range IIoT connectivity node and gateway for real-time data transmission in demanding industrial environments.'
WHERE name = 'Nœud de connectivité IIoT longue portée' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Glass-Link');

-- ---- GPV ----
UPDATE companies SET description_en = 'Danish electronics contract manufacturing (EMS) group, specializing in wiring harnesses, mechatronics and box-build, with production sites in 12 countries.'
WHERE name = 'GPV' AND description_en IS NULL;

UPDATE products SET description_en = 'Design and manufacture of custom wiring harnesses for demanding industrial applications, integrated into complete mechatronic or box-build solutions.'
WHERE name = 'Harnais de câblage sur mesure' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'GPV');

-- ---- Groundcom ----
UPDATE companies SET description_en = 'Czech startup providing affordable ground segment infrastructure (antennas and associated equipment) for small-satellite constellations in low Earth orbit.'
WHERE name = 'Groundcom' AND description_en IS NULL;

UPDATE products SET description_en = 'Shared ground station antenna and equipment, for controlling and receiving data from small-satellite constellations in low Earth orbit.'
WHERE name = 'Antenne de station sol partagée' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Groundcom');

-- ---- Groupe REEL ----
UPDATE companies SET description_en = 'French family-owned, independent industrial group, designing, manufacturing and integrating complex lifting and handling systems for aeronautics, energy (nuclear, hydroelectric), aluminum and naval.'
WHERE name = 'Groupe REEL' AND description_en IS NULL;

UPDATE products SET description_en = 'Design, manufacture and integration of complex lifting and handling systems for aeronautics, energy, aluminum and naval.'
WHERE name = 'Intégration de systèmes de levage et manutention' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Groupe REEL');

-- ---- Hedon Technologies ----
UPDATE companies SET description_en = 'French engineering, IT and operational performance consulting firm, supporting SMEs and large industrial accounts with time-and-materials or fixed-price teams.'
WHERE name = 'Hedon Technologies' AND description_en IS NULL;

UPDATE products SET description_en = 'Technical assistance, engineering consulting and operational performance for SMEs and large industrial accounts, covering digital/IT, engineering and operations.'
WHERE name = 'Conseil en ingénierie et performance opérationnelle' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Hedon Technologies');

-- ---- Hensoldt Nexeya France ----
UPDATE companies SET description_en = 'French subsidiary of the German Hensoldt group (formerly Nexeya): design and integration of critical electronic systems, mission management, testing/simulation and power conversion for defense.'
WHERE name = 'Hensoldt Nexeya France' AND description_en IS NULL;

UPDATE products SET description_en = 'Design and integration of critical electronic systems: mission management, testing/simulation and power conversion for defense.'
WHERE name = 'Systèmes électroniques critiques et intégration' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Hensoldt Nexeya France');

-- ---- Institut de Soudure ----
UPDATE companies SET description_en = 'French reference body in welding: materials testing, non-destructive testing and internationally recognized qualifications (ISO 9606, ISO 9712, ISO 3834, EN 1090).'
WHERE name = 'Institut de Soudure' AND description_en IS NULL;

UPDATE products SET description_en = 'Mechanical, metallographic and corrosion testing, non-destructive testing and internationally recognized welding qualifications.'
WHERE name = 'Essais matériaux et qualification soudage' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Institut de Soudure');

-- ---- Instrumia ----
UPDATE companies SET description_en = 'French specialist in industrial instrumentation: sensors and measuring instruments, with support for users, specifiers and installers.'
WHERE name = 'Instrumia' AND description_en IS NULL;

UPDATE products SET description_en = 'Range of industrial sensors and measuring instruments, with dedicated support for users, specifiers and installers.'
WHERE name = 'Capteur de mesure industriel' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Instrumia');

-- ---- Isar Aerospace ----
UPDATE companies SET description_en = 'German light-launch company, Spectrum range, designed for deploying satellite constellations, Aquila propane/LOX engines.'
WHERE name = 'Isar Aerospace' AND description_en IS NULL;

UPDATE products SET description_en = 'Isar Aerospace''s German light launch vehicle, designed for constellation deployment. 9 Aquila engines (propane/LOX) on the first stage, 1 vacuum-optimized Aquila engine on the upper stage with multiple-restart capability.'
WHERE name = 'Spectrum' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Isar Aerospace');

-- ---- KickMaker ----
UPDATE companies SET description_en = 'French engineering and industrialization agency for high-tech products, supporting startups, SMEs and large groups from prototype to series production (connected objects, robotics, medical devices).'
WHERE name = 'KickMaker' AND description_en IS NULL;

UPDATE products SET description_en = 'Design, prototyping and industrialization of connected high-tech products, from concept to series production, with a network of industrial partners in Europe and Asia.'
WHERE name = 'Développement et industrialisation de produits connectés' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'KickMaker');

-- Contrôle : produits de ces entreprises encore sans description anglaise (doit être 0).
SELECT c.name AS entreprise, count(*) FILTER (WHERE p.description_en IS NULL) AS sans_anglais, count(*) AS total
FROM companies c LEFT JOIN products p ON p.company_id = c.id
WHERE c.name IN ('BYD', 'CAEN ELS', 'Cailabs', 'Carbios', 'Cavok Engineering', 'CDETECH', 'CETIM', 'Cicor', 'CRIT', 'CT Ingénierie', 'Delair', 'Disruptive Technologies', 'DualSun', 'E-Space', 'Ekium', 'Ekyrail', 'Electra', 'Elithion', 'ELMECH-ASE', 'Eltorque', 'ENAG', 'Engix', 'EODev', 'Eutelsat OneWeb', 'Ewattch', 'Ewert Energy Systems', 'Exotec', 'Expleo France', 'Figeac Aéro', 'Firefly Aerospace', 'Fives', 'GAIA Converter', 'Galactic Energy', 'GIF Emploi', 'GISMA Steckverbinder', 'Glass-Link', 'GPV', 'Groundcom', 'Groupe REEL', 'Hedon Technologies', 'Hensoldt Nexeya France', 'Institut de Soudure', 'Instrumia', 'Isar Aerospace', 'KickMaker')
GROUP BY c.name ORDER BY c.name;
