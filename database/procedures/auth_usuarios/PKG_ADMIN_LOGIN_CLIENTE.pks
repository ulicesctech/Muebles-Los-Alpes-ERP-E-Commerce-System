CREATE OR REPLACE PACKAGE PKG_ADMIN_LOGIN_CLIENTE AS
    PROCEDURE logc_crear(
        p_id_cliente IN NUMBER,
        p_usuario    IN VARCHAR2,
        p_password   IN VARCHAR2
    );
    PROCEDURE logc_actualizar_pwd(
        p_id_cliente IN NUMBER,
        p_password   IN VARCHAR2
    );
    PROCEDURE logc_eliminar(p_id_cliente IN NUMBER);
    PROCEDURE logc_autenticar(
        p_usuario    IN  VARCHAR2,
        p_password   IN  VARCHAR2,
        p_id_cliente OUT NUMBER
    );
END PKG_ADMIN_LOGIN_CLIENTE;
/