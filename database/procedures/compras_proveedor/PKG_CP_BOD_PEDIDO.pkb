CREATE OR REPLACE PACKAGE BODY PKG_CP_BOD_PEDIDO AS

    PROCEDURE PED_CREAR(
        p_codigo     IN  VARCHAR2,
        p_forma_pago IN  VARCHAR2,
        p_total      IN  NUMBER,
        p_id         OUT NUMBER
    ) AS
    BEGIN
        INSERT INTO BOD_PEDIDO(ped_codigo, ped_forma_pago, ped_total, ped_fecha)
        VALUES(TRIM(p_codigo), NVL(p_forma_pago, 'SIMULADO'), NVL(p_total, 0), SYSDATE)
        RETURNING ped_pedido INTO p_id;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END PED_CREAR;

    PROCEDURE PED_ACTUALIZAR(
        p_id         IN NUMBER,
        p_codigo     IN VARCHAR2,
        p_forma_pago IN VARCHAR2,
        p_total      IN NUMBER
    ) AS
    BEGIN
        UPDATE BOD_PEDIDO
           SET ped_codigo     = p_codigo,
               ped_forma_pago = p_forma_pago,
               ped_total      = p_total
         WHERE ped_pedido = p_id;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END PED_ACTUALIZAR;

    PROCEDURE PED_AGREGAR_DETALLE(
        p_ped_id   IN NUMBER,
        p_hip_id   IN NUMBER,
        p_cant_sol IN NUMBER
    ) IS
    BEGIN
        INSERT INTO BOD_DETALLE_PEDIDO(ped_pedido, hip_historial_precio, detpe_cantidad_solicitada)
        VALUES(p_ped_id, p_hip_id, p_cant_sol);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END PED_AGREGAR_DETALLE;

    PROCEDURE PED_ELIMINAR(p_id IN NUMBER) AS
    BEGIN
        DELETE FROM BOD_DETALLE_PEDIDO WHERE ped_pedido = p_id;
        DELETE FROM BOD_PEDIDO         WHERE ped_pedido = p_id;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END PED_ELIMINAR;

    PROCEDURE PED_LISTAR(p_data OUT SYS_REFCURSOR) AS
    BEGIN
        OPEN p_data FOR
            SELECT p.ped_pedido,
                   p.ped_codigo,
                   p.ped_fecha,
                   p.ped_forma_pago,
                   p.ped_total,
                   (SELECT LISTAGG(pr2.pro_nombre, ', ') WITHIN GROUP (ORDER BY pr2.pro_nombre)
                      FROM BOD_DETALLE_PEDIDO  d2
                      JOIN BOD_HISTORIAL_PRECIO h2 ON d2.hip_historial_precio = h2.hip_historial_precio
                      JOIN BOD_PRODUCTO         pr2 ON h2.pro_referencia = pr2.pro_referencia
                     WHERE d2.ped_pedido = p.ped_pedido) AS producto,
                   (SELECT LISTAGG(m2.mat_descripcion, ', ') WITHIN GROUP (ORDER BY m2.mat_descripcion)
                      FROM BOD_DETALLE_PEDIDO  d2
                      JOIN BOD_HISTORIAL_PRECIO h2  ON d2.hip_historial_precio = h2.hip_historial_precio
                      JOIN BOD_PRODUCTO         pr2 ON h2.pro_referencia = pr2.pro_referencia
                      JOIN BOD_MATERIAL         m2  ON pr2.mat_material = m2.mat_material
                     WHERE d2.ped_pedido = p.ped_pedido) AS material,
                   (SELECT SUM(d3.detpe_cantidad_solicitada)
                      FROM BOD_DETALLE_PEDIDO d3
                     WHERE d3.ped_pedido = p.ped_pedido) AS cantidad_solicitada,
                   (SELECT SUM(d4.detpe_cantidad_recibida)
                      FROM BOD_DETALLE_PEDIDO d4
                     WHERE d4.ped_pedido = p.ped_pedido) AS cantidad_ingresada
              FROM BOD_PEDIDO p
             ORDER BY p.ped_pedido DESC;
    END PED_LISTAR;

    PROCEDURE PED_BUSCAR(p_codigo IN VARCHAR2, p_data OUT SYS_REFCURSOR) AS
    BEGIN
        OPEN p_data FOR
            SELECT * FROM (
                SELECT p.ped_pedido,
                       p.ped_codigo,
                       p.ped_fecha,
                       p.ped_forma_pago,
                       p.ped_total,
                       (SELECT LISTAGG(pr2.pro_nombre, ', ') WITHIN GROUP (ORDER BY pr2.pro_nombre)
                          FROM BOD_DETALLE_PEDIDO  d2
                          JOIN BOD_HISTORIAL_PRECIO h2  ON d2.hip_historial_precio = h2.hip_historial_precio
                          JOIN BOD_PRODUCTO         pr2 ON h2.pro_referencia = pr2.pro_referencia
                         WHERE d2.ped_pedido = p.ped_pedido) AS producto,
                       (SELECT LISTAGG(m2.mat_descripcion, ', ') WITHIN GROUP (ORDER BY m2.mat_descripcion)
                          FROM BOD_DETALLE_PEDIDO  d2
                          JOIN BOD_HISTORIAL_PRECIO h2  ON d2.hip_historial_precio = h2.hip_historial_precio
                          JOIN BOD_PRODUCTO         pr2 ON h2.pro_referencia = pr2.pro_referencia
                          JOIN BOD_MATERIAL         m2  ON pr2.mat_material = m2.mat_material
                         WHERE d2.ped_pedido = p.ped_pedido) AS material,
                       (SELECT SUM(d3.detpe_cantidad_solicitada)
                          FROM BOD_DETALLE_PEDIDO d3
                         WHERE d3.ped_pedido = p.ped_pedido) AS cantidad_solicitada,
                       (SELECT SUM(d4.detpe_cantidad_recibida)
                          FROM BOD_DETALLE_PEDIDO d4
                         WHERE d4.ped_pedido = p.ped_pedido) AS cantidad_ingresada
                  FROM BOD_PEDIDO p
            ) t
            WHERE UPPER(t.ped_codigo) LIKE '%' || UPPER(p_codigo) || '%'
               OR UPPER(t.producto)   LIKE '%' || UPPER(p_codigo) || '%'
               OR UPPER(t.material)   LIKE '%' || UPPER(p_codigo) || '%'
            ORDER BY t.ped_pedido DESC;
    END PED_BUSCAR;

    PROCEDURE PED_OBTENER_ID(p_id IN NUMBER, p_data OUT SYS_REFCURSOR) AS
    BEGIN
        OPEN p_data FOR
            SELECT ped_pedido, ped_codigo, ped_fecha, ped_forma_pago, ped_total
              FROM BOD_PEDIDO
             WHERE ped_pedido = p_id;
    END PED_OBTENER_ID;

    PROCEDURE PED_RECIBIR(p_detpe_id IN NUMBER, p_cantidad_recibida IN NUMBER) IS
        v_hip_id   NUMBER;
        v_cant_sol NUMBER;
    BEGIN
        IF p_detpe_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'BOD_DETALLE_PEDIDO: id obligatorio.');
        END IF;
        IF p_cantidad_recibida IS NULL OR p_cantidad_recibida <= 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'BOD_DETALLE_PEDIDO: cantidad recibida debe ser > 0.');
        END IF;
        SELECT hip_historial_precio, detpe_cantidad_solicitada
          INTO v_hip_id, v_cant_sol
          FROM BOD_DETALLE_PEDIDO
         WHERE detpe_detalle_pedido = p_detpe_id;
        IF p_cantidad_recibida > v_cant_sol THEN
            RAISE_APPLICATION_ERROR(-20003, 'BOD_DETALLE_PEDIDO: cantidad recibida no puede superar la solicitada.');
        END IF;
        UPDATE BOD_DETALLE_PEDIDO
           SET detpe_cantidad_recibida = p_cantidad_recibida
         WHERE detpe_detalle_pedido = p_detpe_id;
        PKG_BOD_STOCK.ENTRADA(v_hip_id, p_cantidad_recibida);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END PED_RECIBIR;

    PROCEDURE PED_RECIBIR_TODO(p_ped_id IN NUMBER) IS
        CURSOR c_detalles IS
            SELECT detpe_detalle_pedido, hip_historial_precio, detpe_cantidad_solicitada
              FROM BOD_DETALLE_PEDIDO
             WHERE ped_pedido = p_ped_id;
    BEGIN
        IF p_ped_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20004, 'BOD_PEDIDO: id obligatorio.');
        END IF;
        FOR r IN c_detalles LOOP
            UPDATE BOD_DETALLE_PEDIDO
               SET detpe_cantidad_recibida = r.detpe_cantidad_solicitada
             WHERE detpe_detalle_pedido = r.detpe_detalle_pedido;
            PKG_BOD_STOCK.ENTRADA(r.hip_historial_precio, r.detpe_cantidad_solicitada);
        END LOOP;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END PED_RECIBIR_TODO;

    -- --------------------------------------------------------
    -- PED_LISTAR_FORMAS_PAGO
    -- Devuelve las formas de pago validas definidas en el
    -- CHECK constraint de BOD_PEDIDO (ped_forma_pago).
    -- Columnas: FORMA_PAGO (valor a guardar), DESCRIPCION (texto UI)
    -- --------------------------------------------------------
    PROCEDURE PED_LISTAR_FORMAS_PAGO(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT 'CONTADO' AS forma_pago, 'Contado' AS descripcion FROM DUAL
            UNION ALL
            SELECT 'CREDITO' AS forma_pago, 'Credito' AS descripcion FROM DUAL
            ORDER BY forma_pago;
    END PED_LISTAR_FORMAS_PAGO;

END PKG_CP_BOD_PEDIDO;
/
