-- ==========================================================
-- FASE 1: CREACIÓN DE TABLAS Y LLAVES PRIMARIAS (PK)
-- ==========================================================


CREATE TABLE CLI_CARRITO (
    pre_carrito NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pre_correlativo VARCHAR2(50)  NOT NULL,
    cli_cliente NUMBER  NOT NULL,
    pre_fecha_inicio DATE  NOT NULL,
    pre_total NUMBER(10,2)  NOT NULL
);

CREATE TABLE FAC_FACTURA_CLIENTE (
    pre_presupuesto NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    em_empleado NUMBER  NOT NULL,
    facli_codigo_factura VARCHAR2(50)  NOT NULL,
    facli_fecha DATE  NOT NULL
);
CREATE TABLE CLI_DETALLE_CARRITO (
    detcar_detalle_carrito NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hip_historial_precio NUMBER NOT NULL,
    pre_carrito NUMBER NOT NULL,
    detpre_cantidad NUMBER NOT NULL
);






-- ==========================================================
-- FASE 2: CREACIÓN DE LLAVES FORÁNEAS (FK) Y RELACIONES
-- ==========================================================
ALTER TABLE CLI_CARRITO 
ADD CONSTRAINT fk_carrito_cliente FOREIGN KEY (cli_cliente) REFERENCES CLI_CLIENTE(cli_cliente);

ALTER TABLE FAC_FACTURA_CLIENTE 
ADD CONSTRAINT fk_faccli_presupuesto FOREIGN KEY (pre_presupuesto) REFERENCES CLI_CARRITO(pre_carrito);
ALTER TABLE FAC_FACTURA_CLIENTE 
ADD CONSTRAINT fk_faccli_empleado FOREIGN KEY (em_empleado) REFERENCES RH_EMPLEADO(em_empleado);


ALTER TABLE CLI_DETALLE_CARRITO 
ADD CONSTRAINT fk_detcar_historial FOREIGN KEY (hip_historial_precio) REFERENCES BOD_HISTORIAL_PRECIO(hip_historial_precio);
ALTER TABLE CLI_DETALLE_CARRITO 
ADD CONSTRAINT fk_detcar_carrito FOREIGN KEY (pre_carrito) REFERENCES CLI_CARRITO(pre_carrito);



























































