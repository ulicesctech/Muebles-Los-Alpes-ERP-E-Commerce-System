CREATE OR REPLACE PACKAGE BODY PKG_RH_EMPLEADO AS
    PROCEDURE assert_not_null(p_val IN VARCHAR2, p_msg IN VARCHAR2) IS 
    BEGIN 
        IF TRIM(p_val) IS NULL 
        THEN RAISE_APPLICATION_ERROR(-20001, p_msg); 
        END IF; 
    END;

    PROCEDURE assert_id(p_id IN NUMBER, p_msg IN VARCHAR2) IS 
    BEGIN 
        IF p_id IS NULL 
        THEN RAISE_APPLICATION_ERROR(-20002, p_msg); 
        END IF; 
    END;

    PROCEDURE EMP_CREAR(
        p_dpi IN VARCHAR2, 
        p_p_nom IN VARCHAR2, 
        p_s_nom IN VARCHAR2, 
        p_p_ape IN VARCHAR2, 
        p_s_ape IN VARCHAR2, 
        p_dir IN VARCHAR2, 
        p_ave IN VARCHAR2, 
        p_cp IN VARCHAR2, 
        p_tel1 IN VARCHAR2, 
        p_tel2 IN VARCHAR2, 
        p_rol IN NUMBER, 
        p_id OUT NUMBER) IS
    BEGIN
    assert_not_null(p_dpi, 'Empleado: DPI obligatorio.');
    assert_not_null(p_p_nom, 'Empleado: Primer nombre obligatorio.');
    assert_id(p_rol, 'Empleado: Rol obligatorio.');

    INSERT INTO RH_EMPLEADO (
        em_DPI, 
        em_primer_nombre, 
        em_segundo_nombre, 
        em_primer_apellido, 
        em_segundo_apellido, 
        em_direccion, em_avenida, 
        em_codigo_postal, 
        em_primer_telefono, 
        em_segundo_telefono, 
        rolus_rol_usuario)
        VALUES (
            TRIM(p_dpi), 
            TRIM(p_p_nom), 
            TRIM(p_s_nom), 
            TRIM(p_p_ape), 
            TRIM(p_s_ape), 
            TRIM(p_dir), 
            TRIM(p_ave), 
            TRIM(p_cp), 
            TRIM(p_tel1), 
            TRIM(p_tel2), 
            p_rol)
        RETURNING em_empleado INTO p_id;
    END;

    PROCEDURE EMP_ACTUALIZAR(
        p_id IN NUMBER, 
        p_dpi IN VARCHAR2, 
        p_p_nom IN VARCHAR2, 
        p_s_nom IN VARCHAR2, 
        p_p_ape IN VARCHAR2, 
        p_s_ape IN VARCHAR2, 
        p_dir IN VARCHAR2, 
        p_ave IN VARCHAR2, 
        p_cp IN VARCHAR2, 
        p_tel1 IN VARCHAR2, 
        p_tel2 IN VARCHAR2, 
        p_rol IN NUMBER) IS
    BEGIN
        assert_id(p_id, 'Empleado: ID obligatorio.');
        UPDATE RH_EMPLEADO 
            SET 
                em_DPI = TRIM(p_dpi), 
                em_primer_nombre = TRIM(p_p_nom), 
                em_segundo_nombre = TRIM(p_s_nom), 
                em_primer_apellido = TRIM(p_p_ape), 
                em_segundo_apellido = TRIM(p_s_ape), 
                em_direccion = TRIM(p_dir), 
                em_avenida = TRIM(p_ave), 
                em_codigo_postal = TRIM(p_cp), 
                em_primer_telefono = TRIM(p_tel1), 
                em_segundo_telefono = TRIM(p_tel2), 
                rolus_rol_usuario = p_rol
        WHERE em_empleado = p_id;
    END;

    PROCEDURE EMP_ELIMINAR(p_id IN NUMBER) IS 
    BEGIN 
        DELETE FROM RH_EMPLEADO 
        WHERE em_empleado = p_id; 
    END;

    PROCEDURE EMP_LISTAR(p_data OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_data FOR SELECT e.*, g.grupus_descripcion AS rol_nombre 
        FROM RH_EMPLEADO e JOIN ADMIN_GRUPO_USUARIO g ON e.rolus_rol_usuario = g.grupus_grupo_usuario;
    END;
END PKG_RH_EMPLEADO;
/