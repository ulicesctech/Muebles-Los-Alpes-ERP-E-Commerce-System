-- ==========================================================
-- MODULO: AUTH USUARIOS
-- Tablas: Admin, RH, Cliente, Login
-- ==========================================================

-- ----------------------------------------------------------
-- TABLAS
-- ----------------------------------------------------------

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

-- ----------------------------------------------------------
-- LLAVES FORANEAS
-- ----------------------------------------------------------

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

-- ----------------------------------------------------------
-- DATOS INICIALES
-- ----------------------------------------------------------

INSERT INTO ADMIN_PERMISOS (
    PER_ADMIN, PER_RH, PER_FAC, PER_CLI, PER_BOD, PER_PROMO
)
SELECT 1, 1, 1, 1, 1, 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM ADMIN_PERMISOS);
COMMIT;

INSERT INTO ADMIN_GRUPO_USUARIO (GRUPUS_DESCRIPCION, PER_PERMISOS)
VALUES ('SuperUsuario', 1);
COMMIT;

INSERT INTO RH_EMPLEADO (
    EM_DPI, EM_PRIMER_NOMBRE, EM_SEGUNDO_NOMBRE,
    EM_PRIMER_APELLIDO, EM_SEGUNDO_APELLIDO,
    EM_DIRECCION, EM_AVENIDA, EM_CODIGO_POSTAL,
    EM_PRIMER_TELEFONO, ROLUS_ROL_USUARIO
) VALUES (
    '5190202600000', 'Admin', 'Admin', 'Admin', 'Admin',
    '1 calle', '1 avenida', '02211', '20232026',
    (SELECT GRUPUS_GRUPO_USUARIO FROM ADMIN_GRUPO_USUARIO
      WHERE GRUPUS_DESCRIPCION = 'SuperUsuario')
);
COMMIT;

INSERT INTO ADMIN_LOGIN_EMPLEADO (LOGEM_USUARIO, LOGEM_PASSWORD, EM_EMPLEADO)
VALUES (
    '5190202600000', 'Admin.2026',
    (SELECT EM_EMPLEADO FROM RH_EMPLEADO WHERE EM_DPI = '5190202600000')
);
COMMIT;