--1. How many people in the DB do not have a middle name? Show the query.

Select count(*) Total_No_With_No_MiddleName, MiddleName from Person.Person where MiddleName is null
group by MiddleName;

--2. How many email addresses do not end in adventure-works.com? Show the query.
Select count(EmailAddress) as Emails
from Person.EmailAddress
where EmailAddress  like 'adventure-works.com%'


--3. A customer has concerns with market penetration and would like
--a report on what states have the most sales between 2010-2011.
--Provide the data that the customer would find most relevant and add any additional information if required.

---4 A ticket is escalated and asks what customers got the email promotion. Please provide the information.

SELECT BusinessEntityID,FirstName,MiddleName,LastName,EmailPromotion
FROM Person.Person WHERE EmailPromotion > 0;

--5 Retrieve a list of the different types of contacts and how many of them exist in the database.
-- We are only interested in ContactTypes that have 100 contacts or more.

Select c.ContactTypeID, c.Name as ContactTypeName, COUNT(*) as No_Of_Contacts
from Person.BusinessEntityContact as bec
inner join Person.ContactType as c
on c.ContactTypeID = bec.ContactTypeID
group by c.ContactTypeID, c.Name
having count (*) >= 100
order by count (*) desc

--6 Retrieve a list of all contacts which are 'Purchasing Manager' and their names

Select p.BusinessEntityID,FirstName, ISNULL(MiddleName,'') as MiddleName,  LastName, C.Name
from Person.BusinessEntityContact AS bec
inner join Person.ContactType AS c
on c.ContactTypeID = bec.ContactTypeID
inner join Person.Person as p
on p.BusinessEntityID = bec.PersonID
where c.Name = 'Purchasing Manager'
order by LastName, FirstName, MiddleName

--7. Show OrdeQty, the Name and the ListPrice of the order made by CustomerID 635

select orderqty, name, listprice
from sales.SalesOrderDetail as sod
inner join production.product as pp
on sod.productid = pp.ProductID
inner join sales.SalesOrderHeader as soh
on sod.SalesOrderID = soh.SalesOrderID
where soh.CustomerID = 635;

----8 A "Single Item Order" is a customer order where only one item is ordered.
--Show the SalesOrderID and the UnitPrice for every Single Item Order.

select SalesOrderID, UnitPrice
from sales.SalesOrderDetail
where OrderQty = 1
order by UnitPrice asc;

--9 Where did the racing socks go? List the product name and the CompanyName
--for all Customers who ordered ProductModel 'Racing Socks'.

SELECT Pm.Name, SC.CustomerID, ST.Name
from Production.ProductModel PM
join Production.Product PP on PM.ProductModelID = PP.ProductModelID
join Sales.SalesOrderDetail SS on SS.ProductID = PP.ProductID
join Sales.SalesOrderHeader SH on SS.SalesOrderID = SH.SalesOrderID
join Sales.Store ST on SH.SalesPersonID = ST.SalesPersonID
join Sales.Customer SC
on SH.CustomerID = SC.CustomerID
where PM.Name = 'Racing Socks';

--10 How many products in ProductCategory 'Cranksets' have been sold to an address in 'London'?

select sum(orderqty) total from person.Address pa join sales.SalesOrderHeader sh on pa.AddressID = sh.BillToAddressID
join sales.SalesOrderDetail sd on sh.SalesOrderID = sd.SalesOrderID
join production.Product pp on sd.ProductID = pp.ProductID
join production.ProductSubcategory pc on pp.ProductSubcategoryID = pc.ProductSubcategoryID
where (City = 'London') and (pc.Name = 'Cranksets');

-- 11. Show the best-selling item by value.

select top 1 name, SUM(orderqty * unitprice) total_value
from Sales.SalesOrderDetail sd
join Production.Product pp on sd.ProductID = pp.ProductID
group by name
order by total_value desc;
