CREATE OR REPLACE PACKAGE PKG_PROMO_PROMOCION AS
  PROCEDURE CREAR(
    p_pro_referencia IN VARCHAR2,
    p_porcentaje     IN NUMBER,
    p_fecha_inicio   IN DATE,
    p_fecha_final    IN DATE,
    p_id_out         OUT NUMBER
  );

  PROCEDURE ELIMINAR(p_id IN NUMBER);
  PROCEDURE LISTAR_POR_PRODUCTO(p_pro_referencia IN VARCHAR2, p_data OUT SYS_REFCURSOR);
  PROCEDURE VIGENTE(p_pro_referencia IN VARCHAR2, p_data OUT SYS_REFCURSOR);
END PKG_PROMO_PROMOCION;
/