# IFCEtoSQL Pipeline

This repository contains an end-to-end pipeline to extract data from IFC (Industry Foundation Classes) files into a MySQL database via intermediate CSVs.

## Prerequisites

1. **Conda Environment** (or virtualenv)

   * Python 3.8+
   * `ifcopenshell`
   * `pymysql`
2. **Docker & Docker Compose**
3. **IFC-OpenShell** (cloned or as a submodule, if you need `ifcpatch`)

## Repository Structure

```
ifc2sql/
├── export_ifc_to_csv.py      # Exports specified IFC classes to CSV
├── stage_csv_to_sql.py       # Auto-creates staging tables and loads CSVs
├── sql/
│   ├── 001_schema.sql        # DDL for production schema (MySQL-adjusted)
│   ├── 002_transform_mysql.sql # Transform script from staging to production
│   └── CSV/                  # Directory for exported CSV files
├── docker-compose.yml        # Defines MySQL service with local-infile enabled
├── .gitignore
└── README.md                 # (this file)
```

## Setup

1. **Clone the repo**

   ```bash
   git clone <your-repo-url> ifc2sql
   cd ifc2sql
   ```

2. **Create & activate environment**

   ```bash
   conda create -n ifc2sql python=3.11
   conda activate ifc2sql

   pip install ifcopenshell pymysql
   ```

3. **Ensure Docker is running**

4. **Configure `.env`** (create a `.env` alongside `docker-compose.yml`):

   ```dotenv
   MYSQL_ROOT_PASSWORD=rootpass
   MYSQL_USER=ifcuser
   MYSQL_PASSWORD=ifcpass
   MYSQL_DATABASE=ifcdb
   ```

5. **Start MySQL container**

   ```bash
   docker-compose up --build --force-recreate --detach
   ```

## Workflow

### 1. Export IFC to CSV

Run the exporter specifying your IFC file:

```bash
python ifc2CSV_importer.py path/to/your.ifc
```

* CSVs will be saved to `sql/CSV/Ifc<ClassName>.csv`.

### 2. Stage CSVs to MySQL

Load CSVs into staging tables:

```bash
python stage_csv_to_sql.py
```

* Automatically creates `staging_<ClassName>` tables.
* Uses `LOAD DATA LOCAL INFILE` under the hood.

### 3. Load Production Schema

Apply the DDL to create production tables:

```bash
mysql -h 127.0.0.1 -P 3308 -u ifcuser -pifcpass ifcdb < sql/001_schema.sql
```

### 4. Transform Staging → Production

Run the transform script:

```bash
mysql -h 127.0.0.1 -P 3308 -u ifcuser -pifcpass ifcdb < sql/002_transform_mysql.sql
```

### 5. Verify Data

Check row counts:

```bash
mysql -h 127.0.0.1 -P 3308 -u ifcuser -pifcpass -e "USE ifcdb; \
  SELECT 'IfcSpace', COUNT(*) FROM IfcSpace;"
```

Spot-check:

```sql
SELECT * FROM IfcSpace LIMIT 5;
SELECT * FROM IfcWall LIMIT 5;
```

## Next Steps

* Add indexes in MySQL for performance.
* Create views (e.g., `vw_elements_by_space`).
* Hook up a BI tool (Metabase, Tableau) to `127.0.0.1:3308`.
* Extend exporter to include more IFC classes or property sets.
* Automate pipeline using Airflow, Prefect, or cron.

---

Happy modeling!
