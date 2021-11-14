;WITH Rec
AS
(SELECT d.[DepartmentID] 
       ,d.[ParentID] 
       , d.[Name] 
       ,cast (d.[Name] as nvarchar(4000)) As DepartmentPath
       --,1 as DepaptmentPath
FROM [Depts].[Departments] d
--JOIN [Depts].[Employees] e ON e.[DepartmentID]=d.[DepartmentID]
WHERE d.[ParentID] IS NULL
UNION ALL
SELECT m.[DepartmentID]
      ,m.[ParentID]
      ,m.[Name] 
      ,v.DepartmentPath +  '/'+ (cast (m.[Name] as nvarchar(4000)) )
FROM [Depts].[Departments] m 
  JOIN Rec  v ON v.[DepartmentID]<>m.[DepartmentID]
) 
select  * 
FROM Rec t --option (maxrecursion 100)
/*
SELECT [DepartmentPath] AS Department
    ,e.[JobPosition]
    ,e.[FirstName]+e.[LastName] as [Employee]
FROM Rec t
join [Depts].[Employees] e on e.[DepartmentID]=t.DepartmentId*/