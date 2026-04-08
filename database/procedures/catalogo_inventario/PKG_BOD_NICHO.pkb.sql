-- ============================================================
-- PKG_BOD_NICHO.pkb
-- ============================================================
CREATE OR REPLACE PACKAGE BODY PKG_BOD_NICHO AS
 
  PROCEDURE CREAR_Y_ASIGNAR(
    p_numero         IN VARCHAR2,
    p_zona           IN VARCHAR2,
    p_caracteristica IN VARCHAR2,
    p_alm_almacen    IN NUMBER
  ) IS
    v_id_nicho   NUMBER;
    v_id_nic_alm NUMBER;
  BEGIN
    IF TRIM(p_numero) IS NULL THEN RAISE_APPLICATION_ERROR(-20001, 'BOD_NICHO: numero obligatorio.'); END IF;
    IF TRIM(p_zona) IS NULL THEN RAISE_APPLICATION_ERROR(-20002, 'BOD_NICHO: zona obligatoria.'); END IF;
    IF TRIM(p_caracteristica) IS NULL THEN RAISE_APPLICATION_ERROR(-20003, 'BOD_NICHO: caracteristica obligatoria.'); END IF;
    IF p_alm_almacen IS NULL THEN RAISE_APPLICATION_ERROR(-20004, 'BOD_NICHO: almacen obligatorio.'); END IF;
 
    INSERT INTO BOD_NICHO(nic_numero, nic_zona, nic_caracteristica)
    VALUES(TRIM(p_numero), TRIM(p_zona), TRIM(p_caracteristica))
    RETURNING nic_nicho INTO v_id_nicho;
 
    INSERT INTO BOD_NIC_ALM(nic_nicho, alm_almacen)
    VALUES(v_id_nicho, p_alm_almacen)
    RETURNING nic_alm_nichoalmacen INTO v_id_nic_alm;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20005, 'BOD_NICHO: este nicho ya existe en este almacen.');
  END;
 
  PROCEDURE ACTUALIZAR(p_id IN NUMBER, p_numero IN VARCHAR2, p_zona IN VARCHAR2, p_caracteristica IN VARCHAR2) IS
  BEGIN
    IF p_id IS NULL THEN RAISE_APPLICATION_ERROR(-20006, 'BOD_NICHO: id obligatorio.'); END IF;
    IF TRIM(p_numero) IS NULL THEN RAISE_APPLICATION_ERROR(-20007, 'BOD_NICHO: numero obligatorio.'); END IF;
    IF TRIM(p_zona) IS NULL THEN RAISE_APPLICATION_ERROR(-20008, 'BOD_NICHO: zona obligatoria.'); END IF;
    IF TRIM(p_caracteristica) IS NULL THEN RAISE_APPLICATION_ERROR(-20009, 'BOD_NICHO: caracteristica obligatoria.'); END IF;
    UPDATE BOD_NICHO
       SET nic_numero         = TRIM(p_numero),
           nic_zona           = TRIM(p_zona),
           nic_caracteristica = TRIM(p_caracteristica)
     WHERE nic_nicho = p_id;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20010, 'BOD_NICHO: no existe.');
    END IF;
  END;
 
  PROCEDURE ELIMINAR(p_id IN NUMBER) IS
    v_used NUMBER;
  BEGIN
    IF p_id IS NULL THEN RAISE_APPLICATION_ERROR(-20011, 'BOD_NICHO: id obligatorio.'); END IF;
    SELECT COUNT(1) INTO v_used FROM BOD_HISTORIAL_PRECIO WHERE nic_nicho = p_id;
    IF v_used > 0 THEN
      RAISE_APPLICATION_ERROR(-20012, 'BOD_NICHO: no se puede eliminar, tiene historial de precio.');
    END IF;
    DELETE FROM BOD_NIC_ALM WHERE nic_nicho = p_id;
    DELETE FROM BOD_NICHO   WHERE nic_nicho = p_id;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20013, 'BOD_NICHO: no existe.');
    END IF;
  END;
 
  PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN p_data FOR
      SELECT n.nic_nicho,
             n.nic_numero,
             n.nic_zona,
             n.nic_caracteristica,
             a.alm_almacen,
             a.alm_nombre
        FROM BOD_NICHO   n
        JOIN BOD_NIC_ALM na ON na.nic_nicho  = n.nic_nicho
        JOIN BOD_ALMACEN a  ON a.alm_almacen = na.alm_almacen
       ORDER BY a.alm_nombre, n.nic_numero;
  END;
 
  PROCEDURE LISTAR_POR_ALMACEN(p_alm_almacen IN NUMBER, p_data OUT SYS_REFCURSOR) IS
  BEGIN
    IF p_alm_almacen IS NULL THEN
      RAISE_APPLICATION_ERROR(-20014, 'BOD_NICHO: alm_almacen obligatorio.');
    END IF;
    OPEN p_data FOR
      SELECT n.nic_nicho,
             na.nic_alm_nichoalmacen,
             n.nic_numero,
             n.nic_zona,
             n.nic_caracteristica
        FROM BOD_NICHO   n
        JOIN BOD_NIC_ALM na ON na.nic_nicho  = n.nic_nicho
       WHERE na.alm_almacen = p_alm_almacen
       ORDER BY n.nic_numero;
  END;
 
END PKG_BOD_NICHO;
/