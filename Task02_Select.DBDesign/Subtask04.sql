--script to get a set of persons modified in 2009 without Middle Name
SELECT P.[BusinessEntityID]
      ,P.[FirstName]
      ,P.[MiddleName]
      ,P.[ModifiedDate]
 FROM [Person].[Person] AS P
 WHERE YEAR(P.[ModifiedDate]) = 2009 
   AND P.[MiddleName] IS NULL