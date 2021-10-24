--script to get a set of products
SELECT p.[ProductID]
      ,p.[Name]
 FROM [Production].[Product] AS p
 WHERE p.[Color] <> 'Silver'

SELECT p.[ProductID]
      ,p.[Name]
 FROM [Production].[Product]  AS p
 WHERE p.[Color] NOT IN ('Silver')