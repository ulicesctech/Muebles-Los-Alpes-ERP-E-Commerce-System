CREATE OR REPLACE PACKAGE PKG_ADMIN_LOGIN_EMPLEADO AS

    -- Crear login de empleado
    PROCEDURE log_em_crear(
        p_em_empleado IN NUMBER,
        p_usuario     IN VARCHAR2,
        p_password    IN VARCHAR2
    );

    -- Actualizar password
    PROCEDURE log_em_actualizar_pass(
        p_em_empleado IN NUMBER,
        p_password    IN VARCHAR2
    );

    -- Actualizar usuario
    PROCEDURE log_em_actualizar_usuario(
        p_em_empleado IN NUMBER,
        p_usuario     IN VARCHAR2
    );

    -- Eliminar login
    PROCEDURE log_em_eliminar(p_em_empleado IN NUMBER);

    -- Validar login — retorna 1 si es válido, 0 si no
    PROCEDURE log_em_validar(
        p_usuario     IN  VARCHAR2,
        p_password    IN  VARCHAR2,
        p_resultado   OUT NUMBER,
        p_em_empleado OUT NUMBER
    );

    -- Listar todos
    PROCEDURE log_em_listar(p_cursor OUT SYS_REFCURSOR);

    -- Buscar por ID
    PROCEDURE log_em_buscar(
        p_em_empleado IN  NUMBER,
        p_cursor      OUT SYS_REFCURSOR
    );

END PKG_ADMIN_LOGIN_EMPLEADO;
/