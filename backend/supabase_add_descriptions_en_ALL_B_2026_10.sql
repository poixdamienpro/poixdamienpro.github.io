-- ============================================================
-- Descriptions anglaises — fichier regroupé B (lots 5 à 8), 2026-10
-- À exécuter d'un seul coup dans l'éditeur SQL de Supabase.
-- Sûr à relancer : ne remplit que les champs encore vides (IS NULL).
-- Les fichiers regroupés A, B, C couvrent les 11 lots, dans cet ordre.
-- ============================================================

-- ######## Lot 5 ########
-- ---- Faulhaber ----
UPDATE companies SET description_en = 'German family-owned group specializing in precision micromotors and micro drive systems, for robotics, automation, aerospace, optics and medical applications.'
WHERE name = 'Faulhaber' AND description_en IS NULL;

UPDATE products SET description_en = '4-pole technology brushless motor, 22 mm diameter, several lengths available. SC version with integrated speed controller available.'
WHERE name = 'BX4 — Moteur brushless 4 pôles' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Faulhaber');

UPDATE products SET description_en = '10 mm DC micromotor, one of the smallest in the Faulhaber catalog, for ultra-miniaturized applications: medical instrumentation, precision optics, fine robotics.'
WHERE name = 'DC-Micromoteur Série 1016 SR' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Faulhaber');

UPDATE products SET description_en = 'Intermediate-size DC micromotor, coreless rotor with precious-metal commutation for smooth, jerk-free operation. For instrumentation, light automation and small motorized devices.'
WHERE name = 'DC-Micromoteur Série 1724 SR' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Faulhaber');

UPDATE products SET description_en = 'DC micromotor with graphite commutation, self-supporting coreless winding rotor for minimal inertia and jerk-free operation. Intended for precision automation, optics and medical applications.'
WHERE name = 'DC-Micromoteur Série 2668 CR' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Faulhaber');

UPDATE products SET description_en = 'Two-phase stepper motor, high holding torque and low power consumption, for high-precision positioning tasks. 20, 24 or 48 steps per revolution depending on model.'
WHERE name = 'Série AM — Moteur pas-à-pas' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Faulhaber');

UPDATE products SET description_en = 'Linear motor with self-supporting three-phase coil, non-magnetic metal housing, positioning by integrated Hall-effect sensors. Available in 4 sizes.'
WHERE name = 'Série LM — Moteur linéaire DC' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Faulhaber');

-- ---- Kongsberg NanoAvionics ----
UPDATE companies SET description_en = 'Manufacturer of standardized CubeSat and microsatellite platforms. More than 60 satellites launched, more than 300 in production.'
WHERE name = 'Kongsberg NanoAvionics' AND description_en IS NULL;

UPDATE products SET description_en = 'Standardized 12U CubeSat platform for missions needing more payload capacity, same modular architecture as the M range.'
WHERE name = 'M12P — Plateforme CubeSat 12U' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Kongsberg NanoAvionics');

UPDATE products SET description_en = 'Standardized, flight-proven 6U CubeSat platform, available in Light, Mid and Max configurations depending on mission needs.'
WHERE name = 'M6P — Plateforme CubeSat 6U' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Kongsberg NanoAvionics');

UPDATE products SET description_en = 'Gen-2 satellite platform for Earth observation and demanding ISR missions: payload volume increased by more than 50% and downlink data rate multiplied by more than 3 compared to the previous generation.'
WHERE name = 'MP42 (Gen-2)' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Kongsberg NanoAvionics');

UPDATE products SET description_en = 'High-end Gen-2 satellite platform (500 kg class), for complex payloads: very-high-resolution optical imaging, SAR, MWIR thermal imaging, high-speed communications.'
WHERE name = 'MP42D' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Kongsberg NanoAvionics');

UPDATE products SET description_en = 'Enhanced variant of the Gen-2 MP42 family, with GNSS jamming resistance and improved radiation tolerance (detailed technical details not published by the manufacturer).'
WHERE name = 'MP42H' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Kongsberg NanoAvionics');

UPDATE products SET description_en = 'Kongsberg NanoAvionics onboard computer for CubeSats and nanosatellites, integrating a magnetometer and a gyroscope to support attitude determination.'
WHERE name = 'SatBus 3C2' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Kongsberg NanoAvionics');

-- ---- AAC Clyde Space ----
UPDATE companies SET description_en = 'Scottish manufacturer of standardized, miniaturized subsystems for CubeSats and small satellites (up to 500 kg): avionics, OBC, PCDU, batteries, solar panels and communication systems.'
WHERE name = 'AAC Clyde Space' AND description_en IS NULL;

UPDATE products SET description_en = 'Ready-to-fly 6U CubeSat platform optimized for satellite communications (high-power transmission, robust RF systems), for M2M/IoT and AIS/RF collection applications.'
WHERE name = 'EPIC LINK' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'AAC Clyde Space');

UPDATE products SET description_en = 'Ready-to-fly 6U CubeSat platform optimized for Earth observation (high-resolution imaging), building on decades of heritage of AAC Clyde Space CubeSat subsystems.'
WHERE name = 'EPIC VIEW' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'AAC Clyde Space');

UPDATE products SET description_en = 'AAC Clyde Space 50 MHz On-Board Computer with integrated communication protocol unit, intended for low Earth orbit (LEO) SmallSat missions.'
WHERE name = 'SIRIUS OBC LEON3FT' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'AAC Clyde Space');

UPDATE products SET description_en = 'AAC Clyde Space Digital Sun Sensor for CubeSats, with very low mass and low power consumption.'
WHERE name = 'SS200' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'AAC Clyde Space');

UPDATE products SET description_en = 'AAC Clyde Space Power Conditioning and Distribution Unit, used notably on the Nova-C lunar lander of NASA''s CLPS (Commercial Lunar Payload Services) program.'
WHERE name = 'STARBUCK-MINI PCDU' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'AAC Clyde Space');

-- ---- VPT Inc ----
UPDATE companies SET description_en = 'US manufacturer of hi-rel DC/DC converters for space, avionics and military applications, qualified for radiation tolerance (TID, SEE) and extreme environments (-55°C to +125°C).'
WHERE name = 'VPT Inc' AND description_en IS NULL;

UPDATE products SET description_en = 'VPT high-power DC/DC converter, radiation-qualified (TID and SEE), for space applications requiring high onboard power density.'
WHERE name = 'SGRB12018S' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'VPT Inc');

UPDATE products SET description_en = 'VPT 120W DC/DC converter, radiation-qualified, 28V input, single 15V output, for the extreme space environment (-55°C to +125°C).'
WHERE name = 'SVFL2815S' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'VPT Inc');

UPDATE products SET description_en = 'VPT 100W isolated DC/DC converter, 28V input, single 12V output, intended for integration into satellite power systems and avionics equipment.'
WHERE name = 'VPT100-2812S' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'VPT Inc');

UPDATE products SET description_en = 'VPT 100W DC/DC converter, radiation-qualified, 28V input and output, intended for satellite power systems in high-radiation environments.'
WHERE name = 'VSC100-2828S' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'VPT Inc');

UPDATE products SET description_en = 'VPT 250W DC/DC converter, 28V input, single 28V output, designed for integration into avionic and space power distribution systems.'
WHERE name = 'VXR250-2828S' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'VPT Inc');

-- ---- Berlin Space Technologies ----
UPDATE companies SET description_en = 'German manufacturer of microsatellite platforms and avionics subsystems (onboard computers, sun sensors) for Earth observation missions.'
WHERE name = 'Berlin Space Technologies' AND description_en IS NULL;

UPDATE products SET description_en = 'Berlin Space Technologies Fine Sun Sensor Assembly, made up of three analog sun sensors, intended for integration into ADCS systems.'
WHERE name = 'FSSA-110' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Berlin Space Technologies');

UPDATE products SET description_en = 'BST satellite platform derived from the LEOS-50 (same internal avionics), for more demanding missions -- from in-orbit demonstration to sub-meter optical observation and defense/in-orbit servicing missions (S/D/DX versions).'
WHERE name = 'LEOS-100' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Berlin Space Technologies');

UPDATE products SET description_en = 'Small satellite platform with flight heritage since 2015 (BST), for demanding Earth observation missions with a medium-sized payload. Electric propulsion.'
WHERE name = 'LEOS-50' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Berlin Space Technologies');

UPDATE products SET description_en = 'Berlin Space Technologies onboard computer and auxiliary processor, running the Linux operating system, intended for LEO missions.'
WHERE name = 'OBC-100 & ACC-100' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Berlin Space Technologies');

-- ---- Beyond Gravity ----
UPDATE companies SET description_en = 'Global supplier of mission-critical systems for satellites and launch vehicles (formerly RUAG Space). Present for 60 years on hundreds of missions: satellite computers (3,500 cumulative years in orbit), solar array drive mechanisms (SADM, European leader), fairing structures, antennas and PCDUs. Customers: NASA, ESA, JAXA, Airbus, Thales, OHB. Missions: Galileo, JWST, Ariane 6, Artemis, PLATO, Copernicus.'
WHERE name = 'Beyond Gravity' AND description_en IS NULL;

UPDATE products SET description_en = 'Radiation-hardened power conditioning and distribution units (PCDUs) for satellites. Competitive, radiation-hardened and reliable electronic components to keep the platform operational year after year. Integrated on major institutional missions (Galileo, MetOp, Copernicus).'
WHERE name = 'PCDU — Power Conditioning & Distribution Unit' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Beyond Gravity');

UPDATE products SET description_en = 'European leader in SADMs (Solar Array Drive Mechanisms) with 100% mission success over 20+ years. Complete range from microsatellites to large high-power GEO/telecom platforms. Integrated gold-on-gold rotating contact (slip ring). References: BepiColombo (ESA), Artemis (NASA), Eutelsat KONNECT, PLATO. Anti-microvibration solutions for sensitive payloads.'
WHERE name = 'SADM — Mécanisme d''orientation de panneaux solaires' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Beyond Gravity');

UPDATE products SET description_en = 'Satellite onboard computers and data handling systems (C&DH) with 3,500 cumulative years in orbit. Portfolio: OBC, RTU, DHS, HPB for GEO/LEO/deep space missions. Heritage: Sentinel 2/3/4/5P/6, MetOp, EarthCARE, Galileo, JUICE, ExoMars, Euclid, Ariane and Vega. Available in New Space (high-volume) and institutional versions.'
WHERE name = 'Satellite OBC & Système C&DH' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Beyond Gravity');

UPDATE products SET description_en = 'Critical mechanical structures for satellites and launch vehicles: launcher payload fairings, interstage adapters, satellite structures, separation systems and dispensers. 40+ years of experience, present on Ariane 6, Vega-C and Europa Clipper (NASA). Series and high-volume production for LEO constellations.'
WHERE name = 'Structures satellites & coiffes lanceurs' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Beyond Gravity');

-- ---- Bosch Rexroth ----
UPDATE companies SET description_en = 'Bosch group subsidiary specializing in drive and control technologies: hydraulics, electric servomotors, gear technology and industrial automation.'
WHERE name = 'Bosch Rexroth' AND description_en IS NULL;

UPDATE products SET description_en = 'Range of asynchronous servomotors for high-power industrial applications: air-cooled MAD, liquid-cooled MAF. Combined with the IndraDrive drive.'
WHERE name = 'IndraDyn A (MAD/MAF) — Servomoteurs asynchrones' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Bosch Rexroth');

UPDATE products SET description_en = 'Iron-core linear motors, liquid-cooled stainless-steel housing, for fast movement of heavy masses. Several sizes depending on the required force and speed.'
WHERE name = 'IndraDyn L (MLP) — Moteurs linéaires' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Bosch Rexroth');

UPDATE products SET description_en = 'High-precision synchronous servomotor for industrial automation applications, combined with the IndraDrive drive. High-resolution single- or multi-turn encoder, optional holding brake.'
WHERE name = 'IndraDyn S MSK101 — Servomoteur synchrone' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Bosch Rexroth');

UPDATE products SET description_en = 'Synchronous torque motor supplied as a kit (stator + rotor) for direct integration into a machine, without a gearbox. Liquid cooling or natural convection depending on the variant.'
WHERE name = 'IndraDyn T (MRT) — Moteurs-couple' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Bosch Rexroth');

-- ---- Cobham ----
UPDATE companies SET description_en = 'Antennas and RF systems for aircraft, satellites and defense vehicles. Strong SATCOM presence.'
WHERE name = 'Cobham' AND description_en IS NULL;

UPDATE products SET description_en = 'RF power amplifier for satellite links and onboard radars. Ku-band range.'
WHERE name = 'Amplificateur RF haute puissance PA-500' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Cobham');

UPDATE products SET description_en = 'Ku-band directional antenna for satellite links onboard vehicles and mobile platforms.'
WHERE name = 'Antenne SATCOM Ku-Band SAT-450' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Cobham');

UPDATE products SET description_en = 'Compact satellite modem for high-speed data links on mobile platforms and aircraft.'
WHERE name = 'Modem SATCOM compact CSM-200' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Cobham');

UPDATE products SET description_en = 'Motorized 2-axis pointing system for mobile SATCOM antennas, with automatic satellite tracking.'
WHERE name = 'Positionneur d''antenne 2 axes ATP-300' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Cobham');

-- ---- Comat ----
UPDATE companies SET description_en = 'French equipment maker specializing in complex space mechanisms: reaction wheels, SADMs, deployable structures. 45 years of expertise, European leader in its segment.'
WHERE name = 'Comat' AND description_en IS NULL;

UPDATE products SET description_en = 'Deployable antenna designed and assembled by Comat for the IoT mission of the Kineis nanosatellite, ensuring communication in orbit.'
WHERE name = 'Antenne déployable nanosatellite' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Comat');

UPDATE products SET description_en = 'Compact NANOBOOM deployable mast for nanosatellite applications, reusable building-block design.'
WHERE name = 'NANOBOOM — Mât déployable' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Comat');

UPDATE products SET description_en = 'Comat reaction wheel, the only nanosat reaction wheel qualified for 8 years of operation in orbit, offering a very safe mission to satellite prime contractors.'
WHERE name = 'Roue de réaction RW40' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Comat');

UPDATE products SET description_en = 'Solar Array Drive Mechanism (SADM) developed by Comat, currently in pre-qualification under the France 2030 plan.'
WHERE name = 'SADM — Mécanisme d''entraînement panneaux solaires' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Comat');

-- ---- EnduroSat ----
UPDATE companies SET description_en = 'Bulgarian CubeSat and nanosatellite equipment maker, manufacturer of onboard computers (OBC) with a space-grade ARM Cortex-M7 processor.'
WHERE name = 'EnduroSat' AND description_en IS NULL;

UPDATE products SET description_en = '16U nanosatellite platform with flight heritage, with onboard operational frame and standard payload control interfaces.'
WHERE name = '16U CubeSat Platform' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EnduroSat');

UPDATE products SET description_en = '6U nanosatellite platform with optional high-precision ADCS, for missions requiring fine pointing.'
WHERE name = '6U CubeSat Platform' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EnduroSat');

UPDATE products SET description_en = 'Satellite platform for onboard computing and high bandwidth, with extended orbital maneuvering capability.'
WHERE name = 'FRAME Max' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EnduroSat');

UPDATE products SET description_en = 'Onboard computer for CubeSats and nanosatellites, with a space-grade ARM Cortex-M7 processor, onboard NAND Flash memory and optional integrated GNSS.'
WHERE name = 'OBC CubeSat ARM Cortex-M7' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'EnduroSat');

-- ---- Exail ----
UPDATE companies SET description_en = 'French designer and manufacturer of inertial navigation systems (FOG), sensors and equipment for subsea, marine and defense applications. More than 3,000 subsea navigation systems in service worldwide.'
WHERE name = 'Exail' AND description_en IS NULL;

UPDATE products SET description_en = 'FOG-technology AHRS (Attitude Heading and Reference System) from the Exail range for ROVs and small underwater vehicles, designed to be integrated as a navigation component within larger systems.'
WHERE name = 'Octans Nano' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Exail');

UPDATE products SET description_en = 'Compact survey-grade INS from the Exail range, designed to be integrated as a high-precision navigation module within AUVs.'
WHERE name = 'Phins Compact C7' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Exail');

UPDATE products SET description_en = 'High-performance INS from the Exail range for survey-grade navigation in deep water, designed for integration into deep-water ROV/AUV systems.'
WHERE name = 'Phins Subsea' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Exail');

UPDATE products SET description_en = 'Compact INS (Inertial Navigation System) from the Exail range, intended for integration into small ROVs and AUVs requiring compact-quality navigation.'
WHERE name = 'Rovins Nano' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Exail');

-- ---- Franklin Electric ----
UPDATE companies SET description_en = 'US manufacturer of submersible motors, pumps and water and energy management systems, for residential, agricultural, industrial and municipal applications.'
WHERE name = 'Franklin Electric' AND description_en IS NULL;

UPDATE products SET description_en = 'Permanent-magnet submersible motor, higher efficiency than an equivalent induction motor, for energy-efficient pumping applications over long duty cycles.'
WHERE name = 'Moteur immergé à aimants permanents 4"/8"/10"' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Franklin Electric');

UPDATE products SET description_en = 'Submersible motor with hermetic stator and self-healing anti-tracking resin, for borehole pumps. Removable "Water bloc" power connector, drinking-water-compliant materials.'
WHERE name = 'Moteur immergé encapsulé 4"/6"/8"' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Franklin Electric');

UPDATE products SET description_en = 'High-power rewindable submersible motor, rewindable to extend service life, for large-diameter boreholes and industrial/municipal pumping applications.'
WHERE name = 'Moteur immergé rebobinable 6"-12"' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Franklin Electric');

UPDATE products SET description_en = 'Small rewindable oil-lubricated submersible motor, for domestic wells and small agricultural installations.'
WHERE name = 'Moteur immergé rebobinable à bain d''huile 4"' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Franklin Electric');

-- ---- Honeywell Aerospace ----
UPDATE companies SET description_en = 'Inertial measurement units (IMUs) and navigation sensors for defense, aviation and space.'
WHERE name = 'Honeywell Aerospace' AND description_en IS NULL;

UPDATE products SET description_en = 'Low-altitude radar altimeter for tactical flight and landing in degraded conditions.'
WHERE name = 'Altimètre radar RA-200' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Honeywell Aerospace');

UPDATE products SET description_en = 'Air data computer for military aircraft: altitude, airspeed, outside air temperature.'
WHERE name = 'Calculateur de données air ADC-3000' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Honeywell Aerospace');

UPDATE products SET description_en = 'High-precision 6-axis tactical IMU for navigation, guidance and stabilization of defense and space platforms.'
WHERE name = 'Centrale inertielle IMU-HG4930' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Honeywell Aerospace');

UPDATE products SET description_en = 'Hybrid GPS/INS navigation system for defense aircraft and vehicles, operating in degraded environments.'
WHERE name = 'Système de navigation GPS/INS HG-9900' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'Honeywell Aerospace');

-- ---- L3Harris Technologies ----
UPDATE companies SET description_en = 'Ruggedized RF connectors and amplifiers for tactical radios and military satellite links.'
WHERE name = 'L3Harris Technologies' AND description_en IS NULL;

UPDATE products SET description_en = 'Wideband RF amplifier for tactical radios, vehicle or fixed-station mounting.'
WHERE name = 'Amplificateur RF large bande AB-150' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'L3Harris Technologies');

UPDATE products SET description_en = 'Sealed coaxial connector for high-frequency RF links on tactical radios and onboard systems.'
WHERE name = 'Connecteur RF durci RFC-7' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'L3Harris Technologies');

UPDATE products SET description_en = 'Kit of sealed RF connectors and assembled cables for radio integration on tactical vehicles.'
WHERE name = 'Kit connecteurs RF durcis RFK-12' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'L3Harris Technologies');

UPDATE products SET description_en = 'Ruggedized tactical radio for vehicle integration and portable use. Secure mesh network.'
WHERE name = 'Radio tactique vétronique AN/PRC-200' AND description_en IS NULL
  AND company_id = (SELECT id FROM companies WHERE name = 'L3Harris Technologies');

-- ######## Lot 6 ########
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

-- ######## Lot 7 ########
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

-- ######## Lot 8 ########
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

-- Contrôle : ce qu'il reste à traduire (descriptions vides) dans toute la base.
SELECT
  (SELECT count(*) FROM products  WHERE description_en IS NULL OR trim(description_en) = '') AS produits_sans_anglais,
  (SELECT count(*) FROM companies WHERE description_en IS NULL OR trim(description_en) = '') AS entreprises_sans_anglais;
