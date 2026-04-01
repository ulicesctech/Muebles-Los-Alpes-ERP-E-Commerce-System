CREATE OR REPLACE PACKAGE PKG_ADMIN_GRUPO_USUARIO AS

    -- Crear nuevo grupo, retorna el ID generado
    PROCEDURE gru_crear(
        p_descripcion IN VARCHAR2,
        p_permisos    IN NUMBER,
        p_id          OUT NUMBER
    );

    -- Actualizar grupo existente por ID
    PROCEDURE gru_actualizar(
        p_id          IN NUMBER,
        p_descripcion IN VARCHAR2 DEFAULT NULL,
        p_permisos    IN NUMBER   DEFAULT NULL
    );

    -- Eliminar grupo por ID
    PROCEDURE gru_eliminar(p_id IN NUMBER);

    -- Listar todos los grupos
    PROCEDURE gru_listar(p_cursor OUT SYS_REFCURSOR);

    -- Buscar grupo por ID
    PROCEDURE gru_buscar(
        p_id     IN  NUMBER,
        p_cursor OUT SYS_REFCURSOR
    );

END PKG_ADMIN_GRUPO_USUARIO;
/