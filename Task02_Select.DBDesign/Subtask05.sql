--script to get a set of persons modified in April, 2014
SELECT [FirstName] +' ' + [MiddleName] + ' ' + [LastName] AS [FullName]
 FROM [Person].[Person] AS P
 WHERE YEAR(P.[ModifiedDate]) = 2014 
   AND MONTH(P.[ModifiedDate]) = 4
   AND P.[MiddleName] IS NOT NULL