/*----Subtask.05.04 
--Topic: Working with Multiple Grouping Sets 
--Task: The company wants to see and analyze the total due of orders made by Territory Group, Territory,
--Year and Sales Person with totals.
--Calculate Total made by Sales person in a year. Calculate totals for Territory Group and Name.
--Calculate grand total. Display the following columns: · Territory Group · Territory Name
--· Order Year · Full Name · Total due Expected result - the only one query.*/
;WITH cte 
as
    (SELECT  t.[Group] AS [Territory Group]
           , t.[Name]  AS [Territory Name]
           , YEAR(h.[OrderDate]) AS [OrderYear]
           , p.[FirstName] + ' ' + p.[LastName] as [Full Name]
           , SUM(h.[TotalDue]) AS [SumTotalDue]
     FROM [Sales].[SalesOrderHeader] h
     join [Sales].[SalesTerritory] t on t.[TerritoryID]=h.TerritoryID
     join [Sales].[SalesPerson] s on s.TerritoryID=t.TerritoryID
     join [Person].[Person] p on p.BusinessEntityID=s.BusinessEntityID
     WHERE  h.[OrderDate] IS NOT NULL 
     GROUP BY GROUPING SETS 
             (
             (t.[Group]),
             (t.[Name]),
             (YEAR(h.[OrderDate])),
             (p.[FirstName] , p.[LastName])
             )
         )

SELECT
       [Territory Group]
      ,[Territory Name]
      ,[OrderYear]
      ,[Full Name]
      ,[SumTotalDue]
FROM cte a

--Subtask.04.03. Topic: Pivoting Data 
--Task: Get customers and count of their orders splitted by years with order's sum more than 20000.
--Use [Sales].[SalesOrderHeader], [Sales].[SalesOrderDetail], [Sales].[Customer], [Person].[Person]
--The customer name should consist of FirstName, MiddleName and LastName as well

;WITH cte 
AS
    (
     SELECT p.[FirstName] + ' ' + ISNULL(p.[MiddleName],' ') + ' ' + p.[LastName] AS [CustomerName]
         -- , h.SalesOrderID AS [SalesOrderID]
          , YEAR(h.[OrderDate]) AS [YearDate]
          , SUM(h.TotalDue) AS [TotalSum]
     FROM [Sales].[SalesOrderHeader] h
     JOIN [Sales].[SalesOrderDetail] od    ON od.SalesOrderID=h.SalesOrderID
     JOIN [Sales].[Customer] c             ON c.CustomerID=h.CustomerID
     JOIN [Person].[Person] p              ON p.BusinessEntityID=c.PersonID
     WHERE h.[OrderDate] IS NOT NULL
     GROUP BY p.[LastName],p.[FirstName],p.[MiddleName],YEAR(h.[OrderDate])
     HAVING SUM(h.TotalDue)>20000
        )

SELECT DISTINCT [CustomerName],[2011],[2012],[2013],[2014]
FROM cte
PIVOT (SUM([TotalSum])
FOR [YearDate] IN (
                    [2011],
                    [2012],
                    [2013],
                    [2014])) AS P
ORDER BY [CustomerName]
       
-----------------Generate Date
--+ additional task: using a Recursive CTE please generate dates 
--for current year plus number of the day in the year(asc) like result set below:

;WITH Rec_CTE 
   AS (
        SELECT CAST('2021-01-01' AS DATE) AS [Dates]
        , DATEPART(dayofyear,'2021-01-01')  AS [NDay]
        UNION ALL
        SELECT CAST((DATEADD(DAY, 1, [Dates])) as date) as [Dates]
        , (DATEPART(dayofyear,[Dates]))+1  AS [NDay]
        FROM Rec_CTE
        WHERE [Dates] < '2021-12-31'
       )
SELECT CAST([Dates] AS DATE) AS [Dates]
          , [NDay]
FROM Rec_CTE
OPTION (maxrecursion 0)
