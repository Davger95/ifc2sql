
CREATE UNIQUE INDEX idy_product_name ON sustainability_table(material_name(255));

DELETE FROM sustainability_table
WHERE material_name IS NULL;

SELECT * FROM category_matches1 WHERE data2_product IS NULL;
ALTER TABLE sustainability_table ADD CONSTRAINT unique_material UNIQUE (material_name(4));

DROP INDEX idx_product_name ON sustainability_table;
DROP INDEX idx_material ON materialprices;




CREATE TABLE material_categories_t AS
SELECT 
    cm.id, 
    cm.category,
    cm.data1_product, 
    cm.data2_product,
    mp.average_price,  
    mp.year,
    st.UBP_Total,  
    st.Total_kWH,  
    st.Total_co2_emission,  
    st.Volume_Mass   
FROM 
    category_matches cm
JOIN 
    current_prices mp ON cm.data1_product = mp.Material  -- Match data1_product with material in MaterialPrices
JOIN 
    sustainability_table st ON cm.data2_product = st.material_name ; -- Match data2_product with material_name in sustainability_table


