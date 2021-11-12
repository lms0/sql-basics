CREATE DATABASE Monarca1
ON     (NAME=Monarca1_mdf, FILENAME="C:\Bases\Monarca1.mdf")
LOG ON (NAME=Monarca1_ldf, FILENAME="C:\Bases\Monarca1.ldf")

USE Monarca1

-- Maker table:
CREATE TABLE Makers
  (Maker INT NOT NULL PRIMARY KEY,
   MakerName VARCHAR(40) NOT NULL,
   MakerCountry VARCHAR(20) NOT NULL,
   MakerPhone VARCHAR(15) NOT NULL)

CREATE UNIQUE INDEX MakerName_uindx ON Makers(MakerName)
CREATE INDEX MakerCountry_indx ON Makers(MakerCountry)
CREATE UNIQUE INDEX MakerPhone_uindx ON Makers(MakerPhone)

INSERT Makers values (1,'Nestle', 'Switzerland', '+41778142713')
INSERT Makers values (2,'Sony', 'Japan', '+123456543')
INSERT Makers values (3,'Ladrilleria el Ladron', 'Argentina', '+542494507954')
INSERT Makers values (4,'Microsoft', 'USA', '+1234996543')
INSERT Makers values (5,'Don Satur', 'Argentina', '+54249437463')

SELECT * FROM Makers ORDER BY Maker



-- Product categories table:
CREATE TABLE Categories
  (Category INT NOT NULL PRIMARY KEY,
   CategoryDescription VARCHAR(40) NOT NULL)

CREATE UNIQUE INDEX CategoryDescription_uindx ON Categories(CategoryDescription)

INSERT Categories values (1,'Videojuegos')
INSERT Categories values (2,'Casa')
INSERT Categories values (3,'Alimentos')

SELECT * FROM Categories ORDER BY Category

-- Products table:
CREATE TABLE Products
  (Product INT NOT NULL PRIMARY KEY,
   BarCode VARCHAR(60) NOT NULL,
   ProductDescription VARCHAR(60) NOT NULL,
   Price MONEY NOT NULL,
   Maker INT NOT NULL FOREIGN KEY REFERENCES Makers (Maker),
   Category INT NOT NULL FOREIGN KEY REFERENCES Categories (Category))
CREATE UNIQUE INDEX BarCode_uindx ON Products(BarCode)
CREATE UNIQUE INDEX ProductDescription_uindx ON Products(ProductDescription)
CREATE INDEX Maker_indx ON Products(Maker)
CREATE INDEX Category_indx ON Products(Category)
--ALTER TABLE Products
--   ADD CONSTRAINT FK_Products_Maker FOREIGN KEY (Maker)
--   REFERENCES Makers (Maker)
--ALTER TABLE Products
--   ADD CONSTRAINT FK_Products_Category FOREIGN KEY (Category)
--   REFERENCES Categories (Category)

INSERT Products values (1,'7790000000000','PlayStation 5',500.00,2,1)
INSERT Products values (2,'7790000000123','xBox 4',600.00,4,1)
INSERT Products values (3,'7712223333445','Ravioles',6.00,5,3)
INSERT Products values (4,'7714222333446','Ladrillo amigo',16.00,3,2)
INSERT Products values (5,'7712522333446','Chorizo',16.00,5,3)

SELECT * FROM Products ORDER BY Product
SELECT * FROM Products, Makers, Categories
WHERE Products.Maker=Makers.Maker and Products.Category = Categories.Category
order by Product


-- Create Customer Table
CREATE TABLE Customers
  (Customer INT NOT NULL PRIMARY KEY,
   CustomerName VARCHAR(60) NOT NULL,
   Product1 INT NOT NULL FOREIGN KEY REFERENCES Products (Product),
   Product2 INT          FOREIGN KEY REFERENCES Products (Product),
   )
CREATE INDEX CustomerName_indx ON Customers(CustomerName)
INSERT Customers VALUES (1, 'Nico', 1, 2)
INSERT Customers VALUES (2, 'Ile', 3, 5)
INSERT Customers VALUES (3, 'Mosho', 4, NULL)

SELECT Customers.CustomerName, Products.ProductDescription, Products.Price, Makers.MakerName, Categories.CategoryDescription FROM Customers, Products, Makers, Categories
WHERE  ( Customers.Product1 = Products.Product or Customers.Product2 = Products.Product ) 
					and Products.Maker = Makers.Maker 
					and Products.Category = Categories.Category
ORDER BY Customer

-- What product categories did Ile buy?
SELECT DISTINCT Categories.CategoryDescription FROM Customers, Products, Makers, Categories
WHERE Customers.Customer = 2 and ( Customers.Product1 = Products.Product or Customers.Product2 = Products.Product ) 
					and Products.Maker = Makers.Maker 
					and Products.Category = Categories.Category

-- What are the makers of the products that Nico bought?
SELECT DISTINCT Makers.MakerName FROM Customers, Products, Makers, Categories
WHERE Customers.Customer = 1 and ( Customers.Product1 = Products.Product or Customers.Product2 = Products.Product ) 
					and Products.Maker = Makers.Maker 
					and Products.Category = Categories.Category