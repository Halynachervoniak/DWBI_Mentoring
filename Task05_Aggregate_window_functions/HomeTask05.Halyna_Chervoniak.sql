USE [AdventureWorks2019]
GO;

--Subtask.05.02 Topic: Window Ranking Functions 
--Task: Prepare result set without duplicated records from table @T 
--using ROW_NUMBER() function 
--Use the following script: 
--DECLARE @T TABLE(PersonName NVARCHAR(50), PersonAge INT); 
--INSERT INTO @T VALUES(N'Вася', 19),(N'Катя', 20),(N'Вася', 19),(N'Катя', 20),(N'Юля', 19),(N'Юля', 20);
--SELECT * FROM @T; Expected result: result set must be without duplicates 

DECLARE @T TABLE(PersonName NVARCHAR(50), PersonAge INT); 
INSERT INTO @T VALUES(N'Вася', 19),(N'Катя', 20),(N'Вася', 19),(N'Катя', 20),(N'Юля', 19),(N'Юля', 20); 
;WITH Cte
AS(
SELECT 
   ROW_NUMBER() OVER (PARTITION BY PersonName ORDER BY  PersonAge ) row_num,
   --RANK () OVER (PARTITION BY PersonName ORDER BY  PersonAge ) row_rank,
   PersonName, 
   PersonAge

   FROM @T)
   SELECT *
   FROM Cte AS d
   WHERE d.row_num=1

   /* 
--Subtask.05.03 
--Topic: Working with a Single Grouping Set 
--Task: The company wants to see the changing of the total due of orders in the different countries on the year base.
--Display the following columns: ·
--Territory Name · Order Year · Total Due · Previous Total Due (calculate total due for the previous year and the same territory)*/
;WITH cte 
AS
    (SELECT h.[TerritoryID] AS [TerritoryID]
           , t.[Name] AS [TerritoryName]
           , YEAR(h.[OrderDate]) AS [OrderYear]
           , SUM([TotalDue])  AS [SumTotalDue]
     FROM [Sales].[SalesOrderHeader] h
     JOIN [Sales].[SalesTerritory] t ON t.[TerritoryID]=h.TerritoryID
     GROUP BY h.[TerritoryID],t.[Name],YEAR(h.[OrderDate]))
     
     SELECT [TerritoryID]
           ,[TerritoryName]
           ,[OrderYear]
           ,[SumTotalDue]
           ,LAG([SumTotalDue]) OVER ( PARTITION BY [TerritoryID],[TerritoryName] ORDER BY [OrderYear] )  AS [PreviousTotalDue]
     FROM cte
     ORDER BY [TerritoryName],[OrderYear]


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

