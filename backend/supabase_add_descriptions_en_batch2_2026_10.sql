-- ============================================================
-- Traductions anglaises (description_en) — lot « batch2 », 2026-10
-- Entreprises : ACTIA Aerospace, Airbus Defence & Space
--
-- Sûr à relancer : ne remplit que les champs encore vides (IS NULL).
-- ============================================================

-- ---- ACTIA Aerospace ----
UPDATE companies SET description_en = 'Space and aeronautics division of the ACTIA group (Toulouse), heir to over 40 years of experience of its subsidiary STEEL Electronique. 300 employees, €81.7M revenue (2025), more than 2,500 space units in orbit and over 100 space missions: onboard computers, payload processing units, mass memories, DC/DC converters and GNSS receivers.'
WHERE name = 'ACTIA Aerospace' AND description_en IS NULL;

UPDATE products SET description_en = 'ACTIA Aerospace outdoor X-band (7.9-8.4 GHz) SSPA, 100W or 150W, rugged design for harsh environments, compliant with MIL-STD-188-164C.'
WHERE name = 'ASH100X / ASH150X' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace outdoor Ka-band (27.5-31 GHz) SSPA, 20W, GaN technology, compact and lightweight unit for tactical terminals.'
WHERE name = 'ASH20KA' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace outdoor Ka-band (27.5-31 GHz) SSPA, 40W, compact and highly reliable design for tactical terminals, qualified for harsh environments.'
WHERE name = 'ASH40KA' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace indoor X-band (7.9-8.4 GHz) SSPA, 1200W, GaN technology, high-performance liquid cooling.'
WHERE name = 'ASM1200X' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace outdoor X-band (7.9-8.4 GHz) SSPA, 600W, multi-carrier GaAs technology, with built-in 3+1 power supply redundancy.'
WHERE name = 'ASM600X' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace indoor X-band (7.9-8.4 GHz) SSPA, 250W, GaN technology, compact rack-mounted chassis with touchscreen interface.'
WHERE name = 'ASR250X' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace outdoor Q-band (43.5-45.5 GHz) TWTA, 140W, weatherproof, 1+1 switchover controller, optional integral linearizer and L-band converter.'
WHERE name = 'ATH140Q' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace outdoor Ka-band (27.5-31 GHz) TWTA, 250W, compact and lightweight, for fixed or transportable ground stations, optional L-band converter.'
WHERE name = 'ATH250KA' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace outdoor V-band (47.2-52.4 GHz) TWTA, 250W (up to 52.4 GHz), air or liquid cooling, integrated linearizer, 1+1 or 2+1 redundancy options.'
WHERE name = 'ATH250V / ATH250VE' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace outdoor Ku-band (12.75-14.5 GHz) TWTA, 400W, wideband multi-carrier operation, low-profile chassis for easy antenna mounting, version with integrated linearizer available.'
WHERE name = 'ATH400KU / ATH400KU-LIN' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace outdoor Ka-band (27.5-31 GHz) TWTA, 550W, air or liquid cooling, weatherproof for outdoor antenna mounting, 1+1 switchover controller.'
WHERE name = 'ATH550KA' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace outdoor Ka-band (27.5-31 GHz) TWTA, 750W, weatherproof, optional integral linearizer, L-band converter and 2+1 switchover controller.'
WHERE name = 'ATH750KA' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace outdoor Ku-band TWTA, 750W (up to 14.8 GHz for the H version), with integrated linearizer and 1+1 redundancy controller, low-profile chassis for easy antenna integration.'
WHERE name = 'ATH750KU / ATH750KUH' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace indoor X-band (7.9-8.4 GHz) TWTA, 2500W, 2-drawer architecture (RF + power supply) for easier integration and maintenance, air cooling with brushless motor.'
WHERE name = 'ATR2500X' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace indoor Ku-band (12.75-14.5 GHz) TWTA, 400W, compact rack-mounted chassis, optional integral linearizer and L-band upconverter.'
WHERE name = 'ATR400KU' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace electronic unit used to drive and control a cryocooler, in order to keep a detector at cryogenic temperature. The CCE can drive compact pulse-tube cryocoolers (e.g. Thales Cryogenics'' LPT6510 cooler).'
WHERE name = 'CCE — Cryocooler Electronics' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace range of Computer-On-Modules based on different Systems-On-Chip: COMODO-U with NanoXplore''s European radiation-hardened NG-Ultra technology, COMODO-V with the AMD/Xilinx Versal device. Intended for carrier-board integration in custom applications (OBC, payload data processing).'
WHERE name = 'COMODO' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace DREAM instrument (Miniaturized and Adaptable Energy Radiation Detector), based on silicon diode detectors, able to measure proton energy between 13 and 200 MeV and electron energy from 350 keV to 3 MeV.'
WHERE name = 'DREAM' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace control unit with a dual-core Zynq processor and a powerful FPGA fabric, integrating thermal control and power distribution for payload management.'
WHERE name = 'EGCU' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace high-performance mass memory and processing system, compliant with the ESA ADHA standard (cPCI Serial Space 3U-extended format), with a modular and flexible concept for mass memory and payload data processing (PDHU) applications.'
WHERE name = 'FURY' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'Low-cost integrated avionics computer from ACTIA Aerospace, available in a cold-redundant version or a single-string version for reduced-cost missions (no redundancy).'
WHERE name = 'HYPERION' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace instrument/payload control unit with a modular architecture combining off-the-shelf standard modules (flight-heritage boards) and custom hardware tailored to the instrument to be driven.'
WHERE name = 'ICU — Instrument Control Unit' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'High-performance, flexible ACTIA Aerospace processing module, designed mainly for CubeSats and nanosatellites. Beyond the processing core, the M-OBC unit offers a wide range of AOCS interfaces and is highly configurable for custom applications.'
WHERE name = 'M-OBC' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace payload mass memory unit with a modular architecture allowing redundancy and custom interfaces. Flown on the SWOT (Surface Water and Ocean Topography) mission.'
WHERE name = 'MYR-EV/SWOT' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace PC104-format onboard computer for multiple uses: nanosatellite central computer, payload data processing, instrument management.'
WHERE name = 'NINANO' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA Aerospace multi-constellation, multi-channel GNSS receiver, reinforced by a time synchronization system based on orbit determination. Compatible with LEO/MEO platforms, CubeSat-volume compliant.'
WHERE name = 'STRELLAN' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

UPDATE products SET description_en = 'ACTIA software suite for supervising and controlling SatCom systems (satellite gateways), with a microservices architecture, deployable in the cloud and running in a clustered environment. Three levels: Local Manager (single SatCom segment), Central Manager (complete SatCom system), Mission Planner (defining satellite carriers according to user needs).'
WHERE name = 'ZENYA' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ACTIA Aerospace');

-- ---- Airbus Defence & Space ----
UPDATE companies SET description_en = 'Airbus'' space division. Onboard batteries for GEO/LEO/MEO satellites: COSMO-BATT, ASTRO-BATT and STELLAR-BATT. More than 100 modules in flight. Prime contractor for the European Service Module (Artemis).'
WHERE name = 'Airbus Defence & Space' AND description_en IS NULL;

UPDATE products SET description_en = 'Airbus onboard computer for general satellite applications, designed for integration into low Earth orbit (LEO) SmallSat platforms.'
WHERE name = 'Amethyst' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = '3-axis fiber-optic inertial unit. More than 3 million flight hours and 100% mission success, LEO/MEO/GEO and deep-space probes.'
WHERE name = 'Astrix 1090' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'High-precision fiber-optic gyroscope for 15-year GEO missions. Bias stability < 0.0005°/h, noise 0.0001°/√h.'
WHERE name = 'Astrix 200' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Compact 3-axis fiber-optic gyroscope from the Astrix New Space range. 6 million cumulative flight hours on more than 40 satellites with no incident.'
WHERE name = 'Astrix NS' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Modular LEO battery for optical and radar missions of up to 12.5 years in orbit. Available in 30V, 50V and 100V with the same mechanical design. Qualified in mid-2024.'
WHERE name = 'ASTRO-BATT — LEO 30/50/100V' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Passive bi-axis sun sensor. Field of view ±90°, low mass (65 g), high thermal resistance. More than 290 units in orbit.'
WHERE name = 'BASS Bi-Axis Sun Sensor' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'High-accuracy star tracker that determines a satellite''s attitude by star recognition. Core of the AOCS-GNC system.'
WHERE name = 'Capteur stellaire AOCS — Star Tracker' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Control moment gyroscope (CMG) optimized for agile satellites up to 1 tonne. 45 Nm torque, 3°/s agility in less than 2 seconds.'
WHERE name = 'CMG 15-45' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Control moment gyroscope for 1 to 2 tonne satellites. 60 Nm torque, built-in micro-vibration dampers.'
WHERE name = 'CMG 40-60S' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'High-performance control moment gyroscope for agile satellites up to 3 tonnes. 75 Nm torque, patented compact design.'
WHERE name = 'CMG 75-75S' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Modular battery for GEO/MEO telecom and navigation satellites. 500–3,000 Wh modules. More than 300 units manufactured, >100 in flight on E3000-NEO, OneSat and Galileo.'
WHERE name = 'COSMO-BATT — Satellite GEO/NAV' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'COSMO-BATT battery module, version L (2,200 to 3,000 Wh), flown on E3000-NEO satellites. More than 300 units manufactured, more than 100 in flight.'
WHERE name = 'COSMO-BATT-L' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'COSMO-BATT battery module, version M (1,100 to 2,100 Wh), flown on OneSat satellites.'
WHERE name = 'COSMO-BATT-M' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'COSMO-BATT battery module, version S (500 to 1,000 Wh), flown on Galileo navigation satellites.'
WHERE name = 'COSMO-BATT-S' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Compact passive device (85 mm diameter, 53 mm height) ensuring that a satellite will not end up in uncontrolled rotation at end of life. Passive induction brake working on Earth''s magnetic field.'
WHERE name = 'Detumbler' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Onboard electronic unit for launch vehicles: power distribution, sequencing and telemetry during the flight phase.'
WHERE name = 'Électronique de lanceur — Launcher Electronics Unit' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Power processing unit (PPU), the core of the electric propulsion system (EPS). Power conditioning for Hall-effect thrusters and xenon management system.'
WHERE name = 'Elektro PPU NG1' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Evolution of the PPU NG1: power conditioning for Hall-effect thrusters with xenon/krypton fluid management.'
WHERE name = 'Elektro PPU NG2' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Airbus'' new-generation geostationary telecommunications platform, heir to more than 30 years of the Eurostar family. Scalable payload power and payload-centered design.'
WHERE name = 'Eurostar Neo' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'New-generation modular PCDU, the reference solution for Earth observation, scientific and interplanetary missions.'
WHERE name = 'EVO PCDU' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'LAUNCHER-BATT battery, version L, 60V ~1,600 Wh configuration. Selected by ArianeGroup for Ariane 6 (> 150 modules manufactured, > 30 flown on the first flight).'
WHERE name = 'LAUNCHER-BATT-L' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'LAUNCHER-BATT battery, version S, 30V ~260 Wh configuration, to power launcher units or pyrotechnic firing.'
WHERE name = 'LAUNCHER-BATT-S' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'PCDU based on proven automotive-grade components, modular design with competitive mass and volume, sized for LEO constellations.'
WHERE name = 'MEGA PCDU' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Multi-voltage power conditioning unit for geostationary orbit, scientific and telecom missions. GaN technology and digital control.'
WHERE name = 'MVPCU' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Control moment gyroscope package with scalable performance, singularity-free, with integrated control electronics. Covers 500 kg to more than 2 tonnes.'
WHERE name = 'Newton CMG Package' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Airbus'' "software-defined" geostationary telecommunications platform: coverage, capacity and frequency reconfigurable in orbit. All-electric propulsion, launchable in pairs. More than 10 satellites ordered.'
WHERE name = 'OneSat' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Lightweight, compact deployable solar panel for smallsats and constellations. More than 200 units delivered to MDA Space for the AURORA program.'
WHERE name = 'Panneau solaire déployable Sparkwing' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Power conditioning and distribution unit for GEO/LEO satellites. Power bus regulation, battery charging and distribution to payloads.'
WHERE name = 'PCDU — Power Conditioning & Distribution Unit' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Power conditioning unit for electric thrusters (Hall, ion). Converts the satellite bus into the voltages/currents required by the thruster.'
WHERE name = 'PPU — Power Processing Unit (propulsion électrique)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Power Supply Regulator qualified for telecom satellites. PSR 50V heritage, more than 80 units in flight on Alphabus, E3000, E3000-NEO and Galileo.'
WHERE name = 'PSR 100V MKII' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Airbus'' most compact and lightweight power and distribution unit. Unregulated nominal voltage 22-38V, up to 1.5 kW.'
WHERE name = 'PureLine Pearl' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Compact, flexible electric propulsion subsystem for New Space. 10-year lifetime in LEO, designed for station keeping and deorbiting.'
WHERE name = 'PureLine Topaz/THORs' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Agile actuator for satellite attitude control, enabling fast and precise pointing maneuvers.'
WHERE name = 'Roue de réaction agile — Reaction Wheel' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Rotary mechanism for continuously orienting solar panels toward the sun, with power transfer through a slip ring.'
WHERE name = 'SADM — Mécanisme d''entraînement panneaux solaires' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Lightweight deployable solar panel for smallsats and constellations. More than 200 units delivered to MDA Space for the AURORA program.'
WHERE name = 'Sparkwing' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Compact, cost-effective battery designed for mass-produced small-satellite constellations. Extensive standardization to reduce costs and lead times.'
WHERE name = 'STELLAR-BATT — Batterie constellation LEO' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'STELLAR-BATT module, version L, 30V from 900 to 3,600 Wh depending on modular configuration. More than 800 units manufactured, selected for OneWeb (630+ satellites).'
WHERE name = 'STELLAR-BATT-L' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'STELLAR-BATT module, version S, 30V ~1,700 Wh, external mounting with integrated radiator. Selected for the OneWeb constellation.'
WHERE name = 'STELLAR-BATT-S' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

UPDATE products SET description_en = 'Optical terminal for high-speed inter-satellite links, used for constellations and data relays.'
WHERE name = 'Terminal de communication laser inter-satellite' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Airbus Defence & Space');

-- Contrôle : produits de ces entreprises encore sans description anglaise (doit être 0).
SELECT c.name AS entreprise, count(*) FILTER (WHERE p.description_en IS NULL) AS sans_anglais, count(*) AS total
FROM companies c LEFT JOIN products p ON p.company_id = c.id
WHERE c.name IN ('ACTIA Aerospace', 'Airbus Defence & Space')
GROUP BY c.name ORDER BY c.name;
