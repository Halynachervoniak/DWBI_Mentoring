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
�	ProductId 
�	Product name  
�	Special offer description 

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
It will create two new tables � Departments and Employees  
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
       (1,N'����������� ��',NULL), 
       (2,N'����� ���',1), 
       (3,N'������ ���������� ���',2), 
       (4,N'������ ��������� ���',2), 
       (5,N'������ ����������������� ���',2), 
       (6,N'HelpDesk',1), 
       (7,N'1-� ����� ���������',6), 
       (8,N'2-� ����� ���������',6), 
       (9,N'����� �������� �������� ���������',1), 
       (10,N'������ ���������� � ���������',9), 
       (11,N'������ ���������',9), 
       (12,N'������ ��������� ��������������',1), 
       (13,N'������ ���������� �����������������',12), 
       (14,N'������ ��������� �������� �����',12) 
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
       (1,N'����',N'������',1,N'������������ ������������'), 
       (2,N'�������',N'������',6,N'������������ ������'), 
       (3,N'����',N'�����',7,N'��������� ������'), 
       (4,N'����',N'������',7,N'����������'), 
       (5,N'����',N'�����',7,N'����������'), 
       (6,N'�����',N'���������',8,N'��������� ������'), 
       (7,N'�������',N'�����',8,N'������� ����������'), 
       (8,N'������',N'��������',8,N'������� ����������'), 
       (9,N'��������',N'�������',9,N'������������ ������'), 
       (10,N'������',N'������',10,N'������� �����������'), 
       (11,N'�����',N'�����',10,N'�����������'), 
       (12,N'�������',N'�������',11,N'����������'), 
       (13,N'�����',N'�����',11,N'����������'), 
       (14,N'��������',N'������',2,N'������������ ������'), 
       (15,N'�����',N'�������',5,N'������� ����������'), 
       (16,N'������',N'������',5,N'����������'), 
       (17,N'����',N'������',4,N'����������'), 
       (18,N'�������',N'��������',4,N'����������'), 
       (19,N'������',N'�����',3,N'������� ����������'), 
       (20,N'��������',N'�����',3,N'������� ����������'), 
       (21,N'�����',N'�������',3,N'��������� ������'), 
       (22,N'�����',N'��������',3,N'����������'), 
       (23,N'������',N'������',12,N'������������ ������'), 
       (24,N'�����',N'��������',12,N'����������� ������������'), 
       (25,N'����',N'��������',13,N'��������� �������������'), 
       (26,N'�����',N'�����',13,N'��������� �������������'), 
       (27,N'��������',N'�����',13,N'��������� �������������'), 
       (28,N'�������',N'�����',13,N'������������ ������'), 
       (29,N'��������',N'��������',14,N'������������ ������'), 
       (30,N'����',N'�������',14,N'�������'), 
       (31,N'������',N'������',14,N'�������'), 
       (32,N'����',N'�����',14,N'������� �������'), 
       (33,N'�����',N'������',14,N'�������'), 
       (34,N'�������',N'���������',7,N'����������'), 
       (35,N'�������',N'������',7,N'����������'), 
       (36,N'�������',N'��������',7,N'������� ����������'), 
       (37,N'����',N'��������',7,N'������� ����������'), 
       (38,N'�����',N'�����',7,N'������� ����������'), 
       (39,N'�����',N'������',7,N'������� ����������'), 
       (40,N'�����',N'��������',8,N'������� ����������'), 
       (41,N'������',N'���������',8,N'������� ����������'), 
       (42,N'�����',N'������',8,N'������� ����������'), 
       (43,N'����',N'���������',8,N'����������'), 
       (44,N'������',N'���������',8,N'����������'), 
       (45,N'�����',N'������',4,N'������� ����������'), 
       (46,N'�������',N'�����',3,N'����������'), 
       (47,N'�����',N'�����',3,N'����������'), 
       (48,N'������',N'�����',10,N'�����������'), 
       (49,N'�������',N'������',14,N'�������'), 
       (50,N'������',N'��������',14,N'�������') 

Make a query, which will return all full names of departments and their employees.  
Result set should contain next columns  
Department  	Fullname of department  
JobPosition  	JobPosition of employee  
Employee  	FullName of Employee (It contains FirstName and LastName )  
  
Tip: Look for link in presentation file. You can find full information about hierarchies there...  
  
Result Set Example:  
Department  	JobPosition  	Employee  
����������� ��  	������������ ������������  	���� ������  
����������� ��\HelpDesk  	������������ ������  	������� ������  
����������� ��\HelpDesk\1-� ����� ���������  	��������� ������  	���� �����  
����������� ��\HelpDesk\1-� ����� ���������  	����������  	���� ������  
����������� ��\HelpDesk\1-� ����� ���������  	����������  	���� �����  */
  
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