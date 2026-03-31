CREATE OR REPLACE PACKAGE PKG_ADMIN_LOGIN_EMPLEADO AS
  PROCEDURE LOGE_CREAR(
    p_id_empleado IN NUMBER, 
    p_usuario IN VARCHAR2, 
    p_password IN VARCHAR2
    );

  PROCEDURE LOGE_ACTUALIZAR_PWD(
    p_id_empleado IN NUMBER, 
    p_password IN VARCHAR2
    );

  PROCEDURE LOGE_ELIMINAR(
    p_id_empleado IN NUMBER
    );

  PROCEDURE LOGE_AUTENTICAR(
    p_usuario IN VARCHAR2, 
    p_password IN VARCHAR2, 
    p_id_empleado OUT NUMBER, 
    p_rol OUT VARCHAR2
    );
END PKG_ADMIN_LOGIN_EMPLEADO;
/