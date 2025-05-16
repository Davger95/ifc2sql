USE ifcdb;

-- 0) Disable FKs & truncate all prod tables
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE IfcWindowProperty;
TRUNCATE TABLE IfcDoorProperty;
TRUNCATE TABLE IfcWallProperty;
TRUNCATE TABLE IfcSpaceProperty;
TRUNCATE TABLE IfcBuildingStoreyProperty;
TRUNCATE TABLE IfcWindow;
TRUNCATE TABLE IfcDoor;
TRUNCATE TABLE IfcWall;
TRUNCATE TABLE IfcSpace;
TRUNCATE TABLE IfcBuildingStorey;
TRUNCATE TABLE IfcProject;

-- 1) Projects
INSERT IGNORE INTO IfcProject (GlobalId, Name)
  SELECT DISTINCT s.ProjectGlobalId, s.ProjectName
    FROM staging_IfcBuildingStorey AS s;

-- 2) Building‐storeys + props
INSERT IGNORE INTO IfcBuildingStorey (GlobalId, Name, ProjectId)
  SELECT s.GlobalId, s.Name, p.id
    FROM staging_IfcBuildingStorey AS s
    JOIN IfcProject AS p
      ON p.GlobalId = s.ProjectGlobalId;

INSERT IGNORE INTO IfcBuildingStoreyProperty (BuildingStoreyId, PSetName, PropName, PropValue)
  SELECT bs.id, pp.PSetName, pp.PropName, pp.PropValue
    FROM staging_IfcBuildingStorey_Properties AS pp
    JOIN IfcBuildingStorey AS bs
      ON bs.GlobalId = pp.EntityGlobalId;

-- 3) Spaces + props
INSERT IGNORE INTO IfcSpace (GlobalId, Name, StoreyId)
  SELECT s.GlobalId, s.Name, bs.id
    FROM staging_IfcSpace AS s
    JOIN IfcBuildingStorey AS bs
      ON bs.GlobalId = s.StoreyGlobalId;

INSERT IGNORE INTO IfcSpaceProperty (SpaceId, PSetName, PropName, PropValue)
  SELECT sp.id, p.PSetName, p.PropName, p.PropValue
    FROM staging_IfcSpace_Properties AS p
    JOIN IfcSpace AS sp
      ON sp.GlobalId = p.EntityGlobalId;

-- 4) Walls + props
INSERT IGNORE INTO IfcWall (GlobalId, Name, SpaceId)
  SELECT w.GlobalId, w.Name, sp.id
    FROM staging_IfcWall AS w
    JOIN IfcSpace AS sp
      ON sp.GlobalId = w.SpaceGlobalId;

INSERT IGNORE INTO IfcWallProperty (WallId, PSetName, PropName, PropValue)
  SELECT wlt.id, p.PSetName, p.PropName, p.PropValue
    FROM staging_IfcWall_Properties AS p
    JOIN IfcWall AS wlt
      ON wlt.GlobalId = p.EntityGlobalId;

-- 5) Doors + props
INSERT IGNORE INTO IfcDoor (GlobalId, Name, SpaceId)
  SELECT d.GlobalId, d.Name, sp.id
    FROM staging_IfcDoor AS d
    JOIN IfcSpace AS sp
      ON sp.GlobalId = d.SpaceGlobalId;

INSERT IGNORE INTO IfcDoorProperty (DoorId, PSetName, PropName, PropValue)
  SELECT drt.id, p.PSetName, p.PropName, p.PropValue
    FROM staging_IfcDoor_Properties AS p
    JOIN IfcDoor AS drt
      ON drt.GlobalId = p.EntityGlobalId;

-- 6) Windows + props
INSERT IGNORE INTO IfcWindow (GlobalId, Name, SpaceId)
  SELECT w.GlobalId, w.Name, sp.id
    FROM staging_IfcWindow AS w
    JOIN IfcSpace AS sp
      ON sp.GlobalId = w.SpaceGlobalId;

INSERT IGNORE INTO IfcWindowProperty (WindowId, PSetName, PropName, PropValue)
  SELECT wnw.id, p.PSetName, p.PropName, p.PropValue
    FROM staging_IfcWindow_Properties AS p
    JOIN IfcWindow AS wnw
      ON wnw.GlobalId = p.EntityGlobalId;

-- 7) Re‐enable FKs
SET FOREIGN_KEY_CHECKS = 1;
