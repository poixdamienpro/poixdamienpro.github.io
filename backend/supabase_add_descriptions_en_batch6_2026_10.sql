-- ============================================================
-- Traductions anglaises (description_en) — lot « batch6 », 2026-10
-- Entreprises : maxon, Rheinmetall, SEW-Eurodrive, Thales, Wittenstein, Allied Motion (Allient), Alstom, Bradford ECAPS, Corvus Energy, Eaton, Forsee Power, GomSpace, GS Yuasa Technology (Space), Kollmorgen, Lenze, Moog, Powell Electronics, Regal Rexnord, Safran Electrical & Power, Saft (TotalEnergies), Sensata Technologies, SITAEL
--
-- Sûr à relancer : ne remplit que les champs encore vides (IS NULL).
-- ============================================================

-- ---- maxon ----
UPDATE companies SET description_en = 'Swiss group specializing in high-precision drive systems: DC and brushless motors, gearheads, encoders and control electronics, for robotics and automation.'
WHERE name = 'maxon' AND description_en IS NULL;

UPDATE products SET description_en = 'Brushed DC motor (precious metal or graphite), coreless rotor, configurable online from six different windings. Diameters from 6 to 35 mm.'
WHERE name = 'DCX — Moteur DC à balais configurable' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'maxon');

UPDATE products SET description_en = 'Brushless motor with iron winding, optimized magnetic circuit and internal multipole rotor, for high dynamics and very low cogging. 40 mm diameter, several voltage variants.'
WHERE name = 'EC-i 40 — Moteur brushless' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'maxon');

UPDATE products SET description_en = 'Brushless motor combining the qualities of the A-max and RE-max ranges, compatible with a modular system of gearheads, sensors and brakes. 30 mm diameter, several voltage and power variants.'
WHERE name = 'EC-max 30 — Moteur brushless' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'maxon');

UPDATE products SET description_en = 'Coreless-winding brushless motor optimized for very high speed, in standard, high-power, sterilizable or ceramic-bearing versions. For surgical tools and industrial spindles.'
WHERE name = 'ECX SPEED — Moteur brushless très haute vitesse' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'maxon');

-- ---- Rheinmetall ----
UPDATE companies SET description_en = 'High-robustness actuators and servo valves for armored vehicles and weapon systems.'
WHERE name = 'Rheinmetall' AND description_en IS NULL;

UPDATE products SET description_en = 'Electric actuator for turret rotation and stabilization on armored vehicles.'
WHERE name = 'Actionneur électrique de tourelle EA-600' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Rheinmetall');

UPDATE products SET description_en = 'Pneumatic distribution block for auxiliary systems on armored vehicles.'
WHERE name = 'Bloc de vannes pneumatiques PV-220' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Rheinmetall');

UPDATE products SET description_en = 'High-robustness hydraulic servo valve for stabilization and pointing systems on armored vehicles.'
WHERE name = 'Servovanne hydraulique SV-900' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Rheinmetall');

UPDATE products SET description_en = 'Hydraulic cylinder for stabilizing guns and weapon systems on mobile platforms.'
WHERE name = 'Vérin hydraulique de stabilisation HC-450' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Rheinmetall');

-- ---- SEW-Eurodrive ----
UPDATE companies SET description_en = 'German manufacturer of geared motors, drives and mechatronic drive systems, one of the world''s largest groups in industrial power transmission.'
WHERE name = 'SEW-Eurodrive' AND description_en IS NULL;

UPDATE products SET description_en = 'Permanent-magnet synchronous servomotor, low inertia, for dynamic applications. Driven by a three-phase frequency inverter, 7 sizes and 31 power variants.'
WHERE name = 'CMP.. — Servomoteur synchrone' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'SEW-Eurodrive');

UPDATE products SET description_en = 'Standard IE3 three-phase asynchronous motor, compatible with existing SEW gearboxes without adaptation. Covers a very wide power range, from small auxiliary motors to heavy industrial motors.'
WHERE name = 'DRN.. — Moteur asynchrone triphasé IE3' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'SEW-Eurodrive');

UPDATE products SET description_en = 'Drive unit integrating a permanent-magnet synchronous motor, gearbox and power electronics in a single housing, for conveyors and material-handling applications. Compact design, universal mounting.'
WHERE name = 'MOVIGEAR® performance — Unité d''entraînement mécatronique' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'SEW-Eurodrive');

UPDATE products SET description_en = 'Geared motor combined with a digital frequency inverter in a single IP65 housing, decentralized as close as possible to the application. Footprint close to a conventional geared motor despite the integrated electronics.'
WHERE name = 'MOVIMOT® flexible — Moteur-réducteur à variateur intégré' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'SEW-Eurodrive');

-- ---- Thales ----
UPDATE companies SET description_en = 'European leader in tactical radio and radar systems. Ruggedized RF modules for land, naval and space platforms.'
WHERE name = 'Thales' AND description_en IS NULL;

UPDATE products SET description_en = 'Foldable wideband antenna for vehicles and tactical command posts. Fast deployment, low signature.'
WHERE name = 'Antenne tactique repliable AT-150' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Thales');

UPDATE products SET description_en = 'Ruggedized multi-band RF transceiver for tactical links and onboard platforms. Designed for harsh environments.'
WHERE name = 'Module émetteur-récepteur RF TRX-200' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Thales');

UPDATE products SET description_en = 'Multi-band software-defined radio for secure voice and data communications in the field.'
WHERE name = 'Radio tactique multibande RT-9000' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Thales');

UPDATE products SET description_en = 'Multi-constellation anti-spoofing GNSS receiver for precision navigation in contested environments.'
WHERE name = 'Récepteur GNSS militaire GR-Defense' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Thales');

-- ---- Wittenstein ----
UPDATE companies SET description_en = 'German manufacturer of planetary gearheads, servomotors and complete electromechanical drive systems, used in robotics, machine tools and medical technology.'
WHERE name = 'Wittenstein' AND description_en IS NULL;

UPDATE products SET description_en = 'Compact brushless servomotors (17 to 40 mm diameters) with stainless-steel housing, single- or multi-turn absolute encoder, single detachable shielded cable. Designed for robotics and fine automation.'
WHERE name = 'cyber® dynamic line — Servomoteurs compacts' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Wittenstein');

UPDATE products SET description_en = 'High-precision linear electromechanical actuators, for applications requiring high force, speed and dynamics with low maintenance needs. Complements the cyber dynamic (rotary) range with direct linear motion.'
WHERE name = 'cyber® force line — Actionneurs linéaires' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Wittenstein');

UPDATE products SET description_en = 'Actuator integrating a precision planetary gearbox and a synchronous servomotor without coupling, 2-stage gearbox for dynamic rotary applications.'
WHERE name = 'TPM+ dynamic — Actionneur servo rotatif' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Wittenstein');

UPDATE products SET description_en = 'Servo actuator with 2 or 3 reduction stages for heavy-load applications, with a fourth planetary stage for extra torque reserve and torsional stiffness.'
WHERE name = 'TPM+ high torque — Actionneur charges lourdes' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Wittenstein');

-- ---- Allied Motion (Allient) ----
UPDATE companies SET description_en = 'US manufacturer (now Allient Inc.) of precision motion components and systems, for aerospace, robotics, medical and industrial automation.'
WHERE name = 'Allied Motion (Allient)' AND description_en IS NULL;

UPDATE products SET description_en = 'Precision brushless servomotor, five metric sizes, designed for high torque accuracy, good energy efficiency and a lifetime of more than 20,000 hours.'
WHERE name = 'HeiMotion HMP — Servomoteur brushless' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Allied Motion (Allient)');

UPDATE products SET description_en = '8-pole brushless servomotor, three-phase star-wound stator, compliant with NEMA size 56 mounting standards, for applications needing more torque than the standard QB range.'
WHERE name = 'QB056 — Servomoteur brushless 8 pôles' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Allied Motion (Allient)');

UPDATE products SET description_en = 'High-performance brushless servomotor in NEMA 17, 23 and 34 formats, for robotics and compact automation.'
WHERE name = 'Quantum QB — Servomoteur brushless NEMA' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Allied Motion (Allient)');

-- ---- Alstom ----
UPDATE companies SET description_en = 'Rail mobility leader. Propulsion, traction, onboard BESS energy storage for trains and trams.'
WHERE name = 'Alstom' AND description_en IS NULL;

UPDATE products SET description_en = 'Onboard BESS for catenary-free trains and braking energy recovery. Coradia iLint.'
WHERE name = 'BESS TrainPack 800V' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Alstom');

UPDATE products SET description_en = 'Modular traction converter for trains and trams. SiC architecture.'
WHERE name = 'Convertisseur de traction ONIX' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Alstom');

UPDATE products SET description_en = 'Permanent-magnet synchronous traction motor for rolling stock.'
WHERE name = 'Moteur de traction synchrone' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Alstom');

-- ---- Bradford ECAPS ----
UPDATE companies SET description_en = 'Pioneer of green space propulsion (HPGP). Non-toxic ADN-based LMP-103S propellant. Qualified flights on PRISMA (ESA), SkySat. Supplier to NASA, ESA and commercial operators.'
WHERE name = 'Bradford ECAPS' AND description_en IS NULL;

UPDATE products SET description_en = '1N green monopropellant thruster. Non-toxic, high-performance LMP-103S (ADN) propellant. 46 thrusters flown on PRISMA (ESA) and SkySat. Ideal for smallsats.'
WHERE name = '1N HPGP — Propulseur vert LEO' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Bradford ECAPS');

UPDATE products SET description_en = '5N HPGP thruster for attitude control and orbital maneuvers. Studied by NASA Goddard for interplanetary missions.'
WHERE name = '5N HPGP — Contrôle d''orbite' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Bradford ECAPS');

UPDATE products SET description_en = 'Bradford analog sun sensor measuring the sun aspect angle on two axes via a quadrant detector, intended for integration into small-satellite ADCS systems.'
WHERE name = 'Mini Fine Sun Sensor (Mini-FSS)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Bradford ECAPS');

-- ---- Corvus Energy ----
UPDATE companies SET description_en = 'ESS specialist for the marine sector. Packs for hybrid ferries and offshore vessels. DNV GL and ABS certified.'
WHERE name = 'Corvus Energy' AND description_en IS NULL;

UPDATE products SET description_en = 'Compact ESS module for small to medium-sized ferries and vessels.'
WHERE name = 'Corvus Blue Whale — ESS modulaire' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Corvus Energy');

UPDATE products SET description_en = 'High energy-density ESS for marine applications with high power demands.'
WHERE name = 'Corvus Dolphin — ESS haute densité' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Corvus Energy');

UPDATE products SET description_en = '2.1 MWh marine ESS for hybrid propulsion. DNV GL and ABS certified. Onboard SCADA.'
WHERE name = 'Orca Energy 2.1 MWh Marine' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Corvus Energy');

-- ---- Eaton ----
UPDATE companies SET description_en = 'Global leader in power management: intelligent PDUs, UPS, circuit breakers for data centers.'
WHERE name = 'Eaton' AND description_en IS NULL;

UPDATE products SET description_en = 'Low-voltage air circuit breaker with advanced electronic protection.'
WHERE name = 'Disjoncteur basse tension PXR' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Eaton');

UPDATE products SET description_en = 'Intelligent rack PDU, per-outlet monitoring, SNMP v3 and Modbus TCP. Vertical 0U format.'
WHERE name = 'ePDU G3 Advanced 32A' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Eaton');

UPDATE products SET description_en = 'High-power three-phase UPS for data centers and critical industries.'
WHERE name = 'UPS 9395P 500kVA' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Eaton');

-- ---- Forsee Power ----
UPDATE companies SET description_en = 'French integrator of lithium batteries for heavy mobility. European leader in its segment.'
WHERE name = 'Forsee Power' AND description_en IS NULL;

UPDATE products SET description_en = 'Battery pack for heavy electric trucks, optimized chassis integration.'
WHERE name = 'Pulse Pack — Camion électrique' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Forsee Power');

UPDATE products SET description_en = 'Battery pack for hybrid marine propulsion, certified by naval classification societies.'
WHERE name = 'Quantum Pack — Marine hybride' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Forsee Power');

UPDATE products SET description_en = 'High-density 672V NMC pack for urban electric buses. Proprietary BMS, active liquid cooling.'
WHERE name = 'ZEN Pack Bus 672V' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Forsee Power');

-- ---- GomSpace ----
UPDATE companies SET description_en = 'Danish manufacturer of nanosatellite and microsatellite subsystems, including the NanoMind onboard computer range, widely used in the smallsat industry.'
WHERE name = 'GomSpace' AND description_en IS NULL;

UPDATE products SET description_en = 'GomSpace onboard computer from the NanoMind range, designed for nanosatellite, CubeSat and microsatellite missions, with very low power consumption.'
WHERE name = 'NanoMind A3200' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'GomSpace');

UPDATE products SET description_en = '12U nanosatellite platform supplied as a component kit, same bus architecture as the 6U with more payload volume available.'
WHERE name = 'NanoSat 12U Kit' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'GomSpace');

UPDATE products SET description_en = '6U nanosatellite platform supplied as a pre-tested component kit (bus, power, communication, ADCS, C&DH), to be assembled into a ready-to-fly configuration.'
WHERE name = 'NanoSat 6U Kit' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'GomSpace');

-- ---- GS Yuasa Technology (Space) ----
UPDATE companies SET description_en = 'World leader in space Li-ion cells. LSE range (4 generations since 1998). More than 200 satellites powered, 550 million hours without anomaly. Supplier to NASA, JAXA, ESA.'
WHERE name = 'GS Yuasa Technology (Space)' AND description_en IS NULL;

UPDATE products SET description_en = 'Space-grade Li-ion cell, compact format for smallsats and CubeSats.'
WHERE name = 'LSE112 — Cellule Li-ion Spatiale' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'GS Yuasa Technology (Space)');

UPDATE products SET description_en = 'Gen III Li-ion cell for space. 40% DOD in LEO over more than 10 years. Integrated on JPSS-2 (NASA/NOAA). More than 17,000 cells delivered since 1998.'
WHERE name = 'LSE134 Gen III — Cellule Li-ion Spatiale' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'GS Yuasa Technology (Space)');

UPDATE products SET description_en = 'Battery module qualified for planetary rovers and exploration missions.'
WHERE name = 'Module batterie pour rover' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'GS Yuasa Technology (Space)');

-- ---- Kollmorgen ----
UPDATE companies SET description_en = 'US manufacturer of precision motion systems and servomotors, for robotics, medical imaging, aerospace and defense. A distinct brand within the Regal Rexnord group.'
WHERE name = 'Kollmorgen' AND description_en IS NULL;

UPDATE products SET description_en = 'Family of high-performance synchronous servomotors, 28 size/stack combinations and 120 standard windings. Low-voltage AKM2G variant available for battery-powered applications.'
WHERE name = 'AKM — Servomoteur synchrone' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Kollmorgen');

UPDATE products SET description_en = '316L stainless-steel servomotor for food-contact and high-pressure/high-temperature washdown areas, EHEDG and 3-A compliant, FDA-approved materials. 19 sizes available.'
WHERE name = 'AKMH — Servomoteur hygiénique inox' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Kollmorgen');

UPDATE products SET description_en = 'Frameless synchronous motor, integrated directly into the machine, which provides its own bearings to support the rotor. Variable air gap for high torque density and minimal cogging.'
WHERE name = 'KBM — Moteur-couple sans carcasse' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Kollmorgen');

-- ---- Lenze ----
UPDATE companies SET description_en = 'German family-owned company specializing in drive and automation technology for machine building: motors, gearboxes, inverters and engineering tools.'
WHERE name = 'Lenze' AND description_en IS NULL;

UPDATE products SET description_en = 'Three-phase geared motor for machine building and industrial conveying, available in helical, bevel and hollow-shaft versions. Operates on an inverter.'
WHERE name = 'g500 + m500 — Moteur-réducteur triphasé IE3' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Lenze');

UPDATE products SET description_en = 'Compact bevel geared motor, for machines needing a small footprint and moderate torques. Extends the g500 range toward the lower end of the power range.'
WHERE name = 'g500-B + MF — Moteur-réducteur conique compact' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Lenze');

UPDATE products SET description_en = 'Compact synchronous servomotor for applications requiring dynamics, accuracy and small footprint. Reference example: MCS12L41, 4.7 kW / 400 V AC / 11 Nm at 4,050 rpm.'
WHERE name = 'MCS — Servomoteur synchrone' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Lenze');

-- ---- Moog ----
UPDATE companies SET description_en = 'Precision actuators and valves for flight controls, defense and high-dynamic simulation.'
WHERE name = 'Moog' AND description_en IS NULL;

UPDATE products SET description_en = 'High-performance electrohydraulic servo valve. 120 Hz, accuracy <0.1%. Flight control reference.'
WHERE name = 'D633 Servovanne 2 étages' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Moog');

UPDATE products SET description_en = 'Electromechanical actuator for secondary and primary flight controls.'
WHERE name = 'EMA — Actionneur électromécanique' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Moog');

UPDATE products SET description_en = 'High-dynamic servomotor for flight simulators and test benches.'
WHERE name = 'Servomoteur haute dynamique' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Moog');

-- ---- Powell Electronics ----
UPDATE companies SET description_en = 'Value-added distributor of high-reliability electronic components for harsh environments: multi-brand connectors, switches, sensors and electromechanical products. Authorized distributor, QPL-qualified on more than 50 military specifications, ISO certified. Founded in 1946, more than 200 employees, 11 sites in the USA and presence in 6 European countries. Serves aerospace, defense, space, telecom, transportation and medical imaging.'
WHERE name = 'Powell Electronics' AND description_en IS NULL;

UPDATE products SET description_en = 'Distribution of sensors qualified for harsh environments (aerospace, defense, space, industrial).'
WHERE name = 'Capteurs pour environnements sévères' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Powell Electronics');

UPDATE products SET description_en = 'Distribution of multi-brand connectors qualified for harsh environments (aerospace, defense, space).'
WHERE name = 'Connecteurs haute fiabilité multi-marques' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Powell Electronics');

UPDATE products SET description_en = 'Distribution of electromechanical switches and relays qualified for critical applications.'
WHERE name = 'Interrupteurs & relais électromécaniques' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Powell Electronics');

-- ---- Regal Rexnord ----
UPDATE companies SET description_en = 'US industrial group, one of the world''s largest manufacturers of electric motors, power transmissions and motion solutions, born from the merger of Regal Beloit and Rexnord.'
WHERE name = 'Regal Rexnord' AND description_en IS NULL;

UPDATE products SET description_en = 'Electronically commutated motor (ECM) for residential/light commercial ventilation and air conditioning, the sector''s reference brand for more than 30 years. Constant torque/speed/airflow depending on variant.'
WHERE name = 'Genteq ECM — Moteur CVC à commutation électronique' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Regal Rexnord');

UPDATE products SET description_en = 'Standard NEMA/IEC AC motor from the historic Marathon brand (Regal Rexnord group), covering one of the widest power ranges on the market, from small commercial motors to heavy industrial motors.'
WHERE name = 'Marathon Motors — Moteur AC usage général' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Regal Rexnord');

UPDATE products SET description_en = 'Precision-balanced three-phase motor for severe environments (oil, gas, chemicals), IEEE841 compliant, designed for long life and high reliability in critical use.'
WHERE name = 'XRI Severe Duty — Moteur triphasé IEEE841' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Regal Rexnord');

-- ---- Safran Electrical & Power ----
UPDATE companies SET description_en = 'Avionics SSPC PDUs on a 270V DC bus for More Electric Aircraft. DO-160G certified.'
WHERE name = 'Safran Electrical & Power' AND description_en IS NULL;

UPDATE products SET description_en = 'Onboard electrical generator for commercial and military aircraft.'
WHERE name = 'Générateur de puissance avionique' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Safran Electrical & Power');

UPDATE products SET description_en = 'Custom wiring harnesses for avionics electrical systems.'
WHERE name = 'Harnais de câblage avionique' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Safran Electrical & Power');

UPDATE products SET description_en = 'SSPC avionics PDU on a 270V DC bus. Cut-off <1 ms, zero arc. For More Electric Aircraft.'
WHERE name = 'SSPC PDU 270V DC' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Safran Electrical & Power');

-- ---- Saft (TotalEnergies) ----
UPDATE companies SET description_en = 'World reference in high-reliability batteries for space, defense and aviation. Founded in 1918.'
WHERE name = 'Saft (TotalEnergies)' AND description_en IS NULL;

UPDATE products SET description_en = 'Containerized energy storage system for grids and industries.'
WHERE name = 'Intensium Max — ESS conteneurisé' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Saft (TotalEnergies)');

UPDATE products SET description_en = 'Space-qualified Li-ion cell for satellites and launch vehicles, Ariane heritage.'
WHERE name = 'MP 176065 — Li-ion Spatial' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Saft (TotalEnergies)');

UPDATE products SET description_en = 'DO-311A-certified Li-ion cell for aeronautics and defense. -55°C to +70°C.'
WHERE name = 'VL 45E — Li-ion Aviation' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Saft (TotalEnergies)');

-- ---- Sensata Technologies ----
UPDATE companies SET description_en = 'Current sensors, HV relays and pressure sensors for EVs. ISO 26262 ASIL-B certified.'
WHERE name = 'Sensata Technologies' AND description_en IS NULL;

UPDATE products SET description_en = 'Refrigerant pressure sensor for EV air-conditioning systems.'
WHERE name = 'Capteur de pression CPS pour HVAC' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Sensata Technologies');

UPDATE products SET description_en = '±500A HV Hall sensor for EV battery packs. ISO 26262 ASIL-B, 5 kV DC isolation.'
WHERE name = 'CS-HV500 Capteur ±500A' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Sensata Technologies');

UPDATE products SET description_en = 'High-voltage power relay for disconnecting EV battery packs.'
WHERE name = 'Relais haute tension HVR300' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Sensata Technologies');

-- ---- SITAEL ----
UPDATE companies SET description_en = 'Italian industrial company specializing in electric propulsion, satellite platforms and attitude sensors for LEO and GEO missions.'
WHERE name = 'SITAEL' AND description_en IS NULL;

UPDATE products SET description_en = 'SITAEL high-end microsatellite platform, all-electric with advanced electric propulsion, for Earth observation, telecommunications, IoT and scientific missions.'
WHERE name = 'S-350' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'SITAEL');

UPDATE products SET description_en = 'SITAEL entry-level microsatellite platform, all-electric, for multi-application missions (Earth observation, telecom, science, in-orbit demonstration).'
WHERE name = 'S-75' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'SITAEL');

UPDATE products SET description_en = 'SITAEL digital sun sensor for LEO and GEO orbits, intended for integration into attitude determination systems (ADCS).'
WHERE name = 'SITAEL Sun' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'SITAEL');

-- Contrôle : produits de ces entreprises encore sans description anglaise (doit être 0).
SELECT c.name AS entreprise, count(*) FILTER (WHERE p.description_en IS NULL) AS sans_anglais, count(*) AS total
FROM companies c LEFT JOIN products p ON p.company_id = c.id
WHERE c.name IN ('maxon', 'Rheinmetall', 'SEW-Eurodrive', 'Thales', 'Wittenstein', 'Allied Motion (Allient)', 'Alstom', 'Bradford ECAPS', 'Corvus Energy', 'Eaton', 'Forsee Power', 'GomSpace', 'GS Yuasa Technology (Space)', 'Kollmorgen', 'Lenze', 'Moog', 'Powell Electronics', 'Regal Rexnord', 'Safran Electrical & Power', 'Saft (TotalEnergies)', 'Sensata Technologies', 'SITAEL')
GROUP BY c.name ORDER BY c.name;
