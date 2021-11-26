--Task 4
-- Subtask.04.03. Topic: Pivoting Data Task: Get customers and count of their orders splitted by years with order's sum more than 20000

;WITH cte 
AS
    (
     SELECT p.[FirstName] + ' ' + ISNULL(p.[MiddleName],' ') + ' ' + p.[LastName] AS [CustomerName]
          , YEAR(h.[OrderDate]) AS [YearDate]
          , COUNT(h.TotalDue) AS [TotalSum]
     FROM [Sales].[SalesOrderHeader] h
     JOIN [Sales].[Customer] c             ON c.CustomerID=h.CustomerID
     JOIN [Person].[Person] p              ON p.BusinessEntityID=c.PersonID
     WHERE h.[OrderDate] IS NOT NULL
--     AND [FirstName]='Abigail' and  [LastName]='Gonzalez'
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

----------------------------------------------------------------------------------------------------------------------------
--Subtask 04.05
--Make a query, which will return all full names of departments and their employees. Result set should contain next columns
;WITH Rec
AS
     (SELECT d.[DepartmentID] 
            ,d.[ParentID] 
            ,d.[Name] 
            ,CAST (d.[Name] AS NVARCHAR(4000)) AS DepartmentPath
     FROM [Depts].[Departments] d
     WHERE d.[ParentID] IS NULL
     UNION ALL
     SELECT m.[DepartmentID]
           ,m.[ParentID]
           ,m.[Name] 
           ,v.DepartmentPath +  '/'+ (CAST (m.[Name] AS NVARCHAR(4000)) )
     FROM [Depts].[Departments] m 
       JOIN Rec  v ON v.[DepartmentID]=m.ParentID 
     ) 
     
SELECT t.[DepartmentPath] AS Department
    ,e.[JobPosition]
    ,e.[FirstName]+e.[LastName] AS [Employee]
FROM Rec t
JOIN [Depts].[Employees] e ON e.[DepartmentID]=t.DepartmentId

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