SELECT 
    MaterialID,
    Material,
    YEAR(Month_y) AS year,
    AVG(Price) AS average_price
FROM 
    MaterialPrices
WHERE
    YEAR(Month_y) IN (2020, 2021, 2022, 2023, 2024, 2025)
GROUP BY 
    MaterialID, Material, YEAR(Month_y)
ORDER BY 
    MaterialID, year;


SELECT 
    MaterialID,
    Material,
    YEAR(Month_y) AS year,
    AVG(Price) AS average_price
FROM 
    MaterialPrices
WHERE
    YEAR(Month_y) BETWEEN 2000 AND 2025
GROUP BY 
    MaterialID, Material, YEAR(Month_y);



CREATE INDEX idx_date ON MaterialPrices (Month_y);


CREATE TABLE current_prices
SELECT 
    MaterialID,
    Material,
    YEAR(Month_y) AS year,
    AVG(Price) AS average_price
FROM 
    MaterialPrices USE INDEX (idx_date)
WHERE 
    Month_y >= '2020-12-01' AND Month_y < '2025-03-01'
GROUP BY 
    MaterialID, Material, YEAR(Month_y);


