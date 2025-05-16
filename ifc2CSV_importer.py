import os
import csv
import sys
import ifcopenshell

# 1) open your IFC
if len(sys.argv) < 2:
    print("Usage: python ifc2CSV_importer.py path/to/your.ifc")
    sys.exit(1)

ifc_path = sys.argv[1]
ifc = ifcopenshell.open(ifc_path)

# Extract the project GlobalId (assuming one IfcProject in the file)
projects = ifc.by_type("IfcProject")
project_gid = projects[0].GlobalId if projects else ""

# 2) define which classes you care about and their parent FK column name
CLASSES = [
    ("IfcBuildingStorey", "ProjectGlobalId"),
    ("IfcSpace",            "StoreyGlobalId"),
    ("IfcWall",             "SpaceGlobalId"),
    ("IfcDoor",             "SpaceGlobalId"),
    ("IfcWindow",           "SpaceGlobalId"),
]

OUT_DIR = "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads"
os.makedirs(OUT_DIR, exist_ok=True)

for cls, parent_col in CLASSES:
    rows = []   # will hold tuples (GlobalId, Name, ParentGlobalId)
    props = []  # will hold tuples (EntityGlobalId, PSetName, PropName, PropValue)

    for inst in ifc.by_type(cls):
        gid  = inst.GlobalId
        name = getattr(inst, "Name", "") or ""

        # resolve parent GlobalId
        parent_gid = ""
        if cls == "IfcBuildingStorey":
            parent_gid = project_gid
        elif cls == "IfcSpace":
            # building-storey via IfcRelAggregates
            for rel in getattr(inst, "Decomposes", []):
                if rel.is_a("IfcRelAggregates"):
                    parent_gid = rel.RelatingObject.GlobalId
                    break
        else:
            # walls/doors/windows via IfcRelContainedInSpatialStructure
            for rel in getattr(inst, "ContainedInStructure", []):
                if rel.is_a("IfcRelContainedInSpatialStructure"):
                    parent = rel.RelatingStructure
                    parent_gid = getattr(parent, "GlobalId", "")
                    break

        rows.append((gid, name, parent_gid))

        # harvest property-sets
        for rel in getattr(inst, "IsDefinedBy", []):
            if rel.is_a("IfcRelDefinesByProperties"):
                pdef = rel.RelatingPropertyDefinition
                if pdef.is_a("IfcPropertySet"):
                    pset_name = getattr(pdef, "Name", "") or ""
                    for prop in getattr(pdef, "HasProperties", []):
                        if prop.is_a("IfcPropertySingleValue"):
                            prop_name = getattr(prop, "Name", "") or ""
                            nominal   = getattr(prop, "NominalValue", None)
                            val       = getattr(nominal, "wrappedValue", "") if nominal else ""
                            props.append((gid, pset_name, prop_name, val))

    # write main CSV
    csv_path = os.path.join(OUT_DIR, f"{cls}.csv")
    with open(csv_path, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["GlobalId", "Name", parent_col])
        writer.writerows(rows)
    print(f"→ wrote {len(rows)} rows to {csv_path}")

    # write properties CSV
    if props:
        prop_csv = os.path.join(OUT_DIR, f"{cls}_Properties.csv")
        with open(prop_csv, "w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow(["EntityGlobalId", "PSetName", "PropName", "PropValue"])
            writer.writerows(props)
        print(f"→ wrote {len(props)} property rows to {prop_csv}")
    else:
        print(f"→ no properties found for class {cls}")
