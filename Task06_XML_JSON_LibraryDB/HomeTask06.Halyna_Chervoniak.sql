use AdventureWorks2019;
go
--     Subtask.05.01 	Topic: Returning Results as XML with FOR XML  
/*
Task: Get customers who made orders, number of orders and order date. 
Don't present customers without orders. 
Use Sales.Customer, Sales.SalesOrderHeader, Person.Person and FOR XML PATH. 
Expected result: 
<Customer custid="11000" name="Mary C Young"> 
     <Order orderNumber="SO43793" orderdate="2011-06-21T00:00:00" /> 
     <Order orderNumber="SO51522" orderdate="2013-06-20T00:00:00" /> 
     <Order orderNumber="SO57418" orderdate="2013-10-03T00:00:00" /> 
</Customer> 
… 
 
 
<Customer custid="11000" name="Jon V Yang"> 
  <Order orderNumber="SO43793" orderdate="2011-06-21T00:00:00" /> 
  <Order orderNumber="SO51522" orderdate="2013-06-20T00:00:00" /> 
  <Order orderNumber="SO57418" orderdate="2013-10-03T00:00:00" /> 
</Customer> 
… 
*/

select Customer.[CustomerID] AS [@custid],
      p.[FirstName] +' ' + ISNULL(p.[MiddleName],' ') +' ' + p.[LastName] AS [@Name],
      ( 
      select        [Order].[SalesOrderID] as [@orderid], 
                      [Order].OrderDate as [@orderdate]
      from  [Sales].[SalesOrderHeader] [Order] 
      WHERE [Order].CustomerID=Customer.CustomerID
      AND [Order].[ShipDate] IS NOT NULL
      ORDER BY [Order].[SalesOrderID]
      FOR XML PATH ('Order'),  TYPE
      )
FROM [Sales].[Customer] as Customer
join [Person].[Person] p on p.[BusinessEntityID]=Customer.PersonID
--WHERE [ShipDate] IS NOT NULL
--GROUP BY Customer.[CustomerID],p.[FirstName],p.[MiddleName],p.[LastName]
       
ORDER BY Customer.[CustomerID]
FOR XML PATH ('Customer'),  ROOT('Customer')


--     Subtask.05.02	Topic: Querying and Managing XML Data   
/*Task: Get set of products, price and quantity from file “Subtask03.txt”. 

Expected result: 
 */
 DECLARE @DocHandle AS INT; 
DECLARE @XmlDocument AS NVARCHAR(1000); 
SET @XmlDocument = N' 
<products>
			<product>
				<sid>64156228</sid>
				<OKPD>
					<code>25.22.11.130</code>
					<name/>
				</OKPD>
				<name>Пакет для утилизации медицинских отходов класса Б № 100 </name>
				<OKEI>
					<code>778</code>
					<nationalCode>УПАК</nationalCode>
				</OKEI>
				<price>210.50</price>
				<quantity>200</quantity>
				<sum>42100</sum>
			</product>
			<product>
				<sid>64156229</sid>
				<OKPD>
					<code>25.22.11.130</code>
					<name/>
				</OKPD>
				<name>Пакет для утилизации медицинских отходов класса А № 100</name>
				<OKEI>
					<code>778</code>
					<nationalCode>УПАК</nationalCode>
				</OKEI>
				<price>500</price>
				<quantity>90</quantity>
				<sum>45000</sum>
			</product>

-- there was commented part

		</products>'; 
-- 
EXEC sys.sp_xml_preparedocument @DocHandle OUTPUT, @XmlDocument; 
/*-- 
SELECT * 
FROM OPENXML (@DocHandle, '/products/product',1) 
 WITH (name NVARCHAR(200),price decimal (10,2),quantity  int); */
-- 
SELECT * 
FROM OPENXML (@DocHandle, '/products/product',2) 
 WITH (name NVARCHAR(200),price decimal (10,2),quantity  int); 

SELECT * 
FROM OPENXML (@DocHandle, '/products/product',11) 
 WITH (name NVARCHAR(200),price decimal (10,2),quantity  int); 

EXEC sys.sp_xml_removedocument @DocHandle; 
GO 

-- this second part of xml document doesn't work so I commented this part
/* 
			<product>
				<sid>64156230</sid>
				<OKPD>
					<code>25.22.11.130</code>
					<name/>
				</OKPD>
				<name>Пакет для утилизации медицинских отходов класса Б № 100</name>
				<OKEI>
					<code>778</code>
					<nationalCode>УПАК</nationalCode>
				</OKEI>
				<price>300</price>
				<quantity>80</quantity>
				<sum>24000</sum>
			</product>
			<product>
				<sid>64156231</sid>
				<OKPD>
					<code>25.22.11.130</code>
					<name/>
				</OKPD>
				<name>Пакет для утилизации медицинских отходов класса А № 100</name>
				<OKEI>
					<code>778</code>
					<nationalCode>УПАК</nationalCode>
				</OKEI>
				<price>226</price>
				<quantity>150</quantity>
				<sum>33900</sum>
			</product>*/


--     Subtask.05.03	Topic: Querying and Managing XML Data
/*Task: Get list of ProductName as a single line separated by commas, and a separator in alphabetical order. 
Use [Production].[Product]. 

Expected result:
'Adjustable Race', 'All-Purpose Bike Stand', 'AWC Logo Cap', 'BB Ball Bearing', 'Bearing Ball', ... 
*/

-- option 1 FOR XML PATH
SELECT TOP(1) SUBSTRING(
    (
        SELECT ',' + [Name]
        FROM [Production].[Product]
        ORDER BY [Name]
        FOR XML PATH('')), 2, 200000)
 AS ProductName
FROM [Production].[Product] t;

SELECT [Name] 
FROM [Production].[Product]
ORDER  BY [Name] ASC;

-- option 2 STRING_AGG

SELECT 
      STRING_AGG (CAST ([Name] AS NVARCHAR(MAX)),',') AS Result 
FROM [Production].[Product];

SELECT 
      STRING_AGG (CAST ([Name] AS NVARCHAR(MAX)),',')   WITHIN GROUP ( ORDER BY [Name] ASC)  AS Result FROM [Production].[Product];


--Subtask.05.04	Topic: Convert SQL Server data to JSON or export JSON
/*Task: Create a script which will return JSON based on data in  [Production].[Product]
Return following JSON for all users:
[
	{
		"ProductID":317,
		"Name":"LL Crankarm",
		"ProductNumber":"CA-5965",
		"Color":"Black",
		"SafetyStockLevel":500,
		"ReorderPoint":375,
		"Date":{
			"SellStartDate":"2008-04-30T00:00:00",
			"ModifiedDate":"2014-02-08T10:01:36.827"
			}
	}
]
*/
SELECT[ProductID]
      ,[Name]
      ,[ProductNumber]
      ,[Color]
      ,[SafetyStockLevel]
      ,[ReorderPoint]
      ,[SellStartDate] AS [Date.SellStartDate]
      ,[ModifiedDate] as [Date.ModifiedDate]
FROM [Production].[Product]
FOR JSON PATH ,INCLUDE_NULL_VALUES;


--Subtask.05.05	Topic: Extract values from JSON text and use them in queries
/*Task: Create a script which will return table dataset from following JSON

[{"UserID":1,"UserName":"Andrey Potapov","Email":"Andrey.Potapov@insidemedia.onmicrosoft.com","Flags":1,"Notes":"","Type":1,"DisplayName":"Andrey Potapov","sysinfo":{"CreatedAt":"2018-01-29T15:06:43.3300000","ChangedAt":"2018-01-29T15:06:43.3300000"}},{"UserID":2,"UserName":"Michail Kovalenko","Email":"michail.kovalenko@insidemedia.onmicrosoft.com","Flags":1,"Notes":"","Type":1,"DisplayName":"Michail Kovalenko","sysinfo":{"CreatedAt":"2018-01-29T15:06:43.3300000","ChangedAt":"2018-01-29T15:06:43.3300000"}},{"UserID":5,"UserName":"Anton Belousov","Email":"Anton.Belousov@insidemedia.onmicrosoft.com","Flags":1,"Type":1,"DisplayName":"Anton Belousov","sysinfo":{"CreatedAt":"2018-01-29T15:06:43.3300000","ChangedAt":"2018-01-29T15:06:43.3300000"}},{"UserID":6,"UserName":"Arturo Morales","Email":"Arturo.Morales@insidemedia.onmicrosoft.com","Flags":1,"Type":1,"DisplayName":"Arturo Morales","sysinfo":{"CreatedAt":"2018-01-29T15:06:43.3300000","ChangedAt":"2018-01-29T15:06:43.3300000"}},{"UserID":7,"UserName":"Bruno Silveira","Email":"bruno.silveira@groupm.com","Flags":1,"Type":1,"DisplayName":"Bruno Silveira","sysinfo":{"CreatedAt":"2018-01-29T15:06:43.3300000","ChangedAt":"2018-01-29T15:06:43.3300000"}},{"UserID":8,"UserName":"Daniel Escribano","Email":"Daniel.Escribano@insidemedia.onmicrosoft.com","Flags":1,"Type":1,"DisplayName":"Daniel Escribano","sysinfo":{"CreatedAt":"2018-01-29T15:06:43.3300000","ChangedAt":"2018-01-29T15:06:43.3300000"}},{"UserID":9,"UserName":"Dariia Vasilenko","Email":"dariia.vasilenko@insidemedia.onmicrosoft.com","Flags":1,"Type":1,"DisplayName":"Dariia Vasilenko","sysinfo":{"CreatedAt":"2018-01-29T15:06:43.3300000","ChangedAt":"2018-01-29T15:06:43.3300000"}},{"UserID":10,"UserName":"Darya Pivikova","Email":"darya.pivikova@insidemedia.onmicrosoft.com","Flags":1,"Type":1,"DisplayName":"Darya Pivikova","sysinfo":{"CreatedAt":"2018-01-29T15:06:43.3300000","ChangedAt":"2018-01-29T15:06:43.3300000"}},{"UserID":11,"UserName":"Dmitri Sedin","Email":"Dmitri.Sedin@insidemedia.onmicrosoft.com"}] 
 
Display following column 
[ID]
[UserName]
[ActualEmail]
[Email]
[Flags]
[Notes]
[Type]
[DisplayName]
[CreatedDate]
[LastModifiedDate]
*/

---Subtask.05.05 option 1
 

DECLARE @JSON NVARCHAR(MAX) = N'[
{"UserID":1,"UserName":"Andrey Potapov","Email":"Andrey.Potapov@insidemedia.onmicrosoft.com",
"Flags":1,"Notes":"","Type":1,"DisplayName":"Andrey Potapov","sysinfo":
{"CreatedAt":"2018-01-29T15:06:43.3300000","ChangedAt":"2018-01-29T15:06:43.3300000"}},
{"UserID":2,"UserName":"Michail Kovalenko","Email":"michail.kovalenko@insidemedia.onmicrosoft.com","Flags":1,
"Notes":"","Type":1,"DisplayName":"Michail Kovalenko","sysinfo":{"CreatedAt":"2018-01-29T15:06:43.3300000",
"ChangedAt":"2018-01-29T15:06:43.3300000"}},{"UserID":5,"UserName":"Anton Belousov","Email":"Anton.Belousov@insidemedia.onmicrosoft.com",
"Flags":1,"Type":1,"DisplayName":"Anton Belousov","sysinfo":{"CreatedAt":"2018-01-29T15:06:43.3300000","ChangedAt":"2018-01-29T15:06:43.3300000"}},
{"UserID":6,"UserName":"Arturo Morales","Email":"Arturo.Morales@insidemedia.onmicrosoft.com","Flags":1,"Type":1,
"DisplayName":"Arturo Morales","sysinfo":{"CreatedAt":"2018-01-29T15:06:43.3300000","ChangedAt":"2018-01-29T15:06:43.3300000"}},
{"UserID":7,"UserName":"Bruno Silveira","Email":"bruno.silveira@groupm.com","Flags":1,"Type":1,"DisplayName":"Bruno Silveira","sysinfo":
{"CreatedAt":"2018-01-29T15:06:43.3300000","ChangedAt":"2018-01-29T15:06:43.3300000"}},{"UserID":8,"UserName":"Daniel Escribano",
"Email":"Daniel.Escribano@insidemedia.onmicrosoft.com","Flags":1,"Type":1,"DisplayName":"Daniel Escribano","sysinfo"
:{"CreatedAt":"2018-01-29T15:06:43.3300000","ChangedAt":"2018-01-29T15:06:43.3300000"}},{"UserID":9,"UserName":"Dariia Vasilenko",
"Email":"dariia.vasilenko@insidemedia.onmicrosoft.com","Flags":1,"Type":1,"DisplayName":"Dariia Vasilenko","sysinfo":
{"CreatedAt":"2018-01-29T15:06:43.3300000","ChangedAt":"2018-01-29T15:06:43.3300000"}},{"UserID":10,"UserName":
"Darya Pivikova","Email":"darya.pivikova@insidemedia.onmicrosoft.com","Flags":1,"Type":1,"DisplayName":
"Darya Pivikova","sysinfo":{"CreatedAt":"2018-01-29T15:06:43.3300000","ChangedAt":"2018-01-29T15:06:43.3300000"}},
{"UserID":11,"UserName":"Dmitri Sedin","Email":"Dmitri.Sedin@insidemedia.onmicrosoft.com"}
 ]'; 
SELECT *
FROM OPENJSON(@json) 
WITH
 (
 [ID] INT '$.UserID' , 
 [UserName] NVARCHAR(20) '$.UserName', 
 [ActualEmail] NVARCHAR(MAX) '$.Email' ,
 [Email] NVARCHAR(40) '$.Email',
 [Flags] INT '$.Flags',
[Notes] NVARCHAR(20) '$.Notes',
[Type] INT '$.Type',
[DisplayName] NVARCHAR(40) '$.DisplayName',
[CreatedDate] NVARCHAR(40)'$.sysinfo.CreatedAt',
[LastModifiedDate]NVARCHAR(40)'$.sysinfo.ChangedAt'
);





