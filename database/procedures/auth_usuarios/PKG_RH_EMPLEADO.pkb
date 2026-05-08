CREATE OR REPLACE PACKAGE BODY PKG_RH_EMPLEADO AS

    PROCEDURE assert_not_null(p_val IN VARCHAR2, p_msg IN VARCHAR2) IS
    BEGIN
        IF TRIM(p_val) IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, p_msg);
        END IF;
    END assert_not_null;

    PROCEDURE assert_id(p_id IN NUMBER, p_msg IN VARCHAR2) IS
    BEGIN
        IF p_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, p_msg);
        END IF;
    END assert_id;

    PROCEDURE emp_crear(
        p_dpi   IN VARCHAR2, p_p_nom IN VARCHAR2, p_s_nom IN VARCHAR2,
        p_p_ape IN VARCHAR2, p_s_ape IN VARCHAR2, p_dir   IN VARCHAR2,
        p_ave   IN VARCHAR2, p_cp    IN VARCHAR2, p_tel1  IN VARCHAR2,
        p_tel2  IN VARCHAR2, p_rol   IN NUMBER,   p_id    OUT NUMBER
    ) IS
    BEGIN
        assert_not_null(p_dpi,   'Empleado: DPI obligatorio.');
        assert_not_null(p_p_nom, 'Empleado: Primer nombre obligatorio.');
        assert_id(p_rol,         'Empleado: Rol obligatorio.');
        INSERT INTO RH_EMPLEADO (
            em_DPI, em_primer_nombre, em_segundo_nombre,
            em_primer_apellido, em_segundo_apellido,
            em_direccion, em_avenida, em_codigo_postal,
            em_primer_telefono, em_segundo_telefono,
            rolus_rol_usuario
        ) VALUES (
            TRIM(p_dpi), TRIM(p_p_nom), NVL(TRIM(p_s_nom), ' '),
            TRIM(p_p_ape), NVL(TRIM(p_s_ape), ' '),
            TRIM(p_dir), TRIM(p_ave), TRIM(p_cp),
            TRIM(p_tel1), NVL(TRIM(p_tel2), ' '),
            p_rol
        ) RETURNING em_empleado INTO p_id;
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20006, 'DPI ya registrado');
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END emp_crear;

    PROCEDURE emp_actualizar(
        p_id    IN NUMBER,  p_dpi   IN VARCHAR2, p_p_nom IN VARCHAR2,
        p_s_nom IN VARCHAR2, p_p_ape IN VARCHAR2, p_s_ape IN VARCHAR2,
        p_dir   IN VARCHAR2, p_ave   IN VARCHAR2, p_cp    IN VARCHAR2,
        p_tel1  IN VARCHAR2, p_tel2  IN VARCHAR2, p_rol   IN NUMBER
    ) IS
    BEGIN
        assert_id(p_id, 'Empleado: ID obligatorio.');
        UPDATE RH_EMPLEADO SET
            em_DPI              = TRIM(p_dpi),
            em_primer_nombre    = TRIM(p_p_nom),
            em_segundo_nombre   = NVL(TRIM(p_s_nom), ' '),
            em_primer_apellido  = TRIM(p_p_ape),
            em_segundo_apellido = NVL(TRIM(p_s_ape), ' '),
            em_direccion        = TRIM(p_dir),
            em_avenida          = TRIM(p_ave),
            em_codigo_postal    = TRIM(p_cp),
            em_primer_telefono  = TRIM(p_tel1),
            em_segundo_telefono = NVL(TRIM(p_tel2), ' '),
            rolus_rol_usuario   = p_rol
        WHERE em_empleado = p_id;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END emp_actualizar;

    PROCEDURE emp_eliminar(p_id IN NUMBER) IS
    BEGIN
        DELETE FROM RH_ASCENSO          WHERE em_empleado = p_id;
        DELETE FROM ADMIN_LOGIN_EMPLEADO WHERE em_empleado = p_id;
        DELETE FROM RH_EMPLEADO          WHERE em_empleado = p_id;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END emp_eliminar;

    PROCEDURE emp_listar(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR
            SELECT e.*, g.grupus_descripcion AS rol_nombre
              FROM RH_EMPLEADO e
              JOIN ADMIN_GRUPO_USUARIO g ON e.rolus_rol_usuario = g.grupus_grupo_usuario;
    END emp_listar;

    PROCEDURE emp_obtener_admin(p_id OUT NUMBER) IS
    BEGIN
        SELECT MIN(em_empleado) INTO p_id FROM RH_EMPLEADO;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_id := NULL;
    END emp_obtener_admin;

END PKG_RH_EMPLEADO;
/