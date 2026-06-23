-- ============================================================
-- PKG_BOD_NIC_ALM.pks
-- ============================================================
CREATE OR REPLACE PACKAGE PKG_BOD_NIC_ALM AS
  PROCEDURE ASIGNAR(p_nic_nicho IN NUMBER, p_alm_almacen IN NUMBER, p_id OUT NUMBER);
  PROCEDURE QUITAR(p_id IN NUMBER);
  PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR);
  PROCEDURE LISTAR_POR_ALMACEN(p_alm_almacen IN NUMBER, p_data OUT SYS_REFCURSOR);
END PKG_BOD_NIC_ALM;
/