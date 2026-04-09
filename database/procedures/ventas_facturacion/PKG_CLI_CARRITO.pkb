CREATE OR REPLACE PACKAGE BODY PKG_CLI_CARRITO AS

    PROCEDURE assert_id(p_id IN NUMBER, p_msg IN VARCHAR2) IS
    BEGIN
        IF p_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, p_msg);
        END IF;
    END;

    PROCEDURE CARRITO_CREAR(
        p_correlativo   IN VARCHAR2,
        p_cliente       IN NUMBER,
        p_id            OUT NUMBER) IS
    BEGIN
        assert_id(p_cliente, 'Carrito: Cliente obligatorio.');
        INSERT INTO CLI_CARRITO (
            pre_correlativo,
            cli_cliente,
            pre_fecha_inicio,
            pre_total)
        VALUES (
            TRIM(p_correlativo),
            p_cliente,
            SYSDATE,
            0)
        RETURNING pre_carrito INTO p_id;
    END;

    PROCEDURE CARRITO_AGREGAR_DETALLE(
        p_carrito       IN NUMBER,
        p_hist_precio   IN NUMBER,
        p_cantidad      IN NUMBER,
        p_id            OUT NUMBER) IS
    BEGIN
        assert_id(p_carrito, 'Detalle: Carrito obligatorio.');
        assert_id(p_hist_precio, 'Detalle: Precio obligatorio.');
        INSERT INTO CLI_DETALLE_CARRITO (
            hip_historial_precio,
            pre_carrito,
            detpre_cantidad)
        VALUES (
            p_hist_precio,
            p_carrito,
            p_cantidad)
        RETURNING detcar_detalle_carrito INTO p_id;
    END;

    PROCEDURE CARRITO_ELIMINAR_DETALLE(
        p_id IN NUMBER) IS
    BEGIN
        assert_id(p_id, 'Detalle: ID obligatorio.');
        DELETE FROM CLI_DETALLE_CARRITO
        WHERE detcar_detalle_carrito = p_id;
    END;

    PROCEDURE CARRITO_LISTAR(
        p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR SELECT * FROM CLI_CARRITO
        ORDER BY pre_fecha_inicio DESC;
    END;

    PROCEDURE CARRITO_VACIAR(
        p_carrito IN NUMBER) IS
    BEGIN
        assert_id(p_carrito, 'Carrito: ID obligatorio.');
        DELETE FROM CLI_DETALLE_CARRITO
        WHERE pre_carrito = p_carrito;
    END;

    PROCEDURE CARRITO_BUSCAR(
        p_cliente IN NUMBER,
        p_data OUT SYS_REFCURSOR) IS
    BEGIN
        assert_id(p_cliente, 'Carrito: Cliente obligatorio.');
        OPEN p_data FOR SELECT * FROM CLI_CARRITO
        WHERE cli_cliente = p_cliente
        ORDER BY pre_fecha_inicio DESC;
    END;

END PKG_CLI_CARRITO;
/