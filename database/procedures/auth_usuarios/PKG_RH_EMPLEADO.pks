CREATE OR REPLACE PACKAGE PKG_RH_EMPLEADO AS
  PROCEDURE EMP_CREAR(
    p_dpi IN VARCHAR2, 
    p_p_nom IN VARCHAR2, 
    p_s_nom IN VARCHAR2, 
    p_p_ape IN VARCHAR2, 
    p_s_ape IN VARCHAR2, 
    p_dir IN VARCHAR2, 
    p_ave IN VARCHAR2, 
    p_cp IN VARCHAR2, 
    p_tel1 IN VARCHAR2, 
    p_tel2 IN VARCHAR2, 
    p_rol IN NUMBER, 
    p_id OUT NUMBER
    );

  PROCEDURE EMP_ACTUALIZAR(
    p_id IN NUMBER, 
    p_dpi IN VARCHAR2, 
    p_p_nom IN VARCHAR2, 
    p_s_nom IN VARCHAR2, 
    p_p_ape IN VARCHAR2, 
    p_s_ape IN VARCHAR2, 
    p_dir IN VARCHAR2, 
    p_ave IN VARCHAR2, 
    p_cp IN VARCHAR2, 
    p_tel1 IN VARCHAR2, 
    p_tel2 IN VARCHAR2, 
    p_rol IN NUMBER
    );

  PROCEDURE EMP_ELIMINAR(
    p_id IN NUMBER
    );

  PROCEDURE EMP_LISTAR(
    p_data OUT SYS_REFCURSOR
    );
    
END PKG_RH_EMPLEADO;
/