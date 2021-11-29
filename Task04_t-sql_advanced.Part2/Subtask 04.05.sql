/*SELECT *
FROM [Depts].[Departments]

SELECT *
FROM [Depts].[Employees]*/
;WITH Rec
AS
(SELECT d.[Name] AS [Department]
       ,e.[JobPosition] AS [JobPosition]
       ,e.[EmployeeID] AS [EmployeeID]
       ,e.[FirstName]+ ' '+ e.[LastName] AS [Employee]
FROM [Depts].[Departments] d
JOIN [Depts].[Employees] e ON e.[DepartmentID]=d.[DepartmentID]
UNION ALL
SELECT v.[Department]
      ,v.[JobPosition] 
      ,v.[EmployeeID]
      ,v.[Employee]
FROM Rec  v
JOIN [Depts].[Departments] m ON v.[EmployeeID]=m.[ParentID])

SELECT [Department],[JobPosition],[Employee]
FROM Rec