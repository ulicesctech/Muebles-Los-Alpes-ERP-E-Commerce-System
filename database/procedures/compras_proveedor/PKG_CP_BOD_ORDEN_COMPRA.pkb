CREATE OR REPLACE PACKAGE BODY PKG_CP_BOD_ORDEN_COMPRA AS

    PROCEDURE ORC_CREAR(
        p_orc_key  IN VARCHAR2, 
        p_codigo   IN VARCHAR2, 
        p_prov_id  IN NUMBER, 
        p_total    IN NUMBER
    ) IS
    BEGIN
        -- Se inserta p_orc_key directamente sin usar v_next_id ni secuencias
        INSERT INTO BOD_ORDEN_COMPRA(
            orc_orden_compra, 
            orc_codigo, 
            prov_proveedor, 
            orc_fecha, 
            orc_total_precio
        )
        VALUES (
            p_orc_key, 
            p_codigo, 
            p_prov_id, 
            SYSDATE, 
            p_total
        );
        COMMIT;
    EXCEPTION 
        WHEN OTHERS THEN 
            ROLLBACK; 
            RAISE;
    END ORC_CREAR;

    PROCEDURE ORC_ACTUALIZAR(
        p_orc_key IN VARCHAR2, 
        p_codigo  IN VARCHAR2, 
        p_prov_id IN NUMBER, 
        p_total   IN NUMBER
    ) IS
    BEGIN
        UPDATE BOD_ORDEN_COMPRA 
        SET orc_codigo = p_codigo, 
            prov_proveedor = p_prov_id,
            orc_total_precio = p_total
        WHERE orc_orden_compra = p_orc_key;
        COMMIT;
    EXCEPTION 
        WHEN OTHERS THEN 
            ROLLBACK; 
            RAISE;
    END ORC_ACTUALIZAR;

    PROCEDURE ORC_ELIMINAR(p_orc_key IN VARCHAR2) IS
    BEGIN
        -- Elimina dependencias en detalle antes de borrar la cabecera
        DELETE FROM BOD_ORDEN_DETALLE_PEDIDO WHERE orc_orden_compra = p_orc_key;
        DELETE FROM BOD_ORDEN_COMPRA WHERE orc_orden_compra = p_orc_key;
        COMMIT;
    EXCEPTION 
        WHEN OTHERS THEN 
            ROLLBACK; 
            RAISE;
    END ORC_ELIMINAR;

    PROCEDURE ORC_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR 
            SELECT o.*, p.prov_nombre 
            FROM BOD_ORDEN_COMPRA o
            JOIN BOD_PROVEEDOR p ON o.prov_proveedor = p.prov_proveedor
            ORDER BY o.orc_fecha DESC;
    END ORC_LISTAR;

    PROCEDURE ORC_LISTAR_ID(p_orc_key IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR 
            SELECT o.*, p.prov_nombre, d.odp_material, d.odp_cantidad, d.odp_precio
            FROM BOD_ORDEN_COMPRA o
            JOIN BOD_PROVEEDOR p ON o.prov_proveedor = p.prov_proveedor
            LEFT JOIN BOD_ORDEN_DETALLE_PEDIDO d ON o.orc_orden_compra = d.orc_orden_compra
            WHERE o.orc_orden_compra = p_orc_key;
    END ORC_LISTAR_ID;

    PROCEDURE ORC_BUSCAR(p_codigo IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR 
            SELECT o.*, p.prov_nombre 
            FROM BOD_ORDEN_COMPRA o
            JOIN BOD_PROVEEDOR p ON o.prov_proveedor = p.prov_proveedor
            WHERE UPPER(o.orc_codigo) LIKE '%' || UPPER(p_codigo) || '%'
            ORDER BY o.orc_fecha DESC;
    END ORC_BUSCAR;

END PKG_CP_BOD_ORDEN_COMPRA;
/