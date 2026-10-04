-- ============================================================
-- Traductions anglaises (description_en) — lot « batch7 », 2026-10
-- Entreprises : Sonceboz, TE Connectivity, Terma, Victron Energy, Watt & Well, Apex Space, Argotec, Brusa Elektronik, Bürkert, CATL, CAVU Aerospace, CILAS, D-Orbit, Danfoss, Exotrail, Flowserve, Lemo, LG Energy Solution, MacArtney, Moog Space & Defense, Muon Space, Neogy, NewSpace Systems, Oxford Space Systems, Parker Hannifin, PULS GmbH, RECOM Power, Rocket Lab, Samsung SDI, Schneider Electric, Selha Group, Siemens
--
-- Sûr à relancer : ne remplit que les champs encore vides (IS NULL).
-- ============================================================

-- ---- Sonceboz ----
UPDATE companies SET description_en = 'Swiss manufacturer of mechatronic solutions (brushless motors, stepper motors and actuators) for automotive, medical and industrial use, specializing in demanding environments.'
WHERE name = 'Sonceboz' AND description_en IS NULL;

UPDATE products SET description_en = 'Range of hybrid brushless and stepper motors with integrated control electronics, for demanding automotive applications (EGR, intake, exhaust, boost valves, instrument cluster).'
WHERE name = 'Actionneurs mécatroniques BLDC & pas-à-pas' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Sonceboz');

UPDATE products SET description_en = 'Lightweight, powerful permanent-magnet brushless motor, usable as a motor or generator on a 24 or 48 V onboard network. Designed for steering pumps, water pumps and compressors in electrified vehicles.'
WHERE name = 'CPM90 — Moteur/générateur brushless' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Sonceboz');

UPDATE products SET description_en = 'NEMA 23 hybrid stepper motor, neodymium-iron-boron magnets, for precise positioning applications in demanding industrial or automotive environments.'
WHERE name = 'Moteur pas-à-pas hybride Série 6600 (NEMA 23)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Sonceboz');

-- ---- TE Connectivity ----
UPDATE companies SET description_en = 'High-voltage connectors and sensors for EVs and aerospace. HVA280 and MQS references.'
WHERE name = 'TE Connectivity' AND description_en IS NULL;

UPDATE products SET description_en = 'Rugged pressure sensor for braking systems and HV batteries.'
WHERE name = 'Capteur de pression HV' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'TE Connectivity');

UPDATE products SET description_en = 'Sealed miniature connector for low-voltage automotive harnesses.'
WHERE name = 'Connecteur MQS automobile' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'TE Connectivity');

UPDATE products SET description_en = '250A HV connector for EV battery DC bus. Self-segregating HVIL. IP67 when mated.'
WHERE name = 'HVP800 — Connecteur HV 250A' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'TE Connectivity');

-- ---- Terma ----
UPDATE companies SET description_en = 'Danish industrial company in defense and space electronics, more than 50 years of experience in power systems, star trackers and processing units for ESA missions (BepiColombo, Euclid, Rosetta, Mars Express, PLATO).'
WHERE name = 'Terma' AND description_en IS NULL;

UPDATE products SET description_en = 'Terma star tracker based on the Faintstar-2 CMOS sensor, with separate baffle and camera for optimal thermal stability, designed for missions with high radiation exposure (GEO, 15 years in orbit).'
WHERE name = 'T1 Star Tracker' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Terma');

UPDATE products SET description_en = 'Compact Terma star tracker, reduced version of the T1, with high accuracy and excellent thermal stability, designed for 5-year low Earth orbit (LEO) microsatellite missions.'
WHERE name = 'T3 Star Tracker' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Terma');

UPDATE products SET description_en = 'Terma modular Power Conditioning and Distribution Unit, with a scalable architecture up to 15 kW, designed to be integrated into Earth-orbiting satellites, GEO missions or interplanetary probes. Flown on BepiColombo, Euclid, XMM-Newton, Rosetta, Mars Express, Venus Express and PLATO.'
WHERE name = 'Terma PCDU' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Terma');

-- ---- Victron Energy ----
UPDATE companies SET description_en = 'MultiPlus inverter-chargers, MPPT controllers, ESS. The off-grid, marine and motorhome reference.'
WHERE name = 'Victron Energy' AND description_en IS NULL;

UPDATE products SET description_en = 'Bluetooth battery monitor for accurate state-of-charge tracking.'
WHERE name = 'Moniteur batterie BMV-712' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Victron Energy');

UPDATE products SET description_en = '5 kVA inverter-charger for off-grid and hybrid systems. Built-in PowerAssist, 96% efficiency.'
WHERE name = 'MultiPlus-II 48/5000' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Victron Energy');

UPDATE products SET description_en = 'High-power MPPT solar charge controller for off-grid systems.'
WHERE name = 'Régulateur MPPT SmartSolar 250/100' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Victron Energy');

-- ---- Watt & Well ----
UPDATE companies SET description_en = 'French manufacturer of power electronics for demanding applications: fast EV charging, energy storage (BESS), oil & gas downhole and defense & space. OEM supplier of AC/DC, DC/DC, SECC and EVCC modules. Present on Ariane 6 and New Space missions. "Made in France" and USA production.'
WHERE name = 'Watt & Well' AND description_en IS NULL;

UPDATE products SET description_en = 'High-performance bidirectional DC/DC converter for stationary energy storage (ESS), mobile storage (MES) and Vehicle-to-Grid (V2G) applications. Manages energy flows between batteries and the grid. CCS-protocol compatible for integration into ESS or electric vehicles charged at a DC station.'
WHERE name = 'Convertisseur DC/DC bidirectionnel (BESS / V2G)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Watt & Well');

UPDATE products SET description_en = 'High-performance AC/DC converter for DC fast-charging stations (up to 350 kW). Designed for EVSE infrastructure, compatible with ESS, MES and V2G. Simple architecture allowing system integration in a few weeks. Available in unidirectional and bidirectional versions. Made in France.'
WHERE name = 'Module AC/DC pour bornes de recharge rapide (EVSE)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Watt & Well');

UPDATE products SET description_en = 'Supply Equipment Communication Controller (SECC) for DC charging stations. Manages the communication layer between the vehicle and the station according to the ISO 15118 / CCS protocol. Compact module, integrable within weeks into any DC charger architecture.'
WHERE name = 'SECC — Contrôleur de communication pour charge DC' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Watt & Well');

-- ---- Apex Space ----
UPDATE companies SET description_en = 'US platform maker producing standardized "off-the-shelf" satellite buses (Aries range, LEO and GEO), to reduce manufacturing lead times and enable rapid-response missions.'
WHERE name = 'Apex Space' AND description_en IS NULL;

UPDATE products SET description_en = 'Apex Space ESPA-class satellite bus for geostationary missions, optimized for agility with 6-degree-of-freedom hydrazine propulsion, compatible with third-party RPO kits.'
WHERE name = 'GEO Aries' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Apex Space');

UPDATE products SET description_en = 'Apex Space mid-size LEO platform, produced on an active manufacturing line, highly configurable (power, propulsion, GNC) and available off the shelf.'
WHERE name = 'LEO Aries' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Apex Space');

-- ---- Argotec ----
UPDATE companies SET description_en = 'Italian manufacturer of microsatellites and subsystems for deep space missions, including the FERMI onboard computer used on NASA''s deep-space exploration missions.'
WHERE name = 'Argotec' AND description_en IS NULL;

UPDATE products SET description_en = 'Argotec onboard computer designed for deep space missions, with high radiation tolerance, used notably on NASA''s lunar CubeSat missions (ArgoMoon).'
WHERE name = 'FERMI' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Argotec');

UPDATE products SET description_en = 'Argotec''s standardized modular microsatellite platform (interchangeable modular panels, payload integration as the last step), for optical/SAR Earth observation, 5G satcom, space ISR and distributed edge computing.'
WHERE name = 'HAWK PLUS' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Argotec');

-- ---- Brusa Elektronik ----
UPDATE companies SET description_en = 'Pioneer of high-power onboard chargers. NLG range up to 43 kW for premium manufacturers.'
WHERE name = 'Brusa Elektronik' AND description_en IS NULL;

UPDATE products SET description_en = 'High-voltage bidirectional DC/DC converter for EV architectures.'
WHERE name = 'Convertisseur DC/DC BDC546' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Brusa Elektronik');

UPDATE products SET description_en = 'Compact 11 kW onboard charger for utility vehicles and light fleets.'
WHERE name = 'OBC NLG5 11kW' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Brusa Elektronik');

-- ---- Bürkert ----
UPDATE companies SET description_en = 'Solenoid valves, controllers and flow sensors. Leader in microfluidics and pharma applications.'
WHERE name = 'Bürkert' AND description_en IS NULL;

UPDATE products SET description_en = 'Mass flow sensor with no moving parts, hygienic, for pharma applications.'
WHERE name = 'Capteur de débit FLOWave SE30' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Bürkert');

UPDATE products SET description_en = '2/2-way diaphragm solenoid valve for neutral and aggressive fluids.'
WHERE name = 'Électrovanne type 6213' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Bürkert');

-- ---- CATL ----
UPDATE companies SET description_en = 'World leader in lithium batteries (~38% market share). Supplier to BMW, Tesla, Volkswagen, Hyundai.'
WHERE name = 'CATL' AND description_en IS NULL;

UPDATE products SET description_en = 'Long-life prismatic LiFePO4 cell. Standard for ESS and commercial vehicles.'
WHERE name = 'LiFePO4 Pack 280Ah' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CATL');

UPDATE products SET description_en = 'Qilin-generation NMC cell for ultra-fast 4C charging. Cell-to-pack, liquid immersion.'
WHERE name = 'NMC Qilin 100Ah — 4C' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CATL');

-- ---- CAVU Aerospace ----
UPDATE companies SET description_en = 'US specialist in aircraft teardown and the sale of certified used spare parts. Since 2010, CAVU has dismantled more than 500 aircraft and returned more than one million components to service. Diamond AFRA 2024 accredited. Developer of CAVUSmartTags®, a proprietary real-time parts traceability system.'
WHERE name = 'CAVU Aerospace' AND description_en IS NULL;

UPDATE products SET description_en = 'Proprietary inventory and traceability system for aircraft parts. Generates real-time manifests with PN/SN, checks for entry errors and sends automatic shipping notifications. Used in every CAVU teardown to guarantee a complete chain of traceability from disassembly to delivery.'
WHERE name = 'CAVUSmartTags® — Système de traçabilité' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace');

UPDATE products SET description_en = 'Sale of certified used aircraft components from professional teardowns. FAA-certified A&P mechanics. Each part is removed, cleaned, inspected, identified and packaged according to manufacturer recommendations. Full traceability through CAVUSmartTags® (real-time manifests, PN/SN, automatic shipping notification).'
WHERE name = 'Pièces aéronautiques certifiées (MRO)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace');

-- ---- CILAS ----
UPDATE companies SET description_en = 'French expert in lasers and precision optics for space, defense and scientific applications: optical amplifiers for laser communication, optical coatings.'
WHERE name = 'CILAS' AND description_en IS NULL;

UPDATE products SET description_en = 'High-power fiber optical amplifier for space laser communication terminals. Selected by Airbus Defence and Space for the TELEO and LASIN in-orbit demonstrations, flown on BADR-8 (GEO) and CO3D (LEO).'
WHERE name = 'HPOA — Amplificateur optique haute puissance' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CILAS');

UPDATE products SET description_en = 'Protective optical coatings for large-size space optical components (up to 2 m x 2 m), magnetron sputtering technology.'
WHERE name = 'Revêtements optiques de protection' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CILAS');

-- ---- D-Orbit ----
UPDATE companies SET description_en = 'Italian manufacturer of orbital transport services (ION) and satellite subsystems, including the Simba onboard computer compliant with the ECSS Class-1 standard.'
WHERE name = 'D-Orbit' AND description_en IS NULL;

UPDATE products SET description_en = 'Modular 64U orbital transfer vehicle (OTV), able to carry and deploy several CubeSats at different orbital parameters in a single mission. Complete spacecraft with avionics, EPS, ADCS, thermal control and data handling.'
WHERE name = 'ION Satellite Carrier' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'D-Orbit');

UPDATE products SET description_en = 'D-Orbit onboard computer for low Earth orbit (LEO) missions, compliant with the ECSS Class-1 standard, intended for integration into satellite platforms.'
WHERE name = 'Simba' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'D-Orbit');

-- ---- Danfoss ----
UPDATE companies SET description_en = 'VLT/VACON drives, mobile hydraulics and heat pumps. Industrial energy management.'
WHERE name = 'Danfoss' AND description_en IS NULL;

UPDATE products SET description_en = 'Proportional valve block for mobile hydraulics and construction machinery.'
WHERE name = 'Vanne hydraulique mobile PVG' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Danfoss');

UPDATE products SET description_en = 'Versatile frequency drive for process and industrial HVAC applications.'
WHERE name = 'Variateur VACON 100' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Danfoss');

-- ---- Exotrail ----
UPDATE companies SET description_en = 'French New Space equipment maker: flexible high-thrust electric thrusters for small satellites, orbital transfer vehicles and space operations software tools.'
WHERE name = 'Exotrail' AND description_en IS NULL;

UPDATE products SET description_en = 'Flexible high-thrust electric thruster for small satellites, used in orbit for station keeping and transfer maneuvers.'
WHERE name = 'Propulseur électrique spatial' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Exotrail');

UPDATE products SET description_en = 'Orbital transfer vehicle (OTV) -- not a conventional satellite bus -- using Exotrail''s ExoMG electric propulsion to drop off payloads at different orbital parameters (the space "last mile").'
WHERE name = 'SpaceVan' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Exotrail');

-- ---- Flowserve ----
UPDATE companies SET description_en = 'Industrial pumps, valves and actuators in more than 50 countries. API 6D certified.'
WHERE name = 'Flowserve' AND description_en IS NULL;

UPDATE products SET description_en = 'Process centrifugal pump for chemical and petrochemical applications.'
WHERE name = 'Pompe centrifuge Durco Mark 3' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Flowserve');

UPDATE products SET description_en = 'Industrial ball valve for oil & gas and heavy chemical applications.'
WHERE name = 'Vanne à bille Worcester série 44' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Flowserve');

-- ---- Lemo ----
UPDATE companies SET description_en = 'Precision push-pull connectors. Reference in medical, broadcast and military. Made in Switzerland.'
WHERE name = 'Lemo' AND description_en IS NULL;

UPDATE products SET description_en = 'Custom assembled cable with Lemo connectors for medical equipment.'
WHERE name = 'Câble assemblé médical série M' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Lemo');

UPDATE products SET description_en = 'Precision push-pull connector, a reference in medical and military.'
WHERE name = 'Connecteur push-pull série K' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Lemo');

-- ---- LG Energy Solution ----
UPDATE companies SET description_en = 'Supplier to GM, Hyundai, Stellantis, Tesla. Gigafactories in Poland and the USA.'
WHERE name = 'LG Energy Solution' AND description_en IS NULL;

UPDATE products SET description_en = 'High-performance cylindrical cell for EVs and cordless power tools.'
WHERE name = 'Cellule cylindrique 2170' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'LG Energy Solution');

UPDATE products SET description_en = 'RESU residential/commercial pack for solar storage and self-consumption.'
WHERE name = 'Pack pouch RESU ESS 10 kWh' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'LG Energy Solution');

-- ---- MacArtney ----
UPDATE companies SET description_en = 'Danish manufacturer of underwater connectivity (SubConn and TrustLink connectors and cables) and systems for oceanographic instrumentation, integrated into ROVs, AUVs and subsea sensors worldwide.'
WHERE name = 'MacArtney' AND description_en IS NULL;

UPDATE products SET description_en = 'Underwater connector from the SubConn Circular range, with 6, 8 or 10 contacts, designed for electrical integration between ROV, AUV and oceanographic instrumentation system components in the marine environment.'
WHERE name = 'SubConn Circular — 6, 8 et 10 contacts' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'MacArtney');

UPDATE products SET description_en = 'Underwater connector from the SubConn Power range dedicated to the battery link, with 2, 3 or 4 contacts, intended for integrating power blocks into underwater vehicles.'
WHERE name = 'SubConn Power Battery — 2, 3 et 4 contacts' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'MacArtney');

-- ---- Moog Space & Defense ----
UPDATE companies SET description_en = 'Moog''s space division. Propulsion valves, deployment actuators and control systems for launch vehicles and satellites. Present on the ISS, SLS and many commercial satellites.'
WHERE name = 'Moog Space & Defense' AND description_en IS NULL;

UPDATE products SET description_en = 'Electromechanical actuator for deploying solar panels and antennas.'
WHERE name = 'Actionneur de déploiement panneau solaire' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Moog Space & Defense');

UPDATE products SET description_en = 'Latching propulsion valve for satellite and launch vehicle propulsion systems.'
WHERE name = 'Vanne de propulsion satellite' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Moog Space & Defense');

-- ---- Muon Space ----
UPDATE companies SET description_en = 'US platform maker designing custom LEO satellites for Earth observation and constellations, MuSat platform range (standard and XL).'
WHERE name = 'Muon Space' AND description_en IS NULL;

UPDATE products SET description_en = 'Muon Space standard satellite platform, with no deployable element, for Earth observation missions in low sun-synchronous orbit.'
WHERE name = 'MuSat' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Muon Space');

UPDATE products SET description_en = 'Muon Space high-end platform (500 kg class), for the most demanding LEO missions -- advanced sensors, phased-array antennas, edge computing.'
WHERE name = 'MuSat XL' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Muon Space');

-- ---- Neogy ----
UPDATE companies SET description_en = 'Custom B2B battery packs. 3,000 m² factory in Pompignac, 500 MWh/year. Multi-chemistry.'
WHERE name = 'Neogy' AND description_en IS NULL;

UPDATE products SET description_en = 'Custom battery pack for industrial vehicles and specific machinery.'
WHERE name = 'Pack batterie B2B sur-mesure NMC' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Neogy');

UPDATE products SET description_en = 'Custom LiFePO4 pack for stationary storage and industrial applications.'
WHERE name = 'Pack LFP stationnaire sur-mesure' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Neogy');

-- ---- NewSpace Systems ----
UPDATE companies SET description_en = 'South African manufacturer of ADCS and RF components for small satellites: sun sensors, reaction wheels, magnetorquers, GPS receivers, antennas.'
WHERE name = 'NewSpace Systems' AND description_en IS NULL;

UPDATE products SET description_en = 'Rod magnetorquer for reaction wheel desaturation and low-power attitude control.'
WHERE name = 'NSS Magnetorquer Rod' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'NewSpace Systems');

UPDATE products SET description_en = 'Rugged, flight-proven sun sensor for small-satellite attitude determination.'
WHERE name = 'NSS Sun Sensor' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'NewSpace Systems');

-- ---- Oxford Space Systems ----
UPDATE companies SET description_en = 'Leader in deployable antennas for space: Helical, Wrapped Rib and Yagi designs to reduce mass and stowed volume.'
WHERE name = 'Oxford Space Systems' AND description_en IS NULL;

UPDATE products SET description_en = 'Deployable helical antenna for small satellites, optimized to minimize mass and stowed volume.'
WHERE name = 'Helical — Antenne déployable' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Oxford Space Systems');

UPDATE products SET description_en = 'Wrapped Rib reflector for large high-performance deployable antennas.'
WHERE name = 'Wrapped Rib — Réflecteur déployable' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Oxford Space Systems');

-- ---- Parker Hannifin ----
UPDATE companies SET description_en = 'World leader in motion technologies: proportional valves, cylinders, hydraulics.'
WHERE name = 'Parker Hannifin' AND description_en IS NULL;

UPDATE products SET description_en = 'High-precision proportional valve for industrial hydraulic applications.'
WHERE name = 'Vanne proportionnelle D1FP' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Parker Hannifin');

UPDATE products SET description_en = 'ISO-standard hydraulic cylinder for heavy industrial applications.'
WHERE name = 'Vérin hydraulique série 2H' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Parker Hannifin');

-- ---- PULS GmbH ----
UPDATE companies SET description_en = 'German manufacturer specializing in DIN-rail power supplies, DC/DC converters, electronic circuit breakers and DC-UPS modules, intended for integration into industrial electrical distribution cabinets.'
WHERE name = 'PULS GmbH' AND description_en IS NULL;

UPDATE products SET description_en = 'PULS DIN-rail power supply family from the DIMENSION range, designed for integration into high-power-density industrial electrical distribution cabinets.'
WHERE name = 'PULS DIMENSION' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'PULS GmbH');

UPDATE products SET description_en = 'PULS DIN-rail power supply family from the PLANET range, designed for compact power distribution in industrial electrical cabinets.'
WHERE name = 'PULS PLANET' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'PULS GmbH');

-- ---- RECOM Power ----
UPDATE companies SET description_en = 'Austrian manufacturer of isolated DC/DC converters, power modules and power supplies, intended for integration into industrial, medical and telecommunications electronic systems.'
WHERE name = 'RECOM Power' AND description_en IS NULL;

UPDATE products SET description_en = 'RECOM isolated DC/DC converter in DIN-rail format, to be integrated into an electrical distribution cabinet for voltage conversion in industrial environments.'
WHERE name = 'RECOM E-Series' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'RECOM Power');

UPDATE products SET description_en = 'Range of RECOM isolated DC/DC converters, available as a switching regulator and as a DIN-rail module, designed for integration into distributed industrial power systems.'
WHERE name = 'RECOM K-Series' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'RECOM Power');

-- ---- Rocket Lab ----
UPDATE companies SET description_en = 'US-New Zealand launch and platform company, known for the Electron launch vehicle and the Photon satellite bus, an integrated launch + platform solution for LEO and interplanetary missions.'
WHERE name = 'Rocket Lab' AND description_en IS NULL;

UPDATE products SET description_en = 'Rocket Lab light launch vehicle, 9 Rutherford engines on the first stage (electric pumps), 1 vacuum-optimized Rutherford engine on the upper stage. RP-1/LOX propellants.'
WHERE name = 'Electron' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Rocket Lab');

UPDATE products SET description_en = 'Rocket Lab integrated launch + platform solution (based on Electron''s Kick Stage upper stage), for LEO missions, lunar flybys and interplanetary missions. Upgraded "Explorer" version for deep space missions.'
WHERE name = 'Photon' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Rocket Lab');

-- ---- Samsung SDI ----
UPDATE companies SET description_en = 'Prismatic and cylindrical cells for EVs and ESS. Supplier to BMW, Volkswagen, Stellantis.'
WHERE name = 'Samsung SDI' AND description_en IS NULL;

UPDATE products SET description_en = 'High-density prismatic cell for premium EV packs. Compact format, fast charging.'
WHERE name = 'Cellule prismatique 94Ah NMC' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Samsung SDI');

UPDATE products SET description_en = 'PRiMX stationary storage module for grid and industrial applications.'
WHERE name = 'Module ESS PRiMX 50kWh' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Samsung SDI');

-- ---- Schneider Electric ----
UPDATE companies SET description_en = 'World number one in energy management. APC PDUs, Galaxy UPS. Revenue ~€37bn.'
WHERE name = 'Schneider Electric' AND description_en IS NULL;

UPDATE products SET description_en = 'Galaxy VS modular UPS for data centers and critical industries.'
WHERE name = 'Onduleur Galaxy VS 100kVA' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Schneider Electric');

UPDATE products SET description_en = 'Monitored APC rack PDU for data centers and server rooms. Managed via EcoStruxure.'
WHERE name = 'PDU APC rack intelligent' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Schneider Electric');

-- ---- Selha Group ----
UPDATE companies SET description_en = 'French electronics contract manufacturer (EMS), historically Société Electronique du Haut Anjou (SELHA, registered in 1982), specializing in the design and manufacture of electronic boards and equipment for defense, telecommunications, energy, medical, aeronautics and industry. Group of more than 1,000 employees across 5 sites in France and Morocco.'
WHERE name = 'Selha Group' AND description_en IS NULL;

UPDATE products SET description_en = 'All-in-one user terminal (modem, antenna, PoE power supply, Ethernet cable) for high-speed Internet access via Ka-band VHTS geostationary satellites. Designed and manufactured in France (Renazé/Eu site, Selha Group), with an Oxford 2 ASIC-based modem architecture and GaN Ka-band power amplifier, built-in AES-256 encryption and SecureBoot, plug & play installation.'
WHERE name = 'ASTREKa — Terminal de communication satellite Ka-band' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Selha Group');

UPDATE products SET description_en = 'Selha Group electronics contract manufacturing (EMS) service: design and manufacture of electronic boards and equipment on behalf of third parties, for the defense, telecommunications, energy, medical, aeronautics and industrial sectors. Group of more than 1,000 employees, 5 sites in France and Morocco.'
WHERE name = 'Fabrication de cartes et équipements électroniques (EMS)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Selha Group');

-- ---- Siemens ----
UPDATE companies SET description_en = 'SINAMICS drives, SIMOTICS motors, SIMATIC controllers. World reference in automation.'
WHERE name = 'Siemens' AND description_en IS NULL;

UPDATE products SET description_en = 'Standard IE3 industrial induction motor for process applications.'
WHERE name = 'Moteur SIMOTICS GP' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Siemens');

UPDATE products SET description_en = 'Rugged frequency drive for pumps, fans and industrial applications.'
WHERE name = 'Variateur SINAMICS G120X' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Siemens');

-- Contrôle : produits de ces entreprises encore sans description anglaise (doit être 0).
SELECT c.name AS entreprise, count(*) FILTER (WHERE p.description_en IS NULL) AS sans_anglais, count(*) AS total
FROM companies c LEFT JOIN products p ON p.company_id = c.id
WHERE c.name IN ('Sonceboz', 'TE Connectivity', 'Terma', 'Victron Energy', 'Watt & Well', 'Apex Space', 'Argotec', 'Brusa Elektronik', 'Bürkert', 'CATL', 'CAVU Aerospace', 'CILAS', 'D-Orbit', 'Danfoss', 'Exotrail', 'Flowserve', 'Lemo', 'LG Energy Solution', 'MacArtney', 'Moog Space & Defense', 'Muon Space', 'Neogy', 'NewSpace Systems', 'Oxford Space Systems', 'Parker Hannifin', 'PULS GmbH', 'RECOM Power', 'Rocket Lab', 'Samsung SDI', 'Schneider Electric', 'Selha Group', 'Siemens')
GROUP BY c.name ORDER BY c.name;
