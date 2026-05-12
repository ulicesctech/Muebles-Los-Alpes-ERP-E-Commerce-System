-- ==========================================================
-- MODULO: CATALOGO E INVENTARIO
-- Tablas: Bodega, Productos, Stock, Promociones
-- REQUIERE: auth_usuarios.sql ejecutado previamente
-- ==========================================================

-- ----------------------------------------------------------
-- TABLAS
-- ----------------------------------------------------------

CREATE TABLE BOD_CATEGORIA (
    cat_categoria NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cat_descripcion VARCHAR2(255) NOT NULL
);

CREATE TABLE BOD_MATERIAL (
    mat_material NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    mat_descripcion VARCHAR2(255) NOT NULL UNIQUE
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
    mat_material NUMBER NOT NULL,
    pro_alto_cm NUMBER(6,2) NOT NULL,
    pro_ancho_cm NUMBER(6,2) NOT NULL,
    pro_profundidad_cm NUMBER(6,2) NOT NULL,
    pro_color VARCHAR2(50),
    pro_peso NUMBER(12) NOT NULL,
    pro_foto BLOB,
    CONSTRAINT ck_pro_dim CHECK (
        pro_alto_cm > 0 AND
        pro_ancho_cm > 0 AND
        pro_profundidad_cm > 0
    ),
    CONSTRAINT ck_pro_peso CHECK (pro_peso > 0)
);

CREATE TABLE PROMO_CAMPANA (
    camp_campana      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    camp_nombre       VARCHAR2(100) NOT NULL,
    camp_descripcion  VARCHAR2(255),
    camp_estado       VARCHAR2(10) DEFAULT 'PENDIENTE' NOT NULL,
    camp_fecha_inicio DATE NOT NULL,
    camp_fecha_final  DATE NOT NULL,
    CONSTRAINT ck_camp_estado CHECK (camp_estado IN ('ACTIVA','INACTIVA','PENDIENTE')),
    CONSTRAINT ck_camp_fechas CHECK (camp_fecha_inicio <= camp_fecha_final)
);

CREATE TABLE PROMO_PROMOCION (
    prom_promocion NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pro_referencia VARCHAR2(40) NOT NULL,
    prom_porcentaje NUMBER(5,2) NOT NULL,
    camp_campana NUMBER,
    CONSTRAINT ck_prom_porcentaje CHECK (prom_porcentaje > 0 AND prom_porcentaje <= 100)
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
    alm_almacen NUMBER NOT NULL,
    CONSTRAINT uq_nic_alm UNIQUE (nic_nicho, alm_almacen)
);

CREATE TABLE BOD_HISTORIAL_PRECIO (
    hip_historial_precio NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pro_referencia VARCHAR2(40) NOT NULL,
    nic_nicho NUMBER NULL,
    hip_precio NUMBER(10,2) NULL,
    hip_fecha_inicio DATE NOT NULL,
    hip_fecha_final DATE,
    CONSTRAINT ck_hip_precio CHECK (hip_precio > 0),
    CONSTRAINT ck_hip_fechas CHECK (hip_fecha_final IS NULL OR hip_fecha_final >= hip_fecha_inicio)
);

CREATE TABLE BOD_STOCK (
    sto_stock NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hip_historial_precio NUMBER NOT NULL,
    sto_minimo NUMBER NOT NULL,
    sto_maximo NUMBER NOT NULL,
    sto_disponible NUMBER DEFAULT 0 NOT NULL,
    CONSTRAINT ck_stock_nonneg CHECK (
        sto_minimo >= 0 AND
        sto_maximo >= 0 AND
        sto_disponible >= 0
    ),
    CONSTRAINT ck_stock_minmax CHECK (sto_minimo <= sto_maximo)
);

CREATE TABLE BOD_HISTORIAL_PRECIO_VENTA (
    hv_historial_precio_venta NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pro_referencia            VARCHAR2(40)  NOT NULL,
    hv_porcetaje              NUMBER(5,2)   NOT NULL,
    hv_precio_final           NUMBER(12,2)  NOT NULL,
    hv_fecha_inicio           DATE          NOT NULL,
    hv_fecha_final            DATE
);

-- ----------------------------------------------------------
-- LLAVES FORANEAS
-- ----------------------------------------------------------

ALTER TABLE BOD_TIPO ADD CONSTRAINT fk_tip_categoria
    FOREIGN KEY (cat_categoria) REFERENCES BOD_CATEGORIA(cat_categoria);

ALTER TABLE BOD_PRODUCTO ADD CONSTRAINT fk_pro_tipo
    FOREIGN KEY (tip_tipo) REFERENCES BOD_TIPO(tip_tipo);

ALTER TABLE BOD_PRODUCTO ADD CONSTRAINT fk_pro_material
    FOREIGN KEY (mat_material) REFERENCES BOD_MATERIAL(mat_material);

ALTER TABLE BOD_HISTORIAL_PRECIO_VENTA ADD CONSTRAINT fk_hventa_producto
    FOREIGN KEY (pro_referencia) REFERENCES BOD_PRODUCTO(pro_referencia);

ALTER TABLE PROMO_PROMOCION ADD CONSTRAINT fk_prom_producto
    FOREIGN KEY (pro_referencia) REFERENCES BOD_PRODUCTO(pro_referencia);

ALTER TABLE PROMO_PROMOCION ADD CONSTRAINT fk_prom_campana
    FOREIGN KEY (camp_campana) REFERENCES PROMO_CAMPANA(camp_campana);

ALTER TABLE BOD_NIC_ALM ADD CONSTRAINT fk_nicalm_nicho
    FOREIGN KEY (nic_nicho) REFERENCES BOD_NICHO(nic_nicho);

ALTER TABLE BOD_NIC_ALM ADD CONSTRAINT fk_nicalm_almacen
    FOREIGN KEY (alm_almacen) REFERENCES BOD_ALMACEN(alm_almacen);

ALTER TABLE BOD_HISTORIAL_PRECIO ADD CONSTRAINT fk_hip_producto
    FOREIGN KEY (pro_referencia) REFERENCES BOD_PRODUCTO(pro_referencia);

ALTER TABLE BOD_HISTORIAL_PRECIO ADD CONSTRAINT fk_hip_nicho
    FOREIGN KEY (nic_nicho) REFERENCES BOD_NICHO(nic_nicho);

ALTER TABLE BOD_STOCK ADD CONSTRAINT fk_sto_historial
    FOREIGN KEY (hip_historial_precio) REFERENCES BOD_HISTORIAL_PRECIO(hip_historial_precio);

-- ----------------------------------------------------------
-- MODIFICACIONES
-- ----------------------------------------------------------

ALTER TABLE BOD_PRODUCTO ADD PRO_PRECIO NUMBER(10,2);