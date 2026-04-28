-- Tabla: BOD_HISTORIAL_PRECIO_VENTA
CREATE TABLE BOD_HISTORIAL_PRECIO_VENTA (
    hv_historial_precio_venta NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pro_referencia            VARCHAR2(40)  NOT NULL,
    hv_porcetaje              NUMBER(5,2)   NOT NULL,
    hv_precio_final           NUMBER(12,2)  NOT NULL,
    hv_fecha_inicio           DATE          NOT NULL,
    hv_fecha_final            DATE,
    CONSTRAINT FK_HVENTA_PRODUCTO FOREIGN KEY (pro_referencia)
        REFERENCES BOD_PRODUCTO(pro_referencia)
);

-- Modificar CLI_DETALLE_CARRITO
ALTER TABLE CLI_DETALLE_CARRITO DROP COLUMN HIP_HISTORIAL_PRECIO;

ALTER TABLE CLI_DETALLE_CARRITO ADD (
    hv_historial_precio_venta NUMBER NOT NULL
);

ALTER TABLE CLI_DETALLE_CARRITO ADD CONSTRAINT FK_DETCAR_HVENTA
    FOREIGN KEY (hv_historial_precio_venta)
    REFERENCES BOD_HISTORIAL_PRECIO_VENTA(hv_historial_precio_venta);