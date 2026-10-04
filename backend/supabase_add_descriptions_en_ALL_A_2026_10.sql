-- ============================================================
-- Descriptions anglaises — fichier regroupé A (lots 1 à 4), 2026-10
-- À exécuter d'un seul coup dans l'éditeur SQL de Supabase.
-- Sûr à relancer : ne remplit que les champs encore vides (IS NULL).
-- Les fichiers regroupés A, B, C couvrent les 11 lots, dans cet ordre.
-- ============================================================

-- ######## Lot 1 ########
-- ---- Dongguan Jianchuang Electronic Technology Co., Ltd. ----
UPDATE companies SET description_en = 'Dongguan Jianchuang Electronic Technology manufactures custom thick film ceramic circuits, printed resistors, sensor cards and thick film heaters for OEM electronics. We support prototypes and production batches.'
WHERE name = 'Dongguan Jianchuang Electronic Technology Co., Ltd.' AND description_en IS NULL;

UPDATE products SET description_en = 'Custom thick film ceramic circuits, printed resistors, sensor cards and thick film heaters for OEM electronics.'
WHERE name = 'Custom Thick Film Ceramic Circuits and Heaters' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Dongguan Jianchuang Electronic Technology Co., Ltd.');

-- ---- EREMS ----
UPDATE companies SET description_en = 'French SME founded in 1979, specializing in the design and manufacture of flight and ground electronic equipment for space, defense, aeronautics and nuclear applications: onboard computers, PCDUs, battery systems and electric propulsion. Its equipment flies on SVOM, Kinéis, Pléiades Neo, SWOT and MicroCarb/CO3D.'
WHERE name = 'EREMS' AND description_en IS NULL;

UPDATE products SET description_en = 'EREMS power distribution unit for the ACES (Atomic Clock Ensemble in Space) payload, which carries two high-performance atomic clocks (PHARAO and SHM) and is installed on the International Space Station.'
WHERE name = 'ACES — Power Distribution Unit' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EREMS');

UPDATE products SET description_en = 'EREMS power supply unit for the MicroWave Link of the ACES payload, made up of a flight segment (MWL-FS) and its associated antennas.'
WHERE name = 'ACES-MWL — Power Supply Unit' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EREMS');

UPDATE products SET description_en = 'BoMo modular boxes, co-developed by EREMS and CNES as the competitive mini-satellite market takes off.'
WHERE name = 'BoMo — Modular Boxes' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EREMS');

UPDATE products SET description_en = 'New generation of EREMS''s ICARE-NG2 control module, designed to address component obsolescence (including the choice of microcontroller) and to remain compatible with satellite TM/TC buses.'
WHERE name = 'CPU BOARD — Control and Processing Unit' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EREMS');

UPDATE products SET description_en = 'High-performance EREMS processor board built on radiation-hardened components, designed for space applications in collaboration with CNES.'
WHERE name = 'CPUGEN' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EREMS');

UPDATE products SET description_en = 'EREMS DC/DC converter module that supplies power to the modular control unit (ICU).'
WHERE name = 'DCDC Converter Unit' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EREMS');

UPDATE products SET description_en = 'EREMS converter board based on an isolated DC/DC architecture with a GaN (gallium nitride) transistor, intended for integration into space power distribution systems.'
WHERE name = 'GAN — Converter Board' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EREMS');

UPDATE products SET description_en = 'EREMS CPU module that handles telemetry/telecommand (TM/TC) functions and runs dedicated software computations, designed to be integrated into a modular control unit (ICU).'
WHERE name = 'GR740 Module' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EREMS');

UPDATE products SET description_en = 'IPE equipment developed by EREMS, responsible for generating and supplying power to the optical sensor''s front-end electronics.'
WHERE name = 'IPE' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EREMS');

UPDATE products SET description_en = 'EREMS modular Instrument Control Unit for the space market: scientific satellites, probes, Earth observation programs, and exploration or security missions.'
WHERE name = 'Modular ICU' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EREMS');

UPDATE products SET description_en = 'EREMS FPGA module that can run standalone or be powered and supervised by other modules, designed specifically for use within a modular control unit (ICU).'
WHERE name = 'NG Medium Module' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EREMS');

UPDATE products SET description_en = 'Power Conditioning and Distribution Unit developed by EREMS for the MMX (Martian Moons eXploration) project, managing all of the rover''s electrical power.'
WHERE name = 'PCDU MMX' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EREMS');

UPDATE products SET description_en = 'EREMS Power Conditioning and Distribution Unit for nanosatellites, CubeSat-compliant, with a modular architecture of 4 main modules enabling fast multi-mission commissioning (6U to 27U).'
WHERE name = 'PCDU NANO' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EREMS');

UPDATE products SET description_en = 'Flight equipment designed and developed by EREMS, which switches all thruster and XFC electrical signals from two power processing units (PPUs) to one thruster.'
WHERE name = 'PPSU — Plasma Propulsion Selection Unit' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EREMS');

UPDATE products SET description_en = 'More than 2,400 electronic battery-balancing modules supplied by EREMS to SAFT for the Iridium NEXT constellation.'
WHERE name = 'SBS IRIDIUM NEXT — Battery Modules' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EREMS');

UPDATE products SET description_en = 'EREMS unit in charge of powering and controlling the instrument, as well as the scientific processing of the front-end camera data and the generation of the alert trigger signal.'
WHERE name = 'UGTS — Unité de Gestion et de Traitement Scientifique' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EREMS');

-- ---- Colossus Compute ----
UPDATE companies SET description_en = 'US manufacturer of radiation-hardened computing, storage and networking systems for space (LEO, MEO, GEO, lunar and beyond). Radiation-tolerant architecture: hardened circuits, error-correcting memory (ECC), lockstep redundant CPUs, watchdogs and built-in recovery mechanisms — designed for advanced onboard processing, including onboard AI.'
WHERE name = 'Colossus Compute' AND description_en IS NULL;

UPDATE products SET description_en = 'Interconnect expansion card (SERDES and LVDS) for Colossus-range computers.'
WHERE name = 'Cygnus' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Colossus Compute');

UPDATE products SET description_en = 'PCIe and MIPI expansion card for Colossus-range computers.'
WHERE name = 'Draco' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Colossus Compute');

UPDATE products SET description_en = '1G Ethernet and power distribution expansion card for Colossus-range computers.'
WHERE name = 'Eridanus' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Colossus Compute');

UPDATE products SET description_en = 'Space-hardened onboard computer based on the NVIDIA Orin AGX chip, for onboard edge AI processing.'
WHERE name = 'Falcon' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Colossus Compute');

UPDATE products SET description_en = '10G Ethernet expansion card for Colossus-range computers.'
WHERE name = 'Fornax' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Colossus Compute');

UPDATE products SET description_en = 'Radiation-hardened NAND memory controller for space applications.'
WHERE name = 'Pelican' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Colossus Compute');

UPDATE products SET description_en = 'Space-hardened 10G Ethernet or optical switch, 10 ports.'
WHERE name = 'Puma' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Colossus Compute');

UPDATE products SET description_en = 'Space-hardened 1G Ethernet switch, 8 ports.'
WHERE name = 'Razorback' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Colossus Compute');

UPDATE products SET description_en = 'Onboard storage module with 8 SSD slots and adjustable RAID, for the space environment.'
WHERE name = 'Spirit' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Colossus Compute');

UPDATE products SET description_en = 'High-performance onboard computer based on the NVIDIA Thor AGX chip, for intensive onboard AI workloads.'
WHERE name = 'Vulture' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Colossus Compute');

UPDATE products SET description_en = 'High-density onboard computer based on the AMD Versal chip, for intensive onboard AI workloads.'
WHERE name = 'Wasp' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Colossus Compute');

UPDATE products SET description_en = 'Onboard computer based on the AMD Versal chip, geared toward onboard edge AI processing.'
WHERE name = 'Yellowjacket' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Colossus Compute');

-- ---- Infineon Technologies ----
UPDATE companies SET description_en = 'SiC, IGBT and GaN power semiconductors for onboard chargers and traction inverters.'
WHERE name = 'Infineon Technologies' AND description_en IS NULL;

UPDATE products SET description_en = '1200V SiC MOSFET module for onboard chargers and inverters. 50% lower losses than IGBT, 300 kHz max.'
WHERE name = 'CoolSiC MOSFET 1200V' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Infineon Technologies');

UPDATE products SET description_en = 'Gate driver circuit for driving SiC and IGBT modules.'
WHERE name = 'Driver de grille EiceDRIVER' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Infineon Technologies');

UPDATE products SET description_en = 'IGBT module for traction inverters and industrial applications.'
WHERE name = 'Module IGBT EasyPACK' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Infineon Technologies');

-- ######## Lot 2 ########
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

-- ######## Lot 3 ########
-- ---- Delta Electronics ----
UPDATE companies SET description_en = 'Bidirectional onboard chargers up to 22 kW for heavy-duty EVs. V2G supported. Efficiency >94%. IP67.'
WHERE name = 'Delta Electronics' AND description_en IS NULL;

UPDATE products SET description_en = 'Isolated DC/DC converter for 800V electric vehicle architectures.'
WHERE name = 'Convertisseur DC/DC haute tension' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Delta Electronics');

UPDATE products SET description_en = '22 kW bidirectional onboard charger for EV buses and trucks. V2G, ISO 15118, IP67.'
WHERE name = 'OBC 22 kW Bidirectionnel V2G' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Delta Electronics');

UPDATE products SET description_en = 'Three-phase solar inverter for commercial photovoltaic installations.'
WHERE name = 'Onduleur solaire M70A' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Delta Electronics');

-- ---- Nidec ----
UPDATE companies SET description_en = 'World number one in electric motors. Integrated eAxle for EVs up to 200 kW.'
WHERE name = 'Nidec' AND description_en IS NULL;

UPDATE products SET description_en = 'eAxle system integrating motor, inverter and reduction gear for EVs.'
WHERE name = 'eAxle intégré 150kW' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Nidec');

UPDATE products SET description_en = 'Permanent-magnet synchronous servomotor for robotics and automation.'
WHERE name = 'Servomoteur PMSM industriel' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Nidec');

-- ---- Amphenol ----
UPDATE companies SET description_en = 'World leader in connectors. MIL-DTL-38999, RF and fiber-optic connectors for defense and aerospace.'
WHERE name = 'Amphenol' AND description_en IS NULL;

UPDATE products SET description_en = 'Ruggedized fiber-optic connector for high-speed defense data transmission.'
WHERE name = 'Connecteur fibre optique militaire' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Amphenol');

UPDATE products SET description_en = 'SMA RF connector for radar and tactical communication applications.'
WHERE name = 'Connecteur RF SMA durci' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Amphenol');

UPDATE products SET description_en = 'Military circular connector. Reference standard for defense and aerospace. MIL-STD-810 resistance.'
WHERE name = 'MIL-DTL-38999 Série III' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Amphenol');

-- ---- DHV Technology ----
UPDATE companies SET description_en = 'Spanish manufacturer of solar panels, electrical power systems (EPS) and PCDUs for CubeSats and small satellites, as well as solar array drive mechanisms (SADA).'
WHERE name = 'DHV Technology' AND description_en IS NULL;

UPDATE products SET description_en = 'DHV Technology Power Conditioning and Distribution Unit for smallsat platforms, with deployment control and maximum power point tracking (MPPT) functions.'
WHERE name = 'DHV PCDU — Power Conditioning and Distribution System' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'DHV Technology');

UPDATE products SET description_en = 'DHV Technology Electrical Power System designed for integration into nano-format CubeSat platforms.'
WHERE name = 'NANO EPS' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'DHV Technology');

UPDATE products SET description_en = 'DHV Technology Electrical Power System designed for integration into very small CubeSat platforms.'
WHERE name = 'PICO EPS' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'DHV Technology');

-- ---- Anywaves ----
UPDATE companies SET description_en = 'CNES spin-off based in Toulouse, designer and manufacturer of antennas and RF electronics for space: TT&C, data link, navigation, launcher and payload antennas, software-defined radios (VILSA range) and low-noise RF electronics. More than 2,000 RF products delivered on 200+ missions. EN 9100 certified, ITAR-free products.'
WHERE name = 'Anywaves' AND description_en IS NULL;

UPDATE products SET description_en = 'Reflectarray antenna for high-gain payload applications.'
WHERE name = 'Antenne à réseau réflecteur' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'Wide-beam X-band antenna for data links.'
WHERE name = 'Antenne bande X à faisceau large' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'High-gain X-band antenna for high-speed data links.'
WHERE name = 'Antenne bande X haut gain' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'Compact flight-proven (TRL 9) antenna for payload telemetry from a LEO satellite, 7.9–8.5 GHz, 15.5 dBi gain, 100×100 mm footprint.'
WHERE name = 'Antenne compacte bande X' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'Dual-polarization variant (simultaneous LHCP and RHCP on separate connectors) of the compact X-band antenna.'
WHERE name = 'Antenne compacte bande X bi-polarisation' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'Quad-ridged horn antenna, wideband.'
WHERE name = 'Antenne cornet à crêtes croisées' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'Navigation antenna dedicated to the GNSS L1/E1 bands.'
WHERE name = 'Antenne GNSS bandes L1/E1' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'Navigation antenna covering all GNSS bands.'
WHERE name = 'Antenne GNSS multi-bandes' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'Multi-band GNSS antenna with an integrated low-noise amplifier (LNA) board.'
WHERE name = 'Antenne GNSS multi-bandes avec LNA intégré' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'Quadrifilar helix antenna.'
WHERE name = 'Antenne hélice quadrifilaire' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'S-band telemetry antenna for launch vehicles.'
WHERE name = 'Antenne lanceur bande S' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'Multi-band GNSS navigation antenna for launch vehicles.'
WHERE name = 'Antenne lanceur GNSS multi-bandes' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'Slotted waveguide array antenna for payload applications.'
WHERE name = 'Antenne réseau à guide d''ondes à fentes' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'Direct-radiating array antenna for payload applications.'
WHERE name = 'Antenne réseau à rayonnement direct' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'Ka-band telemetry, tracking and command (TT&C) antenna.'
WHERE name = 'Antenne TT&C bande Ka' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'S-band telemetry, tracking and command (TT&C) antenna.'
WHERE name = 'Antenne TT&C bande S' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'Compact S-band telemetry, tracking and command (TT&C) antenna.'
WHERE name = 'Antenne TT&C bande S compacte' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'Compact wideband antennas for payload applications.'
WHERE name = 'Antennes compactes large bande' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'Ground test equipment for functional RF validation of multi-band GNSS antennas once integrated on the satellite.'
WHERE name = 'Banc de test bande GNSS multi-bandes' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'Ground test equipment for functional RF validation of S-band TT&C antennas once integrated on the satellite.'
WHERE name = 'Banc de test bande S TT&C' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'Ground test equipment for functional RF validation of X-band antennas once integrated on the satellite.'
WHERE name = 'Banc de test bande X' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'Low-noise block downconverter (LNB) for RF reception.'
WHERE name = 'Convertisseur bas bruit (LNB)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'Software-defined radio (SDR) from the VILSA range for onboard signal processing.'
WHERE name = 'VILSA — Radio logicielle (SDR)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

UPDATE products SET description_en = 'X-band downlink transmitter from the VILSA range.'
WHERE name = 'VILSA XDL — Émetteur liaison descendante bande X' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Anywaves');

-- ---- ABB ----
UPDATE companies SET description_en = 'Global reference in automation and drives. ACS drives, HXR motors. Revenue ~$32bn.'
WHERE name = 'ABB' AND description_en IS NULL;

UPDATE products SET description_en = 'DTC industrial drive. 0.75–5,600 kW range. Efficiency >98%. Profibus, PROFINET.'
WHERE name = 'ACS880 — 0,75–5 600 kW' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ABB');

UPDATE products SET description_en = 'High-voltage induction motor for heavy industrial applications.'
WHERE name = 'Moteur HXR haute tension' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ABB');

UPDATE products SET description_en = '6-axis industrial robot for high-payload handling and welding.'
WHERE name = 'Robot industriel IRB 6700' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ABB');

-- ---- Emerson (Fisher) ----
UPDATE companies SET description_en = 'Fisher brand: process control valves. FIELDVUE digital positioners. Oil & gas, chemicals.'
WHERE name = 'Emerson (Fisher)' AND description_en IS NULL;

UPDATE products SET description_en = 'Smart digital positioner for control valves, with built-in diagnostics.'
WHERE name = 'Positionneur numérique FIELDVUE DVC6200' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Emerson (Fisher)');

UPDATE products SET description_en = 'Globe process control valve, an industry reference in oil & gas and chemicals.'
WHERE name = 'Vanne de contrôle Fisher easy-e' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Emerson (Fisher)');

-- ---- CubeSpace ----
UPDATE companies SET description_en = 'South African specialist in ADCS (attitude determination and control) systems for CubeSats and SmallSats: reaction wheels, magnetorquers, sun sensors, star trackers.'
WHERE name = 'CubeSpace' AND description_en IS NULL;

UPDATE products SET description_en = 'High-precision fine sun sensor for attitude determination on CubeSats and SmallSats.'
WHERE name = 'Fine Sun Sensor' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CubeSpace');

UPDATE products SET description_en = 'Rugged reaction wheel with in-house CW0500 motor, for CubeSats and SmallSats. Automated laser balancing, integrated magnetic shielding.'
WHERE name = 'Roue de réaction CW0500' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CubeSpace');

-- ---- HarnessTech ----
UPDATE companies SET description_en = 'New Zealand manufacturer specializing in wiring harnesses for the space industry — satellite and launch vehicle makers. Small dedicated team, work to IPC/WHMA-A-620 standards, from one-off prototypes to series production, with design support.'
WHERE name = 'HarnessTech' AND description_en IS NULL;

UPDATE products SET description_en = 'Design and manufacture of custom wiring harnesses for space vehicles and launchers, from one-off prototypes to small or large series production. Design review included: improving methods, components and solutions before manufacturing.'
WHERE name = 'Harnais de câblage sur mesure — spatial & lanceurs' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'HarnessTech');

-- ---- SpaceLocker ----
UPDATE companies SET description_en = 'French operator offering a patented "universal space port" technology that lets several independent payloads be hosted on the same shared satellite, like a USB port.'
WHERE name = 'SpaceLocker' AND description_en IS NULL;

UPDATE products SET description_en = 'SpaceLocker''s first own satellite: a 16U CubeSat integrating the patented "universal space port" technology, allowing several independent customer payloads to be hosted on a single shared satellite.'
WHERE name = 'Out of the Box' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'SpaceLocker');

-- ---- ISISPACE ----
UPDATE companies SET description_en = 'Dutch manufacturer of flight-proven CubeSat subsystems, including IOBC onboard computers, deployers and nanosatellite platforms.'
WHERE name = 'ISISPACE' AND description_en IS NULL;

UPDATE products SET description_en = '12U/16U CubeSat bus equipped with latest-generation subsystems, configurable for in-orbit demonstration (IoD), high-precision Earth observation, high-speed RF communications or deep-space missions.'
WHERE name = 'CubeSat 12U/16U Bus' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ISISPACE');

UPDATE products SET description_en = 'Flight-heritage 6U CubeSat platform, customizable for different missions (in-orbit demonstration, Earth observation, communications).'
WHERE name = 'CubeSat 6U Platform' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ISISPACE');

UPDATE products SET description_en = 'ISISPACE flight-proven onboard computer for CubeSats, with very low mass and low power consumption, designed for integration into nanosatellite platforms.'
WHERE name = 'IOBC' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ISISPACE');

-- ---- EaglePicher Technologies ----
UPDATE companies SET description_en = 'Long-standing battery supplier for space and the US defense sector. 100+ years of experience. NASA programs JPSS-2, ICESat-2, MEV.'
WHERE name = 'EaglePicher Technologies' AND description_en IS NULL;

UPDATE products SET description_en = 'Long-life primary battery for probes and missions without recharging.'
WHERE name = 'Batterie primaire Li-SOCl2 spatiale' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EaglePicher Technologies');

UPDATE products SET description_en = 'Instant-activation thermal battery for defense systems.'
WHERE name = 'Batterie thermique pour défense' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EaglePicher Technologies');

UPDATE products SET description_en = '7.9 kWh / 29.6V Li-ion pack for the JPSS-2 satellite (NASA/NOAA). GS Yuasa LSE134 Gen III cells. Based on proven GEOStar-3 and ICESat-2 platforms.'
WHERE name = 'JPSS-2 Battery — 7,9 kWh / 29,6V' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EaglePicher Technologies');

-- ---- Rotork ----
UPDATE companies SET description_en = 'Electric, pneumatic and hydraulic actuators for oil & gas, water and chemicals.'
WHERE name = 'Rotork' AND description_en IS NULL;

UPDATE products SET description_en = 'Double-acting pneumatic actuator for on/off valves.'
WHERE name = 'Actionneur pneumatique série GP' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Rotork');

UPDATE products SET description_en = 'IQ3 multi-turn electric actuator. Built-in diagnostics, Profibus/Modbus. IP68. ATEX option.'
WHERE name = 'IQ3 Actionneur Électrique' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Rotork');

UPDATE products SET description_en = 'Gear operator for manual operation of heavy valves.'
WHERE name = 'Réducteur manuel série GD' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Rotork');

-- ---- Blue Solutions ----
UPDATE companies SET description_en = 'The only company in the world producing all-solid-state batteries in series. Patented LMP technology.'
WHERE name = 'Blue Solutions' AND description_en IS NULL;

UPDATE products SET description_en = 'All-solid-state lithium metal polymer cell, Blue Solutions patented technology.'
WHERE name = 'Cellule LMP tout-solide' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Blue Solutions');

UPDATE products SET description_en = 'Stationary LMP storage module for industrial sites and electric buses.'
WHERE name = 'Module Bluestorage 35 kWh' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Blue Solutions');

-- ---- ABL Space Systems ----
UPDATE companies SET description_en = 'US small-launcher company; the RS1 range is designed for simple manufacturing and transport in standard containers.'
WHERE name = 'ABL Space Systems' AND description_en IS NULL;

UPDATE products SET description_en = 'ABL Space Systems light launch vehicle, each stage sized to fit in a standard shipping container (easier transport by air, land or sea).'
WHERE name = 'RS1' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'ABL Space Systems');

-- ---- Hemeria ----
UPDATE companies SET description_en = 'French equipment maker and integrator of nano/microsatellites, stratospheric balloons and satellite equipment (structures, harnesses, solar panels).'
WHERE name = 'Hemeria' AND description_en IS NULL;

UPDATE products SET description_en = 'Hemeria SPARTA-G70 microsatellite platform, the most advanced in the range, for missions requiring the greatest onboard capacity.'
WHERE name = 'SPARTA-G70 — Plateforme microsatellite avancée' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Hemeria');

UPDATE products SET description_en = 'Hemeria SPECTRA-L40 nanosatellite platform, designed for Earth observation and telecommunication missions in low Earth orbit.'
WHERE name = 'SPECTRA-L40 — Plateforme nanosatellite' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Hemeria');

UPDATE products SET description_en = 'Hemeria SPRINT-L60 microsatellite platform, an intermediate segment between nano and microsatellites for missions with greater power and payload demands.'
WHERE name = 'SPRINT-L60 — Plateforme microsatellite' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Hemeria');

-- ######## Lot 4 ########
-- ---- CAVU Aerospace UK ----
UPDATE companies SET description_en = 'British company specializing in space avionics (ESA Entity No. 1000042906). Designer and manufacturer of flight-proven onboard computers (OBCs) for satellites and launch vehicles: from the OBC-Polar CubeSat to the OBC 64 based on Microchip''s HPSC RISC-V technology. Supplier of thermal systems, frame grabbers and satellite cameras since 2016.'
WHERE name = 'CAVU Aerospace UK' AND description_en IS NULL;

UPDATE products SET description_en = 'Complete SpaceVPX backplane for multi-board chassis. High-speed PCIe Gen3, 10 GbE and SpaceWire interconnect between all boards in the chassis (OBC, storage, FG, PSU). Designed for the space environment: reduced outgassing, vibration and radiation tolerance.'
WHERE name = 'BackPlane SpaceVPX — Backplane haute vitesse complet' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Flight-proven optical payload for high-resolution Earth observation (panchromatic, multispectral, hyperspectral). Available in 5, 16 and 51 megapixels. 60 mm lens, LVDS + RS422 + Ethernet interface. 12-bit RAW + JPEG format. Hardware acceleration on PolarFire SoC FPGA. CubeSat formats: 2U, 3U, 12U.'
WHERE name = 'Caméra satellite s.LDU.345 (5–51 MP, PAN/MS/HS)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Redundant, flight-proven command and data handling (C&DH) system. Robust architecture with a nominal and a backup path, autonomously fault-tolerant. Designed for missions requiring a high level of mission safety. SpaceWire, CAN and RS-422 interfaces.'
WHERE name = 'CDH-FS — Système C&DH redondant flight-proven' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Baseline-level command and data handling (C&DH) module. Handles telemetry and telecommand routing, real-time clock management and housekeeping data storage.'
WHERE name = 'CDH1 — Module C&DH baseline' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = '30% efficiency GaAs (gallium arsenide) triple-junction solar cell for space applications. Designed for space radiation environments (LEO, MEO, GEO). Compatible with CAVU solar panel assemblies and Omni-P PCDUs.'
WHERE name = 'Cellule solaire spatiale GaAs 30% Triple-Junction' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'High-efficiency 32% AM0 GaAs triple-junction solar cell for demanding space applications. The best version in the CAVU range, optimized to maximize power per unit area. Ideal for compact satellites needing maximum energy in a limited volume.'
WHERE name = 'Cellule solaire spatiale GaAs 32% Triple-Junction' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Onboard mass data and video recorder for satellites. Large storage capacity, multiple interfaces for imaging payloads and OBCs. Designed for Earth observation missions that need to store large quantities of images before passing over a ground station.'
WHERE name = 'Enregistreur de données et vidéo embarqué' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Embedded Processing Card (EPC-1010) for onboard data processing. Designed to interface with instruments and payloads, with real-time data management and flexible acquisition interfaces.'
WHERE name = 'EPC-1010 — Carte de traitement embarqué' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Onboard Frame Grabber card for acquiring and pre-processing video streams from payload cameras. CameraLink interface. Hardware compression, reformatting of image data before storage or transmission. Compatible with CAVU OBCs.'
WHERE name = 'FG-1 — Frame Grabber embarqué' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Advanced Frame Grabber based on the PolarFire SoC FPGA. Hardware acceleration of image pipelines (zero-compression 12-bit Bayer RAW pipeline, real-time cropping). 4-lane MIPI CSI-2 integration for NVIDIA Jetson. Radiation-resistant thanks to ZeroFIT FPGA flash.'
WHERE name = 'FG-Polar — Frame Grabber PolarFire SoC' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Onboard video recording and processing subsystem for observation missions. Captures and compresses high-resolution video streams from payload cameras. Can be integrated with CAVU OBCs and RavenEye cameras.'
WHERE name = 'FireFrame-1 — Enregistreur vidéo embarqué' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Control and interface unit for onboard scientific instruments (ICU). Manages the instrument life cycle: power-up, sequencing, calibration, data acquisition and safe switching. Designed for institutional and scientific ESA/NASA missions.'
WHERE name = 'Instrument Control Unit — Unité de contrôle instrument' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Compact Telemetry, Tracking and Command (TT&C) subsystem for CubeSats. Handles housekeeping downlink, uplink telecommands and ranging. Optimized CubeSat format, low power consumption.'
WHERE name = 'Nano-TTC — Sous-système TT&C CubeSat' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Compact X-band transmitter in PC-104 format for CubeSats and small satellites. 8.0–8.4 GHz frequency, configurable in flight. RF power 23–33 dBm (adjustable in 1 dB steps). Consumption <15 W. DQPSK/QPSK/32-APSK modulations, CCSDS coding. Data rates 1M–30M symbols/s. CAN, RS232, RS422, LVDS and SPI interfaces.'
WHERE name = 'NANO-X — Émetteur X-band CubeSat (PC-104)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'New-generation onboard computer based on the Microchip PIC64-HPSC processor (8× SiFive X280 RISC-V cores). ~26,000 DMIPS, up to 2 TOPS (INT8) / 1 TFLOPS (bf16). ECC DDR4 memory, 10GbE/TSN, PCIe Gen3 ×8, 7-port SpaceWire interfaces. HPSC partnership with Microchip for the most demanding space missions.'
WHERE name = 'OBC-64 — Calculateur HPSC RISC-V (26 000 DMIPS)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Onboard computer in PC/104 format, the industry standard recognized for CubeSat integration. Robust architecture with radiation mitigation and support for classic space interfaces (CAN, RS-422, I2C, SPI). Compatible with the CAVU and third-party PC/104 daughter-board ecosystem.'
WHERE name = 'OBC-Cube-104 — Calculateur PC/104 CubeSat' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'High-performance variant of the OBC-Polar coupled with an NVIDIA Jetson Orin NX for AI/ML inference in orbit. PolarFire SoC (MPFS250T or MPFS460T, 4× 64-bit RISC-V). Can be used as the main OBC of a launch vehicle. Same footprint as the OBC-Polar, with doubled AI performance thanks to the FPGA + GPU combination.'
WHERE name = 'OBC-Hyper Polar — OBC CubeSat & Lanceur (AI/ML)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Advanced onboard computer developed by CAVU Aerospace for demanding satellite applications. Includes extended data processing features and is compatible with the main space interfaces. Designed for high-performance scientific and Earth observation missions.'
WHERE name = 'OBC-Johnston — Calculateur embarqué avancé' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'High-performance onboard computer for CubeSat missions. Based on the Microchip PolarFire SoC FPGA (flash, SEU-immune ZeroFIT). >4,000 DMIPS, large ECC RAM, MRAM/FRAM memories. Multi-lane CameraLink interfaces with FrameGrabber. Supported OSes: Linux, INTEGRITY, FreeBSD, VxWorks. NRE-free customization.'
WHERE name = 'OBC-Polar — Calculateur CubeSat PolarFire SoC' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = '2nd-generation professional OBC for commercial and scientific satellites. Higher performance than the OBC1, better memory management and extended interfaces. Ideal for MEO/LEO missions requiring intensive onboard data processing.'
WHERE name = 'OBC-PRO2 — Calculateur professionnel 2ème génération' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Baseline onboard computer of the CAVU range. Robust and proven, it is the processing core for small satellites and CubeSats. Supports standard space interfaces and offers an optimized power consumption profile.'
WHERE name = 'OBC1 — Calculateur embarqué baseline' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Supervisor board for the CAVU OBC1. Monitors the state of the main computer and triggers autonomous reconfigurations and restarts in case of failure. Essential for long-duration autonomous missions requiring an advanced watchdog.'
WHERE name = 'OBC1 Supervisor — Carte de supervision' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Ultra-compact OBC module for integration into space-constrained systems. Ideal for nanosatellites, PocketQubes and onboard instruments. Low power consumption, miniaturized interfaces.'
WHERE name = 'OBCM — Module OBC ultra-compact' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Dedicated payload processing unit for onboard scientific instruments. Acts as the interface between the instrument and the OBC: acquisition, calibration, compression and packetization of scientific data. RS-422, SpaceWire and MIL-STD-1553 interfaces depending on configuration.'
WHERE name = 'Payload Process-1 — Unité de traitement payload' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Complete range of all-in-one PCDUs (Omni-P1/P2/P3) for CubeSats to small satellites. Omni-P1: regulated 3.3V/5V/12V, 10 LCLs, up to 20 Wh integrated battery. Omni-P2: unregulated 28 V bus. Omni-P3: up to 1,500 W with 100V+28V bus, redundant CAN/RS422, FPGA-based. Integrated MPPT, compatible with CAVU solar panels. ITAR-free, TRL9.'
WHERE name = 'PCDU Omni-P — Power Conditioning & Distribution (1–1500 W)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = '3U SpaceVPX (VITA 78 / SOSA) computer based on PolarFire SoC (MPFS460T/TS). SEU-immune ZeroFIT FPGA flash, no scrubbing. 4× 64-bit RISC-V, 20 GB ECC RAM, redundant 512 GB eMMC, 20 SERDES lanes (PCIe Gen2, 10G XFI, JESD204B). Onboard AI: 279 GOPs INT8, expandable to 1+ TOPS across multiple boards.'
WHERE name = 'PF-VPX OBC — Calculateur 3U SpaceVPX PolarFire' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Onboard AI supercomputer for CubeSats combining a PolarFire SoC FPGA (ZeroFIT SEU-immune) and an NVIDIA Jetson Xavier NX 16 GB. 16 GB LPDDR5 VRAM. OBC memory: 4 GB ECC DDR4 + 2× 256 GB eMMC + MRAM/QSPI. AI image processing in orbit (multi-model inference), 4-lane PCIe CSI-2 acceleration.'
WHERE name = 'Polar Edge – High End — Super-calculateur IA CubeSat' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Onboard SpaceWire switch for intra-satellite communication architectures. Enables dynamic data routing between OBC, payloads and instruments over the SpaceWire bus (ECSS-E-ST-50-12C). Based on PolarFire SoC, ZeroFIT SEU immunity. Compatible with CAVU boards and third-party SpaceWire components.'
WHERE name = 'PolarComm-Switch — Switch SpaceWire embarqué' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'SpaceVPX (3U) mass storage module with 2 NVMe slots. Designed for high-data-density space VPX architectures. PCIe Gen3/4 interface, radiation hardening, support for CCSDS commands for satellite data management.'
WHERE name = 'PolarStore-2N — Stockage SpaceVPX 2 slots NVMe' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'SpaceVPX (3U) mass storage module with 2 SATA/eMMC SSD slots. Compatible with SpaceVPX VITA 78 architectures. Radiation protection option and CCSDS interfaces for data downlink.'
WHERE name = 'PolarStore-2S — Stockage SpaceVPX 2 slots SSD' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'SpaceVPX (3U) mass storage module with 4 NVMe slots. Double the capacity of the PolarStore-2N. Ideal for hyperspectral or high-resolution imaging payloads that need a large volume of fast storage before downlink to the ground.'
WHERE name = 'PolarStore-4N — Stockage SpaceVPX 4 slots NVMe' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'SpaceVPX (3U) mass storage module with 4 SSD slots. High capacity, low cost per GB. Suited to missions with budget constraints that still need substantial mass storage.'
WHERE name = 'PolarStore-4S — Stockage SpaceVPX 4 slots SSD' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = '3U SpaceVPX (Power VPX) power supply for space VPX chassis. Multi-rail regulation, overvoltage and overcurrent protection. Interface compatible with CAVU SpaceVPX backplanes. Radiation hardening.'
WHERE name = 'PSU-Polar-3U — Alimentation SpaceVPX 3U' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Wide-field VNIR (Visible & Near InfraRed) hyperspectral camera in 3U CubeSat format. High spectral resolution RavenEye range for mapping, precision agriculture and environmental monitoring. L (Large) version: wider swath than the S version.'
WHERE name = 'RavenEye-3U-HSV-L (VNIR) — Caméra hyperspectrale grand champ' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Compact VNIR (Visible & Near InfraRed) hyperspectral camera in 3U CubeSat format. S (Small) version of the RavenEye range, with a narrower swath but high spectral resolution. Ideal for scientific missions requiring fine spectral discrimination over a targeted area.'
WHERE name = 'RavenEye-3U-HSV-S (VNIR) — Caméra hyperspectrale compact' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Short-wave infrared (SWIR) multispectral camera in 3U CubeSat format. RavenEye range designed for advanced Earth observation: vegetation detection, soil moisture, coastal monitoring, mineralogy. Integrates with the CAVU PolarFire SoC OBC.'
WHERE name = 'RavenEye-3U-MSS (SWIR) — Caméra multi-spectrale infrarouge' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Complete solar panel assembly for satellites and CubeSats. Includes CAVU GaAs cells (30% or 32%), deployment structures, space connectors and cabling. Compatible with Omni-P PCDUs and integrated MPPT. Designed for severe radiation environments.'
WHERE name = 'Space Solar Array — Panneau solaire spatial complet' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Utility Module for VITA 78-compliant SpaceVPX chassis. Provides system monitoring (voltages, temperatures), reset management, board identification and clock synchronization within the chassis.'
WHERE name = 'SpaceUM-Polar — Module utilitaire SpaceVPX' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'VITA 78 SpaceVPX backplane in double-slot (DS) configuration. Provides high-speed interconnect between boards in the space VPX chassis. PCIe, 10G Ethernet and SpaceWire traces. Radiation-tolerant design, low-outgassing connectors.'
WHERE name = 'SpaceVPX-BP-DS — Backplane SpaceVPX double-slot' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'VITA 78 SpaceVPX backplane in single-slot (SS) configuration. Compact version for reduced-volume applications. Same high-speed trace technology as the BP-DS, suited to CubeSat systems with a miniaturized VPX chassis.'
WHERE name = 'SpaceVPX-BP-SS — Backplane SpaceVPX simple-slot' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'SpaceWire network module compliant with ECSS-E-ST-50-12C for high-reliability intra-satellite communications. 2–400 Mbps data rates, RMAP routing. Can be integrated into CAVU OBCs or used as a standalone board in a SpaceVPX chassis.'
WHERE name = 'SpaceWire — Module réseau SpaceWire' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Onboard communication gateway for translating between several space protocols (SpaceWire, CAN, RS-422, MIL-STD-1553, Ethernet). Eases integration of heterogeneous subsystems without redevelopment. Based on PolarFire SoC.'
WHERE name = 'TartanComm-Bridge — Passerelle de communication multi-protocoles' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'Compact version of the CAVU TCU with half the I/O capacity (55 sensors / 25 heater outputs). Same SEU-immune FPGA core, same thermal control algorithms. Ideal for 3U–6U CubeSat missions where space is constrained but thermal management remains critical.'
WHERE name = 'TCU-L — Unité de contrôle thermique compacte' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'FPGA-based satellite thermal management unit with SEU mitigation. 110 sensor inputs (thermistors, RTDs), 50 heater outputs (up to 50 W/ch) with PWM or linear control. 45-day data storage. Radiation-hardened to 30 krad(Si). CAN and RS-422 interfaces. Fully customizable.'
WHERE name = 'TCU1 — Unité de contrôle thermique (110 capteurs / 50 actionneurs)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

UPDATE products SET description_en = 'CAVU''s most powerful AI computer, combining a PolarFire SoC FPGA and an NVIDIA Jetson AGX Orin 64 GB. 64 GB 256-bit LPDDR5 VRAM. >30 krad(Si) radiation tolerance. More PCIe/CSI lanes for multi-camera configurations + NVMe recorder. Optimal for multispectral or hyperspectral observation missions with full processing in orbit.'
WHERE name = 'Typhoon Edge — Super-calculateur IA ultime (Jetson AGX Orin 64 GB)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'CAVU Aerospace UK');

-- ---- Nimesis Space ----
UPDATE companies SET description_en = 'French designer of smart actuators and mechanisms for space, based on its proprietary shape-memory alloy (SMA) technology. Three families: locking/unlocking, deployment and deorbiting — from TRL 3 to TRL 9. Customer references: Airbus, CNES, JAXA, DLR. Custom engineering support, from concept to production.'
WHERE name = 'Nimesis Space' AND description_en IS NULL;

UPDATE products SET description_en = 'SMA gripping/locking mechanism for satellites and launch vehicles.'
WHERE name = 'Gripper' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Nimesis Space');

UPDATE products SET description_en = 'SMA locking/unlocking mechanism for launch vehicles.'
WHERE name = 'Harper' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Nimesis Space');

UPDATE products SET description_en = 'SMA deployment mechanism for satellites and rovers.'
WHERE name = 'Hector' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Nimesis Space');

UPDATE products SET description_en = 'SMA locking/unlocking mechanism for satellites and rovers.'
WHERE name = 'Jack' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Nimesis Space');

UPDATE products SET description_en = 'SMA locking/unlocking mechanism for launch vehicles.'
WHERE name = 'Lara' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Nimesis Space');

UPDATE products SET description_en = 'SMA deorbiting/decommissioning mechanism for satellites and launch vehicles.'
WHERE name = 'Murphy' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Nimesis Space');

UPDATE products SET description_en = 'SMA deployment mechanism, pyro-free, for satellites and rovers.'
WHERE name = 'SATLATCH' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Nimesis Space');

UPDATE products SET description_en = 'SMA deployment mechanism for satellites.'
WHERE name = 'Stepper' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Nimesis Space');

UPDATE products SET description_en = 'SMA locking/unlocking mechanism for satellites, launch vehicles and rovers.'
WHERE name = 'Triggy' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Nimesis Space');

-- ---- Space Inventor ----
UPDATE companies SET description_en = 'Danish manufacturer of highly vertically integrated satellite modules. Specialized in GNC systems, onboard computers, reaction wheels and power platforms for microsatellites and CubeSats. Founded in 2015, the company designs and manufactures its entire value chain in-house — from component to complete satellite.'
WHERE name = 'Space Inventor' AND description_en IS NULL;

UPDATE products SET description_en = 'Space Inventor 6U CubeSat platform, designed for a 10-year mission lifetime with secure communications.'
WHERE name = '6U Satellite' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Space Inventor');

UPDATE products SET description_en = 'Space Inventor ESPA-class satellite platform (half-plate payload adapter), for missions requiring more mass and power than the CubeSat range.'
WHERE name = 'BIG CAT 300' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Space Inventor');

UPDATE products SET description_en = 'Quad-redundant onboard computing platform for satellites. Four independent ARM Cortex-M7 modules, each with its own power supply, interfaces and storage. Optimal hot/cold redundancy architecture for T&C, GNC and critical payload management. Resistant to single-event upsets (SEU).'
WHERE name = 'Calculateur embarqué OBC-P4' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Space Inventor');

UPDATE products SET description_en = 'Compact, rugged inertial measurement unit for satellites. Two redundant sets of Murata SCH16T-K01 sensors (gyroscope + 6-DOF XYZ accelerometer) and two RM3100 magnetometers. Redundant CAN/CSP interface for integration into the GNC bus.'
WHERE name = 'IMU-P4 (Unité de mesure inertielle)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Space Inventor');

UPDATE products SET description_en = 'High-performance reaction wheel for microsatellites, designed for missions of up to 5 years. 3-phase outer-rotor PMSM motor with integrated control electronics. Hybrid suspension on ceramic bearings in vacuum. Redundant CAN/RS422 interface with CSP protocol.'
WHERE name = 'Reaction Wheel WHL-1000-P4' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Space Inventor');

UPDATE products SET description_en = 'Compact star tracker with rad-hard optics for precise attitude determination. Covers the entire celestial sphere with nominal performance up to 0.3°/s. Advanced constellation recognition algorithms. A natural complement to the Space Inventor GNC suite.'
WHERE name = 'Star Tracker STR-P3' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Space Inventor');

UPDATE products SET description_en = 'Fully integrated, flight-proven ADCS platform for CubeSats (10 kg) to MicroSats (200+ kg) in LEO/MEO/GEO. Includes reaction wheels, magnetorquers, star trackers, IMU and fine sun sensors. Extended Kalman filter sensor-fusion algorithms, orbit determination and autonomous momentum management.'
WHERE name = 'Suite GNC (ADCS Complet)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Space Inventor');

-- Contrôle : ce qu'il reste à traduire (descriptions vides) dans toute la base.
SELECT
  (SELECT count(*) FROM products  WHERE description_en IS NULL OR trim(description_en) = '') AS produits_sans_anglais,
  (SELECT count(*) FROM companies WHERE description_en IS NULL OR trim(description_en) = '') AS entreprises_sans_anglais;
