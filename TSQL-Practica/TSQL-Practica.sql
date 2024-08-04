﻿/*
1)
Hacer una función que dado un artículo y un deposito devuelva un string que
indique el estado del depósito según el artículo. Si la cantidad almacenada es
menor al límite retornar “OCUPACION DEL DEPOSITO XX %” siendo XX el
% de ocupación. Si la cantidad almacenada es mayor o igual al límite retornar
“DEPOSITO COMPLETO”.
*/

ALTER FUNCTION estado_deposito (@articulo char(8), @deposito char(2))
	RETURNS varchar(50)
	BEGIN
		DECLARE @porcentaje numeric(10,2)
		SET @porcentaje = (SELECT (isnull(stoc_cantidad,0)/stoc_stock_maximo)*100 FROM STOCK WHERE stoc_producto=@articulo AND stoc_deposito=@deposito)
		IF (@porcentaje >=100 OR @porcentaje IS NULL)
			RETURN 'DEPOSITO COMPLETO'
		RETURN 'OCUPACION DEL DEPOSITO'+' '+@deposito+' '+' '+STR(@porcentaje)+' '+'%'
	END

GO 

SELECT prod_codigo, prod_detalle, stoc_cantidad, stoc_stock_maximo, dbo.estado_deposito(stoc_producto,stoc_deposito) 
FROM STOCK JOIN Producto ON stoc_producto=prod_codigo 
ORDER BY 1 
GO 

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
2)
Realizar una función que dado un artículo y una fecha, retorne el stock que
existía a esa fecha
CORRECCION enunciado:
se pide la cantidad del articulo que se vendio desde la fecha que se pasa por parametro en adelante.
*/

ALTER FUNCTION cantidad_vendida_desde(@articulo char(8), @fecha smalldatetime)
	RETURNS numeric(12,2)
	BEGIN
		DECLARE @ventas_desde_fecha numeric(12,2)
		SET @ventas_desde_fecha = (SELECT SUM(item_cantidad) FROM Item_Factura JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
									WHERE fact_fecha >= @fecha AND item_producto=@articulo)
		RETURN @ventas_desde_fecha
	END

GO

SELECT prod_detalle, dbo.cantidad_vendida_desde(prod_codigo, '2012-06-17') 'CANTIDAD VENDIDA', '2012-06-17' 'DESDE'--DATEADD(year,-1, MAX(fact_fecha))--CAST(DATEADD(year,-1, MAX(fact_fecha)) AS smalldatetime)
FROM Producto 
JOIN Item_Factura ON prod_codigo=item_producto 
JOIN Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
GROUP BY prod_codigo,prod_detalle
GO 

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
3)
Cree el/los objetos de base de datos necesarios para corregir la tabla empleado
en caso que sea necesario. Se sabe que debería existir un único gerente general
(debería ser el único empleado sin jefe). Si detecta que hay más de un empleado
sin jefe deberá elegir entre ellos el gerente general, el cual será seleccionado por
mayor salario. Si hay más de uno se seleccionara el de mayor antigüedad en la
empresa. Al finalizar la ejecución del objeto la tabla deberá cumplir con la regla
de un único empleado sin jefe (el gerente general) y deberá retornar la cantidad
de empleados que había sin jefe antes de la ejecución.
*/

ALTER PROCEDURE correccion_gerencial @cant_empleados_sin_jefe INTEGER OUTPUT
AS 
BEGIN
	SET @cant_empleados_sin_jefe = (SELECT COUNT(*) FROM Empleado WHERE empl_jefe IS NULL)
	IF @cant_empleados_sin_jefe > 1
	BEGIN
		DECLARE @gerenteGeneral numeric(6,0)
		SET @gerenteGeneral = (SELECT TOP (1) empl_codigo FROM Empleado WHERE empl_jefe IS NULL ORDER BY empl_salario DESC, empl_ingreso ASC)

		UPDATE Empleado
		SET empl_jefe=@gerenteGeneral
		WHERE empl_jefe IS NULL AND empl_codigo!=@gerenteGeneral

		UPDATE Empleado
		SET empl_tareas='Gerente General'
		WHERE empl_codigo=@gerenteGeneral
	END
END	

GO

SELECT * FROM Empleado

BEGIN
	DECLARE @cant INTEGER 
	EXEC dbo.correccion_gerencial @cant output
	PRINT @cant
END
GO 

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
4)
Cree el/los objetos de base de datos necesarios para actualizar la columna de
empleado empl_comision con la sumatoria del total de lo vendido por ese
empleado a lo largo del último año. Se deberá retornar el código del vendedor
que más vendió (en monto) a lo largo del último año.
*/

ALTER PROCEDURE actualizacion_comision @empleado_top1 numeric(6,0) OUTPUT
AS 
BEGIN
	SET @empleado_top1 = (SELECT TOP(1) fact_vendedor FROM Factura WHERE fact_fecha >= DATEADD(year,-1,fact_fecha) GROUP BY fact_vendedor ORDER BY SUM(fact_total) DESC)

	UPDATE Empleado
	SET empl_comision=ISNULL((SELECT SUM(fact_total) FROM Factura WHERE fact_vendedor=empl_codigo AND fact_fecha >= DATEADD(year,-1,fact_fecha)), 0)

END	

GO

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
5)
Realizar un procedimiento que complete con los datos existentes en el modelo
provisto la tabla de hechos denominada Fact_table tiene las siguiente definición:
Create table Fact_table
( 
hech_anio char(4) NOT NULL,
hech_mes char(2) NOT NULL,
hech_familia char(3) NOT NULL,
hech_rubro char(4) NOT NULL,
hech_zona char(3) NOT NULL,
hech_cliente char(6)NOT NULL,
hech_producto char(8) NOT NULL,
hech_cantidad decimal(12,2),
hech_monto decimal(12,2)
)
Alter table Fact_table
Add constraint PK_Fact_table primary key (hech_anio, hech_mes, hech_familia, hech_rubro, hech_zona, hech_cliente, hech_producto)
*/


ALTER PROCEDURE completar_hechos
AS 
BEGIN
	INSERT INTO Fact_table (hech_anio, hech_mes, hech_familia, hech_rubro, hech_zona, hech_cliente, hech_producto, hech_cantidad, hech_monto)
	SELECT year(fact_fecha), month(fact_fecha), fami_id, rubr_id, depa_zona,fact_cliente,prod_codigo, SUM(item_cantidad), SUM(item_precio)
	FROM Item_Factura 
	RIGHT JOIN Producto ON item_producto=prod_codigo 
	JOIN Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
	JOIN Rubro ON prod_rubro=rubr_id
	JOIN Familia ON prod_familia=fami_id
	JOIN Empleado ON fact_vendedor=empl_codigo JOIN Departamento ON empl_departamento=depa_codigo
	GROUP BY year(fact_fecha), month(fact_fecha), fami_id, rubr_id, depa_zona,fact_cliente,prod_codigo

END	

GO

EXEC dbo.completar_hechos
GO 

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
6) -NO EMPEZADO-
Realizar un procedimiento que si en alguna factura se facturaron componentes
que conforman un combo determinado (o sea que juntos componen otro
producto de mayor nivel), en cuyo caso deberá reemplazar las filas
correspondientes a dichos productos por una sola fila con el producto que
componen con la cantidad de dicho producto que corresponda.
*/

create PROCEDURE SP_UNIFICAR_PRODUCTO
AS
BEGIN
	declare @combo char(8);
	declare @combocantidad integer;
	
	declare @fact_tipo char(1);
	declare @fact_suc char(4);
	declare @fact_nro char(8);
	
	
	
	declare  cFacturas cursor for --CURSOR PARA RECORRER LAS FACTURAS
		select fact_tipo, fact_sucursal, fact_numero
		from Factura ;
		/* where para hacer una prueba acotada
		where fact_tipo = 'A' and
				fact_sucursal = '0003' and
				fact_numero='00092476'; */
		
		open cFacturas
		
		fetch next from cFacturas
		into @fact_tipo, @fact_suc, @fact_nro
		
		while @@FETCH_STATUS = 0
		begin	
			declare  cProducto cursor for
			select comp_producto --ACA NECESITAMOS UN CURSOR PORQUE PUEDE HABER MAS DE UN COMBO EN UNA FACTURA
			from Item_Factura join Composicion C1 on (item_producto = C1.comp_componente)
			where item_cantidad >= C1.comp_cantidad and
				  item_sucursal = @fact_suc and
				  item_numero = @fact_nro and
				  item_tipo = @fact_tipo
			group by C1.comp_producto
			having COUNT(*) = (select COUNT(*) from Composicion as C2 where C2.comp_producto= C1.comp_producto)
			
			open cProducto
			fetch next from cProducto into @combo
			while @@FETCH_STATUS = 0 
			begin
	  					
				select @combocantidad= MIN(FLOOR((item_cantidad/c1.comp_cantidad)))
				from Item_Factura join Composicion C1 on (item_producto = C1.comp_componente)
				where item_cantidad >= C1.comp_cantidad and
					  item_sucursal = @fact_suc and
					  item_numero = @fact_nro and
					  item_tipo = @fact_tipo and
					  c1.comp_producto = @combo	--SACAMOS CUANTOS COMBOS PUEDO ARMAR COMO M�XIMO (POR ESO EL MIN)
				
				--INSERTAMOS LA FILA DEL COMBO CON EL PRECIO QUE CORRESPONDE
				insert into Item_Factura (item_tipo, item_sucursal, item_numero, item_producto, item_cantidad, item_precio)
				select @fact_tipo, @fact_suc, @fact_nro, @combo, @combocantidad, (@combocantidad * (select prod_precio from Producto where prod_codigo = @combo));				

				update Item_Factura  
				set 
				item_cantidad = i1.item_cantidad - (@combocantidad * (select comp_cantidad from Composicion
																		where i1.item_producto = comp_componente 
																			  and comp_producto=@combo)),
				ITEM_PRECIO = (i1.item_cantidad - (@combocantidad * (select comp_cantidad from Composicion
															where i1.item_producto = comp_componente 
																  and comp_producto=@combo))) * 	
													(select prod_precio from Producto where prod_codigo = I1.item_producto)											  															  
				from Item_Factura I1, Composicion C1 
				where I1.item_sucursal = @fact_suc and
					  I1.item_numero = @fact_nro and
					  I1.item_tipo = @fact_tipo AND
					  I1.item_producto = C1.comp_componente AND
					  C1.comp_producto = @combo
					  
				delete from Item_Factura
				where item_sucursal = @fact_suc and
					  item_numero = @fact_nro and
					  item_tipo = @fact_tipo and
					  item_cantidad = 0
				
				fetch next from cproducto into @combo
			end
			close cProducto;
			deallocate cProducto;
			
			fetch next from cFacturas into @fact_tipo, @fact_suc, @fact_nro
			end
			close cFacturas;
			deallocate cFacturas;
	end 

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
7)
Hacer un procedimiento que dadas dos fechas complete la tabla Ventas. Debe
insertar una línea por cada artículo con los movimientos de stock generados por
las ventas entre esas fechas. La tabla se encuentra creada y vacía.

*/

IF OBJECT_ID('VENTAS') IS NOT NULL
	DROP TABLE Ventas
GO

CREATE TABLE Ventas( 
	venta_codigo char(8),
	venta_detalle char(50),
	venta_movimientos INT,
	venta_precio_promedio DECIMAL(12,2),
	venta_renglon NUMERIC(6,0),
	venta_ganancia DECIMAL(12,2)
)
GO

ALTER PROCEDURE ejercicio_7 (@fecha_inicio datetime, @fecha_fin datetime)
AS 
BEGIN
	INSERT INTO Ventas (venta_codigo, venta_detalle, venta_movimientos, venta_precio_promedio, venta_renglon, venta_ganancia) 
	SELECT	prod_codigo, 
			prod_detalle,
			COUNT(*),
			AVG(item_cantidad * item_precio),
			ROW_NUMBER() OVER (ORDER BY prod_codigo),
			SUM(item_cantidad * item_precio) - SUM(item_cantidad * prod_precio)
	FROM Producto JOIN Item_Factura ON prod_codigo=item_producto JOIN Factura ON item_numero+item_sucursal+item_tipo=fact_numero+fact_sucursal+fact_tipo 
	WHERE fact_fecha BETWEEN @fecha_inicio AND @fecha_fin
	GROUP BY prod_codigo, prod_detalle
END

--AVG(item_precio)-AVG(prod_precio * item_cantidad)),

EXEC dbo.ejercicio_7 '2012-01-01', '2012-06-01' 

SELECT * FROM Ventas
GO 
/*SELECT item_producto, 
COUNT(*) AS 'VECES QUE SE VENDIO',
SUM(item_cantidad * item_precio) AS 'MONTO TOTAL VENDIDO'
FROM Item_Factura
JOIN Factura ON item_numero + item_sucursal + item_tipo =
fact_numero + fact_sucursal + fact_tipo
WHERE item_producto = '00001415' AND
fact_fecha BETWEEN '2012-01-01' AND '2012-06-01' 
GROUP BY item_producto
*/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
8)
Realizar un procedimiento que complete la tabla Diferencias de precios, para los
productos facturados que tengan composición y en los cuales el precio de
facturación sea diferente al precio del cálculo de los precios unitarios por
cantidad de sus componentes, se aclara que un producto que compone a otro,
también puede estar compuesto por otros y así sucesivamente, la tabla se debe
crear y está formada por las siguientes columnas:
*/

IF OBJECT_ID('Diferencias') IS NOT NULL
	DROP TABLE Diferencias
GO

CREATE TABLE Diferencias ( 
	dif_codigo char(8),
	dif_detalle char(50),
	dif_cantidad NUMERIC(6,0),
	dif_precio_generado DECIMAL(12,2),
	dif_precio_facturado DECIMAL(12,2),
)
GO

ALTER FUNCTION Valor_Comps_Combo(@producto char(8))
RETURNS decimal(12,2)
AS
BEGIN
	DECLARE @valor decimal(12,2)	
	SET @valor = (SELECT SUM(dbo.Valor_Comps_Combo(comp_componente) * comp_cantidad) FROM Composicion WHERE comp_producto = @producto)
	--Solo suma los valores de los componentes, cuando estos no son composiciones de otros productos(que pasa cuando @valor IS NULL ya que
	-- en la busqueda de arriba, busca un comp_producto=@producto, y como no existe => @valor se setea en NULL)
	IF(@valor IS NULL)
		SET @valor = (SELECT prod_precio FROM Producto WHERE prod_codigo = @producto)
	RETURN @valor
END 
GO

CREATE PROCEDURE ejercicio_8
AS
BEGIN 
	INSERT INTO Diferencias (dif_codigo, dif_detalle, dif_cantidad, dif_precio_generado, dif_precio_facturado)
	SELECT prod_codigo, prod_detalle, COUNT(distinct comp_componente), dbo.Valor_Comps_Combo(prod_codigo), prod_precio
	FROM Producto JOIN Composicion ON prod_codigo=comp_producto
	GROUP BY prod_codigo, prod_detalle, prod_precio
END

GO

EXEC dbo.ejercicio_8

SELECT * FROM Diferencias
GO 
/*
SELECT P1.prod_codigo, P1.prod_detalle, P2.prod_detalle--, SUM(comp_cantidad) 
	FROM Producto P1 JOIN Composicion ON P1.prod_codigo=comp_producto JOIN Producto P2 ON P2.prod_codigo=comp_componente
	--GROUP BY prod_codigo, prod_detalle
*/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
9) -NO TERMINADO-
Crear el/los objetos de base de datos que ante alguna modificación de un ítem de
factura de un artículo con composición realice el movimiento de sus
correspondientes componentes.

ACLARACION: Como el enunciado dice "ante alguna modificacion" asumo que tengo que validar
este caso solo para UPDATE y que lo unico que puedo modificar de un item factura es la 
cantidad vendida de ese producto (item_cantidad), por lo tanto una vez modificado ese
campo, el trigger deberia ir a la tabla stock y modificar el stock disponible de los
componentes de ese producto. Como hay stocks negativos en la BD no valido que este tengo 
que ser mayor a 0, lo unico que valido es que no supere el limite de stock. El trigger
solo se activa si hay actualizaciones en la columna item_cantidad 
*/



CREATE TRIGGER ejercicio_9 ON Item_Factura INSTEAD OF UPDATE
AS
BEGIN
	DECLARE @producto char(8)
	DECLARE c1 CURSOR FOR (SELECT item_producto FROM inserted)
	OPEN c1
		FETCH FROM c1 INTO @producto  
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			DECLARE @cambio_stock decimal(12,2)
			SET @cambio_stock = (SELECT item_cantidad FROM deleted) - (SELECT item_cantidad FROM inserted)
			IF(SELECT stoc_stock_maximo-stoc_cantidad FROM STOCK WHERE stoc_producto=@producto - @cambio_stock)>0
			BEGIN
				UPDATE 
			END

			FETCH FROM c1 INTO @producto 
		END
	CLOSE c1
	DEALLOCATE c1
END
GO 

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
10)
. Crear el/los objetos de base de datos que ante el intento de borrar un artículo
verifique que no exista stock y si es así lo borre en caso contrario que emita un
mensaje de error.
*/

ALTER TRIGGER ejercicio_10 ON Producto INSTEAD OF DELETE 
AS
BEGIN
	DECLARE @producto char(8)
	DECLARE c1 CURSOR FOR (SELECT prod_codigo FROM deleted)
	OPEN c1
		FETCH NEXT FROM c1 into @producto
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (SELECT COUNT(*) FROM STOCK WHERE stoc_cantidad>0 AND stoc_producto=@producto)>0
				print('El producto '+@producto+' no se puede borrar')
			ELSE
				DELETE FROM Producto WHERE prod_codigo=@producto
			FETCH NEXT FROM c1 into @producto
		END
	CLOSE c1
	DEALLOCATE c1
END

GO 

/*
delete FROM Producto where prod_codigo>'00000050'
*/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
11)
Cree el/los objetos de base de datos necesarios para que dado un código de
empleado se retorne la cantidad de empleados que este tiene a su cargo (directa o
indirectamente). Solo contar aquellos empleados (directos o indirectos) que
tengan un código mayor que su jefe directo.
*/

ALTER FUNCTION ejercicio_11 (@empleado numeric(6,0))
	RETURNS INTEGER
	BEGIN
		DECLARE @empleados_a_cargo INTEGER
		SET @empleados_a_cargo = 0

		if (SELECT count(*) from Empleado where empl_jefe=@empleado)=0
			return @empleados_a_cargo
		
		SET @empleados_a_cargo = (select count(*) from Empleado where empl_jefe=@empleado)
		DECLARE @indirecto numeric(6,0)
		declare c1 CURSOR for (select empl_codigo from Empleado where empl_jefe=@empleado)
		OPEN c1 
			fetch next from c1 into @indirecto
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @empleados_a_cargo = @empleados_a_cargo + dbo.ejercicio_11(@indirecto)
				FETCH NEXT FROM c1 into @indirecto
			END
		CLOSE c1
		DEALLOCATE c1

		RETURN @empleados_a_cargo
	END

GO 

SELECT * FROM Empleado
SELECT dbo.ejercicio_11(1)
GO 

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
12)
Cree el/los objetos de base de datos necesarios para que nunca un producto
pueda ser compuesto por sí mismo. Se sabe que en la actualidad dicha regla se
cumple y que la base de datos es accedida por n aplicaciones de diferentes tipos
y tecnologías. No se conoce la cantidad de niveles de composición existentes.

*/

--EN GENERAL ESCAPARLE AL INSTEAD OF, IR AL AFTER DE UNA, que ademas es mas sencillo

alter function compuesto (@prod char(8), @comp char(8))
returns int
BEGIN
	declare @componente char(8)
	if @prod=@comp
		return 1
	
	declare c1 cursor for select comp_componente from composicion where comp_producto = @comp
	open c1
	fetch next from c1 into @componente
	while @@FETCH_STATUS = 0
		BEGIN
			IF dbo.compuesto(@prod, @componente)=1
				BEGIN
					CLOSE c1
					DEALLOCATE c1
					return 1
				END
			fetch next from c1 into @componente
		END
	CLOSE c1
	DEALLOCATE c1
	return 0
END

GO

ALTER TRIGGER ejercicio_12 ON Composicion AFTER insert, update
AS
BEGIN
	if (select SUM(dbo.compuesto(comp_producto, comp_componente)) from inserted )> 0
	BEGIN
		print 'EL PRODUCTO ESTA COMPUESTO POR SI MISMO EN ALGUNO DE SUS NIVELES'
		ROLLBACK
	END
END

GO

--Testeo de la funcion (al ser todo 0 ninguno esta compuesto por si mismo)
select dbo.compuesto(comp_producto, comp_componente) from Composicion



--no deja agregarlo por ser igual a si mismo
INSERT INTO Composicion VALUES (2, '00001707', '00001707')

SELECT * FROM Composicion WHERE comp_producto = '00001707'

--deja agregarlo ya que no rompe la regla
INSERT INTO Composicion VALUES (2, '00001707', '00001708')

SELECT * FROM Composicion WHERE comp_producto = '00001707'
--borro la prueba
DELETE FROM Composicion  WHERE comp_producto = '00001707' AND comp_componente = '00001708'
GO 


-- MAL RESUELTO, EN ESTOS CASOS APUTAR AL AFTER, que ademas es mas sencillo

/*ALTER TRIGGER ejercicio_12 ON Composicion INSTEAD OF INSERT
AS
BEGIN
	DECLARE @combo_nuevo char(8)
	DECLARE @componente_nuevo char(8)

	DECLARE c12 CURSOR FOR SELECT comp_producto, comp_componente FROM inserted
	OPEN c12
	FETCH NEXT FROM c12 INTO @combo_nuevo, @componente_nuevo
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		IF(@combo_nuevo!=@componente_nuevo)
			INSERT INTO Composicion
			SELECT * FROM inserted WHERE comp_producto=@combo_nuevo AND comp_componente=@componente_nuevo
		ELSE
			PRINT('error, no puede agregarse como componente a si mismo en: producto = '+STR(@combo_nuevo)+' | componente = '+STR(@componente_nuevo))
		FETCH NEXT FROM c12 INTO @combo_nuevo, @componente_nuevo
	END
	CLOSE c12
	DEALLOCATE c12
END

GO

--no deja agregarlo por ser igual a si mismo
INSERT INTO Composicion VALUES (2, '00001707', '00001707')

SELECT * FROM Composicion WHERE comp_producto = '00001707'

--deja agregarlo ya que no rompe la regla
INSERT INTO Composicion VALUES (2, '00001707', '00001708')

SELECT * FROM Composicion WHERE comp_producto = '00001707'
--borro la prueba
DELETE FROM Composicion  WHERE comp_producto = '00001707' AND comp_componente = '00001708'

*/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
13)
Cree el/los objetos de base de datos necesarios para implantar la siguiente regla
“Ningún jefe puede tener un salario mayor al 20% de las suma de los salarios de
sus empleados totales (directos + indirectos)”. Se sabe que en la actualidad dicha
regla se cumple y que la base de datos es accedida por n aplicaciones de
diferentes tipos y tecnologías
*/
ALTER FUNCTION suma_salarios_subordinados (@empleado numeric(6,0))
	RETURNS decimal(12,2)
	BEGIN
		DECLARE @suma_salarios decimal(12,2), @indirecto numeric(6,0), @salario decimal(12,2)
		SET @suma_salarios = 0

		if (SELECT count(*) from Empleado where empl_jefe=@empleado)=0
			return @suma_salarios
		
		--esto podria ir en vez de @salario pero me parece que es mas claro usando el @salario
		--SET @suma_salarios = (select SUM(empl_salario) from Empleado where empl_jefe=@empleado)

		declare c_salarios CURSOR for (select empl_codigo, empl_salario from Empleado where empl_jefe=@empleado)
		OPEN c_salarios 
			fetch next from c_salarios into @indirecto, @salario
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @suma_salarios = @suma_salarios + @salario + dbo.suma_salarios_subordinados(@indirecto)
				fetch next from c_salarios into @indirecto, @salario
			END
		CLOSE c_salarios
		DEALLOCATE c_salarios

		RETURN @suma_salarios
	END

GO 

--VERSION AFTER
ALTER TRIGGER ejercicio13 ON Empleado AFTER UPDATE, DELETE
AS
BEGIN
	--Este if es necesario ya que ante un update de una fila, hay que chequear que su jefe siga cumpliendo la condicion
	IF EXISTS(SELECT * FROM inserted i
	WHERE (SELECT empl_salario FROM Empleado WHERE empl_codigo=i.empl_jefe) >= (0.2*dbo.suma_salarios_subordinados(i.empl_jefe)))
		BEGIN
			PRINT('error, el salario de algun jefe supera el 20% de la suma del salario de sus subordinados')
			ROLLBACK
		END
	--Este if es necesario ya que ante un update del gerente general, hay que chequear desde el si la condicion se sigue cumpliendo
	IF EXISTS(SELECT * FROM inserted
	WHERE empl_salario >= (0.2*dbo.suma_salarios_subordinados(empl_codigo)))
		BEGIN
			PRINT('error, el salario de algun jefe supera el 20% de la suma del salario de sus subordinados')
			ROLLBACK
		END
	--Este if es necesario ya que ante un delete, hay que chequear desde su jefe si la condicion se sigue cumpliendo, 
	-- y si se elimina el gerente general, no hay problema, ya que este no afecta a niveles superiores(porque no los hay)
	IF EXISTS(SELECT * FROM deleted d
	WHERE (SELECT empl_salario FROM Empleado WHERE empl_codigo=d.empl_jefe) >= (0.2*dbo.suma_salarios_subordinados(d.empl_jefe)))
		BEGIN
			PRINT('error, el salario de algun jefe supera el 20% de la suma del salario de sus subordinados')
			ROLLBACK
		END
END

GO

-- chequeo si la funcion devuelve el valor de salario correcto
SELECT SUM(empl_salario) FROM Empleado WHERE empl_jefe = 1
SELECT SUM(empl_salario) FROM Empleado WHERE empl_jefe = 2
SELECT SUM(empl_salario) FROM Empleado WHERE empl_jefe = 3
SELECT dbo.suma_salarios_subordinados(1)

SELECT * FROM Empleado
WHERE empl_codigo = 3

UPDATE Empleado
SET empl_salario = 10000
WHERE empl_codigo = 3
GO 

--VERSION CON INSTEAD OF
/*
ALTER TRIGGER ejercicio13a ON Empleado INSTEAD OF INSERT
AS
BEGIN
	DECLARE @jefe numeric(6,0)
	DECLARE @salario_jefe decimal(12,2)
	DECLARE c13a CURSOR FOR SELECT empl_codigo, empl_salario FROM inserted
	OPEN c13a
	FETCH NEXT FROM c13a INTO @jefe, @salario_jefe
	WHILE(@@FETCH_STATUS=0)
	BEGIN
		--IF (SELECT count(*) FROM inserted WHERE empl_jefe=@jefe)=0
			--PRINT('error, el empleado insertado no es jefe de ningun otro empleado')
		IF (@salario_jefe) > (0.2*dbo.suma_salarios_subordinados(@jefe)) OR (SELECT count(*) FROM inserted WHERE empl_jefe=@jefe)=0
			INSERT INTO Empleado SELECT * FROM inserted WHERE empl_codigo=@jefe
		ELSE
			PRINT('error, el salario del nuevo empleado supera el 20% de la suma del salario de sus subordinados')

		FETCH NEXT FROM c13a INTO @jefe, @salario_jefe
	END
	CLOSE c13a
	DEALLOCATE c13a
END

GO

ALTER TRIGGER ejercicio13b ON Empleado INSTEAD OF UPDATE
AS
BEGIN
	DECLARE @jefe numeric(6,0)
	DECLARE @salario_jefe decimal(12,2)

	DECLARE c13b CURSOR FOR SELECT empl_codigo, empl_salario FROM inserted
	OPEN c13b
	FETCH NEXT FROM c13b INTO @jefe, @salario_jefe
	WHILE(@@FETCH_STATUS=0)
	BEGIN
		--IF (SELECT count(*) FROM Empleado WHERE empl_jefe=@jefe)=0
			--PRINT('error, el empleado modificado no es jefe de ningun otro empleado')
		IF (@salario_jefe) <= (0.2*dbo.suma_salarios_subordinados(@jefe)) OR (SELECT count(*) FROM Empleado WHERE empl_jefe=@jefe)=0
			UPDATE Empleado SET empl_salario=@salario_jefe WHERE empl_codigo=@jefe
		ELSE
			PRINT('error, el salario del empleado modificado supera el 20% de la suma del salario de sus subordinados')

		FETCH NEXT FROM c13b INTO @jefe, @salario_jefe
	END
	CLOSE c13b
	DEALLOCATE c13b
END

GO

-- chequeo si la funcion devuelve el valor de salario correcto
SELECT SUM(empl_salario) FROM Empleado WHERE empl_jefe = 1
SELECT SUM(empl_salario) FROM Empleado WHERE empl_jefe = 2
SELECT SUM(empl_salario) FROM Empleado WHERE empl_jefe = 3
SELECT dbo.suma_salarios_subordinados(1)

SELECT * FROM Empleado
WHERE empl_codigo = 3

UPDATE Empleado
SET empl_salario = 10500
WHERE empl_codigo = 3
*/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
14)
Agregar el/los objetos necesarios para que si un cliente compra un producto
compuesto a un precio menor que la suma de los precios de sus componentes
que imprima la fecha, que cliente, que productos y a qué precio se realizó la
compra. No se deberá permitir que dicho precio sea menor a la mitad de la suma
de los componentes.
*/

--voy a usar [Valor_Comps_Combo(@producto)] creada para el ejercicio 8

ALTER TRIGGER ejercicio_14 ON Item_Factura INSTEAD OF INSERT
AS
BEGIN
	DECLARE @tipo char(1)
	DECLARE @sucursal char(4)
	DECLARE @numero char(8)
	DECLARE @producto char(8)
	DECLARE @precio decimal(12,2)
	DECLARE @cantidad decimal(12,2)


	DECLARE c14 CURSOR FOR SELECT item_producto FROM inserted
	OPEN c14
	FETCH NEXT FROM c14 INTO @tipo, @sucursal,@numero, @producto, @precio, @cantidad
	WHILE(@@FETCH_STATUS=0)
		BEGIN
			if(select count(*) FROM Composicion where comp_producto=@producto)>0
			BEGIN
				IF(@precio < dbo.Valor_Comps_Combo(@producto)*0.5 )
					BEGIN
						PRINT('El precio del combo no puede ser menos que la mitad de la suma de sus componentes')
						--porque sino ejecuta el insert (necesario en esa posicion para poder agregar los items que no son combo)
						FETCH NEXT FROM c14 INTO @tipo, @sucursal,@numero, @producto, @precio, @cantidad
						CONTINUE
					END
				ELSE 
					BEGIN
						IF (@precio < dbo.Valor_Comps_Combo(@producto))
							BEGIN
							DECLARE @fecha datetime
							SET @fecha = (SELECT fact_fecha FROM Factura WHERE @numero+@sucursal+@tipo=fact_numero+fact_sucursal+fact_tipo)
							DECLARE @cliente char(6)
							SET @cliente = (SELECT fact_cliente FROM Factura WHERE @numero+@sucursal+@tipo=fact_numero+fact_sucursal+fact_tipo)
							PRINT('Fecha: '+@fecha+' cliente: '+STR(@cliente)+' producto: '+STR(@producto)+' precio: '+STR(@precio))
							END
					END
					--PRINT('El precio del combo es mayor o igual a la suma del precio de sus componentes')
				insert item_factura (item_tipo, item_sucursal, item_numero, item_producto, item_cantidad, item_precio)
				values (@tipo, @sucursal, @numero, @producto,@cantidad,@precio)

				FETCH NEXT FROM c14 INTO @tipo, @sucursal,@numero, @producto, @precio, @cantidad
			END
		END
	CLOSE c14
	DEALLOCATE c1
END
GO 

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
15)
Cree el/los objetos de base de datos necesarios para que el objeto principal
reciba un producto como parametro y retorne el precio del mismo.
Se debe prever que el precio de los productos compuestos sera la sumatoria de
los componentes del mismo multiplicado por sus respectivas cantidades. No se
conocen los nivles de anidamiento posibles de los productos. Se asegura que
nunca un producto esta compuesto por si mismo a ningun nivel. El objeto
principal debe poder ser utilizado como filtro en el where de una sentencia
select.
*/

ALTER FUNCTION Valor_Comps_Combo(@producto char(8))
RETURNS decimal(12,2)
AS
BEGIN
	DECLARE @valor decimal(12,2)	
	SET @valor = (SELECT SUM(dbo.Valor_Comps_Combo(comp_componente) * comp_cantidad) FROM Composicion WHERE comp_producto = @producto)
	--Solo suma los valores de los componentes, cuando estos no son composiciones de otros productos(que pasa cuando @valor IS NULL ya que
	-- en la busqueda de arriba, busca un comp_producto=@producto, y como no existe => @valor se setea en NULL)
	IF(@valor IS NULL)
		SET @valor = (SELECT prod_precio FROM Producto WHERE prod_codigo = @producto)
	RETURN @valor
END 
GO


ALTER FUNCTION ejercicio_15 (@producto char(8))
RETURNS decimal(12,2)
AS
BEGIN
	declare @precio decimal(12,2) 

	IF EXISTS (SELECT * FROM Composicion WHERE comp_producto=@producto)
		SET @precio = dbo.Valor_Comps_Combo(@producto)
	ELSE
		SET @precio = (SELECT prod_precio FROM Producto WHERE prod_codigo=@producto)
	
	RETURN @precio
END

GO


-- prueba composicion
SELECT comp_producto, comp_componente, dbo.ejercicio_15(comp_producto), comp_cantidad, P1.prod_precio 'precio combo', P2.prod_precio 'precio componente'
FROM Composicion JOIN Producto P1 ON P1.prod_codigo = comp_producto JOIN Producto P2 ON P2.prod_codigo = comp_componente

-- prueba productos
SELECT TOP (10) *, dbo.ejercicio_15(prod_codigo)  FROM Producto
GO 

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
16)
Desarrolle el/los elementos de base de datos necesarios para que ante una venta
automaticamante se descuenten del stock los articulos vendidos. Se descontaran
del deposito que mas producto poseea y se supone que el stock se almacena
tanto de productos simples como compuestos (si se acaba el stock de los
compuestos no se arman combos)
En caso que no alcance el stock de un deposito se descontara del siguiente y asi
hasta agotar los depositos posibles. En ultima instancia se dejara stock negativo
en el ultimo deposito que se desconto.

*/


CREATE TRIGGER ejercicio_16 ON Item_Factura FOR INSERT
AS
BEGIN
	declare @producto char(8), @cantidad decimal(12,2), @deposito char(2), @ultimo_deposito char(2), @stock decimal(12,2)

	declare citem cursor for select item_producto, item_cantidad from Item_Factura
	open citem
	fetch next from citem into @producto, @cantidad
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS(select * from Composicion where comp_producto=@producto)
			BEGIN 
				declare @componente char(8), @cantcomp decimal(12,2)
                declare @depo_cantidad decimal(12,2)
                declare c_comp cursor for select comp_componente, comp_cantidad*@cantidad from Composicion where comp_producto = @producto
                open c_comp 
                fetch next from c_comp into @componente, @cantcomp
                while @@FETCH_STATUS = 0
                begin 
                    declare c_deposito cursor for select stoc_deposito, stoc_Cantidad  from stock where @componente = stoc_producto
                    and stoc_cantidad > 0 order by stoc_cantidad desc
                    open c_deposito 
                    fetch next from c_deposito into @deposito, @depo_cantidad
                    while @@FETCH_STATUS = 0 and @cantidad > 0
                    begin 
                        if @depo_cantidad >= @cantidad
                            begin 
                                update stock set stoc_cantidad = stoc_cantidad - @cantidad where stoc_producto = @componente
                                and stoc_deposito = @deposito
                                select @cantidad = 0
                            end                                
                        else 
                            begin 
                                update stock set stoc_cantidad = stoc_cantidad - @depo_cantidad where stoc_producto = @componente
                                and stoc_deposito = @deposito
                                select @ultimo_deposito = @deposito
                                select @cantidad = @cantidad - @depo_cantidad
                            end                                
                        fetch next from c_deposito into @deposito, @depo_cantidad
                    end 
                    update stock set stoc_cantidad = stoc_cantidad - @depo_cantidad where stoc_producto = @componente
                    and stoc_deposito = @ultimo_deposito
                    close c_deposito
                    deallocate c_deposito
                end
			END
		ELSE
			BEGIN 
				declare cstock cursor for select stoc_deposito, stoc_cantidad FROM STOCK where stoc_deposito=@producto and 
											stoc_cantidad > 0 order by stoc_cantidad desc
				open cstock
				fetch next from cstock into @deposito, @stock
				WHILE @@FETCH_STATUS = 0 and @cantidad > 0
				BEGIN
					set @ultimo_deposito=@deposito
					IF (@cantidad <= @stock)
						BEGIN
						update STOCK set stoc_cantidad = (stoc_cantidad-@cantidad) where stoc_deposito=@deposito and stoc_producto=@producto
						set @cantidad = 0
						END
					ELSE
						BEGIN
						update STOCK set stoc_cantidad = (stoc_cantidad-@cantidad) where stoc_deposito=@deposito and stoc_producto=@producto
						set @cantidad = @cantidad - @stock
						END
					fetch next from cstock into @deposito, @stock
				END
				IF (@cantidad>0)
					update STOCK set stoc_cantidad = (stoc_cantidad-@cantidad) where stoc_deposito=@ultimo_deposito and stoc_producto=@producto

				close cstock
				deallocate cstock
			END

		fetch next from citem into @producto, @cantidad
	END
	close citem
	deallocate citem
END
GO 

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
17)
Sabiendo que el punto de reposicion del stock es la menor cantidad de ese objeto
que se debe almacenar en el deposito y que el stock maximo es la maxima
cantidad de ese producto en ese deposito, cree el/los objetos de base de datos
necesarios para que dicha regla de negocio se cumpla automaticamente. No se
conoce la forma de acceso a los datos ni el procedimiento por el cual se
incrementa o descuenta stock
*/

CREATE TRIGGER ejercicio_17 ON STOCK FOR insert, update
AS
BEGIN
	IF EXISTS (SELECT * FROM inserted WHERE stoc_cantidad<stoc_punto_reposicion OR stoc_cantidad>stoc_stock_maximo)
		BEGIN
			print('NO SE PUEDEN INGRESAR LOS ELEMENTOS PORQUE NO SE CUMPLE LA REGLA DEL STOCK')
			ROLLBACK
		END
END
GO

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
18)
Sabiendo que el limite de credito de un cliente es el monto maximo que se le
puede facturar mensualmente, cree el/los objetos de base de datos necesarios
para que dicha regla de negocio se cumpla automaticamente. No se conoce la
forma de acceso a los datos ni el procedimiento por el cual se emiten las facturas

*/

--Mi version
CREATE TRIGGER ejercicio_18 ON Factura FOR insert
AS
BEGIN
	IF EXISTS(SELECT * FROM inserted i JOIN Cliente ON fact_cliente=clie_codigo 
				WHERE clie_limite_credito<(select sum(fact_total) from Factura 
											where fact_cliente=i.fact_cliente and month(fact_fecha)=month(i.fact_fecha) and year(fact_fecha)=year(i.fact_fecha)))
											-- '+i.fact_total' no se suma porque com oes AFTER, ya forma parte de NUESTRA tabla factura (nuestra sesion)
											-- si fuera INSTEAD OF si habria que sumarlo
		BEGIN
			print('EL CLIENTE SUPERA SU LIMITE DE CREDITO MENSUAL')
			ROLLBACK
		END
END
GO

--Reinosa
/*create trigger ejercicio_18 on factura for insert
as 
begin 
    if exists (select * from inserted i join cliente on clie_codigo = fact_cliente where clie_limite_Credito < 
            (select sum(fact_total) from factura where i.fact_cliente = fact_cliente and year(i.fact_fecha) = year(fact_fecha)
                    and month(i.fact_fecha) = month(fact_fecha)))
    BEGIN
        print 'ALGUNO DE LOS CLIENTES SUPERA EL LIMITE DE CREDITO'
        ROLLBACK
    END
end 
GO 
*/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
19) -NO EMPEZADO-
Cree el/los objetos de base de datos necesarios para que se cumpla la siguiente
regla de negocio automáticamente “Ningún jefe puede tener menos de 5 años de
antigüedad y tampoco puede tener más del 50% del personal a su cargo
(contando directos e indirectos) a excepción del gerente general”. Se sabe que en
la actualidad la regla se cumple y existe un único gerente general
*/
-- Para calcular el año actual (ultimo año en el que se realizaron ventas)
create FUNCTION dbo.ultimo_año()
RETURNS smalldatetime
AS
BEGIN
	declare @fecha smalldatetime
	select TOP 1 @fecha = YEAR(fact_fecha) from Factura group by YEAR(fact_fecha) order by YEAR(fact_fecha) DESC
	return @fecha
end
go

create function dbo.empleados_del_jefe (@empl numeric(6,0))
returns decimal(12,0)
as 
begin
	declare @cant_empleados decimal(12,0), @cant_empl_indirectos decimal(12,0)
	set @cant_empl_indirectos = 0

	if not exists (select empl_codigo from Empleado where empl_jefe = @empl)
		return @cant_empl_indirectos

	declare @cod_empl numeric(6,0)
	declare cursor_empleados cursor for (select empl_codigo from Empleado where empl_jefe = @empl)

	open cursor_empleados
	fetch next from cursor_empleados into @cod_empl
	set @cant_empleados = 0
	while @@FETCH_STATUS = 0
	begin
		set @cant_empl_indirectos = dbo.empleados_del_jefe(@cod_empl)
		if(@cant_empl_indirectos) = 0
			set @cant_empleados = @cant_empleados + 1
		else
			set @cant_empleados = @cant_empleados + @cant_empl_indirectos + 1 --Este 1 es para contar al empl_jefe que tiene empl a cargo
		fetch next from cursor_empleados into @cod_empl
	end
	close cursor_empleados
	deallocate cursor_empleados
	return @cant_empleados 
end
go

create trigger t_ej19 on Empleado instead of insert, update
as
begin
	if exists (select * from inserted where year(empl_ingreso) <= dbo.ultimo_año()-5
				and dbo.empleados_del_jefe(empl_codigo) > 0 
				and dbo.empleados_del_jefe(empl_codigo) > (0.5*(select count(empl_codigo) from Empleado)-1)
				and empl_jefe is not null)
	begin
		print 'No se puede agregar el jefe ya que no cumple la regla'
		ROLLBACK
	end
end
go




---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
20) -NO EMPEZADO-
Crear el/los objeto/s necesarios para mantener actualizadas las comisiones del
vendedor.
El cálculo de la comisión está dado por el 5% de la venta total efectuada por ese
vendedor en ese mes, más un 3% adicional en caso de que ese vendedor haya
vendido por lo menos 50 productos distintos en el mes.

*/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
21) -NO EMPEZADO-
Desarrolle el/los elementos de base de datos necesarios para que se cumpla
automaticamente la regla de que en una factura no puede contener productos de
diferentes familias. En caso de que esto ocurra no debe grabarse esa factura y
debe emitirse un error en pantalla.
*/

create trigger ejercicio_21 on Factura for insert
as
begin
	if exists (select * from inserted 
					join Item_Factura IT1 on fact_numero+fact_sucursal+fact_tipo = IT1.item_numero+IT1.item_sucursal+IT1.item_tipo
					join Item_Factura IT2 on fact_numero+fact_sucursal+fact_tipo = IT2.item_numero+IT2.item_sucursal+IT2.item_tipo
					join Producto P1 on IT1.item_producto = P1.prod_codigo
					join Producto P2 on IT2.item_producto = P2.prod_codigo
					where it2.item_producto > it1.item_producto
						and p2.prod_familia > p1.prod_familia)
		begin
			delete item from Item_Factura as item join inserted on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo
			print 'Una factura no puede contener productos de distinta familia '
			ROLLBACK
		end
end
GO

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
22) -NO TERMINADO-
Se requiere recategorizar los rubros de productos, de forma tal que nigun rubro
tenga más de 20 productos asignados, si un rubro tiene más de 20 productos
asignados se deberan distribuir en otros rubros que no tengan mas de 20
productos y si no entran se debera crear un nuevo rubro en la misma familia con
la descirpción “RUBRO REASIGNADO”, cree el/los objetos de base de datos
necesarios para que dicha regla de negocio quede implementada.
*/

CREATE PROCEDURE ejercicio_22 
AS
BEGIN
	declare @producto char(8), @rubro char(4), @rubro_recat char(4), @ultimo_rubro_recat char(4), @espacio_recat INT--, @stock decimal(12,2)

	declare crubro cursor for select rubr_id from Rubro
	open crubro
	fetch next from crubro into @rubro
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (SELECT count(*) FROM Producto WHERE prod_rubro=@rubro)<=20
			PRINT('EL RUBRO '+@rubro+' NO NECESITA RECATEGORIZACION')
		ELSE
			BEGIN
				declare @exedente INT
				set @exedente = (SELECT count(*) FROM Producto WHERE prod_rubro=@rubro)-20

				declare crecateg cursor for select --COMP
				open crecateg
				fetch next from crecateg into @rubro_recat, @espacio_recat
				WHILE @@FETCH_STATUS = 0 and @exedente > 0
				BEGIN
					set @ultimo_rubro_recat=@rubro_recat
					/*IF (@cantidad <= @stock)
						BEGIN
						update STOCK set stoc_cantidad = (stoc_cantidad-@cantidad) where stoc_deposito=@deposito and stoc_producto=@producto
						set @cantidad = 0
						END
					ELSE
						BEGIN
						update STOCK set stoc_cantidad = (stoc_cantidad-@cantidad) where stoc_deposito=@deposito and stoc_producto=@producto
						set @cantidad = @cantidad - @stock
						END
					fetch next from crecateg into @deposito, @stock
					*/
				END
				/*IF (@cantidad>0)
					update STOCK set stoc_cantidad = (stoc_cantidad-@cantidad) where stoc_deposito=@ultimo_deposito and stoc_producto=@producto
				*/
				close crecateg
				deallocate crecateg
			END
				
		fetch next from crubro into @rubro
	END
	close crubro
	deallocate crubro
END
GO 

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
23) -REHACER-
Desarrolle el/los elementos de base de datos necesarios para que ante una venta
automaticamante se controle que en una misma factura no puedan venderse más
de dos productos con composición. Si esto ocurre debera rechazarse la factura.
*/

create trigger ejercicio_23 on Item_Factura for insert
as
begin
		DECLARE @PK_FACTURA CHAR(15)
	DECLARE c1 CURSOR
	FOR 
	SELECT item_tipo+item_sucursal+item_numero FROM inserted GROUP BY item_tipo+item_sucursal+item_numero

	OPEN c1
	FETCH NEXT FROM c1 INTO @PK_FACTURA
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF
		(SELECT COUNT(*) FROM Item_Factura 
		WHERE item_tipo+item_sucursal+item_numero = @PK_FACTURA 
			AND item_producto IN (SELECT comp_producto FROM Composicion)
		GROUP BY item_tipo+item_sucursal+item_numero) > 2
		BEGIN
			DELETE fact FROM Factura fact WHERE fact_tipo+fact_sucursal+fact_numero = @PK_FACTURA
			ROLLBACK
		END
		FETCH NEXT FROM c1 INTO @PK_FACTURA
	END
	CLOSE c1
	DEALLOCATE c1
end
go 


--MAL PLANTEADO, DEBE SER UN INSTEAD OF
/*CREATE TRIGGER ejercicio_23 ON Factura FOR insert, update
AS
BEGIN
	IF (SELECT count(*) FROM inserted 
				JOIN Item_Factura ON  fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
				JOIN Composicion ON item_producto=comp_producto)>2
		BEGIN
		PRINT('ERROR, NO PUEDEN VENDERSE MAS DE DOS PRODUCTOS CON COMPOSICION')
		ROLLBACK
		END
END*/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
24)
Se requiere recategorizar los encargados asignados a los depositos. Para ello
cree el o los objetos de bases de datos necesarios que lo resueva, 
1. teniendo en cuenta que un deposito no puede tener como encargado un empleado que
	pertenezca a un departamento que no sea de la misma zona que el deposito, 
2. si esto ocurre a dicho deposito debera asignársele el empleado con menos
	depositos asignados que pertenezca a un departamento de esa zona.
*/

CREATE PROCEDURE ejercicio_24 
AS
BEGIN
	declare @deposito char(2)

	declare cdepo cursor for select depo_codigo, depo_encargado from DEPOSITO
	open cdepo
	fetch next from cdepo into @deposito
	while @@FETCH_STATUS = 0
		BEGIN
			if EXISTS(SELECT * from DEPOSITO JOIN Empleado ON depo_encargado=empl_codigo JOIN Departamento ON empl_departamento=depa_codigo
							where depo_codigo=@deposito AND depo_zona=depa_zona)
				PRINT('EL ENCARGADO ACTUAL YA ESTA CORRECTAMENTE ASIGNADO EN EL DEPOSITO: '+@deposito)
			else
				BEGIN 
					declare @nuevoEncargado numeric(6,0)
					set @nuevoEncargado = (SELECT TOP(1) empl_codigo FROM Deposito RIGHT JOIN Empleado ON depo_encargado=empl_codigo JOIN Departamento ON empl_departamento=depa_codigo
												WHERE depa_zona = (SELECT depo_zona FROM DEPOSITO where depo_codigo=@deposito) 
												GROUP BY empl_codigo ORDER BY count(*) ASC)
					update DEPOSITO set depo_encargado=@nuevoEncargado where depo_codigo=@deposito
					PRINT('EL ENCARGADO DEL DEPOSITO: '+@deposito+' AHORA ES EL EMPLEADO: '+@nuevoEncargado)
				END

			fetch next from cdepo into @deposito, @encargado
		END
	close cdepo
	deallocate cdepo
END
GO

SELECT * FROM DEPOSITO

GO

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
25) -PODRIA HACERCE MEJOR-
Desarrolle el/los elementos de base de datos necesarios para que no se permita
que la composición de los productos sea recursiva, o sea, que si el producto A
compone al producto B, dicho producto B no pueda ser compuesto por el
producto A, hoy la regla se cumple.
*/

--Solo chequea que sea recursiva sobre el primer nivel
ALTER FUNCTION chequeo_combo_recursivo (@prodA char(8))
RETURNS INTEGER
AS 
BEGIN
	declare @prodB char(8), @rec_flag INTEGER
	set @rec_flag=0

	declare crec cursor for select comp_componente FROM Composicion where comp_producto=@prodA
	open crec
	fetch next from crec into @prodB
	while @@FETCH_STATUS=0 AND @rec_flag=0
	BEGIN
		if EXISTS(SELECT * FROM Composicion where comp_producto=@prodB AND comp_componente=@prodA)
			SET @rec_flag=1
		else
			set @rec_flag = dbo.chequeo_combo_recursivo(@prodB)
		fetch next from crec into @prodB
	END
	close crec
	deallocate crec
	RETURN @rec_flag
END
GO

CREATE TRIGGER ejercicio_25 ON Composicion FOR insert,update
AS
BEGIN
	IF EXISTS(SELECT * FROM inserted WHERE dbo.chequeo_combo_recursivo(comp_producto)=1)
		BEGIN
			PRINT('LA COMPOSICION NO ES POSIBLE DADO QUE ES RECURSIVA')
			ROLLBACK
		END
END
GO
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
26) -REHACER-
Desarrolle el/los elementos de base de datos necesarios para que se cumpla
automaticamente la regla de que una factura no puede contener productos que
sean componentes de otros productos. En caso de que esto ocurra no debe
grabarse esa factura y debe emitirse un error en pantalla.
*/

create trigger ejercicio_26 on Item_Factura instead of insert
as
begin
	declare @factura_anterior char(13)
	declare @item_numero char(8), @item_sucursal char(4), @item_tipo char(1)
	declare c1 cursor for select item_numero, item_sucursal, item_tipo from inserted 
							join Composicion on item_producto = comp_componente 
	
	open c1
	fetch next from c1 into @item_numero, @item_sucursal, @item_tipo
	while @@FETCH_STATUS = 0
	begin
		IF @item_numero+@item_sucursal+@item_tipo <> @factura_anterior	
			begin
				delete from Factura where fact_numero+fact_sucursal+fact_tipo = @item_numero+@item_sucursal+@item_tipo
				print 'LA FACTURA: '+@item_numero+@item_sucursal+@item_tipo+ 'NO CUMPLE REGLA'
				set @factura_anterior = @item_numero+@item_sucursal+@item_tipo 
			end		
		fetch next from c1 into @item_numero, @item_sucursal, @item_tipo
	end	 
	close c1 
	deallocate c1
	insert Item_Factura select I.* from inserted I join Composicion on I.item_producto <> comp_componente
end
go

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
27) -NO EMPEZADO-
Se requiere reasignar los encargados de stock de los diferentes depósitos. Para
ello se solicita que realice el o los objetos de base de datos necesarios para
asignar a cada uno de los depósitos el encargado que le corresponda,
entendiendo que el encargado que le corresponde es cualquier empleado que no
es jefe y que no es vendedor, o sea, que no está asignado a ningun cliente, se
deberán ir asignando tratando de que un empleado solo tenga un deposito
asignado, en caso de no poder se irán aumentando la cantidad de depósitos
progresivamente para cada empleado.
*/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
28) -NO EMPEZADO-
Se requiere reasignar los vendedores a los clientes. Para ello se solicita que
realice el o los objetos de base de datos necesarios para asignar a cada uno de los
clientes el vendedor que le corresponda, entendiendo que el vendedor que le
corresponde es aquel que le vendió más facturas a ese cliente, si en particular un
cliente no tiene facturas compradas se le deberá asignar el vendedor con más
venta de la empresa, o sea, el que en monto haya vendido más.
*/

-- se hace con un select case	

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
29) -IGUAL QUE EL 26, TIENE 1 PALABRA DISTINTA EL ENUN, PERO ES LO MISMO-
Desarrolle el/los elementos de base de datos necesarios para que se cumpla
automaticamente la regla de que una factura no puede contener productos que
sean componentes de diferentes productos. En caso de que esto ocurra no debe
grabarse esa factura y debe emitirse un error en pantalla.
*/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
30) 
Agregar el/los objetos necesarios para crear una regla por la cual un cliente no
pueda comprar más de 100 unidades en el mes de ningún producto, si esto
ocurre no se deberá ingresar la operación y se deberá emitir un mensaje “Se ha
superado el límite máximo de compra de un producto”. Se sabe que esta regla se
cumple y que las facturas no pueden ser modificadas.
*/

CREATE TRIGGER ejercicio_30 ON Item_Factura FOR insert
AS
BEGIN
	IF EXISTS(SELECT * FROM inserted i JOIN Factura f ON i.item_tipo+i.item_sucursal+i.item_numero=f.fact_tipo+f.fact_sucursal+f.fact_numero
					Where (SELECT SUM(item_cantidad) FROM Item_Factura JOIN Factura f2 ON item_tipo+item_sucursal+item_numero=f2.fact_tipo+f2.fact_sucursal+f2.fact_numero 
								Where year(fact_fecha) = year(f2.fact_fecha) AND month(fact_fecha) = month(f2.fact_fecha) AND item_producto=i.item_producto)>100)
		BEGIN
			PRINT('ALGUNO DE LOS PRODUCTOS SUPERA EL LIMITE DE 100 UNIDADES MENSUALES')
			ROLLBACK
		END
END
GO

--o utilizando INSTEAD OF(que para mi no es coherente con el enunciado)
/*
CREATE trigger ej30 on Item_Factura INSTEAD OF INSERT
AS
BEGIN
	declare @excedente int, @itemsVendidosEnElMes int

	declare @tipo char(1) ,@sucu char(4), @nro char(8), @producto char(8), @cantidad decimal(12,2), @fecha SMALLDATETIME, @cliente char(6)

	declare c1 cursor for select item_tipo,item_sucursal, item_numero, item_producto, item_cantidad, fact_fecha,fact_cliente
	from inserted JOIN Factura on item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero 
	order by item_tipo+item_sucursal+item_numero
	open c1
	fetch next from c1 into @tipo ,@sucu, @nro, @producto, @cantidad, @fecha, @cliente
	while @@FETCH_STATUS=0
	BEGIN
		SET @itemsVendidosEnElMes = dbo.ventasEnEseMes(@producto, @cliente,@fecha)
		
		IF (@itemsVendidosEnElMes + @cantidad) > 100
		BEGIN	
			SET @excedente = (@itemsVendidosEnELMes + @cantidad)-100
			
			DELETE FROM Item_Factura where item_tipo = @tipo and item_sucursal = @sucu AND item_numero = @nro
			DELETE FROM Factura where fact_tipo = @tipo AND fact_sucursal = @sucu AND fact_numero = @nro

			print('No se puede comprar mas del producto '+@producto+' se superaron las unidades por '+@excedente)
		END
	END
END

go 

CREATE FUNCTION dbo.ventasEnEseMes (@producto char(8),@cliente char (6),@fecha SMALLDATETIME) 
RETURNS int
AS
BEGIN
	declare @ventas int
	select @ventas = sum(item_cantidad) from Item_Factura
	JOIN Factura on item_numero+item_sucursal+item_tipo = fact_numero+fact_sucursal+fact_tipo 
	JOIN Cliente on clie_codigo = fact_cliente
	where @producto = item_numero and @cliente = fact_cliente and MONTH(@fecha) = MONTH(fact_fecha) and YEAR(@fecha) = YEAR(fact_fecha)
	RETURN @ventas
END
*/


---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
31) -NO EMPEZADO-
Desarrolle el o los objetos de base de datos necesarios, para que un jefe no pueda
tener más de 20 empleados a cargo, directa o indirectamente, si esto ocurre
debera asignarsele un jefe que cumpla esa condición, si no existe un jefe para
asignarle se le deberá colocar como jefe al gerente general que es aquel que no
tiene jefe.
*/

