SELECT MONTH(OrderDate) AS MONTH_ORDER, COUNT(DISTINCT CustomerID) AS COUNT_CUSTOMER FROM dbo.Orders
WHERE YEAR(OrderDate) = 1997 
GROUP BY MONTH(OrderDate)

SELECT EmployeeID, LastName, FirstName, Title
FROM Employees
WHERE Title = 'Sales Representative'

SELECT TOP 5 OD.ProductID, P.ProductName, OD.Quantity, YEAR(O.OrderDate) as Order_Year, MONTH(O.OrderDate) as Order_Month
FROM [Order Details] OD
JOIN Products P ON OD.ProductID = P.ProductID
JOIN Orders O ON OD.OrderID = O.OrderID
WHERE YEAR(O.OrderDate) = 1997 AND MONTH(O.OrderDate) = 1
ORDER BY OD.Quantity DESC

SELECT Suppliers.CompanyName, Products.ProductName, Orders.OrderDate
FROM Products
JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
join [Order Details] ON Products.ProductID = [Order Details].ProductID
join Orders On [Order Details].OrderID = Orders.OrderID
WHERE YEAR(Orders.OrderDate) = 1997 AND ProductName = 'Chai'

WITH purchase_summary AS (
SELECT
[Order Details].OrderID,
SUM([Order Details].UnitPrice * [Order Details].Quantity) as total_purchase
FROM [Order Details]
JOIN Orders ON [Order Details].OrderID = Orders.OrderID
GROUP BY [Order Details].OrderID
)
SELECT
SUM(CASE WHEN total_purchase <= 100 THEN 1 ELSE 0 END) as purchase_under_100,
SUM(CASE WHEN total_purchase > 100 AND total_purchase <= 250 THEN 1 ELSE 0 END) as purchase_between_100_250,
SUM(CASE WHEN total_purchase > 250 AND total_purchase <= 500 THEN 1 ELSE 0 END) as purchase_between_250_500,
SUM(CASE WHEN total_purchase > 500 THEN 1 ELSE 0 END) as purchase_over_500
FROM purchase_summary


Select Customers.CompanyName, SUM ([Order Details].Quantity) AS QUANTITY
FROM Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join [Order Details] on Orders.OrderID = [Order Details].OrderID
where YEAR(Orders.OrderDate) = 1997
group by Customers.CompanyName
having SUM ([Order Details].Quantity) > 500
ORDER BY SUM ([Order Details].Quantity)



WITH TOPFIVE AS (
    SELECT Products.ProductName, MONTH(orders.OrderDate) as Month, SUM([Order Details].Quantity ) as TotalSales,
    ROW_NUMBER() OVER (PARTITION BY MONTH(orders.OrderDate) ORDER BY SUM([Order Details].Quantity ) DESC) as RowNo
    FROM Orders
    JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
	JOIN Products ON [Order Details].ProductID = Products.ProductID
    WHERE YEAR(OrderDate) = 1997
    GROUP BY Products.ProductName, MONTH(orders.OrderDate)
)
SELECT ProductName, Month, TotalSales FROM TOPFIVE WHERE RowNo <= 5





CREATE VIEW Order_Details_View AS
SELECT
[Order Details].OrderID,
[Order Details].ProductID,
Products.ProductName,
[Order Details].UnitPrice,
[Order Details].Quantity,
[Order Details].Discount,
([Order Details].UnitPrice * [Order Details].Quantity) - (([Order Details].UnitPrice * [Order Details].Quantity) * [Order Details].Discount) AS Total_After_Discount
FROM [Order Details]
JOIN Products ON [Order Details].ProductID = Products.ProductID

SELECT *
FROM Order_Details_View


CREATE PROCEDURE InvoiceByCustomerID 
AS
    SELECT Customers.CustomerID, Customers.CompanyName, Orders.OrderID, Orders.OrderDate, Orders.RequiredDate, Orders.ShippedDate
    FROM Orders
    JOIN Customers ON Orders.CustomerID = Customers.CustomerID
GO
EXEC InvoiceByCustomerID













