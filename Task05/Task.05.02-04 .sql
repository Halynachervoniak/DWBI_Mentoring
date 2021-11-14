--Subtask.05.02 
--Topic: Window Ranking Functions
--Task: Prepare result set without duplicated records from table @T using ROW_NUMBER() function 
 
/*Use the following script: 
DECLARE @T TABLE(PersonName NVARCHAR(50), PersonAge INT); 
INSERT INTO @T VALUES(N'Вася', 19),(N'Катя', 20),(N'Вася', 19),(N'Катя', 20),(N'Юля', 19),(N'Юля', 20); 
SELECT * FROM @T; 
 
Expected result: result set must be without duplicates */

DECLARE @T TABLE(PersonName NVARCHAR(50), PersonAge INT); 
INSERT INTO @T VALUES(N'Вася', 19),(N'Катя', 20),(N'Вася', 19),(N'Катя', 20),(N'Юля', 19),(N'Юля', 20); 
;WITH Cte
AS(

--SELECT * FROM @T

SELECT 
   ROW_NUMBER() OVER (PARTITION BY PersonName ORDER BY  PersonAge ) row_num,
   RANK () OVER (PARTITION BY PersonName ORDER BY  PersonAge ) row_rank,
   PersonName, 
   PersonAge

   FROM @T)
   SELECT *
   FROM Cte AS d
   where d.row_num=1

/* 
--Subtask.05.03 
--Topic: Working with a Single Grouping Set 
--Task: The company wants to see the changing of the total due of orders in the different countries on the year base.
--Display the following columns: ·
--Territory Name · Order Year · Total Due · Previous Total Due (calculate total due for the previous year and the same territory)*/
--
; with cte as
(select h.[TerritoryID] as [TerritoryID]
     , t.[Name] as [Name]
     ,[TotalDue] as [TotalDue]
    ,h.[OrderDate]
     , YEAR(h.[OrderDate]) AS [CurrentYear]
     --,(YEAR(h.[OrderDate])-1) AS [PriorYear]
     , SUM([TotalDue]) OVER (PARTITION BY h.[TerritoryID],YEAR(h.[OrderDate]) ORDER BY YEAR(h.[OrderDate]) ) AS [SumTotalDue]
      --, SUM([TotalDue]) OVER (PARTITION BY h.[TerritoryID],(YEAR(h.[OrderDate])-1) ORDER BY (YEAR(h.[OrderDate])-1) ) AS [TotalDue2]
     --, SUM([TotalDue]) OVER (PARTITION BY (YEAR(h.[OrderDate])-1) ORDER BY h.[TerritoryID] ) AS [TotalDueP]
     --/*, LAG(SUM([TotalDue])OVER (PARTITION BY h.[TerritoryID] ORDER BY  YEAR(h.[OrderDate]),t.[Name]))
    ---- OVER (PARTITION BY h.[TerritoryID] ORDER BY  YEAR(h.[OrderDate]),t.[Name]) AS jj
     --, SUM([TotalDue])OVER (PARTITION BY h.[TerritoryID] ORDER BY  (YEAR(h.[OrderDate])-1) ,t.[Name]) AS [PreviousTotalDue]
     --, SUM([TotalDue])OVER (PARTITION BY YEAR(h.[OrderDate]),h.[TerritoryID] ORDER BY  YEAR(h.[OrderDate])) AS [TotalDue1]*/
     --, LAG([TotalDue]) OVER (PARTITION BY h.[TerritoryID],YEAR(h.[OrderDate]) ORDER BY YEAR(h.[OrderDate]) )  AS [PreviousTotalDue1]
FROM [Sales].[SalesOrderHeader] h
join [Sales].[SalesTerritory] t on t.[TerritoryID]=h.TerritoryID)

select distinct [TerritoryID],[Name]
               ,[CurrentYear]
               ,[SumTotalDue]
               ,LAG([SumTotalDue]) OVER ( PARTITION BY [TerritoryID],[Name] ORDER BY [CurrentYear] )  AS [PreviousTotalDue1]
from cte
order by [Name],[CurrentYear]
/*----Subtask.05.04 
--Topic: Working with Multiple Grouping Sets 
--Task: The company wants to see and analyze the total due of orders made by Territory Group, Territory,
--Year and Sales Person with totals.
--Calculate Total made by Sales person in a year. Calculate totals for Territory Group and Name.
--Calculate grand total. Display the following columns: · Territory Group · Territory Name
--
--· Order Year · Full Name · Total due Expected result - the only one query.*/
;WITH cte as
(select h.[TerritoryID]
     , t.[Name]  as [Territory Name]
      ,h.[OrderDate]
      ,[Group] as [Territory Group]
      ,[FirstName] + ' ' + [LastName] as [Full Name]
      , YEAR(h.[OrderDate]) AS [OrderYear]
      , SUM([TotalDue]) OVER (PARTITION BY t.[Group] ORDER BY  YEAR(h.[OrderDate])) AS [TotalDueGroup]
      , SUM([TotalDue]) OVER (PARTITION BY p.[BusinessEntityID] ORDER BY  YEAR(h.[OrderDate])) AS [TotalDuePerson]

     , SUM([TotalDue])OVER (PARTITION BY h.[TerritoryID] ORDER BY  YEAR(h.[OrderDate])) AS [TotalDueTerritory]
     , SUM([TotalDue])OVER (PARTITION BY YEAR(h.[OrderDate]) ORDER BY  YEAR(h.[OrderDate])) AS [TotalDueYear]
     , SUM([TotalDue])OVER () AS [GrandTotalDue]
FROM [Sales].[SalesOrderHeader] h
join [Sales].[SalesTerritory] t on t.[TerritoryID]=h.TerritoryID
join [Sales].[SalesPerson] s on s.TerritoryID=t.TerritoryID
join [Person].[Person] p on p.BusinessEntityID=s.BusinessEntityID)

SELECT distinct [Territory Group],[Territory Name],[OrderYear],[Full Name],[TotalDueGroup]
,[TotalDuePerson],[TotalDueTerritory],[TotalDueYear],[GrandTotalDue]
FROM cte a

/*SELECT DISTINCT YEAR(h.[OrderDate]),h.[TerritoryID]
,SUM([TotalDue]) OVER (PARTITION BY h.[TerritoryID] ORDER BY  YEAR(h.[OrderDate])) AS [TotalDueG]
,LAG([TotalDue]) OVER (PARTITION BY h.[TerritoryID] ORDER BY  YEAR(h.[OrderDate])) AS [TotalDueG]
FROM [Sales].[SalesOrderHeader] h
ORDER BY YEAR(h.[OrderDate]),h.[TerritoryID]*/
