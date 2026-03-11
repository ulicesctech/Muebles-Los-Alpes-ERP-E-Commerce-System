 -- =========================
 --PKG_CI_PROMO SPEC
  -- =========================
  CREATE OR REPLACE PACKAGE PKG_CI_PROMO AS
  PROCEDURE PROMO_CREAR(
    p_pro_referencia IN VARCHAR2,
    p_porcentaje     IN NUMBER,
    p_fecha_inicio   IN DATE,
    p_fecha_final    IN DATE,
    p_id_out         OUT NUMBER
  );

  PROCEDURE PROMO_ELIMINAR(p_id IN NUMBER);
  PROCEDURE PROMO_LISTAR_POR_PRODUCTO(p_pro_referencia IN VARCHAR2, p_data OUT SYS_REFCURSOR);
  PROCEDURE PROMO_VIGENTE(p_pro_referencia IN VARCHAR2, p_data OUT SYS_REFCURSOR);
END PKG_CI_PROMO;
/