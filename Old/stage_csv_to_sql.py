# stage_csv_to_sql.py
import glob
import os
import csv
import pymysql

# 1) Configuration: adjust to your setup
CSV_DIR = "/Users/davidgerner/Downloads/PythonProject/ifcExperiment/ifc2sql/sql/CSV"
DB_CONF = {
    "user":     "ifcuser",
    "password": "ifcpass",
    "host":     "127.0.0.1",
    "port":     3308,
    "database": "ifcdb",
    "allow_local_infile": True,
}

def make_staging_table(cursor, table_name, columns):
    """Generate and execute CREATE TABLE IF NOT EXISTS staging_<table_name> (...)"""
    cols_ddl = ",\n  ".join(f"`{col}` TEXT" for col in columns)
    ddl = f"""
    CREATE TABLE IF NOT EXISTS `{table_name}` (
      {cols_ddl}
    ) ENGINE=InnoDB CHARSET=utf8mb4;
    """
    cursor.execute(ddl)

def load_csv(cursor, table_name, filepath):
    """Run LOAD DATA LOCAL INFILE for one CSV"""
    sql = f"""
    LOAD DATA LOCAL INFILE %s
    INTO TABLE `{table_name}`
    FIELDS TERMINATED BY ',' 
    OPTIONALLY ENCLOSED BY '"' 
    LINES TERMINATED BY '\\n'
    IGNORE 1 LINES
    """
    cursor.execute(sql, (filepath,))

def stage_all():
    # connect once
    conn = pymysql.connect(
        host = DB_CONF["host"],
        user = DB_CONF["user"],
        password = DB_CONF["password"],
        database = DB_CONF["database"],
        port = DB_CONF["port"],
        local_infile = True,
        charset = "utf8mb4",
        cursorclass = pymysql.cursors.Cursor)
    cursor = conn.cursor()

    for path in glob.glob(os.path.join(CSV_DIR, "*.csv")):
        base = os.path.splitext(os.path.basename(path))[0]
        table = f"staging_{base}"
        # read header row
        with open(path, newline="") as f:
            reader = csv.reader(f)
            header = next(reader)

        print(f"→ Creating table `{table}` …")
        make_staging_table(cursor, table, header)
        print(f"→ Loading {os.path.basename(path)} into `{table}` …")
        load_csv(cursor, table, os.path.abspath(path))
        conn.commit()

    cursor.close()
    conn.close()
    print("All CSVs staged.")

if __name__ == "__main__":
    stage_all()