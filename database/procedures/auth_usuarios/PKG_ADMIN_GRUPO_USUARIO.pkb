CREATE OR REPLACE PACKAGE BODY PKG_ADMIN_GRUPO_USUARIO AS

    PROCEDURE assert_id(p_id IN NUMBER, p_msg IN VARCHAR2) IS
    BEGIN
        IF p_id IS NULL OR p_id <= 0 THEN
            RAISE_APPLICATION_ERROR(-20002, p_msg);
        END IF;
    END assert_id;

    PROCEDURE assert_permiso(p_permisos IN NUMBER) IS
        v_count NUMBER;
    BEGIN
        IF p_permisos IS NULL OR p_permisos <= 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'per_permisos obligatorio');
        END IF;
        SELECT COUNT(*) INTO v_count
        FROM ADMIN_PERMISOS WHERE per_permisos = p_permisos;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20005, 'Permiso ID ' || p_permisos || ' no existe');
        END IF;
    END assert_permiso;

    PROCEDURE gru_crear(
        p_descripcion IN VARCHAR2,
        p_permisos    IN NUMBER,
        p_id          OUT NUMBER
    ) IS
    BEGIN
        IF p_descripcion IS NULL OR TRIM(p_descripcion) = '' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Descripcion obligatoria');
        END IF;
        assert_permiso(p_permisos);
        INSERT INTO ADMIN_GRUPO_USUARIO (grupus_descripcion, per_permisos)
        VALUES (TRIM(p_descripcion), p_permisos)
        RETURNING grupus_grupo_usuario INTO p_id;
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20006, 'Ya existe un grupo con esa descripcion');
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END gru_crear;

    PROCEDURE gru_actualizar(
        p_id          IN NUMBER,
        p_descripcion IN VARCHAR2 DEFAULT NULL,
        p_permisos    IN NUMBER   DEFAULT NULL
    ) IS
        v_rows NUMBER;
    BEGIN
        assert_id(p_id, 'ID obligatorio');
        IF p_permisos IS NOT NULL THEN
            assert_permiso(p_permisos);
        END IF;
        UPDATE ADMIN_GRUPO_USUARIO SET
            grupus_descripcion = NVL(TRIM(p_descripcion), grupus_descripcion),
            per_permisos       = NVL(p_permisos, per_permisos)
        WHERE grupus_grupo_usuario = p_id;
        v_rows := SQL%ROWCOUNT;
        IF v_rows = 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Grupo no encontrado');
        END IF;
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20006, 'Ya existe un grupo con esa descripcion');
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END gru_actualizar;

    PROCEDURE gru_eliminar(p_id IN NUMBER) IS
        v_rows NUMBER;
    BEGIN
        assert_id(p_id, 'ID obligatorio');
        DELETE FROM ADMIN_GRUPO_USUARIO WHERE grupus_grupo_usuario = p_id;
        v_rows := SQL%ROWCOUNT;
        IF v_rows = 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Grupo no encontrado');
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END gru_eliminar;

    PROCEDURE gru_listar(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT grupus_grupo_usuario, grupus_descripcion, per_permisos
            FROM ADMIN_GRUPO_USUARIO
            ORDER BY grupus_grupo_usuario;
    END gru_listar;

    PROCEDURE gru_buscar(
        p_id     IN  NUMBER,
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        assert_id(p_id, 'ID obligatorio');
        OPEN p_cursor FOR
            SELECT grupus_grupo_usuario, grupus_descripcion, per_permisos
            FROM ADMIN_GRUPO_USUARIO
            WHERE grupus_grupo_usuario = p_id;
    END gru_buscar;

END PKG_ADMIN_GRUPO_USUARIO;
/