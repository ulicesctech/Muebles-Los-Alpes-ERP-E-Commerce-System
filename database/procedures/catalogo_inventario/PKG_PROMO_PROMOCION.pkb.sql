CREATE OR REPLACE PACKAGE BODY PKG_PROMO_PROMOCION AS

    -- ============================================================
    -- CAMPANA — MAESTRO
    -- ============================================================
    PROCEDURE CAMPANA_CREAR(
        p_nombre       IN VARCHAR2,
        p_descripcion  IN VARCHAR2,
        p_fecha_inicio IN DATE,
        p_fecha_final  IN DATE,
        p_id_out       OUT NUMBER
    ) IS
    BEGIN
        IF TRIM(p_nombre) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'PROMO_CAMPANA: nombre obligatorio.');
        END IF;
        IF p_fecha_inicio IS NULL OR p_fecha_final IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, 'PROMO_CAMPANA: fechas obligatorias.');
        END IF;
        IF p_fecha_inicio > p_fecha_final THEN
            RAISE_APPLICATION_ERROR(-20003, 'PROMO_CAMPANA: fecha_inicio no puede ser mayor a fecha_final.');
        END IF;
        INSERT INTO PROMO_CAMPANA(camp_nombre, camp_descripcion, camp_estado, camp_fecha_inicio, camp_fecha_final)
        VALUES(TRIM(p_nombre), TRIM(p_descripcion), 'PENDIENTE', p_fecha_inicio, p_fecha_final)
        RETURNING camp_campana INTO p_id_out;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END CAMPANA_CREAR;

    PROCEDURE CAMPANA_ACTUALIZAR(
        p_id           IN NUMBER,
        p_nombre       IN VARCHAR2,
        p_descripcion  IN VARCHAR2,
        p_estado       IN VARCHAR2,
        p_fecha_inicio IN DATE,
        p_fecha_final  IN DATE
    ) IS
    BEGIN
        IF p_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20004, 'PROMO_CAMPANA: id obligatorio.');
        END IF;
        IF p_estado NOT IN ('ACTIVA','INACTIVA','PENDIENTE') THEN
            RAISE_APPLICATION_ERROR(-20005, 'PROMO_CAMPANA: estado invalido.');
        END IF;
        UPDATE PROMO_CAMPANA SET
            camp_nombre       = TRIM(p_nombre),
            camp_descripcion  = TRIM(p_descripcion),
            camp_estado       = p_estado,
            camp_fecha_inicio = p_fecha_inicio,
            camp_fecha_final  = p_fecha_final
        WHERE camp_campana = p_id;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END CAMPANA_ACTUALIZAR;

    PROCEDURE CAMPANA_ELIMINAR(p_id IN NUMBER) IS
    BEGIN
        IF p_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20006, 'PROMO_CAMPANA: id obligatorio.');
        END IF;
        DELETE FROM PROMO_PROMOCION WHERE camp_campana = p_id;
        DELETE FROM PROMO_CAMPANA   WHERE camp_campana = p_id;
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20007, 'PROMO_CAMPANA: no existe.');
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END CAMPANA_ELIMINAR;

    PROCEDURE CAMPANA_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT c.camp_campana, c.camp_nombre, c.camp_descripcion,
                   c.camp_estado, c.camp_fecha_inicio, c.camp_fecha_final,
                   COUNT(p.prom_promocion) AS total_productos
              FROM PROMO_CAMPANA c
              LEFT JOIN PROMO_PROMOCION p ON p.camp_campana = c.camp_campana
             GROUP BY c.camp_campana, c.camp_nombre, c.camp_descripcion,
                      c.camp_estado, c.camp_fecha_inicio, c.camp_fecha_final
             ORDER BY c.camp_fecha_inicio DESC;
    END CAMPANA_LISTAR;

    PROCEDURE CAMPANA_BUSCAR(p_id IN NUMBER, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        IF p_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20008, 'PROMO_CAMPANA: id obligatorio.');
        END IF;
        OPEN p_data FOR
            SELECT c.camp_campana, c.camp_nombre, c.camp_descripcion,
                   c.camp_estado, c.camp_fecha_inicio, c.camp_fecha_final
              FROM PROMO_CAMPANA c
             WHERE c.camp_campana = p_id;
    END CAMPANA_BUSCAR;

    -- ============================================================
    -- PROMOCION — DETALLE
    -- ============================================================
    PROCEDURE CREAR(
        p_camp_campana   IN NUMBER,
        p_pro_referencia IN VARCHAR2,
        p_porcentaje     IN NUMBER,
        p_id_out         OUT NUMBER
    ) IS
        v_ref VARCHAR2(40);
    BEGIN
        v_ref := TRIM(p_pro_referencia);
        IF p_camp_campana IS NULL THEN
            RAISE_APPLICATION_ERROR(-20010, 'PROMO_PROMOCION: campana obligatoria.');
        END IF;
        IF v_ref IS NULL THEN
            RAISE_APPLICATION_ERROR(-20011, 'PROMO_PROMOCION: referencia obligatoria.');
        END IF;
        IF p_porcentaje IS NULL OR p_porcentaje <= 0 OR p_porcentaje > 100 THEN
            RAISE_APPLICATION_ERROR(-20012, 'PROMO_PROMOCION: porcentaje debe ser >0 y <=100.');
        END IF;
        INSERT INTO PROMO_PROMOCION(camp_campana, pro_referencia, prom_porcentaje)
        VALUES(p_camp_campana, v_ref, p_porcentaje)
        RETURNING prom_promocion INTO p_id_out;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END CREAR;

    PROCEDURE ELIMINAR(p_id IN NUMBER) IS
    BEGIN
        IF p_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20013, 'PROMO_PROMOCION: id obligatorio.');
        END IF;
        DELETE FROM PROMO_PROMOCION WHERE prom_promocion = p_id;
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20014, 'PROMO_PROMOCION: no existe.');
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END ELIMINAR;

    PROCEDURE LISTAR_POR_CAMPANA(p_camp_campana IN NUMBER, p_data OUT SYS_REFCURSOR) IS
    BEGIN
        IF p_camp_campana IS NULL THEN
            RAISE_APPLICATION_ERROR(-20015, 'PROMO_PROMOCION: campana obligatoria.');
        END IF;
        OPEN p_data FOR
            SELECT p.prom_promocion, p.camp_campana, p.pro_referencia,
                   pr.pro_nombre, p.prom_porcentaje
              FROM PROMO_PROMOCION p
              JOIN BOD_PRODUCTO    pr ON pr.pro_referencia = p.pro_referencia
             WHERE p.camp_campana = p_camp_campana
             ORDER BY pr.pro_nombre;
    END LISTAR_POR_CAMPANA;

    PROCEDURE LISTAR_POR_PRODUCTO(p_pro_referencia IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
        v_ref VARCHAR2(40);
    BEGIN
        v_ref := TRIM(p_pro_referencia);
        IF v_ref IS NULL THEN
            RAISE_APPLICATION_ERROR(-20016, 'PROMO_PROMOCION: referencia obligatoria.');
        END IF;
        OPEN p_data FOR
            SELECT p.prom_promocion, p.pro_referencia, p.prom_porcentaje,
                   c.camp_nombre, c.camp_estado,
                   c.camp_fecha_inicio, c.camp_fecha_final
              FROM PROMO_PROMOCION p
              JOIN PROMO_CAMPANA   c ON c.camp_campana = p.camp_campana
             WHERE p.pro_referencia = v_ref
             ORDER BY c.camp_fecha_inicio DESC;
    END LISTAR_POR_PRODUCTO;

    PROCEDURE VIGENTE(p_pro_referencia IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
        v_ref VARCHAR2(40);
    BEGIN
        v_ref := TRIM(p_pro_referencia);
        IF v_ref IS NULL THEN
            RAISE_APPLICATION_ERROR(-20017, 'PROMO_PROMOCION: referencia obligatoria.');
        END IF;
        OPEN p_data FOR
            SELECT p.prom_promocion, p.pro_referencia, p.prom_porcentaje,
                   c.camp_nombre, c.camp_estado,
                   c.camp_fecha_inicio, c.camp_fecha_final
              FROM PROMO_PROMOCION p
              JOIN PROMO_CAMPANA   c ON c.camp_campana = p.camp_campana
             WHERE p.pro_referencia = v_ref
               AND c.camp_estado    = 'ACTIVA'
             ORDER BY p.prom_promocion DESC
             FETCH FIRST 1 ROWS ONLY;
    END VIGENTE;

END PKG_PROMO_PROMOCION;
/