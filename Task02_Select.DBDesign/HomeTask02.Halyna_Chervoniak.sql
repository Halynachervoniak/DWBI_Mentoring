use AdventureWorks2019;
go
--     Subtask.03               -------------------
/*Create T-SQL script to get a set of products with [ProductID], [Name] from [Production].[Product] table for which color is not equal Silver */
SELECT p.[ProductID]
      ,p.[Name]
 FROM [Production].[Product] AS p
 WHERE p.[Color] <> 'Silver'

SELECT p.[ProductID]
      ,p.[Name]
 FROM [Production].[Product]  AS p
 WHERE p.[Color] NOT IN ('Silver')

--     Subtask.04               -------------------
/*Create T-SQL script to get a set of persons modified in 2009 without Middle Name from [Person].[Person] table. 
Show only BusinessEntityID, [FirstName],[MiddleName],[LastName] and modified date. 
*/
SELECT P.[BusinessEntityID]
      ,P.[FirstName]
      ,P.[MiddleName]
      ,P.[ModifiedDate]
 FROM [Person].[Person] AS P
 WHERE YEAR(P.[ModifiedDate]) = 2009 
   AND P.[MiddleName] IS NULL;

--     Subtask.05               -------------------
/*Create T-SQL script to get a set of persons modified in April, 2014 from [Person].[Person] table. 
Show full name combined using [FirstName],[MiddleName],[LastName] 
*/
SELECT [FirstName] +' ' + [MiddleName] + ' ' + [LastName] AS [FullName]
 FROM [Person].[Person] AS P
 WHERE YEAR(P.[ModifiedDate]) = 2014 
   AND MONTH(P.[ModifiedDate]) = 4
   AND P.[MiddleName] IS NOT NULL;

--     Subtask.06               -------------------
/*Create T-SQL script to get a set of persons which have “an” in their First Name and their Middle Name starts with “B”. 
Show full name combined using [FirstName],[MiddleName],[LastName] 
*/
SELECT [FirstName] +' ' + [MiddleName] + ' ' + [LastName] AS [FullName]
 FROM [Person].[Person] AS P
 WHERE P.[FirstName] LIKE '%an%'
   AND P.[MiddleName] LIKE 'B%';

--     Subtask.07               -------------------
/*Create T-SQL script to get set of Employees [HumanResources].[Employee] contained: 
•	Full name - [FullName] 
•	Number of years old - [YearsOld] 
•	Number of years before retirement (according to Russian Federation laws) - [YearsBeforeRetirement] Use simple 60 for man and 55 for woman  
•	Mark if the person overcome retirement age (Yes or No) - [OvercomeRetirementAge] 
Order the list by full name of employees 
*/
WITH cte 
as (
SELECT ISNULL(P.[FirstName],' ') +' ' + ISNULL(P.[MiddleName],' ') + ' ' + ISNULL(P.[LastName],' ') AS [FullName]
      , DATEDIFF(year,[BirthDate],GETDATE()) AS [YearsOld1]--?
      , (DATEDIFF(month,[BirthDate],GETDATE()))/12  AS [YearsOld]--? why whole number
      , [BirthDate] AS [BirthDate]
      , GETDATE() AS [CurrentDate]
      , CASE 
            WHEN Gender ='M' THEN (60-(DATEDIFF(month,[BirthDate],GETDATE()))/12)
            WHEN Gender ='F' THEN (55-(DATEDIFF(month,[BirthDate],GETDATE()))/12)
            END AS [YearsBeforeRetirement]
 FROM [HumanResources].[Employee] AS E
 JOIN [Person].[Person] AS P
   ON E.[BusinessEntityID]=P.[BusinessEntityID])

 SELECT m.[FullName]
      , m.[YearsOld]
      , m.[YearsBeforeRetirement]
      , CASE
         WHEN m.[YearsBeforeRetirement] < 0 THEN 'Yes'
         WHEN m.[YearsBeforeRetirement] > 0 THEN 'No'
         END AS [OvercomeRetirementAge]
  FROM cte m
 ORDER BY m.[FullName];