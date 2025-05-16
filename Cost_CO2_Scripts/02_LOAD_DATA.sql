
ALTER TABLE sustainability_table 
ADD COLUMN real_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

LOAD DATA LOCAL INFILE 'C:/Users/irmak/Desktop/SQL_prep_IFC_project/Sustainability_Score_Swiss_Government2.csv'
INTO TABLE sustainability_table
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\r\n'  -- CRLF line endings
IGNORE 1 LINES
(
  @dummy, @UU_ID, @material_name, @No_ID, @Entsorgung,
  @Volume_Mass, @Ref_unit, @UBP_Total, @Fabrication_UBP, @Eliminator_UBP,
  @Total_kWH, @Total_kWH_fabrication, @Energy_fabrication_kWH, @Material_fabrication_kWH,
  @Elimination_kWH, @Total_co2_emission, @Co2_fabrication, @Co2_elimination_kg,
  @Biogener_in_product_kg
)
SET
  UU_ID = TRIM(@UU_ID),
  material_name= IF(TRIM(@material_name) = '' OR @material_name IS NULL, NULL, TRIM(REPLACE(@material_name, '’', ''))),
    No_ID = IF(TRIM(@No_ID) = '' OR @No_ID IS NULL OR @No_ID = '-', NULL, REPLACE(REPLACE(TRIM(@No_ID), '’', ''), ' ', '')),  -- Handling "-" as NULL for No_ID
  Entsorgung = IF(TRIM(@Entsorgung) = '' OR @Entsorgung IS NULL, NULL, TRIM(REPLACE(@Entsorgung, '’', ''))),
    Volume_Mass = IF(TRIM(@Volume_Mass) = '' OR @Volume_Mass IS NULL, NULL, REPLACE(REPLACE(TRIM(@Volume_Mass), '’', ''), ' ', '')),
  Ref_unit = IF(TRIM(@Ref_unit) = '' OR @Ref_unit IS NULL, NULL, TRIM(@Ref_unit)),
  UBP_Total = IF(TRIM(@UBP_Total) = '' OR @UBP_Total IS NULL, NULL, REPLACE(REPLACE(TRIM(@UBP_Total), '’', ''), ' ', '')),
  Fabrication_UBP = IF(TRIM(@Fabrication_UBP) = '' OR @Fabrication_UBP IS NULL, NULL, REPLACE(REPLACE(TRIM(@Fabrication_UBP), '’', ''), ' ', '')),
  Eliminator_UBP = IF(TRIM(@Eliminator_UBP) = '' OR @Eliminator_UBP IS NULL, NULL, REPLACE(REPLACE(TRIM(@Eliminator_UBP), '’', ''), ' ', '')),
  Total_kWH = IF(TRIM(@Total_kWH) = '' OR @Total_kWH IS NULL, NULL, REPLACE(REPLACE(TRIM(@Total_kWH), '’', ''), ' ', '')),
  Total_kWH_fabrication = IF(TRIM(@Total_kWH_fabrication) = '' OR @Total_kWH_fabrication IS NULL, NULL, REPLACE(REPLACE(TRIM(@Total_kWH_fabrication), '’', ''), ' ', '')),
  Energy_fabrication_kWH = IF(TRIM(@Energy_fabrication_kWH) = '' OR @Energy_fabrication_kWH IS NULL, NULL, REPLACE(REPLACE(TRIM(@Energy_fabrication_kWH), '’', ''), ' ', '')),
  Material_fabrication_kWH = IF(TRIM(@Material_fabrication_kWH) = '' OR @Material_fabrication_kWH IS NULL, NULL, REPLACE(REPLACE(TRIM(@Material_fabrication_kWH), '’', ''), ' ', '')),
  Elimination_kWH = IF(TRIM(@Elimination_kWH) = '' OR @Elimination_kWH IS NULL, NULL, REPLACE(REPLACE(TRIM(@Elimination_kWH), '’', ''), ' ', '')),
  Total_co2_emission = IF(TRIM(@Total_co2_emission) = '' OR @Total_co2_emission IS NULL, NULL, REPLACE(REPLACE(TRIM(@Total_co2_emission), '’', ''), ' ', '')),
  Co2_fabrication = IF(TRIM(@Co2_fabrication) = '' OR @Co2_fabrication IS NULL, NULL, REPLACE(REPLACE(TRIM(@Co2_fabrication), '’', ''), ' ', '')),
  Co2_elimination_kg = IF(TRIM(@Co2_elimination_kg) = '' OR @Co2_elimination_kg IS NULL, NULL, REPLACE(REPLACE(TRIM(@Co2_elimination_kg), '’', ''), ' ', '')),
  Biogener_in_product_kg = IF(TRIM(@Biogener_in_product_kg) = '' OR @Biogener_in_product_kg IS NULL, NULL, REPLACE(REPLACE(TRIM(@Biogener_in_product_kg), '’', ''), ' ', ''));

DELETE FROM sustainability_table
WHERE ID IS NULL OR UU_ID IS NULL OR material_name IS NULL OR No_ID IS NULL OR Entsorgung IS NULL OR Ref_unit IS NULL OR Volume_Mass IS NULL OR UBP_Total IS NULL OR 
Fabrication_UBP IS NULL OR Eliminator_UBP IS NULL OR Total_kWH IS NULL OR Total_kWH_fabrication IS NULL OR Energy_fabrication_kWH IS NULL OR 
Material_fabrication_kWH IS NULL OR Elimination_kWH IS NULL OR Total_co2_emission IS NULL OR Co2_fabrication IS NULL OR Co2_elimination_kg IS NULL OR Biogener_in_product_kg  ;


SELECT * FROM sustainability_table
ORDER BY material_name ASC;

LOAD DATA LOCAL INFILE 'C:/Users/irmak/Desktop/SQL_prep_IFC_project/Prix_des_materieux_suisse2.csv'
INTO TABLE staging_table  
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 5 ROWS
(@product_code, @material_name, @dec_2002, @jan_2003, @feb_2003, @mar_2003, @apr_2003, @may_2003, @jun_2003, @jul_2003, @aug_2003, @sep_2003, @oct_2003, @nov_2003, @dec_2003, @jan_2004, @feb_2004, @mar_2004, @apr_2004, @may_2004, @jun_2004, @jul_2004, @aug_2004, @sep_2004, @oct_2004, @nov_2004, @dec_2004, @jan_2005, @feb_2005, @mar_2005, @apr_2005, @may_2005, @jun_2005, @jul_2005, @aug_2005, @sep_2005, @oct_2005, @nov_2005, @dec_2005, @jan_2006, @feb_2006, @mar_2006, @apr_2006, @may_2006, @jun_2006, @jul_2006, @aug_2006, @sep_2006, @oct_2006, @nov_2006, @dec_2006, @jan_2007, @feb_2007, @mar_2007, @apr_2007, @may_2007, @jun_2007, @jul_2007, @aug_2007, @sep_2007, @oct_2007, @nov_2007, @dec_2007, @jan_2008, @feb_2008, @mar_2008, @apr_2008, @may_2008, @jun_2008, @jul_2008, @aug_2008, @sep_2008, @oct_2008, @nov_2008, @dec_2008, @jan_2009, @feb_2009, @mar_2009, @apr_2009, @may_2009, @jun_2009, @jul_2009, @aug_2009, @sep_2009, @oct_2009, @nov_2009, @dec_2009, @jan_2010, @feb_2010, @mar_2010, @apr_2010, @may_2010, @jun_2010, @jul_2010, @aug_2010, @sep_2010, @oct_2010, @nov_2010, @dec_2010, @jan_2011, @feb_2011, @mar_2011, @apr_2011, @may_2011, @jun_2011, @jul_2011, @aug_2011, @sep_2011, @oct_2011, @nov_2011, @dec_2011, @jan_2012, @feb_2012, @mar_2012, @apr_2012, @may_2012, @jun_2012, @jul_2012, @aug_2012, @sep_2012, @oct_2012, @nov_2012, @dec_2012, @jan_2013, @feb_2013, @mar_2013, @apr_2013, @may_2013, @jun_2013, @jul_2013, @aug_2013, @sep_2013, @oct_2013, @nov_2013, @dec_2013, @jan_2014, @feb_2014, @mar_2014, @apr_2014, @may_2014, @jun_2014, @jul_2014, @aug_2014, @sep_2014, @oct_2014, @nov_2014, @dec_2014, @jan_2015, @feb_2015, @mar_2015, @apr_2015, @may_2015, @jun_2015, @jul_2015, @aug_2015, @sep_2015, @oct_2015, @nov_2015, @dec_2015, @jan_2016, @feb_2016, @mar_2016, @apr_2016, @may_2016, @jun_2016, @jul_2016, @aug_2016, @sep_2016, @oct_2016, @nov_2016, @dec_2016, @jan_2017, @feb_2017, @mar_2017, @apr_2017, @may_2017, @jun_2017, @jul_2017, @aug_2017, @sep_2017, @oct_2017, @nov_2017, @dec_2017, @jan_2018, @feb_2018, @mar_2018, @apr_2018, @may_2018, @jun_2018, @jul_2018, @aug_2018, @sep_2018, @oct_2018, @nov_2018, @dec_2018, @jan_2019, @feb_2019, @mar_2019, @apr_2019, @may_2019, @jun_2019, @jul_2019, @aug_2019, @sep_2019, @oct_2019, @nov_2019, @dec_2019, @jan_2020, @feb_2020, @mar_2020, @apr_2020, @may_2020, @jun_2020, @jul_2020, @aug_2020, @sep_2020, @oct_2020, @nov_2020, @dec_2020, @jan_2021, @feb_2021, @mar_2021, @apr_2021, @may_2021, @jun_2021, @jul_2021, @aug_2021, @sep_2021, @oct_2021, @nov_2021, @dec_2021, @jan_2022, @feb_2022, @mar_2022, @apr_2022, @may_2022, @jun_2022, @jul_2022, @aug_2022, @sep_2022, @oct_2022, @nov_2022, @dec_2022, @jan_2023, @feb_2023, @mar_2023, @apr_2023, @may_2023, @jun_2023, @jul_2023, @aug_2023, @sep_2023, @oct_2023, @nov_2023, @dec_2023, @jan_2024, @feb_2024, @mar_2024, @apr_2024, @may_2024, @jun_2024, @jul_2024, @aug_2024, @sep_2024, @oct_2024, @nov_2024, @dec_2024, @jan_2025, @feb_2025, @mar_2025)
SET
  material_name = NULLIF(TRIM(NULLIF(@material_name, '...')), ''),
  dec_2002 = NULLIF(TRIM(NULLIF(@dec_2002, '...')), ''),
  jan_2003 = NULLIF(TRIM(NULLIF(@jan_2003, '...')), ''),
  feb_2003 = NULLIF(TRIM(NULLIF(@feb_2003, '...')), ''),
  mar_2003 = NULLIF(TRIM(NULLIF(@mar_2003, '...')), ''),
  apr_2003 = NULLIF(TRIM(NULLIF(@apr_2003, '...')), ''),
  may_2003 = NULLIF(TRIM(NULLIF(@may_2003, '...')), ''),
  jun_2003 = NULLIF(TRIM(NULLIF(@jun_2003, '...')), ''),
  jul_2003 = NULLIF(TRIM(NULLIF(@jul_2003, '...')), ''),
  aug_2003 = NULLIF(TRIM(NULLIF(@aug_2003, '...')), ''),
  sep_2003 = NULLIF(TRIM(NULLIF(@sep_2003, '...')), ''),
  oct_2003 = NULLIF(TRIM(NULLIF(@oct_2003, '...')), ''),
  nov_2003 = NULLIF(TRIM(NULLIF(@nov_2003, '...')), ''),
  dec_2003 = NULLIF(TRIM(NULLIF(@dec_2003, '...')), ''),
  jan_2004 = NULLIF(TRIM(NULLIF(@jan_2004, '...')), ''),
  feb_2004 = NULLIF(TRIM(NULLIF(@feb_2004, '...')), ''),
  mar_2004 = NULLIF(TRIM(NULLIF(@mar_2004, '...')), ''),
  apr_2004 = NULLIF(TRIM(NULLIF(@apr_2004, '...')), ''),
  may_2004 = NULLIF(TRIM(NULLIF(@may_2004, '...')), ''),
  jun_2004 = NULLIF(TRIM(NULLIF(@jun_2004, '...')), ''),
  jul_2004 = NULLIF(TRIM(NULLIF(@jul_2004, '...')), ''),
  aug_2004 = NULLIF(TRIM(NULLIF(@aug_2004, '...')), ''),
  sep_2004 = NULLIF(TRIM(NULLIF(@sep_2004, '...')), ''),
  oct_2004 = NULLIF(TRIM(NULLIF(@oct_2004, '...')), ''),
  nov_2004 = NULLIF(TRIM(NULLIF(@nov_2004, '...')), ''),
  dec_2004 = NULLIF(TRIM(NULLIF(@dec_2004, '...')), ''),
  jan_2005 = NULLIF(TRIM(NULLIF(@jan_2005, '...')), ''),
  feb_2005 = NULLIF(TRIM(NULLIF(@feb_2005, '...')), ''),
  mar_2005 = NULLIF(TRIM(NULLIF(@mar_2005, '...')), ''),
  apr_2005 = NULLIF(TRIM(NULLIF(@apr_2005, '...')), ''),
  may_2005 = NULLIF(TRIM(NULLIF(@may_2005, '...')), ''),
  jun_2005 = NULLIF(TRIM(NULLIF(@jun_2005, '...')), ''),
  jul_2005 = NULLIF(TRIM(NULLIF(@jul_2005, '...')), ''),
  aug_2005 = NULLIF(TRIM(NULLIF(@aug_2005, '...')), ''),
  sep_2005 = NULLIF(TRIM(NULLIF(@sep_2005, '...')), ''),
  oct_2005 = NULLIF(TRIM(NULLIF(@oct_2005, '...')), ''),
  nov_2005 = NULLIF(TRIM(NULLIF(@nov_2005, '...')), ''),
  dec_2005 = NULLIF(TRIM(NULLIF(@dec_2005, '...')), ''),
  jan_2006 = NULLIF(TRIM(NULLIF(@jan_2006, '...')), ''),
  feb_2006 = NULLIF(TRIM(NULLIF(@feb_2006, '...')), ''),
  mar_2006 = NULLIF(TRIM(NULLIF(@mar_2006, '...')), ''),
  apr_2006 = NULLIF(TRIM(NULLIF(@apr_2006, '...')), ''),
  may_2006 = NULLIF(TRIM(NULLIF(@may_2006, '...')), ''),
  jun_2006 = NULLIF(TRIM(NULLIF(@jun_2006, '...')), ''),
  jul_2006 = NULLIF(TRIM(NULLIF(@jul_2006, '...')), ''),
  aug_2006 = NULLIF(TRIM(NULLIF(@aug_2006, '...')), ''),
  sep_2006 = NULLIF(TRIM(NULLIF(@sep_2006, '...')), ''),
  oct_2006 = NULLIF(TRIM(NULLIF(@oct_2006, '...')), ''),
  nov_2006 = NULLIF(TRIM(NULLIF(@nov_2006, '...')), ''),
  dec_2006 = NULLIF(TRIM(NULLIF(@dec_2006, '...')), ''),
  jan_2007 = NULLIF(TRIM(NULLIF(@jan_2007, '...')), ''),
  feb_2007 = NULLIF(TRIM(NULLIF(@feb_2007, '...')), ''),
  mar_2007 = NULLIF(TRIM(NULLIF(@mar_2007, '...')), ''),
  apr_2007 = NULLIF(TRIM(NULLIF(@apr_2007, '...')), ''),
  may_2007 = NULLIF(TRIM(NULLIF(@may_2007, '...')), ''),
  jun_2007 = NULLIF(TRIM(NULLIF(@jun_2007, '...')), ''),
  jul_2007 = NULLIF(TRIM(NULLIF(@jul_2007, '...')), ''),
  aug_2007 = NULLIF(TRIM(NULLIF(@aug_2007, '...')), ''),
  sep_2007 = NULLIF(TRIM(NULLIF(@sep_2007, '...')), ''),
  oct_2007 = NULLIF(TRIM(NULLIF(@oct_2007, '...')), ''),
  nov_2007 = NULLIF(TRIM(NULLIF(@nov_2007, '...')), ''),
  dec_2007 = NULLIF(TRIM(NULLIF(@dec_2007, '...')), ''),
  jan_2008 = NULLIF(TRIM(NULLIF(@jan_2008, '...')), ''),
  feb_2008 = NULLIF(TRIM(NULLIF(@feb_2008, '...')), ''),
  mar_2008 = NULLIF(TRIM(NULLIF(@mar_2008, '...')), ''),
  apr_2008 = NULLIF(TRIM(NULLIF(@apr_2008, '...')), ''),
  may_2008 = NULLIF(TRIM(NULLIF(@may_2008, '...')), ''),
  jun_2008 = NULLIF(TRIM(NULLIF(@jun_2008, '...')), ''),
  jul_2008 = NULLIF(TRIM(NULLIF(@jul_2008, '...')), ''),
  aug_2008 = NULLIF(TRIM(NULLIF(@aug_2008, '...')), ''),
  sep_2008 = NULLIF(TRIM(NULLIF(@sep_2008, '...')), ''),
  oct_2008 = NULLIF(TRIM(NULLIF(@oct_2008, '...')), ''),
  nov_2008 = NULLIF(TRIM(NULLIF(@nov_2008, '...')), ''),
  dec_2008 = NULLIF(TRIM(NULLIF(@dec_2008, '...')), ''),
  jan_2009 = NULLIF(TRIM(NULLIF(@jan_2009, '...')), ''),
  feb_2009 = NULLIF(TRIM(NULLIF(@feb_2009, '...')), ''),
  mar_2009 = NULLIF(TRIM(NULLIF(@mar_2009, '...')), ''),
  apr_2009 = NULLIF(TRIM(NULLIF(@apr_2009, '...')), ''),
  may_2009 = NULLIF(TRIM(NULLIF(@may_2009, '...')), ''),
  jun_2009 = NULLIF(TRIM(NULLIF(@jun_2009, '...')), ''),
  jul_2009 = NULLIF(TRIM(NULLIF(@jul_2009, '...')), ''),
  aug_2009 = NULLIF(TRIM(NULLIF(@aug_2009, '...')), ''),
  sep_2009 = NULLIF(TRIM(NULLIF(@sep_2009, '...')), ''),
  oct_2009 = NULLIF(TRIM(NULLIF(@oct_2009, '...')), ''),
  nov_2009 = NULLIF(TRIM(NULLIF(@nov_2009, '...')), ''),
  dec_2009 = NULLIF(TRIM(NULLIF(@dec_2009, '...')), ''),
  jan_2010 = NULLIF(TRIM(NULLIF(@jan_2010, '...')), ''),
  feb_2010 = NULLIF(TRIM(NULLIF(@feb_2010, '...')), ''),
  mar_2010 = NULLIF(TRIM(NULLIF(@mar_2010, '...')), ''),
  apr_2010 = NULLIF(TRIM(NULLIF(@apr_2010, '...')), ''),
  may_2010 = NULLIF(TRIM(NULLIF(@may_2010, '...')), ''),
  jun_2010 = NULLIF(TRIM(NULLIF(@jun_2010, '...')), ''),
  jul_2010 = NULLIF(TRIM(NULLIF(@jul_2010, '...')), ''),
  aug_2010 = NULLIF(TRIM(NULLIF(@aug_2010, '...')), ''),
  sep_2010 = NULLIF(TRIM(NULLIF(@sep_2010, '...')), ''),
  oct_2010 = NULLIF(TRIM(NULLIF(@oct_2010, '...')), ''),
  nov_2010 = NULLIF(TRIM(NULLIF(@nov_2010, '...')), ''),
  dec_2010 = NULLIF(TRIM(NULLIF(@dec_2010, '...')), ''),
  jan_2011 = NULLIF(TRIM(NULLIF(@jan_2011, '...')), ''),
  feb_2011 = NULLIF(TRIM(NULLIF(@feb_2011, '...')), ''),
  mar_2011 = NULLIF(TRIM(NULLIF(@mar_2011, '...')), ''),
  apr_2011 = NULLIF(TRIM(NULLIF(@apr_2011, '...')), ''),
  may_2011 = NULLIF(TRIM(NULLIF(@may_2011, '...')), ''),
  jun_2011 = NULLIF(TRIM(NULLIF(@jun_2011, '...')), ''),
  jul_2011 = NULLIF(TRIM(NULLIF(@jul_2011, '...')), ''),
  aug_2011 = NULLIF(TRIM(NULLIF(@aug_2011, '...')), ''),
  sep_2011 = NULLIF(TRIM(NULLIF(@sep_2011, '...')), ''),
  oct_2011 = NULLIF(TRIM(NULLIF(@oct_2011, '...')), ''),
  nov_2011 = NULLIF(TRIM(NULLIF(@nov_2011, '...')), ''),
  dec_2011 = NULLIF(TRIM(NULLIF(@dec_2011, '...')), ''),
  jan_2012 = NULLIF(TRIM(NULLIF(@jan_2012, '...')), ''),
  feb_2012 = NULLIF(TRIM(NULLIF(@feb_2012, '...')), ''),
  mar_2012 = NULLIF(TRIM(NULLIF(@mar_2012, '...')), ''),
  apr_2012 = NULLIF(TRIM(NULLIF(@apr_2012, '...')), ''),
  may_2012 = NULLIF(TRIM(NULLIF(@may_2012, '...')), ''),
  jun_2012 = NULLIF(TRIM(NULLIF(@jun_2012, '...')), ''),
  jul_2012 = NULLIF(TRIM(NULLIF(@jul_2012, '...')), ''),
  aug_2012 = NULLIF(TRIM(NULLIF(@aug_2012, '...')), ''),
  sep_2012 = NULLIF(TRIM(NULLIF(@sep_2012, '...')), ''),
  oct_2012 = NULLIF(TRIM(NULLIF(@oct_2012, '...')), ''),
  nov_2012 = NULLIF(TRIM(NULLIF(@nov_2012, '...')), ''),
  dec_2012 = NULLIF(TRIM(NULLIF(@dec_2012, '...')), ''),
  jan_2013 = NULLIF(TRIM(NULLIF(@jan_2013, '...')), ''),
  feb_2013 = NULLIF(TRIM(NULLIF(@feb_2013, '...')), ''),
  mar_2013 = NULLIF(TRIM(NULLIF(@mar_2013, '...')), ''),
  apr_2013 = NULLIF(TRIM(NULLIF(@apr_2013, '...')), ''),
  may_2013 = NULLIF(TRIM(NULLIF(@may_2013, '...')), ''),
  jun_2013 = NULLIF(TRIM(NULLIF(@jun_2013, '...')), ''),
  jul_2013 = NULLIF(TRIM(NULLIF(@jul_2013, '...')), ''),
  aug_2013 = NULLIF(TRIM(NULLIF(@aug_2013, '...')), ''),
  sep_2013 = NULLIF(TRIM(NULLIF(@sep_2013, '...')), ''),
  oct_2013 = NULLIF(TRIM(NULLIF(@oct_2013, '...')), ''),
  nov_2013 = NULLIF(TRIM(NULLIF(@nov_2013, '...')), ''),
  dec_2013 = NULLIF(TRIM(NULLIF(@dec_2013, '...')), ''),
  jan_2014 = NULLIF(TRIM(NULLIF(@jan_2014, '...')), ''),
  feb_2014 = NULLIF(TRIM(NULLIF(@feb_2014, '...')), ''),
  mar_2014 = NULLIF(TRIM(NULLIF(@mar_2014, '...')), ''),
  apr_2014 = NULLIF(TRIM(NULLIF(@apr_2014, '...')), ''),
  may_2014 = NULLIF(TRIM(NULLIF(@may_2014, '...')), ''),
  jun_2014 = NULLIF(TRIM(NULLIF(@jun_2014, '...')), ''),
  jul_2014 = NULLIF(TRIM(NULLIF(@jul_2014, '...')), ''),
  aug_2014 = NULLIF(TRIM(NULLIF(@aug_2014, '...')), ''),
  sep_2014 = NULLIF(TRIM(NULLIF(@sep_2014, '...')), ''),
  oct_2014 = NULLIF(TRIM(NULLIF(@oct_2014, '...')), ''),
  nov_2014 = NULLIF(TRIM(NULLIF(@nov_2014, '...')), ''),
  dec_2014 = NULLIF(TRIM(NULLIF(@dec_2014, '...')), ''),
  jan_2015 = NULLIF(TRIM(NULLIF(@jan_2015, '...')), ''),
  feb_2015 = NULLIF(TRIM(NULLIF(@feb_2015, '...')), ''),
  mar_2015 = NULLIF(TRIM(NULLIF(@mar_2015, '...')), ''),
  apr_2015 = NULLIF(TRIM(NULLIF(@apr_2015, '...')), ''),
  may_2015 = NULLIF(TRIM(NULLIF(@may_2015, '...')), ''),
  jun_2015 = NULLIF(TRIM(NULLIF(@jun_2015, '...')), ''),
  jul_2015 = NULLIF(TRIM(NULLIF(@jul_2015, '...')), ''),
  aug_2015 = NULLIF(TRIM(NULLIF(@aug_2015, '...')), ''),
  sep_2015 = NULLIF(TRIM(NULLIF(@sep_2015, '...')), ''),
  oct_2015 = NULLIF(TRIM(NULLIF(@oct_2015, '...')), ''),
  nov_2015 = NULLIF(TRIM(NULLIF(@nov_2015, '...')), ''),
  dec_2015 = NULLIF(TRIM(NULLIF(@dec_2015, '...')), ''),
  jan_2016 = NULLIF(TRIM(NULLIF(@jan_2016, '...')), ''),
  feb_2016 = NULLIF(TRIM(NULLIF(@feb_2016, '...')), ''),
  mar_2016 = NULLIF(TRIM(NULLIF(@mar_2016, '...')), ''),
  apr_2016 = NULLIF(TRIM(NULLIF(@apr_2016, '...')), ''),
  may_2016 = NULLIF(TRIM(NULLIF(@may_2016, '...')), ''),
  jun_2016 = NULLIF(TRIM(NULLIF(@jun_2016, '...')), ''),
  jul_2016 = NULLIF(TRIM(NULLIF(@jul_2016, '...')), ''),
  aug_2016 = NULLIF(TRIM(NULLIF(@aug_2016, '...')), ''),
  sep_2016 = NULLIF(TRIM(NULLIF(@sep_2016, '...')), ''),
  oct_2016 = NULLIF(TRIM(NULLIF(@oct_2016, '...')), ''),
  nov_2016 = NULLIF(TRIM(NULLIF(@nov_2016, '...')), ''),
  dec_2016 = NULLIF(TRIM(NULLIF(@dec_2016, '...')), ''),
  jan_2017 = NULLIF(TRIM(NULLIF(@jan_2017, '...')), ''),
  feb_2017 = NULLIF(TRIM(NULLIF(@feb_2017, '...')), ''),
  mar_2017 = NULLIF(TRIM(NULLIF(@mar_2017, '...')), ''),
  apr_2017 = NULLIF(TRIM(NULLIF(@apr_2017, '...')), ''),
  may_2017 = NULLIF(TRIM(NULLIF(@may_2017, '...')), ''),
  jun_2017 = NULLIF(TRIM(NULLIF(@jun_2017, '...')), ''),
  jul_2017 = NULLIF(TRIM(NULLIF(@jul_2017, '...')), ''),
  aug_2017 = NULLIF(TRIM(NULLIF(@aug_2017, '...')), ''),
  sep_2017 = NULLIF(TRIM(NULLIF(@sep_2017, '...')), ''),
  oct_2017 = NULLIF(TRIM(NULLIF(@oct_2017, '...')), ''),
  nov_2017 = NULLIF(TRIM(NULLIF(@nov_2017, '...')), ''),
  dec_2017 = NULLIF(TRIM(NULLIF(@dec_2017, '...')), ''),
  jan_2018 = NULLIF(TRIM(NULLIF(@jan_2018, '...')), ''),
  feb_2018 = NULLIF(TRIM(NULLIF(@feb_2018, '...')), ''),
  mar_2018 = NULLIF(TRIM(NULLIF(@mar_2018, '...')), ''),
  apr_2018 = NULLIF(TRIM(NULLIF(@apr_2018, '...')), ''),
  may_2018 = NULLIF(TRIM(NULLIF(@may_2018, '...')), ''),
  jun_2018 = NULLIF(TRIM(NULLIF(@jun_2018, '...')), ''),
  jul_2018 = NULLIF(TRIM(NULLIF(@jul_2018, '...')), ''),
  aug_2018 = NULLIF(TRIM(NULLIF(@aug_2018, '...')), ''),
  sep_2018 = NULLIF(TRIM(NULLIF(@sep_2018, '...')), ''),
  oct_2018 = NULLIF(TRIM(NULLIF(@oct_2018, '...')), ''),
  nov_2018 = NULLIF(TRIM(NULLIF(@nov_2018, '...')), ''),
  dec_2018 = NULLIF(TRIM(NULLIF(@dec_2018, '...')), ''),
  jan_2019 = NULLIF(TRIM(NULLIF(@jan_2019, '...')), ''),
  feb_2019 = NULLIF(TRIM(NULLIF(@feb_2019, '...')), ''),
  mar_2019 = NULLIF(TRIM(NULLIF(@mar_2019, '...')), ''),
  apr_2019 = NULLIF(TRIM(NULLIF(@apr_2019, '...')), ''),
  may_2019 = NULLIF(TRIM(NULLIF(@may_2019, '...')), ''),
  jun_2019 = NULLIF(TRIM(NULLIF(@jun_2019, '...')), ''),
  jul_2019 = NULLIF(TRIM(NULLIF(@jul_2019, '...')), ''),
  aug_2019 = NULLIF(TRIM(NULLIF(@aug_2019, '...')), ''),
  sep_2019 = NULLIF(TRIM(NULLIF(@sep_2019, '...')), ''),
  oct_2019 = NULLIF(TRIM(NULLIF(@oct_2019, '...')), ''),
  nov_2019 = NULLIF(TRIM(NULLIF(@nov_2019, '...')), ''),
  dec_2019 = NULLIF(TRIM(NULLIF(@dec_2019, '...')), ''),
  jan_2020 = NULLIF(TRIM(NULLIF(@jan_2020, '...')), ''),
  feb_2020 = NULLIF(TRIM(NULLIF(@feb_2020, '...')), ''),
  mar_2020 = NULLIF(TRIM(NULLIF(@mar_2020, '...')), ''),
  apr_2020 = NULLIF(TRIM(NULLIF(@apr_2020, '...')), ''),
  may_2020 = NULLIF(TRIM(NULLIF(@may_2020, '...')), ''),
  jun_2020 = NULLIF(TRIM(NULLIF(@jun_2020, '...')), ''),
  jul_2020 = NULLIF(TRIM(NULLIF(@jul_2020, '...')), ''),
  aug_2020 = NULLIF(TRIM(NULLIF(@aug_2020, '...')), ''),
  sep_2020 = NULLIF(TRIM(NULLIF(@sep_2020, '...')), ''),
  oct_2020 = NULLIF(TRIM(NULLIF(@oct_2020, '...')), ''),
  nov_2020 = NULLIF(TRIM(NULLIF(@nov_2020, '...')), ''),
  dec_2020 = NULLIF(TRIM(NULLIF(@dec_2020, '...')), ''),
  jan_2021 = NULLIF(TRIM(NULLIF(@jan_2021, '...')), ''),
  feb_2021 = NULLIF(TRIM(NULLIF(@feb_2021, '...')), ''),
  mar_2021 = NULLIF(TRIM(NULLIF(@mar_2021, '...')), ''),
  apr_2021 = NULLIF(TRIM(NULLIF(@apr_2021, '...')), ''),
  may_2021 = NULLIF(TRIM(NULLIF(@may_2021, '...')), ''),
  jun_2021 = NULLIF(TRIM(NULLIF(@jun_2021, '...')), ''),
  jul_2021 = NULLIF(TRIM(NULLIF(@jul_2021, '...')), ''),
  aug_2021 = NULLIF(TRIM(NULLIF(@aug_2021, '...')), ''),
  sep_2021 = NULLIF(TRIM(NULLIF(@sep_2021, '...')), ''),
  oct_2021 = NULLIF(TRIM(NULLIF(@oct_2021, '...')), ''),
  nov_2021 = NULLIF(TRIM(NULLIF(@nov_2021, '...')), ''),
  dec_2021 = NULLIF(TRIM(NULLIF(@dec_2021, '...')), ''),
  jan_2022 = NULLIF(TRIM(NULLIF(@jan_2022, '...')), ''),
  feb_2022 = NULLIF(TRIM(NULLIF(@feb_2022, '...')), ''),
  mar_2022 = NULLIF(TRIM(NULLIF(@mar_2022, '...')), ''),
  apr_2022 = NULLIF(TRIM(NULLIF(@apr_2022, '...')), ''),
  may_2022 = NULLIF(TRIM(NULLIF(@may_2022, '...')), ''),
  jun_2022 = NULLIF(TRIM(NULLIF(@jun_2022, '...')), ''),
  jul_2022 = NULLIF(TRIM(NULLIF(@jul_2022, '...')), ''),
  aug_2022 = NULLIF(TRIM(NULLIF(@aug_2022, '...')), ''),
  sep_2022 = NULLIF(TRIM(NULLIF(@sep_2022, '...')), ''),
  oct_2022 = NULLIF(TRIM(NULLIF(@oct_2022, '...')), ''),
  nov_2022 = NULLIF(TRIM(NULLIF(@nov_2022, '...')), ''),
  dec_2022 = NULLIF(TRIM(NULLIF(@dec_2022, '...')), ''),
  jan_2023 = NULLIF(TRIM(NULLIF(@jan_2023, '...')), ''),
  feb_2023 = NULLIF(TRIM(NULLIF(@feb_2023, '...')), ''),
  mar_2023 = NULLIF(TRIM(NULLIF(@mar_2023, '...')), ''),
  apr_2023 = NULLIF(TRIM(NULLIF(@apr_2023, '...')), ''),
  may_2023 = NULLIF(TRIM(NULLIF(@may_2023, '...')), ''),
  jun_2023 = NULLIF(TRIM(NULLIF(@jun_2023, '...')), ''),
  jul_2023 = NULLIF(TRIM(NULLIF(@jul_2023, '...')), ''),
  aug_2023 = NULLIF(TRIM(NULLIF(@aug_2023, '...')), ''),
  sep_2023 = NULLIF(TRIM(NULLIF(@sep_2023, '...')), ''),
  oct_2023 = NULLIF(TRIM(NULLIF(@oct_2023, '...')), ''),
  nov_2023 = NULLIF(TRIM(NULLIF(@nov_2023, '...')), ''),
  dec_2023 = NULLIF(TRIM(NULLIF(@dec_2023, '...')), ''),
  jan_2024 = NULLIF(TRIM(NULLIF(@jan_2024, '...')), ''),
  feb_2024 = NULLIF(TRIM(NULLIF(@feb_2024, '...')), ''),
  mar_2024 = NULLIF(TRIM(NULLIF(@mar_2024, '...')), ''),
  apr_2024 = NULLIF(TRIM(NULLIF(@apr_2024, '...')), ''),
  may_2024 = NULLIF(TRIM(NULLIF(@may_2024, '...')), ''),
  jun_2024 = NULLIF(TRIM(NULLIF(@jun_2024, '...')), ''),
  jul_2024 = NULLIF(TRIM(NULLIF(@jul_2024, '...')), ''),
  aug_2024 = NULLIF(TRIM(NULLIF(@aug_2024, '...')), ''),
  sep_2024 = NULLIF(TRIM(NULLIF(@sep_2024, '...')), ''),
  oct_2024 = NULLIF(TRIM(NULLIF(@oct_2024, '...')), ''),
  nov_2024 = NULLIF(TRIM(NULLIF(@nov_2024, '...')), ''),
  dec_2024 = NULLIF(TRIM(NULLIF(@dec_2024, '...')), ''),
  jan_2025 = NULLIF(TRIM(NULLIF(@jan_2025, '...')), ''),
  feb_2025 = NULLIF(TRIM(NULLIF(@feb_2025, '...')), ''),
  mar_2025 = NULLIF(TRIM(NULLIF(@mar_2025, '...')), '');
  
  
  SET SQL_SAFE_UPDATES = 0;

DELETE FROM staging_table
WHERE
    product_code IS NULL OR
    material_name IS NULL OR
    dec_2002 IS NULL OR
    jan_2003 IS NULL OR
    feb_2003 IS NULL OR
    mar_2003 IS NULL OR
    apr_2003 IS NULL OR
    may_2003 IS NULL OR
    jun_2003 IS NULL OR
    jul_2003 IS NULL OR
    aug_2003 IS NULL OR
    sep_2003 IS NULL OR
    oct_2003 IS NULL OR
    nov_2003 IS NULL OR
    dec_2003 IS NULL OR
    jan_2004 IS NULL OR
    feb_2004 IS NULL OR
    mar_2004 IS NULL OR
    apr_2004 IS NULL OR
    may_2004 IS NULL OR
    jun_2004 IS NULL OR
    jul_2004 IS NULL OR
    aug_2004 IS NULL OR
    sep_2004 IS NULL OR
    oct_2004 IS NULL OR
    nov_2004 IS NULL OR
    dec_2004 IS NULL OR
    jan_2005 IS NULL OR
    feb_2005 IS NULL OR
    mar_2005 IS NULL OR
    apr_2005 IS NULL OR
    may_2005 IS NULL OR
    jun_2005 IS NULL OR
    jul_2005 IS NULL OR
    aug_2005 IS NULL OR
    sep_2005 IS NULL OR
    oct_2005 IS NULL OR
    nov_2005 IS NULL OR
    dec_2005 IS NULL OR
    jan_2006 IS NULL OR
    feb_2006 IS NULL OR
    mar_2006 IS NULL OR
    apr_2006 IS NULL OR
    may_2006 IS NULL OR
    jun_2006 IS NULL OR
    jul_2006 IS NULL OR
    aug_2006 IS NULL OR
    sep_2006 IS NULL OR
    oct_2006 IS NULL OR
    nov_2006 IS NULL OR
    dec_2006 IS NULL OR
    jan_2007 IS NULL OR
    feb_2007 IS NULL OR
    mar_2007 IS NULL OR
    apr_2007 IS NULL OR
    may_2007 IS NULL OR
    jun_2007 IS NULL OR
    jul_2007 IS NULL OR
    aug_2007 IS NULL OR
    sep_2007 IS NULL OR
    oct_2007 IS NULL OR
    nov_2007 IS NULL OR
    dec_2007 IS NULL OR
    jan_2008 IS NULL OR
    feb_2008 IS NULL OR
    mar_2008 IS NULL OR
    apr_2008 IS NULL OR
    may_2008 IS NULL OR
    jun_2008 IS NULL OR
    jul_2008 IS NULL OR
    aug_2008 IS NULL OR
    sep_2008 IS NULL OR
    oct_2008 IS NULL OR
    nov_2008 IS NULL OR
    dec_2008 IS NULL OR
    jan_2009 IS NULL OR
    feb_2009 IS NULL OR
    mar_2009 IS NULL OR
    apr_2009 IS NULL OR
    may_2009 IS NULL OR
    jun_2009 IS NULL OR
    jul_2009 IS NULL OR
    aug_2009 IS NULL OR
    sep_2009 IS NULL OR
    oct_2009 IS NULL OR
    nov_2009 IS NULL OR
    dec_2009 IS NULL OR
    jan_2010 IS NULL OR
    feb_2010 IS NULL OR
    mar_2010 IS NULL OR
    apr_2010 IS NULL OR
    may_2010 IS NULL OR
    jun_2010 IS NULL OR
    jul_2010 IS NULL OR
    aug_2010 IS NULL OR
    sep_2010 IS NULL OR
    oct_2010 IS NULL OR
    nov_2010 IS NULL OR
    dec_2010 IS NULL OR
    jan_2011 IS NULL OR
    feb_2011 IS NULL OR
    mar_2011 IS NULL OR
    apr_2011 IS NULL OR
    may_2011 IS NULL OR
    jun_2011 IS NULL OR
    jul_2011 IS NULL OR
    aug_2011 IS NULL OR
    sep_2011 IS NULL OR
    oct_2011 IS NULL OR
    nov_2011 IS NULL OR
    dec_2011 IS NULL OR
    jan_2012 IS NULL OR
    feb_2012 IS NULL OR
    mar_2012 IS NULL OR
    apr_2012 IS NULL OR
    may_2012 IS NULL OR
    jun_2012 IS NULL OR
    jul_2012 IS NULL OR
    aug_2012 IS NULL OR
    sep_2012 IS NULL OR
    oct_2012 IS NULL OR
    nov_2012 IS NULL OR
    dec_2012 IS NULL OR
    jan_2013 IS NULL OR
    feb_2013 IS NULL OR
    mar_2013 IS NULL OR
    apr_2013 IS NULL OR
    may_2013 IS NULL OR
    jun_2013 IS NULL OR
    jul_2013 IS NULL OR
    aug_2013 IS NULL OR
    sep_2013 IS NULL OR
    oct_2013 IS NULL OR
    nov_2013 IS NULL OR
    dec_2013 IS NULL OR
    jan_2014 IS NULL OR
    feb_2014 IS NULL OR
    mar_2014 IS NULL OR
    apr_2014 IS NULL OR
    may_2014 IS NULL OR
    jun_2014 IS NULL OR
    jul_2014 IS NULL OR
    aug_2014 IS NULL OR
    sep_2014 IS NULL OR
    oct_2014 IS NULL OR
    nov_2014 IS NULL OR
    dec_2014 IS NULL OR
    jan_2015 IS NULL OR
    feb_2015 IS NULL OR
    mar_2015 IS NULL OR
    apr_2015 IS NULL OR
    may_2015 IS NULL OR
    jun_2015 IS NULL OR
    jul_2015 IS NULL OR
    aug_2015 IS NULL OR
    sep_2015 IS NULL OR
    oct_2015 IS NULL OR
    nov_2015 IS NULL OR
    dec_2015 IS NULL OR
    jan_2016 IS NULL OR
    feb_2016 IS NULL OR
    mar_2016 IS NULL OR
    apr_2016 IS NULL OR
    may_2016 IS NULL OR
    jun_2016 IS NULL OR
    jul_2016 IS NULL OR
    aug_2016 IS NULL OR
    sep_2016 IS NULL OR
    oct_2016 IS NULL OR
    nov_2016 IS NULL OR
    dec_2016 IS NULL OR
    jan_2017 IS NULL OR
    feb_2017 IS NULL OR
    mar_2017 IS NULL OR
    apr_2017 IS NULL OR
    may_2017 IS NULL OR
    jun_2017 IS NULL OR
    jul_2017 IS NULL OR
    aug_2017 IS NULL OR
    sep_2017 IS NULL OR
    oct_2017 IS NULL OR
    nov_2017 IS NULL OR
    dec_2017 IS NULL OR
    jan_2018 IS NULL OR
    feb_2018 IS NULL OR
    mar_2018 IS NULL OR
    apr_2018 IS NULL OR
    may_2018 IS NULL OR
    jun_2018 IS NULL OR
    jul_2018 IS NULL OR
    aug_2018 IS NULL OR
    sep_2018 IS NULL OR
    oct_2018 IS NULL OR
    nov_2018 IS NULL OR
    dec_2018 IS NULL OR
    jan_2019 IS NULL OR
    feb_2019 IS NULL OR
    mar_2019 IS NULL OR
    apr_2019 IS NULL OR
    may_2019 IS NULL OR
    jun_2019 IS NULL OR
    jul_2019 IS NULL OR
    aug_2019 IS NULL OR
    sep_2019 IS NULL OR
    oct_2019 IS NULL OR
    nov_2019 IS NULL OR
    dec_2019 IS NULL OR
    jan_2020 IS NULL OR
    feb_2020 IS NULL OR
    mar_2020 IS NULL OR
    apr_2020 IS NULL OR
    may_2020 IS NULL OR
    jun_2020 IS NULL OR
    jul_2020 IS NULL OR
    aug_2020 IS NULL OR
    sep_2020 IS NULL OR
    oct_2020 IS NULL OR
    nov_2020 IS NULL OR
    dec_2020 IS NULL OR
    jan_2021 IS NULL OR
    feb_2021 IS NULL OR
    mar_2021 IS NULL OR
    apr_2021 IS NULL OR
    may_2021 IS NULL OR
    jun_2021 IS NULL OR
    jul_2021 IS NULL OR
    aug_2021 IS NULL OR
    sep_2021 IS NULL OR
    oct_2021 IS NULL OR
    nov_2021 IS NULL OR
    dec_2021 IS NULL OR
    jan_2022 IS NULL OR
    feb_2022 IS NULL OR
    mar_2022 IS NULL OR
    apr_2022 IS NULL OR
    may_2022 IS NULL OR
    jun_2022 IS NULL OR
    jul_2022 IS NULL OR
    aug_2022 IS NULL OR
    sep_2022 IS NULL OR
    oct_2022 IS NULL OR
    nov_2022 IS NULL OR
    dec_2022 IS NULL OR
    jan_2023 IS NULL OR
    feb_2023 IS NULL OR
    mar_2023 IS NULL OR
    apr_2023 IS NULL OR
    may_2023 IS NULL OR
    jun_2023 IS NULL OR
    jul_2023 IS NULL OR
    aug_2023 IS NULL OR
    sep_2023 IS NULL OR
    oct_2023 IS NULL OR
    nov_2023 IS NULL OR
    dec_2023 IS NULL OR
    jan_2024 IS NULL OR
    feb_2024 IS NULL OR
    mar_2024 IS NULL OR
    apr_2024 IS NULL OR
    may_2024 IS NULL OR
    jun_2024 IS NULL OR
    jul_2024 IS NULL OR
    aug_2024 IS NULL OR
    sep_2024 IS NULL OR
    oct_2024 IS NULL OR
    nov_2024 IS NULL OR
    dec_2024 IS NULL OR
    jan_2025 IS NULL OR
    feb_2025 IS NULL OR
    mar_2025 IS NULL;
    
    
  

-- Insert data into the table for each category (Wall, Window, and Door)
-- Wall category matches
INSERT INTO category_matches (category, data1_product, data2_product) VALUES
('Wall', 'Produits en béton, ciment et plâtre', 'Brique en terre cuite'),
('Wall', 'Béton pour bâtiments', 'Brique en terre cuite remplie de perlite'),
('Wall', 'Béton pour travaux de génie civil', 'Grès'),
('Wall', 'Blocs de gypse / plâtre massif', 'Grès FBB'),
('Wall', 'Plaque de plâtre armé de fibres', 'Grès Hunziker Kalksandstein AG'),
('Wall', 'Plaque de plâtre armé de fibres Fermacell', 'Brique en argile légère'),
('Wall', 'Plaque de plâtre cartonnée', 'Pierre en béton léger: argile expansée'),
('Wall', 'Revêtements de sols', 'Pierre en béton léger: pierre ponce naturelle'),
('Wall', 'Produits en béton, ciment et plâtre', 'Béton cellulaire'),
('Wall', 'Produits en béton, ciment et plâtre', 'Plot de ciment'),
('Wall', 'Produits en béton, ciment et plâtre', 'Bloc de terre compressé terrabloc'),
('Wall', 'Produits en béton, ciment et plâtre', 'Tuiles en béton'),
('Wall', 'Produits en béton, ciment et plâtre', 'Plaque de grès dur'),
('Wall', 'Produits en béton, ciment et plâtre', 'Plaque de calcaire dur'),
('Wall', 'Produits en béton, ciment et plâtre', 'Dalle de céramique/grès');

-- Window category matches
INSERT INTO category_matches (category, data1_product, data2_product) VALUES
('Window', 'Fenêtres et portes', 'Cadre de fenêtre en aluminium'),
('Window', 'Fenêtres et portes', 'Cadre de fenêtre en aluminium WICLINE 75evo fabriqué avec Hydro CIRCAL 75R 2'),
('Window', 'Fenêtres et portes', 'Cadre en matière synthétique (PVC) 2'),
('Window', 'Fenêtres et portes', 'Double vitrage U<1.1 W/m2K épaisseur 24 mm 3'),
('Window', 'Fenêtres et portes', 'Double vitrage U<1.1 W/m2K épaisseur 18 mm 3'),
('Window', 'Fenêtres et portes', 'Double vitrage verre ESG U<1.1 W/m2K 3'),
('Window', 'Fenêtres et portes', 'Double vitrage verre VSG U<1.1 W/m2K 3'),
('Window', 'Fenêtres et portes', 'Triple vitrage U<0.5 W/m2K épaisseur 36 mm 3'),
('Window', 'Fenêtres et portes', 'Triple vitrage U<0.6 W/m2K épaisseur 40 mm 3'),
('Window', 'Fenêtres et portes', 'Triple vitrage verre ESG/ESG U<0.6 W/m2K 3'),
('Window', 'Fenêtres et portes', 'Triple vitrage verre ESG/ESG/ESG U<0.6 W/m2K 3'),
('Window', 'Fenêtres et portes', 'Triple vitrage verre VSG U<0.6 W/m2K 3'),
('Window', 'Fenêtres et portes', 'Triple vitrage verre ESG/VSG U<0.6 W/m2K 3');

-- Door category matches
INSERT INTO category_matches (category, data1_product, data2_product) VALUES
('Door', 'Fenêtres et portes', 'Portes extérieures aluminium avec vitrage'),
('Door', 'Fenêtres et portes', 'Portes extérieures aluminium avec panneau'),
('Door', 'Fenêtres et portes', 'Portes intérieures aluminium avec vitrage');

