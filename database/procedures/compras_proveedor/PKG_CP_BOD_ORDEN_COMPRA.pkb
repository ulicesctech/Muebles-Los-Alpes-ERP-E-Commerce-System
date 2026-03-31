CREATE OR REPLACE PACKAGE BODY PKG_CP_BOD_ORDEN_COMPRA AS
    PROCEDURE ORC_CREAR(
        p_orc_key  IN VARCHAR2, 
        p_codigo   IN VARCHAR2, 
        p_prov_id  IN NUMBER, 
        p_total    IN NUMBER
    ) IS
        v_next_id VARCHAR2(50);
    BEGIN
        v_next_id := 'OC' || SEQ_ORDEN_COMPRA.NEXTVAL;

        INSERT INTO BOD_ORDEN_COMPRA(orc_orden_compra, orc_codigo, prov_proveedor, orc_fecha, orc_total_precio)
        VALUES (v_next_id, p_codigo, p_prov_id, SYSDATE, p_total);
        COMMIT;
    EXCEPTION WHEN OTHERS THEN ROLLBACK; RAISE;
    END;

    PROCEDURE ORC_ACTUALIZAR(
        p_orc_key IN VARCHAR2, 
        p_codigo  IN VARCHAR2, 
        p_prov_id IN NUMBER, 
        p_total   IN NUMBER
    ) IS
    BEGIN
        UPDATE BOD_ORDEN_COMPRA 
        SET orc_codigo = p_codigo, 
            prov_proveedor = p_prov_id, -- Actualización habilitada
            orc_total_precio = p_total
        WHERE orc_orden_compra = p_orc_key;
        COMMIT;
    EXCEPTION WHEN OTHERS THEN ROLLBACK; RAISE;
    END;

    PROCEDURE ORC_ELIMINAR(p_orc_key IN VARCHAR2) IS
    BEGIN
        DELETE FROM BOD_ORDEN_DETALLE_PEDIDO WHERE orc_orden_compra = p_orc_key;
        DELETE FROM BOD_ORDEN_COMPRA WHERE orc_orden_compra = p_orc_key;
        COMMIT;
    EXCEPTION WHEN OTHERS THEN ROLLBACK; RAISE;
    END;

    PROCEDURE ORC_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR 
            SELECT o.*, p.prov_nombre 
            FROM BOD_ORDEN_COMPRA o
            JOIN BOD_PROVEEDOR p ON o.prov_proveedor = p.prov_proveedor
            ORDER BY o.orc_fecha DESC;
    END;

    PROCEDURE ORC_LISTAR_ID(p_orc_key IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR 
            SELECT o.*, p.prov_nombre, d.odp_material, d.odp_cantidad, d.odp_precio
            FROM BOD_ORDEN_COMPRA o
            JOIN BOD_PROVEEDOR p ON o.prov_proveedor = p.prov_proveedor
            LEFT JOIN BOD_ORDEN_DETALLE_PEDIDO d ON o.orc_orden_compra = d.orc_orden_compra
            WHERE o.orc_orden_compra = p_orc_key;
    END;

  PROCEDURE ORC_BUSCAR(p_codigo IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
BEGIN
    OPEN p_data FOR 
        SELECT o.*, p.prov_nombre 
        FROM BOD_ORDEN_COMPRA o
        JOIN BOD_PROVEEDOR p ON o.prov_proveedor = p.prov_proveedor
        -- Convertimos ambos lados a mayúsculas para la comparación
        WHERE UPPER(o.orc_codigo) LIKE '%' || UPPER(p_codigo) || '%'
        ORDER BY o.orc_fecha DESC;
END;
END PKG_CP_BOD_ORDEN_COMPRA;
/