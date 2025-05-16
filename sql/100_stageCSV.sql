USE ifcdb;

-- ===================================================================
-- 1) (Re)create staging tables with AUTO_INCREMENT ids
-- ===================================================================
DROP TABLE IF EXISTS staging_IfcBuildingStorey;
CREATE TABLE staging_IfcBuildingStorey (
  id               INT AUTO_INCREMENT PRIMARY KEY,
  GlobalId         VARCHAR(36),
  Name             VARCHAR(255),
  ProjectGlobalId  VARCHAR(36),
  ProjectName      VARCHAR(255)  -- if you need to capture the project’s Name
);

DROP TABLE IF EXISTS staging_IfcBuildingStorey_Properties;
CREATE TABLE staging_IfcBuildingStorey_Properties (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  EntityGlobalId VARCHAR(64),
  PSetName       VARCHAR(255),
  PropName       VARCHAR(255),
  PropValue      VARCHAR(255)
);

DROP TABLE IF EXISTS staging_IfcSpace;
CREATE TABLE staging_IfcSpace (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  GlobalId        VARCHAR(64),
  Name            VARCHAR(255),
  StoreyGlobalId  VARCHAR(64)
);

DROP TABLE IF EXISTS staging_IfcSpace_Properties;
CREATE TABLE staging_IfcSpace_Properties (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  EntityGlobalId VARCHAR(64),
  PSetName       VARCHAR(255),
  PropName       VARCHAR(255),
  PropValue      VARCHAR(255)
);

DROP TABLE IF EXISTS staging_IfcWall;
CREATE TABLE staging_IfcWall (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  GlobalId       VARCHAR(64),
  Name           VARCHAR(255),
  SpaceGlobalId  VARCHAR(64)
);

DROP TABLE IF EXISTS staging_IfcWall_Properties;
CREATE TABLE staging_IfcWall_Properties (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  EntityGlobalId VARCHAR(64),
  PSetName       VARCHAR(255),
  PropName       VARCHAR(255),
  PropValue      VARCHAR(255)
);

DROP TABLE IF EXISTS staging_IfcDoor;
CREATE TABLE staging_IfcDoor (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  GlobalId       VARCHAR(64),
  Name           VARCHAR(255),
  SpaceGlobalId  VARCHAR(64)
);

DROP TABLE IF EXISTS staging_IfcDoor_Properties;
CREATE TABLE staging_IfcDoor_Properties (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  EntityGlobalId VARCHAR(64),
  PSetName       VARCHAR(255),
  PropName       VARCHAR(255),
  PropValue      VARCHAR(255)
);

DROP TABLE IF EXISTS staging_IfcWindow;
CREATE TABLE staging_IfcWindow (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  GlobalId       VARCHAR(64),
  Name           VARCHAR(255),
  SpaceGlobalId  VARCHAR(64)
);

DROP TABLE IF EXISTS staging_IfcWindow_Properties;
CREATE TABLE staging_IfcWindow_Properties (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  EntityGlobalId VARCHAR(64),
  PSetName       VARCHAR(255),
  PropName       VARCHAR(255),
  PropValue      VARCHAR(255)
);


-- ===================================================================
-- 2) Load each CSV into its staging table
--    note the explicit column lists below
-- ===================================================================

-- BuildingStorey (has 3 columns in CSV: GlobalId,Name,ProjectGlobalId)
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/IfcBuildingStorey.csv'
  INTO TABLE staging_IfcBuildingStorey
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (GlobalId, Name, ProjectGlobalId, ProjectName);

-- BuildingStorey properties (4 columns)
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/IfcBuildingStorey_Properties.csv'
  INTO TABLE staging_IfcBuildingStorey_Properties
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (EntityGlobalId, PSetName, PropName, PropValue);

-- Space (GlobalId,Name,StoreyGlobalId)
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/IfcSpace.csv'
  INTO TABLE staging_IfcSpace
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (GlobalId, Name, StoreyGlobalId);

-- Space properties
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/IfcSpace_Properties.csv'
  INTO TABLE staging_IfcSpace_Properties
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (EntityGlobalId, PSetName, PropName, PropValue);

-- Wall (GlobalId,Name,SpaceGlobalId)
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/IfcWall.csv'
  INTO TABLE staging_IfcWall
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (GlobalId, Name, SpaceGlobalId);

-- Wall properties
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/IfcWall_Properties.csv'
  INTO TABLE staging_IfcWall_Properties
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (EntityGlobalId, PSetName, PropName, PropValue);

-- Door (GlobalId,Name,SpaceGlobalId)
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/IfcDoor.csv'
  INTO TABLE staging_IfcDoor
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (GlobalId, Name, SpaceGlobalId);

-- Door properties
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/IfcDoor_Properties.csv'
  INTO TABLE staging_IfcDoor_Properties
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (EntityGlobalId, PSetName, PropName, PropValue);

-- Window (GlobalId,Name,SpaceGlobalId)
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/IfcWindow.csv'
  INTO TABLE staging_IfcWindow
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (GlobalId, Name, SpaceGlobalId);

-- Window properties
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/IfcWindow_Properties.csv'
  INTO TABLE staging_IfcWindow_Properties
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (EntityGlobalId, PSetName, PropName, PropValue);

-- ===================================================================
-- 3) (Optional) call transformation proc or proceed manually
-- ===================================================================
-- CALL load_all_staging();
