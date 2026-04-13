CREATE OR REPLACE PACKAGE PKG_RH_ASCENSO AS
  PROCEDURE ASCEN_CREAR(
    p_id_puesto IN NUMBER, 
    p_id_empleado IN NUMBER, 
    p_id OUT NUMBER
    );

  PROCEDURE ASCEN_CERRAR(
    p_id_ascenso IN NUMBER
    ); -- Pone fecha final al ascenso actual
  
  PROCEDURE ASCEN_LISTAR_POR_EMP(
    p_id_empleado IN NUMBER, 
    p_data OUT SYS_REFCURSOR
    );
END PKG_RH_ASCENSO;
/