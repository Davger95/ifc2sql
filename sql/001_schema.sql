PRAGMA foreign_keys = ON;  -- (SQLite only; ensures FKs are enforced)

-- IFC core entities
CREATE TABLE IfcBuildingStorey (
  GlobalId TEXT PRIMARY KEY,
  Name     TEXT
);

CREATE TABLE IfcSpace (
  GlobalId TEXT PRIMARY KEY,
  Name     TEXT,
  StoreyId TEXT NOT NULL,
  FOREIGN KEY (StoreyId) REFERENCES IfcBuildingStorey (GlobalId)
);

CREATE TABLE IfcWall (
  GlobalId TEXT PRIMARY KEY,
  Name     TEXT,
  SpaceId  TEXT NOT NULL,
  FOREIGN KEY (SpaceId) REFERENCES IfcSpace (GlobalId)
);

CREATE TABLE IfcDoor (
  GlobalId TEXT PRIMARY KEY,
  Name     TEXT,
  SpaceId  TEXT NOT NULL,
  FOREIGN KEY (SpaceId) REFERENCES IfcSpace (GlobalId)
);

CREATE TABLE IfcWindow (
  GlobalId TEXT PRIMARY KEY,
  Name     TEXT,
  SpaceId  TEXT NOT NULL,
  FOREIGN KEY (SpaceId) REFERENCES IfcSpace (GlobalId)
);

-- Lighting fixtures
CREATE TABLE IfcLightFixtureType (
  GlobalId        TEXT PRIMARY KEY,
  Name            TEXT,
  Wattage         INTEGER,
  ColorTemp       INTEGER,
  ReplaceCycleDays INTEGER
);

CREATE TABLE IfcLightFixture (
  GlobalId    TEXT PRIMARY KEY,
  Name        TEXT,
  SpaceId     TEXT NOT NULL,
  FixtureType TEXT NOT NULL,
  FOREIGN KEY (SpaceId)    REFERENCES IfcSpace (GlobalId),
  FOREIGN KEY (FixtureType) REFERENCES IfcLightFixtureType (GlobalId)
);

-- Other MEP assets
CREATE TABLE IfcAirTerminal (
  GlobalId TEXT PRIMARY KEY,
  Name     TEXT,
  SpaceId  TEXT NOT NULL,
  FOREIGN KEY (SpaceId) REFERENCES IfcSpace (GlobalId)
);

CREATE TABLE IfcPump (
  GlobalId TEXT PRIMARY KEY,
  Name     TEXT,
  SpaceId  TEXT NOT NULL,
  FOREIGN KEY (SpaceId) REFERENCES IfcSpace (GlobalId)
);

CREATE TABLE IfcEnergyConversionDevice (
  GlobalId TEXT PRIMARY KEY,
  Name     TEXT,
  SpaceId  TEXT NOT NULL,
  FOREIGN KEY (SpaceId) REFERENCES IfcSpace (GlobalId)
);

CREATE TABLE IfcFlowController (
  GlobalId TEXT PRIMARY KEY,
  Name     TEXT,
  SpaceId  TEXT NOT NULL,
  FOREIGN KEY (SpaceId) REFERENCES IfcSpace (GlobalId)
);

CREATE TABLE IfcFlowTerminal (
  GlobalId TEXT PRIMARY KEY,
  Name     TEXT,
  SpaceId  TEXT NOT NULL,
  FOREIGN KEY (SpaceId) REFERENCES IfcSpace (GlobalId)
);

-- Consolidated distribution systems
CREATE TABLE IfcDistributionSystem (
  GlobalId     TEXT PRIMARY KEY,
  Name         TEXT,
  SpaceId      TEXT NOT NULL,
  SystemType   TEXT,
  SegmentCount INTEGER,
  FOREIGN KEY (SpaceId) REFERENCES IfcSpace (GlobalId)
);

-- Classification
CREATE TABLE Classification (
  ClassId TEXT PRIMARY KEY,
  Name    TEXT,
  Source  TEXT
);

CREATE TABLE EntityClassification (
  GlobalId TEXT NOT NULL,
  ClassId  TEXT NOT NULL,
  Relation TEXT,
  PRIMARY KEY (GlobalId, ClassId),
  FOREIGN KEY (GlobalId) REFERENCES IfcSpace       (GlobalId),
  FOREIGN KEY (ClassId)  REFERENCES Classification (ClassId)
);

-- Property sets & properties
CREATE TABLE Pset (
  PsetId TEXT PRIMARY KEY,
  Name   TEXT,
  Source TEXT
);

CREATE TABLE Property (
  PropertyId TEXT PRIMARY KEY,
  PsetId     TEXT NOT NULL,
  Name       TEXT,
  DataType   TEXT,
  Unit       TEXT,
  FOREIGN KEY (PsetId) REFERENCES Pset (PsetId)
);

CREATE TABLE EntityProperty (
  GlobalId   TEXT NOT NULL,
  PropertyId TEXT NOT NULL,
  Value      TEXT,
  PRIMARY KEY (GlobalId, PropertyId),
  FOREIGN KEY (GlobalId)   REFERENCES IfcSpace  (GlobalId),
  FOREIGN KEY (PropertyId) REFERENCES Property   (PropertyId)
);
