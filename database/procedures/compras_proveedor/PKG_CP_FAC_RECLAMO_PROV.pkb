CREATE OR REPLACE PACKAGE BODY PKG_CP_FAC_RECLAMO_PROV AS
    PROCEDURE REC_PROV_CREAR(p_orc_key IN VARCHAR2, p_coment IN VARCHAR2, p_estado IN VARCHAR2, p_id OUT NUMBER) IS
    BEGIN
        INSERT INTO FAC_RECLAMO_PROVEEDOR(orc_orden_compra, rep_comentarios, rep_estado, rep_fecha_inicio)
        VALUES (p_orc_key, p_coment, p_estado, SYSDATE)
        RETURNING rep_reclamo_proveedor INTO p_id;
    END;

    PROCEDURE REC_PROV_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN OPEN p_data FOR SELECT * FROM FAC_RECLAMO_PROVEEDOR ORDER BY rep_fecha_inicio DESC; END;
END PKG_CP_FAC_RECLAMO_PROV;
/