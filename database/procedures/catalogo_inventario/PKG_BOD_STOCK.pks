CREATE OR REPLACE PACKAGE PKG_BOD_STOCK AS
  PROCEDURE GUARDAR(
    p_hip_historial_precio IN NUMBER,
    p_minimo               IN NUMBER,
    p_maximo               IN NUMBER,
    p_reservado            IN NUMBER,
    p_disponible           IN NUMBER
  );

  PROCEDURE OBTENER(p_hip_historial_precio IN NUMBER, p_data OUT SYS_REFCURSOR);
END PKG_BOD_STOCK;
/