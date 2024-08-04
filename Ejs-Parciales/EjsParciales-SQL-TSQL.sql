--============================== SQL ==============================--
/* 
Ej SQL 4/7/23 Turno mañana)

0. Realizar una consulta SQL que retorne para los 10 clientes que más compraron en el 2012 y que fueron atendidos por más de 3 vendedores !
distintos:
1. Apellido y Nombre del Cliente. !
2. Cantidad de Productos distintos comprados en el 2012. !
3. Cantidad de unidades compradas dentro del primer semestre del 2012. !

4a. El resultado deberá mostrar ordenado la cantidad de ventas descendente del 2012 de cada cliente, 
4b.	en caso de igualdad de ventas, ordenar por código de cliente.
*/

SELECT TOP(10) C1.clie_razon_social 'Nombre y Apellido Cliente',
	count(distinct I1.item_producto) 'Cant prods comprados 2012',
	(SELECT sum(I2.item_cantidad) FROM Factura F2 
		JOIN Item_Factura I2 ON F2.fact_tipo+F2.fact_sucursal+F2.fact_numero=I2.item_tipo+I2.item_sucursal+I2.item_numero
		WHERE year(F2.fact_fecha)=2012 AND DATEPART(QUARTER, F2.fact_fecha)=1 AND F2.fact_cliente=C1.clie_codigo)'Cant uni vendidas Q1 2012'
FROM Cliente C1 
JOIN Factura F1 ON C1.clie_codigo=F1.fact_cliente
JOIN Item_Factura I1 ON F1.fact_tipo+F1.fact_sucursal+F1.fact_numero=I1.item_tipo+I1.item_sucursal+I1.item_numero
WHERE year(F1.fact_fecha)=2012 
GROUP BY C1.clie_codigo, C1.clie_razon_social
HAVING count(distinct F1.fact_vendedor)>1
ORDER BY sum(F1.fact_total) DESC, count(distinct F1.fact_tipo+F1.fact_sucursal+F1.fact_numero) DESC, C1.clie_codigo

/*
SELECT clie_codigo, clie_razon_social, count(distinct F1.fact_numero), count(distinct F1.fact_vendedor)  FROM Cliente C1 --, count(distinct F1.fact_vendedor) , F1.fact_vendedor
JOIN Factura F1 ON C1.clie_codigo=F1.fact_cliente
JOIN Item_Factura I1 ON F1.fact_tipo+F1.fact_sucursal+F1.fact_numero=I1.item_tipo+I1.item_sucursal+I1.item_numero
WHERE year(F1.fact_fecha)=2012 
GROUP BY C1.clie_codigo, C1.clie_razon_social*/

/*AND (SELECT count(distinct F2.fact_vendedor) FROM Factura F2 where year(F2.fact_fecha)=2012 AND C1.clie_codigo=F2.fact_cliente)>1*/





/*
Ej SQL 4/7/23 Turno noche)

0. Realizar una consulta SQL que retorne para todas las zonas que tengan 3 (tres) o más depósitos. !
1. Detalle Zona !
2. Cantidad de Depósitos x Zona !
3. Cantidad de Productos distintos compuestos en sus depósitos !
4. Producto mas vendido en el año 2012 que tenga stock en al menos uno de sus depósitos. !
5. Mejor encargado perteneciente a esa zona (El que mas vendió en la historia).
6. El resultado deberá ser ordenado por monto total vendido del encargado descendiente.
*/

SELECT	Z0.zona_detalle 'Zona', 
		count(distinct depo_codigo) 'Depositos x zona',
		count(distinct comp_producto) 'Prods compuestos zona',
		isnull((SELECT TOP(1) P1.prod_codigo FROM Producto P1 JOIN STOCK S1 ON P1.prod_codigo=S1.stoc_producto JOIN DEPOSITO D1 ON S1.stoc_deposito=D1.depo_codigo
				JOIN Item_Factura I1 ON P1.prod_codigo=I1.item_producto 
				JOIN Factura F1 ON I1.item_tipo+I1.item_sucursal+I1.item_numero=F1.fact_tipo+F1.fact_sucursal+F1.fact_numero
				WHERE S1.stoc_cantidad > 0 AND D1.depo_zona=Z0.zona_codigo AND year(F1.fact_fecha)=2012
				GROUP BY P1.prod_codigo
				HAVING sum(S1.stoc_cantidad) > 0
				ORDER BY SUM(I1.item_cantidad) DESC), '-') 'Prod mas vendido 2012',
		isnull((SELECT TOP(1) CAST(empl_codigo AS nvarchar(1)) FROM Empleado E2 JOIN DEPOSITO DE2 ON E2.empl_codigo=DE2.depo_encargado
				JOIN Factura F2 ON empl_codigo=fact_vendedor 
				WHERE DE2.depo_zona=Z0.zona_codigo
				GROUP BY empl_codigo
				ORDER BY SUM(fact_total) DESC), '-') 'Mejor encargado'
FROM Zona Z0
JOIN DEPOSITO ON Z0.zona_codigo=depo_zona 
LEFT JOIN STOCK ON depo_codigo=stoc_deposito
LEFT JOIN Composicion ON stoc_producto=comp_producto
group by zona_codigo, zona_detalle
HAVING count(distinct depo_codigo) >=3

-- ver prod x depo
--SELECT distinct depo_codigo,depo_detalle, count(stoc_producto)'productos x deposito' FROM DEPOSITO LEFT JOIN STOCK ON depo_codigo=stoc_deposito GROUP BY depo_codigo,depo_detalle

--ver depos por empleado
--SELECT empl_codigo, count(*)'depos a su cargo' FROM Empleado JOIN DEPOSITO ON empl_codigo=depo_encargado group by empl_codigo	



/*
Ej SQL 22/11/22)

0. Realizar una consulta SQL que muestre aquellos productos que tengan 3 componentes a nivel producto y cuyos componentes tengan 2 rubros distintos.
De estos productos mostrar:
1. El código de producto.
2. El nombre del producto.
3. La cantidad de veces que fueron vendidos sus componentes en el 2012.
4. Monto total vendido del producto.
5. El resultado deberá ser ordenado por cantidad de facturas del 2012 en las cuales se vendieron los componentes.
*/

SELECT P1.prod_codigo, P1.prod_detalle
FROM Producto P1
JOIN Composicion C1 ON prod_codigo=C1.comp_producto 
JOIN Producto P2 ON C1.comp_componente=P2.prod_codigo
GROUP BY P1.prod_codigo, P1.prod_detalle 
HAVING count(distinct C1.comp_componente)=3 AND count(distinct P2.prod_rubro)>=2 

/*
Ej SQL 15/11/22)

0. Realizar una consulta SQL que permita saber los clientes que compraron todos los rubros disponibles del sistema en el 2012.
De estos clientes mostrar, siempre para el 2012:
1. El código del cliente !
2. Código de producto que en cantidades más compro. !
3. El nombre del producto del punto 2. !
4. Cantidad de productos distintos comprados por el cliente. !
5. Cantidad de productos con composición comprados por el cliente. !
6a. El resultado deberá ser ordenado por razón social del cliente alfabéticamente primero !
6b.	y luego, los clientes que compraron entre un
	20 % y 30% del total facturado en el 2012 primero, luego, los restantes
*/

SELECT  F1.fact_cliente 'Codigo Cliente', 
		(SELECT TOP(1) I2.item_producto FROM Item_Factura I2 JOIN Factura F2 ON I2.item_tipo+I2.item_sucursal+I2.item_numero=F2.fact_tipo+F2.fact_sucursal+F2.fact_numero
			where year(F2.fact_fecha)=2012 AND F1.fact_cliente=F2.fact_cliente 
			GROUP BY I2.item_producto ORDER BY count(I2.item_cantidad) DESC) 'Codigo Prod mas comprado',
		(SELECT TOP(1) P3.prod_detalle FROM Item_Factura I3 JOIN Factura F3 ON I3.item_tipo+I3.item_sucursal+I3.item_numero=F3.fact_tipo+F3.fact_sucursal+F3.fact_numero
			JOIN Producto P3 ON I3.item_producto = P3.prod_codigo
			where year(F3.fact_fecha)=2012 AND F1.fact_cliente=F3.fact_cliente 
			GROUP BY P3.prod_detalle ORDER BY count(I3.item_cantidad) DESC)'Detalle Prod mas comprado',
		count(distinct I1.item_producto)'Cant prods distintos comprados',
		isnull((SELECT SUM(I4.item_cantidad) FROM Item_Factura I4 
			JOIN Factura F4 ON I4.item_tipo+I4.item_sucursal+I4.item_numero=F4.fact_tipo+F4.fact_sucursal+F4.fact_numero
			where year(F4.fact_fecha)=2012 AND F1.fact_cliente=F4.fact_cliente
			AND I4.item_producto IN (SELECT DISTINCT comp_producto FROM Composicion)), 0)'Cant prods composicion comprados'
FROM Factura F1 
JOIN Item_Factura I1 ON I1.item_tipo+I1.item_sucursal+I1.item_numero=F1.fact_tipo+F1.fact_sucursal+F1.fact_numero
JOIN Producto P1 ON I1.item_producto=P1.prod_codigo
JOIN Cliente C1 ON F1.fact_cliente=C1.clie_codigo
WHERE year(fact_fecha)=2012
GROUP BY F1.fact_cliente,C1.clie_razon_social 
HAVING count(distinct P1.prod_rubro) = (SELECT count(*) FROM Rubro)
ORDER BY C1.clie_razon_social ASC -- falta segundo criterio ordenamiento, (SELECT ) DESC 


/*
Ej SQL 08/11/22)

0. Realizar una consulta SQL que permita saber si un cliente compro un producto en todos los meses del 2012.
Además, mostrar para el 2012:
1. El cliente !
2. La razón social del cliente !
3. El producto comprado !
4. El nombre del producto !
5. Cantidad de productos distintos comprados por el Cliente. !
6. Cantidad de productos con composición comprados por el cliente. !
7. El resultado deberá ser ordenado poniendo primero aquellos clientes que compraron más de 10 productos distintos en el 2012. !
*/

SELECT	F1.fact_cliente 'Codigo Cliente', 
		C1.clie_razon_social 'Razon Social Cliente',
		P1.prod_codigo 'Codigo Producto',
		P1.prod_detalle 'Detalle Producto',
		(SELECT count(distinct I2.item_producto) FROM Item_Factura I2 
			JOIN Factura F2 ON I2.item_tipo+I2.item_sucursal+I2.item_numero=F2.fact_tipo+F2.fact_sucursal+F2.fact_numero
			Where year(F2.fact_fecha)=2012 AND F2.fact_cliente=F1.fact_cliente) 'Cant Prod distintos comprados',
		isnull((SELECT sum(I3.item_cantidad) FROM Item_Factura I3 
			JOIN Factura F3 ON I3.item_tipo+I3.item_sucursal+I3.item_numero=F3.fact_tipo+F3.fact_sucursal+F3.fact_numero
			Where year(F3.fact_fecha)=2012 AND F3.fact_cliente=F1.fact_cliente 
			AND I3.item_producto IN (SELECT DISTINCT comp_producto FROM Composicion)),0) 'Cant combos comprados'
FROM Factura F1 
JOIN Item_Factura I1 ON I1.item_tipo+I1.item_sucursal+I1.item_numero=F1.fact_tipo+F1.fact_sucursal+F1.fact_numero
JOIN Producto P1 ON I1.item_producto=P1.prod_codigo
JOIN Cliente C1 ON F1.fact_cliente=C1.clie_codigo
WHERE year(fact_fecha)=2012
GROUP BY F1.fact_cliente, C1.clie_razon_social, P1.prod_codigo, P1.prod_detalle 
HAVING count(distinct month(F1.fact_fecha)) = 6
ORDER BY 5 DESC

--AUX
/*
SELECT fact_cliente, item_producto, fact_numero, item_cantidad FROM Factura JOIN Item_Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
where year(fact_fecha)=2012 AND fact_cliente='02110' AND item_producto IN (SELECT DISTINCT comp_producto FROM Composicion)

SELECT fact_cliente, sum(item_cantidad) FROM Factura JOIN Item_Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
where year(fact_fecha)=2012 AND fact_cliente='02110' AND item_producto IN (SELECT DISTINCT comp_producto FROM Composicion) GROUP BY fact_cliente

SELECT * FROM Item_Factura where item_numero='00095195'
*/


/*
Ej SQL 25/06/24)

0. Listado de aquellos productos cuyas ventas de lo que va en el año 2012 fueron superiores al 15% del 
	promedio de ventas de productos vendidos entre los años 2010 y 2011 !
En base a lo solicitado, armar una consulta que retorne:
1. Detalle del producto !
2. mostrar la leyenda "Popular" si dicho producto figura en más de 100 facturas realizadas en el 2012. Caso contrario, mostrar la leyenda "Sin interes" !
3. Cantidad de facturas en las que aparece el producto en año 2012. !
4. Código del cliente que más compró dicho producto en 2012. (en caso de existir más de un cliente, mostrar solamente el de menor codigo)
*/

SELECT	P1.prod_detalle'Detalle Producto',
		(SELECT 
			CASE 
				WHEN count(distinct F3.fact_tipo+F3.fact_sucursal+F3.fact_numero) > 100 THEN 'Popular'
				ELSE 'Sin interes'
			END 
		FROM Factura F3 JOIN Item_Factura I3 ON I3.item_tipo+I3.item_sucursal+I3.item_numero=F3.fact_tipo+F3.fact_sucursal+F3.fact_numero  
		WHERE year(F3.fact_fecha)=2012 AND I3.item_producto=P1.prod_codigo)'Popularidad',
		count(distinct F1.fact_tipo+F1.fact_sucursal+F1.fact_numero) 'Cant facts en la que está - 2012',
		(SELECT TOP(1) C4.clie_codigo FROM Cliente C4 JOIN Factura F4 ON C4.clie_codigo=F4.fact_cliente 
			JOIN Item_Factura I4 ON I4.item_tipo+I4.item_sucursal+I4.item_numero=F4.fact_tipo+F4.fact_sucursal+F4.fact_numero
			Where I4.item_producto=P1.prod_codigo AND year(F4.fact_fecha)=2012 GROUP BY C4.clie_codigo ORDER BY SUM(I4.item_cantidad) DESC, C4.clie_codigo) 'Cliente que mas compró'
FROM PRODUCTO P1 
JOIN Item_Factura I1 ON P1.prod_codigo=I1.item_producto 
JOIN Factura F1 ON I1.item_tipo+I1.item_sucursal+I1.item_numero=F1.fact_tipo+F1.fact_sucursal+F1.fact_numero
WHERE year(fact_fecha)=2012
GROUP BY P1.prod_codigo, P1.prod_detalle 
HAVING SUM(I1.item_cantidad*I1.item_precio)>(0.15*(SELECT avg(I2.item_cantidad*I2.item_precio) FROM Item_Factura I2 
														JOIN Factura F2 ON  I2.item_tipo+I2.item_sucursal+I2.item_numero=F2.fact_tipo+F2.fact_sucursal+F2.fact_numero
														WHERE year(fact_fecha)=2010 OR year(fact_fecha)=2011 ))

--SELECT count(distinct item_producto) FROM Item_Factura

GO
--============================== T-SQL ==============================--

/* 
Ej T-SQL 4/7/23 Turno mañana)

Realizar un stored procedure que reciba un código de producto y una
	fecha y devuelva la mayor cantidad de días consecutivos a partir de esa
	fecha que el producto tuvo al menos la venta de una unidad en el día, el
	sistema de ventas on line está habilitado 24-7 por lo que se deben evaluar
	todos los días incluyendo domingos y feriados.
*/

CREATE PROCEDURE ej_tsql_1 (@producto char(8), @fecha smalldatetime, @diasconsecutivos INTEGER OUTPUT)
AS
BEGIN
	Declare @auxFecha smalldatetime = @fecha
	SET @diasconsecutivos = 0
	WHILE(EXISTS(SELECT count(*) FROM Factura JOIN Item_Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
					WHERE item_producto=@producto AND fact_fecha=@auxFecha))
		BEGIN
			SET @diasconsecutivos = @diasconsecutivos + 1
			SET @auxFecha = DATEADD(day, 1, @auxFecha)
		END
END
GO

/* 
Ej T-SQL 4/7/23 Turno noche)

Actualmente el campo fact_ vendedor representa al empleado que vendió la factura. 
Implementar el/los objetos necesarios para respetar la 
	integridad referenciales de dicho campo suponiendo que no existe una
	foreign key entre ambos.
*/

CREATE TRIGGER ej_tsql_2 ON Empleado FOR delete
AS
BEGIN
	IF EXISTS(SELECT count(*) FROM deleted where empl_codigo IN (SELECT fact_vendedor FROM Factura group by fact_vendedor))
		BEGIN
			PRINT('ERROR, LA ELMIMINACION DE ALGUNO DE LOS ELEMENTOS NO CUMPLE CON LA INTEGRIDAD REFERENCIAL')
			ROLLBACK
		END
END
GO


/*
Ej SQL 22/11/22)

Implementar una regla de negocio en línea donde se valide que nunca
un producto compuesto pueda estar compuesto por componentes de
rubros distintos a el.
*/

CREATE TRIGGER ej_tsql_3 ON Composicion FOR insert, update
AS
BEGIN
	IF(EXISTS (SELECT count(*) FROM inserted i JOIN Producto P1 ON i.comp_producto=P1.prod_codigo JOIN Producto P2 ON i.comp_componente=P2.prod_codigo
					JOIN Rubro r1 ON P1.prod_rubro=r1.rubr_id JOIN Rubro r2 ON P2.prod_rubro=r2.rubr_id
					WHERE r1.rubr_id!=r2.rubr_id))
		BEGIN
			PRINT('ERROR, UN PRODUCTO NO PUEDE ESTAR COMPUESTO POR COMPONENTES DE RUBROS DISTINTOS A EL')
			ROLLBACK
		END
END

--AUX
SELECT P1.prod_codigo, P1.prod_detalle, r1.rubr_id, P2.prod_codigo, P2.prod_detalle, r2.rubr_id
FROM Composicion i JOIN Producto P1 ON i.comp_producto=P1.prod_codigo JOIN Producto P2 ON i.comp_componente=P2.prod_codigo
JOIN Rubro r1 ON P1.prod_rubro=r1.rubr_id JOIN Rubro r2 ON P2.prod_rubro=r2.rubr_id

GO

/*
Ej SQL 15/11/22) -NO EMPEZADO-

. Implementar una regla de negocio en línea que al realizar una venta (SOLO INSERCION) permita componer los productos descompuestos,
	es decir, si se guardan en la factura 2 hamb, 2 papas 2 gaseosas se deberá guardar en la factura 2 (DOS) combo1, 
	. Si 1 combo1 equivale a: 1 hamb. 1 papa y 1 gaseosa.

.Nota: Considerar que cada vez que se guardan los items, se mandan todos los productos de ese item a la vez, y no de manera parcial.
*/

CREATE TRIGGER ej_tsql_4 ON Item_Factura FOR INSERT
AS
BEGIN

END
GO

/*
Ej SQL 08/11/22) -NO EMPEZADO-

. Implementar una regla de negocio de validación en linea que permita implementar una lógica de control de precios en las ventas. 
. Se deberá poder seleccionar una lista de rubros y aquellos productos de los rubros 
	que sean los seleccionados no podrán aumentar por mes más de un 2%. 
. En caso que no se tenga referencia del mes anterior no validar dicha regla.
*/

CREATE TRIGGER ej_tsql_5 ON Producto FOR update
AS
BEGIN
	IF()
		BEGIN
			PRINT('ERROR, ALGUNO DE LOS PRODUCTOS ')
			ROLLBACK
		END
END
GO

/*
Ej SQL 25/06/24)

Realizar el o los objetos de base de datos que dado un código de producto y una
	fecha y devuelva la mayor cantidad de días consecutivos a partir de esa
	fecha que el producto tuvo al menos la venta de una unidad en el día, el
	sistema de ventas on line está habilitado 24-7 por lo que se deben evaluar
	todos los días incluyendo domingos y feriados.
*/

--OPCION 1 (desde la fecha dada en adelante, no necesariamente incluye al param)
CREATE FUNCTION sp_ventas_consecutivas_producto (@producto CHAR(8), @fecha smalldatetime)
RETURNS INTEGER
AS
BEGIN
	DECLARE @max_dias_consecutivos INTEGER
    DECLARE @fecha_venta smalldatetime
    DECLARE @fecha_anterior smalldatetime
    DECLARE @dias_consecutivos INTEGER

    SET @fecha_anterior = @fecha
    SET @dias_consecutivos = 0
    SET @max_dias_consecutivos = 0

    DECLARE cventas_producto CURSOR FOR
        SELECT f.fact_fecha FROM Factura f
        JOIN Item_Factura itm 
            ON itm.item_numero = f.fact_numero
            AND itm.item_sucursal = f.fact_sucursal
            AND itm.item_tipo = f.fact_tipo
        WHERE itm.item_producto = @producto
        AND f.fact_fecha > @fecha
        GROUP BY f.fact_fecha
        ORDER BY f.fact_fecha ASC
    
    OPEN cventas_producto
    FETCH NEXT FROM cventas_producto INTO @fecha_venta
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF (@fecha_venta = DATEADD(DAY, 1, @fecha_anterior))
            BEGIN
                SET @dias_consecutivos = @dias_consecutivos + 1      
            END
        ELSE
            BEGIN
                -- Analizamos los dias consecutivos y vemos si reemplazar el max
                IF (@max_dias_consecutivos < @dias_consecutivos)
                    BEGIN
                        SET @max_dias_consecutivos = @dias_consecutivos
                    END
                SET @dias_consecutivos = 0
            END
        SET @fecha_anterior = @fecha_venta
        FETCH NEXT FROM cventas_producto INTO @fecha_venta
    END
    CLOSE cventas_producto
    DEALLOCATE cventas_producto
	RETURN @max_dias_consecutivos
END
GO

--OPCION 2 (son los dias consecutivos contando incluyendo a la fecha dada)
CREATE FUNCTION ej_tsql_6 (@producto char(8), @fecha smalldatetime)
RETURNS INTEGER
AS
BEGIN
	declare @diasconsecutivos INTEGER
	Declare @auxFecha smalldatetime = @fecha
	SET @diasconsecutivos = 0
	WHILE(EXISTS(SELECT count(*) FROM Factura JOIN Item_Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
					WHERE item_producto=@producto AND fact_fecha=@auxFecha))
		BEGIN
			SET @diasconsecutivos = @diasconsecutivos + 1
			SET @auxFecha = DATEADD(day, 1, @auxFecha)
		END
	return @diasconsecutivos
END
GO


/*
Ej SQL 25/06/24) 

*/
/*******EJERCICIO 1*******/
select
	D.depo_codigo as 'Deposito'
	,D.depo_domicilio as 'Domicilio'
	,(select SUM(stoc_cantidad) 
		from Producto 
		join STOCK on prod_codigo = stoc_producto
		where stoc_deposito = D.depo_codigo
			and prod_codigo in (select comp_producto from Composicion)) as 'Prods_Compuestos'
	,(select SUM(stoc_cantidad) 
		from Producto 
		join STOCK on prod_codigo = stoc_producto
		where stoc_deposito = D.depo_codigo
			and prod_codigo not in (select comp_producto from Composicion)) as 'Prods_no_compuestos'
	,CASE WHEN ((select SUM(stoc_cantidad) 
				from Producto 
				join STOCK on prod_codigo = stoc_producto
				where stoc_deposito = D.depo_codigo
					and prod_codigo in (select comp_producto from Composicion))> (select SUM(stoc_cantidad) 
										from Producto 
										join STOCK on prod_codigo = stoc_producto
										where stoc_deposito = D.depo_codigo
											and prod_codigo not in (select comp_producto from Composicion)))
	THEN 'Mayoria Compuestos'
	ELSE 'Mayoria no compuestos' end as 'Compuestos_por'
	,(select top 1 empl_codigo from Empleado join Deposito on empl_codigo = depo_encargado order by empl_nacimiento asc)as 'Empleado_mas_joven'	
from DEPOSITO D
join STOCK S on D.depo_codigo = S.stoc_deposito
join Producto on S.stoc_producto = prod_codigo
group by D.depo_codigo, D.depo_domicilio
having COUNT(prod_codigo) between 0 and 1000

/*******EJERCICIO 2*******/
go

alter trigger ej2_Parcial on Factura after insert
as
begin
	declare @cliente_anterior char(6)
	declare @cliente char(6)
	declare c1 cursor for select fact_cliente
							from inserted
							join Item_Factura on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo
							join Producto on item_producto = prod_codigo
							where fact_total > 5000 
								and prod_rubro in (select rubr_id 
													from Rubro 
													where rubr_detalle like 'PILAS' or rubr_detalle like 'PASTILLAS'
														OR rubr_detalle like 'ARTICULOS DE TOCADOR')
	open c1
	fetch next from c1 into @cliente
	while @@FETCH_STATUS = 0
	begin
		if @cliente_anterior <> @cliente
			begin
				print 'Ud. accedera a un 5% de descuento del total de su proxima factura'
				set @cliente_anterior = @cliente
			end
		fetch next from c1 into @cliente
	end
	close c1
	deallocate c1
end
go