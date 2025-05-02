
CREATE TABLE IfcBuildingStorey (
  GlobalId       VARCHAR(36)   NOT NULL,
  Name           VARCHAR(255),
  PRIMARY KEY (GlobalId)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IfcSpace (
  GlobalId       VARCHAR(36)   NOT NULL,
  Name           VARCHAR(255),
  StoreyId       VARCHAR(36)   NOT NULL,
  PRIMARY KEY (GlobalId),
  FOREIGN KEY (StoreyId) REFERENCES IfcBuildingStorey (GlobalId)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IfcWall (
  GlobalId       VARCHAR(36)   NOT NULL,
  Name           VARCHAR(255),
  SpaceId        VARCHAR(36)   NOT NULL,
  PRIMARY KEY (GlobalId),
  FOREIGN KEY (SpaceId) REFERENCES IfcSpace (GlobalId)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IfcDoor (
  GlobalId       VARCHAR(36)   NOT NULL,
  Name           VARCHAR(255),
  SpaceId        VARCHAR(36)   NOT NULL,
  PRIMARY KEY (GlobalId),
  FOREIGN KEY (SpaceId) REFERENCES IfcSpace (GlobalId)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IfcWindow (
  GlobalId       VARCHAR(36)   NOT NULL,
  Name           VARCHAR(255),
  SpaceId        VARCHAR(36)   NOT NULL,
  PRIMARY KEY (GlobalId),
  FOREIGN KEY (SpaceId) REFERENCES IfcSpace (GlobalId)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- Lighting fixtures
CREATE TABLE IfcLightFixtureType (
  GlobalId        VARCHAR(36)   NOT NULL,
  Name            VARCHAR(255),
  Wattage         INT,
  ColorTemp       INT,
  ReplaceCycleDays INT,
  PRIMARY KEY (GlobalId)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IfcLightFixture (
  GlobalId    VARCHAR(36)   NOT NULL,
  Name        VARCHAR(255),
  SpaceId     VARCHAR(36)   NOT NULL,
  FixtureType VARCHAR(36)   NOT NULL,
  PRIMARY KEY (GlobalId),
  FOREIGN KEY (SpaceId)    REFERENCES IfcSpace              (GlobalId)
      ON UPDATE CASCADE
      ON DELETE RESTRICT,
  FOREIGN KEY (FixtureType) REFERENCES IfcLightFixtureType   (GlobalId)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- Other MEP assets
CREATE TABLE IfcAirTerminal (
  GlobalId VARCHAR(36)   NOT NULL,
  Name     VARCHAR(255),
  SpaceId  VARCHAR(36)   NOT NULL,
  PRIMARY KEY (GlobalId),
  FOREIGN KEY (SpaceId) REFERENCES IfcSpace (GlobalId)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IfcPump (
  GlobalId VARCHAR(36)   NOT NULL,
  Name     VARCHAR(255),
  SpaceId  VARCHAR(36)   NOT NULL,
  PRIMARY KEY (GlobalId),
  FOREIGN KEY (SpaceId) REFERENCES IfcSpace (GlobalId)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IfcEnergyConversionDevice (
  GlobalId VARCHAR(36)   NOT NULL,
  Name     VARCHAR(255),
  SpaceId  VARCHAR(36)   NOT NULL,
  PRIMARY KEY (GlobalId),
  FOREIGN KEY (SpaceId) REFERENCES IfcSpace (GlobalId)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IfcFlowController (
  GlobalId VARCHAR(36)   NOT NULL,
  Name     VARCHAR(255),
  SpaceId  VARCHAR(36)   NOT NULL,
  PRIMARY KEY (GlobalId),
  FOREIGN KEY (SpaceId) REFERENCES IfcSpace (GlobalId)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IfcFlowTerminal (
  GlobalId VARCHAR(36)   NOT NULL,
  Name     VARCHAR(255),
  SpaceId  VARCHAR(36)   NOT NULL,
  PRIMARY KEY (GlobalId),
  FOREIGN KEY (SpaceId) REFERENCES IfcSpace (GlobalId)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- Consolidated distribution systems
CREATE TABLE IfcDistributionSystem (
  GlobalId     VARCHAR(36)   NOT NULL,
  Name         VARCHAR(255),
  SpaceId      VARCHAR(36)   NOT NULL,
  SystemType   VARCHAR(100),
  SegmentCount INT,
  PRIMARY KEY (GlobalId),
  FOREIGN KEY (SpaceId) REFERENCES IfcSpace (GlobalId)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- Classification
CREATE TABLE Classification (
  ClassId VARCHAR(36)   NOT NULL,
  Name    VARCHAR(255),
  Source  VARCHAR(255),
  PRIMARY KEY (ClassId)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE EntityClassification (
  GlobalId VARCHAR(36)   NOT NULL,
  ClassId  VARCHAR(36)   NOT NULL,
  Relation VARCHAR(100),
  PRIMARY KEY (GlobalId, ClassId),
  FOREIGN KEY (GlobalId) REFERENCES IfcSpace       (GlobalId)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
  FOREIGN KEY (ClassId)  REFERENCES Classification (ClassId)
      ON UPDATE CASCADE
      ON DELETE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- Property sets & properties
CREATE TABLE Pset (
  PsetId VARCHAR(36)   NOT NULL,
  Name   VARCHAR(255),
  Source VARCHAR(255),
  PRIMARY KEY (PsetId)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Property (
  PropertyId VARCHAR(36)   NOT NULL,
  PsetId     VARCHAR(36)   NOT NULL,
  Name       VARCHAR(255),
  DataType   VARCHAR(50),
  Unit       VARCHAR(50),
  PRIMARY KEY (PropertyId),
  FOREIGN KEY (PsetId) REFERENCES Pset (PsetId)
      ON UPDATE CASCADE
      ON DELETE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE EntityProperty (
  GlobalId   VARCHAR(36)   NOT NULL,
  PropertyId VARCHAR(36)   NOT NULL,
  Value      TEXT,
  PRIMARY KEY (GlobalId, PropertyId),
  FOREIGN KEY (GlobalId)   REFERENCES IfcSpace  (GlobalId)
      ON UPDATE CASCADE
      ON DELETE CASCADE,
  FOREIGN KEY (PropertyId) REFERENCES Property   (PropertyId)
      ON UPDATE CASCADE
      ON DELETE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;
