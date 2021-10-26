--to get a set of persons which have “an” in their First Name and their Middle Name starts with “B”. 

SELECT [FirstName] +' ' + [MiddleName] + ' ' + [LastName] AS [FullName]
 FROM [Person].[Person] AS P
 WHERE P.[FirstName] LIKE '%an%'
   AND P.[MiddleName] LIKE 'B%'