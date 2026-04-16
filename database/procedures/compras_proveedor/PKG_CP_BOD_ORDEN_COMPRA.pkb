CREATE OR REPLACE PACKAGE BODY PKG_CP_BOD_ORDEN_COMPRA AS

    PROCEDURE ORC_CREAR(
        p_orc_key  IN VARCHAR2,
        p_codigo   IN VARCHAR2,
        p_prov_id  IN NUMBER,
        p_total    IN NUMBER
    ) IS
    BEGIN
        INSERT INTO BOD_ORDEN_COMPRA(
            orc_orden_compra, orc_codigo, prov_proveedor, orc_fecha, orc_total_precio)
        VALUES (p_orc_key, p_codigo, p_prov_id, SYSDATE, p_total);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END ORC_CREAR;

    PROCEDURE ORC_ACTUALIZAR(
        p_orc_key IN VARCHAR2,
        p_codigo  IN VARCHAR2,
        p_prov_id IN NUMBER,
        p_total   IN NUMBER
    ) IS
    BEGIN
        UPDATE BOD_ORDEN_COMPRA
           SET orc_codigo       = p_codigo,
               prov_proveedor   = p_prov_id,
               orc_total_precio = p_total
         WHERE orc_orden_compra = p_orc_key;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END ORC_ACTUALIZAR;

    PROCEDURE ORC_ACTUALIZAR_TOTAL(
        p_orc_key IN VARCHAR2,
        p_total   IN NUMBER
    ) IS
    BEGIN
        UPDATE BOD_ORDEN_COMPRA
           SET orc_total_precio = p_total
         WHERE orc_orden_compra = p_orc_key;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END ORC_ACTUALIZAR_TOTAL;

    PROCEDURE ORC_ELIMINAR(p_orc_key IN VARCHAR2) IS
    BEGIN
        DELETE FROM BOD_ORDEN_DETALLE_PEDIDO WHERE orc_orden_compra = p_orc_key;
        DELETE FROM BOD_ORDEN_COMPRA          WHERE orc_orden_compra = p_orc_key;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END ORC_ELIMINAR;

    PROCEDURE ORC_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT o.orc_orden_compra  AS ORC_KEY,
                   o.orc_codigo        AS CODIGO,
                   p.prov_nombre       AS PROVEEDOR,
                   o.orc_fecha         AS FECHA,
                   o.orc_total_precio  AS TOTAL
              FROM BOD_ORDEN_COMPRA o
              JOIN BOD_PROVEEDOR    p ON o.prov_proveedor = p.prov_proveedor
             ORDER BY o.orc_fecha DESC;
    END ORC_LISTAR;

    PROCEDURE ORC_LISTAR_ID(
        p_orc_key IN VARCHAR2,
        p_data    OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_data FOR
            SELECT o.orc_orden_compra  AS ORC_KEY,
                   o.orc_codigo        AS CODIGO,
                   p.prov_nombre       AS PROVEEDOR,
                   o.orc_fecha         AS FECHA,
                   o.orc_total_precio  AS TOTAL,
                   d.odp_material      AS MATERIAL,
                   d.odp_cantidad      AS CANTIDAD,
                   d.odp_precio        AS PRECIO
              FROM BOD_ORDEN_COMPRA o
              JOIN BOD_PROVEEDOR    p ON o.prov_proveedor   = p.prov_proveedor
              LEFT JOIN BOD_ORDEN_DETALLE_PEDIDO d
                     ON o.orc_orden_compra = d.orc_orden_compra
             WHERE o.orc_orden_compra = p_orc_key;
    END ORC_LISTAR_ID;

    PROCEDURE ORC_BUSCAR(
        p_codigo IN VARCHAR2,
        p_data   OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_data FOR
            SELECT o.orc_orden_compra  AS ORC_KEY,
                   o.orc_codigo        AS CODIGO,
                   p.prov_nombre       AS PROVEEDOR,
                   o.orc_fecha         AS FECHA,
                   o.orc_total_precio  AS TOTAL
              FROM BOD_ORDEN_COMPRA o
              JOIN BOD_PROVEEDOR    p ON o.prov_proveedor = p.prov_proveedor
             WHERE UPPER(o.orc_codigo)       LIKE '%' || UPPER(p_codigo) || '%'
                OR UPPER(p.prov_nombre)      LIKE '%' || UPPER(p_codigo) || '%'
                OR UPPER(o.orc_orden_compra) LIKE '%' || UPPER(p_codigo) || '%'
             ORDER BY o.orc_fecha DESC;
    END ORC_BUSCAR;

    -- Busca pedidos: devuelve UNA fila por pedido (cabecera solamente)
    PROCEDURE ORC_BUSCAR_PEDIDOS(
        p_texto IN VARCHAR2,
        p_data  OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_data FOR
            SELECT pe.ped_pedido,
                   pe.ped_codigo,
                   pe.ped_fecha,
                   pe.ped_forma_pago,
                   pe.ped_total,
                   COUNT(d.detpe_detalle_pedido) AS total_items
              FROM BOD_PEDIDO         pe
              LEFT JOIN BOD_DETALLE_PEDIDO d ON d.ped_pedido = pe.ped_pedido
             WHERE UPPER(pe.ped_codigo)   LIKE '%' || UPPER(NVL(p_texto, '')) || '%'
                OR TO_CHAR(pe.ped_pedido) LIKE '%' || NVL(p_texto, '') || '%'
             GROUP BY pe.ped_pedido, pe.ped_codigo, pe.ped_fecha, pe.ped_forma_pago, pe.ped_total
             ORDER BY pe.ped_fecha DESC;
    END ORC_BUSCAR_PEDIDOS;

    -- Devuelve todos los items (detalles) de un pedido con producto y material
    PROCEDURE ORC_DETALLES_PEDIDO(
        p_ped_id IN NUMBER,
        p_data   OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_data FOR
            SELECT d.detpe_detalle_pedido,
                   d.ped_pedido,
                   d.hip_historial_precio,
                   d.detpe_cantidad_solicitada  AS cantidad,
                   h.hip_precio                 AS precio_ref,
                   p.pro_referencia,
                   p.pro_nombre                 AS producto_nombre,
                   m.mat_descripcion            AS material
              FROM BOD_DETALLE_PEDIDO   d
              JOIN BOD_HISTORIAL_PRECIO h ON h.hip_historial_precio = d.hip_historial_precio
              JOIN BOD_PRODUCTO         p ON p.pro_referencia       = h.pro_referencia
              JOIN BOD_MATERIAL         m ON m.mat_material         = p.mat_material
             WHERE d.ped_pedido = p_ped_id
             ORDER BY d.detpe_detalle_pedido;
    END ORC_DETALLES_PEDIDO;

END PKG_CP_BOD_ORDEN_COMPRA;
/
