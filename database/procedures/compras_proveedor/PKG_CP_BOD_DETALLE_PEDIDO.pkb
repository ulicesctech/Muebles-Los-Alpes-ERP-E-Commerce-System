CREATE OR REPLACE PACKAGE BODY PKG_BOD_DETALLE_PEDIDO AS

    PROCEDURE DET_PED_INSERTAR(
        p_ped_pedido      IN NUMBER,
        p_hip_historial   IN NUMBER,
        p_cant_solicitada IN NUMBER,
        p_cant_recibida   IN NUMBER DEFAULT 0
    ) IS
    BEGIN
        INSERT INTO BOD_DETALLE_PEDIDO
            (ped_pedido, hip_historial_precio, detpe_cantidad_solicitada, detpe_cantidad_recibida)
        VALUES
            (p_ped_pedido, p_hip_historial, p_cant_solicitada, p_cant_recibida);
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
        OPEN p_data FOR
            SELECT d.detpe_detalle_pedido,
                   d.ped_pedido,
                   d.detpe_cantidad_solicitada,
                   d.detpe_cantidad_recibida,
                   h.hip_precio,
                   p.pro_nombre
              FROM BOD_DETALLE_PEDIDO    d
              JOIN BOD_HISTORIAL_PRECIO  h ON d.hip_historial_precio = h.hip_historial_precio
              JOIN BOD_PRODUCTO          p ON h.pro_referencia        = p.pro_referencia
             WHERE d.ped_pedido = p_ped_pedido;
    END DET_PED_LISTAR_POR_PEDIDO;

    PROCEDURE DET_PED_LISTAR_PRODUCTOS(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT h.hip_historial_precio,
                   p.pro_nombre || ' — Q' || TO_CHAR(h.hip_precio, 'FM999,999,990.00') AS pro_nombre,
                   h.hip_precio
              FROM BOD_HISTORIAL_PRECIO h
              JOIN BOD_PRODUCTO         p ON h.pro_referencia = p.pro_referencia
             WHERE h.hip_fecha_final IS NULL
             ORDER BY p.pro_nombre;
    END DET_PED_LISTAR_PRODUCTOS;

END PKG_BOD_DETALLE_PEDIDO;
/