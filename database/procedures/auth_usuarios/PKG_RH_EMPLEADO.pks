CREATE OR REPLACE PACKAGE PKG_RH_EMPLEADO AS
    PROCEDURE emp_crear(
        p_dpi   IN VARCHAR2, p_p_nom IN VARCHAR2, p_s_nom IN VARCHAR2,
        p_p_ape IN VARCHAR2, p_s_ape IN VARCHAR2, p_dir   IN VARCHAR2,
        p_ave   IN VARCHAR2, p_cp    IN VARCHAR2, p_tel1  IN VARCHAR2,
        p_tel2  IN VARCHAR2, p_rol   IN NUMBER,   p_id    OUT NUMBER
    );
    PROCEDURE emp_actualizar(
        p_id    IN NUMBER,  p_dpi   IN VARCHAR2, p_p_nom IN VARCHAR2,
        p_s_nom IN VARCHAR2, p_p_ape IN VARCHAR2, p_s_ape IN VARCHAR2,
        p_dir   IN VARCHAR2, p_ave   IN VARCHAR2, p_cp    IN VARCHAR2,
        p_tel1  IN VARCHAR2, p_tel2  IN VARCHAR2, p_rol   IN NUMBER
    );
    PROCEDURE emp_eliminar(p_id IN NUMBER);
    PROCEDURE emp_listar(p_data OUT SYS_REFCURSOR);
    PROCEDURE emp_obtener_admin(p_id OUT NUMBER);
END PKG_RH_EMPLEADO;
/