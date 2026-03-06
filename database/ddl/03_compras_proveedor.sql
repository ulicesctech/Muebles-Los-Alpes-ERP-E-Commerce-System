-- ==========================================================
-- FASE 1: CREACIÓN DE TABLAS Y LLAVES PRIMARIAS (PK)
-- ==========================================================


CREATE TABLE BOD_PROVEEDOR (
    prov_proveedor NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    prov_NIT VARCHAR2(50) NOT NULL UNIQUE,
    prov_nombre VARCHAR2(255) NOT NULL,
    prov_avenida VARCHAR2(100) NOT NULL,
    prov_zona VARCHAR2(50) NOT NULL,
    prov_direccion VARCHAR2(255) NOT NULL,
    prov_telefono VARCHAR2(20) NOT NULL
);
-- Módulo de Pedidos, Órdenes de Compra y Facturación a Proveedores
CREATE TABLE BOD_PEDIDO (
    ped_pedido NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ped_codigo VARCHAR2(50) NOT NULL,
    ped_fecha DATE NOT NULL
);
CREATE TABLE BOD_DETALLE_PEDIDO (
    detpe_detalle_pedido NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ped_pedido NUMBER NOT NULL,
    hip_historial_precio NUMBER NOT NULL,
    detpe_cantidad_solicitada NUMBER NOT NULL,
    detpe_cantidad_recibida NUMBER
);

CREATE TABLE BOD_ORDEN_COMPRA (
    orc_orden_compra VARCHAR2(255) PRIMARY KEY,
    orc_codigo VARCHAR2(50) NOT NULL,
    prov_proveedor NUMBER NOT NULL,
    orc_fecha DATE NOT NULL,
    orc_total_precio NUMBER(10,2) NOT NULL
);





CREATE TABLE BOD_ORDEN_DETALLE_PEDIDO (
    odp_orden_detalle_pedido NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    orc_orden_compra VARCHAR2(255) NOT NULL,
    ped_pedido NUMBER NOT NULL,
    odp_material VARCHAR2(255) NOT NULL,
    odp_precio NUMBER(10,2) NOT NULL,
    odp_cantidad NUMBER NOT NULL
);

CREATE TABLE FAC_FACTURA_PROVEEDOR (
    orc_orden_compra VARCHAR2(255) PRIMARY KEY,
    facpro_Codigo_factura VARCHAR2(50) NOT NULL,
    facpro_fecha DATE NOT NULL
);


CREATE TABLE FAC_RECLAMO_PROVEEDOR (
    rep_reclamo_proveedor NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    orc_orden_compra VARCHAR2(255) NOT NULL,
    rep_comentarios VARCHAR2(500) NOT NULL,
    rep_estado VARCHAR2(50) NOT NULL,
    rep_fecha_inicio DATE NOT NULL,
    rep_fecha_final DATE
);


















-- ==========================================================
-- FASE 2: CREACIÓN DE LLAVES FORÁNEAS (FK) Y RELACIONES
-- ==========================================================
ALTER TABLE BOD_DETALLE_PEDIDO 
ADD CONSTRAINT fk_detpe_pedido FOREIGN KEY (ped_pedido) REFERENCES BOD_PEDIDO(ped_pedido);
ALTER TABLE BOD_DETALLE_PEDIDO 
ADD CONSTRAINT fk_detpe_historial FOREIGN KEY (hip_historial_precio) REFERENCES BOD_HISTORIAL_PRECIO(hip_historial_precio);

ALTER TABLE BOD_ORDEN_COMPRA 
ADD CONSTRAINT fk_orc_proveedor FOREIGN KEY (prov_proveedor) REFERENCES BOD_PROVEEDOR(prov_proveedor);

ALTER TABLE BOD_ORDEN_DETALLE_PEDIDO 
ADD CONSTRAINT fk_odp_orden FOREIGN KEY (orc_orden_compra) REFERENCES BOD_ORDEN_COMPRA(orc_orden_compra);
ALTER TABLE BOD_ORDEN_DETALLE_PEDIDO 
ADD CONSTRAINT fk_odp_pedido FOREIGN KEY (ped_pedido) REFERENCES BOD_PEDIDO(ped_pedido);

ALTER TABLE FAC_FACTURA_PROVEEDOR 
ADD CONSTRAINT fk_facpro_orden FOREIGN KEY (orc_orden_compra) REFERENCES BOD_ORDEN_COMPRA(orc_orden_compra);

ALTER TABLE FAC_RECLAMO_PROVEEDOR 
ADD CONSTRAINT fk_rep_orden FOREIGN KEY (orc_orden_compra) REFERENCES BOD_ORDEN_COMPRA(orc_orden_compra);


