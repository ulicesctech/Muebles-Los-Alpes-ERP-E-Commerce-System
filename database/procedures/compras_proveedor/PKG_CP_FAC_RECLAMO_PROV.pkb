CREATE OR REPLACE PACKAGE BODY PKG_CP_FAC_RECLAMO_PROV AS

    PROCEDURE REC_PROV_CREAR(
        p_orc_key IN VARCHAR2, 
        p_coment  IN VARCHAR2, 
        p_id      OUT NUMBER
    ) IS
    BEGIN
        -- Se fuerza SYSDATE en inicio y NULL en final para nuevos registros
        INSERT INTO FAC_RECLAMO_PROVEEDOR (
            orc_orden_compra, 
            rep_comentarios, 
            rep_estado, 
            rep_fecha_inicio, 
            rep_fecha_final
        )
        VALUES (
            p_orc_key, 
            p_coment, 
            'INICIADO', 
            SYSDATE, 
            NULL
        )
        RETURNING rep_reclamo_proveedor INTO p_id;
        
        COMMIT;
    EXCEPTION 
        WHEN OTHERS THEN 
            ROLLBACK; 
            RAISE;
    END;

    PROCEDURE REC_PROV_ACTUALIZAR(p_id IN NUMBER, p_coment IN VARCHAR2) IS
    BEGIN
        UPDATE FAC_RECLAMO_PROVEEDOR 
        SET rep_comentarios = p_coment 
        WHERE rep_reclamo_proveedor = p_id;
        
        COMMIT;
    EXCEPTION 
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END;

    PROCEDURE REC_PROV_CAMBIAR_ESTADO(p_id IN NUMBER, p_estado IN VARCHAR2) IS
        v_estado_upper VARCHAR2(50);
    BEGIN
        v_estado_upper := UPPER(TRIM(p_estado));
        
        UPDATE FAC_RECLAMO_PROVEEDOR 
        SET rep_estado = v_estado_upper,
            -- Si el estado es de cierre, pone la fecha. Si se reabre, la quita.
            rep_fecha_final = CASE 
                WHEN v_estado_upper IN ('FINALIZADO', 'RESUELTO', 'RECHAZADO') THEN SYSDATE 
                ELSE NULL 
            END
        WHERE rep_reclamo_proveedor = p_id;
        
        COMMIT;
    EXCEPTION 
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END;

    PROCEDURE REC_PROV_ELIMINAR(p_id IN NUMBER) IS
    BEGIN
        DELETE FROM FAC_RECLAMO_PROVEEDOR WHERE rep_reclamo_proveedor = p_id;
        COMMIT;
    EXCEPTION 
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END;

    PROCEDURE REC_PROV_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN 
        OPEN p_data FOR 
            SELECT * FROM FAC_RECLAMO_PROVEEDOR 
            ORDER BY rep_fecha_inicio DESC; 
    END;

    PROCEDURE REC_PROV_LISTAR_ID(p_id IN NUMBER, p_data OUT SYS_REFCURSOR) IS
    BEGIN 
        OPEN p_data FOR 
            SELECT * FROM FAC_RECLAMO_PROVEEDOR 
            WHERE rep_reclamo_proveedor = p_id; 
    END;

END PKG_CP_FAC_RECLAMO_PROV;
/