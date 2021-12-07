USE AdventureWorks2019;
Go

-- Subtask.03.02. Topic: Using Set Operators 
/*Task: Get the list of employees of Adventure Works who are still in the job candidate table, in other words - get the list of employees who are in both table 
(HumanResources.Employee, HumanResources.JobCandidate) at the same time. You MUST use set operators here Get following columns: [FullName] - 
combined from FirstName, MiddleName and LastName of employee [JobTitle] - job title of employee
*/
SELECT [FirstName] + ' ' + ISNULL([MiddleName],' ') + ' ' + [LastName] AS [FullName]
     , E.[JobTitle]
FROM [Person].[Person] P
JOIN [HumanResources].[Employee] E        ON E.[BusinessEntityID] = P.[BusinessEntityID]
 WHERE E.[BusinessEntityID] IN
        (
         SELECT [BusinessEntityID]
         FROM [HumanResources].[Employee]
         INTERSECT
         SELECT [BusinessEntityID]
         FROM [HumanResources].[JobCandidate]
         );

-- Subtask.03.03. Topic: Using joins 
/*Task: Get the list of employees of Adventure Works who are still in the job candidate table, in other words - get the list of employees who are in both table 
(HumanResources.Employee, HumanResources.JobCandidate) at the same time. You MUST use join operators here Get following columns: [FullName] - 
combined from FirstName, MiddleName and LastName of employee [JobTitle] - job title of employee
*/
SELECT [FirstName] + ' ' + ISNULL([MiddleName],' ') + ' ' + [LastName] AS [FullName]
     , E.[JobTitle]
FROM [Person].[Person] P
    JOIN [HumanResources].[Employee] E        ON E.[BusinessEntityID] = P.[BusinessEntityID]
    JOIN [HumanResources].[JobCandidate] J    ON J.[BusinessEntityID] = E.[BusinessEntityID];

-- Subtask.03.04. Topic: Using joins 
/*Task: Get the list of bikes which have been bought by "Vista" cardholders. 
Get unique values for the following columns: · Product – name of the bike · Сolor - color of the bike
*/
SELECT DISTINCT P.[Name]
              , P.[Color]
FROM [Production].[Product] P
    JOIN [Sales].[SalesOrderDetail] OD      ON OD.[ProductID]=P.[ProductID]
    JOIN [Sales].[SalesOrderHeader] OH      ON OH.[SalesOrderID]=OD.[SalesOrderID]
    JOIN [Sales].[PersonCreditCard] PC      ON PC.[CreditCardID]=OH.[CreditCardID]
    JOIN [Sales].[CreditCard] C             ON C.[CreditCardID]=PC.[CreditCardID]
    JOIN [Production].[ProductSubcategory] SC ON SC.[ProductSubcategoryID]=P.[ProductSubcategoryID]
WHERE [CardType]='Vista' AND [ProductCategoryID]=1;

-- Subtask.03.05 Topic: Sorting data 
/*Task: Get list of all people whose first name starts with 'Z' and for each of them get list of namesakes (person bearing the same last name). 
Display the following columns: · 
    ID · Full Name
    ID of namesake · 
    Full Name of namesake 
Order you result set by last name of the original persons
*/
SELECT p.[BusinessEntityID] AS [ID]
      ,p.[LastName] AS [LastName]
     ,p.[FirstName] AS [FirstName]
      ,p.[FirstName] + ' ' + p.[LastName] AS [FullName]
FROM [Person].[Person] P
INNER JOIN [Person].[Person] P2 ON P2.[BusinessEntityID]=P.[BusinessEntityID]  --???
AND p.[FirstName] like 'Z%'
ORDER BY [FullName]

---------------------------------------------------------------------------------------------------------------------------------
SELECT [p].[BusinessEntityID] AS [id]
		,(p.[FirstName] + isnull(' ' + p.MiddleName + ' ', ' ') +p.[LastName])  AS [fullname]
		,p2.[BusinessEntityID] AS [ID of namesake] 
		,(p2.[FirstName] + isnull(' ' + p2.MiddleName + ' ', ' ') +p2.[LastName])  AS [fullname]
FROM [Person].[Person] p
	 LEFT JOIN person.[Person] p2 
		ON p.[LastName] = [p2].[LastName] AND [p].[BusinessEntityID]<>p2.[BusinessEntityID] ----filter out same persons in both parts
WHERE p.[FirstName] LIKE 'z%' 
ORDER BY p.[LastName];
---------------------------------------------------------------------------------------------------------------------------------

select q.Id
, q.FullName
    ,string_agg(q.IdOfNamesake, ';') WITHIN GROUP (ORDER BY q.FullNameOfNamesake asc) as IDsOfNamesake
    ,string_agg(q.FullNameOfNamesake, ';') WITHIN GROUP (ORDER BY q.FullNameOfNamesake asc)as FullNamesOfNamesake 
from (
SELECT [p].[BusinessEntityID] AS Id
        ,p.LastName
		,(p.[FirstName] +isnull(' ' + p.MiddleName + ' ', ' ') + p.[LastName])  AS FullName
		,p2.[BusinessEntityID] AS IdOfNamesake
		,(p2.[FirstName] +isnull(' ' + p2.MiddleName + ' ', ' ') + p2.[LastName])  AS FullNameOfNamesake
FROM [Person].[Person] p
	 LEFT JOIN person.[Person] p2 
		ON p.[LastName] = [p2].[LastName] AND [p].[BusinessEntityID]<>p2.[BusinessEntityID] ----filter out same persons in both parts
WHERE p.[FirstName] LIKE 'z%' ) q
group by q.Id, q.[LastName], FullName
ORDER BY q.[LastName];
---------------------------------------------------------------------------------------------------------------------------------

--Subtask.03.06 Topic: SARG 
/*Task: Find shipped orders with order date fitted the timeline for a specified date: 
· from first day of the same month of the previous year for the date- to last day of previous month of current year for the date (included). 
Your script should start with definition of the date: DECLARE @Date DATETIME = '2013-09-30 00:00:00.000'. 
Display the following columns: 
    · SalesOrderID 
    · Name of sale territory 
    · City where order was shipped to 
    · Order date 
Analyze data and pickup approportionate date 
Create a query for CURRENT And for approportionate date
*/
DECLARE @Date DATETIME = '2013-09-30 00:00:00.000'
DECLARE @FirstDayOfCurrentMonth DATETIME = DATEADD(D,-DAY(dateadd(yy,-1,@Date)-1),dateadd(yy,-1,@Date))
DECLARE @LastDayOfPriorMonth DATETIME = dateadd(day,-day(@Date),@Date)

--PRINT @FirstDayOfCurrentMonth
--PRINT @LastDayOfPriorMonth

SELECT H.[SalesOrderID]
     , T.[Name] As [NameSaleTerritory]
     , H.[OrderDate]
     , A.City
FROM [Sales].[SalesOrderHeader] H
    JOIN [Sales].[SalesTerritory] T               ON T.TerritoryID=H.TerritoryID
    JOIN [Sales].[SalesPerson] SP                 ON SP.TerritoryID=T.TerritoryID
    JOIN [Person].[BusinessEntityAddress] BE      ON BE.BusinessEntityID=SP.[BusinessEntityID]
    JOIN [Person].[Address] A                     ON A.AddressID=BE.AddressID
WHERE [OrderDate] >=@FirstDayOfCurrentMonth AND [OrderDate]<=@LastDayOfPriorMonth;

--Subtask.03.07 Topic: Filtering Data with OFFSET-FETCH 
/*Task: The company is going to give prizes to customers who made the most valuable orders in 2014. It has already been done for top 3 orders. 
Now you should find customer orders with places 4-10 in the rating ordered by total due. 
Display the following columns: 
    · Customer ID 
    · Full name of the customer 
    · Order date 
    · Total due of the order
*/
SELECT C.[CustomerID]
        ,[TotalDue]
FROM [Sales].[Customer] C
    JOIN [Sales].[SalesOrderHeader] H    ON H.[CustomerID]=C.[CustomerID]
    JOIN [Sales].[SalesPerson] SP        ON SP.[TerritoryID]=H.[TerritoryID]  
    JOIN [Person].[Person] P             ON  P.[BusinessEntityID]=SP.[BusinessEntityID]  
WHERE H.[OrderDate] BETWEEN '2014-01-01' AND '2014-12-31'
ORDER BY [TotalDue] DESC
--OFFSET 3 ROWS FETCH NEXT 7 ROWS ONLY;

-------------------------------------------------------
SELECT h.[CustomerID]
       ,p.FirstName + isnull(' ' + p.MiddleName, '') + p.LastName as fullName
       ,h.OrderDate
        ,h.[TotalDue]
FROM [Sales].[SalesOrderHeader] H  
    JOIN  [Sales].[Customer] C  ON H.[CustomerID]=C.[CustomerID]
    JOIN [Person].[Person] P    ON  P.[BusinessEntityID]=c.PersonID
WHERE H.[OrderDate] BETWEEN '2014-01-01' AND '2014-12-31'
ORDER BY [TotalDue] DESC
--OFFSET 3 ROWS FETCH NEXT 7 ROWS ONLY