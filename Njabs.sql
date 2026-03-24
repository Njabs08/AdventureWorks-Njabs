/*
Name: Njabulo P Tshuma 
Course: IT143
Assignment: AdventureWorks – Create Answers
Date: 2026/03/24

Description:
This SQL script answers business and metadata questions
using the AdventureWorks2022 database. Each query is written
to translate user questions into SQL statements using proper
joins, aggregations, and filtering techniques.
*/

USE AdventureWorks2022;
GO

/* =========================================================
   Q1 — Marginal Complexity
   Question: What are the top ten most expensive products based on list price?
   Author: [Your Name]
   ========================================================= */

-- Retrieve the top 10 most expensive products
SELECT TOP 10
    Name,           -- Product name
    ListPrice       -- Product price
FROM Production.Product
ORDER BY ListPrice DESC;  -- Highest price first


/* =========================================================
   Q2 — Marginal Complexity
   Question: Which employees have the highest recorded vacation hours?
   Author: []
   ========================================================= */

-- List employees ordered by highest vacation hours
SELECT
    BusinessEntityID,  -- Employee ID
    VacationHours      -- Vacation hours available
FROM HumanResources.Employee
ORDER BY VacationHours DESC;


/* =========================================================
   Q3 — Moderate Complexity
   Question: Calculate net revenue (list price - standard cost)
             and identify the five products with the highest net revenue.
   Author: []
   ========================================================= */

-- Calculate profit per product and return top 5
SELECT TOP 5
    Name,
    ListPrice,
    StandardCost,
    (ListPrice - StandardCost) AS NetRevenue  -- Profit per unit
FROM Production.Product
ORDER BY NetRevenue DESC;


/* =========================================================
   Q4 — Moderate Complexity
   Question: Find total sales quantity and revenue by product category.
   Author: []
   ========================================================= */

-- Aggregate sales by product category
SELECT
    pc.Name AS Category,                     -- Product category
    SUM(sod.OrderQty) AS TotalQuantity,     -- Total units sold
    SUM(sod.LineTotal) AS TotalRevenue      -- Total revenue
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p
    ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc
    ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY TotalRevenue DESC;


/* =========================================================
   Q5 — Increased Complexity
   Question: Monthly road bike sales in 2013 grouped by region,
             including quantity, price, and estimated profit.
   Author: []
   ========================================================= */

-- Analyze road bike sales trends by region and month
SELECT
    cr.Name AS Region,                               -- Country/region
    MONTH(soh.OrderDate) AS OrderMonth,              -- Month of sale
    SUM(sod.OrderQty) AS TotalQuantity,              -- Units sold
    AVG(sod.UnitPrice) AS AvgListPrice,              -- Average price
    SUM((sod.UnitPrice - p.StandardCost) * sod.OrderQty)
        AS EstimatedProfit                           -- Profit estimate
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod
    ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p
    ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc
    ON ps.ProductCategoryID = pc.ProductCategoryID
JOIN Person.Address a
    ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp
    ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr
    ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE
    pc.Name = 'Bikes'
    AND ps.Name LIKE '%Road%'
    AND YEAR(soh.OrderDate) = 2013
GROUP BY
    cr.Name,
    MONTH(soh.OrderDate)
ORDER BY
    cr.Name,
    OrderMonth;


/* =========================================================
   Q6 — Increased Complexity
   Question: Salesperson performance by quarter in 2012,
             including total sales, number of orders,
             and average revenue per order.
   Author: []
   ========================================================= */

-- Evaluate employee sales performance
SELECT
    sp.BusinessEntityID AS SalesPerson,             -- Salesperson ID
    DATEPART(QUARTER, soh.OrderDate) AS Quarter,    -- Quarter
    COUNT(DISTINCT soh.SalesOrderID) AS NumberOfOrders,
    SUM(soh.TotalDue) AS TotalSales,
    AVG(soh.TotalDue) AS AvgRevenuePerOrder
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesPerson sp
    ON soh.SalesPersonID = sp.BusinessEntityID
WHERE YEAR(soh.OrderDate) = 2012
GROUP BY
    sp.BusinessEntityID,
    DATEPART(QUARTER, soh.OrderDate)
ORDER BY
    sp.BusinessEntityID,
    Quarter;


/* =========================================================
   Q7 — Metadata Question
   Question: List all tables containing a column named ProductID.
   Author: []
   ========================================================= */

-- Find all tables with ProductID column
SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'ProductID';


/* =========================================================
   Q8 — Metadata Question
   Question: Identify all columns related to customer data
             and the tables they belong to.
   Author: []
   ========================================================= */

-- Find columns containing the word "Customer"
SELECT
    TABLE_NAME,
    COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE '%Customer%';
