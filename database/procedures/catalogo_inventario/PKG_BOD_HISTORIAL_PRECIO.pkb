CREATE OR REPLACE PACKAGE BODY PKG_BOD_HISTORIAL_PRECIO AS

  PROCEDURE REGISTRAR(
    p_pro_referencia IN VARCHAR2,
    p_nic_nicho      IN NUMBER,
    p_precio         IN NUMBER,
    p_fecha_inicio   IN DATE,
    p_id_out         OUT NUMBER
  ) IS
    v_ref VARCHAR2(40);
  BEGIN
    v_ref := TRIM(p_pro_referencia);

    IF v_ref IS NULL THEN RAISE_APPLICATION_ERROR(-21701, 'BOD_HISTORIAL_PRECIO: referencia obligatoria.'); END IF;
    IF p_nic_nicho IS NULL THEN RAISE_APPLICATION_ERROR(-21702, 'BOD_HISTORIAL_PRECIO: nic_nicho obligatorio.'); END IF;
    IF p_precio IS NULL OR p_precio <= 0 THEN RAISE_APPLICATION_ERROR(-21703, 'BOD_HISTORIAL_PRECIO: precio debe ser > 0.'); END IF;
    IF p_fecha_inicio IS NULL THEN RAISE_APPLICATION_ERROR(-21704, 'BOD_HISTORIAL_PRECIO: fecha_inicio obligatoria.'); END IF;

    -- cerrar vigente anterior del mismo producto+nicho
    UPDATE BOD_HISTORIAL_PRECIO
       SET hip_fecha_final = p_fecha_inicio - (1/86400)
     WHERE pro_referencia = v_ref
       AND nic_nicho = p_nic_nicho
       AND hip_fecha_inicio <= p_fecha_inicio
       AND (hip_fecha_final IS NULL OR hip_fecha_final >= p_fecha_inicio);

    INSERT INTO BOD_HISTORIAL_PRECIO(pro_referencia, nic_nicho, hip_precio, hip_fecha_inicio, hip_fecha_final)
    VALUES(v_ref, p_nic_nicho, p_precio, p_fecha_inicio, NULL)
    RETURNING hip_historial_precio INTO p_id_out;
  END;

  PROCEDURE VIGENTE(
    p_pro_referencia IN VARCHAR2,
    p_nic_nicho      IN NUMBER,
    p_data           OUT SYS_REFCURSOR
  ) IS
    v_ref VARCHAR2(40);
  BEGIN
    v_ref := TRIM(p_pro_referencia);

    IF v_ref IS NULL THEN RAISE_APPLICATION_ERROR(-21705, 'BOD_HISTORIAL_PRECIO: referencia obligatoria.'); END IF;
    IF p_nic_nicho IS NULL THEN RAISE_APPLICATION_ERROR(-21706, 'BOD_HISTORIAL_PRECIO: nic_nicho obligatorio.'); END IF;

    OPEN p_data FOR
      SELECT hip_historial_precio, pro_referencia, nic_nicho,
             hip_precio, hip_fecha_inicio, hip_fecha_final
        FROM BOD_HISTORIAL_PRECIO
       WHERE pro_referencia = v_ref
         AND nic_nicho = p_nic_nicho
         AND hip_fecha_inicio <= SYSDATE
         AND (hip_fecha_final IS NULL OR hip_fecha_final >= SYSDATE)
       ORDER BY hip_fecha_inicio DESC, hip_historial_precio DESC
       FETCH FIRST 1 ROWS ONLY;
  END;

  PROCEDURE LISTAR_POR_PRODUCTO(
    p_pro_referencia IN VARCHAR2,
    p_data           OUT SYS_REFCURSOR
  ) IS
    v_ref VARCHAR2(40);
  BEGIN
    v_ref := TRIM(p_pro_referencia);
    IF v_ref IS NULL THEN
      RAISE_APPLICATION_ERROR(-21707, 'BOD_HISTORIAL_PRECIO: referencia obligatoria.');
    END IF;

    OPEN p_data FOR
      SELECT hip_historial_precio, pro_referencia, nic_nicho,
             hip_precio, hip_fecha_inicio, hip_fecha_final
        FROM BOD_HISTORIAL_PRECIO
       WHERE pro_referencia = v_ref
       ORDER BY hip_fecha_inicio DESC, hip_historial_precio DESC;
  END;

END PKG_BOD_HISTORIAL_PRECIO;
/