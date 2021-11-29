--Subtask.04.03. Topic: Pivoting Data 
--Task: Get customers and count of their orders splitted by years with order's sum more than 20000.
--Use [Sales].[SalesOrderHeader], [Sales].[SalesOrderDetail], [Sales].[Customer], [Person].[Person]
--The customer name should consist of FirstName, MiddleName and LastName as well

/*SELECT *
FROM [Person].[Person] p
join [Sales].[Customer] c ON c.PersonID=p.BusinessEntityID*/
;WITH cte 
AS
(
SELECT p.[FirstName] + ' ' + ISNULL(p.[MiddleName],' ') + ' ' + p.[LastName] AS [CustomerName]
     , h.SalesOrderID AS [SalesOrderID]
     , YEAR(h.ShipDate) AS [YearDate]
     , h.TotalDue AS [TotalSum]
FROM [Sales].[SalesOrderHeader] h
    JOIN [Sales].[SalesOrderDetail] od    ON od.SalesOrderID=h.SalesOrderID
    JOIN [Sales].[Customer] c             ON c.CustomerID=h.CustomerID
    JOIN [Person].[Person] p              ON p.BusinessEntityID=c.PersonID
    WHERE h.ShipDate IS NOT NULL
    GROUP BY h.ShipDate,p.[LastName],p.[FirstName],p.[MiddleName],h.TotalDue,h.SalesOrderID
    HAVING SUM(h.TotalDue)>20000
    )

/*SELECT Distinct m.[YearDate]
FROM cte m*/
SELECT DISTINCT [CustomerName],[2011],[2012],[2013],[2014]
FROM cte
PIVOT (COUNT([SalesOrderID])
FOR [YearDate] IN ([2011],[2012],[2013],[2014])) AS P
ORDER BY [CustomerName]
       


/*
SELECT *
FROM[Sales].[SalesOrderDetail]
SELECT *
FROM[Sales].[Customer]
SELECT *
FROM[Sales].[SalesOrderDetail]
SELECT *
FROM[Sales].[SalesOrderHeader]*/