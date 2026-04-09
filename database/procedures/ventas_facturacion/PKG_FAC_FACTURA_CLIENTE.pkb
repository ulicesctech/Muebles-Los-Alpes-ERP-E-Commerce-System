CREATE OR REPLACE PACKAGE BODY PKG_FAC_FACTURA_CLIENTE AS

    PROCEDURE assert_id(p_id IN NUMBER, p_msg IN VARCHAR2) IS
    BEGIN
        IF p_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, p_msg);
        END IF;
    END;

    PROCEDURE FACTURA_CREAR(
        p_presupuesto       IN NUMBER,
        p_empleado          IN NUMBER,
        p_codigo_factura    OUT VARCHAR2) IS
    BEGIN
        assert_id(p_empleado, 'Factura: Empleado obligatorio.');
        INSERT INTO FAC_FACTURA_CLIENTE (
            em_empleado,
            facli_fecha)
        VALUES (
            p_empleado,
            SYSDATE)
        RETURNING facli_codigo_factura INTO p_codigo_factura;
    END;

    PROCEDURE FACTURA_LISTAR(
        p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR 
            SELECT f.FACLI_CODIGO_FACTURA,
                   c.PRE_CORRELATIVO,
                   e.EM_PRIMER_NOMBRE || ' ' || e.EM_PRIMER_APELLIDO AS NOMBRE_EMPLEADO,
                   f.FACLI_FECHA
            FROM FAC_FACTURA_CLIENTE f
            LEFT JOIN CLI_CARRITO c ON f.PRE_PRESUPUESTO = c.PRE_CARRITO
            LEFT JOIN RH_EMPLEADO e ON f.EM_EMPLEADO = e.EM_EMPLEADO
            ORDER BY f.FACLI_FECHA DESC;
    END;

    PROCEDURE FACTURA_BUSCAR(
        p_presupuesto IN NUMBER,
        p_data OUT SYS_REFCURSOR) IS
    BEGIN
        assert_id(p_presupuesto, 'Factura: Presupuesto obligatorio.');
        OPEN p_data FOR SELECT * FROM FAC_FACTURA_CLIENTE
        WHERE pre_presupuesto = p_presupuesto;
    END;

END PKG_FAC_FACTURA_CLIENTE;
/