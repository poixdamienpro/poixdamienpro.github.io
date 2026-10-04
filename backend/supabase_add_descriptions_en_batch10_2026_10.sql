-- ============================================================
-- Traductions anglaises (description_en) — lot « batch10 », 2026-10
-- Entreprises : Kinéis, KP Labs, LandSpace, Latelec, Lhyfe, Lithium Balance, Lockheed Martin Space, Loft Orbital, MaiaSpace, Manpower France (Engineering), Mapsi Photonics, Maxar, McPhy Energy, MEB Group, Meca-Inox, Mecachrome, Microtec, Millennium Space Systems, Mitsubishi Heavy Industries (Espace), NAWA Technologies, Nordic Batteries, Northrop Grumman Space, Nuvation Energy, OHB System, OMAL, OME Motors, Pasqal, PLD Space, Power Innovation Stromversorgungstechnik, PrimaLuceLab, Prysmian, Q-tronic, REC BMS, Relativity Space, Renault Group, Rivian, Rocket Factory Augsburg, S-INDUSTRIES, Saab Seaeye, Safran.AI (ex-Preligens)
--
-- Sûr à relancer : ne remplit que les champs encore vides (IS NULL).
-- ============================================================

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

-- Contrôle : produits de ces entreprises encore sans description anglaise (doit être 0).
SELECT c.name AS entreprise, count(*) FILTER (WHERE p.description_en IS NULL) AS sans_anglais, count(*) AS total
FROM companies c LEFT JOIN products p ON p.company_id = c.id
WHERE c.name IN ('Kinéis', 'KP Labs', 'LandSpace', 'Latelec', 'Lhyfe', 'Lithium Balance', 'Lockheed Martin Space', 'Loft Orbital', 'MaiaSpace', 'Manpower France (Engineering)', 'Mapsi Photonics', 'Maxar', 'McPhy Energy', 'MEB Group', 'Meca-Inox', 'Mecachrome', 'Microtec', 'Millennium Space Systems', 'Mitsubishi Heavy Industries (Espace)', 'NAWA Technologies', 'Nordic Batteries', 'Northrop Grumman Space', 'Nuvation Energy', 'OHB System', 'OMAL', 'OME Motors', 'Pasqal', 'PLD Space', 'Power Innovation Stromversorgungstechnik', 'PrimaLuceLab', 'Prysmian', 'Q-tronic', 'REC BMS', 'Relativity Space', 'Renault Group', 'Rivian', 'Rocket Factory Augsburg', 'S-INDUSTRIES', 'Saab Seaeye', 'Safran.AI (ex-Preligens)')
GROUP BY c.name ORDER BY c.name;
