-- *** CAMBIE AHORITA: se elimino toda referencia a pro_referencia como columna
-- de BOD_DETALLE_PEDIDO porque fue dropeada (ALTER TABLE DROP COLUMN pro_referencia).
-- Ahora el producto y material se obtienen UNICAMENTE via el JOIN con
-- BOD_HISTORIAL_PRECIO → BOD_PRODUCTO → BOD_MATERIAL usando hip_historial_precio.
CREATE OR REPLACE PACKAGE BODY PKG_BOD_DETALLE_PEDIDO AS

    PROCEDURE DET_PED_INSERTAR(
        p_ped_pedido      IN NUMBER,
        p_hip_historial   IN NUMBER,
        p_pro_referencia  IN VARCHAR2,   -- se mantiene en la firma para no romper el .vb
        p_cant_solicitada IN NUMBER,
        p_cant_recibida   IN NUMBER DEFAULT 0
    ) IS
    BEGIN
        -- *** CAMBIE AHORITA: ya no se inserta pro_referencia en la tabla
        -- porque la columna fue eliminada. p_pro_referencia se recibe pero se ignora.
        -- La conexion con BOD_PRODUCTO se hace via hip_historial_precio (semilla).
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
    BEGIN
        DELETE FROM BOD_DETALLE_PEDIDO
         WHERE detpe_detalle_pedido = p_detpe_id;
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
