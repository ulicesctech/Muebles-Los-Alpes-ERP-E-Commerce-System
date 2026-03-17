CREATE OR REPLACE PACKAGE PKG_BOD_HISTORIAL_PRECIO AS
  PROCEDURE REGISTRAR(
    p_pro_referencia IN VARCHAR2,
    p_nic_nicho      IN NUMBER,
    p_precio         IN NUMBER,
    p_fecha_inicio   IN DATE,
    p_id_out         OUT NUMBER
  );

  PROCEDURE VIGENTE(
    p_pro_referencia IN VARCHAR2,
    p_nic_nicho      IN NUMBER,
    p_data           OUT SYS_REFCURSOR
  );

  PROCEDURE LISTAR_POR_PRODUCTO(
    p_pro_referencia IN VARCHAR2,
    p_data           OUT SYS_REFCURSOR
  );
END PKG_BOD_HISTORIAL_PRECIO;
/