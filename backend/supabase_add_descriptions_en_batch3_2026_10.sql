-- ============================================================
-- Traductions anglaises (description_en) — lot « batch3 », 2026-10
-- Entreprises : Delta Electronics, Nidec, Amphenol, DHV Technology, Anywaves, ABB, Emerson (Fisher), CubeSpace, HarnessTech, SpaceLocker, ISISPACE, EaglePicher Technologies, Rotork, Blue Solutions, ABL Space Systems, Hemeria
--
-- Sûr à relancer : ne remplit que les champs encore vides (IS NULL).
-- ============================================================

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

-- Contrôle : produits de ces entreprises encore sans description anglaise (doit être 0).
SELECT c.name AS entreprise, count(*) FILTER (WHERE p.description_en IS NULL) AS sans_anglais, count(*) AS total
FROM companies c LEFT JOIN products p ON p.company_id = c.id
WHERE c.name IN ('Delta Electronics', 'Nidec', 'Amphenol', 'DHV Technology', 'Anywaves', 'ABB', 'Emerson (Fisher)', 'CubeSpace', 'HarnessTech', 'SpaceLocker', 'ISISPACE', 'EaglePicher Technologies', 'Rotork', 'Blue Solutions', 'ABL Space Systems', 'Hemeria')
GROUP BY c.name ORDER BY c.name;
