CREATE OR REPLACE PACKAGE PKG_BOD_PRODUCTO AS
  PROCEDURE CREAR(
    p_referencia IN VARCHAR2, p_nombre IN VARCHAR2, p_descripcion IN VARCHAR2,
    p_tip_tipo IN NUMBER, p_mat_material IN NUMBER,
    p_alto_cm IN NUMBER, p_ancho_cm IN NUMBER, p_profundidad_cm IN NUMBER,
    p_color IN VARCHAR2, p_peso IN NUMBER, p_foto IN BLOB
  );
  PROCEDURE ACTUALIZAR(
    p_referencia IN VARCHAR2, p_nombre IN VARCHAR2, p_descripcion IN VARCHAR2,
    p_tip_tipo IN NUMBER, p_mat_material IN NUMBER,
    p_alto_cm IN NUMBER, p_ancho_cm IN NUMBER, p_profundidad_cm IN NUMBER,
    p_color IN VARCHAR2, p_peso IN NUMBER
  );
  PROCEDURE ACTUALIZAR_FOTO(p_referencia IN VARCHAR2, p_foto IN BLOB);
  PROCEDURE ACTUALIZAR_PRECIO(p_referencia IN VARCHAR2, p_precio IN NUMBER);
  PROCEDURE ELIMINAR(p_referencia IN VARCHAR2);
  PROCEDURE OBTENER(p_referencia IN VARCHAR2, p_data OUT SYS_REFCURSOR);
  PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR);
  PROCEDURE BUSCAR(p_texto IN VARCHAR2, p_data OUT SYS_REFCURSOR);
  PROCEDURE OBTENER_FOTO(p_referencia IN VARCHAR2, p_foto OUT BLOB);
END PKG_BOD_PRODUCTO;
/