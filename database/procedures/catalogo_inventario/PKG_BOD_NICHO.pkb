CREATE OR REPLACE PACKAGE BODY PKG_BOD_NICHO AS

  PROCEDURE CREAR(p_numero IN VARCHAR2, p_zona IN VARCHAR2, p_caracteristica IN VARCHAR2, p_id OUT NUMBER) IS
  BEGIN
    IF TRIM(p_numero) IS NULL THEN RAISE_APPLICATION_ERROR(-21501, 'BOD_NICHO: numero obligatorio.'); END IF;
    IF TRIM(p_zona) IS NULL THEN RAISE_APPLICATION_ERROR(-21502, 'BOD_NICHO: zona obligatoria.'); END IF;
    IF TRIM(p_caracteristica) IS NULL THEN RAISE_APPLICATION_ERROR(-21503, 'BOD_NICHO: caracteristica obligatoria.'); END IF;

    INSERT INTO BOD_NICHO(nic_numero, nic_zona, nic_caracteristica)
    VALUES(TRIM(p_numero), TRIM(p_zona), TRIM(p_caracteristica))
    RETURNING nic_nicho INTO p_id;
  END;

  PROCEDURE ACTUALIZAR(p_id IN NUMBER, p_numero IN VARCHAR2, p_zona IN VARCHAR2, p_caracteristica IN VARCHAR2) IS
  BEGIN
    IF p_id IS NULL THEN RAISE_APPLICATION_ERROR(-21504, 'BOD_NICHO: id obligatorio.'); END IF;
    IF TRIM(p_numero) IS NULL THEN RAISE_APPLICATION_ERROR(-21505, 'BOD_NICHO: numero obligatorio.'); END IF;
    IF TRIM(p_zona) IS NULL THEN RAISE_APPLICATION_ERROR(-21506, 'BOD_NICHO: zona obligatoria.'); END IF;
    IF TRIM(p_caracteristica) IS NULL THEN RAISE_APPLICATION_ERROR(-21507, 'BOD_NICHO: caracteristica obligatoria.'); END IF;

    UPDATE BOD_NICHO
       SET nic_numero = TRIM(p_numero),
           nic_zona = TRIM(p_zona),
           nic_caracteristica = TRIM(p_caracteristica)
     WHERE nic_nicho = p_id;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-21508, 'BOD_NICHO: no existe.');
    END IF;
  END;

  PROCEDURE ELIMINAR(p_id IN NUMBER) IS
    v_used1 NUMBER;
    v_used2 NUMBER;
  BEGIN
    IF p_id IS NULL THEN RAISE_APPLICATION_ERROR(-21509, 'BOD_NICHO: id obligatorio.'); END IF;

    SELECT COUNT(1) INTO v_used1 FROM BOD_NIC_ALM WHERE nic_nicho = p_id;
    SELECT COUNT(1) INTO v_used2 FROM BOD_HISTORIAL_PRECIO WHERE nic_nicho = p_id;

    IF v_used1 > 0 OR v_used2 > 0 THEN
      RAISE_APPLICATION_ERROR(-21510, 'BOD_NICHO: no se puede eliminar, tiene referencias.');
    END IF;

    DELETE FROM BOD_NICHO WHERE nic_nicho = p_id;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-21511, 'BOD_NICHO: no existe.');
    END IF;
  END;

  PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN p_data FOR
      SELECT nic_nicho, nic_numero, nic_zona, nic_caracteristica
        FROM BOD_NICHO
       ORDER BY nic_numero;
  END;

END PKG_BOD_NICHO;
/