-- ============================================================
-- Traductions anglaises (description_en) — lot « batch8 », 2026-10
-- Entreprises : Solar MEMS Technologies, SPACEMANIC, Syrlinks, Turntide Technologies, TYVA Energie, U-Space, Valeo, Verkor, XP Power, A2P Connectique, Actual Group, Additive Drives, AddUp, Advanced Cooling Technologies (ACT), Agnikul Cosmos, AKETYS, Akkodis France, AKROMECA, Alseamar, Alten, Apave, ArianeGroup, ARQUIMEA, Assystem, Astranis, Astroscale, Automotive Cells Company (ACC), Avio, AVNIR Engineering, Axis Électronique, Balyo, Batconnect, Blue Canyon Technologies, Blue Origin, BMA (Boussac Montier Automatisme), BMW Group, Boeing Satellite Systems, Bright Ascension, BTRY, Bureau Veritas
--
-- Sûr à relancer : ne remplit que les champs encore vides (IS NULL).
-- ============================================================

-- ---- Solar MEMS Technologies ----
UPDATE companies SET description_en = 'Spanish specialist in miniaturized sun sensors and star trackers for small satellites, based on MEMS technology.'
WHERE name = 'Solar MEMS Technologies' AND description_en IS NULL;

UPDATE products SET description_en = 'High-precision digital fine sun sensor for satellite attitude determination in LEO/MEO/GEO.'
WHERE name = 'FDSS — Fine Digital Sun Sensor' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Solar MEMS Technologies');

UPDATE products SET description_en = 'Miniaturized star tracker designed specifically for the mass and volume constraints of nanosatellites.'
WHERE name = 'MicroST — Star Tracker nanosatellites' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Solar MEMS Technologies');

-- ---- SPACEMANIC ----
UPDATE companies SET description_en = 'Slovak manufacturer of nanosatellite platforms and subsystems, including ultra-compact onboard computers for CubeSats.'
WHERE name = 'SPACEMANIC' AND description_en IS NULL;

UPDATE products SET description_en = 'Advanced nanosatellite platform developed under the ESA Pioneer program, scalable from 1U to 16U to offer more volume, mass and power to the payload.'
WHERE name = 'CORVUS 6U Platform' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'SPACEMANIC');

UPDATE products SET description_en = 'SPACEMANIC ultra-compact onboard computer for CubeSats and nanosatellites, with very low mass and minimal power consumption.'
WHERE name = 'SM-OBC-MSP430' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'SPACEMANIC');

-- ---- Syrlinks ----
UPDATE companies SET description_en = 'French manufacturer of RF radiocommunication equipment for small and medium LEO satellites, and of time-frequency solutions. Subsidiary of Safran Electronics & Defense since 2022.'
WHERE name = 'Syrlinks' AND description_en IS NULL;

UPDATE products SET description_en = 'New-generation Syrlinks S-band transceiver for LEO satellites (mini, micro, CubeSats/nanosatellites), miniaturized low-power design.'
WHERE name = 'EWC31-NG — Émetteur-récepteur bande S' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Syrlinks');

UPDATE products SET description_en = 'Syrlinks low-power micro atomic clock, offering a unique compromise between high time-frequency stability and low power consumption.'
WHERE name = 'MMA — Micro Horloge Atomique' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Syrlinks');

-- ---- Turntide Technologies ----
UPDATE companies SET description_en = 'US manufacturer of software-driven switched reluctance motors, with no rare earths or copper in the rotor, designed to replace AC induction motors in HVAC and industrial applications.'
WHERE name = 'Turntide Technologies' AND description_en IS NULL;

UPDATE products SET description_en = 'Modular axial-flux electric drive unit, integrating motor, inverter and gearbox with shared cooling. Single or dual-stack configurations for commercial vehicles, off-road machinery and hybrid applications.'
WHERE name = 'Axial Flux EDU — Moteur de traction véhicules électriques' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Turntide Technologies');

UPDATE products SET description_en = 'Switched reluctance motor (SRM) with a multi-pole rotor, driven by an onboard, connected software inverter. Designed to replace AC induction motors in air handling units, without rare-earth magnets.'
WHERE name = 'Smart Motor System — Moteur à réluctance commutée' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Turntide Technologies');

-- ---- TYVA Energie ----
UPDATE companies SET description_en = 'Modular lithium batteries without welding. TYVA Refill technology: replaceable cells. 245 Wh/kg.'
WHERE name = 'TYVA Energie' AND description_en IS NULL;

UPDATE products SET description_en = 'Modular 3D assembly without welding. Replaceable cells (TYVA Refill). Rapid prototyping.'
WHERE name = 'Moduloo 3D — Sur-mesure' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'TYVA Energie');

UPDATE products SET description_en = '48V NMC battery in A4+ format, up to 245 Wh/kg. No welding. Made in France.'
WHERE name = 'Moduloo Ax — 48V 30Ah' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'TYVA Energie');

-- ---- U-Space ----
UPDATE companies SET description_en = 'ISAE-SUPAERO spin-off designing and manufacturing modular nanosatellite platforms (10 to 150 kg) for dedicated constellations, with a series production plant (U-Zine) in Toulouse.'
WHERE name = 'U-Space' AND description_en IS NULL;

UPDATE products SET description_en = 'U-Space standardized 12U nanosatellite platform, designed for series production of dedicated constellations.'
WHERE name = '12U Platform' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'U-Space');

UPDATE products SET description_en = 'U-Space "custom" modular microsatellite platform, outside the standard CubeSat format, for missions needing more mass and power.'
WHERE name = 'Free Form Platform' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'U-Space');

-- ---- Valeo ----
UPDATE companies SET description_en = 'Leading French automotive supplier, designer of components for electrification, driver assistance (ADAS) and lighting, integrated by the world''s main manufacturers.'
WHERE name = 'Valeo' AND description_en IS NULL;

UPDATE products SET description_en = 'Belt-driven Integrated Starter-Generator, the central component of Valeo''s 48V mild-hybrid system, to be integrated with a 48V lithium-ion battery and a DC/DC converter to form a complete hybrid powertrain.'
WHERE name = 'Valeo BISG — Démarreur-générateur intégré 48V' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Valeo');

UPDATE products SET description_en = '3D LiDAR laser sensor intended for integration into driver-assistance (ADAS) and autonomous driving systems. The world''s first series-produced automotive LiDAR, fitted notably on the Honda Legend and the Mercedes-Benz S-Class (level 3 autonomy).'
WHERE name = 'Valeo SCALA™ LiDAR' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Valeo');

-- ---- Verkor ----
UPDATE companies SET description_en = 'Low-carbon batteries for premium EVs. Backed by Renault. Dunkirk gigafactory 2025.'
WHERE name = 'Verkor' AND description_en IS NULL;

UPDATE products SET description_en = 'NMC cell manufactured in a low-carbon gigafactory for premium electric vehicles.'
WHERE name = 'Cellule NMC bas-carbone' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Verkor');

UPDATE products SET description_en = 'Complete battery pack for premium EVs, full carbon traceability.'
WHERE name = 'Pack VE 75 kWh bas-carbone' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Verkor');

-- ---- XP Power ----
UPDATE companies SET description_en = 'British manufacturer of power conversion solutions: AC/DC power supplies, DC/DC converters and high-voltage solutions, for industrial, medical, rail and defense/avionics applications.'
WHERE name = 'XP Power' AND description_en IS NULL;

UPDATE products SET description_en = 'XP Power ultra-compact 40W DC/DC converter, intended for integration into industrial, rail and defense/avionics equipment requiring onboard power conversion.'
WHERE name = 'BCT40 Series' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'XP Power');

UPDATE products SET description_en = 'XP Power fully digital, intelligent, configurable AC/DC power supply in 1U format, designed to be integrated into industrial racks and power distribution systems.'
WHERE name = 'FLXPro Series' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'XP Power');

-- ---- A2P Connectique ----
UPDATE companies SET description_en = 'French manufacturer of custom wiring harnesses, industrial cabling, enclosures and mounting plates for various industrial applications.'
WHERE name = 'A2P Connectique' AND description_en IS NULL;

UPDATE products SET description_en = 'Custom wiring harnesses, industrial cabling, enclosures and mounting plates for various industrial applications.'
WHERE name = 'Faisceaux électriques et coffrets sur mesure' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'A2P Connectique');

-- ---- Actual Group ----
UPDATE companies SET description_en = 'French temporary staffing and recruitment group, one of the main players in the sector in France, with a network of more than 600 branches, a significant share of them dedicated to engineering and industry.'
WHERE name = 'Actual Group' AND description_en IS NULL;

UPDATE products SET description_en = 'Provision of technical and industrial staff on temporary, fixed-term and permanent contracts, through a national network of local branches.'
WHERE name = 'Intérim et recrutement technique' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Actual Group');

-- ---- Additive Drives ----
UPDATE companies SET description_en = 'German manufacturer of high-performance electric motors with 3D-printed windings, supplier to Amazon, Airbus, BMW and Audi.'
WHERE name = 'Additive Drives' AND description_en IS NULL;

UPDATE products SET description_en = 'High-performance electric motor with 3D-printed copper/aluminum windings, for high energy efficiency.'
WHERE name = 'Moteur électrique à bobinage imprimé 3D' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Additive Drives');

-- ---- AddUp ----
UPDATE companies SET description_en = 'Michelin / Fives joint venture, French leader in industrial metal additive manufacturing (DED and powder bed fusion technologies), FormUp printer range.'
WHERE name = 'AddUp' AND description_en IS NULL;

UPDATE products SET description_en = 'AddUp industrial metal printer (laser powder bed fusion), 1 or 2 Yb fiber lasers of 500W, for producing complex metal parts (maraging and stainless steels).'
WHERE name = 'FormUp 350' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'AddUp');

-- ---- Advanced Cooling Technologies (ACT) ----
UPDATE companies SET description_en = 'US manufacturer (founded in 2003, Lancaster PA) of thermal solutions: heat pipes, pumped two-phase loops, cooling and thermal storage systems. Operates the largest facility dedicated to manufacturing constant conductance heat pipes (CCHP) for space, under ISO 9001:2015 and AS9100D certification.'
WHERE name = 'Advanced Cooling Technologies (ACT)' AND description_en IS NULL;

UPDATE products SET description_en = 'Aluminum-ammonia constant conductance heat pipes for passive satellite thermal control: transferring heat from electronic equipment to radiators. Made of extruded aluminum with internal grooves (wick), flight-qualified on many NASA and commercial programs.'
WHERE name = 'Constant Conductance Heat Pipes (CCHP)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Advanced Cooling Technologies (ACT)');

-- ---- Agnikul Cosmos ----
UPDATE companies SET description_en = 'Indian private launch company, Agnibaan range powered by the Agnilet engine -- the world''s first single-piece 3D-printed semi-cryogenic engine.'
WHERE name = 'Agnikul Cosmos' AND description_en IS NULL;

UPDATE products SET description_en = 'Indian light launch vehicle fitted with the Agnilet engine, the world''s first single-piece 3D-printed semi-cryogenic engine. Configurable from 30 to 300 kg of payload depending on the mission.'
WHERE name = 'Agnibaan' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Agnikul Cosmos');

-- ---- AKETYS ----
UPDATE companies SET description_en = 'French consulting, study and outsourced R&D firm in aeronautical, automotive and rail engineering, up to turnkey system development.'
WHERE name = 'AKETYS' AND description_en IS NULL;

UPDATE products SET description_en = 'Consulting, study and outsourced R&D services, from concept to turnkey system, for aeronautics, automotive and rail.'
WHERE name = 'Assistance technique et R&D externalisée' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'AKETYS');

-- ---- Akkodis France ----
UPDATE companies SET description_en = 'French engineering and technology consulting brand born from the merger of AKKA Technologies (founded in 1984) and Modis, providing engineering and IT experts to industry.'
WHERE name = 'Akkodis France' AND description_en IS NULL;

UPDATE products SET description_en = 'Product engineering and IT experts on a time-and-materials or fixed-price basis, for aeronautics, automotive, energy and telecoms.'
WHERE name = 'Ingénierie et assistance technique IT/industrie' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Akkodis France');

-- ---- AKROMECA ----
UPDATE companies SET description_en = 'French subcontractor manufacturing precision mechanical parts for industry, construction, energy, defense and aeronautics.'
WHERE name = 'AKROMECA' AND description_en IS NULL;

UPDATE products SET description_en = 'Manufacture of precision mechanical parts for industry, construction, energy, defense and aeronautics.'
WHERE name = 'Fabrication de pièces mécaniques de précision' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'AKROMECA');

-- ---- Alseamar ----
UPDATE companies SET description_en = 'Subsidiary of the ALCEN group (La Ciotat), designs and manufactures autonomous underwater gliders, surface/underwater drones and acoustic positioning systems, for defense, oceanographic research and offshore.'
WHERE name = 'Alseamar' AND description_en IS NULL;

UPDATE products SET description_en = 'Alseamar autonomous underwater glider (AUV), wingless, with silent variable-buoyancy propulsion, no support vessel required during the mission.'
WHERE name = 'SEAEXPLORER' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Alseamar');

-- ---- Alten ----
UPDATE companies SET description_en = 'French engineering and technology consulting group, providing consultants and project teams in product engineering, R&D and IT for all major industrial sectors.'
WHERE name = 'Alten' AND description_en IS NULL;

UPDATE products SET description_en = 'Consultants and project teams in product engineering, R&D and IT, on a time-and-materials or fixed-price basis, for aeronautics, automotive, rail, energy and telecoms.'
WHERE name = 'Ingénierie produit et assistance technique en régie' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Alten');

-- ---- Apave ----
UPDATE companies SET description_en = 'French technical risk management body, active for more than 150 years: inspection, testing, certification, training and consulting for all industrial sectors.'
WHERE name = 'Apave' AND description_en IS NULL;

UPDATE products SET description_en = 'Statutory inspection, laboratory testing and certification for technical risk management, all industrial sectors.'
WHERE name = 'Inspection, essais et certification' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Apave');

-- ---- ArianeGroup ----
UPDATE companies SET description_en = 'Airbus / Safran joint venture, historic European launch company, prime contractor for Ariane 6 on behalf of ESA.'
WHERE name = 'ArianeGroup' AND description_en IS NULL;

UPDATE products SET description_en = 'ArianeGroup European launch vehicle on behalf of ESA, available in A62 (2 boosters) and A64 (4 boosters) versions. Vulcain 2.1 engine on the first stage, Vinci on the upper stage.'
WHERE name = 'Ariane 6' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ArianeGroup');

-- ---- ARQUIMEA ----
UPDATE companies SET description_en = 'Spanish space equipment maker (spin-off from Airbus Defence & Space, founded in 2005). More than 20 years of experience and 180+ missions: structures and thermal systems (heat pipes, loop heat pipes, thermo-structural panels), mechanisms, optics and radiation-hardened microelectronics for telecom, observation, navigation and exploration satellites.'
WHERE name = 'ARQUIMEA' AND description_en IS NULL;

UPDATE products SET description_en = 'Passive two-phase heat transfer devices (capillary-pumped loop) for satellites, insensitive to gravity (allowing full ground testing of the thermal subsystem), with no moving parts or noise. Qualified or fully customized solutions, flown on missions such as Intelsat 19, SpainSat NG and Sentinel-1D.'
WHERE name = 'Loop Heat Pipes (LHP) spatiaux' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ARQUIMEA');

-- ---- Assystem ----
UPDATE companies SET description_en = 'French engineering group specializing in low-carbon energy (nuclear, renewables, power grids) and critical infrastructure.'
WHERE name = 'Assystem' AND description_en IS NULL;

UPDATE products SET description_en = 'Engineering design, project management and technical assistance for nuclear, renewable energy and power grids.'
WHERE name = 'Ingénierie de projets énergie et infrastructures critiques' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Assystem');

-- ---- Astranis ----
UPDATE companies SET description_en = 'US platform maker specializing in miniaturized geostationary satellites (MicroGEO), dedicated to one operator or region, with a proprietary software-defined radio reallocating bandwidth and power in real time.'
WHERE name = 'Astranis' AND description_en IS NULL;

UPDATE products SET description_en = 'Astranis miniaturized geostationary satellite, dedicated to one operator or region (Ka-band), with a proprietary software-defined radio reallocating bandwidth and power in real time. Electric propulsion.'
WHERE name = 'MicroGEO' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Astranis');

-- ---- Astroscale ----
UPDATE companies SET description_en = 'Japanese operator specializing in in-orbit services: space debris removal and satellite end-of-life, using servicer spacecraft capable of rendezvous and capture (magnetic or robotic) of another vehicle.'
WHERE name = 'Astroscale' AND description_en IS NULL;

UPDATE products SET description_en = 'Astroscale servicer spacecraft capable of rendezvous and magnetic capture of another spacecraft, a demonstrator of end-of-life and debris removal services.'
WHERE name = 'ELSA-d' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Astroscale');

-- ---- Automotive Cells Company (ACC) ----
UPDATE companies SET description_en = 'Stellantis / Mercedes-Benz / TotalEnergies (Saft) joint venture, manufacturer of NMC battery cells for electric vehicles. First gigafactory in Billy-Berclau-Douvrin, industrial center of excellence in Nersac.'
WHERE name = 'Automotive Cells Company (ACC)' AND description_en IS NULL;

UPDATE products SET description_en = 'NMC battery cell mass-produced at the ACC gigafactory in Billy-Berclau-Douvrin, for electric vehicles of the Stellantis and Mercedes-Benz brands.'
WHERE name = 'Cellule NMC — Gigafactory' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Automotive Cells Company (ACC)');

-- ---- Avio ----
UPDATE companies SET description_en = 'Italian launch company, prime contractor of the European light launch vehicle Vega C on behalf of ESA.'
WHERE name = 'Avio' AND description_en IS NULL;

UPDATE products SET description_en = 'Avio European light launch vehicle on behalf of ESA, 4 stages, 3.3 m diameter fairing doubling the payload volume compared to Vega.'
WHERE name = 'Vega C' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Avio');

-- ---- AVNIR Engineering ----
UPDATE companies SET description_en = 'French vibration testing and qualification laboratory according to RTCA DO-160 (aeronautics), MIL-STD-810 (defense) and ECSS (space) standards.'
WHERE name = 'AVNIR Engineering' AND description_en IS NULL;

UPDATE products SET description_en = 'Vibration testing and qualification campaigns (sine, random, shock, modal analysis) according to RTCA DO-160, MIL-STD-810 and ECSS.'
WHERE name = 'Essais vibratoires et qualification DO-160/ECSS' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'AVNIR Engineering');

-- ---- Axis Électronique ----
UPDATE companies SET description_en = 'French electronics contract manufacturer (EMS) assembling SMT and THT boards from one-off prototypes to series production, for defense, energy/nuclear, medical and industrial robotics.'
WHERE name = 'Axis Électronique' AND description_en IS NULL;

UPDATE products SET description_en = 'Assembly of SMT and THT boards from one-off prototypes to series production, for defense, energy/nuclear, medical and robotics.'
WHERE name = 'Assemblage de cartes électroniques CMS/THT' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Axis Électronique');

-- ---- Balyo ----
UPDATE companies SET description_en = 'French logistics robotics startup, "Driven by Balyo" technology (geoguided navigation) turning standard forklifts into autonomous robots. More than 1,500 robots deployed in 25+ countries.'
WHERE name = 'Balyo' AND description_en IS NULL;

UPDATE products SET description_en = 'Balyo autonomous reach truck (AGV/AMR), geoguided navigation with no added infrastructure, 3D pallet detection and 360° safety system.'
WHERE name = 'REACHY' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Balyo');

-- ---- Batconnect ----
UPDATE companies SET description_en = 'French manufacturer of connected LFP lithium batteries (CAN, UART, GPS, 4G) with real-time tracking and predictive maintenance, for light electric vehicles, airport ground equipment, marine, robotics, industrial cleaning and stationary storage.'
WHERE name = 'Batconnect' AND description_en IS NULL;

UPDATE products SET description_en = '48V 100Ah lithium iron phosphate (LFP) battery pack with integrated connectivity module (CAN/UART/GPS/4G depending on configuration), for real-time tracking of state of charge and health, and predictive maintenance through a fleet management platform.'
WHERE name = 'Pack LFP 48V 100Ah connecté (IoT)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Batconnect');

-- ---- Blue Canyon Technologies ----
UPDATE companies SET description_en = 'US platform maker (RTX/Raytheon subsidiary) specializing in small/microsatellite buses of the X-SAT range, with significant flight heritage.'
WHERE name = 'Blue Canyon Technologies' AND description_en IS NULL;

UPDATE products SET description_en = 'Satellite bus from the Blue Canyon Technologies X-SAT range, with a standard 24-inch launcher interface, for LEO, GEO and deep space missions.'
WHERE name = 'X-SAT Saturn Class' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Blue Canyon Technologies');

-- ---- Blue Origin ----
UPDATE companies SET description_en = 'US launch company founded by Jeff Bezos, developer of the New Glenn reusable heavy-lift launch vehicle and the BE-4/BE-3U engines.'
WHERE name = 'Blue Origin' AND description_en IS NULL;

UPDATE products SET description_en = 'Blue Origin reusable heavy-lift launch vehicle, recoverable first stage designed for 25 missions (7 BE-4 engines), 7-meter-diameter fairing (2x the volume of classic 5 m launchers).'
WHERE name = 'New Glenn' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Blue Origin');

-- ---- BMA (Boussac Montier Automatisme) ----
UPDATE companies SET description_en = 'French supplier of solenoid valves, actuators and process valves for petrochemicals, chemicals, pharmaceuticals and food processing. Recognized expertise in ATEX equipment.'
WHERE name = 'BMA (Boussac Montier Automatisme)' AND description_en IS NULL;

UPDATE products SET description_en = 'Solenoid valve and process valves for petrochemicals, chemicals, pharmaceuticals and food processing, available in an ATEX-certified version.'
WHERE name = 'Électrovanne tous fluides' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'BMA (Boussac Montier Automatisme)');

-- ---- BMW Group ----
UPDATE companies SET description_en = 'German premium carmaker, platform maker of the new all-electric Neue Klasse (800V) architecture, alongside the MINI and Rolls-Royce brands.'
WHERE name = 'BMW Group' AND description_en IS NULL;

UPDATE products SET description_en = 'BMW''s first model on the all-electric Neue Klasse architecture, 800V architecture, sixth generation of the in-house eDrive technology.'
WHERE name = 'iX3' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'BMW Group');

-- ---- Boeing Satellite Systems ----
UPDATE companies SET description_en = 'Boeing''s satellite division, historic geostationary platform maker with the 702 bus (47 satellites launched, 60 on order), for telecommunications and government missions.'
WHERE name = 'Boeing Satellite Systems' AND description_en IS NULL;

UPDATE products SET description_en = 'Boeing''s historic geostationary platform (payload module attached to the bus by only 4 anchor points), for telecommunications and government missions. 15-year design life.'
WHERE name = 'Boeing 702' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Boeing Satellite Systems');

-- ---- Bright Ascension ----
UPDATE companies SET description_en = 'Scottish publisher of modular flight software (Flightkit) for satellite onboard computers, based on pre-validated, reconfigurable components.'
WHERE name = 'Bright Ascension' AND description_en IS NULL;

UPDATE products SET description_en = 'Modular, reconfigurable flight software development kit for satellite onboard computers, based on pre-validated components.'
WHERE name = 'Flightkit — logiciel de vol modulaire' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Bright Ascension');

-- ---- BTRY ----
UPDATE companies SET description_en = 'Swiss spin-off of ETH Zurich and Empa developing ultra-thin solid-state lithium-ion batteries, capable of charging in one minute.'
WHERE name = 'BTRY' AND description_en IS NULL;

UPDATE products SET description_en = 'Ultra-thin integrated energy solution based on solid-state lithium-ion cells, designed for one-minute charging.'
WHERE name = 'BTRY 1S4P — batterie solid-state ultra-fine' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'BTRY');

-- ---- Bureau Veritas ----
UPDATE companies SET description_en = 'French group founded in 1828, world leader in laboratory testing, inspection and certification, an independent trusted third party for compliance with standards and regulations.'
WHERE name = 'Bureau Veritas' AND description_en IS NULL;

UPDATE products SET description_en = 'Laboratory testing, inspection and compliance certification to standards and regulations, for all industrial sectors.'
WHERE name = 'Essais en laboratoire, inspection et certification' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Bureau Veritas');

-- Contrôle : produits de ces entreprises encore sans description anglaise (doit être 0).
SELECT c.name AS entreprise, count(*) FILTER (WHERE p.description_en IS NULL) AS sans_anglais, count(*) AS total
FROM companies c LEFT JOIN products p ON p.company_id = c.id
WHERE c.name IN ('Solar MEMS Technologies', 'SPACEMANIC', 'Syrlinks', 'Turntide Technologies', 'TYVA Energie', 'U-Space', 'Valeo', 'Verkor', 'XP Power', 'A2P Connectique', 'Actual Group', 'Additive Drives', 'AddUp', 'Advanced Cooling Technologies (ACT)', 'Agnikul Cosmos', 'AKETYS', 'Akkodis France', 'AKROMECA', 'Alseamar', 'Alten', 'Apave', 'ArianeGroup', 'ARQUIMEA', 'Assystem', 'Astranis', 'Astroscale', 'Automotive Cells Company (ACC)', 'Avio', 'AVNIR Engineering', 'Axis Électronique', 'Balyo', 'Batconnect', 'Blue Canyon Technologies', 'Blue Origin', 'BMA (Boussac Montier Automatisme)', 'BMW Group', 'Boeing Satellite Systems', 'Bright Ascension', 'BTRY', 'Bureau Veritas')
GROUP BY c.name ORDER BY c.name;
