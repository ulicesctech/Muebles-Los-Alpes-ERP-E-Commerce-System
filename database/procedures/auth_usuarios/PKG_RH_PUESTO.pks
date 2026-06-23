CREATE OR REPLACE PACKAGE PKG_RH_PUESTO AS
    PROCEDURE pue_crear(
        p_pue_nombre      IN  VARCHAR2,
        p_pue_salario     IN  NUMBER,
        p_pue_descripcion IN  VARCHAR2,
        p_nuevo_id        OUT NUMBER
    );
    PROCEDURE pue_actualizar(
        p_pue_puestos     IN NUMBER,
        p_pue_nombre      IN VARCHAR2,
        p_pue_salario     IN NUMBER,
        p_pue_descripcion IN VARCHAR2
    );
    PROCEDURE pue_eliminar(p_pue_puestos IN NUMBER);
    PROCEDURE pue_listar(
        p_pue_puestos IN  NUMBER DEFAULT NULL,
        p_data        OUT SYS_REFCURSOR
    );
    PROCEDURE pue_obtener(
        p_pue_puestos IN  NUMBER,
        p_data        OUT SYS_REFCURSOR
    );
END PKG_RH_PUESTO;
/