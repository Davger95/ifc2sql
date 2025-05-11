-- Building hierarchy
CREATE TABLE IF NOT EXISTS IfcBuildingStorey (
  id       INT            NOT NULL AUTO_INCREMENT,
  GlobalId VARCHAR(36)    NOT NULL,
  Name     VARCHAR(255),
  PRIMARY KEY (id),
  UNIQUE KEY ux_IfcBuildingStorey_GlobalId (GlobalId)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS IfcSpace (
  id       INT            NOT NULL AUTO_INCREMENT,
  GlobalId VARCHAR(36)    NOT NULL,
  Name     VARCHAR(255),
  StoreyId INT            NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY ux_IfcSpace_GlobalId (GlobalId),
  FOREIGN KEY (StoreyId)
    REFERENCES IfcBuildingStorey (id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- Core elements
CREATE TABLE IF NOT EXISTS IfcWall (
  id       INT            NOT NULL AUTO_INCREMENT,
  GlobalId VARCHAR(36)    NOT NULL,
  Name     VARCHAR(255),
  SpaceId  INT            NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY ux_IfcWall_GlobalId (GlobalId),
  FOREIGN KEY (SpaceId)
    REFERENCES IfcSpace (id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS IfcDoor (
  id       INT            NOT NULL AUTO_INCREMENT,
  GlobalId VARCHAR(36)    NOT NULL,
  Name     VARCHAR(255),
  SpaceId  INT            NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY ux_IfcDoor_GlobalId (GlobalId),
  FOREIGN KEY (SpaceId)
    REFERENCES IfcSpace (id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS IfcWindow (
  id       INT            NOT NULL AUTO_INCREMENT,
  GlobalId VARCHAR(36)    NOT NULL,
  Name     VARCHAR(255),
  SpaceId  INT            NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY ux_IfcWindow_GlobalId (GlobalId),
  FOREIGN KEY (SpaceId)
    REFERENCES IfcSpace (id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- Classification
CREATE TABLE IF NOT EXISTS Classification (
  ClassId VARCHAR(36) NOT NULL,
  Name    VARCHAR(255),
  Source  VARCHAR(255),
  PRIMARY KEY (ClassId)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS EntityClassification (
  GlobalId VARCHAR(36) NOT NULL,
  ClassId  VARCHAR(36) NOT NULL,
  Relation VARCHAR(100),
  PRIMARY KEY (GlobalId, ClassId),
  FOREIGN KEY (GlobalId)
    REFERENCES IfcSpace (GlobalId)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
  FOREIGN KEY (ClassId)
    REFERENCES Classification (ClassId)
      ON UPDATE CASCADE
      ON DELETE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- Property sets & properties
CREATE TABLE IF NOT EXISTS Pset (
  PsetId VARCHAR(36) NOT NULL,
  Name   VARCHAR(255),
  Source VARCHAR(255),
  PRIMARY KEY (PsetId)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS Property (
  PropertyId VARCHAR(36) NOT NULL,
  PsetId     VARCHAR(36) NOT NULL,
  Name       VARCHAR(255),
  DataType   VARCHAR(50),
  Unit       VARCHAR(50),
  PRIMARY KEY (PropertyId),
  FOREIGN KEY (PsetId)
    REFERENCES Pset (PsetId)
      ON UPDATE CASCADE
      ON DELETE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS EntityProperty (
  GlobalId   VARCHAR(36) NOT NULL,
  PropertyId VARCHAR(36) NOT NULL,
  Value      TEXT,
  PRIMARY KEY (GlobalId, PropertyId),
  FOREIGN KEY (GlobalId)
    REFERENCES IfcSpace (GlobalId)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
  FOREIGN KEY (PropertyId)
    REFERENCES Property (PropertyId)
      ON UPDATE CASCADE
      ON DELETE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- bsDD material classes
CREATE TABLE IF NOT EXISTS MaterialClass (
  ClassId         INT AUTO_INCREMENT PRIMARY KEY,
  bsdd_id         VARCHAR(50)  NOT NULL UNIQUE,
  class_name      VARCHAR(255) NOT NULL,
  parent_bsdd_id  VARCHAR(50),
  parent_ClassId  INT,
  FOREIGN KEY (parent_ClassId)
    REFERENCES MaterialClass (ClassId)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- Polymorphic bridge for IFC elements → material class
CREATE TABLE IF NOT EXISTS IfcElement_MaterialClass (
  ElementType VARCHAR(50) NOT NULL,
  ElementId   INT          NOT NULL,
  ClassId     INT          NOT NULL,
  PRIMARY KEY (ElementType, ElementId, ClassId),
  FOREIGN KEY (ClassId)
    REFERENCES MaterialClass (ClassId)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;
