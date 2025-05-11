USE ifcdb;

-- ===================================================================
-- 1) (Re)create staging tables with AUTO_INCREMENT ids
-- ===================================================================
DROP TABLE IF EXISTS staging_IfcBuildingStorey;
CREATE TABLE staging_IfcBuildingStorey (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  GlobalId     VARCHAR(64),
  Name         VARCHAR(255)
);

DROP TABLE IF EXISTS staging_IfcBuildingStorey_Properties;
CREATE TABLE staging_IfcBuildingStorey_Properties (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  EntityGlobalId VARCHAR(64),
  PSetName       VARCHAR(255),
  PropName       VARCHAR(255),
  PropValue      VARCHAR(255)
);

-- Repeat for each class:
DROP TABLE IF EXISTS staging_IfcSpace;
CREATE TABLE staging_IfcSpace (
  id       INT AUTO_INCREMENT PRIMARY KEY,
  GlobalId VARCHAR(64),
  Name     VARCHAR(255)
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
  id       INT AUTO_INCREMENT PRIMARY KEY,
  GlobalId VARCHAR(64),
  Name     VARCHAR(255)
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
  id       INT AUTO_INCREMENT PRIMARY KEY,
  GlobalId VARCHAR(64),
  Name     VARCHAR(255)
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
  id       INT AUTO_INCREMENT PRIMARY KEY,
  GlobalId VARCHAR(64),
  Name     VARCHAR(255)
);
DROP TABLE IF EXISTS staging_IfcWindow_Properties;
CREATE TABLE staging_IfcWindow_Properties (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  EntityGlobalId VARCHAR(64),
  PSetName       VARCHAR(255),
  PropName       VARCHAR(255),
  PropValue      VARCHAR(255)
);

DELIMITER $$
CREATE PROCEDURE load_all_staging()
BEGIN
  DECLARE cls         VARCHAR(64);
  DECLARE done_main   INT DEFAULT 0;
  DECLARE skip_err    INT DEFAULT 0;

  -- Cursor over your five classes
  DECLARE cur CURSOR FOR
    SELECT class_name FROM (
      SELECT 'IfcBuildingStorey' AS class_name UNION ALL
      SELECT 'IfcSpace'             UNION ALL
      SELECT 'IfcWall'              UNION ALL
      SELECT 'IfcDoor'              UNION ALL
      SELECT 'IfcWindow'
    ) AS classes;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done_main = 1;

  OPEN cur;
  main_loop: LOOP
    FETCH cur INTO cls;
    IF done_main THEN 
      LEAVE main_loop; 
    END IF;

    -- 2.a) Load the main <Class>.csv
    SET @tbl  = CONCAT('staging_', cls);
    SET @file = CONCAT('C:/Users/irmakoezarslan/Documents/IFCproject/ifc2sql/ifc_output_CSV/',
                       cls, '.csv');
    SET @sql  = CONCAT(
      "LOAD DATA LOCAL INFILE '", @file, "' INTO TABLE ", @tbl,
      " FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"'",
      " LINES TERMINATED BY '\\n' IGNORE 1 LINES;"
    );
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- 2.b) Load the <Class>_Properties.csv, but skip if missing
    SET @prop_tbl  = CONCAT('staging_', cls, '_Properties');
    SET @prop_file = CONCAT('C:/Users/irmakoezarslan/Documents/IFCproject/ifc2sql/ifc_output_CSV/',
                            cls, '_Properties.csv');
    BEGIN
      DECLARE CONTINUE HANDLER FOR SQLSTATE 'HY000' SET skip_err = 1;
      SET skip_err = 0;
      SET @sql = CONCAT(
        "LOAD DATA LOCAL INFILE '", @prop_file, "' INTO TABLE ", @prop_tbl,
        " FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"'",
        " LINES TERMINATED BY '\\n' IGNORE 1 LINES;"
      );
      PREPARE stmt2 FROM @sql;
      EXECUTE stmt2;
      DEALLOCATE PREPARE stmt2;
      -- if skip_err=1, the file or table wasn’t there, but we just continue
    END;

  END LOOP;
  CLOSE cur;
END$$
DELIMITER ;


CALL load_all_staging();
