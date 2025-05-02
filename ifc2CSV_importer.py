import os
import csv
import sys
import ifcopenshell

# 1) open your IFC
ifc = ifcopenshell.open(sys.argv[1])

# 2) define which classes you care about
CLASSES = [
    "IfcBuildingStorey",
    "IfcSpace",
    "IfcWall",
    "IfcDoor",
    "IfcWindow",
    # add more MEP classes as needed...
]

# 3) define and ensure your output folder
OUT_DIR = "/Users/davidgerner/Downloads/PythonProject/ifcExperiment/ifc2sql/sql/CSV"
os.makedirs(OUT_DIR, exist_ok=True)

for cls in CLASSES:
    rows = []
    # get all instances of that class
    for inst in ifc.by_type(cls):
        gid  = inst.GlobalId
        name = getattr(inst, "Name", "")
        rows.append((gid, name))

    # build the full path
    csv_path = os.path.join(OUT_DIR, f"{cls}.csv")

    # write out a CSV per class
    with open(csv_path, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["GlobalId", "Name"])
        w.writerows(rows)

    print(f"→ wrote {len(rows)} rows to {csv_path}")
