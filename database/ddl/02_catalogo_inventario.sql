-- ==========================================================
-- FASE 1: CREACIÓN DE TABLAS Y LLAVES PRIMARIAS (PK)
-- ==========================================================

-- Módulo de Bodega, Productos y Proveedores
CREATE TABLE BOD_CATEGORIA (
    cat_categoria NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cat_descripcion VARCHAR2(255) NOT NULL
);

CREATE TABLE BOD_MATERIAL (
    mat_material NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    mat_descripcion VARCHAR2(255) NOT NULL
);

CREATE TABLE BOD_TIPO (
    tip_tipo NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tip_descripcion VARCHAR2(255) NOT NULL,
    cat_categoria NUMBER NOT NULL
);

CREATE TABLE BOD_PRODUCTO (
    pro_referencia VARCHAR2(40) PRIMARY KEY,
    pro_nombre VARCHAR2(255) NOT NULL,
    pro_descripcion VARCHAR2(255),
    tip_tipo NUMBER NOT NULL,
    mat_material NUMBER,
    pro_dimensiones VARCHAR2(120) NOT NULL,
    pro_color VARCHAR2(50),
    pro_peso NUMBER(10,2) NOT NULL,
    pro_foto VARCHAR2(255)
);

CREATE TABLE PROMO_PROMOCION (
    prom_promocion NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pro_referencia VARCHAR2(40)  NOT NULL,
    prom_porcentaje NUMBER(5,2) NOT NULL,
    prom_fecha_inicio DATE NOT NULL,
    prom_fecha_final DATE NOT NULL
);

CREATE TABLE BOD_NICHO (
    nic_nicho NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nic_numero VARCHAR2(50) NOT NULL,
    nic_zona VARCHAR2(50) NOT NULL,
    nic_caracteristica VARCHAR2(255) NOT NULL
);

CREATE TABLE BOD_ALMACEN (
    alm_almacen NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    alm_nombre VARCHAR2(255) NOT NULL,
    alm_pais VARCHAR2(100) NOT NULL,
    alm_ubicacion VARCHAR2(255) NOT NULL
);

CREATE TABLE BOD_NIC_ALM (
    nic_alm_nichoalmacen NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nic_nicho NUMBER NOT NULL,
    alm_almacen NUMBER NOT NULL
);

CREATE TABLE BOD_HISTORIAL_PRECIO (
    hip_historial_precio NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pro_referencia VARCHAR2(40) NOT NULL,
    nic_nicho NUMBER NOT NULL,
    hip_precio NUMBER(10,2) NOT NULL,
    hip_fecha_inicio DATE NOT NULL,
    hip_fecha_final DATE 
);

CREATE TABLE BOD_STOCK (
    sto_stock NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hip_historial_precio NUMBER NOT NULL,
    sto_minimo NUMBER NOT NULL,
    sto_maximo NUMBER NOT NULL,
    sto_reservado NUMBER NOT NULL
);






-- ==========================================================
-- FASE 2: CREACIÓN DE LLAVES FORÁNEAS (FK) Y RELACIONES
-- ==========================================================
ALTER TABLE BOD_TIPO 
ADD CONSTRAINT fk_tip_categoria FOREIGN KEY (cat_categoria) REFERENCES BOD_CATEGORIA(cat_categoria);

ALTER TABLE BOD_PRODUCTO 
ADD CONSTRAINT fk_pro_tipo FOREIGN KEY (tip_tipo) REFERENCES BOD_TIPO(tip_tipo);
ALTER TABLE BOD_PRODUCTO 
ADD CONSTRAINT fk_pro_material FOREIGN KEY (mat_material) REFERENCES BOD_MATERIAL(mat_material);

ALTER TABLE PROMO_PROMOCION 
ADD CONSTRAINT fk_prom_producto FOREIGN KEY (pro_referencia) REFERENCES BOD_PRODUCTO(pro_referencia);

ALTER TABLE BOD_NIC_ALM 
ADD CONSTRAINT fk_nicalm_nicho FOREIGN KEY (nic_nicho) REFERENCES BOD_NICHO(nic_nicho);
ALTER TABLE BOD_NIC_ALM 
ADD CONSTRAINT fk_nicalm_almacen FOREIGN KEY (alm_almacen) REFERENCES BOD_ALMACEN(alm_almacen);


ALTER TABLE BOD_HISTORIAL_PRECIO 
ADD CONSTRAINT fk_hip_producto FOREIGN KEY (pro_referencia) REFERENCES BOD_PRODUCTO(pro_referencia);
ALTER TABLE BOD_HISTORIAL_PRECIO 
ADD CONSTRAINT fk_hip_nicho FOREIGN KEY (nic_nicho) REFERENCES BOD_NICHO(nic_nicho);

ALTER TABLE BOD_STOCK 
ADD CONSTRAINT fk_sto_historial FOREIGN KEY (hip_historial_precio) REFERENCES BOD_HISTORIAL_PRECIO(hip_historial_precio);

