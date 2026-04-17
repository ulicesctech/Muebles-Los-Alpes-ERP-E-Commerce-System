-- ============================================================
-- PKG_BOD_HISTORIAL_PRECIO.pks
--
-- CAMBIOS vs version anterior:
--   + CERRAR_TODOS     : cierra TODOS los vigentes de un pro_referencia
--                        sin filtrar por nic_nicho (incluye semillas NULL).
--   + REGISTRAR_GLOBAL : atomico: CERRAR_TODOS + INSERT nuevo vigente.
--                        Reemplaza CERRAR_VIGENTE+REGISTRAR en flujo normal.
--
-- ESTADO DEL ESQUEMA (tras ALTER ejecutado):
--   BOD_HISTORIAL_PRECIO.nic_nicho  -> NULL permitido
--   BOD_HISTORIAL_PRECIO.hip_precio -> NULL permitido
--   (semillas tienen ambos campos NULL hasta que se confirma recepcion)
-- ============================================================
CREATE OR REPLACE PACKAGE PKG_BOD_HISTORIAL_PRECIO AS

  -- Inserta un nuevo registro de precio real (queda vigente, sin fecha_final).
  PROCEDURE REGISTRAR(
    p_pro_referencia IN  VARCHAR2,
    p_nic_nicho      IN  NUMBER,
    p_precio         IN  NUMBER,
    p_fecha_inicio   IN  DATE,
    p_id_out         OUT NUMBER
  );

  -- Inserta una semilla con nic_nicho=NULL y hip_precio=NULL.
  -- Se usa al agregar un item al pedido antes de tener Orden de Compra.
  PROCEDURE REGISTRAR_SEMILLA(
    p_pro_referencia IN  VARCHAR2,
    p_id_out         OUT NUMBER
  );

  -- Cierra el vigente de un nicho especifico (se conserva para usos puntuales).
  PROCEDURE CERRAR_VIGENTE(
    p_pro_referencia IN VARCHAR2,
    p_nic_nicho      IN NUMBER,
    p_fecha_cierre   IN DATE
  );

  -- NUEVO: Cierra TODOS los registros vigentes del producto
  -- sin importar nicho ni almacen (incluye semillas con nic_nicho IS NULL).
  PROCEDURE CERRAR_TODOS(
    p_pro_referencia IN VARCHAR2,
    p_fecha_cierre   IN DATE
  );

  -- NUEVO: Atomico: cierra todos los vigentes del producto
  -- e inserta el nuevo registro vigente unico.
  -- Reemplaza CERRAR_VIGENTE + REGISTRAR en el flujo normal de Precios.aspx.
  PROCEDURE REGISTRAR_GLOBAL(
    p_pro_referencia IN  VARCHAR2,
    p_nic_nicho      IN  NUMBER,
    p_precio         IN  NUMBER,
    p_fecha_inicio   IN  DATE,
    p_id_out         OUT NUMBER
  );

  -- Devuelve el registro vigente real (precio NOT NULL) de un producto/nicho.
  PROCEDURE VIGENTE(
    p_pro_referencia IN  VARCHAR2,
    p_nic_nicho      IN  NUMBER,
    p_data           OUT SYS_REFCURSOR
  );

  -- Lista todos los registros de historial (incluye semillas).
  PROCEDURE LISTAR_TODOS(
    p_data OUT SYS_REFCURSOR
  );

  -- Lista el historial de un producto especifico.
  PROCEDURE LISTAR_POR_PRODUCTO(
    p_pro_referencia IN  VARCHAR2,
    p_data           OUT SYS_REFCURSOR
  );

  -- Lista solo los vigentes reales (precio NOT NULL, sin fecha_final).
  PROCEDURE LISTAR_VIGENTES(
    p_data OUT SYS_REFCURSOR
  );

  -- Lista registros activos durante un mes y anio especifico.
  PROCEDURE LISTAR_POR_MES(
    p_mes  IN  NUMBER,
    p_anio IN  NUMBER,
    p_data OUT SYS_REFCURSOR
  );

  -- Actualiza la semilla con nicho, precio y fecha reales
  -- al confirmar la recepcion desde Precios.aspx (flujo readonly).
  PROCEDURE ACTUALIZAR_SEMILLA(
    p_hip_id       IN NUMBER,
    p_nic_nicho    IN NUMBER,
    p_precio       IN NUMBER,
    p_fecha_inicio IN DATE
  );

END PKG_BOD_HISTORIAL_PRECIO;
/