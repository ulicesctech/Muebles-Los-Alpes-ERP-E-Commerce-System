-- NUEVO .pks SIMPLE (sin fecha_crea)
CREATE OR REPLACE PACKAGE PKG_ADMIN_PERMISOS AS
    PROCEDURE per_crear(
        p_admin   IN NUMBER DEFAULT 0,
        p_rh      IN NUMBER DEFAULT 0,
        p_fac     IN NUMBER DEFAULT 0,
        p_cli     IN NUMBER DEFAULT 0,
        p_bod     IN NUMBER DEFAULT 0,
        p_promo   IN NUMBER DEFAULT 0,
        p_id      OUT NUMBER
    );
    
    PROCEDURE per_actualizar(
        p_id      IN NUMBER,
        p_admin   IN NUMBER DEFAULT NULL,
        p_rh      IN NUMBER DEFAULT NULL,
        p_fac     IN NUMBER DEFAULT NULL,
        p_cli     IN NUMBER DEFAULT NULL,
        p_bod     IN NUMBER DEFAULT NULL,
        p_promo   IN NUMBER DEFAULT NULL
    );
    
    PROCEDURE per_eliminar(p_id IN NUMBER);
    
    PROCEDURE per_listar(p_cursor OUT SYS_REFCURSOR);
END PKG_ADMIN_PERMISOS;
/