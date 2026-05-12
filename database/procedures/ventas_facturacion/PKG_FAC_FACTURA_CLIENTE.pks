CREATE OR REPLACE PACKAGE PKG_FAC_FACTURA_CLIENTE AS
    PROCEDURE FACTURA_CREAR(
        p_presupuesto    IN NUMBER,
        p_empleado       IN NUMBER,
        p_forma_pago     IN VARCHAR2,
        p_tipo_entrega   IN VARCHAR2,
        p_almacen        IN NUMBER,
        p_codigo_factura OUT VARCHAR2
    );
    PROCEDURE FACTURA_LISTAR(p_data OUT SYS_REFCURSOR);
    PROCEDURE FACTURA_BUSCAR(p_presupuesto IN NUMBER, p_data OUT SYS_REFCURSOR);
    PROCEDURE FACTURA_LISTAR_POR_CLIENTE(p_cliente IN NUMBER, p_data OUT SYS_REFCURSOR);
END PKG_FAC_FACTURA_CLIENTE;
/