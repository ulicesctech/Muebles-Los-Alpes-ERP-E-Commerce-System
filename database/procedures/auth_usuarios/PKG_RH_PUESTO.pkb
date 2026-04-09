CREATE OR REPLACE PACKAGE BODY PKG_RH_PUESTO AS

    PROCEDURE PUE_CREAR(p_pue_nombre VARCHAR2, p_pue_salario NUMBER, p_pue_descripcion VARCHAR2, p_nuevo_id OUT NUMBER) IS
    BEGIN
        IF p_pue_salario <= 0 THEN RAISE_APPLICATION_ERROR(-20100, 'Salario debe ser > 0'); END IF;
        
        INSERT INTO RH_PUESTO (pue_nombre, pue_salario, pue_descripcion)
        VALUES (TRIM(p_pue_nombre), p_pue_salario, TRIM(p_pue_descripcion))
        RETURNING pue_puestos INTO p_nuevo_id;
        
        COMMIT;
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN RAISE_APPLICATION_ERROR(-20101, 'Puesto ya existe'); END;

    PROCEDURE PUE_ACTUALIZAR(p_pue_puestos NUMBER, p_pue_nombre VARCHAR2, p_pue_salario NUMBER, p_pue_descripcion VARCHAR2) IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM RH_PUESTO WHERE pue_puestos = p_pue_puestos;
        IF v_count = 0 THEN RAISE_APPLICATION_ERROR(-20102, 'Puesto no existe'); END IF;
        
        UPDATE RH_PUESTO SET
            pue_nombre = TRIM(p_pue_nombre),
            pue_salario = p_pue_salario,
            pue_descripcion = TRIM(p_pue_descripcion)
        WHERE pue_puestos = p_pue_puestos;
        COMMIT;
    END;

    PROCEDURE PUE_ELIMINAR(p_pue_puestos NUMBER) IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM RH_ASCENSO WHERE pue_puestos = p_pue_puestos;
        IF v_count > 0 THEN RAISE_APPLICATION_ERROR(-20103, 'Puesto en uso por ascensos'); END IF;
        
        DELETE FROM RH_PUESTO WHERE pue_puestos = p_pue_puestos;
        COMMIT;
    END;

    FUNCTION PUE_LISTAR(p_pue_puestos NUMBER DEFAULT NULL) RETURN t_cursor_puesto IS
        v_cur t_cursor_puesto;
    BEGIN
        IF p_pue_puestos IS NULL THEN
            OPEN v_cur FOR SELECT * FROM RH_PUESTO ORDER BY pue_nombre;
        ELSE
            OPEN v_cur FOR SELECT * FROM RH_PUESTO WHERE pue_puestos = p_pue_puestos;
        END IF;
        RETURN v_cur;
    END;

    FUNCTION PUE_OBTENER(p_pue_puestos NUMBER) RETURN t_puesto_rec IS
        v_rec t_puesto_rec;
    BEGIN
        SELECT * INTO v_rec FROM RH_PUESTO WHERE pue_puestos = p_pue_puestos;
        RETURN v_rec;
    EXCEPTION WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR(-20104, 'Puesto no encontrado'); END;

END PKG_RH_PUESTO;
/