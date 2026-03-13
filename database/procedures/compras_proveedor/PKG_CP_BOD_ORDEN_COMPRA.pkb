CREATE OR REPLACE PACKAGE BODY PKG_CP_BOD_ORDEN_COMPRA AS
    PROCEDURE ORC_CREAR(p_orc_key IN VARCHAR2, p_codigo IN VARCHAR2, p_prov_id IN NUMBER, p_total IN NUMBER) IS
    BEGIN
        INSERT INTO BOD_ORDEN_COMPRA(orc_orden_compra, orc_codigo, prov_proveedor, orc_fecha, orc_total_precio)
        VALUES (p_orc_key, p_codigo, p_prov_id, SYSDATE, p_total);
    END;

    PROCEDURE ORC_VINCULAR_PEDIDO(p_orc_key IN VARCHAR2, p_ped_id IN NUMBER, p_mat IN VARCHAR2, p_precio IN NUMBER, p_cant IN NUMBER) IS
    BEGIN
        INSERT INTO BOD_ORDEN_DETALLE_PEDIDO(orc_orden_compra, ped_pedido, odp_material, odp_precio, odp_cantidad)
        VALUES (p_orc_key, p_ped_id, p_mat, p_precio, p_cant);
    END;

    PROCEDURE ORC_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR SELECT o.*, p.prov_nombre FROM BOD_ORDEN_COMPRA o 
        JOIN BOD_PROVEEDOR p ON o.prov_proveedor = p.prov_proveedor;
    END;
END PKG_CP_BOD_ORDEN_COMPRA;
/