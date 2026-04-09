SELECT Productkey, COUNT(*) AS Numerooccorenze
FROM dimproduct
GROUP BY ProductKey
having COUNT(*) > 1;
--- VERIFICA NULL
SELECT *
FROM dimproduct
WHERE ProductKey IS NULL;
--- Il campo productkey non può essere una chiave primaria perché contiene valori NULL. 
--- Numero di transazioni al giorno dal 01 genanaio 2020
SELECT OrderDate,
Count(SalesOrderLineNumber) AS NumberTransazioni
FROM factresellersales
WHERE OrderDate >= '2020-01-01'
GROUP BY OrderDate
ORDER BY OrderDate;
--- fatturato totale, quantità totale e prezzo medio per prodotto
SELECT 
    p.EnglishProductName AS NomeProdotto,
    SUM(f.SalesAmount) AS FatturatoTotale,
    SUM(f.OrderQuantity) AS QuantitaTotaleVenduta,
    AVG(f.UnitPrice) AS PrezzoMedioVendita
FROM FactResellerSales f
JOIN DimProduct p
    ON f.ProductKey = p.ProductKey
WHERE f.OrderDate >= '2020-01-01'
GROUP BY p.EnglishProductName
ORDER BY FatturatoTotale DESC;
--- fatturato totale e quantità totale per categoria prodotto
SELECT 
    c.EnglishProductCategoryName AS CategoriaProdotto,
    SUM(f.SalesAmount) AS FatturatoTotale,
    SUM(f.OrderQuantity) AS QuantitaTotaleVenduta
FROM FactResellerSales f
JOIN DimProduct p
    ON f.ProductKey = p.ProductKey
JOIN DimProductSubcategory s
    ON p.ProductSubcategoryKey = s.ProductSubcategoryKey
JOIN DimProductCategory c
    ON s.ProductCategoryKey = c.ProductCategoryKey
GROUP BY c.EnglishProductCategoryName
ORDER BY FatturatoTotale DESC;
--- Fatturato totale per città dal 1 Gennaio 2020 solo città >60k
SELECT 
    g.City AS Citta,
    SUM(f.SalesAmount) AS FatturatoTotale
FROM FactResellerSales f
JOIN DimReseller r
    ON f.ResellerKey = r.ResellerKey
JOIN DimGeography g
    ON r.GeographyKey = g.GeographyKey
WHERE f.OrderDate >= '2020-01-01'
GROUP BY g.City
HAVING SUM(f.SalesAmount) > 60000
ORDER BY FatturatoTotale DESC;