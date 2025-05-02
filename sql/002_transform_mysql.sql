-- 002_transform_mysql.sql
-- Transform: load from staging CSV tables into production schema

-- 0) Disable FK checks for bulk inserts
SET FOREIGN_KEY_CHECKS = 0;

-- 1) Building Storeys
INSERT IGNORE INTO IfcBuildingStorey (GlobalId, Name)
SELECT GlobalId, Name
FROM staging_IfcBuildingStorey;

-- 2) Spaces
INSERT IGNORE INTO IfcSpace (GlobalId, Name)
SELECT GlobalId, Name
FROM staging_IfcSpace;

-- 3) Walls
INSERT IGNORE INTO IfcWall (GlobalId, Name)
SELECT GlobalId, Name
FROM staging_IfcWall;

-- 4) Doors
INSERT IGNORE INTO IfcDoor (GlobalId, Name)
SELECT GlobalId, Name
FROM staging_IfcDoor;

-- 5) Windows
INSERT IGNORE INTO IfcWindow (GlobalId, Name)
SELECT GlobalId, Name
FROM staging_IfcWindow;

-- (Optional) MEP classes if you exported them:
-- INSERT IGNORE INTO IfcAirTerminal (GlobalId, Name)
-- SELECT GlobalId, Name FROM staging_IfcAirTerminal;
--
-- INSERT IGNORE INTO IfcDistributionSystem (GlobalId, Name)
-- SELECT GlobalId, Name FROM staging_IfcDistributionSystem;

-- 6) (Repeat the above pattern for any other staging_<Entity> → production table)

-- 7) Re-enable FK checks
SET FOREIGN_KEY_CHECKS = 1;
