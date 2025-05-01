// IFC core entities
Table IfcBuildingStorey {
  GlobalId varchar [pk]   // primary key
  Name     varchar
}

Table IfcSpace {
  GlobalId varchar [pk]
  Name     varchar
  StoreyId varchar
}

Table IfcWall {
  GlobalId varchar [pk]
  Name     varchar
  SpaceId  varchar
}

// Doors & Windows tied to Space
Table IfcDoor {
  GlobalId varchar [pk]
  Name     varchar
  SpaceId  varchar
}

Table IfcWindow {
  GlobalId varchar [pk]
  Name     varchar
  SpaceId  varchar
}

// MEP entities all tied to Space


Table IfcLightFixture {
  GlobalId    varchar [pk]
  Name        varchar
  SpaceId     varchar
  FixtureType varchar     // FK → IfcLightFixtureType.GlobalId
}

Table IfcLightFixtureType {
  GlobalId    varchar [pk]
  Name        varchar
  Wattage     integer
  ColorTemp   integer
  ReplaceCycleDays integer  // typical replacement interval
}

Table IfcAirTerminal {
  GlobalId varchar [pk]
  Name     varchar
  SpaceId  varchar
}

Table IfcPump {
  GlobalId varchar [pk]
  Name     varchar
  SpaceId  varchar
}

Table IfcEnergyConversionDevice {
  GlobalId varchar [pk]
  Name     varchar
  SpaceId  varchar
}

Table IfcFlowController {
  GlobalId varchar [pk]
  Name     varchar
  SpaceId  varchar
}

Table IfcFlowTerminal {
  GlobalId varchar [pk]
  Name     varchar
  SpaceId  varchar
}

// *** Consolidated Distribution System ***
Table IfcDistributionSystem {
  GlobalId varchar [pk]   // each run/loop
  Name     varchar
  SpaceId  varchar
  SystemType varchar         // e.g. 'HVAC-Duct', 'Water-Pipe'
  SegmentCount  integer      // optional: number of segments in system
}

// Classification tables
Table Classification {
  ClassId varchar [pk]
  Name    varchar
  Source  varchar
}

Table EntityClassification {
  GlobalId varchar
  ClassId  varchar
  Relation varchar
  indexes {
    (GlobalId, ClassId)
  }
}

// Property Sets & Properties
Table Pset {
  PsetId varchar [pk]
  Name   varchar
  Source varchar
}

Table Property {
  PropertyId varchar [pk]
  PsetId     varchar
  Name       varchar
  DataType   varchar
  Unit       varchar
}

Table EntityProperty {
  GlobalId   varchar
  PropertyId varchar
  Value      varchar
  indexes {
    (GlobalId, PropertyId)
  }
}

Ref: IfcSpace.StoreyId                   > IfcBuildingStorey.GlobalId

Ref: IfcWall.SpaceId                     > IfcSpace.GlobalId
Ref: IfcDoor.SpaceId                     > IfcSpace.GlobalId
Ref: IfcWindow.SpaceId                   > IfcSpace.GlobalId

Ref: IfcLightFixture.SpaceId         > IfcSpace.GlobalId
Ref: IfcLightFixture.FixtureType     > IfcLightFixtureType.GlobalId
Ref: IfcAirTerminal.SpaceId              > IfcSpace.GlobalId
Ref: IfcPump.SpaceId                     > IfcSpace.GlobalId
Ref: IfcEnergyConversionDevice.SpaceId   > IfcSpace.GlobalId
Ref: IfcFlowController.SpaceId           > IfcSpace.GlobalId
Ref: IfcFlowTerminal.SpaceId             > IfcSpace.GlobalId

Ref: IfcDistributionSystem.SpaceId       > IfcSpace.GlobalId

Ref: EntityClassification.GlobalId       > IfcSpace.GlobalId   // or other IFC tables as needed
Ref: EntityClassification.ClassId        > Classification.ClassId

Ref: Property.PsetId                     > Pset.PsetId
Ref: EntityProperty.GlobalId             > IfcSpace.GlobalId   // or Any IFC table.GlobalId
Ref: EntityProperty.PropertyId           > Property.PropertyId