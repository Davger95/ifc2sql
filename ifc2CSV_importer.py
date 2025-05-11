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

# 2) define which classes you care about
CLASSES = [
    "IfcBuildingStorey",
    "IfcSpace",
    "IfcWall",
    "IfcDoor",
    "IfcWindow",
    # add more MEP classes as needed...
]

OUT_DIR = os.path.join(os.getcwd(), "ifc_output_CSV")
os.makedirs(OUT_DIR, exist_ok=True)

for cls in CLASSES:
    rows = []        # basic attributes
    props = []       # property-set entries

    # get all instances of that class
    for inst in ifc.by_type(cls):
        gid  = inst.GlobalId
        name = getattr(inst, "Name", "")
        rows.append((gid, name))

        # harvest all property-sets for this instance
        for rel in getattr(inst, 'IsDefinedBy', []):
            if rel.is_a("IfcRelDefinesByProperties"):
                pdef = rel.RelatingPropertyDefinition
                if pdef.is_a("IfcPropertySet"):
                    pset_name = getattr(pdef, "Name", "")
                    for prop in getattr(pdef, 'HasProperties', []):
                        if prop.is_a("IfcPropertySingleValue"):
                            prop_name = getattr(prop, "Name", "")
                            nominal = getattr(prop, "NominalValue", None)
                            # extract wrappedValue for all types
                            val = getattr(nominal, "wrappedValue", "") if nominal else ""
                            props.append((gid, pset_name, prop_name, val))

    # write out main CSV for the class
    csv_path = os.path.join(OUT_DIR, f"{cls}.csv")
    with open(csv_path, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["GlobalId", "Name"])
        w.writerows(rows)
    print(f"→ wrote {len(rows)} rows to {csv_path}")

    # write out properties CSV if any were found
    if props:
        prop_csv = os.path.join(OUT_DIR, f"{cls}_Properties.csv")
        with open(prop_csv, "w", newline="", encoding="utf-8") as f:
            w = csv.writer(f)
            w.writerow(["EntityGlobalId", "PSetName", "PropName", "PropValue"])
            w.writerows(props)
        print(f"→ wrote {len(props)} property rows to {prop_csv}")
    else:
        print(f"→ no properties found for class {cls}")
