CREATE OR REPLACE PACKAGE PKG_ADMIN_GRUPO_USUARIO AS
    PROCEDURE gru_crear(
        p_descripcion IN VARCHAR2,
        p_permisos    IN NUMBER,
        p_id          OUT NUMBER
    );
    PROCEDURE gru_actualizar(
        p_id          IN NUMBER,
        p_descripcion IN VARCHAR2 DEFAULT NULL,
        p_permisos    IN NUMBER   DEFAULT NULL
    );
    PROCEDURE gru_eliminar(p_id IN NUMBER);
    PROCEDURE gru_listar(p_cursor OUT SYS_REFCURSOR);
    PROCEDURE gru_buscar(
        p_id     IN  NUMBER,
        p_cursor OUT SYS_REFCURSOR
    );
END PKG_ADMIN_GRUPO_USUARIO;
/