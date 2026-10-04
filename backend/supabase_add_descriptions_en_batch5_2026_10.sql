-- ============================================================
-- Traductions anglaises (description_en) — lot « batch5 », 2026-10
-- Entreprises : Faulhaber, Kongsberg NanoAvionics, AAC Clyde Space, VPT Inc, Berlin Space Technologies, Beyond Gravity, Bosch Rexroth, Cobham, Comat, EnduroSat, Exail, Franklin Electric, Honeywell Aerospace, L3Harris Technologies
--
-- Sûr à relancer : ne remplit que les champs encore vides (IS NULL).
-- ============================================================

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

-- Contrôle : produits de ces entreprises encore sans description anglaise (doit être 0).
SELECT c.name AS entreprise, count(*) FILTER (WHERE p.description_en IS NULL) AS sans_anglais, count(*) AS total
FROM companies c LEFT JOIN products p ON p.company_id = c.id
WHERE c.name IN ('Faulhaber', 'Kongsberg NanoAvionics', 'AAC Clyde Space', 'VPT Inc', 'Berlin Space Technologies', 'Beyond Gravity', 'Bosch Rexroth', 'Cobham', 'Comat', 'EnduroSat', 'Exail', 'Franklin Electric', 'Honeywell Aerospace', 'L3Harris Technologies')
GROUP BY c.name ORDER BY c.name;
