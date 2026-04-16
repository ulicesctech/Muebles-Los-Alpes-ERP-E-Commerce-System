CREATE OR REPLACE PACKAGE BODY PKG_CP_FAC_FACTURA_PROV AS
    PROCEDURE FAC_PROV_REGISTRAR(p_orc_key IN VARCHAR2, p_fac_cod IN VARCHAR2) IS
    BEGIN
        INSERT INTO FAC_FACTURA_PROVEEDOR(orc_orden_compra, facpro_codigo_factura, facpro_fecha)
        VALUES (p_orc_key, p_fac_cod, SYSDATE);
        COMMIT;
    EXCEPTION WHEN OTHERS THEN ROLLBACK; RAISE;
    END;

    PROCEDURE FAC_PROV_ACTUALIZAR(p_orc_key IN VARCHAR2, p_fac_cod IN VARCHAR2) IS
    BEGIN
        UPDATE FAC_FACTURA_PROVEEDOR 
        SET facpro_codigo_factura = p_fac_cod
        WHERE orc_orden_compra = p_orc_key;
        COMMIT;
    EXCEPTION WHEN OTHERS THEN ROLLBACK; RAISE;
    END;

    PROCEDURE FAC_PROV_ELIMINAR(p_orc_key IN VARCHAR2) IS
    BEGIN
        DELETE FROM FAC_FACTURA_PROVEEDOR WHERE orc_orden_compra = p_orc_key;
        COMMIT;
    EXCEPTION WHEN OTHERS THEN ROLLBACK; RAISE;
    END;

    PROCEDURE FAC_PROV_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN 
        OPEN p_data FOR 
            SELECT f.*, o.orc_codigo, p.prov_nombre
            FROM FAC_FACTURA_PROVEEDOR f
            JOIN BOD_ORDEN_COMPRA o ON f.orc_orden_compra = o.orc_orden_compra
            JOIN BOD_PROVEEDOR p ON o.prov_proveedor = p.prov_proveedor
            ORDER BY f.facpro_fecha DESC; 
    END;

    PROCEDURE FAC_PROV_LISTAR_ID(p_orc_key IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
    BEGIN 
        OPEN p_data FOR SELECT * FROM FAC_FACTURA_PROVEEDOR WHERE orc_orden_compra = p_orc_key; 
    END;

    PROCEDURE FAC_PROV_BUSCAR(p_fac_cod IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR 
            SELECT f.*, o.orc_codigo
            FROM FAC_FACTURA_PROVEEDOR f
            JOIN BOD_ORDEN_COMPRA o ON f.orc_orden_compra = o.orc_orden_compra
            WHERE f.facpro_codigo_factura LIKE '%' || p_fac_cod || '%';
    END;
END PKG_CP_FAC_FACTURA_PROV;
/