-- ============================================================
-- PKG_BOD_NICHO.pks
-- ============================================================
CREATE OR REPLACE PACKAGE PKG_BOD_NICHO AS
  PROCEDURE CREAR_Y_ASIGNAR(
    p_numero         IN VARCHAR2,
    p_zona           IN VARCHAR2,
    p_caracteristica IN VARCHAR2,
    p_alm_almacen    IN NUMBER
  );
  PROCEDURE ACTUALIZAR(p_id IN NUMBER, p_numero IN VARCHAR2, p_zona IN VARCHAR2, p_caracteristica IN VARCHAR2);
  PROCEDURE ELIMINAR(p_id IN NUMBER);
  PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR);
  PROCEDURE LISTAR_POR_ALMACEN(p_alm_almacen IN NUMBER, p_data OUT SYS_REFCURSOR);
END PKG_BOD_NICHO;
/