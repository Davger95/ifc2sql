-- 002_transform.sql
-- ELT: load filtered IFC entities from raw into production

-- 1. Attach the raw import database
ATTACH DATABASE 'ifcdb_raw.sqlite' AS raw;

-- 2. Populate Building Storeys
INSERT INTO IfcBuildingStorey (GlobalId, Name)
SELECT GlobalId, Name
  FROM raw.IfcBuildingStorey
  WHERE GlobalId IS NOT NULL;

-- 3. Populate Spaces
INSERT INTO IfcSpace (GlobalId, Name, StoreyId)
SELECT GlobalId, Name, StoreyId
  FROM raw.IfcSpace
  WHERE StoreyId IN (SELECT GlobalId FROM IfcBuildingStorey);

-- 4. Populate Walls, Doors, Windows
INSERT INTO IfcWall (GlobalId, Name, SpaceId)
SELECT GlobalId, Name, SpaceId
  FROM raw.IfcWall
  WHERE SpaceId IN (SELECT GlobalId FROM IfcSpace);

INSERT INTO IfcDoor (GlobalId, Name, SpaceId)
SELECT GlobalId, Name, SpaceId
  FROM raw.IfcDoor
  WHERE SpaceId IN (SELECT GlobalId FROM IfcSpace);

INSERT INTO IfcWindow (GlobalId, Name, SpaceId)
SELECT GlobalId, Name, SpaceId
  FROM raw.IfcWindow
  WHERE SpaceId IN (SELECT GlobalId FROM IfcSpace);

-- 5. Populate MEP assets
INSERT INTO IfcAirTerminal (GlobalId, Name, SpaceId)
SELECT GlobalId, Name, SpaceId
  FROM raw.IfcAirTerminal
  WHERE SpaceId IN (SELECT GlobalId FROM IfcSpace);

INSERT INTO IfcPump (GlobalId, Name, SpaceId)
SELECT GlobalId, Name, SpaceId
  FROM raw.IfcPump
  WHERE SpaceId IN (SELECT GlobalId FROM IfcSpace);

INSERT INTO IfcEnergyConversionDevice (GlobalId, Name, SpaceId)
SELECT GlobalId, Name, SpaceId
  FROM raw.IfcEnergyConversionDevice
  WHERE SpaceId IN (SELECT GlobalId FROM IfcSpace);

INSERT INTO IfcFlowController (GlobalId, Name, SpaceId)
SELECT GlobalId, Name, SpaceId
  FROM raw.IfcFlowController
  WHERE SpaceId IN (SELECT GlobalId FROM IfcSpace);

INSERT INTO IfcFlowTerminal (GlobalId, Name, SpaceId)
SELECT GlobalId, Name, SpaceId
  FROM raw.IfcFlowTerminal
  WHERE SpaceId IN (SELECT GlobalId FROM IfcSpace);

INSERT INTO IfcDistributionSystem (GlobalId, Name, SpaceId, SystemType, SegmentCount)
SELECT
  GlobalId,
  Name,
  SpaceId,
  json_extract(json, '$.PredefinedType') AS SystemType,  -- if available in raw
  (SELECT COUNT(*) FROM raw.IfcDistributionFlowElement fe
     WHERE fe.SystemId = ds.GlobalId)                   AS SegmentCount
FROM raw.IfcDistributionSystem ds
WHERE SpaceId IN (SELECT GlobalId FROM IfcSpace);

-- 6. Populate Light Fixtures & Types
INSERT INTO IfcLightFixtureType (GlobalId, Name, Wattage, ColorTemp, ReplaceCycleDays)
SELECT GlobalId, Name,
       CAST(json_extract(json, '$.Wattage') AS INTEGER),
       CAST(json_extract(json, '$.ColorTemperature') AS INTEGER),
       CAST(json_extract(json, '$.ReplacementInterval') AS INTEGER)
  FROM raw.IfcLightFixtureType;

INSERT INTO IfcLightFixture (GlobalId, Name, SpaceId, FixtureType)
SELECT GlobalId, Name, SpaceId, PredefinedType
  FROM raw.IfcLightFixture
  WHERE SpaceId IN (SELECT GlobalId FROM IfcSpace);

-- 7. Populate Classifications
INSERT INTO Classification (ClassId, Name, Source)
SELECT ClassId, Name, Source
  FROM raw.Classification;

INSERT INTO EntityClassification (GlobalId, ClassId, Relation)
SELECT GlobalId, ClassId, Relation
  FROM raw.EntityClassification
  WHERE GlobalId IN (
    SELECT GlobalId FROM IfcSpace
    UNION
    SELECT GlobalId FROM IfcDoor
    UNION
    SELECT GlobalId FROM IfcWindow
  );

-- 8. Populate P-sets & Properties
INSERT INTO Pset (PsetId, Name, Source)
SELECT PsetId, Name, Source
  FROM raw.Pset;

INSERT INTO Property (PropertyId, PsetId, Name, DataType, Unit)
SELECT PropertyId, PsetId, Name, DataType, Unit
  FROM raw.Property;

INSERT INTO EntityProperty (GlobalId, PropertyId, Value)
SELECT GlobalId, PropertyId, Value
  FROM raw.EntityProperty
  WHERE GlobalId IN (
    SELECT GlobalId FROM IfcSpace
    UNION
    SELECT GlobalId FROM IfcDoor
    UNION
    SELECT GlobalId FROM IfcWindow
    UNION
    SELECT GlobalId FROM IfcLightFixture
  );

-- 9. Detach raw DB
DETACH DATABASE raw;
