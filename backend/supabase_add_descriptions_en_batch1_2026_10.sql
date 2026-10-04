-- ============================================================
-- Traductions anglaises (description_en) — lot « batch1 », 2026-10
-- Entreprises : Dongguan Jianchuang Electronic Technology Co., Ltd., EREMS, Colossus Compute, Infineon Technologies
--
-- Sûr à relancer : ne remplit que les champs encore vides (IS NULL).
-- ============================================================

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

-- Contrôle : produits de ces entreprises encore sans description anglaise (doit être 0).
SELECT c.name AS entreprise, count(*) FILTER (WHERE p.description_en IS NULL) AS sans_anglais, count(*) AS total
FROM companies c LEFT JOIN products p ON p.company_id = c.id
WHERE c.name IN ('Dongguan Jianchuang Electronic Technology Co., Ltd.', 'EREMS', 'Colossus Compute', 'Infineon Technologies')
GROUP BY c.name ORDER BY c.name;
