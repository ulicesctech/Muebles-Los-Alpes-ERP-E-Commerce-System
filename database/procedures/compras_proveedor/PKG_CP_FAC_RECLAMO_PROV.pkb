CREATE OR REPLACE PACKAGE BODY PKG_CP_FAC_RECLAMO_PROV AS

    PROCEDURE REC_PROV_CREAR(
        p_orc_key     IN VARCHAR2,
        p_descripcion IN VARCHAR2,
        p_id          OUT NUMBER
    ) IS
    BEGIN
        INSERT INTO FAC_RECLAMO_PROVEEDOR (
            orc_orden_compra,
            rep_descripcion,
            rep_comentarios,
            rep_estado,
            rep_fecha_inicio,
            rep_fecha_final
        )
        VALUES (
            p_orc_key,
            TRIM(p_descripcion),
            NULL,
            'INICIADO',
            SYSDATE,
            NULL
        )
        RETURNING rep_reclamo_proveedor INTO p_id;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END;

    -- Actualiza descripcion — solo disponible cuando estado es INICIADO o PENDIENTE
    PROCEDURE REC_PROV_ACTUALIZAR(p_id IN NUMBER, p_descripcion IN VARCHAR2) IS
    BEGIN
        UPDATE FAC_RECLAMO_PROVEEDOR
           SET rep_descripcion = TRIM(p_descripcion)
         WHERE rep_reclamo_proveedor = p_id;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END;

    -- Actualiza solo comentarios — disponible cuando estado es RESUELTO o RECHAZADO
    PROCEDURE REC_PROV_ACTUALIZAR_COMENTARIOS(p_id IN NUMBER, p_coment IN VARCHAR2) IS
    BEGIN
        UPDATE FAC_RECLAMO_PROVEEDOR
           SET rep_comentarios = TRIM(p_coment)
         WHERE rep_reclamo_proveedor = p_id;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END;

    -- Cambia el estado con orden estricto — no se puede retroceder.
    -- Flujo: INICIADO(1) -> PENDIENTE(2) -> RESUELTO/RECHAZADO(3)
    -- Al llegar a nivel 3 guarda comentarios y fecha_final=SYSDATE.
    PROCEDURE REC_PROV_CAMBIAR_ESTADO(
        p_id     IN NUMBER,
        p_estado IN VARCHAR2,
        p_coment IN VARCHAR2
    ) IS
        v_estado_upper  VARCHAR2(50);
        v_estado_actual VARCHAR2(50);
        v_nivel_actual  NUMBER;
        v_nivel_nuevo   NUMBER;
    BEGIN
        v_estado_upper := UPPER(TRIM(p_estado));

        SELECT UPPER(TRIM(rep_estado))
          INTO v_estado_actual
          FROM FAC_RECLAMO_PROVEEDOR
         WHERE rep_reclamo_proveedor = p_id;

        SELECT CASE v_estado_actual
                   WHEN 'INICIADO'  THEN 1
                   WHEN 'PENDIENTE' THEN 2
                   WHEN 'RESUELTO'  THEN 3
                   WHEN 'RECHAZADO' THEN 3
                   ELSE 0
               END
          INTO v_nivel_actual FROM DUAL;

        SELECT CASE v_estado_upper
                   WHEN 'INICIADO'  THEN 1
                   WHEN 'PENDIENTE' THEN 2
                   WHEN 'RESUELTO'  THEN 3
                   WHEN 'RECHAZADO' THEN 3
                   ELSE 0
               END
          INTO v_nivel_nuevo FROM DUAL;

        IF v_nivel_nuevo <= v_nivel_actual THEN
            RAISE_APPLICATION_ERROR(-20070,
                'No se puede cambiar al estado ' || v_estado_upper ||
                '. El reclamo ya esta en ' || v_estado_actual ||
                ' y no puede retroceder.');
        END IF;

        IF v_nivel_nuevo = 3 THEN
            UPDATE FAC_RECLAMO_PROVEEDOR
               SET rep_estado      = v_estado_upper,
                   rep_comentarios = TRIM(p_coment),
                   rep_fecha_final = SYSDATE
             WHERE rep_reclamo_proveedor = p_id;
        ELSE
            UPDATE FAC_RECLAMO_PROVEEDOR
               SET rep_estado = v_estado_upper
             WHERE rep_reclamo_proveedor = p_id;
        END IF;

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
            SELECT rep_reclamo_proveedor,
                   orc_orden_compra,
                   rep_descripcion,
                   rep_comentarios,
                   rep_estado,
                   rep_fecha_inicio,
                   rep_fecha_final
              FROM FAC_RECLAMO_PROVEEDOR
             ORDER BY rep_fecha_inicio DESC;
    END;

    PROCEDURE REC_PROV_LISTAR_ID(p_id IN NUMBER, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT rep_reclamo_proveedor,
                   orc_orden_compra,
                   rep_descripcion,
                   rep_comentarios,
                   rep_estado,
                   rep_fecha_inicio,
                   rep_fecha_final
              FROM FAC_RECLAMO_PROVEEDOR
             WHERE rep_reclamo_proveedor = p_id;
    END;

    PROCEDURE REC_PROV_BUSCAR(
        p_texto       IN VARCHAR2,
        p_estado      IN VARCHAR2,
        p_fecha_desde IN DATE,
        p_fecha_hasta IN DATE,
        p_data        OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_data FOR
            SELECT rep_reclamo_proveedor,
                   orc_orden_compra,
                   rep_descripcion,
                   rep_comentarios,
                   rep_estado,
                   rep_fecha_inicio,
                   rep_fecha_final
              FROM FAC_RECLAMO_PROVEEDOR
             WHERE (
                     p_texto IS NULL
                     OR UPPER(orc_orden_compra)              LIKE '%' || UPPER(p_texto) || '%'
                     OR UPPER(rep_descripcion)               LIKE '%' || UPPER(p_texto) || '%'
                     OR UPPER(NVL(rep_comentarios, ''))      LIKE '%' || UPPER(p_texto) || '%'
                   )
               AND (p_estado IS NULL OR UPPER(rep_estado) = UPPER(TRIM(p_estado)))
               AND (p_fecha_desde IS NULL OR TRUNC(rep_fecha_inicio) >= TRUNC(p_fecha_desde))
               AND (p_fecha_hasta IS NULL OR TRUNC(rep_fecha_inicio) <= TRUNC(p_fecha_hasta))
             ORDER BY rep_fecha_inicio DESC;
    END;

    PROCEDURE REC_PROV_LISTAR_ESTADOS(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT 'TODOS'     AS estado, '— Todos los estados —' AS descripcion FROM DUAL UNION ALL
            SELECT 'INICIADO'  AS estado, 'INICIADO'              AS descripcion FROM DUAL UNION ALL
            SELECT 'PENDIENTE' AS estado, 'PENDIENTE'             AS descripcion FROM DUAL UNION ALL
            SELECT 'RESUELTO'  AS estado, 'RESUELTO'              AS descripcion FROM DUAL UNION ALL
            SELECT 'RECHAZADO' AS estado, 'RECHAZADO'             AS descripcion FROM DUAL;
    END;

    PROCEDURE REC_PROV_ES_CIERRE(p_estado IN VARCHAR2, p_resultado OUT NUMBER) IS
    BEGIN
        SELECT CASE
                   WHEN UPPER(TRIM(p_estado)) IN ('RESUELTO', 'RECHAZADO') THEN 1
                   ELSE 0
               END
          INTO p_resultado
          FROM DUAL;
    END;

END PKG_CP_FAC_RECLAMO_PROV;
/
