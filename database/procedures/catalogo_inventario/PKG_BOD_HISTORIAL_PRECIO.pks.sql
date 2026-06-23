-- ============================================================
-- PKG_BOD_HISTORIAL_PRECIO.pks
--
-- CAMBIOS vs version anterior:
--   + CERRAR_SEMILLA: cierra unicamente la semilla indicada por
--     su hip_id sin afectar ningun otro registro del producto.
--     Se usa cuando el precio del pedido coincide con el vigente
--     real, evitando generar un nuevo historial innecesario.
-- ============================================================
CREATE OR REPLACE PACKAGE PKG_BOD_HISTORIAL_PRECIO AS

  PROCEDURE REGISTRAR(
    p_pro_referencia IN  VARCHAR2,
    p_nic_nicho      IN  NUMBER,
    p_precio         IN  NUMBER,
    p_fecha_inicio   IN  DATE,
    p_id_out         OUT NUMBER
  );

  PROCEDURE REGISTRAR_SEMILLA(
    p_pro_referencia IN  VARCHAR2,
    p_id_out         OUT NUMBER
  );

  PROCEDURE CERRAR_VIGENTE(
    p_pro_referencia IN VARCHAR2,
    p_nic_nicho      IN NUMBER,
    p_fecha_cierre   IN DATE
  );

  PROCEDURE CERRAR_TODOS(
    p_pro_referencia IN VARCHAR2,
    p_fecha_cierre   IN DATE
  );

  -- NUEVO: Cierra unicamente la semilla indicada por su hip_id.
  -- No afecta ningun otro registro del producto.
  -- Se usa cuando el precio del pedido coincide con el vigente real,
  -- evitando generar un nuevo historial innecesario.
  PROCEDURE CERRAR_SEMILLA(
    p_hip_id       IN NUMBER,
    p_fecha_cierre IN DATE
  );

  PROCEDURE REGISTRAR_GLOBAL(
    p_pro_referencia IN  VARCHAR2,
    p_nic_nicho      IN  NUMBER,
    p_precio         IN  NUMBER,
    p_fecha_inicio   IN  DATE,
    p_id_out         OUT NUMBER
  );

  PROCEDURE VIGENTE(
    p_pro_referencia IN  VARCHAR2,
    p_nic_nicho      IN  NUMBER,
    p_data           OUT SYS_REFCURSOR
  );

  PROCEDURE LISTAR_TODOS(
    p_data OUT SYS_REFCURSOR
  );

  PROCEDURE LISTAR_POR_PRODUCTO(
    p_pro_referencia IN  VARCHAR2,
    p_data           OUT SYS_REFCURSOR
  );

  PROCEDURE LISTAR_VIGENTES(
    p_data OUT SYS_REFCURSOR
  );

  PROCEDURE LISTAR_POR_MES(
    p_mes  IN  NUMBER,
    p_anio IN  NUMBER,
    p_data OUT SYS_REFCURSOR
  );

  PROCEDURE ACTUALIZAR_SEMILLA(
    p_hip_id       IN NUMBER,
    p_nic_nicho    IN NUMBER,
    p_precio       IN NUMBER,
    p_fecha_inicio IN DATE
  );

  PROCEDURE OBTENER_ANIOS(
    p_data OUT SYS_REFCURSOR
);

END PKG_BOD_HISTORIAL_PRECIO;
/