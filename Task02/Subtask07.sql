--Create T-SQL script to get set of Employees [HumanResources].[Employee] contained: · Full name - [FullName] ·
--Number of years old - [YearsOld]
--Number of years before retirement (according to Russian Federation laws) - [YearsBeforeRetirement]
--Use simple 60 for man and 55 for woman · Mark if the person overcome retirement age (Yes or No) -
--[OvercomeRetirementAge] Order the list by full name of employees


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
 ORDER BY m.[FullName]
