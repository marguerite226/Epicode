-- JOIN Annagrafica prodotti

SELECT 
    p.EnglishProductName,
    s.EnglishProductSubcategoryName
FROM
 DimProduct p
JOIN 
DimProductSubcategory s
    ON p.ProductSubcategoryKey = s.ProductSubcategoryKey;
    
    -- SUGQUERY
    SELECT 
    EnglishProductName,
    
	-- 2 join annagrafica prodotti, categorie e sottocategorie
   (SELECT EnglishProductSubcategoryName
     FROM DimProductSubcategory s
     WHERE s.ProductSubcategoryKey = p.ProductSubcategoryKey) 
     AS Subcategory
FROM DimProduct p;
SELECT
    p.EnglishProductName,
    s.EnglishProductSubcategoryName,
    c.EnglishProductCategoryName
FROM DimProduct p
JOIN DimProductSubcategory s
    ON p.ProductSubcategoryKey = s.ProductSubcategoryKey
JOIN DimProductCategory c
    ON s.ProductCategoryKey = c.ProductCategoryKey;
-- SUBQUERY
SELECT 
    EnglishProductName,
    (SELECT EnglishProductSubcategoryName
     FROM DimProductSubcategory s
     WHERE s.ProductSubcategoryKey = p.ProductSubcategoryKey) AS Subcategory,
     
    (SELECT EnglishProductCategoryName
     FROM DimProductCategory c
     WHERE c.ProductCategoryKey =
           (SELECT ProductCategoryKey
            FROM DimProductSubcategory s
            WHERE s.ProductSubcategoryKey = p.ProductSubcategoryKey)
    ) AS Category
FROM DimProduct p;
-- 3 SOLO PRODOTTI VENDUTI
SELECT DISTINCT
   p.EnglishProductName
FROM DimProduct p
JOIN FactResellerSales f
    ON p.ProductKey = f.ProductKey;
    -- SUBQUERY
    SELECT 
    EnglishProductName
FROM DimProduct
WHERE ProductKey IN
    (SELECT ProductKey
     FROM FactResellerSales);
     -- 4 PRODOTTI NON VENDUTI 
     SELECT 
	 p.EnglishProductName
FROM DimProduct p
LEFT JOIN FactResellerSales f
    ON p.ProductKey = f.ProductKey
WHERE f.ProductKey IS NULL
AND p.FinishedGoodsFlag = 1;

-- SUBQUERY
SELECT 
    ProductKey,
    EnglishProductName
FROM DimProduct
WHERE FinishedGoodsFlag = 1
AND ProductKey NOT IN
    (SELECT ProductKey
     FROM FactResellerSales);
     
     -- 5) ELENCO TRANSAZIONI VENDITA
     SELECT 
    f.SalesOrderNumber,
    f.OrderQuantity,
    f.SalesAmount,
    p.EnglishProductName
FROM FactResellerSales f
JOIN DimProduct p
    ON f.ProductKey = p.ProductKey;
    -- SUBQUERRY
    SELECT 
    SalesOrderNumber,
    OrderQuantity,
    SalesAmount,
    (SELECT EnglishProductName
     FROM DimProduct p
     WHERE p.ProductKey = f.ProductKey) AS ProductName
FROM FactResellerSales f;
-- JOIN ELENCO TRANSAZIONI INDICANDO CATEGORIE DI CIASCUN PRODOTTO
SELECT 
    SalesOrderNumber,
    OrderQuantity,
    SalesAmount,
    (SELECT EnglishProductName
     FROM DimProduct p
     WHERE p.ProductKey = f.ProductKey) AS ProductName
FROM FactResellerSales f;
-- SUBQUERY
SELECT 
    SalesOrderNumber,
    
    (SELECT EnglishProductName
     FROM DimProduct p
     WHERE p.ProductKey = f.ProductKey) AS ProductName,
     
    (SELECT EnglishProductCategoryName
     FROM DimProductCategory c
     WHERE c.ProductCategoryKey =
         (SELECT ProductCategoryKey
          FROM DimProductSubcategory s
          WHERE s.ProductSubcategoryKey =
              (SELECT ProductSubcategoryKey
               FROM DimProduct p
               WHERE p.ProductKey = f.ProductKey)
         )
    ) AS Category
FROM FactResellerSales f;
-- ESPLORA LA TABELLA DIMRESELLER
SELECT *
FROM DimReseller;

-- elenco reseller con area geografica
SELECT 
    r.ResellerName,
    g.EnglishCountryRegionName,
    g.StateProvinceName,
    g.City
FROM DimReseller r
JOIN DimGeography g
    ON r.GeographyKey = g.GeographyKey;
    
    -- subquery
    SELECT 
    ResellerName,
    
    (SELECT EnglishCountryRegionName
     FROM DimGeography g
     WHERE g.GeographyKey = r.GeographyKey) AS Country,
     
    (SELECT StateProvinceName
     FROM DimGeography g
     WHERE g.GeographyKey = r.GeographyKey) AS Province,
     
    (SELECT City
     FROM DimGeography g
     WHERE g.GeographyKey = r.GeographyKey) AS City
     
FROM DimReseller r;

-- trasazioni complete con prodotto, categoria, resellere area geografica
-- join
SELECT 
    f.SalesOrderNumber,
    f.SalesOrderLineNumber,
    f.OrderDate,
    f.UnitPrice,
    f.OrderQuantity,
    f.TotalProductCost,
    
    p.EnglishProductName,
    c.EnglishProductCategoryName,
    
    r.ResellerName,
    g.EnglishCountryRegionName,
    g.StateProvinceName,
    g.City
    
FROM FactResellerSales f

JOIN DimProduct p
    ON f.ProductKey = p.ProductKey

JOIN DimProductSubcategory s
    ON p.ProductSubcategoryKey = s.ProductSubcategoryKey

JOIN DimProductCategory c
    ON s.ProductCategoryKey = c.ProductCategoryKey

JOIN DimReseller r
    ON f.ResellerKey = r.ResellerKey

JOIN DimGeography g
    ON r.GeographyKey = g.GeographyKey;
    
    -- subquery
    
    SELECT 
    SalesOrderNumber,
    SalesOrderLineNumber,
    OrderDate,
    UnitPrice,
    OrderQuantity,
    TotalProductCost,

    /* nome prodotto */
    (SELECT EnglishProductName
     FROM DimProduct p
     WHERE p.ProductKey = f.ProductKey) AS ProductName,

    /* categoria prodotto */
    (SELECT EnglishProductCategoryName
     FROM DimProductCategory c
     WHERE c.ProductCategoryKey =
        (SELECT ProductCategoryKey
         FROM DimProductSubcategory s
         WHERE s.ProductSubcategoryKey =
            (SELECT ProductSubcategoryKey
             FROM DimProduct p
             WHERE p.ProductKey = f.ProductKey)
        )
    ) AS Category,

    /* nome reseller */
    (SELECT ResellerName
     FROM DimReseller r
     WHERE r.ResellerKey = f.ResellerKey) AS Reseller,

    /* area geografica */
    (SELECT EnglishCountryRegionName
     FROM DimGeography g
     WHERE g.GeographyKey =
        (SELECT GeographyKey
         FROM DimReseller r
         WHERE r.ResellerKey = f.ResellerKey)
    ) AS Country,

    (SELECT StateProvinceName
     FROM DimGeography g
     WHERE g.GeographyKey =
        (SELECT GeographyKey
         FROM DimReseller r
         WHERE r.ResellerKey = f.ResellerKey)
    ) AS Province,

    (SELECT City
     FROM DimGeography g
     WHERE g.GeographyKey =
        (SELECT GeographyKey
         FROM DimReseller r
         WHERE r.ResellerKey = f.ResellerKey)
    ) AS City

FROM FactResellerSales f;
