-- ==========================================================
-- FASE 1: CREACION DE TABLAS Y LLAVES PRIMARIAS (PK) ==========================================================
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
    per_permisos NUMBER NOT NULL
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
    CONSTRAINT uq_facli_codigo UNIQUE (facli_codigo_factura)
);

CREATE TABLE CLI_DETALLE_CARRITO (
    detcar_detalle_carrito NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hip_historial_precio NUMBER NOT NULL,
    pre_carrito NUMBER NOT NULL,
    detpre_cantidad NUMBER NOT NULL,
    CONSTRAINT ck_detcar_cantidad CHECK (detpre_cantidad > 0)
);

-- Modulo de Bodega, Productos y Proveedores
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
    --Peso en gramos: mejor entero
    pro_peso NUMBER(12) NOT NULL,
    -- Foto como URL/ruta (mejor 500)
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

CREATE TABLE PROMO_PROMOCION (
    prom_promocion NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pro_referencia VARCHAR2(40) NOT NULL,
    prom_porcentaje NUMBER(5,2) NOT NULL,
    prom_fecha_inicio DATE NOT NULL,
    prom_fecha_final DATE NOT NULL,
    CONSTRAINT ck_prom_porcentaje CHECK (prom_porcentaje > 0 AND prom_porcentaje <= 100),
    CONSTRAINT ck_prom_fechas CHECK (prom_fecha_inicio <= prom_fecha_final)
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
    nic_nicho NUMBER NOT NULL,
    hip_precio NUMBER(10,2) NOT NULL,
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
    sto_reservado NUMBER NOT NULL,
    sto_disponible NUMBER DEFAULT 0 NOT NULL,
    CONSTRAINT ck_stock_nonneg CHECK (
        sto_minimo >= 0 AND
        sto_maximo >= 0 AND
        sto_reservado >= 0 AND
        sto_disponible >= 0	
    ),
    CONSTRAINT ck_stock_minmax CHECK (sto_minimo <= sto_maximo),
    CONSTRAINT ck_stock_reservado CHECK (sto_reservado <= sto_disponible)
);

-- Modulo de Pedidos, ordenes de Compra y Facturacion a Proveedores
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
    hip_historial_precio NUMBER NOT NULL,
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
-- FASE 2: CREACION DE LLAVES FORANEAS (FK) Y RELACIONES
-- ==========================================================

ALTER TABLE ADMIN_GRUPO_USUARIO
ADD CONSTRAINT fk_grupus_permisos FOREIGN KEY (per_permisos)
REFERENCES ADMIN_PERMISOS(per_permisos);

ALTER TABLE RH_EMPLEADO
ADD CONSTRAINT fk_em_rolus FOREIGN KEY (rolus_rol_usuario)
REFERENCES ADMIN_GRUPO_USUARIO(grupus_grupo_usuario);

ALTER TABLE RH_ASCENSO
ADD CONSTRAINT fk_asc_puesto FOREIGN KEY (pue_puestos)
REFERENCES RH_PUESTO(pue_puestos);

ALTER TABLE RH_ASCENSO
ADD CONSTRAINT fk_asc_empleado FOREIGN KEY (em_empleado)
REFERENCES RH_EMPLEADO(em_empleado);

ALTER TABLE ADMIN_LOGIN_EMPLEADO
ADD CONSTRAINT fk_logem_empleado FOREIGN KEY (em_empleado)
REFERENCES RH_EMPLEADO(em_empleado);

ALTER TABLE ADMIN_LOGIN_CLIENTE
ADD CONSTRAINT fk_logcli_cliente FOREIGN KEY (cli_cliente)
REFERENCES CLI_CLIENTE(cli_cliente);

ALTER TABLE CLI_CARRITO
ADD CONSTRAINT fk_carrito_cliente FOREIGN KEY (cli_cliente)
REFERENCES CLI_CLIENTE(cli_cliente);

ALTER TABLE FAC_FACTURA_CLIENTE
ADD CONSTRAINT fk_faccli_carrito FOREIGN KEY (pre_carrito)
REFERENCES CLI_CARRITO(pre_carrito);

ALTER TABLE FAC_FACTURA_CLIENTE
ADD CONSTRAINT fk_faccli_empleado FOREIGN KEY (em_empleado)
REFERENCES RH_EMPLEADO(em_empleado);

ALTER TABLE BOD_TIPO
ADD CONSTRAINT fk_tip_categoria FOREIGN KEY (cat_categoria)
REFERENCES BOD_CATEGORIA(cat_categoria);

-- Producto -> Tipo/Material (en fase 2 para mantener orden)
ALTER TABLE BOD_PRODUCTO
ADD CONSTRAINT fk_pro_tipo FOREIGN KEY (tip_tipo)
REFERENCES BOD_TIPO(tip_tipo);

ALTER TABLE BOD_PRODUCTO
ADD CONSTRAINT fk_pro_material FOREIGN KEY (mat_material)
REFERENCES BOD_MATERIAL(mat_material);

ALTER TABLE PROMO_PROMOCION
ADD CONSTRAINT fk_prom_producto FOREIGN KEY (pro_referencia)
REFERENCES BOD_PRODUCTO(pro_referencia);

ALTER TABLE BOD_NIC_ALM
ADD CONSTRAINT fk_nicalm_nicho FOREIGN KEY (nic_nicho)
REFERENCES BOD_NICHO(nic_nicho);

ALTER TABLE BOD_NIC_ALM
ADD CONSTRAINT fk_nicalm_almacen FOREIGN KEY (alm_almacen)
REFERENCES BOD_ALMACEN(alm_almacen);

ALTER TABLE BOD_HISTORIAL_PRECIO
ADD CONSTRAINT fk_hip_producto FOREIGN KEY (pro_referencia)
REFERENCES BOD_PRODUCTO(pro_referencia);

ALTER TABLE BOD_HISTORIAL_PRECIO
ADD CONSTRAINT fk_hip_nicho FOREIGN KEY (nic_nicho)
REFERENCES BOD_NICHO(nic_nicho);

ALTER TABLE BOD_STOCK
ADD CONSTRAINT fk_sto_historial FOREIGN KEY (hip_historial_precio)
REFERENCES BOD_HISTORIAL_PRECIO(hip_historial_precio);


ALTER TABLE CLI_DETALLE_CARRITO
ADD CONSTRAINT fk_detcar_historial FOREIGN KEY (hip_historial_precio)
REFERENCES BOD_HISTORIAL_PRECIO(hip_historial_precio);

ALTER TABLE CLI_DETALLE_CARRITO
ADD CONSTRAINT fk_detcar_carrito FOREIGN KEY (pre_carrito)
REFERENCES CLI_CARRITO(pre_carrito);

ALTER TABLE BOD_DETALLE_PEDIDO
ADD CONSTRAINT fk_detpe_pedido FOREIGN KEY (ped_pedido)
REFERENCES BOD_PEDIDO(ped_pedido);

ALTER TABLE BOD_DETALLE_PEDIDO
ADD CONSTRAINT fk_detpe_historial FOREIGN KEY (hip_historial_precio)
REFERENCES BOD_HISTORIAL_PRECIO(hip_historial_precio);

ALTER TABLE BOD_ORDEN_COMPRA
ADD CONSTRAINT fk_orc_proveedor FOREIGN KEY (prov_proveedor)
REFERENCES BOD_PROVEEDOR(prov_proveedor);

ALTER TABLE BOD_ORDEN_DETALLE_PEDIDO
ADD CONSTRAINT fk_odp_orden FOREIGN KEY (orc_orden_compra)
REFERENCES BOD_ORDEN_COMPRA(orc_orden_compra);

ALTER TABLE BOD_ORDEN_DETALLE_PEDIDO
ADD CONSTRAINT fk_odp_pedido FOREIGN KEY (ped_pedido)
REFERENCES BOD_PEDIDO(ped_pedido);

ALTER TABLE FAC_FACTURA_PROVEEDOR
ADD CONSTRAINT fk_facpro_orden FOREIGN KEY (orc_orden_compra)
REFERENCES BOD_ORDEN_COMPRA(orc_orden_compra);

ALTER TABLE FAC_RECLAMO_PROVEEDOR
ADD CONSTRAINT fk_rep_orden FOREIGN KEY (orc_orden_compra)
REFERENCES BOD_ORDEN_COMPRA(orc_orden_compra);

