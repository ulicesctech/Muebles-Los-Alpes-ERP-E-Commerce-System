CREATE OR REPLACE PACKAGE BODY PKG_ADMIN_LOGIN_EMPLEADO AS

    PROCEDURE assert_id(p_id IN NUMBER, p_msg IN VARCHAR2) IS
    BEGIN
        IF p_id IS NULL OR p_id <= 0 THEN
            RAISE_APPLICATION_ERROR(-20002, p_msg);
        END IF;
    END assert_id;

    PROCEDURE assert_empleado(p_em_empleado IN NUMBER) IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM RH_EMPLEADO WHERE em_empleado = p_em_empleado;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20007, 'Empleado ID ' || p_em_empleado || ' no existe');
        END IF;
    END assert_empleado;

    PROCEDURE log_em_crear(
        p_em_empleado IN NUMBER,
        p_usuario     IN VARCHAR2,
        p_password    IN VARCHAR2
    ) IS
    BEGIN
        assert_id(p_em_empleado, 'ID de empleado obligatorio');
        assert_empleado(p_em_empleado);
        IF p_usuario IS NULL OR TRIM(p_usuario) = '' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Usuario obligatorio');
        END IF;
        IF p_password IS NULL OR TRIM(p_password) = '' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Password obligatorio');
        END IF;
        INSERT INTO ADMIN_LOGIN_EMPLEADO (em_empleado, logem_usuario, logem_password)
        VALUES (p_em_empleado, TRIM(p_usuario), p_password);
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20006, 'Usuario ya existe');
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END log_em_crear;

    PROCEDURE log_em_actualizar_pass(
        p_em_empleado IN NUMBER,
        p_password    IN VARCHAR2
    ) IS
        v_rows NUMBER;
    BEGIN
        assert_id(p_em_empleado, 'ID de empleado obligatorio');
        IF p_password IS NULL OR TRIM(p_password) = '' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Password obligatorio');
        END IF;
        UPDATE ADMIN_LOGIN_EMPLEADO SET logem_password = p_password
        WHERE em_empleado = p_em_empleado;
        v_rows := SQL%ROWCOUNT;
        IF v_rows = 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Login no encontrado: ' || p_em_empleado);
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END log_em_actualizar_pass;

    PROCEDURE log_em_actualizar_usuario(
        p_em_empleado IN NUMBER,
        p_usuario     IN VARCHAR2
    ) IS
        v_rows NUMBER;
    BEGIN
        assert_id(p_em_empleado, 'ID de empleado obligatorio');
        IF p_usuario IS NULL OR TRIM(p_usuario) = '' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Usuario obligatorio');
        END IF;
        UPDATE ADMIN_LOGIN_EMPLEADO SET logem_usuario = TRIM(p_usuario)
        WHERE em_empleado = p_em_empleado;
        v_rows := SQL%ROWCOUNT;
        IF v_rows = 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Login no encontrado: ' || p_em_empleado);
        END IF;
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20006, 'Usuario ya existe');
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END log_em_actualizar_usuario;

    PROCEDURE log_em_eliminar(p_em_empleado IN NUMBER) IS
        v_rows NUMBER;
    BEGIN
        assert_id(p_em_empleado, 'ID de empleado obligatorio');
        DELETE FROM ADMIN_LOGIN_EMPLEADO WHERE em_empleado = p_em_empleado;
        v_rows := SQL%ROWCOUNT;
        IF v_rows = 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Login no encontrado: ' || p_em_empleado);
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END log_em_eliminar;

    PROCEDURE log_em_validar(
        p_usuario     IN  VARCHAR2,
        p_password    IN  VARCHAR2,
        p_resultado   OUT NUMBER,
        p_em_empleado OUT NUMBER
    ) IS
        v_em NUMBER;
    BEGIN
        SELECT em_empleado INTO v_em
        FROM ADMIN_LOGIN_EMPLEADO
        WHERE logem_usuario  = TRIM(p_usuario)
        AND   logem_password = p_password;
        p_resultado   := 1;
        p_em_empleado := v_em;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_resultado   := 0;
            p_em_empleado := NULL;
    END log_em_validar;

    PROCEDURE log_em_listar(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT l.em_empleado, l.logem_usuario,
                   e.em_primer_nombre || ' ' || e.em_primer_apellido AS em_nombre_completo
            FROM ADMIN_LOGIN_EMPLEADO l
            JOIN RH_EMPLEADO e ON e.em_empleado = l.em_empleado
            ORDER BY l.em_empleado;
    END log_em_listar;

    PROCEDURE log_em_buscar(
        p_em_empleado IN  NUMBER,
        p_cursor      OUT SYS_REFCURSOR
    ) IS
    BEGIN
        assert_id(p_em_empleado, 'ID de empleado obligatorio');
        OPEN p_cursor FOR
            SELECT l.em_empleado, l.logem_usuario,
                   e.em_primer_nombre || ' ' || e.em_primer_apellido AS em_nombre_completo
            FROM ADMIN_LOGIN_EMPLEADO l
            JOIN RH_EMPLEADO e ON e.em_empleado = l.em_empleado
            WHERE l.em_empleado = p_em_empleado;
    END log_em_buscar;

END PKG_ADMIN_LOGIN_EMPLEADO;
/