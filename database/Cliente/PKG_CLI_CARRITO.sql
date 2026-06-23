CREATE OR REPLACE PACKAGE PKG_CLI_CARRITO AS
    PROCEDURE CARRITO_CREAR(p_cliente IN NUMBER, p_id OUT NUMBER);
    PROCEDURE CARRITO_AGREGAR_DETALLE(p_carrito IN NUMBER, p_hv_precio IN NUMBER, p_cantidad IN NUMBER, p_id OUT NUMBER);
    PROCEDURE CARRITO_ELIMINAR_DETALLE(p_id IN NUMBER);
    PROCEDURE CARRITO_ELIMINAR(p_id IN NUMBER);
    PROCEDURE CARRITO_LISTAR(p_data OUT SYS_REFCURSOR);
    PROCEDURE CARRITO_VACIAR(p_carrito IN NUMBER);
    PROCEDURE CARRITO_BUSCAR(p_cliente IN NUMBER, p_data OUT SYS_REFCURSOR);
    PROCEDURE CARRITO_LISTAR_DETALLE(p_carrito IN NUMBER, p_data OUT SYS_REFCURSOR);
    PROCEDURE CARRITO_PRODUCTOS_DISPONIBLES(p_data OUT SYS_REFCURSOR);
    PROCEDURE CARRITO_RESUMEN(p_carrito IN NUMBER, p_data OUT SYS_REFCURSOR);
    PROCEDURE CARRITO_RESUMEN_TODOS(p_data OUT SYS_REFCURSOR);
    PROCEDURE CARRITO_FACTURAR(p_carrito IN NUMBER);
    PROCEDURE ALMACENES_CON_STOCK(p_hv_ids IN VARCHAR2, p_data OUT SYS_REFCURSOR);
END PKG_CLI_CARRITO;
/

CREATE OR REPLACE PACKAGE BODY PKG_CLI_CARRITO AS

    PROCEDURE assert_id(p_id IN NUMBER, p_msg IN VARCHAR2) IS
    BEGIN
        IF p_id IS NULL THEN RAISE_APPLICATION_ERROR(-20002, p_msg); END IF;
    END;

    PROCEDURE CARRITO_CREAR(p_cliente IN NUMBER, p_id OUT NUMBER) IS
        v_corr VARCHAR2(50);
    BEGIN
        assert_id(p_cliente, 'Carrito: Cliente obligatorio.');
        v_corr := 'CAR-' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || '-' || p_cliente;
        INSERT INTO CLI_CARRITO(pre_correlativo, cli_cliente, pre_fecha_inicio, pre_total)
        VALUES(v_corr, p_cliente, SYSDATE, 0)
        RETURNING pre_carrito INTO p_id;
    END;

    PROCEDURE CARRITO_AGREGAR_DETALLE(p_carrito IN NUMBER, p_hv_precio IN NUMBER, p_cantidad IN NUMBER, p_id OUT NUMBER) IS
    BEGIN
        assert_id(p_carrito,   'Detalle: Carrito obligatorio.');
        assert_id(p_hv_precio, 'Detalle: Precio obligatorio.');
        INSERT INTO CLI_DETALLE_CARRITO(hv_historial_precio_venta, pre_carrito, detpre_cantidad)
        VALUES(p_hv_precio, p_carrito, p_cantidad)
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
        DELETE FROM CLI_DETALLE_CARRITO WHERE pre_carrito = p_id;
        DELETE FROM CLI_CARRITO WHERE pre_carrito = p_id;
    END;

    PROCEDURE CARRITO_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT c.pre_carrito,
                   c.pre_correlativo,
                   c.pre_fecha_inicio,
                   c.pre_total,
                   cl.cli_primer_nombre || ' ' || cl.cli_primer_apellido AS nombre_cliente,
                   NVL(
                       (SELECT LISTAGG(p.pro_nombre || ' x' || d.detpre_cantidad, ', ')
                               WITHIN GROUP (ORDER BY p.pro_nombre)
                          FROM CLI_DETALLE_CARRITO d
                          JOIN BOD_HISTORIAL_PRECIO_VENTA hv ON hv.hv_historial_precio_venta = d.hv_historial_precio_venta
                          JOIN BOD_PRODUCTO p ON p.pro_referencia = hv.pro_referencia
                         WHERE d.pre_carrito = c.pre_carrito),
                       'Sin productos'
                   ) AS productos
              FROM CLI_CARRITO c
              JOIN CLI_CLIENTE cl ON cl.cli_cliente = c.cli_cliente
             ORDER BY c.pre_fecha_inicio DESC;
    END;

    PROCEDURE CARRITO_VACIAR(p_carrito IN NUMBER) IS
    BEGIN
        assert_id(p_carrito, 'Carrito: ID obligatorio.');
        DELETE FROM CLI_DETALLE_CARRITO WHERE pre_carrito = p_carrito;
    END;

    PROCEDURE CARRITO_BUSCAR(p_cliente IN NUMBER, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        assert_id(p_cliente, 'Carrito: Cliente obligatorio.');
        OPEN p_data FOR
          SELECT * FROM CLI_CARRITO WHERE cli_cliente = p_cliente
          ORDER BY pre_fecha_inicio DESC;
    END;

    PROCEDURE CARRITO_LISTAR_DETALLE(p_carrito IN NUMBER, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        assert_id(p_carrito, 'Carrito: ID obligatorio.');
        OPEN p_data FOR
            SELECT d.detcar_detalle_carrito,
                   d.pre_carrito,
                   d.detpre_cantidad,
                   hv.hv_historial_precio_venta,
                   hv.hv_precio_final,
                   hv.hv_precio_final * d.detpre_cantidad AS subtotal,
                   p.pro_referencia,
                   p.pro_nombre
              FROM CLI_DETALLE_CARRITO d
              JOIN BOD_HISTORIAL_PRECIO_VENTA hv ON hv.hv_historial_precio_venta = d.hv_historial_precio_venta
              JOIN BOD_PRODUCTO              p  ON p.pro_referencia = hv.pro_referencia
             WHERE d.pre_carrito = p_carrito
             ORDER BY d.detcar_detalle_carrito;
    END;

    PROCEDURE CARRITO_PRODUCTOS_DISPONIBLES(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT hv.hv_historial_precio_venta,
                   hv.pro_referencia,
                   p.pro_nombre,
                   p.pro_descripcion,
                   hv.hv_precio_final,
                   hv.hv_porcetaje,
                   hv.hv_fecha_inicio,
                   hv.hv_fecha_final
              FROM BOD_HISTORIAL_PRECIO_VENTA hv
              JOIN BOD_PRODUCTO              p ON p.pro_referencia = hv.pro_referencia
             WHERE hv.hv_fecha_final IS NULL
                OR hv.hv_fecha_final >= SYSDATE
             ORDER BY p.pro_nombre;
    END;

    PROCEDURE CARRITO_RESUMEN(p_carrito IN NUMBER, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        assert_id(p_carrito, 'Carrito: ID obligatorio.');
        OPEN p_data FOR
            SELECT c.pre_carrito,
                   c.pre_correlativo,
                   c.pre_fecha_inicio,
                   cl.cli_primer_nombre || ' ' || cl.cli_primer_apellido AS nombre_cliente,
                   p.pro_referencia,
                   p.pro_nombre,
                   hv.hv_precio_final,
                   d.detpre_cantidad,
                   hv.hv_precio_final * d.detpre_cantidad AS subtotal,
                   SUM(hv.hv_precio_final * d.detpre_cantidad)
                       OVER (PARTITION BY c.pre_carrito) AS total
              FROM CLI_CARRITO             c
              JOIN CLI_CLIENTE             cl ON cl.cli_cliente               = c.cli_cliente
              JOIN CLI_DETALLE_CARRITO     d  ON d.pre_carrito                = c.pre_carrito
              JOIN BOD_HISTORIAL_PRECIO_VENTA hv ON hv.hv_historial_precio_venta = d.hv_historial_precio_venta
              JOIN BOD_PRODUCTO            p  ON p.pro_referencia             = hv.pro_referencia
             WHERE c.pre_carrito = p_carrito
             ORDER BY d.detcar_detalle_carrito;
    END;

    PROCEDURE CARRITO_RESUMEN_TODOS(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT c.pre_carrito,
                   c.pre_correlativo,
                   c.pre_fecha_inicio,
                   cl.cli_primer_nombre || ' ' || cl.cli_primer_apellido AS nombre_cliente,
                   p.pro_referencia,
                   p.pro_nombre,
                   hv.hv_precio_final,
                   d.detpre_cantidad,
                   hv.hv_precio_final * d.detpre_cantidad AS subtotal,
                   SUM(hv.hv_precio_final * d.detpre_cantidad)
                       OVER (PARTITION BY c.pre_carrito) AS total
              FROM CLI_CARRITO             c
              JOIN CLI_CLIENTE             cl ON cl.cli_cliente               = c.cli_cliente
              JOIN CLI_DETALLE_CARRITO     d  ON d.pre_carrito                = c.pre_carrito
              JOIN BOD_HISTORIAL_PRECIO_VENTA hv ON hv.hv_historial_precio_venta = d.hv_historial_precio_venta
              JOIN BOD_PRODUCTO            p  ON p.pro_referencia             = hv.pro_referencia
             ORDER BY c.pre_carrito, d.detcar_detalle_carrito;
    END;

PROCEDURE CARRITO_FACTURAR(p_carrito IN NUMBER) IS
    CURSOR c_detalles IS
        SELECT d.detpre_cantidad,
               h.hip_historial_precio
          FROM CLI_DETALLE_CARRITO d
          JOIN BOD_HISTORIAL_PRECIO_VENTA hv ON hv.hv_historial_precio_venta = d.hv_historial_precio_venta
          JOIN (
              SELECT h2.hip_historial_precio, h2.pro_referencia,
                     ROW_NUMBER() OVER (PARTITION BY h2.pro_referencia ORDER BY s.sto_disponible DESC) rn
                FROM BOD_HISTORIAL_PRECIO h2
                JOIN BOD_STOCK s ON s.hip_historial_precio = h2.hip_historial_precio
               WHERE h2.hip_fecha_final IS NULL
                 AND h2.hip_precio IS NOT NULL
                 AND s.sto_disponible > 0
          ) h ON h.pro_referencia = hv.pro_referencia AND h.rn = 1
         WHERE d.pre_carrito = p_carrito;
    v_disponible NUMBER;
BEGIN
    assert_id(p_carrito, 'Carrito: ID obligatorio.');
    FOR r IN c_detalles LOOP
        SELECT sto_disponible INTO v_disponible
          FROM BOD_STOCK
         WHERE hip_historial_precio = r.hip_historial_precio;

        IF v_disponible < r.detpre_cantidad THEN
            RAISE_APPLICATION_ERROR(-20012,
                'Stock insuficiente. Disponible: ' || v_disponible ||
                ', Solicitado: ' || r.detpre_cantidad);
        END IF;

        PKG_BOD_STOCK.SALIDA(r.hip_historial_precio, r.detpre_cantidad);
    END LOOP;
END;

PROCEDURE ALMACENES_CON_STOCK(p_hv_ids IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
    v_total NUMBER;
BEGIN
    SELECT COUNT(DISTINCT hv.pro_referencia)
      INTO v_total
      FROM BOD_HISTORIAL_PRECIO_VENTA hv
     WHERE INSTR(',' || p_hv_ids || ',', ',' || hv.hv_historial_precio_venta || ',') > 0;

    OPEN p_data FOR
        SELECT a.alm_almacen,
               a.alm_nombre,
               a.alm_ubicacion,
               a.alm_pais
          FROM BOD_ALMACEN a
         WHERE (
            SELECT COUNT(DISTINCT hv2.pro_referencia)
              FROM BOD_STOCK              s
              JOIN BOD_HISTORIAL_PRECIO   h   ON h.hip_historial_precio = s.hip_historial_precio
                                             AND h.hip_fecha_final IS NULL
              JOIN BOD_NIC_ALM            na  ON na.nic_nicho = h.nic_nicho
              JOIN BOD_HISTORIAL_PRECIO_VENTA hv2 ON hv2.pro_referencia = h.pro_referencia
                                                 AND hv2.hv_fecha_final IS NULL
             WHERE na.alm_almacen = a.alm_almacen
               AND s.sto_disponible > 0
               AND INSTR(',' || p_hv_ids || ',', ',' || hv2.hv_historial_precio_venta || ',') > 0
         ) >= v_total
         ORDER BY a.alm_nombre;
END;

END PKG_CLI_CARRITO;
/