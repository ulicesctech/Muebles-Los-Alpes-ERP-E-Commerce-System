 -- =========================
 --PKG_CI_PRECIO_STOCK SPEC
  -- =========================
  CREATE OR REPLACE PACKAGE PKG_CI_PRECIO_STOCK AS
  -- Registrar precio (cierra precio vigente anterior del mismo producto+nicho)
  PROCEDURE PRECIO_REGISTRAR(
    p_pro_referencia IN VARCHAR2,
    p_nic_nicho      IN NUMBER,
    p_precio         IN NUMBER,
    p_fecha_inicio   IN DATE,
    p_id_out         OUT NUMBER
  );

  PROCEDURE PRECIO_VIGENTE(
    p_pro_referencia IN VARCHAR2,
    p_nic_nicho      IN NUMBER,
    p_data           OUT SYS_REFCURSOR
  );

  PROCEDURE PRECIO_LISTAR_POR_PRODUCTO(
    p_pro_referencia IN VARCHAR2,
    p_data           OUT SYS_REFCURSOR
  );

  -- Stock (Upsert por hip_historial_precio)
  PROCEDURE STOCK_GUARDAR(
    p_hip_historial_precio IN NUMBER,
    p_minimo               IN NUMBER,
    p_maximo               IN NUMBER,
    p_reservado            IN NUMBER,
    p_disponible           IN NUMBER
  );

  PROCEDURE STOCK_OBTENER(
    p_hip_historial_precio IN NUMBER,
    p_data                 OUT SYS_REFCURSOR
  );
END PKG_CI_PRECIO_STOCK;
/