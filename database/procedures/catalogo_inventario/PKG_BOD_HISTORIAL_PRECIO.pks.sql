-- ============================================================
-- PKG_BOD_HISTORIAL_PRECIO.pks
-- ============================================================
CREATE OR REPLACE PACKAGE PKG_BOD_HISTORIAL_PRECIO AS

  -- Inserta un nuevo registro de precio (queda vigente, sin fecha_final).
  -- Retorna el ID generado en p_id_out.
  PROCEDURE REGISTRAR(
    p_pro_referencia IN  VARCHAR2,
    p_nic_nicho      IN  NUMBER,
    p_precio         IN  NUMBER,
    p_fecha_inicio   IN  DATE,
    p_id_out         OUT NUMBER
  );

  -- *** CAMBIE AHORITA: nueva firma para insertar una semilla con precio=0
  -- y nic_nicho=0 sin validaciones de precio ni nicho real.
  -- Se usa al agregar un item al pedido ANTES de tener Orden de Compra.
  -- Retorna el hip_historial_precio generado para guardarlo en BOD_DETALLE_PEDIDO.
  PROCEDURE REGISTRAR_SEMILLA(
    p_pro_referencia IN  VARCHAR2,
    p_id_out         OUT NUMBER
  );
  -- *** FIN CAMBIE AHORITA

  -- Cierra el precio vigente actual de un producto/nicho
  -- poniendo hip_fecha_final = p_fecha_cierre.
  PROCEDURE CERRAR_VIGENTE(
    p_pro_referencia IN VARCHAR2,
    p_nic_nicho      IN NUMBER,
    p_fecha_cierre   IN DATE
  );

  -- Devuelve el registro vigente (sin fecha_final) de un producto/nicho.
  PROCEDURE VIGENTE(
    p_pro_referencia IN  VARCHAR2,
    p_nic_nicho      IN  NUMBER,
    p_data           OUT SYS_REFCURSOR
  );

  -- Lista todos los registros de historial con JOIN a producto y nicho.
  PROCEDURE LISTAR_TODOS(
    p_data OUT SYS_REFCURSOR
  );

  -- Lista el historial de un producto especifico con JOIN a producto y nicho.
  PROCEDURE LISTAR_POR_PRODUCTO(
    p_pro_referencia IN  VARCHAR2,
    p_data           OUT SYS_REFCURSOR
  );

  -- Lista solo los registros vigentes (sin fecha_final) con JOIN.
  PROCEDURE LISTAR_VIGENTES(
    p_data OUT SYS_REFCURSOR
  );

  -- Lista registros activos durante un mes y anio especifico.
  PROCEDURE LISTAR_POR_MES(
    p_mes  IN  NUMBER,
    p_anio IN  NUMBER,
    p_data OUT SYS_REFCURSOR
  );

  -- Actualiza el registro semilla con nicho, precio y fecha reales
  -- al confirmar la recepcion de mercancia desde Precios.aspx.
  PROCEDURE ACTUALIZAR_SEMILLA(
    p_hip_id       IN NUMBER,
    p_nic_nicho    IN NUMBER,
    p_precio       IN NUMBER,
    p_fecha_inicio IN DATE
  );

END PKG_BOD_HISTORIAL_PRECIO;
/
