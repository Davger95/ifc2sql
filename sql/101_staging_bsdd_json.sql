-- Raw JSON → staging_bsdd_json
CREATE TABLE IF NOT EXISTS staging_bsdd_json (doc JSON);

LOAD DATA LOCAL INFILE 'SourceData/MaterialClassification.json'
INTO TABLE staging_bsdd_json (@raw)
SET doc = CAST(@raw AS JSON);

-- Flatten into staging_bsdd_materials
CREATE TABLE IF NOT EXISTS staging_bsdd_materials (
  bsdd_id    VARCHAR(50) PRIMARY KEY,
  class_name VARCHAR(255),
  parent_id  VARCHAR(50)
);

INSERT IGNORE INTO staging_bsdd_materials (bsdd_id, class_name, parent_id)
SELECT
  jt.referenceCode, jt.name, jt.parentCode
FROM staging_bsdd_json AS s
CROSS JOIN JSON_TABLE(
  s.doc, '$[*]'
  COLUMNS (
    referenceCode VARCHAR(50) PATH '$.referenceCode',
    name          VARCHAR(255) PATH '$.name',
    parentCode    VARCHAR(50) PATH '$.parentClassReference.code'
  )
) AS jt;
