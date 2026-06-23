-- ============================================================
-- 2. PKG_BOD_MATERIAL
-- ============================================================
CREATE OR REPLACE PACKAGE PKG_BOD_MATERIAL AS
  PROCEDURE CREAR(p_descripcion IN VARCHAR2, p_id OUT NUMBER);
  PROCEDURE ACTUALIZAR(p_id IN NUMBER, p_descripcion IN VARCHAR2);
  PROCEDURE ELIMINAR(p_id IN NUMBER);
  PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR);
  PROCEDURE BUSCAR(p_texto IN VARCHAR2, p_data OUT SYS_REFCURSOR);
END PKG_BOD_MATERIAL;
/