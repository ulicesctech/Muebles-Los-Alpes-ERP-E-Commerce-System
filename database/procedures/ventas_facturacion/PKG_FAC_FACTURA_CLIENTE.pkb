CREATE OR REPLACE PACKAGE BODY PKG_FAC_FACTURA_CLIENTE AS

    PROCEDURE assert_id(p_id IN NUMBER, p_msg IN VARCHAR2) IS
    BEGIN
        IF p_id IS NULL THEN RAISE_APPLICATION_ERROR(-20002, p_msg); END IF;
    END;

    PROCEDURE FACTURA_CREAR(
        p_presupuesto    IN NUMBER,
        p_empleado       IN NUMBER,
        p_forma_pago     IN VARCHAR2,
        p_tipo_entrega   IN VARCHAR2,
        p_almacen        IN NUMBER,
        p_codigo_factura OUT VARCHAR2) IS
        v_codigo VARCHAR2(50);
    BEGIN
        assert_id(p_presupuesto, 'Factura: Presupuesto obligatorio.');
        assert_id(p_empleado,    'Factura: Empleado obligatorio.');
        v_codigo := 'FAC-' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || '-' || p_presupuesto;
        INSERT INTO FAC_FACTURA_CLIENTE(
            pre_carrito, em_empleado, facli_codigo_factura, facli_fecha,
            facli_forma_pago, facli_tipo_entrega, facli_almacen)
        VALUES(
            p_presupuesto, p_empleado, v_codigo, SYSDATE,
            NVL(TRIM(p_forma_pago), 'EFECTIVO'),
            NVL(TRIM(p_tipo_entrega), 'DOMICILIO'),
            p_almacen);
        p_codigo_factura := v_codigo;
    END;

    PROCEDURE FACTURA_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT f.pre_presupuesto,
                   f.facli_codigo_factura,
                   f.facli_fecha,
                   f.facli_forma_pago,
                   f.facli_tipo_entrega,
                   f.facli_almacen,
                   c.pre_correlativo,
                   e.em_primer_nombre || ' ' || e.em_primer_apellido AS nombre_empleado,
                   a.alm_nombre AS nombre_almacen
              FROM FAC_FACTURA_CLIENTE f
              JOIN CLI_CARRITO  c ON c.pre_carrito  = f.pre_carrito
              JOIN RH_EMPLEADO  e ON e.em_empleado  = f.em_empleado
              LEFT JOIN BOD_ALMACEN a ON a.alm_almacen = f.facli_almacen
             ORDER BY f.facli_fecha DESC;
    END;

    PROCEDURE FACTURA_BUSCAR(p_presupuesto IN NUMBER, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        assert_id(p_presupuesto, 'Factura: Presupuesto obligatorio.');
        OPEN p_data FOR SELECT * FROM FAC_FACTURA_CLIENTE WHERE pre_carrito = p_presupuesto;
    END;

    PROCEDURE FACTURA_LISTAR_POR_CLIENTE(p_cliente IN NUMBER, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        assert_id(p_cliente, 'Factura: Cliente obligatorio.');
        OPEN p_data FOR
            SELECT f.facli_codigo_factura,
                   f.facli_fecha,
                   f.facli_forma_pago,
                   f.facli_tipo_entrega,
                   f.pre_carrito,
                   c.pre_total,
                   c.cli_cliente,
                   a.alm_nombre AS nombre_almacen
              FROM FAC_FACTURA_CLIENTE f
              JOIN CLI_CARRITO  c ON c.pre_carrito  = f.pre_carrito
              LEFT JOIN BOD_ALMACEN a ON a.alm_almacen = f.facli_almacen
             WHERE c.cli_cliente = p_cliente
             ORDER BY f.facli_fecha DESC;
    END;

END PKG_FAC_FACTURA_CLIENTE;
/