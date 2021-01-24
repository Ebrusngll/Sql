--1.	Stoğu 20 den fazla olan siparişlerimin hangi kargo şirketleriyle teslim edildiğini listeleyiniz
--Stoğu 20 den fazla olan siparişlerimin hangi kargo şirketleriyle teslim edildiğini listeleyiniz
select 
	s.CompanyName,
	o.OrderID,
	UnitsInStock
from Products p 
join [Order Details] od on od.ProductID=p.ProductID
join Orders o on od.OrderID=o.OrderID
join Shippers s on o.ShipVia=s.ShipperID
where UnitsInStock>20
--2.	Federal Shipping ile taşınmış ve Nancy'nin almış olduğu siparişleri gösteriniz
select 
	OrderID,
	e.FirstName,
	CompanyName
from Shippers s 
join Orders o on o.ShipVia=s.ShipperID
join Employees e on o.EmployeeID=e.EmployeeID
where s.CompanyName='Federal Shipping' and e.FirstName='Nancy'
--3.	Web sayfası olan tedarikçilerimden hangi ürünleri tedarik ediyorum?
select
	ProductName,
	CompanyName
from Products p 
join Suppliers s on p.SupplierID=s.SupplierID
where s.HomePage is not null
--4.	Doğu konumundaki bölgeleri listeleyin
select
	TerritoryDescription
from Region r 
join Territories t on t.RegionID=r.RegionID
where RegionDescription='Eastern'
--5.	Adet olarak en çok sipariş verilen ürünümün adını getiriniz
select top 1
	P.ProductName,
	sum(Quantity)
from Products p
join [Order Details] od on od.ProductID=p.ProductID
group by p.ProductName
order by sum(Quantity) desc
--6.	Tedarik şehri Londra olan, kargo şirketinin 4. harfi e olan stoğumda bulunan ve birim fiyatı 30 - 60 arasında olan siparişlerim nelerdir? 
select 
	o.OrderID,
	su.City,
	s.CompanyName
from Suppliers su 
join Products p on p.SupplierID=p.ProductID
join [Order Details] od on od.ProductID=p.ProductID
join Orders o on od.OrderID=o.OrderID
join Shippers s on o.ShipVia=s.ShipperID
where su.City='London' and s.CompanyName like '___e%' and UnitsInStock<>0 and p.UnitPrice between 30 and 60
--7.	 Şehri Tacoma olan çalışanlarımın aldığı siparişleri listeleyiniz
select 
	e.FirstName,e.LastName,e.City,o.OrderID
from Employees e 
join Orders o on o.EmployeeID=e.EmployeeID
where e.City='Tacoma'
--8.	 Satışı durdurulmuş ve aynı zamanda stoğu kalmamış ürünlerimin tedarikçilerinin isimlerini ve telefon numaralarını listeleyiniz.
select
	s.CompanyName,
	p.ProductName,
	p.UnitsInStock
from Products p
join Suppliers s on p.SupplierID=s.SupplierID
where Discontinued=1 and UnitsInStock=0
--9.	 New York şehrinden sorumlu çalışan(lar)ım kim?
select distinct
	FirstName,
	LastName,
	TerritoryDescription
from Employees e
join EmployeeTerritories et on e.EmployeeID=et.EmployeeID
join Territories t on et.TerritoryID=t.TerritoryID
where TerritoryDescription='New york'
--10.	 1 Ocak 1998 tarihinden sonra sipariş veren müşterilerimin isimlerini artan olarak sıralayınız.
select 
	CompanyName,OrderID,OrderDate
from Orders
join Customers on orders.CustomerID=Customers.CustomerID
where OrderDate>'1998.01.01'
order by CompanyName
--11.	 CHAI ürününü hangi müşterilere satmışım?
select 
	ProductName,
	c.CompanyName
from Products p 
join [Order Details] od on p.ProductID=od.ProductID
join orders o on od.OrderID=o.OrderID
join Customers c on o.CustomerID=c.CustomerID
where ProductName='Chai'
--12.	 10248 ID'li siparişimle hangi çalışanım ilgilenmiştir?
select 
	o.OrderID,
	e.FirstName
from Employees e
join Orders o  on o.EmployeeID=e.EmployeeID
where OrderID='10248'
--13.	 Şişede satılan ürünlerimi sipariş ile gönderdiğim ülkeler hangileridir? (QuantityPerUnit alanı)
select 
	ProductName,
	ShipCountry
from Products p
join [Order Details] od on od.ProductID=p.ProductID
join Orders o on od.OrderID=o.OrderID
where QuantityPerUnit like '%bottle%'
--14.	 Ağustos ayında teslim edilen siparişlerimdeki ürünlerden kategorisi içecek(kategori ismi içecek değil açıklamasında yazabilir.) olanların, ürün isimlerini, teslim tarihini ve hangi şehre teslim edildiğini kargo ücretine göre ters sıralı şekilde listeleyiniz.
select
	ProductName,
	RequiredDate,
	ShipCity
from Products p
join Categories c on p.CategoryID=c.CategoryID
join [Order Details] od on od.ProductID=p.ProductID
join Orders o on od.OrderID=o.OrderID
join Shippers s on o.ShipVia=s.ShipperID
where DATEPART(MONTH,RequiredDate)=8 and c.Description like '%drinks%'
order by Freight desc
--15.	 Meksikalı müşterilerimden şirket sahibi ile iletişime geçtiğim, kargo ücreti 30 doların altında olan siparişlerle hangi çalışanlarım ilgilenmiştir?
select 
	FirstName,
	LastName
from Customers c
join Orders o  on o.CustomerID=c.CustomerID
join Employees e on o.EmployeeID=e.EmployeeID
where c.Country='Mexico' and c.ContactTitle='Owner' and Freight<30
--16.	 Seafood ürünlerinden sipariş gönderdiğim müşterilerim kimlerdir?
select distinct
	CompanyName
from Products p
join [Order Details] od on od.ProductID=p.ProductID
join Orders o on od.OrderID=o.OrderID
join Customers c on o.CustomerID=c.CustomerID
join Categories ca on p.CategoryID=ca.CategoryID
where ca.CategoryName='Seafood'
--17.	 Kadın çalışanlarımın ilgilendiği siparişlerin, gönderildiği müşterilerimden iletişime geçtiğim kişilerin isimleri ve şehirleri nelerdir?
select 
	ContactName,
	c.City
from Employees e 
join Orders o on o.EmployeeID=e.EmployeeID
join Customers c on o.CustomerID=c.CustomerID
where TitleOfCourtesy in ('mrs.','ms.')
--18.	 250den fazla sipariş taşımış olan kargo firmalarının adlarını, telefon numaralarını ve taşıdıkları sipariş sayılarını getiren sorguyu yazınız.
select 
	s.CompanyName, 
	s.Phone, 
	count(OrderID) SiparisSayisi 
from Orders o
inner join Shippers s on o.ShipVia = s.ShipperID
group by s.CompanyName, s.Phone
having count(OrderID) > 250
--19.	 Kategori adı Confections olan ürünlerin hangi ülkelere fiyat olarak toplam ne kadar gönderdik?
select 
	o.ShipCountry, 
	sum(Freight) fiyat 
from Products p
inner join [Order Details] od on od.ProductID = p.ProductID
inner join Orders o on o.OrderID = od.OrderID 
inner join Categories c on p.CategoryID = c.CategoryID
where c.CategoryName = 'Confections'
group by o.ShipCountry
--20.	 Hangi tedarikçiden hangi ürünü kaç adet temin ettiğimizi listeleyin
select 
	s.CompanyName,
	p.ProductName,
	sum(unitsInStock) + SUM(UnitsOnOrder)
from Products p
join Suppliers s on p.SupplierID = s.SupplierID
group by s.CompanyName, p.ProductName
order by s.CompanyName
--21.	 'Nancy' adındaki personelim hangi firmaya toplam kaç adet ürün satılmıştır listeleyiniz.
select
	c.CompanyName,
	sum(od.Quantity) ürünAdet
from Employees e
join Orders o on o.EmployeeID = e.EmployeeID
join Customers c on c.CustomerID = o.CustomerID
join [Order Details] od on od.OrderID = o.OrderID
where e.FirstName = 'Nancy'
group by c.CompanyName
--22.	 Batı bölgesinden sorumlu çalışanlara ait müşteri sayısı bilgisini getirin.
select
	E.FirstName + ' ' + E.LastName calisan,
	COUNT(c.CustomerID) MüsteriSayisi
from Customers c
join Orders o on o.CustomerID = c.CustomerID
join Employees e on e.EmployeeID = o.EmployeeID
join EmployeeTerritories et on et.EmployeeID = e.EmployeeID
join Territories t on t.TerritoryID = et.TerritoryID
join Region r on r.RegionID = t.RegionID
where r.RegionDescription = 'Western'
group by E.FirstName + ' ' + E.LastName 
--23.	 Hangi personelin toplam kaç siparişi zamanında müşteriye teslim edilmemiştir
select 
	E.FirstName + ' ' + E.LastName çalısan,
	COUNT(OrderID) GecikenSiparişSayisi
from Orders o
join Employees e on e.EmployeeID = o.EmployeeID
where RequiredDate < ShippedDate
group by E.FirstName + ' ' + E.LastName
--24.	 10 ID li üründen toplam ne kadar ciro elde etmişim
select 
	SUM(UnitPrice * Quantity * (1 - Discount)) ciro
from [Order Details] 
where ProductID = 10
--25.	 Her bir ürün için toplam kaç kez sipariş verilmiştir listeleyiniz.
select 
	P.ProductName,
	COUNT(OrderID) SiparişSayisi
from [Order Details] od
join Products p on od.ProductID = p.ProductID
group by p.productName
--26.	 Her bir ürün için ortalama talep sayısı. (ortalama sipariş adeti > ProductID, ProductName, Adet) (toplam Satılan adet miktarı / toplam sipariş sayısı)
select 
	P.ProductID,
	P.ProductName,
	SUM(OD.Quantity) / count(OrderID) OrtalamaTalep
from [Order Details] od
join Products p on od.ProductID = p.ProductID
group by p.productName, p.ProductID
--27.	 En değerli müşterim kim? (Bana en çok para kazandıran)
select top 1 
	c.CompanyName, 
	sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) ciro 
from [Order Details] od
inner join Orders o on od.OrderID = o.OrderID
inner join Customers c on c.CustomerID = o.CustomerID
group by c.CompanyName
order by ciro desc
--28.	 10000den fazla ciro elde ettiğim müşterilerim (Premium Müşteriler)
select c.CompanyName, sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) ciro from [Order Details] od
inner join Orders o on od.OrderID = o.OrderID
inner join Customers c on c.CustomerID = o.CustomerID
group by c.CompanyName
having sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) > 10000
--29.	 -Müşterilerimin yıllık toplam sipariş sayısı. Aşağıdaki gibi görünsün
-- BilgeAdam 1997 14       - bu şekilde grupla
-- BilgeAdam 1998 25
select 
	c.CompanyName, 
	year(o.OrderDate) Yıl, 
	count(OrderID) Adet from Orders o
inner join Customers c on o.CustomerID = c.CustomerID
group by CompanyName, year(o.OrderDate)

--30.	Region tablosundaki bölge bilgilerine göre kaç çalışanım var
select r.RegionDescription Bölge, count(e.EmployeeID) ÇalışanSayısı from Employees e
inner join EmployeeTerritories et on et.EmployeeID = e.EmployeeID
inner join Territories t on t.TerritoryID = et.TerritoryID
inner join Region r on r.RegionID = t.RegionID
group by r.RegionDescription
--31.	 Çalışanlarım hangi kargo şirketi ile toplam kaç SİPARİŞ göndermiştir.
select e.FirstName + ' ' + e.LastName Çalışan, s.CompanyName, count(OrderID) Adet from orders o
inner join Employees e on o.EmployeeID = e.EmployeeID
inner join Shippers s on s.ShipperID = o.ShipVia
group by e.FirstName + ' ' + e.LastName, s.CompanyName
order by Adet desc
--32.	 En çok hangi kargo şirketi ile gönderilen SİPARİŞLERDE gecikme olmuştur. Şirketin adı ve kaç tane sipariş gecikmeli gitmiş listeleyiniz
select top 1 s.CompanyName, count(OrderID) GecikenÜrünSayısı from Orders o
inner join Shippers s on o.ShipVia = s.ShipperID
where o.RequiredDate < o.ShippedDate
group by s.CompanyName
order by GecikenÜrünSayısı desc
--33.	 Tedarikçilerimden aldığım ürünlerimden toplam stok miktarı 150 ten fazla olanlar hangi ülkelerden listeleyiniz
select s.Country, s.CompanyName, sum(UnitsInStock) from Products p
inner join Suppliers s on p.SupplierID = s.SupplierID
group by s.Country, s.CompanyName
having sum(UnitsInStock) > 150
order by s.Country
--34.	 Kategorilerine göre, her bir kategori için ortalama ürün fiyatlarını bulunuz, Sadece birim fiyatı 10 dan büyük olan ürünleri ortalama hesabına dahil edin.
select 
	c.CategoryName, 
	avg(UnitPrice) Ortalama 
from Categories c
inner join Products p on c.CategoryID = p.CategoryID
where UnitPrice > 10
group by c.CategoryName
--35.	 Londra'da yaşayan personellerim bana ne kadar kazandırmış.
select 
	e.FirstName + ' ' + e.LastName, 
	sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) 
from Orders o
inner join Employees e on o.EmployeeID = e.EmployeeID
inner join [Order Details] od on od.OrderID = o.OrderID
where e.City = 'London'
group by e.FirstName + ' ' + e.LastName
--36.	 Çalışanlarım kaç bölgeden sorumlu_? En çok bölgeden(T) sorumlu olan çalışanım hangisi?
select  
	e.FirstName + ' ' + e.LastName Çalışan, 
	count(t.TerritoryID) BölgeSayısı 
from Employees e
inner join EmployeeTerritories et on et.EmployeeID = e.EmployeeID
inner join Territories t on t.TerritoryID = et.TerritoryID
group by e.FirstName + ' ' + e.LastName
order by BölgeSayısı desc
--37.	Şehir bazında satışlarım nasıl? (şehirlere kaç adet satış yapmışım)
select 
	city, 
	count(OrderID) SatışSayısı 
from orders o 
inner join Customers c on o.CustomerID = c.CustomerID
group by c.City
--38.	 Almanya ya Federal Shipping ile kargolanmış siparişlerimi onaylayan çalışanlarım ve bu çalışanlarımın hangi bölgede olduklarını listeleyiniz
select distinct
	FirstName + ' ' + LastName as İsimSoyisim,
	r.RegionDescription
from Region as r 
join Territories as t on r.RegionID=t.RegionID
join EmployeeTerritories as et on t.TerritoryID=et.TerritoryID
join Employees as e on e.EmployeeID=et.EmployeeID
join Orders as o on e.EmployeeID=o.EmployeeID
join Shippers as s on s.ShipperID=o.ShipVia 
where ShipCountry='Germany' and s.CompanyName='Federal Shipping'
--39.	 Condiments kategorisinde en pahalı 10 ürünü ProductID, ürün adı, tedarikçi adı şeklinde listelenen bir view oluşturunuz bu view ı kullanarak bu ürünlerimi hangi çalışanlarım onaylamış bulunuz
CREATE VIEW EnPahaliUrun
AS
SELECT TOP 10
	P.ProductID,
	P.ProductName,
	S.CompanyName
FROM 
Products P
INNER JOIN Categories C ON P.CategoryID = C.CategoryID
INNER JOIN Suppliers S ON P.SupplierID = S.SupplierID
WHERE C.CategoryName = 'Condiments'
ORDER BY p.ProductName DESC
--------------------------------------
SELECT E.FirstName, E.LastName, EN.ProductName, EN.CompanyName FROM EnPahaliUrun EN
JOIN [Order Details] OD ON OD.ProductID = EN.ProductID
JOIN Orders O ON O.OrderID = OD.OrderID
JOIN Employees E ON E.EmployeeID = O.EmployeeID
--40.	 Fedaral Shipping Şirketi ile gönderdiğim siparişlerimi listeleyen bir view oluşturunuz. Bu viewı kullanarak bu siparişleri hangi müşterilerime yollamışım listeleyiniz
Create VIEW FedaralShippingSiparisleri
AS
select OrderID, CustomerID from Orders o
inner join Shippers s on o.ShipVia = s.ShipperID
where s.CompanyName = 'Federal Shipping'


SELECT distinct C.CompanyName FROM FedaralShippingSiparisleri FS
JOIN Customers C ON FS.CustomerID = C.CustomerID
--41.	Batı bölgesinden sorumlu olan çalışanlarımın onayladığı siparişlerimi view olarak kaydediniz. Ürünlerimin tedarikçilerini listeleyen bir view oluşturunuz. Bu viewleri kullanarak batı bölgesinden sorumlu olan çalışanlarımın onayladığı siparişlerimin tedarikçi bilgilerini listeleyiniz
CREATE VIEW BatiBolgesiSorumlu
As
select distinct e.EmployeeID CalisanId, e.FirstName + ' ' + e.LastName [AdSoyad] from Employees e
join EmployeeTerritories et on et.EmployeeID = e.EmployeeID
join Territories t on t.TerritoryID = et.TerritoryID
join Region r on r.RegionID = t.RegionID
where r.RegionDescription = 'Western'

CREATE VIEW UrunTedarikci
AS
select p.ProductID UrunID, s.SupplierID TedarikciID, p.ProductName Urun, s.CompanyName Tedarikci from Products p
join Suppliers s on p.SupplierID = s.SupplierID

drop view UrunTedarikci

select distinct bs.AdSoyad, ut.Tedarikci from Orders o
join BatiBolgesiSorumlu bs on bs.CalisanId = o.EmployeeID
join [Order Details] od on od.OrderID = o.OrderID
join UrunTedarikci ut on ut.UrunID = od.ProductID
--42.	.Siparişlerin toplam tutarı en yüksek olan 10 müşterim benim Platinium müşterim. Bu müşterilerimi listeleyen bir view yazınız 
CREATE VIEW PlatiniumMusteri
AS
select top 10  c.CompanyName, sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) tutar from [Order Details] od
join Orders o on od.OrderID = o.OrderID
join Customers c on c.CustomerID = o.CustomerID
group by c.CompanyName
order by tutar desc
--43.	Kritik seviyede olan ve gelecek siparişi olmayan ürünlerimin tedarikçilerini, kategorilerini, minimum ne kadar sipariş vermem gerektiğini listeleyen bir view oluşturunuz view ismi KritikSeviyeUrunBilgileri
CREATE VIEW KritikSeviyeUrunBilgileri
AS
SELECT 
	P.ProductName,
	C.CategoryName,
	P.ReorderLevel - P.UnitsInStock AS [Minimum miktar]
FROM Products P 
INNER JOIN Categories C ON P.CategoryID = C.CategoryID
INNER JOIN Suppliers S ON P.SupplierID = S.SupplierID
WHERE P.UnitsInStock < P.ReorderLevel AND P.UnitsOnOrder = 0
--44.	 Kategorilerin en çok satan ürününün(adet olarak) kategori adını ve toplam satış adedini gösteren view tasarlayınız. 
create view VW_KategoriAdet 
with encryption 
as
select 
	CategoryName,
	SUM(Quantity) Adet
from [Order Details] od
join Products p on p.ProductID = od.ProductID
join Categories c on c.CategoryID = p.CategoryID
group by CategoryName
--45.	Yöneticimin ilgilendiği müşterilerden Fransa'nın Paris şehrinde olmayanlarını listeleyiniz. Ülke ve şehre göre sıralı olarak gelsin 
Create View vw_YöneticiminMusterisi 
as
select distinct
	CompanyName
from dbo.Orders o
join dbo.Employees e on e.EmployeeID = o.EmployeeID
join dbo.Customers c on c.CustomerID = o.CustomerID
where e.ReportsTo is null and c.Country = 'France' and  c.City <> 'Paris'
--46.	Doğu bölgesindeki müşterilerim hangi kategorilerden alışveriş yapmış, rağbet durumuna göre sıralayan bir view oluşturun.
create view KategoriAdet 
as
select top 99.99 percent
	CategoryName,
	count(c.CategoryID) KategoriAdet
from orders o
join Employees e on e.EmployeeID = o.EmployeeID
join EmployeeTerritories et on et.EmployeeID = e.EmployeeID
join Territories t on t.TerritoryID = et.TerritoryID
join Region r on r.RegionID = t.RegionID
join [Order Details] od on od.OrderID = o.OrderID
join Products p on p.ProductID = od.ProductID
join Categories c on c.CategoryID = p.CategoryID
where r.RegionDescription = 'Eastern'
group by CategoryName
order by KategoriAdet desc
--47.	 Her bir sipariş kalemim de olan ürünlerimin kategorileri, hangi kargo şirketi ile gönderildiği, müşteri bilgisi, tedarikçi bilgisi, hangi çalışanım tarafından onaylandığını tek bir kolonda, ürün ve kategorilerim tek bir kolonda 'kategori Adi - ürün Adi' seklinde kolon adi ürün olsun, müşteri bilgisi 'müsteri id - müşteri adi' seklinde kolon adi müşteri olsun.
select distinct
	CategoryName + ' ' + s.CompanyName + ' ' + c.CategoryName + ' ' + su.CompanyName + ' ' + e.FirstName,
	ProductName + ' - ' + CategoryName Ürün,
	ca.CustomerID + ' ' + ca.CompanyName Musteri 
from Orders o
join [Order Details] od on od.OrderID = o.OrderID
join Customers ca on ca.CustomerID = o.CustomerID
join Shippers s on s.ShipperID = o.ShipVia
join Employees e on e.EmployeeID = o.EmployeeID
join Products p on p.ProductID = od.ProductID
join Categories c on c.CategoryID = p.CategoryID
join Suppliers su on su.SupplierID = p.SupplierID
join EmployeeTerritories et on et.EmployeeID = e.EmployeeID
join Territories t on t.TerritoryID = et.TerritoryID
join Region r on r.RegionID = t.RegionID
--48.	 Bölge bilgisi Northern olan çalışanlarımın onayladığı siparişlerimdeki kritik stok seviyesinde olan ürünleri listeleyiniz ürün adi ve çalışan adi listelensin ve tekrar eden kayıtlar olmasın
select distinct
	ProductName,
	FirstName + ' ' + LastName as Çalışan
from Orders o
join [Order Details] od on od.OrderID = o.OrderID
join Employees e on e.EmployeeID = o.EmployeeID
join Products p on p.ProductID = od.ProductID
join EmployeeTerritories et on et.EmployeeID = e.EmployeeID
join Territories t on t.TerritoryID = et.TerritoryID
join Region r on r.RegionID = t.RegionID
where RegionDescription = 'Northern' and ReorderLevel > UnitsInStock
--49.	 Konumu 'Eastern' olan çalışanlarım tarafından onaylanan siparişlerimin müşterileri, federal shipping ile taşınan ürünlerini kategorilere göre sıralayınız.
select
	o.OrderID,
	cu.CompanyName,
	s.CompanyName,
	ProductName
from Region r 
join Territories t on t.RegionID=r.RegionID
join EmployeeTerritories et on et.TerritoryID=t.TerritoryID
join Employees e on et.EmployeeID=e.EmployeeID
join Orders o on o.EmployeeID=e.EmployeeID
join [Order Details] od on od.OrderID=o.OrderID
join Products p on od.ProductID=p.ProductID
join Categories c on p.CategoryID=c.CategoryID
join Shippers s on o.ShipVia=s.ShipperID
join Customers cu on o.CustomerID=cu.CustomerID
where RegionDescription='Eastern' and s.CompanyName='federal shipping' 
order by CategoryName
--50.	 Speedy Express ile taşınan tedarikçilerimden pazarlama müdürleriyle iletişime geçtiğim, Steven Buchanan adlı çalışanıma rapor veren çalışanlarımın ilgilendiği, Amerika'ya gönderdiğim siparişlerimin ürünlerinin kategorileri nelerdir?
select 
	CategoryName,
	ProductName,
	Calisan.FirstName as calisan,
	patron.FirstName as patron
from Shippers s 
	join Orders o on o.ShipVia=s.ShipperID
	join Customers c on o.CustomerID=c.CustomerID
	join Employees Calisan on o.EmployeeID=Calisan.EmployeeID
	join [Order Details] od on od.OrderID=o.OrderID
	join Products p on od.ProductID=p.ProductID
	join Categories ca on p.CategoryID=ca.CategoryID
	join Employees Patron on Patron.EmployeeID=Calisan.ReportsTo
where s.CompanyName='Speedy Express' 
	and c.ContactTitle='marketing manager' 
	and Patron.FirstName = 'Steven' 
	and Patron.LastName = 'Buchanan'
	and ShipCountry='USA'
--51.	Stok miktarı dışarıdan girilen min ve max STOK aralığında olan, urun ücreti dışarıdan girilen min ve max değerler aralığında olan, toptanci firma adı, dışarıdan girilen karakterleri barındıran tedarikçi firma adı, urun fiyatı dışarıdan girilen kdv uygulanmış haliyle listeleyiniz
Create proc KargoSipariss
(
@minstok smallint,@maxstok smallint,
@ucretmin decimal,@maxucret decimal,
@name nvarchar(50),
@kdv float
)
as 
select (p.UnitPrice+(p.UnitPrice*@kdv)) as KdvliFiyat,p.ProductName,s.CompanyName 
from Products p 
join Suppliers s on s.SupplierID=p.SupplierID
where p.UnitPrice between @ucretmin and @maxucret 
and p.UnitsInStock between @minstok and @maxstok 
and s.CompanyName like '%'+@name+'%'
--52.	 Klavyeden Girilen Shipvia numarasına göre 300'den az veya fazla olduğunu gösteren prosedürü yazınız. Eğer Shipvia değeri yoksa Hata mesajı versin.
--Kayıt Çıktısı Şu Şekilde Olacak : 300den fazla kayıt var. Kayıt Sayısı= 330
create proc kayitSayisi
 @Sayi INT,
 @sutunsayisi int out
 as
 begin
SELECT  @sutunsayisi = COUNT(OrderID) FROM Orders where ShipVia=@sayi
if exists(select * from orders where ShipVia=@sayi)
	IF @sutunsayisi > 300 
		BEGIN
			PRINT '300den fazla kayıt var. Kayıt Sayısı= ' + cast(@sutunsayisi as nvarchar)
		END
	ELSE 
		BEGIN
			PRINT '300den az kayıt var, Kayıt Sayısı= ' + cast(@sutunsayisi as nvarchar)
		END
	else
		begin
			print'Shipvia Bulunamadı'
		end
end

declare @t int
exec kayitSayisi 2,@t out

--53.	 Ürün adı ve kategori adı parametresi alacak Kategori yoksa ekletip sonra ürün ekleten, Kategori varsa o kategoriye ürünü ekleten PROCEDURE'ü yazın.
CREATE PROC PC_KategUrun (@urunAdi nvarchar(30),@kategAdi nvarchar(30))
As

DECLARE @id int
IF Exists (SELECT * FROM Categories c WHERE CategoryName=@kategAdi)
	BEGIN 
		SET @id= (SELECT CategoryID FROM Categories c WHERE CategoryName=@kategAdi)
		INSERT INTO Products (ProductName,CategoryID) Values(@urunAdi,@id)
	END
ELSE 
	BEGIN
		INSERT INTO Categories (CategoryName) Values(@kategAdi)
		INSERT INTO Products (ProductName,CategoryID) Values (@urunAdi,SCOPE_IDENTITY())
	END
--54. Yeni bir tedarikçi ekleyebileceğim bir procedure istiyorum. Burada company name bilgisi alınsın. Tedarikçinin satacağı ürünler, ürünün stok sayısı, fiyat bilgisi ve kategorisi de eklensin. Girilen tedarikçi, kategori ve ürün adı tekrar eklenemesin ve ilgili kategori, tedarikçi ya da ürün yoktur diye hata mesajı fırlatsın. Birden fazla ürün ve kategori de ekleyebilmeliyim. Procedure verilecek parametreler aşağıdaki gibi olmalıdır.
Create proc TedarikciEkle
(
	@CompanyName nvarchar(40),
	@ProductName nvarchar(40),
	@ProductUnitPrice money,
	@ProductCategoryName nvarchar(15)
)
AS

BEGIN
	declare @CompanyVarmi int;
	select @CompanyVarmi= COUNT(CompanyName) from Suppliers where CompanyName = @CompanyName
		
		IF @CompanyVarmi=0
		begin
			insert into Suppliers(CompanyName)		values (@CompanyName)					
		end
		else
		begin
		print 'ilgili tedarikçi vardır.'
		end
	declare @CategoryNameVarmi nvarchar(15)
	select @CategoryNameVarmi = COUNT(CategoryName)	 from Categories where CategoryName= @ProductCategoryName
					
					IF @CategoryNameVarmi=0
						begin
						insert into Categories(CategoryName) values (@ProductCategoryName)
						end
					else
					begin
						print 'ilgili kategori vardır.'
					end
	declare @ProductNameVarmi nvarchar(40)
	select @ProductNameVarmi= COUNT(ProductName) from Products where ProductName= @ProductName
					
					IF @ProductNameVarmi =0
					begin
					insert into Products(ProductName) values (@ProductName)
					end
					else
					begin
					print 'ilgili ürün vardır.'
					end
		
END
--55. Günlük olarak rapor almak istiyorum. Girdiğim kategoriye göre ürün adı ve stok miktarını getiren bir procedure oluşturunuz.
create proc GünlükKategoriRaporu
(@CategoryName  nvarchar(15))
AS
BEGIN
select p.ProductName,p.UnitsInStock
from Products p
JOIN Categories c ON c.CategoryID = p.CategoryID
where c.CategoryName= @CategoryName
END
--56. Girilen iki tarih arasındaki günler için günlük ciromu veren bir procedure oluşturunuz.
Create proc Soru56
(
	@Tarih1 datetime,
	@Tarih2 datetime
)
as
BEGIN
	select SUM(Quantity*p.UnitPrice*(1-Discount))
	from Orders o
	JOIN [Order Details] od ON od.OrderID =o.OrderID
	JOIN Products p ON p.ProductID = od.ProductID
	where o.ShippedDate between @Tarih1 and @Tarih2	
END