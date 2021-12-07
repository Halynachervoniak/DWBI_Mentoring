USE AdventureWorks2019;
Go

--Subtask.04.03. Topic: Pivoting Data 
--Task: Get customers and count of their orders splitted by years with order's sum more than 20000.
--Use [Sales].[SalesOrderHeader], [Sales].[SalesOrderDetail], [Sales].[Customer], [Person].[Person]
--The customer name should consist of FirstName, MiddleName and LastName as well

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

SELECT DISTINCT [CustomerName],[2011],[2012],[2013],[2014]    -- distinct?
FROM cte
PIVOT (SUM([TotalSum])
FOR [YearDate] IN (
                    [2011],
                    [2012],
                    [2013],
                    [2014])) AS P
ORDER BY [CustomerName]
       
----------------------------------------------------------------------------------------------------------------------------
/*Subtask.04.04 	Topic: APPLY operator
Task: For each product in Production.Product, select special offer.

Display the following columns: 
•	ProductId 
•	Product name  
•	Special offer description 

Use Apply and read task carefully  

Example:
SELECT  
u.[DisplayName], 
MAX(wi.EffortCompleted) 
FROM [dbo].[WorkItem] AS wi 
INNER JOIN [dbo].[Users] AS u 
ON u.ID = wi.AssignedToId 
GROUP BY u.[DisplayName] 
 
SELECT  
u.[DisplayName],  
a.EffortCompleted, 
a.WorkItemId 
FROM [dbo].[Users] AS u 
CROSS APPLY  
( 
SELECT TOP(3)  
wi.WorkItemId 
,wi.EffortCompleted 
FROM [dbo].[WorkItem] AS wi 
WHERE u.ID = wi.AssignedToId 
ORDER BY wi.EffortCompleted DESC 
) AS A 
*/
SELECT p.[ProductID]
      ,[Name] AS ProductName
      ,[OrderQty]
FROM [Production].[Product] p
CROSS APPLY(SELECT  [ProductID],[OrderQty]
               FROM [Production].[WorkOrder] AS w
               WHERE w.[ProductID]=p.[ProductID]
               AND [OrderQty]>15
               --ORDER BY  productid,[OrderQty]
               ) a

----------------------------------------------------------------------------------------------------------------------------
/*
Subtask 04.05	Topic : Recursive Queries
Task:
For the next subtask you need to run the next script on your local sql server  
It will create two new tables – Departments and Employees  
USE [TSQL2012] 
GO 
/****** Object:  Schema [Depts]    Script Date: 11/7/2016 7:30:57 PM ******/ 
CREATE SCHEMA [Depts] 
GO 
/****** Object:  Table [Depts].[Departments]    Script Date: 11/7/2016 7:31:11 PM ******/ 
SET ANSI_NULLS ON 
GO 
SET QUOTED_IDENTIFIER ON 
GO 
  
CREATE TABLE [Depts].[Departments]( 
       [DepartmentID] [int] NOT NULL, 
       [Name] [nvarchar](50) NOT NULL, 
       [ParentID] [int] NULL 
) ON [PRIMARY] 
GO 
  
INSERT INTO [Depts].[Departments]( 
        [DepartmentID] 
       ,[Name] 
       ,[ParentID]) 
VALUES 
       (1,N'Департамент ИТ',NULL), 
       (2,N'Отдел СЭД',1), 
       (3,N'Группа разработки СЭД',2), 
       (4,N'Группа поддержки СЭД',2), 
       (5,N'Группа администрирования СЭД',2), 
       (6,N'HelpDesk',1), 
       (7,N'1-я линия поддержки',6), 
       (8,N'2-я линия поддержки',6), 
       (9,N'Отдел развития сетевого хранилища',1), 
       (10,N'Группа разработки и внедрения',9), 
       (11,N'Группа поддержки',9), 
       (12,N'Служба поддержки инфраструктуры',1), 
       (13,N'Группа системного администрирования',12), 
       (14,N'Группа поддержки рабочего места',12) 
GO 
  
/****** Object:  Table [Depts].[Employees]    Script Date: 11/7/2016 7:31:13 PM ******/ 
CREATE TABLE [Depts].[Employees]( 
       [EmployeeID] [int] NOT NULL, 
       [FirstName] [nvarchar](50) NOT NULL, 
       [LastName] [nvarchar](50) NOT NULL, 
       [DepartmentID] [int] NOT NULL, 
       [JobPosition] [nvarchar](50) NULL 
) ON [PRIMARY] 
GO 
  
INSERT INTO [Depts].[Employees]( 
        [EmployeeID] 
       ,[FirstName] 
       ,[LastName] 
       ,[DepartmentID] 
       ,[JobPosition]) 
VALUES 
       (1,N'Алёна',N'Козырь',1,N'Руководитель департамента'), 
       (2,N'Алексей',N'Ведров',6,N'Руководитель отдела'), 
       (3,N'Егор',N'Шаров',7,N'Начальник группы'), 
       (4,N'Егор',N'Кругов',7,N'Специалист'), 
       (5,N'Алёна',N'Белая',7,N'Специалист'), 
       (6,N'Антон',N'Квадратов',8,N'Начальник группы'), 
       (7,N'Наталья',N'Белая',8,N'Главный специалист'), 
       (8,N'Виктор',N'Линейный',8,N'Главный специалист'), 
       (9,N'Виктория',N'Кругова',9,N'Руководитель отдела'), 
       (10,N'Виктор',N'Кругов',10,N'Старший программист'), 
       (11,N'Ирина',N'Белая',10,N'Программист'), 
       (12,N'Наталья',N'Кругова',11,N'Специалист'), 
       (13,N'Ольга',N'Браво',11,N'Специалист'), 
       (14,N'Виктория',N'Козырь',2,N'Руководитель отдела'), 
       (15,N'Ольга',N'Кругова',5,N'Главный специалист'), 
       (16,N'Андрей',N'Ведров',5,N'Специалист'), 
       (17,N'Егор',N'Ведров',4,N'Специалист'), 
       (18,N'Алексей',N'Линейный',4,N'Специалист'), 
       (19,N'Виктор',N'Шаров',3,N'Старший специалист'), 
       (20,N'Виктория',N'Белая',3,N'Главный специалист'), 
       (21,N'Ирина',N'Кругова',3,N'Начальник группы'), 
       (22,N'Ольга',N'Северная',3,N'Специалист'), 
       (23,N'Андрей',N'Кругов',12,N'Руководитель службы'), 
       (24,N'Ирина',N'Северная',12,N'Заместитель руководителя'), 
       (25,N'Алёна',N'Северная',13,N'Системный администратор'), 
       (26,N'Ольга',N'Белая',13,N'Системный администратор'), 
       (27,N'Виктория',N'Браво',13,N'Системный администратор'), 
       (28,N'Алексей',N'Шаров',13,N'Руководитель группы'), 
       (29,N'Виктория',N'Северная',14,N'Руководитель группы'), 
       (30,N'Алёна',N'Кругова',14,N'Инженер'), 
       (31,N'Виктор',N'Ведров',14,N'Инженер'), 
       (32,N'Алёна',N'Браво',14,N'Главный инженер'), 
       (33,N'Ирина',N'Козырь',14,N'Инженер'), 
       (34,N'Алексей',N'Квадратов',7,N'Специалист'), 
       (35,N'Наталья',N'Козырь',7,N'Специалист'), 
       (36,N'Наталья',N'Северная',7,N'Младший специалист'), 
       (37,N'Егор',N'Линейный',7,N'Младший специалист'), 
       (38,N'Ирина',N'Браво',7,N'Младший специалист'), 
       (39,N'Антон',N'Кругов',7,N'Младший специалист'), 
       (40,N'Антон',N'Линейный',8,N'Ведущий специалист'), 
       (41,N'Андрей',N'Квадратов',8,N'Ведущий специалист'), 
       (42,N'Антон',N'Ведров',8,N'Ведущий специалист'), 
       (43,N'Егор',N'Квадратов',8,N'Специалист'), 
       (44,N'Виктор',N'Квадратов',8,N'Специалист'), 
       (45,N'Ольга',N'Козырь',4,N'Ведущий специалист'), 
       (46,N'Наталья',N'Браво',3,N'Специалист'), 
       (47,N'Антон',N'Шаров',3,N'Специалист'), 
       (48,N'Андрей',N'Шаров',10,N'Программист'), 
       (49,N'Алексей',N'Кругов',14,N'Инженер'), 
       (50,N'Андрей',N'Линейный',14,N'Инженер') 

Make a query, which will return all full names of departments and their employees.  
Result set should contain next columns  
Department  	Fullname of department  
JobPosition  	JobPosition of employee  
Employee  	FullName of Employee (It contains FirstName and LastName )  
  
Tip: Look for link in presentation file. You can find full information about hierarchies there...  
  
Result Set Example:  
Department  	JobPosition  	Employee  
Департамент ИТ  	Руководитель департамента  	Алёна Козырь  
Департамент ИТ\HelpDesk  	Руководитель отдела  	Алексей Ведров  
Департамент ИТ\HelpDesk\1-я линия поддержки  	Начальник группы  	Егор Шаров  
Департамент ИТ\HelpDesk\1-я линия поддержки  	Специалист  	Егор Кругов  
Департамент ИТ\HelpDesk\1-я линия поддержки  	Специалист  	Алёна Белая  */
  
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

---+ additional task -Generate Date
--+ additional task: using a Recursive CTE please generate dates 
--for current year plus number of the day in the year(asc) like result set below:

DECLARE @currentstartyear date
DECLARE @currentendyear date
SET @currentstartyear= DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)
SET @currentendyear=DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)
select @currentstartyear, @currentendyear
--print @currentyear
--print @currentendyear

;WITH Rec_CTE 
   AS (
        SELECT CAST(@currentstartyear AS DATE) AS [Dates]
        , DATEPART(dayofyear,@currentstartyear)  AS [NDay]
        UNION ALL
        SELECT CAST((DATEADD(DAY, 1, [Dates])) as date) as [Dates]
        , (DATEPART(dayofyear,[Dates]))+1  AS [NDay]
        FROM Rec_CTE
        WHERE [Dates] < @currentendyear
       )
SELECT CAST([Dates] AS DATE) AS [Dates]
          , [NDay]
FROM Rec_CTE
OPTION (maxrecursion 0)

----------------------+ Additional 
 --additional task: create dynamic PIVOT query for Subtask.04.03.

DECLARE @columns nvarchar(max);
--DECLARE @SQL nvarchar(max);
  SET @columns = N'
;WITH cte 
AS
    (
     SELECT p.[FirstName] + '''''''''' + ISNULL(p.[MiddleName],'''''''') + '''''''''+ '''''''''p.[LastName] AS [CustomerName]
          , YEAR(h.[OrderDate]) AS [YearDate]
          , COUNT(h.TotalDue) AS [TotalSum]
     FROM [Sales].[SalesOrderHeader] h
     JOIN [Sales].[Customer] c             ON c.CustomerID=h.CustomerID
     JOIN [Person].[Person] p              ON p.BusinessEntityID=c.PersonID
     WHERE h.[OrderDate] IS NOT NULL
     GROUP BY p.[LastName],p.[FirstName],p.[MiddleName],YEAR(h.[OrderDate])
     HAVING SUM(h.TotalDue)>20000
        )

SELECT [CustomerName],'+ @columns +'
FROM cte
PIVOT (SUM([TotalSum])
FOR [YearDate] IN (
                    '+ @columns +')) AS P
ORDER BY [CustomerName]'
print @columns
exec (@columns);
print @columns
 --  SELECT @columns;
 -----------------------------------------------------------------------------
go
declare @columns nvarchar(max);
declare @sql nvarchar(max);

set @columns = N'';

select @columns = '[' + string_agg(cast(YearOfOrder as nvarchar(max)), '], [') WITHIN GROUP (ORDER BY YearOfOrder ASC) + ']'
from (
    select year(OrderDate) as YearOfOrder
    from [Sales].[SalesOrderHeader]
    group by year(OrderDate)
) x;

set @sql = N'
;with task_04_03_cte as (
SELECT 
    concat(p.[FirstName], '' '' + p.[MiddleName], '' '', p.[LastName]) AS CustomerName,
    p.BusinessEntityID,
/*    cast(sum(h.TotalDue) as decimal(18,2)) as TotalTotalDue,*/
    count(h.SalesOrderID) AS #SalesOrderID,
    year(h.OrderDate) as YearOfOrder
FROM [Sales].[SalesOrderHeader] h
    JOIN [Sales].[Customer] c             ON c.CustomerID=h.CustomerID
    JOIN [Person].[Person] p              ON p.BusinessEntityID=c.PersonID
    GROUP BY p.[LastName],p.[FirstName],p.[MiddleName],year(h.OrderDate) , p.BusinessEntityID
    HAVING SUM(h.TotalDue) > 20000   /* need to be clarified*/
)
select 
    [CustomerName],
    p.BusinessEntityID,
    ' + @columns + N' 
from task_04_03_cte 
    pivot (sum(#SalesOrderID) for YearOfOrder in (
    ' + @columns + N')) as p
order by CustomerName
';

print @sql
exec (@sql);