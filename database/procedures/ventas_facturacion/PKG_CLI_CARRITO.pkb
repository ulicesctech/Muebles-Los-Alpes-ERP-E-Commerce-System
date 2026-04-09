CREATE OR REPLACE PACKAGE BODY PKG_CLI_CARRITO AS

    PROCEDURE assert_id(p_id IN NUMBER, p_msg IN VARCHAR2) IS
    BEGIN
        IF p_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, p_msg);
        END IF;
    END;

    PROCEDURE CARRITO_CREAR(p_cliente IN NUMBER, p_id OUT NUMBER) IS
    BEGIN
        assert_id(p_cliente, 'Carrito: Cliente obligatorio.');
        INSERT INTO CLI_CARRITO (cli_cliente, pre_fecha_inicio, pre_total)
        VALUES (p_cliente, SYSDATE, 0)
        RETURNING pre_carrito INTO p_id;
    END;

    PROCEDURE CARRITO_AGREGAR_DETALLE(p_carrito IN NUMBER, p_hist_precio IN NUMBER, p_cantidad IN NUMBER, p_id OUT NUMBER) IS
    BEGIN
        assert_id(p_carrito, 'Detalle: Carrito obligatorio.');
        assert_id(p_hist_precio, 'Detalle: Precio obligatorio.');
        INSERT INTO CLI_DETALLE_CARRITO (hip_historial_precio, pre_carrito, detpre_cantidad)
        VALUES (p_hist_precio, p_carrito, p_cantidad)
        RETURNING detcar_detalle_carrito INTO p_id;
    END;

    PROCEDURE CARRITO_ELIMINAR_DETALLE(p_id IN NUMBER) IS
    BEGIN
        assert_id(p_id, 'Detalle: ID obligatorio.');
        DELETE FROM CLI_DETALLE_CARRITO WHERE detcar_detalle_carrito = p_id;
    END;

    PROCEDURE CARRITO_ELIMINAR(p_id IN NUMBER) IS
    BEGIN
        assert_id(p_id, 'Carrito: ID obligatorio.');
        DELETE FROM CLI_CARRITO WHERE pre_carrito = p_id;
    END;

    PROCEDURE CARRITO_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR 
            SELECT c.PRE_CARRITO, c.PRE_CORRELATIVO, 
                   cli.CLI_PRIMER_NOMBRE || ' ' || cli.CLI_PRIMER_APELLIDO AS NOMBRE_CLIENTE,
                   c.PRE_FECHA_INICIO, c.PRE_TOTAL,
                   NVL(LISTAGG(bh.PRO_REFERENCIA || ' x' || cd.DETPRE_CANTIDAD, ', ') 
                   WITHIN GROUP (ORDER BY bh.PRO_REFERENCIA), 'Sin productos') AS PRODUCTOS
            FROM CLI_CARRITO c
            JOIN CLI_CLIENTE cli ON c.CLI_CLIENTE = cli.CLI_CLIENTE
            LEFT JOIN CLI_DETALLE_CARRITO cd ON c.PRE_CARRITO = cd.PRE_CARRITO
            LEFT JOIN BOD_HISTORIAL_PRECIO bh ON cd.HIP_HISTORIAL_PRECIO = bh.HIP_HISTORIAL_PRECIO
            GROUP BY c.PRE_CARRITO, c.PRE_CORRELATIVO, cli.CLI_PRIMER_NOMBRE, 
                     cli.CLI_PRIMER_APELLIDO, c.PRE_FECHA_INICIO, c.PRE_TOTAL
            ORDER BY c.PRE_CARRITO DESC;
    END;

    PROCEDURE CARRITO_VACIAR(p_carrito IN NUMBER) IS
    BEGIN
        assert_id(p_carrito, 'Carrito: ID obligatorio.');
        DELETE FROM CLI_DETALLE_CARRITO WHERE pre_carrito = p_carrito;
    END;

    PROCEDURE CARRITO_BUSCAR(p_cliente IN NUMBER, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        assert_id(p_cliente, 'Carrito: Cliente obligatorio.');
        OPEN p_data FOR SELECT * FROM CLI_CARRITO
        WHERE cli_cliente = p_cliente ORDER BY pre_fecha_inicio DESC;
    END;

    PROCEDURE CARRITO_LISTAR_DETALLE(p_carrito IN NUMBER, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        assert_id(p_carrito, 'Detalle: Carrito obligatorio.');
        OPEN p_data FOR
            SELECT cd.DETCAR_DETALLE_CARRITO, bh.PRO_REFERENCIA, cd.DETPRE_CANTIDAD
            FROM CLI_DETALLE_CARRITO cd
            JOIN BOD_HISTORIAL_PRECIO bh ON cd.HIP_HISTORIAL_PRECIO = bh.HIP_HISTORIAL_PRECIO
            WHERE cd.PRE_CARRITO = p_carrito;
    END;

    PROCEDURE CARRITO_PRODUCTOS_DISPONIBLES(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT DISTINCT bh.HIP_HISTORIAL_PRECIO, bh.PRO_REFERENCIA, 
                   p.PRO_NOMBRE, bh.HIP_PRECIO
            FROM BOD_HISTORIAL_PRECIO bh
            JOIN BOD_PRODUCTO p ON bh.PRO_REFERENCIA = p.PRO_REFERENCIA
            WHERE bh.HIP_FECHA_FINAL IS NULL
            ORDER BY p.PRO_NOMBRE;
    END;

    PROCEDURE CARRITO_RESUMEN(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT c.PRE_CARRITO,
                   c.PRE_CORRELATIVO,
                   cli.CLI_PRIMER_NOMBRE || ' ' || cli.CLI_PRIMER_APELLIDO AS NOMBRE_CLIENTE,
                   c.PRE_FECHA_INICIO,
                   NVL(LISTAGG(p.PRO_NOMBRE || ' x' || cd.DETPRE_CANTIDAD, ', ')
                       WITHIN GROUP (ORDER BY p.PRO_NOMBRE), 'Sin productos') AS PRODUCTOS,
                   NVL(SUM(bh.HIP_PRECIO * cd.DETPRE_CANTIDAD), 0) AS TOTAL
            FROM CLI_CARRITO c
            JOIN CLI_CLIENTE cli ON c.CLI_CLIENTE = cli.CLI_CLIENTE
            LEFT JOIN CLI_DETALLE_CARRITO cd ON c.PRE_CARRITO = cd.PRE_CARRITO
            LEFT JOIN BOD_HISTORIAL_PRECIO bh ON cd.HIP_HISTORIAL_PRECIO = bh.HIP_HISTORIAL_PRECIO
            LEFT JOIN BOD_PRODUCTO p ON bh.PRO_REFERENCIA = p.PRO_REFERENCIA
            GROUP BY c.PRE_CARRITO, c.PRE_CORRELATIVO, 
                     cli.CLI_PRIMER_NOMBRE, cli.CLI_PRIMER_APELLIDO, c.PRE_FECHA_INICIO
            ORDER BY c.PRE_CARRITO DESC;
    END;

END PKG_CLI_CARRITO;
/