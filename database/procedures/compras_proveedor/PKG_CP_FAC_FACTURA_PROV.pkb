CREATE OR REPLACE PACKAGE BODY PKG_CP_FAC_FACTURA_PROV AS

    PROCEDURE FAC_PROV_REGISTRAR(p_orc_key IN VARCHAR2, p_fac_cod IN VARCHAR2) IS
    BEGIN
        INSERT INTO FAC_FACTURA_PROVEEDOR(orc_orden_compra, facpro_codigo_factura, facpro_fecha)
        VALUES (p_orc_key, p_fac_cod, SYSDATE);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END;

    PROCEDURE FAC_PROV_ACTUALIZAR(
        p_orc_key_old IN VARCHAR2,
        p_orc_key_new IN VARCHAR2,
        p_fac_cod     IN VARCHAR2
    ) IS
    BEGIN
        UPDATE FAC_FACTURA_PROVEEDOR
           SET orc_orden_compra      = p_orc_key_new,
               facpro_codigo_factura = p_fac_cod
         WHERE orc_orden_compra = p_orc_key_old;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END;

    PROCEDURE FAC_PROV_ELIMINAR(p_orc_key IN VARCHAR2) IS
    BEGIN
        DELETE FROM FAC_FACTURA_PROVEEDOR WHERE orc_orden_compra = p_orc_key;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END;

    PROCEDURE FAC_PROV_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT f.orc_orden_compra,
                   f.facpro_codigo_factura,
                   f.facpro_fecha,
                   o.orc_codigo
              FROM FAC_FACTURA_PROVEEDOR f
              JOIN BOD_ORDEN_COMPRA      o ON f.orc_orden_compra = o.orc_orden_compra
             ORDER BY f.facpro_fecha DESC;
    END;

    PROCEDURE FAC_PROV_BUSCAR(p_texto IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT f.orc_orden_compra,
                   f.facpro_codigo_factura,
                   f.facpro_fecha,
                   o.orc_codigo
              FROM FAC_FACTURA_PROVEEDOR f
              JOIN BOD_ORDEN_COMPRA      o ON f.orc_orden_compra = o.orc_orden_compra
             WHERE UPPER(f.facpro_codigo_factura) LIKE '%' || UPPER(p_texto) || '%'
                OR UPPER(o.orc_codigo)            LIKE '%' || UPPER(p_texto) || '%'
                OR UPPER(f.orc_orden_compra)      LIKE '%' || UPPER(p_texto) || '%'
             ORDER BY f.facpro_fecha DESC;
    END;

    -- Busca con filtros combinados.
    -- p_texto:       busca en codigo factura, orc_codigo y orc_orden_compra (NULL = ignorado)
    -- p_orc_key:     filtra por orden de compra exacta                      (NULL = ignorado)
    -- p_fecha_desde: limite inferior de facpro_fecha                        (NULL = ignorado)
    -- p_fecha_hasta: limite superior de facpro_fecha                        (NULL = ignorado)
    PROCEDURE FAC_PROV_BUSCAR_FILTRO(
        p_texto       IN VARCHAR2,
        p_orc_key     IN VARCHAR2,
        p_fecha_desde IN DATE,
        p_fecha_hasta IN DATE,
        p_data        OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_data FOR
            SELECT f.orc_orden_compra,
                   f.facpro_codigo_factura,
                   f.facpro_fecha,
                   o.orc_codigo
              FROM FAC_FACTURA_PROVEEDOR f
              JOIN BOD_ORDEN_COMPRA      o ON f.orc_orden_compra = o.orc_orden_compra
             WHERE (
                     p_texto IS NULL
                     OR UPPER(f.facpro_codigo_factura) LIKE '%' || UPPER(p_texto) || '%'
                     OR UPPER(o.orc_codigo)            LIKE '%' || UPPER(p_texto) || '%'
                     OR UPPER(f.orc_orden_compra)      LIKE '%' || UPPER(p_texto) || '%'
                   )
               AND (p_orc_key     IS NULL OR f.orc_orden_compra = p_orc_key)
               AND (p_fecha_desde IS NULL OR TRUNC(f.facpro_fecha) >= TRUNC(p_fecha_desde))
               AND (p_fecha_hasta IS NULL OR TRUNC(f.facpro_fecha) <= TRUNC(p_fecha_hasta))
             ORDER BY f.facpro_fecha DESC;
    END;

END PKG_CP_FAC_FACTURA_PROV;
/
