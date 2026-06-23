CREATE OR REPLACE PACKAGE BODY PKG_RH_PUESTO AS

    PROCEDURE pue_crear(
        p_pue_nombre      IN  VARCHAR2,
        p_pue_salario     IN  NUMBER,
        p_pue_descripcion IN  VARCHAR2,
        p_nuevo_id        OUT NUMBER
    ) IS
    BEGIN
        IF p_pue_salario <= 0 THEN
            RAISE_APPLICATION_ERROR(-20100, 'Salario debe ser > 0');
        END IF;
        INSERT INTO RH_PUESTO (pue_nombre, pue_salario, pue_descripcion)
        VALUES (TRIM(p_pue_nombre), p_pue_salario, TRIM(p_pue_descripcion))
        RETURNING pue_puestos INTO p_nuevo_id;
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20101, 'Puesto ya existe');
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END pue_crear;

    PROCEDURE pue_actualizar(
        p_pue_puestos     IN NUMBER,
        p_pue_nombre      IN VARCHAR2,
        p_pue_salario     IN NUMBER,
        p_pue_descripcion IN VARCHAR2
    ) IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM RH_PUESTO WHERE pue_puestos = p_pue_puestos;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20102, 'Puesto no existe');
        END IF;
        UPDATE RH_PUESTO SET
            pue_nombre      = TRIM(p_pue_nombre),
            pue_salario     = p_pue_salario,
            pue_descripcion = TRIM(p_pue_descripcion)
        WHERE pue_puestos = p_pue_puestos;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END pue_actualizar;

    PROCEDURE pue_eliminar(p_pue_puestos IN NUMBER) IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM RH_ASCENSO WHERE pue_puestos = p_pue_puestos;
        IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20103, 'Puesto en uso por ascensos');
        END IF;
        DELETE FROM RH_PUESTO WHERE pue_puestos = p_pue_puestos;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END pue_eliminar;

    PROCEDURE pue_listar(
        p_pue_puestos IN  NUMBER DEFAULT NULL,
        p_data        OUT SYS_REFCURSOR
    ) IS
    BEGIN
        IF p_pue_puestos IS NULL THEN
            OPEN p_data FOR SELECT * FROM RH_PUESTO ORDER BY pue_nombre;
        ELSE
            OPEN p_data FOR SELECT * FROM RH_PUESTO WHERE pue_puestos = p_pue_puestos;
        END IF;
    END pue_listar;

    PROCEDURE pue_obtener(
        p_pue_puestos IN  NUMBER,
        p_data        OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_data FOR SELECT * FROM RH_PUESTO WHERE pue_puestos = p_pue_puestos;
    END pue_obtener;

END PKG_RH_PUESTO;
/