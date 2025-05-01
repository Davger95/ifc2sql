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
Table IfcAirTerminal {
  GlobalId varchar [pk]
  Name     varchar
  SpaceId  varchar
}

Table IfcDuctSegment {
  GlobalId varchar [pk]
  Name     varchar
  SpaceId  varchar
}

Table IfcDuctFitting {
  GlobalId varchar [pk]
  Name     varchar
  SpaceId  varchar
}

Table IfcPipeSegment {
  GlobalId varchar [pk]
  Name     varchar
  SpaceId  varchar
}

Table IfcPipeFitting {
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

Table IfcDistributionSystem {
  GlobalId varchar [pk]
  Name     varchar
  SpaceId  varchar
}

Table IfcDistributionFlowElement {
  GlobalId varchar [pk]
  Name     varchar
  SystemId varchar
}

// Classification entities
Table Classification {
  ClassId varchar [pk]
  Name    varchar
  Source  varchar
}

Table EntityClassification {
  GlobalId varchar
  ClassId  varchar
  Relation varchar
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
}

// References (foreign keys)
Ref: IfcSpace.StoreyId              > IfcBuildingStorey.GlobalId

Ref: IfcWall.SpaceId                > IfcSpace.GlobalId
Ref: IfcDoor.SpaceId                > IfcSpace.GlobalId
Ref: IfcWindow.SpaceId              > IfcSpace.GlobalId

Ref: IfcAirTerminal.SpaceId         > IfcSpace.GlobalId
Ref: IfcDuctSegment.SpaceId         > IfcSpace.GlobalId
Ref: IfcDuctFitting.SpaceId         > IfcSpace.GlobalId
Ref: IfcPipeSegment.SpaceId         > IfcSpace.GlobalId
Ref: IfcPipeFitting.SpaceId         > IfcSpace.GlobalId
Ref: IfcPump.SpaceId                > IfcSpace.GlobalId
Ref: IfcEnergyConversionDevice.SpaceId > IfcSpace.GlobalId
Ref: IfcFlowController.SpaceId      > IfcSpace.GlobalId
Ref: IfcFlowTerminal.SpaceId        > IfcSpace.GlobalId
Ref: IfcDistributionSystem.SpaceId  > IfcSpace.GlobalId
Ref: IfcDistributionFlowElement.SystemId > IfcDistributionSystem.GlobalId

Ref: EntityClassification.GlobalId  > IfcSpace.GlobalId    // or > any entity you classify
Ref: EntityClassification.ClassId   > Classification.ClassId

Ref: Property.PsetId                > Pset.PsetId
Ref: EntityProperty.GlobalId        > IfcSpace.GlobalId    // or > any entity you give a property
Ref: EntityProperty.PropertyId      > Property.PropertyId
