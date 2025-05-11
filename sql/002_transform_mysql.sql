-- 002_transform_mysql.sql (updated)
-- Transform: load from staging CSV tables into production schema, including properties

-- 0) Disable FK checks for bulk inserts
SET FOREIGN_KEY_CHECKS = 0;

-- 1) Building Storeys
INSERT IGNORE INTO IfcBuildingStorey (GlobalId, Name)
SELECT GlobalId, Name
  FROM staging_IfcBuildingStorey;

-- 1.a) BuildingStorey properties
INSERT IGNORE INTO IfcBuildingStoreyProperty (BuildingStoreyId, PSetName, PropName, PropValue)
SELECT bs.id, p.PSetName, p.PropName, p.PropValue
  FROM staging_IfcBuildingStorey_Properties p
  JOIN IfcBuildingStorey bs
    ON bs.GlobalId = p.EntityGlobalId;

-- 2) Spaces
INSERT IGNORE INTO IfcSpace (GlobalId, Name)
SELECT GlobalId, Name
  FROM staging_IfcSpace;

-- 2.a) Space properties
INSERT IGNORE INTO IfcSpaceProperty (SpaceId, PSetName, PropName, PropValue)
SELECT s.id, p.PSetName, p.PropName, p.PropValue
  FROM staging_IfcSpace_Properties p
  JOIN IfcSpace s
    ON s.GlobalId = p.EntityGlobalId;

-- 3) Walls
INSERT IGNORE INTO IfcWall (GlobalId, Name)
SELECT GlobalId, Name
  FROM staging_IfcWall;

-- 3.a) Wall properties
INSERT IGNORE INTO IfcWallProperty (WallId, PSetName, PropName, PropValue)
SELECT w.id, p.PSetName, p.PropName, p.PropValue
  FROM staging_IfcWall_Properties p
  JOIN IfcWall w
    ON w.GlobalId = p.EntityGlobalId;

-- 4) Doors
INSERT IGNORE INTO IfcDoor (GlobalId, Name)
SELECT GlobalId, Name
  FROM staging_IfcDoor;

-- 4.a) Door properties
INSERT IGNORE INTO IfcDoorProperty (DoorId, PSetName, PropName, PropValue)
SELECT d.id, p.PSetName, p.PropName, p.PropValue
  FROM staging_IfcDoor_Properties p
  JOIN IfcDoor d
    ON d.GlobalId = p.EntityGlobalId;

-- 5) Windows
INSERT IGNORE INTO IfcWindow (GlobalId, Name)
SELECT GlobalId, Name
  FROM staging_IfcWindow;

-- 5.a) Window properties
INSERT IGNORE INTO IfcWindowProperty (WindowId, PSetName, PropName, PropValue)
SELECT w.id, p.PSetName, p.PropName, p.PropValue
  FROM staging_IfcWindow_Properties p
  JOIN IfcWindow w
    ON w.GlobalId = p.EntityGlobalId;

-- (Optional) MEP classes if you exported them:
-- e.g.
-- INSERT IGNORE INTO IfcAirTerminal (GlobalId, Name)
--   SELECT GlobalId, Name FROM staging_IfcAirTerminal;
-- INSERT IGNORE INTO IfcAirTerminalProperty (AirTerminalId, PSetName, PropName, PropValue)
--   SELECT a.id, p.PSetName, p.PropName, p.PropValue
--     FROM staging_IfcAirTerminal_Properties p
--     JOIN IfcAirTerminal a ON a.GlobalId = p.EntityGlobalId;

-- 6) (Repeat pattern for any other class + property table)

-- 7) Re-enable FK checks
SET FOREIGN_KEY_CHECKS = 1;
