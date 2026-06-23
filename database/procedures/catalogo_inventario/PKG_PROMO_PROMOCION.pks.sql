CREATE OR REPLACE PACKAGE PKG_PROMO_PROMOCION AS
    -- CAMPANA (maestro)
    PROCEDURE CAMPANA_CREAR(
        p_nombre      IN VARCHAR2,
        p_descripcion IN VARCHAR2,
        p_fecha_inicio IN DATE,
        p_fecha_final  IN DATE,
        p_id_out       OUT NUMBER
    );
    PROCEDURE CAMPANA_ACTUALIZAR(
        p_id          IN NUMBER,
        p_nombre      IN VARCHAR2,
        p_descripcion IN VARCHAR2,
        p_estado      IN VARCHAR2,
        p_fecha_inicio IN DATE,
        p_fecha_final  IN DATE
    );
    PROCEDURE CAMPANA_ELIMINAR(p_id IN NUMBER);
    PROCEDURE CAMPANA_LISTAR(p_data OUT SYS_REFCURSOR);
    PROCEDURE CAMPANA_BUSCAR(p_id IN NUMBER, p_data OUT SYS_REFCURSOR);

    -- PROMOCION (detalle)
    PROCEDURE CREAR(
        p_camp_campana   IN NUMBER,
        p_pro_referencia IN VARCHAR2,
        p_porcentaje     IN NUMBER,
        p_id_out         OUT NUMBER
    );
    PROCEDURE ELIMINAR(p_id IN NUMBER);
    PROCEDURE LISTAR_POR_CAMPANA(p_camp_campana IN NUMBER, p_data OUT SYS_REFCURSOR);
    PROCEDURE LISTAR_POR_PRODUCTO(p_pro_referencia IN VARCHAR2, p_data OUT SYS_REFCURSOR);
    PROCEDURE VIGENTE(p_pro_referencia IN VARCHAR2, p_data OUT SYS_REFCURSOR);
END PKG_PROMO_PROMOCION;
/