-- ============================================================
-- PKG_BOD_NIC_ALM.pkb
-- ============================================================
CREATE OR REPLACE PACKAGE BODY PKG_BOD_NIC_ALM AS
 
  PROCEDURE ASIGNAR(p_nic_nicho IN NUMBER, p_alm_almacen IN NUMBER, p_id OUT NUMBER) IS
  BEGIN
    IF p_nic_nicho IS NULL OR p_alm_almacen IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'BOD_NIC_ALM: nicho y almacen son obligatorios.');
    END IF;
    INSERT INTO BOD_NIC_ALM(nic_nicho, alm_almacen)
    VALUES(p_nic_nicho, p_alm_almacen)
    RETURNING nic_alm_nichoalmacen INTO p_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20002, 'BOD_NIC_ALM: este nicho ya esta asignado a este almacen.');
  END;
 
  PROCEDURE QUITAR(p_id IN NUMBER) IS
  BEGIN
    IF p_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20003, 'BOD_NIC_ALM: id obligatorio.');
    END IF;
    DELETE FROM BOD_NIC_ALM WHERE nic_alm_nichoalmacen = p_id;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20004, 'BOD_NIC_ALM: no existe.');
    END IF;
  END;
 
  -- NIC_DISPLAY incluye: numero, caracteristica y almacen
  -- Ejemplo: "A-01 | Estanteria alta para sala | Almacen Central"
  PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN p_data FOR
      SELECT na.nic_alm_nichoalmacen,
             na.nic_nicho,
             na.alm_almacen,
             n.nic_numero,
             n.nic_zona,
             n.nic_caracteristica,
             a.alm_nombre,
             n.nic_numero || ' | ' || n.nic_caracteristica || ' | ' || a.alm_nombre AS nic_display
        FROM BOD_NIC_ALM na
        JOIN BOD_NICHO   n ON n.nic_nicho   = na.nic_nicho
        JOIN BOD_ALMACEN a ON a.alm_almacen = na.alm_almacen
       ORDER BY a.alm_nombre, n.nic_numero;
  END;
 
  PROCEDURE LISTAR_POR_ALMACEN(p_alm_almacen IN NUMBER, p_data OUT SYS_REFCURSOR) IS
  BEGIN
    IF p_alm_almacen IS NULL THEN
      RAISE_APPLICATION_ERROR(-20005, 'BOD_NIC_ALM: alm_almacen obligatorio.');
    END IF;
    OPEN p_data FOR
      SELECT na.nic_alm_nichoalmacen,
             na.nic_nicho,
             na.alm_almacen,
             n.nic_numero,
             n.nic_zona,
             n.nic_caracteristica,
             a.alm_nombre,
             n.nic_numero || ' | ' || n.nic_caracteristica || ' | ' || a.alm_nombre AS nic_display
        FROM BOD_NIC_ALM na
        JOIN BOD_NICHO   n ON n.nic_nicho   = na.nic_nicho
        JOIN BOD_ALMACEN a ON a.alm_almacen = na.alm_almacen
       WHERE na.alm_almacen = p_alm_almacen
       ORDER BY n.nic_numero;
  END;
 
END PKG_BOD_NIC_ALM;
/