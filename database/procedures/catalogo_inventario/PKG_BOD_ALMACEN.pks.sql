-- ============================================================
-- 4. PKG_BOD_ALMACEN
-- ============================================================
CREATE OR REPLACE PACKAGE PKG_BOD_ALMACEN AS
  PROCEDURE CREAR(p_nombre IN VARCHAR2, p_pais IN VARCHAR2, p_ubicacion IN VARCHAR2, p_id OUT NUMBER);
  PROCEDURE ACTUALIZAR(p_id IN NUMBER, p_nombre IN VARCHAR2, p_pais IN VARCHAR2, p_ubicacion IN VARCHAR2);
  PROCEDURE ELIMINAR(p_id IN NUMBER);
  PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR);
END PKG_BOD_ALMACEN;
/