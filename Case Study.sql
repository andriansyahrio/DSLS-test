/*
Product Analysis
*/
--Analisis Penjualan produk Chang tiap bulannya di 1997
SELECT MONTH(Orders.OrderDate) as Bulan, SUM([Order Details].Quantity) as Jumlah_Terjual
FROM Orders
JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
JOIN Products ON [Order Details].ProductID = Products.ProductID
WHERE Products.ProductName = 'Chang' and YEAR(Orders.OrderDate) = 1997
GROUP BY MONTH(Orders.OrderDate)
ORDER BY MONTH(Orders.OrderDate)

--Identifikasi produk yang paling laris di USA dan Australia.
SELECT Products.ProductName, SUM([Order Details].Quantity) as Jumlah_Terjual
FROM Orders
JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
JOIN Products ON [Order Details].ProductID = Products.ProductID
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE (Customers.Country = 'USA' OR Customers.Country = 'Australia')
GROUP BY Products.ProductName
ORDER BY Jumlah_Terjual DESC

/*
CUSTOMER ANALYSIS
*/
--Analisis jumlah pembelian pelanggan dari negara USA
WITH Customer_Purchases AS (
SELECT Customers.CustomerID, Customers.CompanyName, SUM([Order Details].Quantity) as Total_Quantity, Customers.Country
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
WHERE Customers.Country = 'USA'
GROUP BY Customers.CustomerID, Customers.CompanyName, Customers.Country
)
SELECT CompanyName, Total_Quantity
FROM Customer_Purchases
ORDER BY Total_Quantity DESC

--Identifikasi pelanggan yang paling sering melakukan pengiriman ke negara sweden,
SELECT Customers.CompanyName, COUNT(Orders.OrderID) as Total_Orders
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.ShipCountry = 'Sweden'
GROUP BY Customers.CompanyName
ORDER BY Total_Orders DESC


/*
Employee Analysis
*/
--Analisis employee dan title employee yang banyak berurusan dengan order.
SELECT Employees.FirstName, Employees.LastName, Employees.Title, COUNT(Orders.OrderID) AS OrderCount
FROM Employees
JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.EmployeeID, Employees.FirstName, Employees.LastName, Employees.Title
ORDER BY OrderCount DESC;

--Analisis persentase karyawan berdasarkan jenis title
SELECT Title, COUNT(*) * 100 / (SELECT COUNT(*) FROM Employees) AS "Percentage"
FROM Employees
GROUP BY Title;
-------------------------------------


