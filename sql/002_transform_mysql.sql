-- Transform: load from staging CSV tables into production schema, including properties

-- 0) Disable FK checks for bulk inserts
SET FOREIGN_KEY_CHECKS = 0;

-- 1) Building Storeys
INSERT IGNORE INTO IfcBuildingStorey (GlobalId, Name)
SELECT GlobalId, Name
  FROM staging_IfcBuildingStorey;
TRUNCATE TABLE staging_IfcBuildingStorey;

-- 1.a) BuildingStorey properties
INSERT IGNORE INTO IfcBuildingStoreyProperty (BuildingStoreyId, PSetName, PropName, PropValue)
SELECT bs.id, p.PSetName, p.PropName, p.PropValue
  FROM staging_IfcBuildingStorey_Properties p
  JOIN IfcBuildingStorey bs
    ON bs.GlobalId = p.EntityGlobalId;
TRUNCATE TABLE staging_IfcBuildingStorey_Properties;

-- 2) Spaces
INSERT IGNORE INTO IfcSpace (GlobalId, Name)
SELECT GlobalId, Name
  FROM staging_IfcSpace;
TRUNCATE TABLE staging_IfcSpace;

-- 2.a) Space properties
INSERT IGNORE INTO IfcSpaceProperty (SpaceId, PSetName, PropName, PropValue)
SELECT s.id, p.PSetName, p.PropName, p.PropValue
  FROM staging_IfcSpace_Properties p
  JOIN IfcSpace s
    ON s.GlobalId = p.EntityGlobalId;
TRUNCATE TABLE staging_IfcSpace_Properties;

-- 3) Walls
INSERT IGNORE INTO IfcWall (GlobalId, Name)
SELECT GlobalId, Name
  FROM staging_IfcWall;
TRUNCATE TABLE staging_IfcWall;

-- 3.a) Wall properties
INSERT IGNORE INTO IfcWallProperty (WallId, PSetName, PropName, PropValue)
SELECT w.id, p.PSetName, p.PropName, p.PropValue
  FROM staging_IfcWall_Properties p
  JOIN IfcWall w
    ON w.GlobalId = p.EntityGlobalId;
TRUNCATE TABLE staging_IfcWall_Properties;

-- 4) Doors
INSERT IGNORE INTO IfcDoor (GlobalId, Name)
SELECT GlobalId, Name
  FROM staging_IfcDoor;
TRUNCATE TABLE staging_IfcDoor;

-- 4.a) Door properties
INSERT IGNORE INTO IfcDoorProperty (DoorId, PSetName, PropName, PropValue)
SELECT d.id, p.PSetName, p.PropName, p.PropValue
  FROM staging_IfcDoor_Properties p
  JOIN IfcDoor d
    ON d.GlobalId = p.EntityGlobalId;
TRUNCATE TABLE staging_IfcDoor_Properties;

-- 5) Windows
INSERT IGNORE INTO IfcWindow (GlobalId, Name)
SELECT GlobalId, Name
  FROM staging_IfcWindow;
TRUNCATE TABLE staging_IfcWindow;

-- 5.a) Window properties
INSERT IGNORE INTO IfcWindowProperty (WindowId, PSetName, PropName, PropValue)
SELECT w.id, p.PSetName, p.PropName, p.PropValue
  FROM staging_IfcWindow_Properties p
  JOIN IfcWindow w
    ON w.GlobalId = p.EntityGlobalId;
TRUNCATE TABLE staging_IfcWindow_Properties;

-- 6) MaterialClass load & parent backfill
INSERT IGNORE INTO MaterialClass (bsdd_id, class_name, parent_bsdd_id)
SELECT bsdd_id, class_name, NULLIF(parent_id,'')
  FROM staging_bsdd_materials;
UPDATE MaterialClass c
  JOIN MaterialClass p
    ON c.parent_bsdd_id = p.bsdd_id
SET c.parent_ClassId = p.ClassId
WHERE c.parent_bsdd_id IS NOT NULL;
TRUNCATE TABLE staging_bsdd_materials;

-- 7) Element→material staging
CREATE TABLE IF NOT EXISTS staging_element_material_map (
  EntityGlobalId VARCHAR(36),
  ElementType    VARCHAR(50),
  bsdd_id        VARCHAR(50)
);
LOAD DATA LOCAL INFILE '/path/to/map_all_elements.csv'
INTO TABLE staging_element_material_map
FIELDS TERMINATED BY ',' ENCLOSED BY '"' IGNORE 1 LINES
  (EntityGlobalId, ElementType, bsdd_id);

-- 8) Link elements to classes
INSERT IGNORE INTO IfcElement_MaterialClass (ElementType, ElementId, ClassId)
SELECT
  m.ElementType,
  CASE m.ElementType
    WHEN 'IfcBuildingStorey' THEN (SELECT id FROM IfcBuildingStorey WHERE GlobalId = m.EntityGlobalId)
    WHEN 'IfcSpace'          THEN (SELECT id FROM IfcSpace          WHERE GlobalId = m.EntityGlobalId)
    WHEN 'IfcWall'           THEN (SELECT id FROM IfcWall           WHERE GlobalId = m.EntityGlobalId)
    WHEN 'IfcDoor'           THEN (SELECT id FROM IfcDoor           WHERE GlobalId = m.EntityGlobalId)
    WHEN 'IfcWindow'         THEN (SELECT id FROM IfcWindow         WHERE GlobalId = m.EntityGlobalId)
  END,
  mc.ClassId
FROM staging_element_material_map m
JOIN MaterialClass mc
  ON m.bsdd_id = mc.bsdd_id
WHERE m.bsdd_id <> '';
TRUNCATE TABLE staging_element_material_map;

-- 9) Re-enable FKs
SET FOREIGN_KEY_CHECKS = 1;
