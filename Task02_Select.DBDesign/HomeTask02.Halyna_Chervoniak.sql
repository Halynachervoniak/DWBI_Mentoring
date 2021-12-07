USE AdventureWorks2019;
GO
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
      ,P.[LastName]
      ,P.[MiddleName]
      ,P.[ModifiedDate]
 FROM [Person].[Person] AS P
 WHERE P.[ModifiedDate] BETWEEN '2014-01-01' AND '2014-12-31' 
   AND P.[MiddleName] IS NULL;

--     Subtask.05               -------------------
/*Create T-SQL script to get a set of persons modified in April, 2014 from [Person].[Person] table. 
Show full name combined using [FirstName],[MiddleName],[LastName] 
*/
SELECT [FirstName] +' ' + ISNULL([MiddleName], ' ') + ' ' + [LastName] AS [FullName]
 FROM [Person].[Person] AS P
 WHERE P.[ModifiedDate] BETWEEN '2014-04-01' AND '2014-04-30';

--     Subtask.06               -------------------
/*Create T-SQL script to get a set of persons which have “an” in their First Name and their Middle Name starts with “B”. 
Show full name combined using [FirstName],[MiddleName],[LastName] 
*/
SELECT [FirstName] +' ' + ISNULL([MiddleName], ' ') + ' ' + [LastName] AS [FullName]
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
declare @d date = '2021-09-10',-- getdate(), 
        @d1 date;

;WITH cte 
AS (
     SELECT [FirstName] +' ' + ISNULL([MiddleName], ' ') + ' ' + [LastName] AS [FullName]
           , (DATEDIFF(month,[BirthDate],@d))/12.00  AS [YearsOld_old]  -- ?
           --,year(@d) - year([BirthDate]) as DifY
           ,datediff(year, [BirthDate], @d)
                - case when datefromparts(year(@d), month(BirthDate), day(BirthDate) + case when (month(BirthDate) = 2 and day(BirthDate) = 29) then -1 else 0 end) > @d then 1 else 0 end as YearsOld
           , [BirthDate] AS [BirthDate]
           ,Gender
           , @d AS [CurrentDate]
      FROM [HumanResources].[Employee] AS E
        JOIN [Person].[Person] AS P   ON E.[BusinessEntityID] = P.[BusinessEntityID] --where FirstName = 'Betsy'
        ),
cte_b as (
SELECT m.[FullName]
      , m.[YearsOld]
      , case m.Gender when 'M' then 60 
                      when 'F' then 55 
                      else null end  - m.YearsOld as YearsBeforeRetirement
FROM cte m
)
select 
    FullName,
    YearsOld,
    YearsBeforeRetirement,
    case when YearsBeforeRetirement < 0 then 'Yes' else 'No' end as OvercomeRetirementAge
from cte_b
ORDER BY [FullName];

 -- Betsy A Stadick	55.000000	1966-12-17	0	NULL
 ------------------------------------------------------
declare @y date = '2020-02-29';  -- leap year
declare  @y1 date = datefromparts(year(getdate()), month(@y), day(@y));
select @y, @y1