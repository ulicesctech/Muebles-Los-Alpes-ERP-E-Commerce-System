CREATE OR REPLACE PACKAGE BODY PKG_RH_ASCENSO AS

    PROCEDURE assert_id(p_id IN NUMBER, p_msg IN VARCHAR2) IS
    BEGIN
        IF p_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, p_msg);
        END IF;
    END assert_id;

    PROCEDURE ascen_crear(
        p_id_puesto   IN  NUMBER,
        p_id_empleado IN  NUMBER,
        p_id          OUT NUMBER
    ) IS
    BEGIN
        assert_id(p_id_puesto,   'Ascenso: Puesto obligatorio.');
        assert_id(p_id_empleado, 'Ascenso: Empleado obligatorio.');

        UPDATE RH_ASCENSO SET asc_fecha_final = SYSDATE
        WHERE em_empleado = p_id_empleado AND asc_fecha_final IS NULL;

        INSERT INTO RH_ASCENSO (pue_puestos, em_empleado, asc_fecha_inicio)
        VALUES (p_id_puesto, p_id_empleado, SYSDATE)
        RETURNING asc_ascenso INTO p_id;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END ascen_crear;

    PROCEDURE ascen_cerrar(p_id_ascenso IN NUMBER) IS
    BEGIN
        UPDATE RH_ASCENSO SET asc_fecha_final = SYSDATE
        WHERE asc_ascenso = p_id_ascenso;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END ascen_cerrar;

    PROCEDURE ascen_eliminar(p_id_ascenso IN NUMBER) IS
    BEGIN
        DELETE FROM RH_ASCENSO WHERE asc_ascenso = p_id_ascenso;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END ascen_eliminar;

    PROCEDURE ascen_listar_por_emp(
        p_id_empleado IN  NUMBER,
        p_data        OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_data FOR
            SELECT a.asc_ascenso, a.em_empleado, a.pue_puestos,
                   p.pue_nombre, a.asc_fecha_inicio, a.asc_fecha_final
            FROM RH_ASCENSO a
            JOIN RH_PUESTO p ON a.pue_puestos = p.pue_puestos
            WHERE a.em_empleado = p_id_empleado
            ORDER BY a.asc_fecha_inicio DESC;
    END ascen_listar_por_emp;

END PKG_RH_ASCENSO;
/