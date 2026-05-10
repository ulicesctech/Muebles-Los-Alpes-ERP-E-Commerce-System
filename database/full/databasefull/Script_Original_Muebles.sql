-- ==========================================================
-- FASE 1: CREACION DE TABLAS Y LLAVES PRIMARIAS (PK) 
-- ==========================================================

-- Modulo de Administracion y Permisos
CREATE TABLE ADMIN_PERMISOS (
    per_permisos NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    per_Admin NUMBER(1) DEFAULT 0,
    per_RH NUMBER(1) DEFAULT 0,
    per_Fac NUMBER(1) DEFAULT 0,
    per_cli NUMBER(1) DEFAULT 0,
    per_Bod NUMBER(1) DEFAULT 0,
    per_promo NUMBER(1) DEFAULT 0
);

CREATE TABLE ADMIN_GRUPO_USUARIO (
    grupus_grupo_usuario NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    grupus_descripcion VARCHAR2(255) NOT NULL UNIQUE,
    per_permisos NUMBER
);

-- Modulo de Recursos Humanos
CREATE TABLE RH_PUESTO (
    pue_puestos NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pue_nombre VARCHAR2(255) NOT NULL,
    pue_salario NUMBER(10,2) NOT NULL,
    pue_descripcion VARCHAR2(255) NOT NULL
);

CREATE TABLE RH_EMPLEADO (
    em_empleado NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    em_DPI VARCHAR2(20) NOT NULL UNIQUE,
    em_primer_nombre VARCHAR2(100) NOT NULL,
    em_segundo_nombre VARCHAR2(100) NOT NULL,
    em_primer_apellido VARCHAR2(100) NOT NULL,
    em_segundo_apellido VARCHAR2(100) NOT NULL,
    em_direccion VARCHAR2(255) NOT NULL,
    em_avenida VARCHAR2(100) NOT NULL,
    em_codigo_postal VARCHAR2(20) NOT NULL,
    em_primer_telefono VARCHAR2(20) NOT NULL,
    em_segundo_telefono VARCHAR2(20),
    rolus_rol_usuario NUMBER NOT NULL
);

CREATE TABLE RH_ASCENSO (
    asc_ascenso NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pue_puestos NUMBER NOT NULL,
    em_empleado NUMBER NOT NULL,
    asc_fecha_inicio DATE NOT NULL,
    asc_fecha_final DATE
);

CREATE TABLE ADMIN_LOGIN_EMPLEADO (
    em_empleado NUMBER PRIMARY KEY,
    logem_password VARCHAR2(255) NOT NULL,
    logem_usuario VARCHAR2(100) NOT NULL UNIQUE
);

-- Módulo de Clientes y Carrito
CREATE TABLE CLI_CLIENTE (
    cli_cliente NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cli_tipodocumento VARCHAR2(50) NOT NULL,
    cli_numdocumento VARCHAR2(50) NOT NULL UNIQUE,
    cli_nit VARCHAR2(50),
    cli_primer_nombre VARCHAR2(100) NOT NULL,
    cli_segundo_nombre VARCHAR2(100),           
    cli_primer_apellido VARCHAR2(100) NOT NULL,
    cli_segundo_apellido VARCHAR2(100),         
    cli_pais VARCHAR2(100) NOT NULL,
    cli_departamento VARCHAR2(100) NOT NULL,
    cli_municipio VARCHAR2(100) NOT NULL,
    cli_zona VARCHAR2(50) NOT NULL,
    cli_direccion VARCHAR2(255) NOT NULL,
    cli_codigo_postal VARCHAR2(20) NOT NULL,
    cli_primer_telefono VARCHAR2(20) NOT NULL,
    cli_segundo_telefono VARCHAR2(20),
    cli_email VARCHAR2(100) NOT NULL,
    cli_profesion VARCHAR2(100),
    cli_tipocliente VARCHAR2(50) NOT NULL,
    CONSTRAINT uq_cli_email UNIQUE (cli_email),
    CONSTRAINT ck_cli_tipocliente CHECK (UPPER(cli_tipocliente) IN ('NATURAL','JURIDICA'))
);

CREATE TABLE ADMIN_LOGIN_CLIENTE (
    cli_cliente NUMBER PRIMARY KEY,
    logcli_password VARCHAR2(255) NOT NULL,
    logcli_usuario VARCHAR2(100) NOT NULL UNIQUE
);

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

-- Modulo de Bodega, Productos y Proveedores
CREATE TABLE BOD_HISTORIAL_PRECIO_VENTA (
    hv_historial_precio_venta NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pro_referencia            VARCHAR2(40)  NOT NULL,
    hv_porcetaje              NUMBER(5,2)   NOT NULL,
    hv_precio_final           NUMBER(12,2)  NOT NULL,
    hv_fecha_inicio           DATE          NOT NULL,
    hv_fecha_final            DATE
);

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

CREATE TABLE BOD_PROVEEDOR (
    prov_proveedor NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    prov_NIT VARCHAR2(50) NOT NULL UNIQUE,
    prov_nombre VARCHAR2(255) NOT NULL,
    prov_avenida VARCHAR2(100) NOT NULL,
    prov_zona VARCHAR2(50) NOT NULL,
    prov_direccion VARCHAR2(255) NOT NULL,
    prov_telefono VARCHAR2(20) NOT NULL
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

-- Modulo de Pedidos, ordenes de Compra y Facturacion
CREATE TABLE BOD_PEDIDO (
    ped_pedido NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ped_codigo VARCHAR2(50) NOT NULL,
    ped_fecha DATE DEFAULT SYSDATE NOT NULL,
    ped_total NUMBER(10,2) DEFAULT 0 NOT NULL,
    ped_forma_pago VARCHAR2(30) DEFAULT 'SIMULADO' NOT NULL,
    CONSTRAINT uq_ped_codigo UNIQUE (ped_codigo),
    CONSTRAINT ck_ped_total CHECK (ped_total >= 0)
);

CREATE TABLE BOD_DETALLE_PEDIDO (
    detpe_detalle_pedido NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ped_pedido NUMBER NOT NULL,
    hip_historial_precio NUMBER NULL,
    detpe_cantidad_solicitada NUMBER NOT NULL,
    detpe_cantidad_recibida NUMBER DEFAULT 0 NOT NULL,
    CONSTRAINT ck_detpe_cant CHECK (
        detpe_cantidad_solicitada > 0 AND
        detpe_cantidad_recibida >= 0
    )
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
    odp_cantidad NUMBER NOT NULL,
    odp_producto VARCHAR2(255) NOT NULL
);

CREATE TABLE FAC_FACTURA_PROVEEDOR (
    orc_orden_compra VARCHAR2(255) PRIMARY KEY,
    facpro_Codigo_factura VARCHAR2(50) NOT NULL,
    facpro_fecha DATE NOT NULL
);

CREATE TABLE FAC_RECLAMO_PROVEEDOR (
    rep_reclamo_proveedor NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    orc_orden_compra VARCHAR2(255) NOT NULL,
    rep_comentarios VARCHAR2(500) NULL,
    rep_estado VARCHAR2(50) NOT NULL,
    rep_fecha_inicio DATE NOT NULL,
    rep_fecha_final DATE,
    rep_descripcion VARCHAR2(255) NOT NULL
);

-- Tablas de Marketing - Reportería
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


-- ==========================================================
-- FASE 2: CREACION DE LLAVES FORANEAS (FK) Y RELACIONES
-- ==========================================================

ALTER TABLE ADMIN_GRUPO_USUARIO ADD CONSTRAINT fk_grupus_permisos 
    FOREIGN KEY (per_permisos) REFERENCES ADMIN_PERMISOS(per_permisos);

ALTER TABLE RH_EMPLEADO ADD CONSTRAINT fk_em_rolus 
    FOREIGN KEY (rolus_rol_usuario) REFERENCES ADMIN_GRUPO_USUARIO(grupus_grupo_usuario);

ALTER TABLE RH_ASCENSO ADD CONSTRAINT fk_asc_puesto 
    FOREIGN KEY (pue_puestos) REFERENCES RH_PUESTO(pue_puestos);

ALTER TABLE RH_ASCENSO ADD CONSTRAINT fk_asc_empleado 
    FOREIGN KEY (em_empleado) REFERENCES RH_EMPLEADO(em_empleado);

ALTER TABLE ADMIN_LOGIN_EMPLEADO ADD CONSTRAINT fk_logem_empleado 
    FOREIGN KEY (em_empleado) REFERENCES RH_EMPLEADO(em_empleado);

ALTER TABLE ADMIN_LOGIN_CLIENTE ADD CONSTRAINT fk_logcli_cliente 
    FOREIGN KEY (cli_cliente) REFERENCES CLI_CLIENTE(cli_cliente);

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

ALTER TABLE BOD_DETALLE_PEDIDO ADD CONSTRAINT fk_detpe_pedido 
    FOREIGN KEY (ped_pedido) REFERENCES BOD_PEDIDO(ped_pedido);

ALTER TABLE BOD_DETALLE_PEDIDO ADD CONSTRAINT fk_detpe_historial 
    FOREIGN KEY (hip_historial_precio) REFERENCES BOD_HISTORIAL_PRECIO(hip_historial_precio);

ALTER TABLE BOD_ORDEN_COMPRA ADD CONSTRAINT fk_orc_proveedor 
    FOREIGN KEY (prov_proveedor) REFERENCES BOD_PROVEEDOR(prov_proveedor);

ALTER TABLE BOD_ORDEN_DETALLE_PEDIDO ADD CONSTRAINT fk_odp_orden 
    FOREIGN KEY (orc_orden_compra) REFERENCES BOD_ORDEN_COMPRA(orc_orden_compra);

ALTER TABLE BOD_ORDEN_DETALLE_PEDIDO ADD CONSTRAINT fk_odp_pedido 
    FOREIGN KEY (ped_pedido) REFERENCES BOD_PEDIDO(ped_pedido);

ALTER TABLE FAC_FACTURA_PROVEEDOR ADD CONSTRAINT fk_facpro_orden 
    FOREIGN KEY (orc_orden_compra) REFERENCES BOD_ORDEN_COMPRA(orc_orden_compra);

ALTER TABLE FAC_RECLAMO_PROVEEDOR ADD CONSTRAINT fk_rep_orden 
    FOREIGN KEY (orc_orden_compra) REFERENCES BOD_ORDEN_COMPRA(orc_orden_compra);

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


-- ==========================================================
-- FASE 3: MODIFICACIONES FINALES (ALTERACIONES)
-- ==========================================================

ALTER TABLE BOD_PRODUCTO ADD PRO_PRECIO NUMBER(10,2);


-- ==========================================================
-- FASE 4: DATOS INICIALES ADMINISTRADOR
-- ==========================================================

INSERT INTO ADMIN_PERMISOS (
    PER_ADMIN, PER_RH, PER_FAC, PER_CLI, PER_BOD, PER_PROMO
) 
SELECT 1, 1, 1, 1, 1, 1
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM ADMIN_PERMISOS
);
COMMIT;

INSERT INTO ADMIN_GRUPO_USUARIO (
    GRUPUS_DESCRIPCION, PER_PERMISOS
) VALUES (
    'SuperUsuario', 1
);
COMMIT;

INSERT INTO RH_EMPLEADO (
    EM_DPI, EM_PRIMER_NOMBRE, EM_SEGUNDO_NOMBRE,
    EM_PRIMER_APELLIDO, EM_SEGUNDO_APELLIDO,
    EM_DIRECCION, EM_AVENIDA, EM_CODIGO_POSTAL,
    EM_PRIMER_TELEFONO, ROLUS_ROL_USUARIO
) VALUES (
    '5190202600000', 'Admin', 'Admin', 'Admin', 'Admin',
    '1 calle', '1 avenida', '02211', '20232026',
    (SELECT GRUPUS_GRUPO_USUARIO 
       FROM ADMIN_GRUPO_USUARIO 
      WHERE GRUPUS_DESCRIPCION = 'SuperUsuario')
);
COMMIT;

INSERT INTO ADMIN_LOGIN_EMPLEADO (
    LOGEM_USUARIO, LOGEM_PASSWORD, EM_EMPLEADO
) VALUES (
    '5190202600000', 'Admin.2026',
    (SELECT EM_EMPLEADO 
       FROM RH_EMPLEADO 
      WHERE EM_DPI = '5190202600000')
);
COMMIT;


-- ==========================================================
-- VERIFICACION GENERAL
-- ==========================================================

SELECT table_name, column_name 
FROM user_tab_columns 
WHERE table_name IN (
    'PROMO_CAMPANA',
    'PROMO_PROMOCION',
    'FAC_FACTURA_CLIENTE',
    'CLI_DETALLE_CARRITO',
    'BOD_HISTORIAL_PRECIO_VENTA',
    'BOD_DETALLE_PEDIDO',
    'BOD_HISTORIAL_PRECIO',
    'BOD_ORDEN_DETALLE_PEDIDO',
    'FAC_RECLAMO_PROVEEDOR'
)
ORDER BY table_name, column_id;


