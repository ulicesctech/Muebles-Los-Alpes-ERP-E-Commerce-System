CREATE OR REPLACE PACKAGE BODY PKG_FAC_FACTURA_CLIENTE AS

    PROCEDURE assert_id(p_id IN NUMBER, p_msg IN VARCHAR2) IS
    BEGIN
        IF p_id IS NULL THEN RAISE_APPLICATION_ERROR(-20002, p_msg); END IF;
    END;

    PROCEDURE FACTURA_CREAR(
        p_presupuesto    IN NUMBER,
        p_empleado       IN NUMBER,
        p_codigo_factura OUT VARCHAR2) IS
        v_codigo VARCHAR2(50);
    BEGIN
        assert_id(p_presupuesto, 'Factura: Presupuesto obligatorio.');
        assert_id(p_empleado,    'Factura: Empleado obligatorio.');
        v_codigo := 'FAC-' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || '-' || p_presupuesto;
        INSERT INTO FAC_FACTURA_CLIENTE(pre_carrito, em_empleado, facli_codigo_factura, facli_fecha)
        VALUES(p_presupuesto, p_empleado, v_codigo, SYSDATE);
        p_codigo_factura := v_codigo;
    END;

    PROCEDURE FACTURA_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT f.pre_presupuesto,
                   f.facli_codigo_factura,
                   f.facli_fecha,
                   c.pre_correlativo         AS pre_presupuesto,
                   e.em_primer_nombre || ' ' || e.em_primer_apellido AS em_empleado
              FROM FAC_FACTURA_CLIENTE f
              JOIN CLI_CARRITO  c ON c.pre_carrito = f.pre_carrito
              JOIN RH_EMPLEADO  e ON e.em_empleado = f.em_empleado
             ORDER BY f.facli_fecha DESC;
    END;

    PROCEDURE FACTURA_BUSCAR(p_presupuesto IN NUMBER, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        assert_id(p_presupuesto, 'Factura: Presupuesto obligatorio.');
        OPEN p_data FOR SELECT * FROM FAC_FACTURA_CLIENTE WHERE pre_carrito = p_presupuesto;
    END;

END PKG_FAC_FACTURA_CLIENTE;
/