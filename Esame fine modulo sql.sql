
-- elimina database se esiste
DROP DATABASE IF EXISTS toysgrow;

CREATE DATABASE ToySGrow;
USE ToySGrow;

-- CATEGORY

CREATE TABLE Category (
    CategoryID INT AUTO_INCREMENT,
    CategoryName VARCHAR(50) NOT NULL,

    PRIMARY KEY (CategoryID)
);


-- SALES REGION

CREATE TABLE SalesRegion (
    SalesRegionID INT AUTO_INCREMENT,
    SalesRegionName VARCHAR(100) NOT NULL,

    PRIMARY KEY (SalesRegionID)
);

-- PRODUCT
CREATE TABLE Product (
    ProductID INT AUTO_INCREMENT,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    CategoryID INT NOT NULL,

    PRIMARY KEY (ProductID),

    FOREIGN KEY (CategoryID)
    REFERENCES Category(CategoryID)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);


-- STATE

CREATE TABLE State (
    StateID INT AUTO_INCREMENT,
    StateName VARCHAR(100) NOT NULL,
    SalesRegionID INT NOT NULL,

    PRIMARY KEY (StateID),

    FOREIGN KEY (SalesRegionID)
    REFERENCES SalesRegion(SalesRegionID)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);


-- SALES
CREATE TABLE Sales (
    OrderID INT AUTO_INCREMENT,
    OrderDate DATE NOT NULL,
    Quantity INT NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    ProductID INT NOT NULL,
    StateID INT NOT NULL,

    PRIMARY KEY (OrderID),

    FOREIGN KEY (ProductID)
    REFERENCES Product(ProductID)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    FOREIGN KEY (StateID)
    REFERENCES State(StateID)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

-- INSERT DATI SENZA NULL/ POPOLAMENTO DELLE TABELLE
INSERT INTO Category (CategoryName) VALUES
('Bikes'),
('Gloves'),
('Accessories');

INSERT INTO SalesRegion (SalesRegionName) VALUES
('Western Europe'),
('Southern Europe'),
('Northern Europe');

INSERT INTO Product (ProductName, Price, CategoryID) VALUES
('Bike-100', 500.00, 1),
('Bike-200', 800.00, 1),
('Glove-100', 20.00, 2),
('Helmet-200', 50.00, 3);

INSERT INTO State (StateName, SalesRegionID) VALUES
('Italy', 2),
('Germany', 1),
('France', 1),
('Sweden', 3);

INSERT INTO Sales (OrderDate, Quantity, TotalAmount, ProductID, StateID) VALUES
('2023-01-10', 10, 5000.00, 1, 1),
('2023-02-15', 5, 4000.00, 2, 2),
('2023-03-12', 20, 400.00, 3, 1),
('2022-11-05', 7, 3500.00, 1, 3),
('2023-04-20', 3, 150.00, 4, 4);

-- CONTROLLO

SELECT * FROM Category;
SELECT * FROM Product;
SELECT * FROM SalesRegion;
SELECT * FROM State;

-- creazione relazioni
ALTER TABLE Product
ADD FOREIGN KEY (CategoryID)
REFERENCES Category(CategoryID);

ALTER TABLE State
ADD FOREIGN KEY (SalesRegionID)
REFERENCES SalesRegion(SalesRegionID);

ALTER TABLE Sales
ADD FOREIGN KEY (ProductID)
REFERENCES Product(ProductID);

ALTER TABLE Sales
ADD FOREIGN KEY (StateID)
REFERENCES State(StateID);
select *
from product;
-- Implementazione fisica DDL
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS State;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS SalesRegion;

CREATE TABLE Category (
    CategoryID INT AUTO_INCREMENT,
    CategoryName VARCHAR(50) NOT NULL,
    PRIMARY KEY (CategoryID)
);

CREATE TABLE SalesRegion (
    SalesRegionID INT AUTO_INCREMENT,
    SalesRegionName VARCHAR(100) NOT NULL,
    PRIMARY KEY (SalesRegionID)
);

CREATE TABLE Product (
    ProductID INT AUTO_INCREMENT,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    CategoryID INT NOT NULL,
    PRIMARY KEY (ProductID),
    FOREIGN KEY (CategoryID)
    REFERENCES Category(CategoryID)
);

CREATE TABLE State (
    StateID INT AUTO_INCREMENT,
    StateName VARCHAR(100) NOT NULL,
    SalesRegionID INT NOT NULL,
    PRIMARY KEY (StateID),
    FOREIGN KEY (SalesRegionID)
    REFERENCES SalesRegion(SalesRegionID)
);

CREATE TABLE Sales (
    OrderID INT AUTO_INCREMENT,
    OrderDate DATE NOT NULL,
    Quantity INT NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    ProductID INT NOT NULL,
    StateID INT NOT NULL,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (ProductID)
    REFERENCES Product(ProductID),
    FOREIGN KEY (StateID)
    REFERENCES State(StateID)
);

-- TASK 4 
-- verifica valori distinti pk
SELECT ProductID, COUNT(*)
FROM Product
GROUP BY ProductID
HAVING COUNT(*) > 1;

-- 2 Elenco transazioni con indicazioni Oltre 180 giorni (campo booleanno)

SELECT 
    s.OrderID, s.OrderDate, p.ProductName, c.CategoryName, st.StateName,
    IF(DATEDIFF(CURDATE(), s.OrderDate) > 180, 'True', 'False') AS Oltre_180_Giorni
FROM sales s
JOIN product p ON s.ProductID = p.ProductID
JOIN category c ON p.CategoryID = c.CategoryID
JOIN state st ON s.StateID = st.StateID;

-- prodotti con vendite superiori alla media 
SELECT ProductID, SUM(Quantity) AS totale_quantita
FROM sales
WHERE OrderDate >= '2023-01-01'
GROUP BY ProductID
HAVING SUM(Quantity) >
(
SELECT AVG(Quantity)
FROM Sales
WHERE OrderDate >= '2023-01-01'
);

-- 4 elenco prodotti vendutti e fatturato totale per anno

SELECT 
YEAR(s.OrderDate)as anno,
Productname,
SUM(s.TotalAmount) as fatturato
FROM Sales s
JOIN product p ON s.ProductID = p.ProductID
GROUP BY p.ProductName,
YEAR(OrderDate);

-- Fatturato totale per stato

SELECT st.StateName,
 YEAR(s.OrderDate) AS Anno, SUM(s.TotalAmount) AS Fatturato
FROM sales s
JOIN state st ON s.StateID = st.StateID
GROUP BY st.StateName, Anno
ORDER BY Anno DESC, Fatturato DESC;

-- Categoria articoli maggiormente richiesta
SELECT 
    c.CategoryName, 
    SUM(s.Quantity) AS totale_vendite
FROM sales s
JOIN product p ON s.ProductID = p.ProductID
JOIN category c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY totale_vendite DESC
LIMIT 1;  

-- prodotti invenduti 
SELECT p.ProductName, p.ProductID
FROM Product p
LEFT JOIN Sales s
ON p.ProductID = s.ProductID
WHERE s.orderID  IS NULL;

-- vista denormalizzata dei prodotti
CREATE VIEW vista_prodotti_completa AS
SELECT
p.ProductID,
p.ProductName,
c.CategoryName
FROM Product p
JOIN Category c
ON p.CategoryID = c.CategoryID;

-- 9 vista informazioni geografiche
CREATE VIEW vista_geografia_completa AS
SELECT
st.stateID,
st.StateName,
sr.SalesRegionName
FROM State st
JOIN SalesRegion sr
ON st.SalesRegionID = sr.SalesRegionID;

