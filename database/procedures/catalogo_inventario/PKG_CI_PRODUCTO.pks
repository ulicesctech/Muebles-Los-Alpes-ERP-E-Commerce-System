 -- =========================
 --PKG_CI_PRODUCTO SPEC
  -- =========================
  CREATE OR REPLACE PACKAGE PKG_CI_PRODUCTO AS
  PROCEDURE PRO_CREAR(
    p_referencia     IN VARCHAR2,
    p_nombre         IN VARCHAR2,
    p_descripcion    IN VARCHAR2,
    p_tip_tipo       IN NUMBER,
    p_mat_material   IN NUMBER,
    p_alto_cm        IN NUMBER,
    p_ancho_cm       IN NUMBER,
    p_profundidad_cm IN NUMBER,
    p_color          IN VARCHAR2,
    p_peso           IN NUMBER,
    p_foto           IN BLOB
  );

  PROCEDURE PRO_ACTUALIZAR(
    p_referencia     IN VARCHAR2,
    p_nombre         IN VARCHAR2,
    p_descripcion    IN VARCHAR2,
    p_tip_tipo       IN NUMBER,
    p_mat_material   IN NUMBER,
    p_alto_cm        IN NUMBER,
    p_ancho_cm       IN NUMBER,
    p_profundidad_cm IN NUMBER,
    p_color          IN VARCHAR2,
    p_peso           IN NUMBER
  );

  -- Actualizar foto por separado (BLOB)
  PROCEDURE PRO_ACTUALIZAR_FOTO(
    p_referencia IN VARCHAR2,
    p_foto       IN BLOB
  );

  PROCEDURE PRO_ELIMINAR(p_referencia IN VARCHAR2); -- solo si no tiene historial/precio/promo
  PROCEDURE PRO_OBTENER(p_referencia IN VARCHAR2, p_data OUT SYS_REFCURSOR); -- sin BLOB
  PROCEDURE PRO_LISTAR(p_data OUT SYS_REFCURSOR);
  PROCEDURE PRO_BUSCAR(p_texto IN VARCHAR2, p_data OUT SYS_REFCURSOR);

  -- Obtener foto BLOB
  PROCEDURE PRO_OBTENER_FOTO(p_referencia IN VARCHAR2, p_foto OUT BLOB);
END PKG_CI_PRODUCTO;
/