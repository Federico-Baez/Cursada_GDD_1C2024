USE GD1C2024
/*********************************DROPEO DE TABLAS BI*********************************/

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'BI_Fact_Table_Ventas')
begin
	DROP TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Ventas;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'BI_Fact_Table_Pagos')
begin
	DROP TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Pagos;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'BI_Fact_Table_Envios')
begin
	DROP TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Envios;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'BI_Fact_Table_Promociones')
begin
	DROP TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Promociones;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'BI_Medio_De_Pago')
begin
	DROP TABLE PRAISE_THE_SUN_GDD.BI_Medio_De_Pago;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'BI_Categoria')
begin
	DROP TABLE PRAISE_THE_SUN_GDD.BI_Categoria;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'BI_Promocion')
begin
	DROP TABLE PRAISE_THE_SUN_GDD.BI_Promocion;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'BI_Descuento')
begin
	DROP TABLE PRAISE_THE_SUN_GDD.BI_Descuento;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'BI_Descuento')
begin
	DROP TABLE PRAISE_THE_SUN_GDD.BI_Descuento;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'BI_Tipo_Caja')
begin
	DROP TABLE PRAISE_THE_SUN_GDD.BI_Tipo_Caja;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'BI_Turnos')
begin
	DROP TABLE PRAISE_THE_SUN_GDD.BI_Turnos;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'BI_Sucursal')
begin
	DROP TABLE PRAISE_THE_SUN_GDD.BI_Sucursal;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'BI_Tiempo')
begin
	DROP TABLE PRAISE_THE_SUN_GDD.BI_Tiempo;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'BI_Rango_Etario')
begin
	DROP TABLE PRAISE_THE_SUN_GDD.BI_Rango_Etario;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'BI_Ubicacion')
begin
	DROP TABLE PRAISE_THE_SUN_GDD.BI_Ubicacion;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'BI_Provincia')
begin
	DROP TABLE PRAISE_THE_SUN_GDD.BI_Provincia;
end

/*********************************CREACION DE DIMENSIONES BI*********************************/


-- Medio de pago
CREATE TABLE PRAISE_THE_SUN_GDD.BI_Medio_De_Pago (
	id_medio_de_pago INT IDENTITY PRIMARY KEY NOT NULL,
	nombre_medio_pago nvarchar(255)
);

-- Categoria
CREATE TABLE PRAISE_THE_SUN_GDD.BI_Categoria(
	id_categoria INT PRIMARY KEY IDENTITY NOT NULL,
	categoria NVARCHAR(255),
	subcategoria NVARCHAR(255)
);

-- Tipo caja
CREATE TABLE PRAISE_THE_SUN_GDD.BI_Tipo_Caja(
	id_tipo_caja INT PRIMARY KEY IDENTITY NOT NULL,
	tipo_caja NVARCHAR(255)
);

-- Turnos
CREATE TABLE PRAISE_THE_SUN_GDD.BI_Turnos(
	id_turnos INT PRIMARY KEY IDENTITY NOT NULL,
	hora_inicial INT,
	hora_final INT,
);

-- Sucursal
CREATE TABLE PRAISE_THE_SUN_GDD.BI_Sucursal (
	id_sucursal INT IDENTITY PRIMARY KEY NOT NULL,
	nombre_sucursal nvarchar(255)
);

-- Tiempo
CREATE TABLE PRAISE_THE_SUN_GDD.BI_Tiempo (
	id_tiempo INT PRIMARY KEY IDENTITY NOT NULL,   	 
	anio INT,
	cuatrimestre INT,    	 
	mes INT
);

-- Rango Etario
CREATE TABLE PRAISE_THE_SUN_GDD.BI_Rango_Etario (
	id_rango_etario INT PRIMARY KEY IDENTITY NOT NULL,   	 
	edad_desde INT,
	edad_hasta INT
);

-- Provincia
CREATE TABLE PRAISE_THE_SUN_GDD.BI_Provincia(
	id_provincia DECIMAL(18,0) PRIMARY KEY NOT NULL,   	 
	nombre_provincia NVARCHAR(255),
);

-- Ubicacion
CREATE TABLE PRAISE_THE_SUN_GDD.BI_Ubicacion(
	id_ubicacion INT PRIMARY KEY IDENTITY NOT NULL,   	 
	nombre_localidad NVARCHAR(255),
	codigo_provincia DECIMAL(18,0) FOREIGN KEY
    	REFERENCES PRAISE_THE_SUN_GDD.BI_Provincia(id_provincia)
);



/*********************************CREACION DE FACT TABLES BI*********************************/

-- HECHOS VENTAS
CREATE TABLE  PRAISE_THE_SUN_GDD.BI_Fact_Table_Ventas(
	id_tiempo INT NOT NULL,
	id_sucursal INT NOT NULL,
	id_turnos INT NOT NULL,
	id_rango_etario INT NOT NULL,
	id_ubicacion INT NOT NULL,
	id_tipo_caja INT NOT NULL,
	importe_total decimal(18,2),
	cantidad_articulos decimal(18,2),
	descuento_aplicado DECIMAL(18,2)
);

-- HECHOS PAGOS
CREATE TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Pagos(
id_tiempo INT NOT NULL,
id_medio_de_pago INT NOT NULL,
id_sucursal INT NOT NULL,
id_rango_etario INT NOT NULL,
importe_pago_total decimal(18,2),
cantidad_cuotas decimal(18,0),
--importe_pago_cuotas decimal(18,2),
valor_descontado decimal(18,2)
);

-- HECHOS ENVIOS
CREATE TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Envios(
	id_tiempo INT NOT NULL,   	 
	id_rango_etario INT NOT NULL,
	id_ubicacion INT NOT NULL,
	id_sucursal INT NOT NULL,
	cantidad_envios DECIMAL(18,0),
	envios_cumplidos DECIMAL(18,0),
	costo_envio DECIMAL(18,2)
);

-- HECHOS PROMOCIONES
CREATE TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Promociones(
	id_tiempo INT NOT NULL,
	id_categoria INT NOT NULL,
	promocion_producto_aplicada DECIMAL(18,2)
);

/**** CREACION DE FKs ****/
ALTER TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Ventas ADD CONSTRAINT FK_V_tiempo FOREIGN KEY (id_tiempo) REFERENCES PRAISE_THE_SUN_GDD.BI_Tiempo(id_tiempo);
ALTER TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Ventas ADD CONSTRAINT FK_V_sucursal FOREIGN KEY (id_sucursal) REFERENCES PRAISE_THE_SUN_GDD.BI_Sucursal(id_sucursal);
ALTER TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Ventas ADD CONSTRAINT FK_V_turnos FOREIGN KEY (id_turnos) REFERENCES PRAISE_THE_SUN_GDD.BI_Turnos(id_turnos);
ALTER TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Ventas ADD CONSTRAINT FK_V_rango_etario FOREIGN KEY (id_rango_etario) REFERENCES PRAISE_THE_SUN_GDD.BI_Rango_Etario(id_rango_etario);
ALTER TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Ventas ADD CONSTRAINT FK_V_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES PRAISE_THE_SUN_GDD.BI_Ubicacion(id_ubicacion);
ALTER TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Ventas ADD CONSTRAINT FK_V_tipo_caja FOREIGN KEY (id_tipo_caja) REFERENCES PRAISE_THE_SUN_GDD.BI_Tipo_Caja(id_tipo_caja);

ALTER TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Pagos ADD CONSTRAINT FK_P_tiempo FOREIGN KEY (id_tiempo) REFERENCES PRAISE_THE_SUN_GDD.BI_Tiempo(id_tiempo);
ALTER TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Pagos ADD CONSTRAINT FK_P_medio_de_pago FOREIGN KEY (id_medio_de_pago) REFERENCES PRAISE_THE_SUN_GDD.BI_Medio_De_Pago(id_medio_de_pago);
ALTER TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Pagos ADD CONSTRAINT FK_P_sucursal FOREIGN KEY (id_sucursal) REFERENCES PRAISE_THE_SUN_GDD.BI_Sucursal(id_sucursal);

ALTER TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Envios ADD CONSTRAINT FK_E_Tiempo FOREIGN KEY (id_tiempo) REFERENCES PRAISE_THE_SUN_GDD.BI_Tiempo(id_tiempo);
ALTER TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Envios ADD CONSTRAINT FK_E_Rango_Etario FOREIGN KEY (id_rango_etario) REFERENCES PRAISE_THE_SUN_GDD.BI_Rango_Etario(id_rango_etario);
ALTER TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Envios ADD CONSTRAINT FK_E_Ubicacion FOREIGN KEY (id_ubicacion) REFERENCES PRAISE_THE_SUN_GDD.BI_Ubicacion(id_ubicacion);

ALTER TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Promociones ADD CONSTRAINT FK_Pr_Tiempo FOREIGN KEY (id_tiempo) REFERENCES PRAISE_THE_SUN_GDD.BI_Tiempo(id_tiempo);
ALTER TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Promociones ADD CONSTRAINT FK_Pr_categoria FOREIGN KEY (id_categoria) REFERENCES PRAISE_THE_SUN_GDD.BI_Categoria(id_categoria);


/**** CREACION DE PKs ****/
ALTER TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Ventas ADD CONSTRAINT PK_BI_Fact_Table_Ventas PRIMARY KEY(id_tiempo, id_sucursal, id_turnos, id_rango_etario, id_ubicacion, id_tipo_caja)
ALTER TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Pagos ADD CONSTRAINT PK_BI_Fact_Table_Pagos PRIMARY KEY(id_tiempo, id_medio_de_pago, id_sucursal,id_rango_etario)
ALTER TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Envios ADD CONSTRAINT PK_BI_Fact_Table_Envios PRIMARY KEY(id_tiempo, id_rango_etario, id_ubicacion, id_sucursal)
ALTER TABLE PRAISE_THE_SUN_GDD.BI_Fact_Table_Promociones ADD CONSTRAINT PK_BI_Fact_Table_Promociones PRIMARY KEY(id_tiempo, id_categoria)




/*********************************INSERTS TABLAS BI*********************************/

-- Tipo cajas
INSERT INTO PRAISE_THE_SUN_GDD.BI_Tipo_Caja( tipo_caja)
SELECT tipc_detalle
	FROM PRAISE_THE_SUN_GDD.Tipo_Caja

-- Turnos
INSERT INTO PRAISE_THE_SUN_GDD.BI_Turnos(hora_inicial ,hora_final) VALUES(8,12), (12,16), (16, 20), (20, 8)

-- Catagorias
INSERT INTO PRAISE_THE_SUN_GDD.BI_Categoria(categoria, subcategoria)
SELECT
	distinct C1.cate_nombre, C2.cate_nombre
FROM PRAISE_THE_SUN_GDD.Categoria C1
join PRAISE_THE_SUN_GDD.Producto ON prod_categoria = C1.cate_codigo
JOIN PRAISE_THE_SUN_GDD.Categoria C2 ON prod_subcategoria = C2.cate_codigo
ORDER BY 1 ASC

-- Sucursal
INSERT INTO PRAISE_THE_SUN_GDD.BI_Sucursal(nombre_sucursal)(
	select sucu_nombre
	from PRAISE_THE_SUN_GDD.Sucursal
)

-- Medio de pago
INSERT INTO PRAISE_THE_SUN_GDD.BI_Medio_De_Pago(nombre_medio_pago)(
	select distinct medp_detalle
	from PRAISE_THE_SUN_GDD.Medio_De_Pago
)

-- Provincia
INSERT INTO PRAISE_THE_SUN_GDD.BI_Provincia(id_provincia, nombre_provincia)(
	select prov_codigo, prov_detalle
	from PRAISE_THE_SUN_GDD.Provincia
)

-- Ubicacion
INSERT INTO PRAISE_THE_SUN_GDD.BI_UBICACION(nombre_localidad, codigo_provincia)(
	select loca_localidad, prov_codigo
	from PRAISE_THE_SUN_GDD.Localidad
	join PRAISE_THE_SUN_GDD.Provincia on loca_provincia = prov_codigo
)

-- Tiempo
INSERT INTO PRAISE_THE_SUN_GDD.BI_Tiempo(anio, cuatrimestre, mes)
select distinct YEAR(tick_fecha_hora), DATEPART(QUARTER, tick_fecha_hora), MONTH(tick_fecha_hora)
	from PRAISE_THE_SUN_GDD.Ticket
	union
	select distinct YEAR(envi_fecha_entrega), DATEPART(QUARTER, envi_fecha_entrega), MONTH(envi_fecha_entrega)
	FROM PRAISE_THE_SUN_GDD.Envio
	order by 1 desc, 3 asc

-- Rango etario
INSERT INTO  PRAISE_THE_SUN_GDD.BI_Rango_Etario(edad_desde, edad_hasta) VALUES (0,25), (25,35), (35,50), (50,200), (NULL,NULL)


-- FACT TABLE VENTAS
INSERT INTO PRAISE_THE_SUN_GDD.BI_Fact_Table_Ventas(id_tiempo, id_sucursal, id_turnos, id_rango_etario,
                                                	id_ubicacion, id_tipo_caja, importe_total, cantidad_articulos, descuento_aplicado)(
SELECT 	 
	id_tiempo               	 
	,id_sucursal
	,id_turnos
	,id_rango_etario
	,id_ubicacion
	,id_tipo_caja
	,SUM(tick_total_ticket)
	,SUM(item_cantidad)
	,ISNULL(SUM(tick_total_descuento_aplicado + tick_total_descuento_aplicado_mp), 0)
FROM PRAISE_THE_SUN_GDD.Ticket
JOIN PRAISE_THE_SUN_GDD.BI_TIEMPO ON YEAR(tick_fecha_hora) = anio and MONTH(tick_fecha_hora) = mes
JOIN PRAISE_THE_SUN_GDD.Sucursal ON tick_sucursal = sucu_codigo
JOIN PRAISE_THE_SUN_GDD.BI_Sucursal ON sucu_nombre = nombre_sucursal
JOIN PRAISE_THE_SUN_GDD.BI_Turnos ON ((DATEPART(HOUR, tick_fecha_hora) >= hora_inicial AND DATEPART(HOUR, tick_fecha_hora) < hora_final)
                                	OR (hora_inicial > hora_final AND (DATEPART(HOUR, tick_fecha_hora) >= hora_inicial
                                    	OR DATEPART(HOUR, tick_fecha_hora) < hora_final)))
JOIN PRAISE_THE_SUN_GDD.Item_ticket ON tick_numero+tick_sucursal = item_ticket+item_sucursal AND tick_tipo = item_tipo AND tick_fecha_hora  = item_fecha_hora
JOIN PRAISE_THE_SUN_GDD.Empleado ON tick_empleado = empl_codigo
JOIN PRAISE_THE_SUN_GDD.BI_Rango_Etario ON (year(GETDATE())-DATEPART(YEAR, empl_fech_nacimiento)) >= edad_desde
                                    	AND (year(GETDATE())-DATEPART(YEAR, empl_fech_nacimiento)) < edad_hasta
                                    	AND (year(GETDATE())-DATEPART(YEAR, empl_fech_nacimiento)) BETWEEN edad_desde AND edad_hasta
JOIN PRAISE_THE_SUN_GDD.Localidad ON sucu_localidad = loca_codigo
JOIN PRAISE_THE_SUN_GDD.Provincia ON loca_provincia = prov_codigo
JOIN PRAISE_THE_SUN_GDD.BI_Ubicacion ON loca_localidad = nombre_localidad AND prov_codigo = codigo_provincia
JOIN PRAISE_THE_SUN_GDD.Caja ON tick_caja = caja_codigo and tick_sucursal = caja_sucursal
JOIN PRAISE_THE_SUN_GDD.Tipo_Caja ON caja_tipo = tipc_codigo
JOIN PRAISE_THE_SUN_GDD.BI_Tipo_Caja ON tipc_detalle = tipo_caja
group by	 
	id_tiempo
	,id_sucursal
	,id_turnos
	,id_rango_etario
	,id_ubicacion
	,id_tipo_caja
)

-- FACT TABLE PAGOS
INSERT INTO PRAISE_THE_SUN_GDD.BI_Fact_Table_Pagos(id_tiempo, id_medio_de_pago, id_sucursal, id_rango_etario, importe_pago_total, cantidad_cuotas, valor_descontado )(
	select	BI_T.id_tiempo,
        	BI_M.id_medio_de_pago,
        	BI_S.id_sucursal,
        	BI_RE.id_rango_etario,
        	SUM(P.pago_importe),
        	ISNULL(SUM(DT.deta_pago_tarjeta_cuotas), 0),
        	SUM(DxM.dxmp_desc_aplicado)
	from PRAISE_THE_SUN_GDD.Pago P
	JOIN PRAISE_THE_SUN_GDD.BI_Tiempo BI_T ON year(P.pago_fecha)=BI_T.anio AND month(P.pago_fecha)=BI_T.mes
	JOIN PRAISE_THE_SUN_GDD.Medio_De_Pago M ON P.pago_medio_pago=M.medp_codigo
	JOIN PRAISE_THE_SUN_GDD.BI_Medio_De_Pago BI_M ON M.medp_detalle=BI_M.nombre_medio_pago
	JOIN PRAISE_THE_SUN_GDD.Ticket Tk ON P.pago_importe=TK.tick_total_ticket AND CAST(P.pago_fecha AS date)=CAST(TK.tick_fecha_hora AS date)
	JOIN PRAISE_THE_SUN_GDD.Sucursal S ON TK.tick_sucursal=S.sucu_codigo
	JOIN PRAISE_THE_SUN_GDD.BI_Sucursal BI_S ON S.sucu_nombre=BI_S.nombre_sucursal
	LEFT JOIN PRAISE_THE_SUN_GDD.Detalle_Pago_Tarjeta DT ON P.pago_detalle=DT.deta_codigo
	JOIN PRAISE_THE_SUN_GDD.Descuento_X_Medio_Pago DxM ON P.pago_codigo=DxM.dxmp_pago_codigo
	LEFT JOIN PRAISE_THE_SUN_GDD.Cliente C ON P.pago_cliente=C.clie_codigo
	JOIN PRAISE_THE_SUN_GDD.BI_Rango_Etario BI_RE ON (year(GETDATE())-DATEPART(YEAR, C.clie_fecha_nacimiento)) >= BI_RE.edad_desde
                                    	AND (year(GETDATE())-DATEPART(YEAR,  C.clie_fecha_nacimiento)) < BI_RE.edad_hasta
                                    	AND (year(GETDATE())-DATEPART(YEAR,  C.clie_fecha_nacimiento)) BETWEEN BI_RE.edad_desde AND BI_RE.edad_hasta
                                    	OR BI_RE.edad_desde IS NULL AND BI_RE.edad_hasta IS NULL
	GROUP BY BI_T.id_tiempo, BI_M.id_medio_de_pago, BI_S.id_sucursal, BI_RE.id_rango_etario
)

-- FACT TABLE ENVIOS
INSERT INTO PRAISE_THE_SUN_GDD.BI_Fact_Table_Envios(id_tiempo, id_rango_etario, id_ubicacion, id_sucursal, cantidad_envios, envios_cumplidos, costo_envio)(
	select	BI_T.id_tiempo,
        	BI_RE.id_rango_etario,
        	BI_U.id_ubicacion,
        	BI_S.id_sucursal,
        	count(E.envi_codigo),
        	SUM(CASE WHEN YEAR(E.envi_fecha_entrega) = YEAR(E.envi_fecha_programada)
            	AND MONTH(E.envi_fecha_entrega) = MONTH(E.envi_fecha_programada)
            	AND DAY(E.envi_fecha_entrega) = DAY(E.envi_fecha_programada)
            	THEN 1 ELSE 0 END) AS entregas_a_tiempo,
        	SUM(E.envi_costo)

	from PRAISE_THE_SUN_GDD.Envio E
	JOIN PRAISE_THE_SUN_GDD.Ticket Tk ON E.envi_ticket_tipo=TK.tick_tipo AND E.envi_ticket_sucursal=TK.tick_sucursal
                                        	AND E.envi_ticket_numero=TK.tick_numero AND E.envi_ticket_hora=TK.tick_fecha_hora
	JOIN PRAISE_THE_SUN_GDD.BI_Tiempo BI_T ON year(E.envi_ticket_hora)=BI_T.anio AND month(E.envi_ticket_hora)=BI_T.mes
	JOIN PRAISE_THE_SUN_GDD.Cliente C ON TK.tick_cliente_codigo=C.clie_codigo
	JOIN PRAISE_THE_SUN_GDD.BI_Rango_Etario BI_RE
            	ON ((year(GETDATE()) - year(C.clie_fecha_nacimiento)) >= BI_RE.edad_desde
            	AND (year(GETDATE()) - year(C.clie_fecha_nacimiento)) < BI_RE.edad_hasta)                            	 
	JOIN PRAISE_THE_SUN_GDD.Localidad L ON C.clie_localidad=L.loca_codigo
	JOIN PRAISE_THE_SUN_GDD.BI_Ubicacion BI_U ON L.loca_localidad=BI_U.nombre_localidad AND L.loca_provincia=BI_U.codigo_provincia
	JOIN PRAISE_THE_SUN_GDD.Sucursal S ON Tk.tick_sucursal = S.sucu_codigo
	JOIN PRAISE_THE_SUN_GDD.BI_Sucursal BI_S ON S.sucu_nombre = BI_S.nombre_sucursal
	GROUP BY BI_T.id_tiempo, BI_RE.id_rango_etario, BI_U.id_ubicacion, BI_S.id_sucursal
)

-- FACT TABLE PROMOCIOENS
INSERT INTO PRAISE_THE_SUN_GDD.BI_Fact_Table_Promociones(id_tiempo, id_categoria, promocion_producto_aplicada) (
	SELECT
    	id_tiempo
    	,id_categoria
    	,ISNULL(SUM(pxtk_descuento_aplicado) ,0)
	FROM PRAISE_THE_SUN_GDD.Ticket
	JOIN PRAISE_THE_SUN_GDD.BI_TIEMPO ON YEAR(tick_fecha_hora) = anio and MONTH(tick_fecha_hora) = mes
	JOIN PRAISE_THE_SUN_GDD.Item_ticket ON tick_numero+tick_sucursal = item_ticket+item_sucursal AND tick_tipo = item_tipo AND tick_fecha_hora  = item_fecha_hora
	JOIN PRAISE_THE_SUN_GDD.Producto ON item_producto = prod_codigo
	JOIN PRAISE_THE_SUN_GDD.Categoria C1 ON prod_categoria = C1.cate_codigo
	JOIN PRAISE_THE_SUN_GDD.Categoria C2 ON prod_subcategoria = C2.cate_codigo
	JOIN PRAISE_THE_SUN_GDD.BI_Categoria ON C1.cate_nombre = categoria AND C2.cate_nombre = subcategoria
	LEFT JOIN PRAISE_THE_SUN_GDD.Promocion_X_Ticket ON item_ticket = pxtk_ticket and item_sucursal = pxtk_sucursal
                                                	and item_tipo = pxtk_tipo and item_fecha_hora = pxtk_fecha_hora and item_producto = pxtk_producto
	GROUP BY id_tiempo, id_categoria
)
GO

/*********************************DROP VISTAS BI*********************************/
IF OBJECT_ID('PRAISE_THE_SUN_GDD.VIEW_1_Ticket_promedio_mensual') IS NOT NULL
	DROP VIEW PRAISE_THE_SUN_GDD.VIEW_1_Ticket_promedio_mensual
GO

IF OBJECT_ID('PRAISE_THE_SUN_GDD.VIEW_2_Cantidad_unidades_promedio') IS NOT NULL
	DROP VIEW PRAISE_THE_SUN_GDD.VIEW_2_Cantidad_unidades_promedio
GO

IF OBJECT_ID('PRAISE_THE_SUN_GDD.VIEW_3_Porcentaje_anual_de_ventas') IS NOT NULL
	DROP VIEW PRAISE_THE_SUN_GDD.VIEW_3_Porcentaje_anual_de_ventas
GO

IF OBJECT_ID('PRAISE_THE_SUN_GDD.VIEW_4_Cantidad_ventas_por_turno') IS NOT NULL
	DROP VIEW PRAISE_THE_SUN_GDD.VIEW_4_Cantidad_ventas_por_turno
GO

IF OBJECT_ID('PRAISE_THE_SUN_GDD.VIEW_5_Porcentaje_descuento_aplicado_por_MES_ANIO') IS NOT NULL
	DROP VIEW PRAISE_THE_SUN_GDD.VIEW_5_Porcentaje_descuento_aplicado_por_MES_ANIO
GO

IF OBJECT_ID('PRAISE_THE_SUN_GDD.VIEW_6_Categorias_con_mayor_descuento_aplicado') IS NOT NULL
	DROP VIEW PRAISE_THE_SUN_GDD.VIEW_6_Categorias_con_mayor_descuento_aplicado
GO

IF OBJECT_ID('PRAISE_THE_SUN_GDD.VIEW_7_PORCENTAJE_CUMPLIMIENTO_ENVIOS') IS NOT NULL
	DROP VIEW PRAISE_THE_SUN_GDD.VIEW_7_PORCENTAJE_CUMPLIMIENTO_ENVIOS
GO

IF OBJECT_ID('PRAISE_THE_SUN_GDD.VIEW_8_Cantidad_envios_por_Rango_etario') IS NOT NULL
	DROP VIEW PRAISE_THE_SUN_GDD.VIEW_8_Cantidad_envios_por_Rango_etario
GO

IF OBJECT_ID('PRAISE_THE_SUN_GDD.VIEW_9_TOP5_LOCALIDADES_COSTO_ENVIO') IS NOT NULL
	DROP VIEW PRAISE_THE_SUN_GDD.VIEW_9_TOP5_LOCALIDADES_COSTO_ENVIO
GO

IF OBJECT_ID('PRAISE_THE_SUN_GDD.VIEW_10') IS NOT NULL
	DROP VIEW PRAISE_THE_SUN_GDD.VIEW_10
GO

IF OBJECT_ID('PRAISE_THE_SUN_GDD.VIEW_11') IS NOT NULL
	DROP VIEW PRAISE_THE_SUN_GDD.VIEW_11
GO

IF OBJECT_ID('PRAISE_THE_SUN_GDD.VIEW_12') IS NOT NULL
	DROP VIEW PRAISE_THE_SUN_GDD.VIEW_12
GO

/*********************************VISTAS BI*********************************/
GO

-- 1. Ticket promedio mensual
CREATE VIEW PRAISE_THE_SUN_GDD.VIEW_1_Ticket_promedio_mensual
AS
	SELECT CAST(SUM(importe_total)/COUNT(*) AS DECIMAL(18,2)) as Promedio_Ticket_Mensual  -- (SUM(importe_total)/(SUM(promo_aplicada)+SUM(descuento_total_aplicado)))
	FROM PRAISE_THE_SUN_GDD.BI_Fact_Table_Ventas FV
	JOIN PRAISE_THE_SUN_GDD.BI_Tiempo BI_T ON FV.id_tiempo =  BI_T.id_tiempo
	JOIN PRAISE_THE_SUN_GDD.BI_Ubicacion BI_U ON FV.id_ubicacion = BI_U.id_ubicacion
	GROUP by BI_U.nombre_localidad , BI_T.anio, BI_T.mes
GO
--Select * from PRAISE_THE_SUN_GDD.VIEW_1_TICKET_PROMEDIO_MENSUAL

-- 2. Cantidad unidades promedio
CREATE VIEW PRAISE_THE_SUN_GDD.VIEW_2_Cantidad_unidades_promedio
AS
	SELECT
    	BI_TM.cuatrimestre AS Cuatrimestre
    	,BI_TN.id_turnos AS Turno
    	,CAST(SUM(FV.cantidad_articulos)/COUNT(*) AS DECIMAL(18,2)) AS Promedio_Cantidad_Unidades
	FROM PRAISE_THE_SUN_GDD.BI_Fact_Table_Ventas FV
	JOIN PRAISE_THE_SUN_GDD.BI_Turnos BI_TN ON FV.id_turnos = BI_TN.id_turnos
	JOIN PRAISE_THE_SUN_GDD.BI_Tiempo BI_TM ON FV.id_tiempo = BI_TM.id_tiempo
	GROUP by BI_TM.cuatrimestre, BI_TN.id_turnos
GO
--select * from PRAISE_THE_SUN_GDD.VIEW_2_Cantidad_unidades_promedio

-- 3. Porcentaje anual de ventas
CREATE VIEW PRAISE_THE_SUN_GDD.VIEW_3_Porcentaje_anual_de_ventas
AS
	SELECT    
    	RTRIM(BI_R.edad_desde)+ ' - ' +RTRIM(BI_R.edad_hasta) AS Rango_Etario
    	,BI_TC.tipo_caja AS Tipo_De_Caja   	 
    	,BI_TM.cuatrimestre AS Cuatrimestre
    	,CAST(100*CAST(COUNT(*) AS decimal(18,2))/(SELECT COUNT(*) FROM PRAISE_THE_SUN_GDD.BI_Fact_Table_Ventas) AS decimal(18,2)) AS Porcentaje_Anual_Ventas
	FROM PRAISE_THE_SUN_GDD.BI_Fact_Table_Ventas FV
	JOIN PRAISE_THE_SUN_GDD.BI_Tiempo BI_TM ON FV.id_tiempo = BI_TM.id_tiempo
	JOIN PRAISE_THE_SUN_GDD.BI_Rango_Etario BI_R ON FV.id_rango_etario = BI_R.id_rango_etario
	JOIN PRAISE_THE_SUN_GDD.BI_Tipo_Caja BI_TC ON FV.id_tipo_caja = BI_TC.id_tipo_caja
	GROUP by BI_R.edad_desde, BI_R.edad_hasta, BI_TM.cuatrimestre, BI_TC.tipo_caja   	 
GO

-- 4. Cantidad de ventas registradas por turno
CREATE VIEW PRAISE_THE_SUN_GDD.VIEW_4_Cantidad_ventas_por_turno
AS
	SELECT
    	BI_T.anio AS Anio
    	,BI_T.mes AS Mes
    	,RTRIM(BI_TU.hora_inicial)+ ' - ' +RTRIM(BI_TU.hora_final) AS Turno
    	,BI_U.nombre_localidad AS Localidad
    	,COUNT(*) AS Cantidad_Ventas
    	FROM PRAISE_THE_SUN_GDD.BI_Fact_Table_Ventas FV
    	JOIN PRAISE_THE_SUN_GDD.BI_Ubicacion BI_U ON FV.id_ubicacion = BI_U.id_ubicacion
    	JOIN PRAISE_THE_SUN_GDD.BI_Tiempo BI_T ON FV.id_tiempo = BI_T.id_tiempo
    	join PRAISE_THE_SUN_GDD.BI_Turnos BI_TU ON BI_TU.id_turnos = FV.id_turnos
    	GROUP BY BI_T.anio, BI_T.mes, BI_TU.hora_inicial, BI_TU.hora_final, BI_U.nombre_localidad
GO
--SELECT * FROM PRAISE_THE_SUN_GDD.VIEW_4_Cantidad_ventas_por_turno

-- 5. Porcentaje de descuento aplicados en función del total de los tickets según el mes de cada año.
CREATE VIEW PRAISE_THE_SUN_GDD.VIEW_5_Porcentaje_descuento_aplicado_por_MES_ANIO
AS
	SELECT
    	BI_T.anio AS Anio
    	,BI_T.mes AS Mes
    	,CAST(100*SUM(BI_FV.descuento_aplicado)/SUM(BI_FV.importe_total) AS decimal(18,2)) AS Porcentaje_Descuento_Promedio
	FROM PRAISE_THE_SUN_GDD.BI_Fact_Table_Ventas BI_FV
	JOIN PRAISE_THE_SUN_GDD.BI_Tiempo BI_T ON BI_FV.id_tiempo = BI_T.id_tiempo
	GROUP BY BI_T.anio, BI_T.mes
GO
--SELECT * FROM PRAISE_THE_SUN_GDD.VIEW_5_Porcentaje_descuento_aplicado_por_MES_ANIO

-- 6. Las tres categorías de productos con mayor descuento aplicado
CREATE VIEW PRAISE_THE_SUN_GDD.VIEW_6_Categorias_con_mayor_descuento_aplicado
AS
	SELECT TOP 3
    	BI_T.anio AS Anio
    	,BI_T.cuatrimestre AS Cuatrimestre
    	,BI_C.categoria AS Categoria
    	,sum(cast(BI_FPR.promocion_producto_aplicada as decimal(18,0))) AS Descuento_Aplicado
	FROM PRAISE_THE_SUN_GDD.BI_Fact_Table_Promociones BI_FPR
	JOIN PRAISE_THE_SUN_GDD.BI_Categoria BI_C ON BI_FPR.id_categoria = BI_C.id_categoria
	JOIN PRAISE_THE_SUN_GDD.BI_Tiempo BI_T ON BI_FPR.id_tiempo = BI_T.id_tiempo
	GROUP BY BI_T.anio, BI_T.cuatrimestre, BI_C.categoria
	ORDER BY 4 DESC
GO
--SELECT * FROM PRAISE_THE_SUN_GDD.VIEW_6_Categorias_con_mayor_descuento_aplicado

-- 7. Porcentaje de cumplimiento de envíos
CREATE VIEW PRAISE_THE_SUN_GDD.VIEW_7_PORCENTAJE_CUMPLIMIENTO_ENVIOS
AS
	SELECT
    	BI_T.anio AS Anio
    	,BI_T.mes AS Mes
    	,BI_S.nombre_sucursal AS Sucursal
    	,CAST(ISNULL (100*sum(FE.envios_cumplidos), 0) / sum(FE.cantidad_envios) AS decimal(18,2)) AS Porcentaje_Cumplimiento
	FROM PRAISE_THE_SUN_GDD.BI_Fact_Table_Envios FE
	JOIN PRAISE_THE_SUN_GDD.BI_Tiempo BI_T ON FE.id_tiempo = BI_T.id_tiempo
	JOIN PRAISE_THE_SUN_GDD.BI_Sucursal BI_S ON FE.id_sucursal = BI_S.id_sucursal
	GROUP BY BI_T.anio, BI_T.mes, BI_S.nombre_sucursal
GO
--SELECT * FROM PRAISE_THE_SUN_GDD.VIEW_7_PORCENTAJE_CUMPLIMIENTO_ENVIOS

-- 8. Cantidad de envíos por rango etario de clientes
CREATE VIEW PRAISE_THE_SUN_GDD.VIEW_8_Cantidad_envios_por_Rango_etario
AS
	SELECT
    	BI_T.anio AS Anio
    	,BI_T.cuatrimestre AS Cuatrimestre
    	,BI_R.id_rango_etario AS Rango_Etario
    	,SUM(FE.cantidad_envios) AS Envios_Cumplidos
	FROM PRAISE_THE_SUN_GDD.BI_Fact_Table_Envios FE
	JOIN PRAISE_THE_SUN_GDD.BI_Tiempo BI_T ON FE.id_tiempo = BI_T.id_tiempo
	JOIN PRAISE_THE_SUN_GDD.BI_Rango_Etario BI_R ON FE.id_rango_etario = BI_R.id_rango_etario
	GROUP BY BI_T.anio, BI_T.cuatrimestre, BI_R.id_rango_etario
GO
--SELECT * FROM PRAISE_THE_SUN_GDD.VIEW_8_Cantidad_envios_por_Rango_etario

-- 9. Las 5 localidades con mayor costo de envío.
CREATE VIEW PRAISE_THE_SUN_GDD.VIEW_9_TOP5_LOCALIDADES_COSTO_ENVIO
AS
	SELECT TOP 5
    	U.nombre_localidad AS Localidad
	FROM PRAISE_THE_SUN_GDD.BI_Ubicacion U
	JOIN PRAISE_THE_SUN_GDD.BI_Fact_Table_Envios FE ON U.id_ubicacion = FE.id_ubicacion
	GROUP BY U.nombre_localidad
	ORDER BY SUM(FE.costo_envio) DESC
GO
--SELECT * FROM PRAISE_THE_SUN_GDD.VIEW_9_TOP5_LOCALIDADES_COSTO_ENVIO

-- 10. Las 3 sucursales con el mayor importe de pagos en cuotas, según el medio de pago, mes y año.
CREATE VIEW PRAISE_THE_SUN_GDD.VIEW_10
AS
	SELECT TOP(3) BI_S.nombre_sucursal, BI_MP.nombre_medio_pago, BI_T.anio, BI_T.mes  FROM PRAISE_THE_SUN_GDD.BI_Fact_Table_Pagos BI_FTP
	JOIN PRAISE_THE_SUN_GDD.BI_Sucursal BI_S ON BI_FTP.id_sucursal=BI_S.id_sucursal
	JOIN PRAISE_THE_SUN_GDD.BI_Tiempo BI_T ON BI_FTP.id_tiempo=BI_T.id_tiempo
	JOIN PRAISE_THE_SUN_GDD.BI_Medio_De_Pago BI_MP ON BI_FTP.id_medio_de_pago=BI_MP.id_medio_de_pago
	WHERE BI_MP.nombre_medio_pago!='Efectivo'
	GROUP BY BI_S.nombre_sucursal, BI_MP.nombre_medio_pago, BI_T.anio, BI_T.mes
	ORDER BY SUM(BI_FTP.importe_pago_total) DESC
GO

-- 11. Promedio de importe de la cuota en función del rango etareo del cliente.
CREATE VIEW PRAISE_THE_SUN_GDD.VIEW_11
AS
	SELECT
    	BI_RE.edad_desde AS Edad_desde
    	,BI_RE.edad_hasta AS Edad_hasta
    	,CAST(SUM(BI_FTP.importe_pago_total)/SUM(BI_FTP.cantidad_cuotas) AS decimal(18,2))AS promedio_importe_cuotas
	FROM PRAISE_THE_SUN_GDD.BI_Fact_Table_Pagos BI_FTP
	JOIN PRAISE_THE_SUN_GDD.BI_Rango_Etario BI_RE ON BI_FTP.id_rango_etario=BI_RE.id_rango_etario
	JOIN PRAISE_THE_SUN_GDD.BI_Medio_De_Pago BI_MP ON BI_FTP.id_medio_de_pago=BI_MP.id_medio_de_pago
	WHERE BI_MP.nombre_medio_pago not like 'Efectivo'
	GROUP BY BI_RE.edad_desde, BI_RE.edad_hasta
GO

-- 12. Porcentaje de descuento aplicado por cada medio de pago en función del valor de total de pagos sin el descuento, por cuatrimestre
CREATE VIEW PRAISE_THE_SUN_GDD.VIEW_12
AS
	SELECT BI_T.anio, BI_T.cuatrimestre, BI_MP.nombre_medio_pago, (SUM(BI_FTP.valor_descontado)*100/SUM(BI_FTP.importe_pago_total))as porcentaje_descuento_aplicado FROM PRAISE_THE_SUN_GDD.BI_Fact_Table_Pagos BI_FTP
	JOIN PRAISE_THE_SUN_GDD.BI_Tiempo BI_T ON BI_FTP.id_tiempo=BI_T.id_tiempo
	JOIN PRAISE_THE_SUN_GDD.BI_Medio_De_Pago BI_MP ON BI_FTP.id_medio_de_pago=BI_MP.id_medio_de_pago
	GROUP BY BI_T.anio, BI_T.cuatrimestre, BI_MP.nombre_medio_pago
GO


