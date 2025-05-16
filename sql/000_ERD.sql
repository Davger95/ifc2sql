Table IfcProject {
  id        int          [pk]
  GlobalId  varchar(36)  [unique]
  Name      varchar(255)
}

// IFC Core Entities
Table IfcBuildingStorey {
  id         int          [pk]
  GlobalId   varchar(36)  [unique]
  Name       varchar(255)
  ProjectId  int          [ref: > IfcProject.id]
}

Table IfcSpace {
   id        int         [pk]
  GlobalId  varchar(36) [unique]
  Name      varchar(255)
  StoreyId  int         [ref: > IfcBuildingStorey.id]
}

Table IfcWall {
  id         int            [pk]
  GlobalId   varchar(36)    [unique]
  Name       varchar(255)
  SpaceId    int            [ref: > IfcSpace.id]
}

Table IfcDoor {
  id         int            [pk]
  GlobalId   varchar(36)    [unique]
  Name       varchar(255)
  SpaceId    int            [ref: > IfcSpace.id]
}

Table IfcWindow {
  id         int            [pk]
  GlobalId   varchar(36)    [unique]
  Name       varchar(255)
  SpaceId    int            [ref: > IfcSpace.id]
}

// Material / Cost / Emission Lookups
Table MaterialType {
  id    int            [pk]
  Name  varchar(255)
}

Table CostReference {
  id    int            [pk]
  Value decimal(12,2)
  Unit  varchar(50)
}

Table EmissionReference {
  id    int            [pk]
  Value decimal(12,2)
  Unit  varchar(50)
}

// Polymorphic Metrics Link
Table ElementMetrics {
  element_type         varchar(50)    [pk]  // 'IfcWall' | 'IfcDoor' | 'IfcWindow'
  element_id           int            [pk]
  material_type_id     int            [ref: > MaterialType.id]
  cost_reference_id    int            [ref: > CostReference.id]
  emission_reference_id int           [ref: > EmissionReference.id]
}

// Classification Module
Table Classification {
  ClassId varchar(36)   [pk]
  Name    varchar(255)
  Source  varchar(255)
}

Table EntityClassification {
  GlobalId varchar(36)   [pk]
  ClassId  varchar(36)   [pk, ref: > Classification.ClassId]
  Relation varchar(100)
}

// Property‐sets Module
Table Pset {
  PsetId varchar(36)     [pk]
  Name   varchar(255)
  Source varchar(255)
}

Table Property {
  PropertyId varchar(36) [pk]
  PsetId     varchar(36) [ref: > Pset.PsetId]
  Name       varchar(255)
  DataType   varchar(50)
  Unit       varchar(50)
}

Table EntityProperty {
  GlobalId   varchar(36) [pk]
  PropertyId varchar(36) [pk, ref: > Property.PropertyId]
  Value      text
}
