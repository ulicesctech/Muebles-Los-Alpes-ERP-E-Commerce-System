-- ==========================================================
-- MODULO: VENTAS Y FACTURACION
-- Tablas: Carrito, Factura Cliente, Marketing
-- REQUIERE: auth_usuarios.sql y catalogo_inventario.sql
--           ejecutados previamente
-- ==========================================================

-- ----------------------------------------------------------
-- TABLAS
-- ----------------------------------------------------------

CREATE TABLE CLI_CARRITO (
    pre_carrito NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pre_correlativo VARCHAR2(50) NOT NULL UNIQUE,
    cli_cliente NUMBER NOT NULL,
    pre_fecha_inicio DATE DEFAULT SYSDATE NOT NULL,
    pre_total NUMBER(10,2) DEFAULT 0 NOT NULL,
    CONSTRAINT ck_carrito_total CHECK (pre_total >= 0)
);

CREATE TABLE FAC_FACTURA_CLIENTE (
    pre_presupuesto NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pre_carrito NUMBER NOT NULL,
    em_empleado NUMBER NOT NULL,
    facli_codigo_factura VARCHAR2(50) NOT NULL,
    facli_fecha DATE DEFAULT SYSDATE NOT NULL,
    FACLI_FORMA_PAGO   VARCHAR2(20) DEFAULT 'EFECTIVO'  NOT NULL,
    FACLI_TIPO_ENTREGA VARCHAR2(20) DEFAULT 'DOMICILIO' NOT NULL,
    FACLI_ALMACEN      NUMBER,
    CONSTRAINT uq_facli_codigo UNIQUE (facli_codigo_factura),
    CONSTRAINT chk_forma_pago CHECK (FACLI_FORMA_PAGO IN ('EFECTIVO','TARJETA','TRANSFERENCIA')),
    CONSTRAINT chk_tipo_entrega CHECK (FACLI_TIPO_ENTREGA IN ('DOMICILIO','SUCURSAL'))
);

CREATE TABLE CLI_DETALLE_CARRITO (
    detcar_detalle_carrito NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hv_historial_precio_venta NUMBER NOT NULL,
    pre_carrito NUMBER NOT NULL,
    detpre_cantidad NUMBER NOT NULL,
    CONSTRAINT ck_detcar_cantidad CHECK (detpre_cantidad > 0)
);

CREATE TABLE MKT_MEDIO_FUENTE (
    med_fuente NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    med_nombre VARCHAR2(50) NOT NULL
);

CREATE TABLE MKT_CAMPANA (
    cam_campana NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    med_fuente NUMBER NOT NULL,
    cam_nombre VARCHAR2(100) NOT NULL,
    cam_fecha_inicio DATE NOT NULL,
    cam_fecha_fin DATE NOT NULL,
    cam_estado NUMBER(1) NOT NULL,
    cam_comentario VARCHAR2(500)
);

CREATE TABLE MKT_COSTO_ADS (
    ads_ads NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cam_campana NUMBER NOT NULL,
    ads_fecha DATE NOT NULL,
    ads_monto_gastado NUMBER(12,2) DEFAULT 0,
    ads_clicks NUMBER(10) DEFAULT 0,
    ads_impresiones NUMBER(12) DEFAULT 0
);

CREATE TABLE MKT_PLATAFORMA (
    pla_plataforma NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pla_nombre VARCHAR2(50) NOT NULL
);

CREATE TABLE MKT_SESION (
    ses_sesion NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cli_cliente NUMBER NOT NULL,
    pla_plataforma NUMBER NOT NULL,
    ses_fecha DATE DEFAULT SYSDATE
);

CREATE TABLE MKT_CANAL_REGISTRO (
    can_canal_reg NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    can_nombre VARCHAR2(30) NOT NULL
);

CREATE TABLE MKT_ATRIBUCION (
    atr_atribucion NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cli_cliente NUMBER NOT NULL UNIQUE,
    cam_campana NUMBER NOT NULL,
    can_canal_reg NUMBER NOT NULL,
    atr_fecha_instal DATE DEFAULT SYSDATE
);

-- ----------------------------------------------------------
-- LLAVES FORANEAS
-- ----------------------------------------------------------

ALTER TABLE CLI_CARRITO ADD CONSTRAINT fk_carrito_cliente
    FOREIGN KEY (cli_cliente) REFERENCES CLI_CLIENTE(cli_cliente);

ALTER TABLE FAC_FACTURA_CLIENTE ADD CONSTRAINT fk_faccli_carrito
    FOREIGN KEY (pre_carrito) REFERENCES CLI_CARRITO(pre_carrito);

ALTER TABLE FAC_FACTURA_CLIENTE ADD CONSTRAINT fk_faccli_empleado
    FOREIGN KEY (em_empleado) REFERENCES RH_EMPLEADO(em_empleado);

ALTER TABLE FAC_FACTURA_CLIENTE ADD CONSTRAINT fk_factura_almacen
    FOREIGN KEY (FACLI_ALMACEN) REFERENCES BOD_ALMACEN(ALM_ALMACEN);

ALTER TABLE CLI_DETALLE_CARRITO ADD CONSTRAINT fk_detcar_carrito
    FOREIGN KEY (pre_carrito) REFERENCES CLI_CARRITO(pre_carrito);

ALTER TABLE CLI_DETALLE_CARRITO ADD CONSTRAINT fk_detcar_hventa
    FOREIGN KEY (hv_historial_precio_venta) REFERENCES BOD_HISTORIAL_PRECIO_VENTA(hv_historial_precio_venta);

ALTER TABLE MKT_CAMPANA ADD CONSTRAINT fk_campana_medio
    FOREIGN KEY (med_fuente) REFERENCES MKT_MEDIO_FUENTE(med_fuente);

ALTER TABLE MKT_COSTO_ADS ADD CONSTRAINT fk_costo_campana
    FOREIGN KEY (cam_campana) REFERENCES MKT_CAMPANA(cam_campana);

ALTER TABLE MKT_SESION ADD CONSTRAINT fk_sesion_cliente
    FOREIGN KEY (cli_cliente) REFERENCES CLI_CLIENTE(cli_cliente);

ALTER TABLE MKT_SESION ADD CONSTRAINT fk_sesion_plataforma
    FOREIGN KEY (pla_plataforma) REFERENCES MKT_PLATAFORMA(pla_plataforma);

ALTER TABLE MKT_ATRIBUCION ADD CONSTRAINT fk_atribucion_cliente
    FOREIGN KEY (cli_cliente) REFERENCES CLI_CLIENTE(cli_cliente);

ALTER TABLE MKT_ATRIBUCION ADD CONSTRAINT fk_atribucion_campana
    FOREIGN KEY (cam_campana) REFERENCES MKT_CAMPANA(cam_campana);

ALTER TABLE MKT_ATRIBUCION ADD CONSTRAINT fk_atribucion_canal
    FOREIGN KEY (can_canal_reg) REFERENCES MKT_CANAL_REGISTRO(can_canal_reg);

-- ----------------------------------------------------------
-- VERIFICACION FINAL
-- ----------------------------------------------------------

SELECT table_name, column_name
FROM user_tab_columns
WHERE table_name IN (
    'PROMO_CAMPANA','PROMO_PROMOCION','FAC_FACTURA_CLIENTE',
    'CLI_DETALLE_CARRITO','BOD_HISTORIAL_PRECIO_VENTA',
    'BOD_DETALLE_PEDIDO','BOD_HISTORIAL_PRECIO',
    'BOD_ORDEN_DETALLE_PEDIDO','FAC_RECLAMO_PROVEEDOR'
)
ORDER BY table_name, column_id;