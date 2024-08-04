USE GD1C2024
/*********************************CREACION DEL ESQUEMA*********************************/

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'PRAISE_THE_SUN_GDD')
BEGIN
    EXEC ('CREATE SCHEMA PRAISE_THE_SUN_GDD')
END
GO
/***********************************************************************************/

/*********************************DROPEO DE TABLAS*********************************/

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Promocion_X_Ticket')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Promocion_X_Ticket;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Item_ticket')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Item_ticket;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Envio')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Envio;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Ticket')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Ticket;
end
if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Descuento_X_Medio_Pago')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Descuento_X_Medio_Pago;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Promocion_X_Producto')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Promocion_X_Producto;
end
if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Caja')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Caja;
end
if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Sucursal')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Sucursal;
end
if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Pago')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Pago;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Descuento')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Descuento;
end
if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Cliente')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Cliente;
end
if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Supermercado')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Supermercado;
end
if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Promocion')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Promocion;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Medio_De_Pago')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Medio_De_Pago;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Localidad')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Localidad;
end
if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Producto')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Producto;
end

if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Detalle_Pago_Tarjeta')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Detalle_Pago_Tarjeta;
end
if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Tipo_Medio_Pago')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Tipo_Medio_Pago;
end
if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Tipo_Caja')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Tipo_Caja;
end
if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Estado_Envio')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Estado_Envio;
end
if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Empleado')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Empleado;
end
if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Provincia')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Provincia;
end
if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Categoria')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Categoria;
end
if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Marca')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Marca;
end
if exists (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'PRAISE_THE_SUN_GDD' AND TABLE_NAME = 'Regla')
begin
    DROP TABLE PRAISE_THE_SUN_GDD.Regla;
end
/***********************************************************************************/


/*********************************CREACION DE LAS TABLAS*********************************/

--a)
-- PAGO
CREATE TABLE PRAISE_THE_SUN_GDD.Pago(
    pago_codigo decimal(18,0) NOT NULL IDENTITY,
    pago_fecha datetime NOT NULL,
	pago_importe decimal(18,2) NOT NULL,
	pago_medio_pago decimal(18,0) NOT NULL,
	pago_detalle decimal(18,0),
	pago_cliente decimal(18,0),
);

-- DETALLE_PAGO_TARJETA
CREATE TABLE PRAISE_THE_SUN_GDD.Detalle_Pago_Tarjeta(
    deta_codigo decimal(18,0) NOT NULL IDENTITY,
    deta_pago_nro_tarjeta nvarchar(50) NOT NULL,
	deta_pago_tarjeta_fecha_venc datetime NOT NULL,
	deta_pago_tarjeta_cuotas decimal(18,0) NOT NULL,
);

-- DESCUENTO_X_MEDIO_PAGO
CREATE TABLE PRAISE_THE_SUN_GDD.Descuento_X_Medio_Pago(
    dxmp_pago_codigo decimal(18,0) NOT NULL,
    dxmp_desc_codigo decimal(18,0) NOT NULL,
	dxmp_desc_aplicado decimal(18,2)
);

-- MEDIO_DE_PAGO
CREATE TABLE PRAISE_THE_SUN_GDD.Medio_De_Pago(
    medp_codigo decimal(18,0) NOT NULL IDENTITY,
    medp_detalle nvarchar(255) NOT NULL,
	medp_tipo decimal(18,0) NOT NULL
);

-- DESCUENTO
CREATE TABLE PRAISE_THE_SUN_GDD.Descuento(
    desc_codigo decimal(18,0) NOT NULL,
    desc_descripcion nvarchar(255) NOT NULL,
	desc_medio_pago decimal(18,0) NOT NULL,
	desc_fecha_inicio datetime NOT NULL,
	desc_fecha_fin datetime NOT NULL,
	desc_porcentaje_desc decimal(18,2) NOT NULL,
	desc_tope decimal(18,2) NOT NULL
);

CREATE TABLE PRAISE_THE_SUN_GDD.Tipo_Medio_Pago(
    timp_codigo decimal(18,0) NOT NULL IDENTITY,
    timp_detalle nvarchar(255) NOT NULL,
);





-- b)
-- CLIENTE
CREATE TABLE PRAISE_THE_SUN_GDD.Cliente(
    clie_codigo decimal(18, 0) NOT NULL identity,
    clie_nombre nvarchar(255) NULL,
    clie_apellido nvarchar(255) NULL,
    clie_dni decimal(18,0) NULL,
    clie_fecha_registro datetime NULL,
    clie_telefono decimal(18,0) NULL,
    clie_mail nvarchar(255) NULL,
    clie_fecha_nacimiento date NULL,
    clie_domicilio nvarchar(255) NULL,
    clie_localidad decimal(18,0) NOT NULL
);

-- TICKET
CREATE TABLE PRAISE_THE_SUN_GDD.Ticket(
	tick_numero decimal(18,0) NOT NULL,
	tick_sucursal decimal(18,0) NOT NULL,  
	tick_tipo nvarchar(255) NOT NULL,
	tick_cliente_codigo decimal(18,0),
	tick_empleado decimal(18,0) NOT NULL,
	tick_caja decimal(18,0) NOT NULL,
  	tick_fecha_hora datetime NOT NULL,
	tick_subtotal_productos decimal(18,2) NULL,
	tick_total_descuento_aplicado decimal(18,2) NULL,
	tick_total_descuento_aplicado_mp decimal(18,2) NULL,
	tick_total_envio decimal(18,2) NULL,
	tick_total_ticket decimal(18,2) NULL
);



-- CAJA
CREATE TABLE PRAISE_THE_SUN_GDD.Caja(
	caja_codigo decimal(18,0) NOT NULL,
   	caja_sucursal decimal(18,0) NOT NULL,
	caja_tipo decimal(18,0) NOT NULL
);

-- TIPO_CAJA
CREATE TABLE PRAISE_THE_SUN_GDD.Tipo_Caja(
    tipc_codigo decimal(18,0) NOT NULL identity,
    tipc_detalle nvarchar(255) NULL
);




-- ENVIO
CREATE TABLE PRAISE_THE_SUN_GDD.Envio(
    envi_codigo decimal(18,0) NOT NULL identity,
    envi_costo decimal(18,2) NULL,
    envi_fecha_programada datetime NULL,
    envi_hora_inicio decimal(18,0) NULL,
    envi_hora_fin decimal(18,0) NULL,
    envi_fecha_entrega datetime NULL,
    envi_estado decimal(18,0) NOT NULL,
    envi_ticket_numero decimal(18,0) NOT NULL,
    envi_ticket_sucursal decimal(18,0) NOT NULL,
    envi_ticket_tipo nvarchar(255) NOT NULL,
    envi_ticket_hora datetime NOT NULL
);

-- ESTADO_ENVIO
CREATE TABLE PRAISE_THE_SUN_GDD.Estado_Envio(
    estd_codigo decimal(18,0) NOT NULL identity,
    estd_detalle nvarchar(255) NULL
);


--c)

CREATE TABLE  PRAISE_THE_SUN_GDD.Empleado (
    empl_codigo DECIMAL(18, 0) NOT NULL identity,   
    empl_nombre NVARCHAR(255) NULL,                 
    empl_apellido NVARCHAR(255) NULL,               
    empl_dni NVARCHAR(50) NULL,                     
    empl_fech_registro NVARCHAR(50) NULL,           
    empl_telefono NVARCHAR(50) NULL,                
    empl_email NVARCHAR(255) NULL,                  
    empl_fech_nacimiento DATE                  
);





CREATE TABLE PRAISE_THE_SUN_GDD.Sucursal (
    sucu_codigo DECIMAL(18, 0) NOT NULL IDENTITY,
    sucu_nombre NVARCHAR(255) NULL,
    sucu_direccion NVARCHAR(255) NULL,
    sucu_localidad DECIMAL(18, 0) NOT NULL,
    sucu_super DECIMAL(18,0) NOT NULL 
    
);


CREATE TABLE PRAISE_THE_SUN_GDD.Localidad (
    loca_codigo DECIMAL(18, 0)  NOT NULL IDENTITY,
    loca_localidad NVARCHAR(255) NULL,
    loca_provincia DECIMAL(18, 0) NOT NULL
);

CREATE TABLE PRAISE_THE_SUN_GDD.Provincia (
    prov_codigo DECIMAL(18, 0) NOT NULL IDENTITY,
    prov_detalle NVARCHAR(255) NULL
);

CREATE TABLE PRAISE_THE_SUN_GDD.Supermercado (
    supe_codigo DECIMAL(18, 0) NOT NULL IDENTITY,
    supe_nombre NVARCHAR(255) NULL,
    supe_domicilio NVARCHAR(255) NULL,
    supe_CUIT NVARCHAR(255) NULL,
    supe_ingr_brut NVARCHAR(255) NULL,
    supe_razon_soc NVARCHAR(255) NULL,
    supe_fecha_inicio DATETIME NULL,
    supe_cond_fiscal NVARCHAR(255) NULL,
    supe_localidad DECIMAL(18, 0) NULL
);



CREATE TABLE PRAISE_THE_SUN_GDD.Item_ticket (
    item_ticket DECIMAL(18, 0) NOT NULL ,        
    item_sucursal DECIMAL(18, 0) NOT NULL,       
    item_tipo NVARCHAR(255) NOT NULL,
    item_fecha_hora datetime NOT NULL,            
    item_producto DECIMAL(18, 0) NOT NULL,       
    item_cantidad DECIMAL(18, 0) NULL,           
    item_precio_unitario DECIMAL(18, 2) NULL,    
    item_precio_total DECIMAL(18, 2) NOT NULL
);






--d)
CREATE TABLE PRAISE_THE_SUN_GDD.Promocion_X_Producto(
    prxp_promocion  DECIMAL(18,0) NOT NULL,
	prxp_producto  DECIMAL(18,0) NOT NULL
);


CREATE TABLE PRAISE_THE_SUN_GDD.Producto(
	prod_codigo DECIMAL(18,0) NOT NULL IDENTITY ,
	prod_nombre nvarchar(255) NOT NULL,
	prod_descripcion nvarchar(255),
	prod_precio DECIMAL(18,2),
	prod_categoria DECIMAL(18,0) NOT NULL, 
	prod_subcategoria DECIMAL(18,0) NOT NULL,
	prod_marca DECIMAL(18,0) NOT NULL
);




CREATE TABLE PRAISE_THE_SUN_GDD.Categoria(
	cate_codigo DECIMAL(18,0) NOT NULL IDENTITY,
	cate_nombre nvarchar(255)
);



CREATE TABLE PRAISE_THE_SUN_GDD.Marca(
	marc_codigo DECIMAL(18,0) NOT NULL IDENTITY,
	marc_detalle nvarchar(255)
);


CREATE TABLE PRAISE_THE_SUN_GDD.Promocion_X_Ticket(
    pxtk_ticket  DECIMAL(18,0) NOT NULL,
	pxtk_sucursal DECIMAL(18,0) NOT NULL, 
	pxtk_tipo nvarchar(255) NOT NULL, 
	pxtk_fecha_hora datetime NOT NULL,
	pxtk_producto DECIMAL(18,0) NOT NULL,
	pxtk_item_tick_total DECIMAL(18,2) NOT NULL,
	pxtk_promo  DECIMAL(18,0) NOT NULL,
	pxtk_descuento_aplicado decimal(18,2)
);


CREATE TABLE PRAISE_THE_SUN_GDD.Promocion(
	prom_codigo DECIMAL(18,0) NOT NULL,
	prom_descripcion nvarchar(255),
	prom_fecha_inicio DATETIME,
	prom_fecha_fin DATETIME,
	prom_regla_codigo DECIMAL(18,0) NOT NULL
);


CREATE TABLE PRAISE_THE_SUN_GDD.Regla(
	regl_codigo DECIMAL(18,0) NOT NULL IDENTITY,
	regl_descripcion nvarchar(255),
	regl_descuento_aplicable_prod  DECIMAL(18,2),
	regl_cantidad_aplicable_regla DECIMAL(18,2),
	regl_cant_aplica_descuento DECIMAL(18,2),
	regl_cant_max_prod DECIMAL(18,2),
	regl_aplica_misma_marca DECIMAL(18,0),
	regl_aplica_mismo_prod DECIMAL(18,0)
);




/**** CREACION DE PKs ****/ 
--a
ALTER TABLE PRAISE_THE_SUN_GDD.Pago ADD CONSTRAINT PK_Pago PRIMARY KEY (pago_codigo)
ALTER TABLE PRAISE_THE_SUN_GDD.Detalle_Pago_Tarjeta ADD CONSTRAINT PK_Detalle_Pago_Tarjeta PRIMARY KEY (deta_codigo)
ALTER TABLE PRAISE_THE_SUN_GDD.Descuento_X_Medio_Pago ADD CONSTRAINT PK_Descuento_X_Medio_Pago PRIMARY KEY (dxmp_pago_codigo, dxmp_desc_codigo)
ALTER TABLE PRAISE_THE_SUN_GDD.Medio_De_Pago ADD CONSTRAINT PK_Medio_De_Pago PRIMARY KEY (medp_codigo)
ALTER TABLE PRAISE_THE_SUN_GDD.Descuento ADD CONSTRAINT PK_Descuento PRIMARY KEY (desc_codigo)
ALTER TABLE PRAISE_THE_SUN_GDD.Tipo_Medio_Pago ADD CONSTRAINT PK_Tipo_Medio_Pago PRIMARY KEY (timp_codigo)
--b
-- b
ALTER TABLE PRAISE_THE_SUN_GDD.Cliente ADD CONSTRAINT PK_Cliente PRIMARY KEY (clie_codigo);
ALTER TABLE PRAISE_THE_SUN_GDD.Ticket ADD CONSTRAINT PK_Ticket PRIMARY KEY (tick_numero, tick_sucursal, tick_tipo, tick_fecha_hora);
ALTER TABLE PRAISE_THE_SUN_GDD.Caja ADD CONSTRAINT PK_Caja PRIMARY KEY (caja_codigo, caja_sucursal);
ALTER TABLE PRAISE_THE_SUN_GDD.Tipo_Caja ADD CONSTRAINT PK_Tipo_Caja PRIMARY KEY (tipc_codigo);
ALTER TABLE PRAISE_THE_SUN_GDD.Envio ADD CONSTRAINT PK_Envio PRIMARY KEY (envi_codigo);
ALTER TABLE PRAISE_THE_SUN_GDD.Estado_Envio ADD CONSTRAINT PK_Estado_Envio PRIMARY KEY (estd_codigo);
--c
ALTER TABLE PRAISE_THE_SUN_GDD.Empleado ADD CONSTRAINT PK_Empleado PRIMARY KEY (empl_codigo) 
ALTER TABLE PRAISE_THE_SUN_GDD.Sucursal ADD CONSTRAINT PK_Sucursal PRIMARY KEY (sucu_codigo) ;
ALTER TABLE PRAISE_THE_SUN_GDD.Localidad ADD CONSTRAINT PK_Localidad PRIMARY KEY (loca_codigo) ;
ALTER TABLE PRAISE_THE_SUN_GDD.Provincia ADD CONSTRAINT PK_Provincia PRIMARY KEY (prov_codigo);
ALTER TABLE PRAISE_THE_SUN_GDD.Supermercado ADD CONSTRAINT PK_Supermercado PRIMARY KEY (supe_codigo);
ALTER TABLE  PRAISE_THE_SUN_GDD.Item_ticket
 ADD CONSTRAINT PK_Item_ticket PRIMARY KEY (item_ticket, item_sucursal, item_tipo, item_fecha_hora, item_producto, item_precio_total);

--d
--PK
ALTER TABLE PRAISE_THE_SUN_GDD.Promocion_X_Producto ADD CONSTRAINT PK_Promocion_X_Producto PRIMARY KEY(prxp_promocion, prxp_producto)
ALTER TABLE PRAISE_THE_SUN_GDD.Producto ADD CONSTRAINT PK_Producto PRIMARY KEY(prod_codigo)
ALTER TABLE PRAISE_THE_SUN_GDD.Categoria ADD CONSTRAINT PK_Categoria PRIMARY KEY(cate_codigo)
ALTER TABLE PRAISE_THE_SUN_GDD.Marca ADD CONSTRAINT PK_Marca PRIMARY KEY(marc_codigo);
ALTER TABLE PRAISE_THE_SUN_GDD.Promocion_X_Ticket ADD CONSTRAINT PK_Promocion_X_Ticket PRIMARY KEY(pxtk_ticket, pxtk_sucursal, pxtk_tipo, pxtk_fecha_hora, pxtk_producto,pxtk_promo, pxtk_item_tick_total);
ALTER TABLE PRAISE_THE_SUN_GDD.Promocion ADD CONSTRAINT PK_Promocion PRIMARY KEY(prom_codigo);
ALTER TABLE PRAISE_THE_SUN_GDD.Regla ADD CONSTRAINT PK_Regla PRIMARY KEY(regl_codigo);


/**** CREACION DE FKs ****/
--a
ALTER TABLE PRAISE_THE_SUN_GDD.Pago ADD CONSTRAINT FK_pago_medio_pago FOREIGN KEY (pago_medio_pago) REFERENCES PRAISE_THE_SUN_GDD.Medio_De_Pago(medp_codigo)
ALTER TABLE PRAISE_THE_SUN_GDD.Pago ADD CONSTRAINT FK_pago_detalle FOREIGN KEY (pago_detalle) REFERENCES PRAISE_THE_SUN_GDD.Detalle_Pago_Tarjeta(deta_codigo)
ALTER TABLE PRAISE_THE_SUN_GDD.Pago ADD CONSTRAINT FK_pago_cliente FOREIGN KEY (pago_cliente) REFERENCES PRAISE_THE_SUN_GDD.Cliente(clie_codigo)
ALTER TABLE PRAISE_THE_SUN_GDD.Descuento_X_Medio_Pago ADD CONSTRAINT FK_dxmp_pago_codigo FOREIGN KEY (dxmp_pago_codigo) REFERENCES PRAISE_THE_SUN_GDD.Pago(pago_codigo)
ALTER TABLE PRAISE_THE_SUN_GDD.Descuento_X_Medio_Pago ADD CONSTRAINT FK_dxmp_desc_codigo FOREIGN KEY (dxmp_desc_codigo) REFERENCES PRAISE_THE_SUN_GDD.Descuento(desc_codigo)
ALTER TABLE PRAISE_THE_SUN_GDD.Medio_De_Pago ADD CONSTRAINT FK_medp_tipo FOREIGN KEY (medp_tipo) REFERENCES PRAISE_THE_SUN_GDD.Tipo_Medio_Pago(timp_codigo)
ALTER TABLE PRAISE_THE_SUN_GDD.Descuento ADD CONSTRAINT FK_desc_medio_pago FOREIGN KEY (desc_medio_pago) REFERENCES PRAISE_THE_SUN_GDD.Medio_De_Pago(medp_codigo)

-- b
ALTER TABLE PRAISE_THE_SUN_GDD.Cliente ADD CONSTRAINT FK_clie_localidad FOREIGN KEY (clie_localidad) REFERENCES PRAISE_THE_SUN_GDD.Localidad(loca_codigo);
ALTER TABLE PRAISE_THE_SUN_GDD.Ticket ADD CONSTRAINT FK_tick_sucursal FOREIGN KEY (tick_sucursal) REFERENCES PRAISE_THE_SUN_GDD.Sucursal (sucu_codigo);
ALTER TABLE PRAISE_THE_SUN_GDD.Ticket ADD CONSTRAINT FK_tick_cliente_codigo FOREIGN KEY (tick_cliente_codigo) REFERENCES PRAISE_THE_SUN_GDD.Cliente(clie_codigo);
ALTER TABLE PRAISE_THE_SUN_GDD.Ticket ADD CONSTRAINT FK_tick_empleado FOREIGN KEY (tick_empleado) REFERENCES PRAISE_THE_SUN_GDD.Empleado(empl_codigo);
ALTER TABLE PRAISE_THE_SUN_GDD.Ticket ADD CONSTRAINT FK_tick_caja FOREIGN KEY (tick_caja, tick_sucursal) REFERENCES PRAISE_THE_SUN_GDD.Caja(caja_codigo, caja_sucursal);
ALTER TABLE PRAISE_THE_SUN_GDD.Caja ADD CONSTRAINT FK_caja_tipo FOREIGN KEY (caja_tipo) REFERENCES PRAISE_THE_SUN_GDD.Tipo_Caja(tipc_codigo);
ALTER TABLE PRAISE_THE_SUN_GDD.Caja ADD CONSTRAINT FK_caja_sucursal FOREIGN KEY (caja_sucursal) REFERENCES PRAISE_THE_SUN_GDD.Sucursal(sucu_codigo);
ALTER TABLE PRAISE_THE_SUN_GDD.Envio ADD CONSTRAINT FK_envi_estado FOREIGN KEY (envi_estado) REFERENCES PRAISE_THE_SUN_GDD.Estado_Envio(estd_codigo);
ALTER TABLE PRAISE_THE_SUN_GDD.Envio ADD CONSTRAINT FK_envi_ticket FOREIGN KEY (envi_ticket_numero, envi_ticket_sucursal, envi_ticket_tipo, envi_ticket_hora) 
	REFERENCES PRAISE_THE_SUN_GDD.Ticket (tick_numero, tick_sucursal, tick_tipo, tick_fecha_hora)

--c
ALTER TABLE  PRAISE_THE_SUN_GDD.Sucursal
ADD CONSTRAINT FK_SucursalLocalidad
FOREIGN KEY (sucu_localidad) REFERENCES PRAISE_THE_SUN_GDD.Localidad(loca_codigo);

ALTER TABLE  PRAISE_THE_SUN_GDD.Sucursal
ADD CONSTRAINT FK_SucursalSupermercado
FOREIGN KEY (sucu_super) REFERENCES PRAISE_THE_SUN_GDD.Supermercado(supe_codigo);
ALTER TABLE  PRAISE_THE_SUN_GDD.Supermercado
ADD CONSTRAINT FK_SupermercadoLocalidad
FOREIGN KEY (supe_localidad) REFERENCES PRAISE_THE_SUN_GDD.Localidad(loca_codigo);

ALTER TABLE PRAISE_THE_SUN_GDD.Item_ticket
ADD CONSTRAINT FK_Item_ticket FOREIGN KEY (item_ticket, item_sucursal, item_tipo, item_fecha_hora) 
	REFERENCES PRAISE_THE_SUN_GDD.Ticket (tick_numero, tick_sucursal, tick_tipo, tick_fecha_hora);

ALTER TABLE PRAISE_THE_SUN_GDD.Item_ticket
ADD CONSTRAINT FK_Item_ticket_producto FOREIGN KEY (item_producto) REFERENCES PRAISE_THE_SUN_GDD.Producto(prod_codigo);



--d
ALTER TABLE PRAISE_THE_SUN_GDD.Promocion ADD CONSTRAINT FK_prom_regla_codigo FOREIGN KEY (prom_regla_codigo) REFERENCES PRAISE_THE_SUN_GDD.Regla(regl_codigo);
ALTER TABLE PRAISE_THE_SUN_GDD.Promocion_X_Producto ADD CONSTRAINT FK_prxp_promocion FOREIGN KEY (prxp_promocion) REFERENCES PRAISE_THE_SUN_GDD.Promocion(prom_codigo);
ALTER TABLE PRAISE_THE_SUN_GDD.Promocion_X_Producto ADD CONSTRAINT FK_prxp_producto FOREIGN KEY (prxp_producto) REFERENCES PRAISE_THE_SUN_GDD.Producto(prod_codigo);
ALTER TABLE PRAISE_THE_SUN_GDD.Producto ADD CONSTRAINT FK_prod_categoria FOREIGN KEY (prod_categoria) REFERENCES PRAISE_THE_SUN_GDD.Categoria(cate_codigo);
ALTER TABLE PRAISE_THE_SUN_GDD.Producto ADD CONSTRAINT FK_prod_subcategoria FOREIGN KEY (prod_subcategoria) REFERENCES PRAISE_THE_SUN_GDD.Categoria(cate_codigo);
ALTER TABLE PRAISE_THE_SUN_GDD.Producto ADD CONSTRAINT FK_prod_marca FOREIGN KEY (prod_marca) REFERENCES PRAISE_THE_SUN_GDD.Marca(marc_codigo);
ALTER TABLE PRAISE_THE_SUN_GDD.Promocion_X_Ticket ADD CONSTRAINT FK_pxtk_ticket FOREIGN KEY (pxtk_ticket, pxtk_sucursal, pxtk_tipo, pxtk_fecha_hora, pxtk_producto, pxtk_item_tick_total) 
	REFERENCES PRAISE_THE_SUN_GDD.Item_ticket(item_ticket, item_sucursal, item_tipo, item_fecha_hora, item_producto, item_precio_total);
ALTER TABLE PRAISE_THE_SUN_GDD.Promocion_X_Ticket ADD CONSTRAINT FK_pxtk_promo FOREIGN KEY (pxtk_promo) REFERENCES PRAISE_THE_SUN_GDD.Promocion(prom_codigo);
;

/***********************************************************************************/


/*********************************INSERTS DE LAS TABLAS*********************************/

-- (1)
/*
DETALLE_PAGO_TARJETA (1)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Detalle_Pago_Tarjeta(deta_pago_nro_tarjeta, deta_pago_tarjeta_fecha_venc, deta_pago_tarjeta_cuotas)
SELECT	 PAGO_TARJETA_NRO
		,PAGO_TARJETA_FECHA_VENC
		,PAGO_TARJETA_CUOTAS
FROM GD1C2024.gd_esquema.Maestra WHERE PAGO_TARJETA_NRO IS NOT NULL

/*
TIPO_MEDIO_PAGO (1)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Tipo_Medio_Pago(timp_detalle)
SELECT	distinct([PAGO_TIPO_MEDIO_PAGO])
FROM GD1C2024.gd_esquema.Maestra WHERE PAGO_TIPO_MEDIO_PAGO IS NOT NULL

/*
PROVINCIA (1)
*/ 
INSERT INTO PRAISE_THE_SUN_GDD.Provincia(prov_detalle)
SELECT DISTINCT CLIENTE_PROVINCIA
FROM GD1C2024.gd_esquema.Maestra
WHERE CLIENTE_PROVINCIA IS NOT NULL
 
/*
MARCA (1)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Marca(marc_detalle)
	SELECT DISTINCT (PRODUCTO_MARCA) FROM gd_esquema.Maestra
	WHERE PRODUCTO_MARCA IS NOT NULL

/*
CATEGORIA (1)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Categoria(cate_nombre)
	SELECT  DISTINCT (PRODUCTO_CATEGORIA) FROM gd_esquema.Maestra
	WHERE PRODUCTO_CATEGORIA IS NOT NULL
	UNION
	SELECT DISTINCT (PRODUCTO_SUB_CATEGORIA) FROM gd_esquema.Maestra
	WHERE PRODUCTO_CATEGORIA IS NOT NULL


/*
REGLA (1)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Regla
	(regl_descripcion,
	regl_descuento_aplicable_prod,
	regl_cantidad_aplicable_regla,
	regl_cant_aplica_descuento,
	regl_cant_max_prod,
	regl_aplica_misma_marca,
	regl_aplica_mismo_prod)
SELECT	DISTINCT 
		REGLA_DESCRIPCION,
		REGLA_DESCUENTO_APLICABLE_PROD,
		REGLA_CANT_APLICABLE_REGLA,
		REGLA_CANT_APLICA_DESCUENTO,
		REGLA_CANT_MAX_PROD,
		REGLA_APLICA_MISMA_MARCA,
		REGLA_APLICA_MISMO_PROD
FROM gd_esquema.Maestra
WHERE 
	REGLA_APLICA_MISMA_MARCA IS NOT NULL AND
	REGLA_APLICA_MISMO_PROD IS NOT NULL AND
	REGLA_CANT_APLICA_DESCUENTO IS NOT NULL AND
	REGLA_CANT_APLICABLE_REGLA IS NOT NULL AND
	REGLA_CANT_MAX_PROD IS NOT NULL AND
	REGLA_DESCRIPCION IS NOT NULL AND
	REGLA_DESCUENTO_APLICABLE_PROD IS NOT NULL

/*
TIPO_CAJA (1)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Tipo_Caja (tipc_detalle)
SELECT DISTINCT CAJA_TIPO
FROM GD1C2024.gd_esquema.Maestra WHERE CAJA_TIPO IS NOT NULL

/*
ESTADO_ENVIO (1)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Estado_Envio (estd_detalle)
SELECT DISTINCT ENVIO_ESTADO
FROM GD1C2024.gd_esquema.Maestra WHERE ENVIO_ESTADO IS NOT NULL






/*
EMPLEADO (1)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Empleado(empl_nombre, empl_apellido, empl_dni,  empl_fech_registro, empl_telefono, empl_email, empl_fech_nacimiento)
SELECT DISTINCT
   	EMPLEADO_NOMBRE,
   	EMPLEADO_APELLIDO,
   	EMPLEADO_DNI,
   	EMPLEADO_FECHA_REGISTRO,
   	EMPLEADO_TELEFONO,
   	EMPLEADO_MAIL,
   	EMPLEADO_FECHA_NACIMIENTO
FROM GD_ESQUEMA.Maestra
WHERE
   	EMPLEADO_NOMBRE IS NOT NULL AND
   	EMPLEADO_APELLIDO IS NOT NULL AND
   	EMPLEADO_DNI IS NOT NULL AND
   	EMPLEADO_FECHA_REGISTRO IS NOT NULL AND
   	EMPLEADO_TELEFONO IS NOT NULL AND
   	EMPLEADO_MAIL IS NOT NULL AND
   	EMPLEADO_FECHA_NACIMIENTO IS NOT NULL AND
   	EMPLEADO_FECHA_NACIMIENTO IS NOT NULL


---------------------------------------------------------------------------------------------------------------------------
-- (2)
/*
MEDIO_DE_PAGO (2)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Medio_De_Pago(medp_detalle, medp_tipo)
SELECT DISTINCT  PAGO_MEDIO_PAGO
		,TMP.timp_codigo
FROM GD1C2024.gd_esquema.Maestra JOIN PRAISE_THE_SUN_GDD.Tipo_Medio_Pago TMP ON PAGO_TIPO_MEDIO_PAGO = TMP.timp_detalle
WHERE PAGO_MEDIO_PAGO IS NOT NULL

/*
LOCALIDAD (2)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Localidad(loca_localidad, loca_provincia)
SELECT DISTINCT CLIENTE_LOCALIDAD,
                prov_codigo
FROM GD1C2024.gd_esquema.Maestra
    JOIN PRAISE_THE_SUN_GDD.Provincia ON CLIENTE_PROVINCIA = prov_detalle
WHERE CLIENTE_PROVINCIA IS NOT NULL AND
        CLIENTE_LOCALIDAD IS NOT NULL

/*
PRODUCTO (2)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Producto(prod_nombre,prod_descripcion,prod_precio,prod_categoria,prod_subcategoria,prod_marca)
	SELECT DISTINCT
		M.PRODUCTO_NOMBRE,
		M.PRODUCTO_DESCRIPCION,
		M.PRODUCTO_PRECIO,
		cat.cate_codigo,
		subCat.cate_codigo,
		marc.marc_codigo
	FROM gd_esquema.Maestra M
		JOIN PRAISE_THE_SUN_GDD.Categoria cat
		ON cat.cate_nombre = M.PRODUCTO_CATEGORIA
		JOIN PRAISE_THE_SUN_GDD.Categoria subCat
		ON subCat.cate_nombre = M.PRODUCTO_SUB_CATEGORIA
		JOIN PRAISE_THE_SUN_GDD.Marca marc
		ON marc.marc_detalle = M.PRODUCTO_MARCA;

---------------------------------------------------------------------------------------------------------------------------
-- (3)
/*
DESCUENTO (3)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Descuento(desc_codigo, desc_descripcion, desc_medio_pago, desc_fecha_inicio, desc_fecha_fin, desc_porcentaje_desc, desc_tope)
SELECT	 DISTINCT DESCUENTO_CODIGO
		,DESCUENTO_DESCRIPCION
		,MDP.medp_codigo
		,DESCUENTO_FECHA_INICIO
		,DESCUENTO_FECHA_FIN
		,DESCUENTO_PORCENTAJE_DESC
		,DESCUENTO_TOPE
FROM GD1C2024.gd_esquema.Maestra 
JOIN PRAISE_THE_SUN_GDD.Medio_De_Pago MDP ON PAGO_MEDIO_PAGO=MDP.medp_detalle 
WHERE DESCUENTO_CODIGO IS NOT NULL

/*
CLIENTE (3)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Cliente(clie_nombre, clie_apellido, clie_dni, clie_fecha_registro, clie_telefono, clie_mail, clie_fecha_nacimiento, clie_domicilio, clie_localidad)
SELECT CLIENTE_NOMBRE
   	 ,CLIENTE_APELLIDO
   	 ,CLIENTE_DNI
   	 ,CLIENTE_FECHA_REGISTRO
   	 ,CLIENTE_TELEFONO
   	 ,CLIENTE_MAIL
   	 ,CLIENTE_FECHA_NACIMIENTO
   	 ,CLIENTE_DOMICILIO
   	 ,loca_codigo
FROM GD1C2024.gd_esquema.Maestra
    JOIN PRAISE_THE_SUN_GDD.Localidad ON loca_localidad = CLIENTE_LOCALIDAD
    JOIN PRAISE_THE_SUN_GDD.Provincia ON loca_provincia = prov_codigo AND CLIENTE_PROVINCIA = prov_detalle
WHERE 	 CLIENTE_NOMBRE IS NOT NULL AND
   	 CLIENTE_APELLIDO IS NOT NULL AND
   	 CLIENTE_DNI IS NOT NULL AND
   	 CLIENTE_FECHA_REGISTRO IS NOT NULL AND
   	 CLIENTE_TELEFONO IS NOT NULL AND
   	 CLIENTE_MAIL IS NOT NULL AND
   	 CLIENTE_FECHA_NACIMIENTO IS NOT NULL AND
   	 CLIENTE_DOMICILIO IS NOT NULL AND
   	 CLIENTE_LOCALIDAD IS NOT NULL

/*
SUPERMERCADO (3)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Supermercado(supe_nombre, supe_domicilio, supe_CUIT, supe_ingr_brut, 
											supe_razon_soc, supe_fecha_inicio, supe_cond_fiscal, supe_localidad)
SELECT	 DISTINCT 
		 SUPER_NOMBRE
		,SUPER_DOMICILIO
		,SUPER_CUIT
		,SUPER_IIBB
		,SUPER_RAZON_SOC
		,SUPER_FECHA_INI_ACTIVIDAD
		,SUPER_CONDICION_FISCAL
		,L.loca_codigo
FROM GD1C2024.gd_esquema.Maestra
JOIN PRAISE_THE_SUN_GDD.Localidad L ON SUPER_LOCALIDAD=L.loca_localidad
WHERE SUPER_NOMBRE IS NOT NULL AND SUPER_DOMICILIO IS NOT NULL AND SUPER_CUIT IS NOT NULL AND SUPER_IIBB IS NOT NULL AND SUPER_RAZON_SOC IS NOT NULL
	AND SUPER_FECHA_INI_ACTIVIDAD IS NOT NULL AND SUPER_CONDICION_FISCAL IS NOT NULL AND SUPER_LOCALIDAD IS NOT NULL


/*
PROMOCION (3)
*/

INSERT INTO PRAISE_THE_SUN_GDD.Promocion(prom_codigo, prom_descripcion,prom_fecha_inicio,prom_fecha_fin,prom_regla_codigo)
	SELECT DISTINCT
	PROMO_CODIGO,
	PROMOCION_DESCRIPCION,
	PROMOCION_FECHA_INICIO,
	PROMOCION_FECHA_FIN,
	re.regl_codigo
	FROM gd_esquema.Maestra M
	JOIN PRAISE_THE_SUN_GDD.Regla re ON  re.regl_descripcion = M.REGLA_DESCRIPCION

---------------------------------------------------------------------------------------------------------------------------
-- (4)
/*
PAGO (4)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Pago(pago_fecha, pago_importe, pago_medio_pago, pago_detalle, pago_cliente)
SELECT DISTINCT M1.PAGO_FECHA
      ,M1.PAGO_IMPORTE
	  ,MDP.medp_codigo
	  ,DPT.deta_codigo
	  ,(SELECT MAX(clie_codigo) FROM PRAISE_THE_SUN_GDD.Cliente 
							JOIN GD1C2024.gd_esquema.Maestra M2 ON clie_dni = M2.CLIENTE_DNI 
							WHERE M2.TICKET_NUMERO = M1.TICKET_NUMERO)
FROM GD1C2024.gd_esquema.Maestra M1
JOIN PRAISE_THE_SUN_GDD.Medio_De_Pago MDP ON M1.PAGO_MEDIO_PAGO=MDP.medp_detalle
LEFT JOIN PRAISE_THE_SUN_GDD.Detalle_Pago_Tarjeta DPT ON M1.PAGO_TARJETA_NRO=deta_pago_nro_tarjeta AND M1.PAGO_TARJETA_FECHA_VENC=deta_pago_tarjeta_fecha_venc AND M1.PAGO_TARJETA_CUOTAS=deta_pago_tarjeta_cuotas
LEFT JOIN PRAISE_THE_SUN_GDD.Localidad L ON M1.CLIENTE_LOCALIDAD=L.loca_localidad
WHERE M1.PAGO_IMPORTE IS NOT NULL

/*
SUCURSAL (4)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Sucursal(sucu_nombre, sucu_direccion, sucu_localidad, sucu_super)
SELECT  DISTINCT SUCURSAL_NOMBRE
       ,SUCURSAL_DIRECCION
       ,L.loca_codigo
	   ,SM.supe_codigo
FROM GD1C2024.gd_esquema.Maestra M
    JOIN PRAISE_THE_SUN_GDD.Localidad L ON l.loca_localidad= M.SUCURSAL_LOCALIDAD
	JOIN PRAISE_THE_SUN_GDD.Supermercado SM ON SUPER_CUIT= SM.supe_CUIT
WHERE SUCURSAL_NOMBRE IS NOT NULL AND SUCURSAL_PROVINCIA IS NOT NULL AND L.loca_codigo IS NOT NULL AND SM.supe_codigo IS NOT NULL 


/*
PROMOCION_X_PRODUCTO (4)
*/
INSERT PRAISE_THE_SUN_GDD.Promocion_X_Producto(prxp_producto,prxp_promocion) SELECT prod.prod_codigo, promo.prom_codigo FROM gd_esquema.Maestra M JOIN PRAISE_THE_SUN_GDD.Producto prod ON prod.prod_descripcion = PRODUCTO_DESCRIPCION JOIN PRAISE_THE_SUN_GDD.Marca ma ON ma.marc_codigo = prod.prod_marca AND ma.marc_detalle = PRODUCTO_MARCA JOIN PRAISE_THE_SUN_GDD.Promocion promo ON promo.prom_codigo = PROMO_CODIGO GROUP BY prod.prod_codigo, promo.prom_codigo ORDER BY 1,2 ASC
---------------------------------------------------------------------------------------------------------------------------
-- (5)
/*
DESCUENTO_X_MEDIO_PAGO (5)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Descuento_X_Medio_Pago(dxmp_pago_codigo, dxmp_desc_codigo, dxmp_desc_aplicado)
SELECT	 DISTINCT P.pago_codigo
		,desc_codigo
		,TICKET_TOTAL_DESCUENTO_APLICADO_MP --NO estoy seguro si hay que poner esto en este campo
FROM GD1C2024.gd_esquema.Maestra M
JOIN PRAISE_THE_SUN_GDD.Descuento D ON DESCUENTO_CODIGO=D.desc_codigo
JOIN PRAISE_THE_SUN_GDD.Pago P 
	ON M.PAGO_FECHA=P.pago_fecha AND M.PAGO_IMPORTE=P.pago_importe
WHERE P.pago_codigo IS NOT NULL AND D.desc_codigo IS NOT NULL

/*
CAJA (5)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Caja (caja_codigo, caja_sucursal, caja_tipo)
SELECT DISTINCT CAJA_NUMERO,
   	 sucu_codigo, -- Me falta el codigo de sucursal, pero lo voy a tener una vez creada la entidad
   	 tipc_codigo
FROM GD1C2024.gd_esquema.Maestra
    JOIN PRAISE_THE_SUN_GDD.Tipo_Caja ON tipc_detalle = CAJA_TIPO
    JOIN PRAISE_THE_SUN_GDD.Sucursal ON SUCURSAL_NOMBRE = sucu_nombre --> Creo que es asi
WHERE CAJA_NUMERO IS NOT NULL AND
   	 SUCURSAL_NOMBRE IS NOT NULL

---------------------------------------------------------------------------------------------------------------------------
--6
/*
TICKET (6)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Ticket(tick_numero, tick_sucursal, tick_tipo, tick_cliente_codigo, tick_empleado, tick_caja, tick_fecha_hora,
   								 tick_subtotal_productos, tick_total_descuento_aplicado, tick_total_descuento_aplicado_mp, tick_total_envio, tick_total_ticket)
SELECT
     DISTINCT M1.TICKET_NUMERO
    ,sucu_codigo
    ,M1.TICKET_TIPO_COMPROBANTE
    ,(SELECT MAX(clie_codigo) FROM PRAISE_THE_SUN_GDD.Cliente
   						 JOIN GD1C2024.gd_esquema.Maestra M2 ON clie_dni = M2.CLIENTE_DNI
   						 WHERE M2.TICKET_NUMERO = M1.TICKET_NUMERO)
    ,empl_codigo
    ,caja_codigo
    ,M1.TICKET_FECHA_HORA
    ,M1.TICKET_SUBTOTAL_PRODUCTOS
    ,M1.TICKET_TOTAL_DESCUENTO_APLICADO
    ,M1.TICKET_TOTAL_DESCUENTO_APLICADO_MP
    ,M1.TICKET_TOTAL_ENVIO
    ,M1.TICKET_TOTAL_TICKET
FROM GD1C2024.gd_esquema.Maestra M1
    JOIN PRAISE_THE_SUN_GDD.Sucursal ON sucu_nombre = M1.SUCURSAL_NOMBRE
    JOIN PRAISE_THE_SUN_GDD.Empleado ON empl_dni = M1.EMPLEADO_DNI
    JOIN PRAISE_THE_SUN_GDD.Caja ON caja_sucursal = sucu_codigo and M1.CAJA_NUMERO = caja_codigo
WHERE M1.TICKET_NUMERO IS NOT NULL AND
   	 M1.TICKET_TIPO_COMPROBANTE IS NOT NULL AND
   	 M1.TICKET_FECHA_HORA IS NOT NULL AND
   	 M1.TICKET_SUBTOTAL_PRODUCTOS IS NOT NULL AND
   	 M1.TICKET_SUBTOTAL_PRODUCTOS IS NOT NULL AND
   	 M1.TICKET_TOTAL_DESCUENTO_APLICADO IS NOT NULL AND
   	 M1.TICKET_TOTAL_DESCUENTO_APLICADO_MP IS NOT NULL AND
   	 M1.TICKET_TOTAL_ENVIO IS NOT NULL AND
   	 M1.TICKET_TOTAL_ENVIO IS NOT NULL
ORDER BY 1

/*
ITEM_TICKET (6)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Item_ticket(item_ticket, item_sucursal, item_tipo, item_fecha_hora, item_producto, item_cantidad, item_precio_unitario, item_precio_total)
SELECT DISTINCT T.tick_numero,
		T.tick_sucursal,
        T.tick_tipo,
		T.tick_fecha_hora,
        P.prod_codigo,
        TICKET_DET_CANTIDAD,
		TICKET_DET_PRECIO,
		TICKET_DET_TOTAL
FROM GD1C2024.gd_esquema.Maestra
	JOIN PRAISE_THE_SUN_GDD.Sucursal S ON SUCURSAL_NOMBRE=S.sucu_nombre
	JOIN PRAISE_THE_SUN_GDD.Ticket T ON TICKET_NUMERO=T.tick_numero AND S.sucu_codigo=T.tick_sucursal AND TICKET_TIPO_COMPROBANTE=T.tick_tipo AND TICKET_FECHA_HORA=T.tick_fecha_hora
	JOIN PRAISE_THE_SUN_GDD.Marca ON PRODUCTO_MARCA=marc_detalle
	JOIN PRAISE_THE_SUN_GDD.Categoria C1 ON PRODUCTO_CATEGORIA=C1.cate_nombre
	JOIN PRAISE_THE_SUN_GDD.Categoria C2 ON PRODUCTO_SUB_CATEGORIA=C2.cate_nombre
	JOIN PRAISE_THE_SUN_GDD.Producto P ON PRODUCTO_NOMBRE=P.prod_nombre AND marc_codigo=P.prod_marca AND C1.cate_codigo=P.prod_categoria AND C2.cate_codigo=P.prod_subcategoria


---------------------------------------------------------------------------------------------------------------------------
--7
/*
ENVIO (7)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Envio (envi_costo, envi_fecha_programada, envi_hora_inicio,
	envi_hora_fin, envi_fecha_entrega, envi_estado, envi_ticket_numero, envi_ticket_sucursal, envi_ticket_tipo, envi_ticket_hora)
SELECT    ENVIO_COSTO
   	 ,ENVIO_FECHA_PROGRAMADA
   	 ,ENVIO_HORA_INICIO
   	 ,ENVIO_HORA_FIN
   	 ,ENVIO_FECHA_ENTREGA
   	 ,estd_codigo
   	 ,tick_numero
   	 ,sucu_codigo
   	 ,tick_tipo
   	 ,tick_fecha_hora
FROM GD1C2024.gd_esquema.Maestra
    JOIN PRAISE_THE_SUN_GDD.Estado_Envio ON ENVIO_ESTADO = estd_detalle
    JOIN PRAISE_THE_SUN_GDD.Sucursal ON SUCURSAL_NOMBRE = sucu_nombre
    JOIN PRAISE_THE_SUN_GDD.Ticket ON TICKET_NUMERO = tick_numero and TICKET_TIPO_COMPROBANTE = tick_tipo and TICKET_FECHA_HORA = tick_fecha_hora
WHERE ENVIO_COSTO = TICKET_TOTAL_ENVIO AND
   	 ENVIO_FECHA_PROGRAMADA IS NOT NULL AND
   	 ENVIO_HORA_INICIO IS NOT NULL AND
   	 ENVIO_HORA_FIN IS NOT NULL AND
   	 ENVIO_FECHA_ENTREGA IS NOT NULL AND
   	 TICKET_NUMERO IS NOT NULL AND
   	 SUCURSAL_NOMBRE IS NOT NULL AND
   	 TICKET_TIPO_COMPROBANTE IS NOT NULL

/*
PROMOCION_X_TICKET (7)
*/
INSERT INTO PRAISE_THE_SUN_GDD.Promocion_X_Ticket(pxtk_ticket, pxtk_sucursal, pxtk_tipo, pxtk_fecha_hora,pxtk_producto, pxtk_promo, pxtk_descuento_aplicado, pxtk_item_tick_total)
SELECT	 DISTINCT 
		 IT.item_ticket
		,IT.item_sucursal
		,IT.item_tipo
		,IT.item_fecha_hora
		,IT.item_producto
		,PM.prom_codigo
		,PROMO_APLICADA_DESCUENTO
		,IT.item_precio_total
FROM GD1C2024.gd_esquema.Maestra
JOIN PRAISE_THE_SUN_GDD.Sucursal S ON SUCURSAL_NOMBRE=S.sucu_nombre
JOIN PRAISE_THE_SUN_GDD.Marca ON PRODUCTO_MARCA=marc_detalle
JOIN PRAISE_THE_SUN_GDD.Categoria C1 ON PRODUCTO_CATEGORIA=C1.cate_nombre
JOIN PRAISE_THE_SUN_GDD.Categoria C2 ON PRODUCTO_SUB_CATEGORIA=C2.cate_nombre
JOIN PRAISE_THE_SUN_GDD.Producto P ON PRODUCTO_NOMBRE=P.prod_nombre AND marc_codigo=P.prod_marca AND C1.cate_codigo=P.prod_categoria AND C2.cate_codigo=P.prod_subcategoria
JOIN PRAISE_THE_SUN_GDD.Item_Ticket IT ON TICKET_NUMERO=IT.item_ticket AND S.sucu_codigo=IT.item_sucursal  
		AND TICKET_TIPO_COMPROBANTE=IT.item_tipo AND TICKET_FECHA_HORA=IT.item_fecha_hora AND P.prod_codigo=IT.item_producto 
		AND TICKET_DET_TOTAL=IT.item_precio_total
JOIN PRAISE_THE_SUN_GDD.Promocion PM ON PROMO_CODIGO=PM.prom_codigo






