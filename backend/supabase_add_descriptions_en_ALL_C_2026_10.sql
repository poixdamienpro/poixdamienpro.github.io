-- ============================================================
-- Descriptions anglaises — fichier regroupé C (lots 9 à 11), 2026-10
-- À exécuter d'un seul coup dans l'éditeur SQL de Supabase.
-- Sûr à relancer : ne remplit que les champs encore vides (IS NULL).
-- Les fichiers regroupés A, B, C couvrent les 11 lots, dans cet ordre.
-- ============================================================

-- ######## Lot 9 ########
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

-- ######## Lot 10 ########
-- ---- Kinéis ----
UPDATE companies SET description_en = 'French startup (Toulouse), operator of the first European constellation dedicated to IoT (25 nanosatellites), global connectivity for connected objects and ship tracking (AIS).'
WHERE name = 'Kinéis' AND description_en IS NULL;

UPDATE products SET description_en = '30 kg-class nanosatellite of the Kineis constellation (25 units, 5 orbital planes at 650 km), integrating IoT connectivity and AIS ship tracking, supported by 20 ground stations worldwide.'
WHERE name = 'Nanosatellite Kinéis' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Kinéis');

-- ---- KP Labs ----
UPDATE companies SET description_en = 'Polish manufacturer of AI-driven onboard computers and data processing units (DPUs) for small satellites (CubeSat-oriented). They also offer engineering services in thermal, FPGA development, electronic design, mission analysis and system analysis.'
WHERE name = 'KP Labs' AND description_en IS NULL;

UPDATE products SET description_en = 'Computing unit for small satellites that can serve as an onboard computer or an onboard data processing unit, with AI algorithms.'
WHERE name = 'Antelope — unité de traitement de données / OBC' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'KP Labs');

-- ---- LandSpace ----
UPDATE companies SET description_en = 'Chinese commercial launch company, the first in the world to put a methane-oxygen rocket into orbit (Zhuque-2).'
WHERE name = 'LandSpace' AND description_en IS NULL;

UPDATE products SET description_en = 'The world''s first launch vehicle powered by liquid methane-oxygen (methalox) to reach orbit. 4 TQ-12 engines on the first stage, 1 vacuum-optimized TQ-12 engine on the upper stage.'
WHERE name = 'Zhuque-2' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'LandSpace');

-- ---- Latelec ----
UPDATE companies SET description_en = 'Subsidiary of the Latécoère group specializing in the study, design and manufacture of electrical and electronic harnesses and interconnection systems for aeronautics and space.'
WHERE name = 'Latelec' AND description_en IS NULL;

UPDATE products SET description_en = 'Study, design, manufacture and maintenance of electrical/electronic harnesses and interconnection systems for aeronautics and space.'
WHERE name = 'Fabrication de faisceaux et interconnexion aéronautique' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Latelec');

-- ---- Lhyfe ----
UPDATE companies SET description_en = 'French startup, a pioneer in green hydrogen production by electrolysis from renewable electricity, with several production sites in France and Europe.'
WHERE name = 'Lhyfe' AND description_en IS NULL;

UPDATE products SET description_en = 'Lhyfe green hydrogen production site by electrolysis (e.g. Le Cheylas), powered by renewable electricity, RFNBO-certified.'
WHERE name = 'Site de production d''hydrogène vert' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Lhyfe');

-- ---- Lithium Balance ----
UPDATE companies SET description_en = 'Danish manufacturer of battery management systems (BMS) for lithium-ion batteries, spun out of the Danish Technological Institute.'
WHERE name = 'Lithium Balance' AND description_en IS NULL;

UPDATE products SET description_en = 'Battery management system (BMS) for lithium-ion packs, developed for a wide range of industrial and mobile applications.'
WHERE name = 'BMS pour batteries lithium-ion' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Lithium Balance');

-- ---- Lockheed Martin Space ----
UPDATE companies SET description_en = 'Lockheed Martin''s space division, a major platform maker of military and commercial geostationary satellites (LM 2100 range, evolution of the historic A2100 bus).'
WHERE name = 'Lockheed Martin Space' AND description_en IS NULL;

UPDATE products SET description_en = 'Lockheed Martin geostationary platform, a modernized version of the A2100 bus (Hall-effect thrusters, multi-mission solar array), for military and commercial missions.'
WHERE name = 'LM 2100' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Lockheed Martin Space');

-- ---- Loft Orbital ----
UPDATE companies SET description_en = 'US space infrastructure operator: standardized satellite platform (Longbow) fitted with a universal payload adapter ("Hub"), allowing several customers to fly their payload without developing their own satellite.'
WHERE name = 'Loft Orbital' AND description_en IS NULL;

UPDATE products SET description_en = 'Loft Orbital standardized satellite platform fitted with the "Hub", a universal payload adapter allowing several customers to fly a payload without developing their own satellite or customizing the bus.'
WHERE name = 'Longbow (plateforme YAM)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Loft Orbital');

-- ---- MaiaSpace ----
UPDATE companies SET description_en = 'ArianeGroup subsidiary, Europe''s first reusable and eco-responsible launch vehicle (Agile method), Prometheus bio-methane/LOX engines developed for ESA.'
WHERE name = 'MaiaSpace' AND description_en IS NULL;

UPDATE products SET description_en = 'Europe''s first reusable micro-launcher (MaiaSpace, ArianeGroup subsidiary), vertical landing of the first stage on a sea barge. Prometheus engines (bio-methane/LOX, developed for ESA).'
WHERE name = 'Maia' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'MaiaSpace');

-- ---- Manpower France (Engineering) ----
UPDATE companies SET description_en = 'Engineering division of Manpower France: recruitment and temporary staffing of technical and industrial profiles, on permanent, fixed-term, temporary or interim management contracts.'
WHERE name = 'Manpower France (Engineering)' AND description_en IS NULL;

UPDATE products SET description_en = 'Recruitment and temporary staffing of technical and industrial profiles, on permanent, fixed-term, temporary or interim management contracts.'
WHERE name = 'Intérim et recrutement ingénierie' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Manpower France (Engineering)');

-- ---- Mapsi Photonics ----
UPDATE companies SET description_en = 'Spanish spin-off of the Polytechnic University of Catalonia, manufacturer of infrared optical components for industrial and sensing applications.'
WHERE name = 'Mapsi Photonics' AND description_en IS NULL;

UPDATE products SET description_en = 'Infrared optical component for industrial sensing and air-quality applications, born from nanotechnology research.'
WHERE name = 'Composant optique infrarouge industriel' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Mapsi Photonics');

-- ---- Maxar ----
UPDATE companies SET description_en = 'Historic US platform maker, known for its 1300 range of geostationary buses (more than 90 in orbit since 1989) and its high-resolution Earth observation satellites.'
WHERE name = 'Maxar' AND description_en IS NULL;

UPDATE products SET description_en = 'Maxar modular geostationary platform (telecommunications and Earth observation), more than 90 satellites in orbit since 1989, panel-based construction making mission adaptation easier.'
WHERE name = 'Maxar 1300' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Maxar');

-- ---- McPhy Energy ----
UPDATE companies SET description_en = 'French manufacturer of equipment for producing and distributing decarbonized hydrogen (McLyzer electrolyzers, distribution stations), for industry and mobility.'
WHERE name = 'McPhy Energy' AND description_en IS NULL;

UPDATE products SET description_en = 'McPhy range of high-pressure alkaline electrolyzers, for industrial-scale decarbonized hydrogen production, with possible coupling to renewable energy.'
WHERE name = 'McLyzer' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'McPhy Energy');

-- ---- MEB Group ----
UPDATE companies SET description_en = 'Polish-German group specializing in renewable energy, energy storage and electric mobility infrastructure.'
WHERE name = 'MEB Group' AND description_en IS NULL;

UPDATE products SET description_en = 'Energy storage and electric mobility infrastructure solutions for renewable energy projects.'
WHERE name = 'Système de stockage et infrastructure e-mobilité' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'MEB Group');

-- ---- Meca-Inox ----
UPDATE companies SET description_en = 'French designer and manufacturer of high-performance stainless-steel ball valves, for the chemical, gas, food processing and cryogenic industries. ISO 9001 certified.'
WHERE name = 'Meca-Inox' AND description_en IS NULL;

UPDATE products SET description_en = 'Stainless-steel industrial valve, designed for chemical, gas, food processing and cryogenic applications. French manufacturing, ISO 9001 certified.'
WHERE name = 'Vanne à tournant sphérique inox' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Meca-Inox');

-- ---- Mecachrome ----
UPDATE companies SET description_en = 'French industrial group founded in 1937, specializing in precision machining and assembly of mechanical parts for airframe structures, aircraft engines and motorsport.'
WHERE name = 'Mecachrome' AND description_en IS NULL;

UPDATE products SET description_en = 'Precision machining and assembly of mechanical parts for airframe structures, aircraft engines and motorsport.'
WHERE name = 'Usinage de précision et assemblage aéronautique' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Mecachrome');

-- ---- Microtec ----
UPDATE companies SET description_en = 'French SME in high-precision mechanics and machining for the aeronautics, space and medical sectors: design, prototyping, 5-axis machining, screw machining and grinding.'
WHERE name = 'Microtec' AND description_en IS NULL;

UPDATE products SET description_en = 'High-precision design, prototyping, 5-axis machining, screw machining and grinding for aeronautics, space and medical.'
WHERE name = 'Usinage de précision 5 axes' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Microtec');

-- ---- Millennium Space Systems ----
UPDATE companies SET description_en = 'Boeing subsidiary specializing in quick-to-produce satellite buses (ALTAIR range), for national security constellations and NASA science missions.'
WHERE name = 'Millennium Space Systems' AND description_en IS NULL;

UPDATE products SET description_en = 'Millennium Space Systems (Boeing subsidiary) satellite bus, flight-heritage avionics/GNC (TRL9), used for national security constellations and NASA science missions (e.g. TRACERS).'
WHERE name = 'ALTAIR' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Millennium Space Systems');

-- ---- Mitsubishi Heavy Industries (Espace) ----
UPDATE companies SET description_en = 'Space division of the Japanese conglomerate MHI, prime contractor of the H3 launch vehicle for JAXA, launched from the Tanegashima Space Center.'
WHERE name = 'Mitsubishi Heavy Industries (Espace)' AND description_en IS NULL;

UPDATE products SET description_en = 'MHI''s Japanese launch vehicle for JAXA, available in several configurations (number of main LE-9 engines and SRB-3 strap-on boosters). Launched from Tanegashima.'
WHERE name = 'H3' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Mitsubishi Heavy Industries (Espace)');

-- ---- NAWA Technologies ----
UPDATE companies SET description_en = 'French startup developing vertically aligned carbon nanotube (VACNT) electrodes, for ultra-fast charging/discharging hybrid batteries with a very long life.'
WHERE name = 'NAWA Technologies' AND description_en IS NULL;

UPDATE products SET description_en = 'NAWA Technologies electrode based on vertically aligned carbon nanotubes (VACNT), for hybrid batteries that charge/discharge in seconds.'
WHERE name = 'Ultra-Fast Carbon Battery' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'NAWA Technologies');

-- ---- Nordic Batteries ----
UPDATE companies SET description_en = 'Norwegian manufacturer of high-power battery modules and packs for industrial, marine, defense and power grid applications.'
WHERE name = 'Nordic Batteries' AND description_en IS NULL;

UPDATE products SET description_en = 'High-power battery module for industrial, marine, defense and power grid applications.'
WHERE name = 'Module batterie haute puissance' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Nordic Batteries');

-- ---- Northrop Grumman Space ----
UPDATE companies SET description_en = 'Northrop Grumman''s space division, geostationary platform maker with the GEOStar bus family, initially focused on small geostationary telecommunications satellites.'
WHERE name = 'Northrop Grumman Space' AND description_en IS NULL;

UPDATE products SET description_en = 'Latest generation of Northrop Grumman''s GEOStar geostationary platform family, for telecommunications missions with a heritage 36V regulated power bus.'
WHERE name = 'GEOStar-3' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Northrop Grumman Space');

-- ---- Nuvation Energy ----
UPDATE companies SET description_en = 'US manufacturer founded in 1997, specializing in battery management systems (BMS) and control electronics for large-scale energy storage, supplier to storage system integrators and battery manufacturers.'
WHERE name = 'Nuvation Energy' AND description_en IS NULL;

UPDATE products SET description_en = 'Low-voltage battery management system (BMS) managing up to 16 cells in series (up to 60 V DC), with contactor control and communication with the energy storage controller, intended for stationary storage systems.'
WHERE name = 'NUV300 — BMS basse tension' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Nuvation Energy');

-- ---- OHB System ----
UPDATE companies SET description_en = 'German platform maker of the OHB SE group, known for its modular SmallGEO geostationary platform (marketed as Luxor), developed under the ESA ARTES-11 program.'
WHERE name = 'OHB System' AND description_en IS NULL;

UPDATE products SET description_en = 'OHB modular geostationary platform, developed under the ESA ARTES-11 program, for telecommunications, Earth observation and in-orbit technology demonstration. Choice of conventional, hybrid or all-electric propulsion.'
WHERE name = 'SmallGEO (Luxor)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'OHB System');

-- ---- OMAL ----
UPDATE companies SET description_en = 'Italian manufacturer of industrial valves and pneumatic and electric actuators for fluid control, since 1981.'
WHERE name = 'OMAL' AND description_en IS NULL;

UPDATE products SET description_en = 'Industrial valve combined with an electric or pneumatic actuator, for fluid control in demanding industrial environments.'
WHERE name = 'Actionneur électrique et vanne process' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'OMAL');

-- ---- OME Motors ----
UPDATE companies SET description_en = 'Italian manufacturer of custom industrial electric motors, distributed internationally.'
WHERE name = 'OME Motors' AND description_en IS NULL;

UPDATE products SET description_en = 'Industrial electric motor designed to order according to the customer''s specification, distributed internationally.'
WHERE name = 'Moteur électrique industriel sur mesure' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'OME Motors');

-- ---- Pasqal ----
UPDATE companies SET description_en = 'French quantum computing startup (Massy), developing neutral-atom quantum processors (Orion range), with on-site deployments at GENCI/TGCC, Jülich, CINECA and Aramco.'
WHERE name = 'Pasqal' AND description_en IS NULL;

UPDATE products SET description_en = 'Pasqal neutral-atom (rubidium-87) quantum processor, programmable optical traps, analog and digital modes, data-center integration without cryogenics.'
WHERE name = 'Orion' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Pasqal');

-- ---- PLD Space ----
UPDATE companies SET description_en = 'Spanish launch company, Miura range (Miura 1 suborbital already flown, Miura 5 orbital under development with a first stage recoverable by parachutes).'
WHERE name = 'PLD Space' AND description_en IS NULL;

UPDATE products SET description_en = 'Spanish 2-3 stage light launch vehicle, 5 TEPREL-C engines (RP-1/LOX) on the first stage, first-stage recovery by parachutes planned.'
WHERE name = 'Miura 5' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'PLD Space');

-- ---- Power Innovation Stromversorgungstechnik ----
UPDATE companies SET description_en = 'German manufacturer of industrial inverters and switch-mode power supplies, with custom developments for specific applications.'
WHERE name = 'Power Innovation Stromversorgungstechnik' AND description_en IS NULL;

UPDATE products SET description_en = 'Industrial inverter and switch-mode power supply developed to order for the customer''s specific applications.'
WHERE name = 'Onduleur industriel sur mesure' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Power Innovation Stromversorgungstechnik');

-- ---- PrimaLuceLab ----
UPDATE companies SET description_en = 'Italian manufacturer of ground station equipment and robotic systems for astronomy and space exploration, through its PrimaLuceSpace division.'
WHERE name = 'PrimaLuceLab' AND description_en IS NULL;

UPDATE products SET description_en = 'Robotic ground station system for tracking and observation, including mount, control and software integration.'
WHERE name = 'Station sol robotisée' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'PrimaLuceLab');

-- ---- Prysmian ----
UPDATE companies SET description_en = 'Global Italian cable and electrical distribution systems group, including a range dedicated to automotive wiring harnesses for combustion, hybrid and electric vehicles.'
WHERE name = 'Prysmian' AND description_en IS NULL;

UPDATE products SET description_en = 'Wiring harnesses and assemblies for engines/powertrains, transmissions, fuel systems and hybrid/electric vehicles. Copper or aluminum conductors, temperature ranges from 85°C to 200°C.'
WHERE name = 'Harnais de câblage automobile & VE' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Prysmian');

-- ---- Q-tronic ----
UPDATE companies SET description_en = 'Dutch integrator of electric powertrain systems for more than 40 years, with a dedicated range of power distribution units (PDUs).'
WHERE name = 'Q-tronic' AND description_en IS NULL;

UPDATE products SET description_en = 'Power distribution unit for electric powertrains, integrated into custom powertrain solutions.'
WHERE name = 'Unité de distribution de puissance véhicule électrique' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Q-tronic');

-- ---- REC BMS ----
UPDATE companies SET description_en = 'Slovenian manufacturer (REC d.o.o.), founded in 2011, of battery management systems (BMS) for lithium-ion packs, with a range natively integrating CAN communication and compatibility with the main energy storage inverters (Victron Energy, SMA Sunny Island, Studer Innotec, Pylontech, etc.).'
WHERE name = 'REC BMS' AND description_en IS NULL;

UPDATE products SET description_en = 'Battery management system (BMS) for lithium-ion packs of 5 to 16 cells in series, with built-in CAN communication and native compatibility with eight energy storage inverter protocols (Victron Energy, SMA Sunny Island, Studer Innotec, Pylontech, among others), intended for stationary and mobile storage applications.'
WHERE name = 'REC Q BMS 16S — Système de gestion de batterie' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'REC BMS');

-- ---- Relativity Space ----
UPDATE companies SET description_en = 'US launch company, a pioneer in additive manufacturing (3D printing) of rockets, developing Terran R, a fully reusable medium/heavy launch vehicle.'
WHERE name = 'Relativity Space' AND description_en IS NULL;

UPDATE products SET description_en = 'Relativity Space''s fully reusable medium/heavy launch vehicle, built by 3D printing. 13 Aeon R engines (methane/LOX) on the first stage, designed for up to 20 flights.'
WHERE name = 'Terran R' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Relativity Space');

-- ---- Renault Group ----
UPDATE companies SET description_en = 'French carmaker, platform maker of the new compact electric range (Renault 5 E-Tech, AmpR Small platform), alongside the Dacia and Alpine brands.'
WHERE name = 'Renault Group' AND description_en IS NULL;

UPDATE products SET description_en = 'Renault electric city car on the new AmpR Small platform, available in several battery configurations (LFP or NMC).'
WHERE name = 'Renault 5 E-Tech' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Renault Group');

-- ---- Rivian ----
UPDATE companies SET description_en = 'US maker of native electric vehicles (R1T pickup, R1S SUV), with several battery and powertrain configurations (up to 4 motors).'
WHERE name = 'Rivian' AND description_en IS NULL;

UPDATE products SET description_en = 'Rivian electric pickup, several battery sizes and motor configurations (dual to quad motor).'
WHERE name = 'R1T' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Rivian');

-- ---- Rocket Factory Augsburg ----
UPDATE companies SET description_en = 'German launch company (subsidiary of the OHB SE group), RFA One 3-stage range for the light segment, in-house Helix engines (RP-1/LOX).'
WHERE name = 'Rocket Factory Augsburg' AND description_en IS NULL;

UPDATE products SET description_en = 'German 3-stage light launch vehicle, 9 Helix engines (RP-1/LOX, staged combustion cycle) on the first stage.'
WHERE name = 'RFA One' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Rocket Factory Augsburg');

-- ---- S-INDUSTRIES ----
UPDATE companies SET description_en = 'French manufacturer of wiring harnesses in small, medium and large series, with a production site in Normandy and a second in Tunisia.'
WHERE name = 'S-INDUSTRIES' AND description_en IS NULL;

UPDATE products SET description_en = 'Industrialization and manufacture of wiring harnesses in small, medium and large series, at French and Tunisian sites.'
WHERE name = 'Fabrication de faisceaux électriques en série' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'S-INDUSTRIES');

-- ---- Saab Seaeye ----
UPDATE companies SET description_en = 'World leader in electric underwater robotics, designer of ROV vehicles and electric components (manipulators, thrusters) intended for integration into complex underwater systems.'
WHERE name = 'Saab Seaeye' AND description_en IS NULL;

UPDATE products SET description_en = 'Seven-function electric manipulator intended for integration on work-class ROVs. Modular electric joints enabling precise arm control, path planning and built-in diagnostics.'
WHERE name = 'Seaeye eM1-7' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Saab Seaeye');

-- ---- Safran.AI (ex-Preligens) ----
UPDATE companies SET description_en = 'French AI startup for defense imagery (formerly Earthcube, then Preligens), acquired and renamed Safran.AI by Safran in September 2024. "AI Factory" for automatic analysis of satellite images, video and acoustic signals.'
WHERE name = 'Safran.AI (ex-Preligens)' AND description_en IS NULL;

UPDATE products SET description_en = 'Software for monitoring sites of military interest through very-high-resolution (VHR) satellite imagery, with automatic alerts on unusual activity patterns, based on Safran.AI''s AI Factory.'
WHERE name = 'Strategic Site Monitoring' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Safran.AI (ex-Preligens)');

-- ######## Lot 11 ########
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

-- Contrôle : ce qu'il reste à traduire (descriptions vides) dans toute la base.
SELECT
  (SELECT count(*) FROM products  WHERE description_en IS NULL OR trim(description_en) = '') AS produits_sans_anglais,
  (SELECT count(*) FROM companies WHERE description_en IS NULL OR trim(description_en) = '') AS entreprises_sans_anglais;
