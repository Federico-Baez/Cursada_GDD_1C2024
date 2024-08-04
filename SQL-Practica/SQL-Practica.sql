/*
1)
Mostrar el código, razón social de todos los clientes cuyo límite de crédito sea mayor o
igual a $ 1000 ordenado por código de cliente.
*/

SELECT clie_codigo 'Codigo Cliente' 
      ,clie_razon_social 'Razon Social Cliente'
	  ,clie_limite_credito 'Limite Crediticio Cliente'
	FROM Cliente
	WHERE clie_limite_credito >= 1000
	ORDER BY clie_codigo

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
2)
Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados por
cantidad vendida.
*/

SELECT prod_codigo 'Codigo producto',
	   prod_detalle 'Detalle Producto',
	   sum(item_cantidad) 'Total Vendido'
	  FROM Producto 
	  JOIN Item_Factura ON prod_codigo = item_producto 
	  JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero 
	  WHERE YEAR(fact_fecha) = 2012
	  GROUP BY prod_codigo, prod_detalle
	  ORDER BY sum(item_cantidad) DESC

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
3)
Realizar una consulta que muestre código de producto, nombre de producto y el stock
total, sin importar en que deposito se encuentre, los datos deben ser ordenados por
nombre del artículo de menor a mayor.
*/

SELECT prod_codigo 'Codigo Producto', prod_detalle 'Nombre Producto', isnull(sum(stoc_cantidad),0) 'Total Stock'
FROM Producto LEFT JOIN STOCK ON prod_codigo=stoc_producto
GROUP BY prod_codigo, prod_detalle
ORDER BY prod_detalle

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
4)
Realizar una consulta que muestre para todos los artículos código, detalle y cantidad de
artículos que lo componen. Mostrar solo aquellos artículos para los cuales el stock
promedio por depósito sea mayor a 100.
*/

SELECT prod_codigo 'Codigo Producto', prod_detalle 'Detalle Producto',count(distinct comp_componente) 'Cantidad Componentes', AVG(stoc_cantidad) 'Stock promedio'
FROM Producto 
LEFT JOIN Composicion ON prod_codigo=comp_producto
JOIN STOCK ON prod_codigo=stoc_producto
GROUP BY prod_codigo, prod_detalle
HAVING AVG(stoc_cantidad) > 100

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
5)
Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos de
stock que se realizaron para ese artículo en el año 2012 (egresan los productos que
fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el 2011.
*/

SELECT prod_codigo 'Codigo Producto', prod_detalle 'Detalle Producto', sum(item_cantidad) 'Total Egresos'
FROM Producto  
JOIN Item_Factura ON prod_codigo=item_producto
JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero 
WHERE YEAR(fact_fecha) = 2012 
GROUP BY prod_codigo, prod_detalle
HAVING sum(item_cantidad) > (SELECT sum(item_cantidad)
							FROM Item_Factura JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero 
							WHERE YEAR(fact_fecha) = 2011 AND prod_codigo=item_producto)

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
6)
Mostrar para todos los rubros de artículos código, detalle, cantidad de artículos de ese
rubro y stock total de ese rubro de artículos. Solo tener en cuenta aquellos artículos que
tengan un stock mayor al del artículo ‘00000000’ en el depósito ‘00’.
*/

SELECT rubr_id 'Codigo Rubro'
      ,rubr_detalle 'Detalle Rubro'
	  , count( distinct prod_codigo) 'Cantidad de articulos Rubro'
	  , isnull(sum(stoc_cantidad),0) 'Cantidad de stock Rubro'
  FROM Rubro LEFT JOIN Producto ON rubr_id=prod_rubro JOIN STOCK ON prod_codigo=stoc_producto
  WHERE (SELECT sum(stoc_cantidad) FROM STOCK WHERE prod_codigo = stoc_producto) > (SELECT stoc_cantidad from STOCK WHERE stoc_deposito = '00' AND stoc_producto = '00000000')
  GROUP BY rubr_id, rubr_detalle
  ORDER BY 1

--ALTERNATIVA
/*  
SELECT rubr_id 'Codigo Rubro'
,rubr_detalle 'Detalle Rubro'
, count( distinct prod_codigo) 'Cantidad de articulos Rubro'
, isnull(sum(stoc_cantidad),0) 'Cantidad de stock Rubro'
FROM Rubro LEFT JOIN Producto ON rubr_id=prod_rubro JOIN STOCK ON prod_codigo=stoc_producto
WHERE prod_codigo IN 
(SELECT stoc_producto FROM STOCK GROUP BY stoc_producto 
HAVING SUM(stoc_cantidad) > (SELECT stoc_cantidad FROM STOCK WHERE stoc_producto = '00000000' AND stoc_deposito = '00'))
GROUP BY rubr_id, rubr_detalle
 */

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
7)
. Generar una consulta que muestre para cada artículo código, detalle, mayor precio
menor precio y % de la diferencia de precios (respecto del menor Ej.: menor precio =
10, mayor precio =12 => mostrar 20 %). Mostrar solo aquellos artículos que posean
stock.
*/

SELECT	prod_codigo 'Codigo producto', 
		prod_detalle 'Detalle Producto', 
		MIN(item_precio) 'Precio Minimo', 
		MAX(item_precio) 'Precio Maximo', 
		CONCAT(CAST( ((MAX(item_precio)-MIN(item_precio))*100)/MIN(item_precio) as decimal(8,2)),'%') 'Porcentaje'
  FROM Producto JOIN Item_Factura ON prod_codigo=item_producto JOIN STOCK ON prod_codigo=stoc_producto
  WHERE (SELECT sum(stoc_cantidad) FROM STOCK WHERE prod_codigo = stoc_producto) > 0
  GROUP BY prod_codigo, prod_detalle

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
8)
Mostrar para el o los artículos que tengan stock en todos los depósitos, nombre del
artículo, stock del depósito que más stock tiene.

*/

SELECT prod_detalle 'Detalle Producto', MAX(stoc_cantidad) 'Mayor Stock Deposito'
  FROM Producto JOIN STOCK ON prod_codigo=stoc_producto
  GROUP BY prod_codigo, prod_detalle
  HAVING COUNT(*) = (SELECT COUNT(*) FROM DEPOSITO)

/*
SELECT prod_detalle 'Detalle Producto', MAX(stoc_cantidad) 'Mayor Stock Deposito'
  FROM Producto JOIN STOCK ON prod_codigo=stoc_producto
  GROUP BY prod_codigo, prod_detalle
  HAVING prod_codigo IN (SELECT stoc_producto FROM STOCK GROUP BY stoc_producto HAVING MIN(stoc_cantidad)>0)
*/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
9)
Mostrar el código del jefe, código del empleado que lo tiene como jefe, nombre del
mismo y la cantidad de depósitos que ambos tienen asignados.
*/

SELECT empl_jefe 'Codigo Jefe', empl_codigo 'Codigo Empleado', COUNT(depo_encargado) 'Depositos Asignados Empleado + Jefe'
  FROM Empleado LEFT JOIN DEPOSITO ON (depo_encargado=empl_codigo OR depo_encargado=empl_jefe)
  GROUP BY empl_jefe, empl_codigo, empl_nombre


--NO HACER ESTO
/*SELECT empl_jefe 'Codigo Jefe', empl_codigo 'Codigo Empleado',
(SELECT COUNT(*) FROM DEPOSITO WHERE depo_encargado=empl_jefe) 'Depositos Asignados Jefe' ,
(SELECT COUNT(*) FROM DEPOSITO WHERE depo_encargado=empl_codigo)'Depositos Asignados Empleado' 
FROM Empleado*/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
10)
Mostrar los 10 productos más vendidos en la historia y también los 10 productos menos
vendidos en la historia. Además mostrar de esos productos, quien fue el cliente que
mayor compra realizo.

*/

SELECT prod_codigo 'Codigo Producto', prod_detalle 'Detalle producto', 
--(SELECT SUM(item_cantidad) FROM Item_Factura WHERE prod_codigo=item_producto) 'Total vendido',
(SELECT TOP(1) clie_codigo FROM Cliente JOIN Factura ON clie_codigo=fact_cliente JOIN Item_Factura ON fact_numero=item_numero WHERE prod_codigo=item_producto)
FROM Producto
WHERE prod_codigo IN 
(SELECT TOP(10) item_producto FROM Item_Factura GROUP BY item_producto ORDER BY SUM(item_cantidad) DESC)
OR prod_codigo IN
(SELECT TOP(10) item_producto FROM Item_Factura GROUP BY item_producto ORDER BY SUM(item_cantidad) ASC)


/*(SELECT TOP(10) prod_codigo, prod_detalle, SUM(item_precio*item_cantidad) 
FROM Producto JOIN Item_Factura ON prod_codigo = item_producto
GROUP BY prod_codigo, prod_detalle
ORDER BY SUM(item_precio*item_cantidad) DESC)
UNION ALL 
(SELECT TOP(10) prod_codigo, prod_detalle, SUM(item_precio*item_cantidad) 
FROM Producto JOIN Item_Factura ON prod_codigo = item_producto
GROUP BY prod_codigo, prod_detalle
ORDER BY SUM(item_precio*item_cantidad))*/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
11)
Realizar una consulta que retorne el detalle de la familia, la cantidad diferentes de
productos vendidos y el monto de dichas ventas sin impuestos. Los datos se deberán
ordenar de mayor a menor, por la familia que más productos diferentes vendidos tenga,
solo se deberán mostrar las familias que tengan una venta superior a 20000 pesos para
el año 2012.
*/

SELECT fami_detalle 'Detalle Familia' , count(distinct prod_codigo) 'Cantidad Productos'
FROM Familia JOIN Producto ON fami_id=prod_familia
WHERE prod_codigo IN (SELECT item_producto FROM Item_Factura GROUP BY item_producto)
GROUP BY fami_detalle
HAVING fami_detalle IN(SELECT fami_detalle FROM Familia
										JOIN Producto ON fami_id=prod_familia
										JOIN Item_Factura ON prod_codigo=item_producto
										JOIN Factura ON item_numero=fact_numero WHERE year(fact_fecha)=2012
										GROUP BY fami_detalle
										HAVING SUM(fact_total)>20000)
ORDER BY 2 DESC

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
12)
Mostrar nombre de producto, cantidad de clientes distintos que lo compraron importe
promedio pagado por el producto, cantidad de depósitos en los cuales hay stock del
producto y stock actual del producto en todos los depósitos. Se deberán mostrar
aquellos productos que hayan tenido operaciones en el año 2012 y los datos deberán
ordenarse de mayor a menor por monto vendido del producto.
*/

SELECT	prod_detalle 'Nombre Producto', 
		COUNT(distinct fact_cliente) 'Clientes Unicos', 
		AVG(item_precio) 'Precio Promedio',
		(SELECT COUNT(*) FROM STOCK WHERE stoc_producto=prod_codigo) 'Depositos con Stock',
		(SELECT SUM(stoc_cantidad) FROM STOCK WHERE stoc_producto=prod_codigo) 'Stock Total'
FROM Producto 
JOIN Item_Factura ON prod_codigo=item_producto 
JOIN Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero 
WHERE prod_codigo IN(SELECT item_producto FROM Item_Factura	
	JOIN Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero WHERE YEAR(fact_fecha) = 2012) 
GROUP BY prod_codigo, prod_detalle
ORDER BY SUM(item_precio) DESC

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
13)
Realizar una consulta que:
. retorne para cada producto que posea composición nombre del producto!, 
. precio del producto!, 
. [ precio de la sumatoria de los precios por la cantidadde los productos que lo componen(suma de los precios de sus componentes) ]. 
. Solo se deberán mostrar los productos que estén compuestos por más de 2 productos! 
. y deben ser ordenados de mayor a menor por cantidad de productos que lo componen!
*/

--Aclaracion, en realidad devuelve 0 filas, para el resultado correcto cambiar el >= por >

SELECT	P1.prod_detalle 'Nombre Producto',
		--count(distinct comp_componente) 'Cantidad Componentes', 
		P1.prod_precio 'Precio Composicion',
		SUM(comp_cantidad * P2.prod_precio) 'Suma de sus partes' 
FROM Producto P1
JOIN Composicion ON P1.prod_codigo=comp_producto
JOIN Producto P2 ON comp_componente=P2.prod_codigo
GROUP BY P1.prod_codigo, P1.prod_detalle,P1.prod_precio
HAVING count(distinct comp_componente) >= 2
ORDER BY count(distinct comp_componente) DESC

--Otro ejem para cerrar el concepto
/*
select ee.empl_nombre, ee. empl_apellido, ej .empl_nombre, ej .empl_apellido
from Empleado ee join empleado ej on ee.empl_jefe = ej .empl_codigo
*/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
14)
Escriba una consulta que retorne una estadística de ventas por cliente. Los campos que
debe retornar son:
Código del cliente!
Cantidad de veces que compro en el último año!
Promedio por compra en el último año!
Cantidad de productos diferentes que compro en el último año!
Monto de la mayor compra que realizo en el último año!
Se deberán retornar todos los clientes ordenados por la cantidad de veces que compro en el último año.!
No se deberán visualizar NULLs en ninguna columna!
*/

--Aclaracion: use como ultimo año 2012 para ver datos, realmente se debe usar el DATEADD(), para contar siempre 1 año atras desde que se ejecuta el select

SELECT	clie_codigo 'Codigo Cliente',
		count(distinct fact_numero) 'Compras ultimo año',
		(SELECT count(distinct item_producto) FROM Item_Factura JOIN Factura ON item_numero=fact_numero WHERE fact_cliente=clie_codigo) 'Productos dif comprados ultimo año',
		AVG(fact_total) 'Promedio compra ultimo año',
		MAX(fact_total) 'Monto mayor compra ultimo año'
FROM Cliente JOIN Factura ON clie_codigo=fact_cliente --JOIN Item_Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
WHERE year(fact_fecha) = 2012 --DATEADD(year, -1, GETDATE())
GROUP BY clie_codigo
UNION
SELECT clie_codigo, 0, 0, 0, 0 
FROM Cliente WHERE NOT EXISTS (SELECT fact_cliente FROM Factura 
WHERE fact_cliente = clie_codigo AND year(fact_fecha) = 2012) --DATEADD(year, -1, GETDATE())
ORDER BY count(distinct fact_numero) DESC

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
15) 
Escriba una consulta que retorne los pares de productos que hayan sido vendidos juntos
(en la misma factura) más de 500 veces. El resultado debe mostrar el código y
descripción de cada uno de los productos y la cantidad de veces que fueron vendidos
juntos. El resultado debe estar ordenado por la cantidad de veces que se vendieron
juntos dichos productos. Los distintos pares no deben retornarse más de una vez.
Ejemplo de lo que retornaría la consulta:
PROD1 DETALLE1 PROD2 DETALLE2 VECES
1731 MARLBORO KS 1 7 1 8 P H ILIPS MORRIS KS 5 0 7
1718 PHILIPS MORRIS KS 1 7 0 5 P H I L I P S MORRIS BOX 10 5 6 2
*/

--Ejem util para el 15
/*
select ee.empl_nombre, ee. empl_apellido, ej .empl_nombre, ej .empl_apellido
from Empleado ee join empleado ej on ee.empl_jefe = ej .empl_codigo
*/

SELECT	P1.prod_codigo 'Producto 1', 
		P1.prod_detalle 'Detalle 1', 
		P2.prod_codigo 'Producto 2', 
		P2.prod_detalle 'Detalle 2', 
		count(*) 'Veces'
FROM Producto P1 
JOIN Item_Factura I1 ON P1.prod_codigo=item_producto 
JOIN Producto P2 ON P1.prod_codigo!=P2.prod_codigo JOIN Item_Factura I2  ON P2.prod_codigo=I2.item_producto
WHERE I1.item_numero=I2.item_numero AND P1.prod_codigo>P2.prod_codigo
GROUP BY P1.prod_codigo, P1.prod_detalle, P2.prod_codigo, P2.prod_detalle
HAVING count(*)>500
ORDER BY count(*)

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
15) b) que es otra cosa muy distinta a lo que pide pero me gusto la resolucion

Escriba una consulta que retorne los pares de productos que hayan sido vendidos juntos
(en la misma factura) más de 500 veces. El resultado debe mostrar el código y
descripción de cada uno de los productos y la cantidad de veces que fueron vendidos
juntos. El resultado debe estar ordenado por la cantidad de veces que se vendieron
juntos dichos productos. Los distintos pares no deben retornarse más de una vez.
Ejemplo de lo que retornaría la consulta:
PROD1 DETALLE1 PROD2 DETALLE2 VECES
1731 MARLBORO KS 1 7 1 8 P H ILIPS MORRIS KS 5 0 7
1718 PHILIPS MORRIS KS 1 7 0 5 P H I L I P S MORRIS BOX 10 5 6 2
*/

--Ejem util para el 15
/*
select ee.empl_nombre, ee. empl_apellido, ej .empl_nombre, ej .empl_apellido
from Empleado ee join empleado ej on ee.empl_jefe = ej .empl_codigo
*/

/*
SELECT P1.prod_codigo, P1.prod_detalle,P2.prod_codigo, P2.prod_detalle, item_numero
FROM Producto P1 JOIN Item_Factura ON P1.prod_codigo=item_producto JOIN Producto P2 ON P1.prod_codigo!=P2.prod_codigo  --AND P1.prod_codigo!=P2.prod_codigo
*/

SELECT	P1.prod_codigo 'Producto 1', 
		P1.prod_detalle 'Detalle 1', 
		I1.item_numero, 
		I1.item_cantidad,
		P2.prod_codigo 'Producto 2', 
		P2.prod_detalle 'Detalle 2', 
		I2.item_numero, 
		I2.item_cantidad, 
		I1.item_cantidad+I2.item_cantidad 'Veces'
FROM Producto P1 
JOIN Item_Factura I1 ON P1.prod_codigo=item_producto 
JOIN Producto P2 ON P1.prod_codigo!=P2.prod_codigo JOIN Item_Factura I2  ON P2.prod_codigo=I2.item_producto
WHERE I1.item_numero=I2.item_numero AND I1.item_cantidad+I2.item_cantidad>500 AND P1.prod_codigo>P2.prod_codigo --AND P1.prod_codigo<>P2.prod_codigo

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
16)
Con el fin de lanzar una nueva campaña comercial para los clientes que menos compran
en la empresa, 
0. se pide una consulta SQL que retorne aquellos clientes cuyas compras son inferiores a 1/3 del promedio de ventas del producto que más se vendió en el 2012.
Además mostrar !
1. Nombre del Cliente!
2. Cantidad de unidades totales vendidas en el 2012 para ese cliente. !
3. Código de producto que mayor venta tuvo en el 2012 (en caso de existir más de 1,
mostrar solamente el de menor código) para ese cliente. !
Aclaraciones:
La composición es de 2 niveles, es decir, un producto compuesto solo se compone de
productos no compuestos.
4. Los clientes deben ser ordenados por código de provincia ascendente. !
*/


SELECT	clie_razon_social 'Nombre Cliente', 
		(SELECT SUM(fact_total) FROM Factura WHERE fact_cliente=clie_codigo) 'Total Compras Cliente', 
		SUM(item_cantidad)'Unidades Compradas Cliente',
		(SELECT TOP(1) item_producto FROM Item_Factura JOIN Factura  ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
			WHERE fact_cliente=clie_codigo AND year(fact_fecha) = 2012 GROUP BY item_producto ORDER BY SUM(item_precio*item_cantidad) DESC, item_producto ASC) 'Producto Mas Comprado'
FROM Cliente JOIN Factura ON clie_codigo=fact_cliente JOIN Item_Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
WHERE year(fact_fecha)=2012 AND (SELECT SUM(fact_total) FROM Factura WHERE fact_cliente=clie_codigo) 
< (SELECT TOP(1) AVG(item_precio*item_cantidad) FROM Item_Factura JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero WHERE year(fact_fecha) = 2012 GROUP BY item_producto ORDER BY 1 DESC)/3
GROUP BY clie_codigo, clie_razon_social, clie_domicilio 
ORDER BY clie_domicilio ASC


/*
SELECT clie_razon_social 'Nombre Cliente', SUM(fact_total) 'Total Compras Cliente'
FROM Cliente JOIN Factura ON clie_codigo=fact_cliente
GROUP BY clie_codigo, clie_razon_social 
ORDER BY 2 ASC

SELECT SUM(fact_total), clie_razon_social 
FROM Factura JOIN Item_Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero JOIN Cliente ON fact_cliente=clie_codigo
GROUP BY fact_cliente, clie_razon_social
ORDER BY 1 ASC*/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
17)
Escriba una consulta que retorne una estadística de ventas por año y mes para cada
producto.
La consulta debe retornar:
PERIODO: Año y mes de la estadística con el formato YYYYMM !
PROD: Código de producto !
DETALLE: Detalle del producto !
CANTIDAD_VENDIDA= Cantidad vendida del producto en el periodo !
VENTAS_AÑO_ANT= Cantidad vendida del producto en el mismo mes del periodo
pero del año anterior
CANT_FACTURAS= Cantidad de facturas en las que se vendió el producto en el
periodo
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
por periodo y código de producto.
*/

--Aclaracion: Intente con la funcion FORMAT para resolver la parte del mes del formato YYYYMM pero me hacia la consulta demasiado lenta

SELECT	CONCAT(YEAR(F1.fact_fecha), RIGHT('0' + RTRIM(MONTH(F1.fact_fecha)), 2)) 'YYYYMM',  --MONTH(F1.fact_fecha))
		prod_codigo 'PROD', 
		prod_detalle 'DETALLE', 
		SUM(item_cantidad) 'CANTIDAD_VENDIDA', 
		ISNULL((SELECT SUM(item_cantidad) 
		FROM Item_Factura 
		JOIN Factura F2 ON item_tipo+item_sucursal+item_numero=F2.fact_tipo+F2.fact_sucursal+F2.fact_numero
		WHERE item_producto=prod_codigo AND YEAR(F2.fact_fecha)+1=YEAR(F1.fact_fecha) AND MONTH(F2.fact_fecha)=MONTH(F1.fact_fecha)),0) 'VENTAS_AÑO_ANT',
		COUNT(*) 'CANT_FACTURAS'
FROM Producto 
JOIN Item_Factura ON prod_codigo=item_producto
JOIN Factura F1 ON item_tipo+item_sucursal+item_numero=F1.fact_tipo+F1.fact_sucursal+F1.fact_numero
GROUP BY YEAR(F1.fact_fecha), MONTH(F1.fact_fecha), prod_codigo, prod_detalle
ORDER BY 1, 2


/*
SELECT CONCAT(YEAR(fact_fecha),FORMAT(fact_fecha, 'MM')), item_producto 
FROM Factura JOIN Item_Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
WHERE CONCAT(YEAR(fact_fecha)+1,FORMAT(fact_fecha, 'MM')) = '201207'
*/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
18)
Escriba una consulta que retorne una estadística de ventas para 
0. todos los rubros. !
La consulta debe retornar:
1. DETALLE_RUBRO: Detalle del rubro !
2. VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro ! SUM(item_precio*item_cantidad)
3. PROD1: Código del producto más vendido de dicho rubro !
4. PROD2: Código del segundo producto más vendido de dicho rubro !
5. CLIENTE: Código del cliente que compro más productos del rubro en los últimos 30 días!
6. La consulta no puede mostrar NULL en ninguna de sus columnas ! 
7. y debe estar ordenada por cantidad de productos diferentes vendidos del rubro. 
*/

--Aclaracion: Para los clientes que mas compraron en los ultimos 30 dias la opcion correcta es la comentada, para visualizar datos saqué esa condicion deh WHERE

SELECT	rubr_detalle 'DETALLE_RUBRO',
		ISNULL(SUM(item_precio * item_cantidad),0) 'VENTAS',
		ISNULL((SELECT TOP (1) P1.prod_codigo FROM Producto P1 JOIN Item_Factura ON P1.prod_codigo=item_producto 
		WHERE P1.prod_rubro=rubr_id GROUP BY P1.prod_codigo ORDER BY SUM(item_precio*item_cantidad) DESC), '-') 'PROD1',
		ISNULL((SELECT TOP (1) P2.prod_codigo FROM Producto P2 JOIN Item_Factura ON P2.prod_codigo=item_producto 
		WHERE P2.prod_rubro=rubr_id AND P2.prod_codigo != (SELECT TOP (1) P4.prod_codigo FROM Producto P4 JOIN Item_Factura ON P4 .prod_codigo=item_producto 
		WHERE P4 .prod_rubro=rubr_id  GROUP BY P4.prod_codigo ORDER BY SUM(item_precio*item_cantidad) DESC) GROUP BY P2.prod_codigo ORDER BY SUM(item_precio*item_cantidad) DESC), '-') 'PROD2',
		ISNULL((SELECT TOP (1) fact_cliente 
			FROM Factura JOIN Item_Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero JOIN Producto P3 ON item_producto=P3.prod_codigo
			WHERE  P3.prod_rubro=rubr_id) --fact_fecha > DATEADD(day, -30, GETDATE()) AND 
			, '-') 'CLIENTE'
FROM Rubro 
LEFT JOIN PRODUCTO ON rubr_id=prod_rubro 
LEFT JOIN Item_Factura ON prod_codigo=item_producto 
LEFT JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
GROUP BY rubr_id, rubr_detalle
ORDER BY COUNT(distinct item_producto) DESC

--Alternativa para ver los ultimos 30 dias desde la ultima fecha registrada(que no creo que sea correcto)
--fact_fecha > (SELECT DATEADD(DAY, -30, MAX(fact_fecha)) FROM Factura) AND

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
19)
En virtud de una recategorizacion de productos referida a la familia de los mismos se
solicita que desarrolle una consulta sql que retorne para todos los productos:
1. Codigo de producto !
2. Detalle del producto !
3. Codigo de la familia del producto !
4. Detalle de la familia actual del producto !
5. Codigo de la familia sugerido para el producto
6. Detalla de la familia sugerido para el producto
7. La familia sugerida para un producto es la que poseen la mayoria de los productos cuyo detalle coinciden en los primeros 5 caracteres.
8. En caso que 2 o mas familias pudieran ser sugeridas se debera seleccionar la de menorcodigo. 
9. Solo se deben mostrar los productos para los cuales la familia actual sea diferente a la sugerida
10. Los resultados deben ser ordenados por detalle de producto de manera ascendente
*/


SELECT	P1.prod_codigo'Prod Codigo', 
		P1.prod_detalle'Prod Detalle', 
		P1.prod_familia'Familia Codigo', 
		F1.fami_detalle'Familia Detalle',
		(SELECT TOP (1) F2.fami_id
		FROM Producto P2 JOIN Familia F2 ON P2.prod_familia=F2.fami_id 
		WHERE LEFT(P1.prod_detalle,5)=LEFT(P2.prod_detalle,5) 
		GROUP BY F2.fami_id
		ORDER BY COUNT(F2.fami_id) DESC, F2.fami_id ASC
		)'Familia Sugerida Codigo',
		(SELECT TOP (1) F2.fami_detalle
		FROM Producto P2 JOIN Familia F2 ON P2.prod_familia=F2.fami_id 
		WHERE LEFT(P1.prod_detalle,5)=LEFT(P2.prod_detalle,5) 
		GROUP BY F2.fami_id, F2.fami_detalle
		ORDER BY COUNT(F2.fami_id) DESC, F2.fami_id ASC
		)'Familia Sugerida Codigo'
FROM Producto P1 JOIN Familia F1 ON P1.prod_familia=F1.fami_id
WHERE F1.fami_id != (SELECT TOP (1) F2.fami_id
		FROM Producto P2 JOIN Familia F2 ON P2.prod_familia=F2.fami_id 
		WHERE LEFT(P1.prod_detalle,5)=LEFT(P2.prod_detalle,5) 
		GROUP BY F2.fami_id
		ORDER BY COUNT(F2.fami_id) DESC, F2.fami_id ASC
		)
ORDER BY 2 ASC

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
20)
Escriba una consulta sql que retorne un ranking de los mejores 3 empleados del 2012
Se debera retornar 
1. legajo,  !
2. nombre y !
3. apellido, !
4. anio de ingreso, !
5. puntaje 2011, !
6. puntaje 2012. !
El puntaje de cada empleado se calculara de la siguiente manera: para los que
hayan vendido al menos 50 facturas el puntaje se calculara como la cantidad de facturas
que superen los 100 pesos que haya vendido en el año, para los que tengan menos de 50
facturas en el año el calculo del puntaje sera el 50% de cantidad de facturas realizadas
por sus subordinados directos en dicho año.
*/


SELECT TOP(3)	empl_codigo'Legajo', 
		empl_nombre'Nombre',
		empl_apellido'Apellido',
		year(empl_ingreso)'Año Ingreso',
		(SELECT 
			CASE 
				WHEN count(*) >= 50 THEN (SELECT COUNT(*) FROM Factura WHERE fact_vendedor=empl_codigo AND fact_total>100 AND year(fact_fecha)=2011)--SUM(CASE WHEN fact_total > 100 THEN 1 ELSE 0 END)
				ELSE 0.5 * (SELECT COUNT(*) FROM Factura JOIN Empleado Subordinado ON fact_vendedor = Subordinado.empl_codigo WHERE Subordinado.empl_jefe=empl_codigo)
			END as puntaje
		FROM Factura WHERE empl_codigo=fact_vendedor AND year(fact_fecha)=2011)'Puntaje 2011',
		(SELECT 
			CASE 
				WHEN count(*) >= 50 THEN (SELECT COUNT(*) FROM Factura WHERE fact_vendedor=empl_codigo AND fact_total>100 AND year(fact_fecha)=2012)--SUM(CASE WHEN fact_total > 100 THEN 1 ELSE 0 END)
				ELSE 0.5 * (SELECT COUNT(*) FROM Factura JOIN Empleado Subordinado ON fact_vendedor = Subordinado.empl_codigo WHERE Subordinado.empl_jefe=empl_codigo)
			END as puntaje
		FROM Factura WHERE empl_codigo=fact_vendedor AND year(fact_fecha)=2011)'Puntaje 2012'
FROM Empleado
ORDER BY 6 DESC, 5 DESC

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
21) -NO EMPEZADO-
Escriba una consulta sql que retorne para todos los años, en los cuales se haya hecho al
menos una factura, la cantidad de clientes a los que se les facturo de manera incorrecta
al menos una factura y que cantidad de facturas se realizaron de manera incorrecta. 
Se considera que una factura es incorrecta cuando la diferencia entre el total de la factura
menos el total de impuesto tiene una diferencia mayor a $ 1 respecto a la sumatoria de
los costos de cada uno de los items de dicha factura. Las columnas que se deben mostrar
son:
1. Año
2. Clientes a los que se les facturo mal en ese año
3. Facturas mal realizadas en ese año
*/

select YEAR(F1.fact_fecha) as 'Anio', COUNT(distinct F1.fact_cliente) as 'ClientesMalFacturados', count(*) as 'FacturasMalRealizadas'
from Factura F1
where (F1.fact_total - F1.fact_total_impuestos) - (select top 1 SUM(item_precio*item_cantidad) 
													from Item_Factura
													where F1.fact_numero+F1.fact_sucursal+F1.fact_tipo = item_numero+item_sucursal+item_tipo
													group by item_numero) > 1
group by year(F1.fact_fecha)

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*. 
22)
Escriba una consulta sql que retorne una estadistica de venta para todos los rubros por
trimestre contabilizando todos los años. Se mostraran como maximo 4 filas por rubro (1
por cada trimestre).
Se deben mostrar 4 columnas:
1. Detalle del rubro !
2. Numero de trimestre del año (1 a 4) !
3. Cantidad de facturas emitidas en el trimestre en las que se haya vendido al menos un producto del rubro !
4. Cantidad de productos diferentes del rubro vendidos en el trimestre !
5. El resultado debe ser ordenado alfabeticamente por el detalle del rubro y dentro de cada rubro primero el trimestre en el que mas facturas se emitieron. 1!
6. No se deberan mostrar aquellos rubros y trimestres para los cuales las facturas emitidas no superen las 100.
7. En ningun momento se tendran en cuenta los productos compuestos para esta estadistica !
*/

SELECT	rubr_detalle 'Detalle Rubro', 
		DATEPART(QUARTER, fact_fecha) 'Trimestre', 
		count(distinct fact_tipo+fact_sucursal+fact_numero) 'Cant Facts Emitidas', 
		count(distinct prod_codigo) 'Cant Prods Dif Vendidos' 
FROM Rubro 
JOIN Producto ON rubr_id=prod_rubro
JOIN Item_Factura ON prod_codigo=item_producto
JOIN Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
WHERE prod_codigo NOT IN (SELECT comp_producto FROM Composicion)
GROUP BY rubr_detalle, DATEPART(QUARTER, fact_fecha)
HAVING count(distinct fact_tipo+fact_sucursal+fact_numero) > 100
ORDER BY 1, 3 DESC

--SELECT * FROM Rubro WHERE rubr_detalle='ARTICULOS DE TOCADOR'

--SELECT prod_detalle, prod_rubro, fact_fecha FROM Item_Factura JOIN Producto  ON item_producto=prod_codigo JOIN Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero where prod_rubro = '0012'

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
23)
Realizar una consulta SQL que para cada año muestre :
1. Año !
2. El producto con composición más vendido para ese año. !
3. Cantidad de productos que componen directamente al producto más vendido !
4. La cantidad de facturas en las cuales aparece ese producto. !
5. El código de cliente que más compro ese producto. !
6. El porcentaje que representa la venta de ese producto respecto al total de venta del año. !
7. El resultado deberá ser ordenado por el total vendido por año en forma descendente. !
*/

SELECT	year(F1.fact_fecha) 'Año', 
		prod_codigo 'Combo mas vendido',
		(SELECT COUNT(*) FROM Composicion WHERE comp_producto=prod_codigo) 'Cant Componentes',
		count(distinct fact_tipo+fact_sucursal+fact_numero) 'Cant Facturas',
		(SELECT TOP(1) fact_cliente FROM Factura JOIN Item_Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero  
			where item_producto=prod_codigo group by fact_cliente order by sum(item_cantidad) DESC) 'Cliente que mas lo compro',
		CAST(SUM(item_cantidad*item_precio)*100/(SELECT SUM(fact_total) FROM Factura where year(fact_fecha)=year(F1.fact_fecha)) AS decimal(4,2))'Porcentual respecto a la venta total del año'
FROM Factura F1
JOIN Item_Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero 
JOIN Producto ON item_producto=prod_codigo
JOIN Composicion ON prod_codigo=comp_producto
WHERE prod_codigo = (SELECT TOP (1) comp_producto
		FROM Composicion
		JOIN Item_Factura ON comp_producto=item_producto
		JOIN Factura F2 ON F2.fact_tipo+F2.fact_sucursal+F2.fact_numero=item_tipo+item_sucursal+item_numero 
		WHERE year(F2.fact_fecha)= year(F1.fact_fecha)
		GROUP BY comp_producto
		ORDER BY (SELECT COUNT(*) FROM Item_Factura WHERE item_producto=comp_producto) DESC) 
GROUP BY year(fact_fecha), prod_codigo
ORDER BY (SELECT SUM(fact_total) FROM Factura where year(fact_fecha)=year(F1.fact_fecha)) DESC


-- muestra los prod vendidos por año con sus cantidades, siempre es el 1708
/*
SELECT	year(fact_fecha) 'Año', 
		count(distinct fact_tipo+fact_sucursal+fact_numero),
		prod_codigo,
		prod_detalle
		
FROM Factura 
JOIN Item_Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero 
JOIN Producto ON item_producto=prod_codigo
JOIN Composicion ON prod_codigo=comp_producto
GROUP BY year(fact_fecha), comp_producto, prod_codigo, prod_detalle
ORDER BY 1, 2 DESC
*/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
24)
0a. Escriba una consulta que considerando solamente las facturas correspondientes a los dos vendedores con mayores comisiones,
0b.	retorne los productos con composición facturados al menos en cinco facturas,

La consulta debe retornar las siguientes columnas:
1. Código de Producto !
2. Nombre del Producto !
3. Unidades facturadas !
4. El resultado deberá ser ordenado por las unidades facturadas descendente.

*/

-- solo se vendieron 5 composiciones distintas, la 00001104 no fue vendida 

SELECT prod_codigo 'Producto Codigo', prod_detalle 'Producto Detalle', SUM(item_cantidad) 'Unidades Facturadas' 
FROM Producto
JOIN Item_Factura ON prod_codigo=item_producto
JOIN Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
WHERE fact_vendedor IN (SELECT TOP(10) empl_codigo FROM Empleado ORDER BY empl_comision DESC)
GROUP BY prod_codigo, prod_detalle
HAVING prod_codigo IN (SELECT comp_producto FROM Composicion) AND count(*) >= 0
ORDER BY 3 DESC


--SELECT fact_tipo, fact_sucursal,fact_numero,item_producto, item_cantidad FROM Factura JOIN Item_Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
--WHERE item_producto='00001104'
--SELECT * FROM Empleado

/*
SELECT prod_codigo 'Producto Codigo', prod_detalle 'Producto Detalle', item_cantidad--, SUM(item_cantidad) 
FROM Producto
JOIN Item_Factura ON prod_codigo=item_producto
JOIN Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
WHERE fact_vendedor IN (SELECT TOP(10) empl_codigo FROM Empleado ORDER BY empl_comision DESC) 
	AND prod_codigo IN (SELECT comp_producto FROM Composicion) AND prod_codigo='00006402'
*/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/* 
25) -NO EMPEZADO-
Realizar una consulta SQL que para cada año y familia muestre :
a. Año
b. El código de la familia más vendida en ese año.
c. Cantidad de Rubros que componen esa familia.
d. Cantidad de productos que componen directamente al producto más vendido de
esa familia.
e. La cantidad de facturas en las cuales aparecen productos pertenecientes a esa
familia.
f. El código de cliente que más compro productos de esa familia.
g. El porcentaje que representa la venta de esa familia respecto al total de venta
del año.
El resultado deberá ser ordenado por el total vendido por año y familia en forma
descendente.

*/

select YEAR(F1.fact_fecha) as 'Anio' --a
	,P1.prod_familia as 'Familia_Mas_Vendida' --b
	,(select COUNT(distinct rubr_id) 
		from Producto
		JOIN Rubro ON rubr_id = prod_rubro
		where prod_familia = P1.prod_familia) as 'Cant_Rubros_EnFamilia' --c
	,COUNT(distinct fact_numero+fact_sucursal+fact_tipo) as 'Cant_Facturas' --d
	,ISNULL(0, (select SUM(comp_cantidad)
		From Composicion
		where comp_producto = (select top 1 prod_codigo 
								from Factura
								join Item_Factura on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo
								join Producto on item_producto = prod_codigo
								where prod_familia = P1.prod_familia and YEAR(fact_fecha) = YEAR(F1.fact_fecha)
								group by prod_codigo
								order by COUNT(distinct fact_numero+fact_sucursal+fact_tipo) desc))) as 'Cant_Prod_Componentes' --e
	,(select top 1 fact_cliente
		from Factura
		join Item_Factura on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo
		join Producto on item_producto = prod_codigo
		where prod_familia = P1.prod_familia and YEAR(fact_fecha) = YEAR(F1.fact_fecha)
		group by fact_cliente
		order by COUNT(distinct fact_numero+fact_sucursal+fact_tipo) desc) as 'Cliente_MasComprador' --f
	,RTRIM(count(distinct fact_numero+fact_sucursal+fact_tipo)*100/
			(select count(distinct fact_numero+fact_sucursal+fact_tipo) 
					from Factura
					join Item_Factura on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo
					join Producto on item_producto = prod_codigo
					where YEAR(fact_fecha) = year(F1.fact_fecha))) + '%' as '%_Venta' --g
from Factura F1
join Item_Factura on F1.fact_numero+F1.fact_sucursal+F1.fact_tipo = item_numero+item_sucursal+item_tipo
join Producto P1 on item_producto = P1.prod_codigo
group by year(F1.fact_fecha), P1.prod_familia
having P1.prod_familia in (select top 1 prod_familia 
							from Factura
							join Item_Factura on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo
							join Producto P1 on item_producto = P1.prod_codigo
							group by prod_familia 
							order by COUNT(fact_numero+fact_sucursal+fact_tipo) desc)
order by 1 desc, 5 desc

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
26)
. Escriba una consulta sql que retorne un ranking de empleados devolviendo las
siguientes columnas:
1. Empleado !
2. Depósitos que tiene a cargo !
3. Monto total facturado en el año corriente !
4. Codigo de Cliente al que mas le vendió !
5. Producto más vendido !
6. Porcentaje de la venta de ese empleado sobre el total vendido ese año. !
Los datos deberan ser ordenados por venta del empleado de mayor a menor.

*/

SELECT	empl_codigo 'Empleado', 
		(SELECT count(depo_codigo) FROM DEPOSITO WHERE depo_encargado=empl_codigo)'Depositos a Cargo', 
		isnull(sum(fact_total),0)'Total facturado año corriente',
		isnull((SELECT TOP(1) F2.fact_cliente FROM Factura F2
					WHERE fact_vendedor=empl_codigo AND year(F2.fact_fecha) = year(F1.fact_fecha) 
					GROUP BY F2.fact_cliente ORDER BY count(*)DESC), '-')'Clie al que mas le vendio',
		isnull((SELECT TOP(1) item_producto FROM Factura F3
					JOIN Item_Factura ON F3.fact_tipo+F3.fact_sucursal+F3.fact_numero=item_tipo+item_sucursal+item_numero 
					WHERE F3.fact_vendedor=empl_codigo AND year(F3.fact_fecha) = year(F1.fact_fecha)
					GROUP BY item_producto ORDER BY sum(item_cantidad)DESC), '-')'Prod mas vendido',
		CAST(isnull(sum(fact_total)*100/(SELECT SUM(fact_total) FROM Factura 
										WHERE year(fact_fecha) = year(F1.fact_fecha)), 0) AS decimal(4,2))'Porcentaje venta empl sobre total anual'
FROM Empleado 
LEFT JOIN Factura F1 ON empl_codigo=F1.fact_vendedor AND year(F1.fact_fecha) = 2012--year(GETDATE()) --2012 si se quieren ver montos dif a 0
GROUP BY empl_codigo, year(F1.fact_fecha)
ORDER BY 3 DESC

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
27)
Escriba una consulta sql que retorne una estadística basada en la facturacion por año y
envase devolviendo las siguientes columnas:
1. Año !
2. Codigo de envase !
3. Detalle del envase !
4. Cantidad de productos que tienen ese envase !
5. Cantidad de productos facturados de ese envase !
6. Producto mas vendido de ese envase (entiendo que en ese periodo) !
7. Monto total de venta de ese envase en ese año !
8. Porcentaje de la venta de ese envase respecto al total vendido de ese año
*/

SELECT	year(fact_fecha)'Año', 
		enva_codigo'Envase Codigo', 
		enva_detalle'Envase Detalle',
		(SELECT count(*) FROM Producto WHERE prod_envase=enva_codigo) 'Cant de prods con este envase',
		sum(item_cantidad)'Cant de prods facturados con este envase',
		(SELECT TOP(1) item_producto FROM Item_Factura JOIN Producto ON prod_codigo=item_producto
				JOIN Factura ON item_tipo+item_sucursal+item_numero =fact_tipo+fact_sucursal+fact_numero
				WHERE prod_envase=enva_codigo AND year(fact_fecha)=year(F1.fact_fecha) GROUP BY item_producto ORDER BY count(*))'Producto mas vendido',
		sum(item_cantidad*item_precio)'Monto total venta envase',
		--no me cierran estos porcentajes
		sum(item_cantidad*item_precio)*100/(SELECT SUM(item_precio*item_cantidad)FROM Factura 
												JOIN Item_Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
												WHERE year(fact_fecha)=year(F1.fact_fecha))'Porcentaje de venta sobre el total'
FROM Producto 
JOIN Envases ON prod_envase=enva_codigo
JOIN Item_Factura ON prod_codigo=item_producto
JOIN Factura F1 ON item_tipo+item_sucursal+item_numero=F1.fact_tipo+F1.fact_sucursal+F1.fact_numero
GROUP BY year(fact_fecha), enva_codigo, enva_detalle
ORDER BY 1,2

--SELECT * FROM PRODUCTO

--SELECT enva_codigo, enva_detalle, count(*) FROM Envases JOIN Producto on enva_codigo=prod_envase GROUP BY enva_codigo, enva_detalle
--SELECT * FROM Item_Factura WHERE item_producto='00000000'

/*
SELECT	F1.fact_tipo,F1.fact_sucursal,F1.fact_numero, F1.fact_total, item_producto, item_cantidad, item_precio
FROM Producto 
JOIN Envases ON prod_envase=enva_codigo
JOIN Item_Factura ON prod_codigo=item_producto
JOIN Factura F1 ON item_tipo+item_sucursal+item_numero=F1.fact_tipo+F1.fact_sucursal+F1.fact_numero
*/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
/*
28) -NO EMPEZADO-
. Escriba una consulta sql que retorne una estadística por Año y Vendedor que retorne las
siguientes columnas:
1. Año.
2. Codigo de Vendedor
3. Detalle del Vendedor
4. Cantidad de facturas que realizó en ese año
5. Cantidad de clientes a los cuales les vendió en ese año.
6. Cantidad de productos facturados con composición en ese año
7. Cantidad de productos facturados sin composicion en ese año.
8. Monto total vendido por ese vendedor en ese año
Los datos deberan ser ordenados por año y dentro del año por el vendedor que haya
vendido mas productos diferentes de mayor a menor.a de la empresa, o sea, el que en monto haya vendido más.
*/

select YEAR(F1.fact_fecha) as 'Anio'
	,F1.fact_vendedor as 'Vendedor'
	,rtrim(E1.empl_nombre)+ ' ' +rtrim(E1.empl_apellido) as 'Detalle'
	,COUNT(distinct F1.fact_numero+F1.fact_sucursal+F1.fact_tipo) as 'Cant_facturas'
	,(select COUNT(distinct fact_cliente)
		from Factura
		where YEAR(fact_fecha) = YEAR(F1.fact_fecha) and fact_vendedor = F1.fact_vendedor) as 'Cant_Clientes'
	,(select sum(item_cantidad)
		from Item_Factura 
		join Factura on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo
		where YEAR(fact_fecha) = YEAR(F1.fact_fecha) and fact_vendedor = F1.fact_vendedor and item_producto not in (select comp_producto from Composicion)
		) as 'Cant_prod_Scomp'
	,(select sum(item_cantidad)
		from Item_Factura 
		join Factura on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo
		where YEAR(fact_fecha) = YEAR(F1.fact_fecha) and fact_vendedor = F1.fact_vendedor and item_producto in (select comp_producto from Composicion)
		) as 'Cant_prod_Ccomp' -- Revisar, capaz debe dar el doble
	,(select SUM(fact_total)
		from Factura
		where fact_vendedor = F1.fact_vendedor and YEAR(fact_fecha) = YEAR(F1.fact_fecha)) as 'Monto_ventido'
from Empleado E1
left join Factura F1 on E1.empl_codigo = F1.fact_vendedor
join Item_Factura on F1.fact_numero+F1.fact_sucursal+F1.fact_tipo = item_numero+item_sucursal+item_tipo
group by  YEAR(F1.fact_fecha), F1.fact_vendedor, E1.empl_nombre, E1.empl_apellido
order by 1 desc, COUNT(distinct item_producto) desc


/*
29) -NO EMPEZADO-
. Se solicita que realice una estadística de venta por producto para el año 2011, solo para 
los productos que pertenezcan a las familias que tengan más de 20 productos asignados 
a ellas, la cual deberá devolver las siguientes columnas: 
a. Código de producto 
b. Descripción del producto 
c. Cantidad vendida 
d. Cantidad de facturas en la que esta ese producto 
e. Monto total facturado de ese producto 

Solo se deberá mostrar un producto por fila en función a los considerandos establecidos 
antes.  El resultado deberá ser ordenado por el la cantidad vendida de mayor a menor.
*/

select prod_codigo as 'Codigo'
	,prod_detalle as 'Detalle'
	,SUM(item_cantidad) as 'Cant_Vendida'
	,COUNT(fact_numero+fact_sucursal+fact_tipo) as 'Cant_facturas'
	,SUM(item_cantidad*item_precio) as 'Monto_total'
from Producto
join Item_Factura on prod_codigo = item_producto
join Factura on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo
where YEAR(fact_fecha) like '2011' 
	and prod_familia in (select fami_id 
						from Familia 
						join Producto on fami_id = prod_familia
						group by fami_id
						having count(prod_codigo) >= 20)
group by prod_codigo, prod_detalle
order by 3 desc


select prod_codigo 
from Producto
join Familia on fami_id = prod_familia
join Item_Factura on prod_codigo = item_producto
join Factura on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo
where YEAR(fact_fecha) like '2011' 
	and prod_familia in (select fami_id 
						from Familia 
						join Producto on fami_id = prod_familia
						group by fami_id
						having count(prod_codigo) >= 20)
order by 1 desc


/*
30) -NO EMPEZADO-
. Se solicita que realice una estadística de venta por producto para el año 2011, solo para 
los productos que pertenezcan a las familias que tengan más de 20 productos asignados 
a ellas, la cual deberá devolver las siguientes columnas: 
a. Código de producto 
b. Descripción del producto 
c. Cantidad vendida 
d. Cantidad de facturas en la que esta ese producto 
e. Monto total facturado de ese producto 

Solo se deberá mostrar un producto por fila en función a los considerandos establecidos 
antes.  El resultado deberá ser ordenado por el la cantidad vendida de mayor a menor.
*/

select 
	EJ2.empl_nombre as 'Jefe'
	,COUNT(distinct E1.empl_codigo) as 'Empleados_A_Cargo'
	,sum(fact_total) as 'Monto_Empleados'
	,COUNT(distinct fact_numero+fact_sucursal+fact_tipo) as 'Facturas_realizadas'
	,(select top 1 empl_nombre 
		from Empleado 
		join Factura on empl_codigo = fact_vendedor
		where YEAR(fact_fecha) = 2012 
			and empl_jefe = EJ2.empl_codigo
		group by empl_nombre
		order  by SUM(fact_total) desc) as 'Mejor_Empleado'
From Factura F1 
join Empleado E1 on E1.empl_codigo = F1.fact_vendedor
join Empleado EJ2 on EJ2.empl_codigo = E1.empl_jefe 
where YEAR(F1.fact_fecha) = 2012
group by EJ2.empl_nombre, EJ2.empl_codigo
having COUNT(distinct fact_numero+fact_sucursal+fact_tipo) > 10
order by 3 DESC

/*
31) -NO EMPEZADO-
. Escriba una consulta sql que retorne una estadística por Año y Vendedor que retorne las 
siguientes columnas: 
1. Año. !
2. Codigo de Vendedor !
3. Detalle del Vendedor !
4. Cantidad de facturas que realizó en ese año !
5. Cantidad de clientes a los cuales les vendió en ese año. !
6. Cantidad de productos facturados con composición en ese año 
7. Cantidad de productos facturados sin composicion en ese año. 
8. Monto total vendido por ese vendedor en ese año  !
Los datos deberan ser ordenados por año y dentro del año por el vendedor que haya 
vendido mas productos diferentes de mayor a menor. 
*/

SELECT	year(F1.fact_fecha) 'anio'
		, F1.fact_vendedor
		, empl_nombre
		, empl_apellido
		, count(distinct F1.fact_tipo+F1.fact_sucursal+F1.fact_numero)'cant facturas'
		, count(distinct F1.fact_cliente)'cant clientes distintos'
		, (SELECT sum(I2.item_cantidad) FROM Factura F2 
			JOIN Item_Factura I2 ON F2.fact_tipo+F2.fact_sucursal+F2.fact_numero=I2.item_tipo+I2.item_sucursal+I2.item_numero
			WHERE year(F2.fact_fecha)=year(F1.fact_fecha) AND
			F2.fact_vendedor=F1.fact_vendedor AND
			I2.item_producto IN (SELECT distinct(C2.comp_producto) FROM Composicion C2))'Productos con compo vendidos'
		, (SELECT sum(I3.item_cantidad) FROM Factura F3 
			JOIN Item_Factura I3 ON F3.fact_tipo+F3.fact_sucursal+F3.fact_numero=I3.item_tipo+I3.item_sucursal+I3.item_numero
			WHERE year(F3.fact_fecha)=year(F1.fact_fecha) AND
			F3.fact_vendedor=F1.fact_vendedor AND 
			I3.item_producto NOT IN (SELECT distinct(C2.comp_producto) FROM Composicion C2))'Productos sin compo vendidos'
		,
		(SELECT sum(F4.fact_total)FROM Factura F4 
			WHERE year(F4.fact_fecha)=year(F1.fact_fecha) AND F4.fact_vendedor=F1.fact_vendedor)'total facturado'  
FROM Factura F1 JOIN Empleado ON F1.fact_vendedor=empl_codigo
JOIN Item_Factura I1 ON F1.fact_tipo+F1.fact_sucursal+F1.fact_numero=I1.item_tipo+I1.item_sucursal+I1.item_numero
GROUP BY year(F1.fact_fecha),F1.fact_vendedor, empl_nombre, empl_apellido
ORDER BY 1, count(distinct I1.item_producto) DESC


--luca
/*
select
	year(F.fact_fecha) as 'Anio'
	,F.fact_vendedor as 'Vendedor'
	,RTRIM(E.empl_nombre)+' '+RTRIM(E.empl_apellido) AS 'Detalle'
	,count(distinct F.fact_numero+F.fact_sucursal+F.fact_tipo) as 'Cant_Facturas'
	,count(distinct F.fact_cliente) as 'Cant_Clientes'
	,(select sum(item_cantidad) from Factura 
		join Item_Factura on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo 
		join Composicion on item_producto = comp_producto 
		where year(F.fact_fecha) = year(fact_fecha)
			and F.fact_vendedor = fact_vendedor
			and item_producto in (select comp_producto from Composicion group by comp_producto)) AS 'Cant_Prod_Con_Composicion'
	,(select sum(item_cantidad) from Factura 
		join Item_Factura on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo 
		where year(F.fact_fecha) = year(fact_fecha)
			and F.fact_vendedor = fact_vendedor
			and item_producto not in (select comp_producto from Composicion group by comp_producto)) as 'Cant_Prod_Sin_Composicion'
	,sum(distinct F.fact_total) as 'Monto_total'
from Factura F 
join Empleado E on F.fact_vendedor = E.empl_codigo
join Item_Factura I on F.fact_numero+F.fact_sucursal+F.fact_tipo = I.item_numero+I.item_sucursal+I.item_tipo
group by year(F.fact_fecha), F.fact_vendedor, E.empl_nombre, E.empl_apellido
order by 1, count(distinct I.item_producto) desc 
*/


/*
32) -NO EMPEZADO-
. Se desea conocer las familias que sus productos se facturaron juntos en las mismas 
facturas para ello se solicita que escriba una consulta sql que retorne los pares de 
familias que tienen productos que se facturaron juntos.  Para ellos deberá devolver las 
siguientes columnas: 
1. Código de familia  
2. Detalle de familia 
3. Código de familia 
4. Detalle de familia  
5. Cantidad de facturas 
6. Total vendido 
Los datos deberan ser ordenados por Total vendido y solo se deben mostrar las familias 
que se vendieron juntas más de 10 veces. 
*/

select
	P1.prod_familia 'COD1',
	FAM1.fami_detalle 'DETALLE1',
	P2.prod_familia 'COD2',
	FAM2.fami_detalle 'DETALLE2',
	COUNT(distinct IF1.item_tipo+IF1.item_sucursal+IF1.item_numero) '# FACTURAS',
	SUM(IF1.item_precio*IF1.item_cantidad + IF2.item_precio*IF2.item_cantidad) 'TOTAL VENDIDO'
from Item_Factura IF1
JOIN Item_Factura IF2 ON IF2.item_tipo+IF2.item_sucursal+IF2.item_numero=IF1.item_tipo+IF1.item_sucursal+IF1.item_numero
JOIN Producto P1 ON P1.prod_codigo = IF1.item_producto
JOIN Producto P2 ON P2.prod_codigo = IF2.item_producto
JOIN Familia FAM1 ON FAM1.fami_id = P1.prod_familia
JOIN Familia FAM2 ON FAM2.fami_id = P2.prod_familia
	where IF1.item_producto > IF2.item_producto
		AND P1.prod_familia > P2.prod_familia
group by P1.prod_familia, FAM1.fami_detalle, P2.prod_familia, FAM2.fami_detalle
having COUNT(distinct IF1.item_tipo+IF1.item_sucursal+IF1.item_numero) > 10
order by 6

/*
33) -NO EMPEZADO-
. Se requiere obtener una estadística de venta de productos que sean componentes. Para 
ello se solicita que realiza la siguiente consulta que retorne la venta de los 
componentes del producto más vendido del año 2012.  Se deberá mostrar: 
a. Código de producto 
b. Nombre del producto 
c. Cantidad de unidades vendidas 
d. Cantidad de facturas en la cual se facturo 
e. Precio promedio facturado de ese producto. 
f. Total facturado para ese producto 
El resultado deberá ser ordenado por el total vendido por producto para el año 2012. 
*/

select
	item_producto 'COD',
	prod_detalle 'PROD NAME',
	SUM(item_cantidad) '#U VENDIDAS',
	COUNT(distinct item_tipo+item_sucursal+item_numero) '#FACT',
	AVG(item_cantidad*item_precio) 'AVG',
	SUM(item_cantidad*item_precio) 'TOTAL FACTURADO'
from Item_Factura
JOIN Producto ON prod_codigo = item_producto
where item_producto IN 
	(select comp_componente from Composicion where comp_producto = 
		(select TOP 1 item_producto from Item_Factura 
		JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
		where YEAR(fact_fecha) = 2012 group by item_producto order by SUM(item_cantidad) DESC)
	group by comp_componente)
group by item_producto, prod_detalle
order by 3
