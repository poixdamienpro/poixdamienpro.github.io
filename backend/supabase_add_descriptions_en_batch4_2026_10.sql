-- ============================================================
-- Traductions anglaises (description_en) — lot « batch4 », 2026-10
-- Entreprises : CAVU Aerospace UK, Nimesis Space, Space Inventor
--
-- Sûr à relancer : ne remplit que les champs encore vides (IS NULL).
-- ============================================================

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

-- Contrôle : produits de ces entreprises encore sans description anglaise (doit être 0).
SELECT c.name AS entreprise, count(*) FILTER (WHERE p.description_en IS NULL) AS sans_anglais, count(*) AS total
FROM companies c LEFT JOIN products p ON p.company_id = c.id
WHERE c.name IN ('CAVU Aerospace UK', 'Nimesis Space', 'Space Inventor')
GROUP BY c.name ORDER BY c.name;
