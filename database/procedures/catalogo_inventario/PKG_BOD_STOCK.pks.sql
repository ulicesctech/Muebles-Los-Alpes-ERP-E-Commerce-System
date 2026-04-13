-- ============================================================
-- PKG_BOD_STOCK.pks
-- ============================================================
CREATE OR REPLACE PACKAGE PKG_BOD_STOCK AS
  PROCEDURE GUARDAR(
    p_hip_historial_precio IN NUMBER,
    p_minimo               IN NUMBER,
    p_maximo               IN NUMBER,
    p_disponible           IN NUMBER
  );
  PROCEDURE OBTENER(p_hip_historial_precio IN NUMBER, p_data OUT SYS_REFCURSOR);
  PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR);
  PROCEDURE LISTAR_POR_PRODUCTO(p_pro_referencia IN VARCHAR2, p_data OUT SYS_REFCURSOR);
  -- Suma cantidad al disponible (entrada de mercancia desde Compras)
  PROCEDURE ENTRADA(p_hip_historial_precio IN NUMBER, p_cantidad IN NUMBER);
  -- Resta cantidad del disponible (salida por venta desde Ventas)
  PROCEDURE SALIDA(p_hip_historial_precio IN NUMBER, p_cantidad IN NUMBER);
END PKG_BOD_STOCK;
/   