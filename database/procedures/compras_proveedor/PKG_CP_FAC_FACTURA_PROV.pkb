CREATE OR REPLACE PACKAGE BODY PKG_CP_FAC_FACTURA_PROV AS

    PROCEDURE FAC_PROV_REGISTRAR(p_orc_key IN VARCHAR2, p_fac_cod IN VARCHAR2) IS
    BEGIN
        INSERT INTO FAC_FACTURA_PROVEEDOR(orc_orden_compra, facpro_codigo_factura, facpro_fecha)
        VALUES (p_orc_key, p_fac_cod, SYSDATE);
        COMMIT;
    END;

    PROCEDURE FAC_PROV_ACTUALIZAR(p_orc_key_old IN VARCHAR2, p_orc_key_new IN VARCHAR2, p_fac_cod IN VARCHAR2) IS
    BEGIN
        UPDATE FAC_FACTURA_PROVEEDOR 
        SET orc_orden_compra = p_orc_key_new,
            facpro_codigo_factura = p_fac_cod
        WHERE orc_orden_compra = p_orc_key_old;
        COMMIT;
    END;

    PROCEDURE FAC_PROV_ELIMINAR(p_orc_key IN VARCHAR2) IS
    BEGIN
        DELETE FROM FAC_FACTURA_PROVEEDOR WHERE orc_orden_compra = p_orc_key;
        COMMIT;
    END;

    PROCEDURE FAC_PROV_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN 
        OPEN p_data FOR 
            SELECT f.orc_orden_compra, f.facpro_codigo_factura, f.facpro_fecha, o.orc_codigo
            FROM FAC_FACTURA_PROVEEDOR f
            INNER JOIN BOD_ORDEN_COMPRA o ON f.orc_orden_compra = o.orc_orden_compra
            ORDER BY f.facpro_fecha DESC; 
    END;

    PROCEDURE FAC_PROV_BUSCAR(p_texto IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT f.orc_orden_compra, f.facpro_codigo_factura, f.facpro_fecha, o.orc_codigo
            FROM FAC_FACTURA_PROVEEDOR f
            INNER JOIN BOD_ORDEN_COMPRA o ON f.orc_orden_compra = o.orc_orden_compra
            WHERE UPPER(f.facpro_codigo_factura) LIKE '%' || UPPER(p_texto) || '%'
               OR UPPER(o.orc_codigo) LIKE '%' || UPPER(p_texto) || '%'
            ORDER BY f.facpro_fecha DESC;
    END;

END PKG_CP_FAC_FACTURA_PROV;
/