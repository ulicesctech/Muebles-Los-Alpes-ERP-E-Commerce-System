CREATE OR REPLACE PACKAGE BODY PKG_ADMIN_LOGIN_EMPLEADO AS
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

    PROCEDURE LOGE_CREAR(p_id_empleado IN NUMBER, p_usuario IN VARCHAR2, p_password IN VARCHAR2) IS
    BEGIN
        assert_id(p_id_empleado, 'Login Emp: Empleado obligatorio.');
        assert_not_null(p_usuario, 'Login Emp: Usuario obligatorio.');
        INSERT INTO ADMIN_LOGIN_EMPLEADO (em_empleado, logem_usuario, logem_password) VALUES (p_id_empleado, TRIM(p_usuario), TRIM(p_password));
    END;

    PROCEDURE LOGE_ACTUALIZAR_PWD(p_id_empleado IN NUMBER, p_password IN VARCHAR2) IS
    BEGIN
        UPDATE ADMIN_LOGIN_EMPLEADO 
        SET logem_password = TRIM(p_password) WHERE em_empleado = p_id_empleado;
    END;

    PROCEDURE LOGE_ELIMINAR(p_id_empleado IN NUMBER) IS
    BEGIN
        DELETE FROM ADMIN_LOGIN_EMPLEADO WHERE em_empleado = p_id_empleado;
    END;

    PROCEDURE LOGE_AUTENTICAR(p_usuario IN VARCHAR2, p_password IN VARCHAR2, p_id_empleado OUT NUMBER, p_rol OUT VARCHAR2) IS
    BEGIN
        BEGIN
            SELECT l.em_empleado, g.grupus_descripcion INTO p_id_empleado, p_rol
            FROM ADMIN_LOGIN_EMPLEADO l JOIN RH_EMPLEADO e ON l.em_empleado = e.em_empleado
            JOIN ADMIN_GRUPO_USUARIO g ON e.rolus_rol_usuario = g.grupus_grupo_usuario
            WHERE l.logem_usuario = TRIM(p_usuario) AND l.logem_password = TRIM(p_password);
            EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20006, 'Credenciales incorrectas.');
        END;
    END;
END PKG_ADMIN_LOGIN_EMPLEADO;
/