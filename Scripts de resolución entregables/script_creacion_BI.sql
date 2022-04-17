USE GD2C2020
GO

CREATE FUNCTION GESTION_DE_DUENDES.fx_cantidad_cambios (@tipo_codigo_caja DECIMAL(18,0))
RETURNS INT
AS BEGIN
	DECLARE @RETORNO INT
	SET @RETORNO = CASE @tipo_codigo_caja WHEN 1001 THEN 1
										WHEN 1002 THEN 2
										WHEN 1003 THEN 3
										WHEN 1004 THEN 4
	END

	RETURN @RETORNO

END
GO
;


CREATE FUNCTION GESTION_DE_DUENDES.fx_rango_etario(@edad DECIMAL(18,0))
RETURNS VARCHAR(255)
AS BEGIN
	DECLARE @RETORNO VARCHAR(255)
	SET @RETORNO = CASE
		WHEN @edad > 50 THEN 'Rango3'
		WHEN @edad  > 30 THEN 'Rango2'
		WHEN @edad >= 18 THEN 'Rango1'
		ELSE 'Error'
	END
	RETURN @RETORNO
END
GO
;

CREATE FUNCTION GESTION_DE_DUENDES.fx_rango_potencia(@potencia DECIMAL(18,0))
RETURNS nvarchar(20)
AS BEGIN
    DECLARE @RETORNO nvarchar(20)
    SET @RETORNO = CASE
        WHEN @potencia > 300 THEN 'Potente'
        WHEN @potencia  > 150 THEN 'Medio'
        WHEN @potencia >= 50 THEN 'Bajo'
        ELSE 'Error'
    END
    RETURN @RETORNO
END
GO
;

CREATE TABLE GESTION_DE_DUENDES.dimensionCliente(
ID_Cliente varchar(100),
rango_etario varchar(255),
sexo varchar(15),
PRIMARY KEY (ID_Cliente),
);

CREATE TABLE GESTION_DE_DUENDES.hechos_automovil_compra(
anio_compra decimal(4),
mes_compra decimal(2),
vendedor varchar(100) REFERENCES GESTION_DE_DUENDES.dimensionCliente (ID_Cliente),
numero_compra decimal(18) REFERENCES GESTION_DE_DUENDES.Compra (Numero_De_Compra),
sucursal_compra nvarchar(255) REFERENCES GESTION_DE_DUENDES.Sucursal(Direccion),
modelo decimal(18) REFERENCES GESTION_DE_DUENDES.Modelo(Codigo_Modelo),
fabricante nvarchar(60),
tipo_auto decimal(18) REFERENCES GESTION_DE_DUENDES.TipoDeAuto(Codigo_Tipo_Auto),
tipo_caja_de_cambios decimal(18) REFERENCES GESTION_DE_DUENDES.Caja(Codigo_Caja),
cantidad_de_cambios decimal(18),
tipo_motor decimal(18),
tipo_de_transmision decimal(18) REFERENCES GESTION_DE_DUENDES.Transmision,
nivel_de_potencia nvarchar(20),
cantidad_comprada_por_mes_y_sucursal decimal(20),
precio_promedio_automoviles_comprados decimal(22,2),
promedio_tiempo_stock_modelo decimal(20),
PRIMARY KEY (anio_compra, mes_compra, vendedor, numero_compra, sucursal_compra,
 modelo, fabricante, tipo_auto, tipo_caja_de_cambios, cantidad_de_cambios, tipo_motor, tipo_de_transmision,
nivel_de_potencia)
);

CREATE TABLE GESTION_DE_DUENDES.hechos_automovil_venta(
anio_venta decimal(4),
mes_venta decimal(2),
comprador varchar(100) REFERENCES GESTION_DE_DUENDES.dimensionCliente (ID_Cliente),
numero_factura decimal(18) REFERENCES GESTION_DE_DUENDES.Factura(Numero_De_Factura),
sucursal_factura nvarchar(255) REFERENCES GESTION_DE_DUENDES.Sucursal(Direccion),
modelo decimal(18) REFERENCES GESTION_DE_DUENDES.Modelo(Codigo_Modelo),
fabricante nvarchar(60),
tipo_auto decimal(18) REFERENCES GESTION_DE_DUENDES.TipoDeAuto(Codigo_Tipo_Auto),
tipo_caja_de_cambios decimal(18) REFERENCES GESTION_DE_DUENDES.Caja(Codigo_Caja),
cantidad_de_cambios decimal(18),
tipo_motor decimal(18),
tipo_de_transmision decimal(18) REFERENCES GESTION_DE_DUENDES.Transmision,
nivel_de_potencia nvarchar(20),
cantidad_vendida_por_mes_y_sucursal decimal(20),
precio_promedio_automoviles_vendidos decimal(22,2),
ganancia_por_mes_y_sucursal decimal(22,2),
PRIMARY KEY (anio_venta, mes_venta, comprador, numero_factura, sucursal_factura,
 modelo, fabricante, tipo_auto, tipo_caja_de_cambios, cantidad_de_cambios, tipo_motor, tipo_de_transmision,
nivel_de_potencia)
);

CREATE TABLE GESTION_DE_DUENDES.hechos_autoparte_compra(
anio_compra decimal(4),
mes_compra decimal(2),
vendedor varchar(100) REFERENCES GESTION_DE_DUENDES.dimensionCliente (ID_Cliente),
numero_compra decimal(18) REFERENCES GESTION_DE_DUENDES.Compra(Numero_De_Compra),
sucursal_compra nvarchar(255) REFERENCES GESTION_DE_DUENDES.Sucursal(Direccion),
modelo decimal(18) REFERENCES GESTION_DE_DUENDES.Modelo(Codigo_Modelo),
fabricante nvarchar(60),
nivel_de_potencia nvarchar(20),
autoparte decimal(18) REFERENCES GESTION_DE_DUENDES.Autoparte(Codigo_Parte),
autoparte_rubro varchar(50),
precio_promedio_autopartes_compradas decimal(22,2),
maxima_cantidad_de_stock_por_sucursal decimal(20),
PRIMARY KEY(anio_compra, mes_compra, vendedor, numero_compra, sucursal_compra, modelo, fabricante, nivel_de_potencia, autoparte, autoparte_rubro)
);

CREATE TABLE GESTION_DE_DUENDES.hechos_autoparte_venta(
anio_venta decimal(4),
mes_venta decimal(2),
comprador varchar(100) REFERENCES GESTION_DE_DUENDES.dimensionCliente (ID_Cliente),
numero_factura decimal(18) REFERENCES GESTION_DE_DUENDES.Factura(Numero_De_Factura),
sucursal_venta nvarchar(255) REFERENCES GESTION_DE_DUENDES.Sucursal(Direccion),
modelo decimal(18) REFERENCES GESTION_DE_DUENDES.Modelo(Codigo_Modelo),
fabricante nvarchar(60),
nivel_de_potencia nvarchar(20),
autoparte decimal(18) REFERENCES GESTION_DE_DUENDES.Autoparte(Codigo_Parte),
autoparte_rubro varchar(50),
precio_promedio_autopartes_vendidas decimal(22,2),
ganancia_por_mes_y_sucursal decimal(22,2),
PRIMARY KEY (anio_venta,mes_venta,comprador,numero_factura,sucursal_venta,modelo,fabricante,nivel_de_potencia,autoparte,autoparte_rubro)
);
GO

CREATE PROCEDURE GESTION_DE_DUENDES.creacion_BI
AS

INSERT INTO GESTION_DE_DUENDES.dimensionCliente(ID_Cliente, rango_etario, sexo) 
SELECT CAST(cliente.ID_Cliente AS varchar(100)),
GESTION_DE_DUENDES.fx_rango_etario(CAST(FLOOR(DATEDIFF(DAY,cliente.Fecha_De_Nac, GETDATE())/ 365.25)  AS DECIMAL(18,0))),
'Desconocido'
 FROM GESTION_DE_DUENDES.Cliente cliente

INSERT INTO GESTION_DE_DUENDES.hechos_automovil_compra (anio_compra, mes_compra, vendedor, numero_compra, sucursal_compra,
modelo, fabricante, tipo_auto, tipo_caja_de_cambios, cantidad_de_cambios, tipo_motor,tipo_de_transmision,
nivel_de_potencia, cantidad_comprada_por_mes_y_sucursal, precio_promedio_automoviles_comprados, promedio_tiempo_stock_modelo)
SELECT YEAR(sub1.Fecha), MONTH(sub1.Fecha), sub1.ID_Cliente, sub1.Numero_De_Compra, sub1.ID_Sucursal, modelo.Codigo_Modelo, modelo.fabricante,
modelo.Codigo_Tipo_Auto, modelo.Codigo_Caja, GESTION_DE_DUENDES.fx_cantidad_cambios(modelo.Codigo_caja), modelo.Tipo_Motor, modelo.Codigo_Transmision,
GESTION_DE_DUENDES.fx_rango_potencia(modelo.Potencia), sub2.cantidad_comprada_por_mes_y_sucursal, sub3.precio_promedio_automoviles_comprados
as precio_promedio_automoviles_comprados, DATEDIFF(day, sub4.fecha_compra_promedio,  sub4.fecha_venta_promedio) as promedio_tiempo_stock_modelo
FROM GESTION_DE_DUENDES.Compra sub1
 JOIN GESTION_DE_DUENDES.dimensionCliente cli ON (cli.ID_Cliente = sub1.ID_Cliente)
 JOIN GESTION_DE_DUENDES.Automovil auto ON (auto.Numero_De_Compra = sub1.Numero_De_Compra)
 JOIN GESTION_DE_DUENDES.Modelo modelo ON (auto.Codigo_Modelo = modelo.Codigo_Modelo)
 JOIN (SELECT COUNT(c.Precio)  as cantidad_comprada_por_mes_y_sucursal, MONTH(c.Fecha)as mes, 
		YEAR(c.Fecha) as anio, c.ID_Sucursal as direccion
		FROM GESTION_DE_DUENDES.Compra c JOIN GESTION_DE_DUENDES.Automovil a ON (a.Numero_De_Compra = c.Numero_De_Compra)
		GROUP BY  MONTH(c.Fecha), YEAR(c.Fecha), c.ID_Sucursal
		) 
sub2 ON (sub2.direccion = sub1.ID_Sucursal AND sub2.mes = MONTH(sub1.Fecha) AND sub2.anio = YEAR(sub1.Fecha))
JOIN (SELECT SUM(compra.Precio)/COUNT(*) as precio_promedio_automoviles_comprados, a.Codigo_Modelo as modelo
		FROM GESTION_DE_DUENDES.Automovil a JOIN GESTION_DE_DUENDES.Compra compra ON (a.Numero_De_Compra = compra.Numero_De_Compra)
		GROUP BY a.Codigo_Modelo
) 
sub3 ON (sub3.modelo = modelo.Codigo_Modelo)
JOIN (SELECT a.Codigo_Modelo as modelo,  CAST(AVG(CAST(CAST(compra.Fecha AS datetime) AS INT)) AS DATETIME) as fecha_compra_promedio, 
		COALESCE(CAST(AVG(CAST(CAST(factura.Fecha AS datetime)AS INT)) AS DATETIME),GETDATE()) as fecha_venta_promedio
		FROM GESTION_DE_DUENDES.Automovil a JOIN GESTION_DE_DUENDES.Compra compra ON (a.Numero_De_Compra = compra.Numero_De_Compra)
		LEFT JOIN GESTION_DE_DUENDES.FacturaPorAutomovil fact ON (fact.Patente = a.Patente) LEFT JOIN GESTION_DE_DUENDES.Factura factura
		ON (factura.Numero_De_Factura = fact.Numero_De_Factura) WHERE Tipo_De_Factura = 'Automovil'
		GROUP BY a.Codigo_Modelo
		)
		sub4 ON (sub4.modelo = modelo.Codigo_Modelo)
WHERE sub1.Tipo_De_Compra = 'Automovil'

INSERT INTO GESTION_DE_DUENDES.hechos_automovil_venta (anio_venta, mes_venta, comprador, numero_factura, sucursal_factura,
modelo, fabricante, tipo_auto, tipo_caja_de_cambios, cantidad_de_cambios, tipo_motor,tipo_de_transmision,
nivel_de_potencia, cantidad_vendida_por_mes_y_sucursal, precio_promedio_automoviles_vendidos, ganancia_por_mes_y_sucursal)
SELECT YEAR(factura.Fecha), MONTH(factura.Fecha), factura.ID_Cliente, factura.Numero_De_Factura, factura.ID_Sucursal, modelo.Codigo_Modelo, modelo.fabricante,
modelo.Codigo_Tipo_Auto, modelo.Codigo_Caja, GESTION_DE_DUENDES.fx_cantidad_cambios(modelo.Codigo_caja), modelo.Tipo_Motor, modelo.Codigo_Transmision,
GESTION_DE_DUENDES.fx_rango_potencia(modelo.Potencia), sub2.cantidad_vendida_por_mes_y_sucursal as cantidad_vendida_por_mes_y_sucursal, sub4.precio_promedio_automoviles_vendidos
as precio_promedio_automoviles_vendidos,
sub2.total_vendido_por_mes_y_sucursal - sub3.total_comprado_por_mes_y_sucursal as ganancia_por_mes_y_sucursal
FROM GESTION_DE_DUENDES.Factura factura
 JOIN GESTION_DE_DUENDES.FacturaPorAutomovil factAuto ON (factura.Numero_De_Factura = factAuto.Numero_De_Factura)
 JOIN GESTION_DE_DUENDES.dimensionCliente cli ON (cli.ID_Cliente = factura.ID_Cliente)
 JOIN GESTION_DE_DUENDES.Automovil auto ON (auto.Patente = factAuto.Patente)
 JOIN GESTION_DE_DUENDES.Modelo modelo ON (auto.Codigo_Modelo = modelo.Codigo_Modelo)
 JOIN (SELECT COUNT(f.Precio)  as cantidad_vendida_por_mes_y_sucursal, SUM(f.Precio) as total_vendido_por_mes_y_sucursal, MONTH(f.Fecha)as mes, 
		YEAR(f.Fecha) as anio, f.ID_Sucursal as direccion
		FROM GESTION_DE_DUENDES.Factura f WHERE f.Tipo_De_Factura = 'Automovil'
		GROUP BY  MONTH(f.Fecha), YEAR(f.Fecha), f.ID_Sucursal
		) 
sub2 ON (sub2.direccion = factura.ID_Sucursal AND sub2.mes = MONTH(factura.Fecha) AND sub2.anio = YEAR(factura.Fecha))
JOIN (SELECT SUM(c.Precio) AS total_comprado_por_mes_y_sucursal, MONTH(C.Fecha) as mes, YEAR(C.Fecha) as Anio, c.ID_Sucursal as direccion
		FROM GESTION_DE_DUENDES.Compra C JOIN GESTION_DE_DUENDES.Automovil a ON (a.Numero_De_Compra = C.Numero_De_Compra)
		GROUP BY MONTH(C.Fecha), YEAR(C.Fecha), c.ID_Sucursal
		) sub3 ON (sub3.direccion = factura.ID_Sucursal AND sub3.mes = MONTH(factura.Fecha) AND sub3.anio = YEAR(factura.Fecha))
JOIN (SELECT SUM(factura.Precio)/COUNT(*) as precio_promedio_automoviles_vendidos, a.Codigo_Modelo as modelo
		FROM GESTION_DE_DUENDES.Automovil a JOIN GESTION_DE_DUENDES.FacturaPorAutomovil fact ON (fact.Patente = a.Patente)
											JOIN GESTION_DE_DUENDES.Factura factura ON (fact.Numero_De_Factura = factura.Numero_De_Factura)
		GROUP BY a.Codigo_Modelo
) 
sub4 ON (sub4.modelo = modelo.Codigo_Modelo)

INSERT INTO GESTION_DE_DUENDES.hechos_autoparte_compra(anio_compra, mes_compra, vendedor, numero_compra, sucursal_compra,
modelo, fabricante, nivel_de_potencia, autoparte, autoparte_rubro, precio_promedio_autopartes_compradas, maxima_cantidad_de_stock_por_sucursal)
SELECT YEAR(sub1.Fecha), MONTH(sub1.Fecha), sub1.ID_Cliente, sub1.Numero_De_Compra, sub1.ID_Sucursal,
modelo.Codigo_Modelo, modelo.fabricante, GESTION_DE_DUENDES.fx_rango_potencia(modelo.Potencia), a.Codigo_Parte,
'Desconocido',sub2.precio_promedio_autopartes_compradas as precio_promedio_automoviles_comprados, sub3.maxima_cantidad_de_stock_por_sucursal as maxima_cantidad_de_stock_por_sucursal
FROM GESTION_DE_DUENDES.CompraPorAutoparte compra
 JOIN GESTION_DE_DUENDES.Compra sub1 ON (sub1.Numero_De_Compra = compra.Numero_De_Compra)
 JOIN GESTION_DE_DUENDES.dimensionCliente cli ON (cli.ID_Cliente = sub1.ID_Cliente)
 JOIN GESTION_DE_DUENDES.Autoparte a ON (a.Codigo_Parte = compra.Codigo_Parte)
 JOIN GESTION_DE_DUENDES.Modelo modelo ON (a.Codigo_Modelo = modelo.Codigo_Modelo)

JOIN (SELECT SUM(compra.Precio_Compra * compra.Cantidad)/COUNT(*) as precio_promedio_autopartes_compradas, compra.Codigo_Parte as autoparte
		FROM GESTION_DE_DUENDES.CompraPorAutoparte compra 
		GROUP BY compra.Codigo_Parte
) 
sub2 ON (sub2.autoparte = a.Codigo_Parte)

JOIN (SELECT COUNT(c.Numero_De_Compra)  as maxima_cantidad_de_stock_por_sucursal, YEAR(c.Fecha) as anio,
		c.ID_Sucursal as direccion
		FROM GESTION_DE_DUENDES.Compra c
		WHERE c.Tipo_De_Compra = 'Autoparte'
		GROUP BY  YEAR(c.Fecha), c.ID_Sucursal)
		sub3 ON (sub3.anio = YEAR(sub1.Fecha) AND sub3.direccion = sub1.ID_Sucursal)

INSERT INTO GESTION_DE_DUENDES.hechos_autoparte_venta(anio_venta, mes_venta, comprador, numero_factura, sucursal_venta,
modelo, fabricante, nivel_de_potencia, autoparte, autoparte_rubro, precio_promedio_autopartes_vendidas,
ganancia_por_mes_y_sucursal)
SELECT YEAR(sub1.Fecha), MONTH(sub1.Fecha), sub1.ID_Cliente, sub1.Numero_De_Factura, 
sub1.ID_Sucursal, modelo.Codigo_Modelo, modelo.fabricante, GESTION_DE_DUENDES.fx_rango_potencia(modelo.Potencia), a.Codigo_Parte,
'Desconocido',sub2.precio_promedio_autopartes_vendidas as precio_promedio_automoviles_vendidos,
sub3.total_vendido_por_mes_y_sucursal - sub4.total_comprado_por_mes_y_sucursal as ganancia_por_mes_y_sucursal
FROM GESTION_DE_DUENDES.FacturaPorAutoparte factura
 JOIN GESTION_DE_DUENDES.Factura sub1 ON (sub1.Numero_De_Factura = factura.Numero_De_Factura)
 JOIN GESTION_DE_DUENDES.dimensionCliente cli ON (cli.ID_Cliente = sub1.ID_Cliente)
 JOIN GESTION_DE_DUENDES.Autoparte a ON (a.Codigo_Parte = factura.Codigo_Parte)
 JOIN GESTION_DE_DUENDES.Modelo modelo ON (a.Codigo_Modelo = modelo.Codigo_Modelo)

JOIN (SELECT SUM(factura.Precio_Facturado * factura.Cantidad)/COUNT(*) as precio_promedio_autopartes_vendidas, factura.Codigo_Parte as autoparte
		FROM GESTION_DE_DUENDES.FacturaPorAutoparte factura 
		GROUP BY factura.Codigo_Parte
) 
sub2 ON (sub2.autoparte = a.Codigo_Parte)

JOIN (SELECT SUM(factura.Precio) as total_vendido_por_mes_y_sucursal, MONTH(factura.Fecha) as mes, YEAR(factura.Fecha) as anio,
		factura.ID_Sucursal as direccion
		FROM GESTION_DE_DUENDES.Factura factura
		WHERE factura.Tipo_De_Factura = 'Autoparte'
		GROUP BY MONTH(factura.Fecha), YEAR(factura.Fecha),factura.ID_Sucursal
) sub3 ON (sub3.direccion = sub1.ID_Sucursal AND sub3.mes = MONTH(sub1.Fecha) AND sub3.anio = YEAR(sub1.Fecha))

JOIN (SELECT SUM(compra.Precio) as total_comprado_por_mes_y_sucursal, MONTH(compra.Fecha) as mes, YEAR(compra.Fecha) as anio,
		compra.ID_Sucursal as direccion
		FROM GESTION_DE_DUENDES.Compra compra
		WHERE compra.Tipo_De_Compra = 'Autoparte'
		GROUP BY MONTH(compra.Fecha), YEAR(compra.Fecha), compra.ID_Sucursal
) sub4 ON (sub4.direccion = sub1.ID_Sucursal AND sub4.mes = MONTH(sub1.Fecha) AND sub4.anio = YEAR(sub1.Fecha))

GO

EXEC GESTION_DE_DUENDES.creacion_BI;
GO

CREATE VIEW GESTION_DE_DUENDES.cantidad_comprada_por_mes_y_sucursal
AS SELECT DISTINCT anio_compra, mes_compra, sucursal_compra, cantidad_comprada_por_mes_y_sucursal
FROM GESTION_DE_DUENDES.hechos_automovil_compra
;
GO

CREATE VIEW GESTION_DE_DUENDES.precio_promedio_automoviles_comprados
AS SELECT DISTINCT  modelo,precio_promedio_automoviles_comprados
FROM GESTION_DE_DUENDES.hechos_automovil_compra
;
GO

CREATE VIEW GESTION_DE_DUENDES.promedio_tiempo_stock_modelo
AS SELECT DISTINCT c.modelo, c.promedio_tiempo_stock_modelo  FROM GESTION_DE_DUENDES.hechos_automovil_compra c
;
GO

CREATE VIEW GESTION_DE_DUENDES.cantidad_vendida_por_mes_y_sucursal
AS SELECT DISTINCT anio_venta, mes_venta, sucursal_factura, cantidad_vendida_por_mes_y_sucursal
FROM GESTION_DE_DUENDES.hechos_automovil_venta
;
GO

CREATE VIEW GESTION_DE_DUENDES.precio_promedio_automoviles_vendidos
AS SELECT DISTINCT  modelo,precio_promedio_automoviles_vendidos
FROM GESTION_DE_DUENDES.hechos_automovil_venta
;
GO

CREATE VIEW GESTION_DE_DUENDES.ganancias_por_sucursal_por_mes_automoviles
AS SELECT DISTINCT v.anio_venta, v.mes_venta, v.sucursal_factura, v.ganancia_por_mes_y_sucursal
FROM GESTION_DE_DUENDES.hechos_automovil_venta v
;
GO

CREATE VIEW GESTION_DE_DUENDES.precio_promedio_autopartes_compradas
AS SELECT DISTINCT autoparte, precio_promedio_autopartes_compradas
FROM GESTION_DE_DUENDES.hechos_autoparte_compra
;
GO

CREATE VIEW GESTION_DE_DUENDES.maxima_cantidad_de_stock_por_sucursal
AS SELECT DISTINCT anio_compra, sucursal_compra, maxima_cantidad_de_stock_por_sucursal
FROM GESTION_DE_DUENDES.hechos_autoparte_compra
;
GO

CREATE VIEW GESTION_DE_DUENDES.precio_promedio_autopartes_vendidas
AS SELECT DISTINCT autoparte, precio_promedio_autopartes_vendidas
FROM GESTION_DE_DUENDES.hechos_autoparte_venta;
GO

CREATE VIEW GESTION_DE_DUENDES.ganancia_por_mes_y_sucursal_autopartes
AS SELECT DISTINCT anio_venta, mes_venta, sucursal_venta, ganancia_por_mes_y_sucursal
FROM GESTION_DE_DUENDES.hechos_autoparte_venta
;
GO