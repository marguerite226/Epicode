SELECT SalesOrderNumber, OrderDate, Productkey, SalesAmount, TotalProductCost,(SalesAmount-TotalProductCost)
AS Profitto
FROM FactResellerSales
WHERE OrderDate >= '2020-01-01factresellersales' AND Productkey IN ( 597, 598, 477, 214); 