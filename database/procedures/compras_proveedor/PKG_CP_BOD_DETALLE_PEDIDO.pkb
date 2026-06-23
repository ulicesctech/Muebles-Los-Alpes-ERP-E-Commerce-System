-- *** CAMBIE AHORITA: se elimino toda referencia a pro_referencia como columna
-- de BOD_DETALLE_PEDIDO porque fue dropeada (ALTER TABLE DROP COLUMN pro_referencia).
-- Ahora el producto y material se obtienen UNICAMENTE via el JOIN con
-- BOD_HISTORIAL_PRECIO → BOD_PRODUCTO → BOD_MATERIAL usando hip_historial_precio.
CREATE OR REPLACE PACKAGE BODY PKG_BOD_DETALLE_PEDIDO AS

    PROCEDURE DET_PED_INSERTAR(
        p_ped_pedido      IN NUMBER,
        p_hip_historial   IN NUMBER,
        p_pro_referencia  IN VARCHAR2,
        p_cant_solicitada IN NUMBER,
        p_cant_recibida   IN NUMBER DEFAULT 0
    ) IS
        v_existe NUMBER;
    BEGIN
        -- Verificar que el producto no este ya en el pedido
        -- comparando pro_referencia via BOD_HISTORIAL_PRECIO de los items existentes
        SELECT COUNT(*)
          INTO v_existe
          FROM BOD_DETALLE_PEDIDO d
          JOIN BOD_HISTORIAL_PRECIO h ON h.hip_historial_precio = d.hip_historial_precio
         WHERE d.ped_pedido    = p_ped_pedido
           AND h.pro_referencia = TRIM(p_pro_referencia);

        IF v_existe > 0 THEN
            RAISE_APPLICATION_ERROR(-20060,
                'Este producto ya fue agregado al pedido. No se puede repetir.');
        END IF;

        INSERT INTO BOD_DETALLE_PEDIDO
            (ped_pedido, hip_historial_precio,
             detpe_cantidad_solicitada, detpe_cantidad_recibida)
        VALUES
            (p_ped_pedido,
             NULLIF(p_hip_historial, 0),
             p_cant_solicitada,
             p_cant_recibida);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END DET_PED_INSERTAR;

    PROCEDURE DET_PED_ACTUALIZAR(
        p_detpe_id        IN NUMBER,
        p_cant_solicitada IN NUMBER,
        p_cant_recibida   IN NUMBER
    ) IS
    BEGIN
        UPDATE BOD_DETALLE_PEDIDO
           SET detpe_cantidad_solicitada = p_cant_solicitada,
               detpe_cantidad_recibida  = p_cant_recibida
         WHERE detpe_detalle_pedido = p_detpe_id;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END DET_PED_ACTUALIZAR;

    PROCEDURE DET_PED_ELIMINAR(p_detpe_id IN NUMBER) IS
        v_hip_id   NUMBER;
        v_ped_id   NUMBER;
        v_precio   NUMBER;
        v_nicho    NUMBER;
        v_tiene_oc NUMBER;
        v_otros    NUMBER;
    BEGIN
        -- Leer ped_pedido e hip_historial_precio antes de borrar
        SELECT ped_pedido, hip_historial_precio
          INTO v_ped_id, v_hip_id
          FROM BOD_DETALLE_PEDIDO
         WHERE detpe_detalle_pedido = p_detpe_id;

        -- Bloquear si el pedido ya tiene Orden de Compra
        SELECT COUNT(*)
          INTO v_tiene_oc
          FROM BOD_ORDEN_DETALLE_PEDIDO
         WHERE ped_pedido = v_ped_id;

        IF v_tiene_oc > 0 THEN
            RAISE_APPLICATION_ERROR(-20060,
                'No se puede eliminar: el pedido ya tiene una Orden de Compra asociada.');
        END IF;

        -- Borrar el detalle
        DELETE FROM BOD_DETALLE_PEDIDO
         WHERE detpe_detalle_pedido = p_detpe_id;

        -- Si tenia semilla vinculada, verificar si es huerfana y borrarla
        IF v_hip_id IS NOT NULL THEN
            SELECT NVL(hip_precio, -1), NVL(nic_nicho, -1)
              INTO v_precio, v_nicho
              FROM BOD_HISTORIAL_PRECIO
             WHERE hip_historial_precio = v_hip_id;

            -- Es semilla si precio o nicho son NULL (representados como -1 por NVL)
            IF v_precio = -1 OR v_nicho = -1 THEN
                -- Contar cuantos detalles quedan apuntando a esta semilla
                SELECT COUNT(*)
                  INTO v_otros
                  FROM BOD_DETALLE_PEDIDO
                 WHERE hip_historial_precio = v_hip_id;

                -- Si nadie mas la referencia, eliminarla
                IF v_otros = 0 THEN
                    DELETE FROM BOD_HISTORIAL_PRECIO
                     WHERE hip_historial_precio = v_hip_id;
                END IF;
            END IF;
        END IF;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END DET_PED_ELIMINAR;

    PROCEDURE DET_PED_LISTAR_POR_PEDIDO(
        p_ped_pedido IN NUMBER,
        p_data       OUT SYS_REFCURSOR
    ) IS
    BEGIN
        -- *** CAMBIE AHORITA: se eliminaron los JOINs via d.pro_referencia directa
        -- (p2, m2) porque esa columna ya no existe en BOD_DETALLE_PEDIDO.
        -- Producto y material se obtienen SOLO via hip_historial_precio → BOD_HISTORIAL_PRECIO
        -- → BOD_PRODUCTO → BOD_MATERIAL. La semilla creada en REGISTRAR_SEMILLA
        -- garantiza que hip_historial_precio tenga la pro_referencia correcta.
        OPEN p_data FOR
            SELECT d.detpe_detalle_pedido,
                   d.ped_pedido,
                   d.hip_historial_precio,
                   d.detpe_cantidad_solicitada,
                   d.detpe_cantidad_recibida,
                   NVL(h.hip_precio, 0)          AS hip_precio,
                   NVL(p.pro_nombre, '—')        AS pro_nombre,
                   NVL(m.mat_descripcion, '—')   AS material,
                   h.pro_referencia              AS pro_referencia
              FROM BOD_DETALLE_PEDIDO   d
              LEFT JOIN BOD_HISTORIAL_PRECIO h  ON h.hip_historial_precio = d.hip_historial_precio
              LEFT JOIN BOD_PRODUCTO         p  ON p.pro_referencia       = h.pro_referencia
              LEFT JOIN BOD_MATERIAL         m  ON m.mat_material         = p.mat_material
             WHERE d.ped_pedido = p_ped_pedido
             ORDER BY d.detpe_detalle_pedido;
    END DET_PED_LISTAR_POR_PEDIDO;

    PROCEDURE DET_PED_LISTAR_PRODUCTOS(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT h.hip_historial_precio,
                   p.pro_referencia,
                   p.pro_nombre || ' - Q' || TO_CHAR(h.hip_precio, 'FM999,999,990.00') AS pro_nombre,
                   h.hip_precio
              FROM BOD_HISTORIAL_PRECIO h
              JOIN BOD_PRODUCTO         p ON h.pro_referencia = p.pro_referencia
             WHERE h.hip_fecha_final IS NULL
               AND h.hip_precio IS NOT NULL
             ORDER BY p.pro_nombre;
    END DET_PED_LISTAR_PRODUCTOS;

    PROCEDURE DET_PED_LISTAR_PRODUCTOS_BASE(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT h.hip_historial_precio,
                   p.pro_referencia,
                   p.pro_nombre,
                   h.hip_precio AS precio_sugerido
              FROM BOD_HISTORIAL_PRECIO h
              JOIN BOD_PRODUCTO         p ON h.pro_referencia = p.pro_referencia
             WHERE h.hip_fecha_final IS NULL
               AND h.hip_precio IS NOT NULL
             ORDER BY p.pro_nombre;
    END DET_PED_LISTAR_PRODUCTOS_BASE;

    PROCEDURE DET_PED_LISTAR_TODOS_PRODUCTOS(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT p.pro_referencia,
                   p.pro_nombre || ' — ' || NVL(m.mat_descripcion, '?') AS pro_nombre,
                   NVL(
                       (SELECT h.hip_precio
                          FROM BOD_HISTORIAL_PRECIO h
                         WHERE h.pro_referencia = p.pro_referencia
                           AND h.hip_fecha_final IS NULL
                           AND h.hip_precio IS NOT NULL
                           AND ROWNUM = 1), 0) AS precio_sugerido,
                   NVL(
                       (SELECT h.nic_nicho
                          FROM BOD_HISTORIAL_PRECIO h
                         WHERE h.pro_referencia = p.pro_referencia
                           AND h.hip_fecha_final IS NULL
                           AND h.hip_precio IS NOT NULL
                           AND ROWNUM = 1), 0) AS nic_nicho_vigente,
                   NVL(
                       (SELECT h.hip_historial_precio
                          FROM BOD_HISTORIAL_PRECIO h
                         WHERE h.pro_referencia = p.pro_referencia
                           AND h.hip_fecha_final IS NULL
                           AND h.hip_precio IS NOT NULL
                           AND ROWNUM = 1), 0) AS hip_id_vigente
              FROM BOD_PRODUCTO p
              LEFT JOIN BOD_MATERIAL m ON m.mat_material = p.mat_material
             ORDER BY p.pro_nombre;
    END DET_PED_LISTAR_TODOS_PRODUCTOS;

    PROCEDURE DET_PED_ACTUALIZAR_HISTORIAL(
        p_detpe_id IN NUMBER,
        p_hip_id   IN NUMBER
    ) IS
    BEGIN
        UPDATE BOD_DETALLE_PEDIDO
           SET hip_historial_precio = p_hip_id
         WHERE detpe_detalle_pedido = p_detpe_id;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END DET_PED_ACTUALIZAR_HISTORIAL;

END PKG_BOD_DETALLE_PEDIDO;
/