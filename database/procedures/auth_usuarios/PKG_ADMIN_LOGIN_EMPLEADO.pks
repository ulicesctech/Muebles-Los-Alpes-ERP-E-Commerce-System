CREATE OR REPLACE PACKAGE PKG_ADMIN_LOGIN_EMPLEADO AS
    PROCEDURE log_em_crear(
        p_em_empleado IN NUMBER,
        p_usuario     IN VARCHAR2,
        p_password    IN VARCHAR2
    );
    PROCEDURE log_em_actualizar_pass(
        p_em_empleado IN NUMBER,
        p_password    IN VARCHAR2
    );
    PROCEDURE log_em_actualizar_usuario(
        p_em_empleado IN NUMBER,
        p_usuario     IN VARCHAR2
    );
    PROCEDURE log_em_eliminar(p_em_empleado IN NUMBER);
    PROCEDURE log_em_validar(
        p_usuario     IN  VARCHAR2,
        p_password    IN  VARCHAR2,
        p_resultado   OUT NUMBER,
        p_em_empleado OUT NUMBER
    );
    PROCEDURE log_em_listar(p_cursor OUT SYS_REFCURSOR);
    PROCEDURE log_em_buscar(
        p_em_empleado IN  NUMBER,
        p_cursor      OUT SYS_REFCURSOR
    );
END PKG_ADMIN_LOGIN_EMPLEADO;
/