CREATE OR REPLACE PACKAGE BODY PKG_BOD_ORDEN_DETALLE_PEDIDO AS

    PROCEDURE ODP_INSERTAR(
        p_orc_key  IN VARCHAR2,
        p_ped_id   IN NUMBER,
        p_material IN VARCHAR2,
        p_precio   IN NUMBER,
        p_cantidad IN NUMBER
    ) IS
    BEGIN
        INSERT INTO BOD_ORDEN_DETALLE_PEDIDO
            (orc_orden_compra, ped_pedido, odp_material, odp_precio, odp_cantidad)
        VALUES
            (p_orc_key, p_ped_id, p_material, p_precio, p_cantidad);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN 
            ROLLBACK; 
            RAISE;
    END ODP_INSERTAR;

    PROCEDURE ODP_ACTUALIZAR(
        p_odp_id   IN NUMBER,
        p_material IN VARCHAR2,
        p_precio   IN NUMBER,
        p_cantidad IN NUMBER
    ) IS
    BEGIN
        UPDATE BOD_ORDEN_DETALLE_PEDIDO
           SET odp_material = p_material,
               odp_precio   = p_precio,
               odp_cantidad = p_cantidad
         WHERE odp_orden_detalle_pedido = p_odp_id;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN 
            ROLLBACK; 
            RAISE;
    END ODP_ACTUALIZAR;

    PROCEDURE ODP_ELIMINAR(p_odp_id IN NUMBER) IS
    BEGIN
        DELETE FROM BOD_ORDEN_DETALLE_PEDIDO
         WHERE odp_orden_detalle_pedido = p_odp_id;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN 
            ROLLBACK; 
            RAISE;
    END ODP_ELIMINAR;

  PROCEDURE ODP_LISTAR_POR_ORDEN(
        p_orc_key IN VARCHAR2,
        p_data    OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_data FOR
            SELECT d.odp_orden_detalle_pedido,
                   d.orc_orden_compra,
                   d.ped_pedido,
                   p.ped_codigo,        -- Ahora sí lo traerá de la tabla BOD_PEDIDO
                   d.odp_material,
                   d.odp_precio,
                   d.odp_cantidad
              FROM BOD_ORDEN_DETALLE_PEDIDO d
              LEFT JOIN BOD_PEDIDO p ON d.ped_pedido = p.ped_pedido -- Unimos las tablas
             WHERE d.orc_orden_compra = p_orc_key
             ORDER BY d.odp_orden_detalle_pedido;
    END ODP_LISTAR_POR_ORDEN;

    PROCEDURE ODP_LISTAR_POR_PEDIDO(
    p_ped_id IN NUMBER,
    p_data   OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_data FOR
        SELECT d.odp_id,        -- El nuevo ID único de la secuencia
               d.odp_precio,    -- El precio que pactaste en la orden
               d.odp_material,
               p.pro_referencia -- ¡ESTO ES VITAL PARA COMPARAR!
          FROM BOD_ORDEN_DETALLE_PEDIDO d
          JOIN BOD_DETALLE_PEDIDO dp ON d.ped_pedido = dp.ped_pedido 
          -- Necesitamos unir con la tabla de productos para obtener la referencia
          JOIN BOD_HISTORIAL_PRECIO h ON dp.hip_historial_precio = h.hip_historial_precio
          JOIN BOD_PRODUCTO p ON h.pro_producto = p.pro_producto
         WHERE d.ped_pedido = p_ped_id;
END ODP_LISTAR_POR_PEDIDO;

END PKG_BOD_ORDEN_DETALLE_PEDIDO;
/