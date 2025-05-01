import ifcopenshell, logging
from ifcpatch.recipes.Ifc2Sql import Patcher

# 1. open your IFC
model = ifcopenshell.open("/Users/davidgerner/Downloads/PythonProject/ifcExperiment/ifc2sql/wall-with-opening-and-window.ifc")
# (the “No MySQL support” warning just means your build of ifcopenshell
#  wasn’t compiled with MySQL connectors—it doesn’t block SQLite usage)

# 2. optional console logger
logger = logging.getLogger("Ifc2Sql")
logger.setLevel(logging.INFO)
h = logging.StreamHandler()
h.setFormatter(logging.Formatter("[%(levelname)s] %(message)s"))
logger.addHandler(h)

# 3. instantiate the patcher—no SQLTypes import needed:
patcher = Patcher(
    file        = model,
    logger      = logger,
    sql_type    = "SQLite",
    database    = "ifcdb_raw.sqlite",
    full_schema = False,
    # …
)



# 4. run it
patcher.patch()
logger.info("Done! Your IFC data is now in SQLite database `ifcdb`.")
