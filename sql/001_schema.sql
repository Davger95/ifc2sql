USE ifcdb;

-- ----------------------------------------------------------------
-- 0) Projects
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS IfcProject;
CREATE TABLE IfcProject (
  id        INT            NOT NULL AUTO_INCREMENT,
  GlobalId  VARCHAR(36)    NOT NULL,
  Name      VARCHAR(255),
  PRIMARY KEY (id),
  UNIQUE KEY ux_IfcProject_GlobalId (GlobalId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------
-- 1) Building hierarchy
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS IfcBuildingStorey;
CREATE TABLE IfcBuildingStorey (
  id         INT            NOT NULL AUTO_INCREMENT,
  GlobalId   VARCHAR(36)    NOT NULL,
  Name       VARCHAR(255),
  ProjectId  INT            NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY ux_IfcBuildingStorey_GlobalId (GlobalId),
  CONSTRAINT fk_storey_project
    FOREIGN KEY (ProjectId)
      REFERENCES IfcProject(id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS IfcSpace;
CREATE TABLE IfcSpace (
  id       INT            NOT NULL AUTO_INCREMENT,
  GlobalId VARCHAR(36)    NOT NULL,
  Name     VARCHAR(255),
  StoreyId INT            NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY ux_IfcSpace_GlobalId (GlobalId),
  CONSTRAINT fk_space_storey
    FOREIGN KEY (StoreyId)
      REFERENCES IfcBuildingStorey(id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------
-- 2) Core elements
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS IfcWall;
CREATE TABLE IfcWall (
  id       INT            NOT NULL AUTO_INCREMENT,
  GlobalId VARCHAR(36)    NOT NULL,
  Name     VARCHAR(255),
  SpaceId  INT            NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY ux_IfcWall_GlobalId (GlobalId),
  CONSTRAINT fk_wall_space
    FOREIGN KEY (SpaceId)
      REFERENCES IfcSpace(id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS IfcDoor;
CREATE TABLE IfcDoor (
  id       INT            NOT NULL AUTO_INCREMENT,
  GlobalId VARCHAR(36)    NOT NULL,
  Name     VARCHAR(255),
  SpaceId  INT            NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY ux_IfcDoor_GlobalId (GlobalId),
  CONSTRAINT fk_door_space
    FOREIGN KEY (SpaceId)
      REFERENCES IfcSpace(id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS IfcWindow;
CREATE TABLE IfcWindow (
  id       INT            NOT NULL AUTO_INCREMENT,
  GlobalId VARCHAR(36)    NOT NULL,
  Name     VARCHAR(255),
  SpaceId  INT            NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY ux_IfcWindow_GlobalId (GlobalId),
  CONSTRAINT fk_window_space
    FOREIGN KEY (SpaceId)
      REFERENCES IfcSpace(id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------
-- 3) Entity‐specific property tables
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS IfcBuildingStoreyProperty;
CREATE TABLE IfcBuildingStoreyProperty (
  BuildingStoreyId INT    NOT NULL,
  PSetName         VARCHAR(255),
  PropName         VARCHAR(255),
  PropValue        VARCHAR(255),
  PRIMARY KEY (BuildingStoreyId, PSetName, PropName),
  CONSTRAINT fk_bs_prop_storey
    FOREIGN KEY (BuildingStoreyId)
      REFERENCES IfcBuildingStorey(id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS IfcSpaceProperty;
CREATE TABLE IfcSpaceProperty (
  SpaceId    INT    NOT NULL,
  PSetName   VARCHAR(255),
  PropName   VARCHAR(255),
  PropValue  VARCHAR(255),
  PRIMARY KEY (SpaceId, PSetName, PropName),
  CONSTRAINT fk_space_prop_space
    FOREIGN KEY (SpaceId)
      REFERENCES IfcSpace(id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS IfcWallProperty;
CREATE TABLE IfcWallProperty (
  WallId     INT    NOT NULL,
  PSetName   VARCHAR(255),
  PropName   VARCHAR(255),
  PropValue  VARCHAR(255),
  PRIMARY KEY (WallId, PSetName, PropName),
  CONSTRAINT fk_wall_prop_wall
    FOREIGN KEY (WallId)
      REFERENCES IfcWall(id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS IfcDoorProperty;
CREATE TABLE IfcDoorProperty (
  DoorId     INT    NOT NULL,
  PSetName   VARCHAR(255),
  PropName   VARCHAR(255),
  PropValue  VARCHAR(255),
  PRIMARY KEY (DoorId, PSetName, PropName),
  CONSTRAINT fk_door_prop_door
    FOREIGN KEY (DoorId)
      REFERENCES IfcDoor(id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS IfcWindowProperty;
CREATE TABLE IfcWindowProperty (
  WindowId   INT    NOT NULL,
  PSetName   VARCHAR(255),
  PropName   VARCHAR(255),
  PropValue  VARCHAR(255),
  PRIMARY KEY (WindowId, PSetName, PropName),
  CONSTRAINT fk_window_prop_window
    FOREIGN KEY (WindowId)
      REFERENCES IfcWindow(id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------
-- 4) Property‐sets & generic EntityProperty
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS EntityProperty, Property, Pset;
CREATE TABLE Pset (
  PsetId VARCHAR(36) NOT NULL,
  Name   VARCHAR(255),
  Source VARCHAR(255),
  PRIMARY KEY (PsetId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Property (
  PropertyId VARCHAR(36) NOT NULL,
  PsetId     VARCHAR(36) NOT NULL,
  Name       VARCHAR(255),
  DataType   VARCHAR(50),
  Unit       VARCHAR(50),
  PRIMARY KEY (PropertyId),
  CONSTRAINT fk_prop_pset
    FOREIGN KEY (PsetId)
      REFERENCES Pset(PsetId)
      ON UPDATE CASCADE
      ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE EntityProperty (
  GlobalId   VARCHAR(36) NOT NULL,
  PropertyId VARCHAR(36) NOT NULL,
  Value      TEXT,
  PRIMARY KEY (GlobalId, PropertyId),
  CONSTRAINT fk_entityprop_global
    FOREIGN KEY (GlobalId)
      REFERENCES IfcSpace(GlobalId)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
  CONSTRAINT fk_entityprop_property
    FOREIGN KEY (PropertyId)
      REFERENCES Property(PropertyId)
      ON UPDATE CASCADE
      ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------
-- 5) Classification & EntityClassification
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS EntityClassification, Classification;
CREATE TABLE Classification (
  ClassId VARCHAR(36) NOT NULL,
  Name    VARCHAR(255),
  Source  VARCHAR(255),
  PRIMARY KEY (ClassId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE EntityClassification (
  GlobalId VARCHAR(36) NOT NULL,
  ClassId  VARCHAR(36) NOT NULL,
  Relation VARCHAR(100),
  PRIMARY KEY (GlobalId, ClassId),
  CONSTRAINT fk_entityclass_global
    FOREIGN KEY (GlobalId)
      REFERENCES IfcSpace(GlobalId)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
  CONSTRAINT fk_entityclass_class
    FOREIGN KEY (ClassId)
      REFERENCES Classification(ClassId)
      ON UPDATE CASCADE
      ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
