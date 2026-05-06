-- ============================================================
-- PKG_CP_FAC_FACTURA_PROV.pks
-- ============================================================
CREATE OR REPLACE PACKAGE PKG_CP_FAC_FACTURA_PROV AS

    -- Registra una nueva factura de proveedor
    PROCEDURE FAC_PROV_REGISTRAR(p_orc_key IN VARCHAR2, p_fac_cod IN VARCHAR2);

    -- Actualiza permitiendo cambiar la orden de compra asociada
    PROCEDURE FAC_PROV_ACTUALIZAR(
        p_orc_key_old IN VARCHAR2,
        p_orc_key_new IN VARCHAR2,
        p_fac_cod     IN VARCHAR2
    );

    -- Elimina una factura por clave de orden de compra
    PROCEDURE FAC_PROV_ELIMINAR(p_orc_key IN VARCHAR2);

    -- Lista todas las facturas ordenadas por fecha desc
    PROCEDURE FAC_PROV_LISTAR(p_data OUT SYS_REFCURSOR);

    -- Busca por texto libre (codigo factura u orc_codigo)
    PROCEDURE FAC_PROV_BUSCAR(p_texto IN VARCHAR2, p_data OUT SYS_REFCURSOR);

    -- Busca con filtros combinados: texto libre + orden de compra exacta + rango de fechas
    -- Cualquier parametro NULL se ignora
    PROCEDURE FAC_PROV_BUSCAR_FILTRO(
        p_texto       IN VARCHAR2,
        p_orc_key     IN VARCHAR2,
        p_fecha_desde IN DATE,
        p_fecha_hasta IN DATE,
        p_data        OUT SYS_REFCURSOR
    );

END PKG_CP_FAC_FACTURA_PROV;
/
