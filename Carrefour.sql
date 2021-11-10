-- Crear Base de Datos.
CREATE DATABASE Carrefour
ON     (NAME=Carrefour_mdf, FILENAME="E:\Bases SQL\Carrefour.mdf")
LOG ON (NAME=Carrefour_ldf, FILENAME="E:\Bases SQL\Carrefour.ldf")

use Carrefour
-- Crear Productos, Rubros de Productos, Proveedores.

-- Crear Rubro de Productos:
CREATE TABLE RubrosDeProductos
  (RubroDeProducto INT NOT NULL PRIMARY KEY,
   Descripción VARCHAR(40) NOT NULL,
   Abreviado VARCHAR(12) NOT NULL)
CREATE UNIQUE INDEX RubrosDeProductos_Descripción ON RubrosDeProductos(Descripción)
CREATE UNIQUE INDEX RubrosDeProductos_Abreviado ON RubrosDeProductos(Abreviado)

INSERT RubrosDeProductos values (1,'Almacén', 'Almacén')
INSERT RubrosDeProductos values (2,'Jardinería', 'Jardinería')
INSERT RubrosDeProductos values (3,'Juegos', 'Juegos')
INSERT RubrosDeProductos (Descripción,Abreviado,RubroDeProducto) values ('Frutería','Frutería',4)
INSERT RubrosDeProductos (Descripción,Abreviado,RubroDeProducto) values ('Pastas','Pastas',5)

SELECT * FROM RubrosDeProductos ORDER BY RubroDeProducto

-- Crear Proveedores:
CREATE TABLE Proveedores
  (Proveedor INT NOT NULL PRIMARY KEY,
   Nombre VARCHAR(40) NOT NULL,
   Abreviado VARCHAR(12) NOT NULL,
   Domicilio VARCHAR(40) NOT NULL,
   Localidad VARCHAR(40) NOT NULL)
CREATE UNIQUE INDEX Proveedores_Nombre ON Proveedores(Nombre)
CREATE UNIQUE INDEX Proveedores_Abreviado ON Proveedores(Abreviado)
CREATE INDEX Proveedores_Localidad ON Proveedores(Localidad)

--BEGIN TRANSACTION
INSERT Proveedores values (1,'Nicolás INC', 'NicolásINC','Martín Fierro 69','Tandil')
INSERT Proveedores values (2,'Ileana INC', 'IleanaINC','Pinto 1234','Posadas')
INSERT Proveedores values (3,'Alfredo INC', 'AlfredoINC','Sarmiento 1234','Posadas')
UPDATE Proveedores SET Localidad='Vela' WHERE Localidad!='Posadas'
--COMMIT TRANSACTION
--rollback transaction

SELECT * FROM Proveedores ORDER BY Proveedor
TRUNCATE TABLE Proveedores

-- Tabla Productos:
DROP TABLE Productos
CREATE TABLE Productos
  (Producto INT NOT NULL PRIMARY KEY,
   CódigoDeBarras VARCHAR(60) NOT NULL,
   Descripción VARCHAR(60) NOT NULL,
   Precio MONEY NOT NULL,
   RubroDeProducto INT NOT NULL,
   Proveedor INT NOT NULL)
CREATE UNIQUE INDEX Productos_CódigoDeBarras ON Productos(CódigoDeBarras)
CREATE UNIQUE INDEX Productos_Descripción ON Productos(Descripción)
CREATE INDEX Productos_RubroDeProducto ON Productos(RubroDeProducto)
CREATE INDEX Productos_Proveedor ON Productos(Proveedor)
ALTER TABLE Productos
   ADD CONSTRAINT FK_Productos_RubroDeProducto FOREIGN KEY (RubroDeProducto)
   REFERENCES RubrosDeProductos (RubroDeProducto)
ALTER TABLE Productos
   ADD CONSTRAINT FK_Productos_Proveedor FOREIGN KEY (Proveedor)
   REFERENCES Proveedores (Proveedor)


--   ON UPDATE CASCADE ON DELETE CASCADE
--   ON UPDATE NO ACTION ON DELETE NO ACTION

sp_help Productos

INSERT Productos values (1,'7790000000000','PlayStation 5',500.00,3,2)
INSERT Productos values (2,'7790000000123','xBox 4',600.00,3,1)
INSERT Productos values (3,'7712222333445','Ravioles',6.00,5,3)
INSERT Productos values (4,'7712222333446','Aceite Cocinero',6.00,1,3)

select Producto, Descripción, Precio, Proveedores.Proveedor, Nombre
from Productos, Proveedores
where Productos.Proveedor=Proveedores.Proveedor and
      RubroDeProducto=3
order by Producto  

delete from Proveedores where Proveedor=1