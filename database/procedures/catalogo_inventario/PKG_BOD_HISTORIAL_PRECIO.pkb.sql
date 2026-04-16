-- ============================================================
-- PKG_BOD_HISTORIAL_PRECIO.pkb
-- ============================================================
CREATE OR REPLACE PACKAGE BODY PKG_BOD_HISTORIAL_PRECIO AS
 
  PROCEDURE REGISTRAR(
    p_pro_referencia IN VARCHAR2,
    p_nic_nicho      IN NUMBER,
    p_precio         IN NUMBER,
    p_fecha_inicio   IN DATE,
    p_id_out         OUT NUMBER
  ) IS
    v_ref       VARCHAR2(40);
    v_hip_nuevo NUMBER;
  BEGIN
    v_ref := TRIM(p_pro_referencia);
    IF v_ref IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'BOD_HISTORIAL_PRECIO: referencia obligatoria.');
    END IF;
    IF p_nic_nicho IS NULL THEN
      RAISE_APPLICATION_ERROR(-20002, 'BOD_HISTORIAL_PRECIO: nic_nicho obligatorio.');
    END IF;
    IF p_precio IS NULL OR p_precio <= 0 THEN
      RAISE_APPLICATION_ERROR(-20003, 'BOD_HISTORIAL_PRECIO: precio debe ser > 0.');
    END IF;
    IF p_fecha_inicio IS NULL THEN
      RAISE_APPLICATION_ERROR(-20004, 'BOD_HISTORIAL_PRECIO: fecha_inicio obligatoria.');
    END IF;
 
    -- Insertar nuevo precio sin fecha_final (queda vigente)
    INSERT INTO BOD_HISTORIAL_PRECIO(
        pro_referencia, nic_nicho, hip_precio, hip_fecha_inicio, hip_fecha_final)
    VALUES(v_ref, p_nic_nicho, p_precio, p_fecha_inicio, NULL)
    RETURNING hip_historial_precio INTO v_hip_nuevo;
 
    COMMIT;
    p_id_out := v_hip_nuevo;
  EXCEPTION
    WHEN OTHERS THEN ROLLBACK; RAISE;
  END REGISTRAR;
 
  -- Cierra el precio vigente actual poniendo hip_fecha_final = p_fecha_cierre.
  -- Se llama desde Precios.aspx al confirmar la recepcion de mercancia.
  PROCEDURE CERRAR_VIGENTE(
    p_pro_referencia IN VARCHAR2,
    p_nic_nicho      IN NUMBER,
    p_fecha_cierre   IN DATE
  ) IS
    v_ref VARCHAR2(40);
  BEGIN
    v_ref := TRIM(p_pro_referencia);
    IF v_ref IS NULL THEN
      RAISE_APPLICATION_ERROR(-20010, 'BOD_HISTORIAL_PRECIO: referencia obligatoria.');
    END IF;
    IF p_nic_nicho IS NULL THEN
      RAISE_APPLICATION_ERROR(-20011, 'BOD_HISTORIAL_PRECIO: nic_nicho obligatorio.');
    END IF;
    IF p_fecha_cierre IS NULL THEN
      RAISE_APPLICATION_ERROR(-20012, 'BOD_HISTORIAL_PRECIO: fecha_cierre obligatoria.');
    END IF;
 
    UPDATE BOD_HISTORIAL_PRECIO
       SET hip_fecha_final = p_fecha_cierre
     WHERE pro_referencia  = v_ref
       AND nic_nicho        = p_nic_nicho
       AND hip_fecha_final  IS NULL;
 
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN ROLLBACK; RAISE;
  END CERRAR_VIGENTE;
 
  PROCEDURE VIGENTE(
    p_pro_referencia IN VARCHAR2,
    p_nic_nicho      IN NUMBER,
    p_data           OUT SYS_REFCURSOR
  ) IS
    v_ref VARCHAR2(40);
  BEGIN
    v_ref := TRIM(p_pro_referencia);
    IF v_ref IS NULL THEN
      RAISE_APPLICATION_ERROR(-20005, 'BOD_HISTORIAL_PRECIO: referencia obligatoria.');
    END IF;
    IF p_nic_nicho IS NULL THEN
      RAISE_APPLICATION_ERROR(-20006, 'BOD_HISTORIAL_PRECIO: nic_nicho obligatorio.');
    END IF;
    OPEN p_data FOR
      SELECT h.hip_historial_precio,
             h.pro_referencia,
             h.nic_nicho,
             h.hip_precio,
             h.hip_fecha_inicio,
             h.hip_fecha_final
        FROM BOD_HISTORIAL_PRECIO h
       WHERE h.pro_referencia = v_ref
         AND h.nic_nicho      = p_nic_nicho
         AND h.hip_fecha_final IS NULL
       FETCH FIRST 1 ROWS ONLY;
  END VIGENTE;
 
 
  -- Lista todos los registros con datos legibles via JOIN
  PROCEDURE LISTAR_TODOS(p_data OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN p_data FOR
      SELECT h.hip_historial_precio,
             h.pro_referencia,
             p.pro_nombre,
             h.nic_nicho,
             n.nic_numero,
             n.nic_caracteristica,
             h.hip_precio,
             h.hip_fecha_inicio,
             h.hip_fecha_final
        FROM BOD_HISTORIAL_PRECIO h
        JOIN BOD_PRODUCTO         p ON p.pro_referencia = h.pro_referencia
        JOIN BOD_NICHO            n ON n.nic_nicho      = h.nic_nicho
       ORDER BY h.hip_fecha_inicio DESC, h.hip_historial_precio DESC;
  END;
 
  -- Lista historial de un producto con datos legibles
  PROCEDURE LISTAR_POR_PRODUCTO(p_pro_referencia IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
    v_ref VARCHAR2(40);
  BEGIN
    v_ref := TRIM(p_pro_referencia);
    IF v_ref IS NULL THEN RAISE_APPLICATION_ERROR(-20007, 'BOD_HISTORIAL_PRECIO: referencia obligatoria.'); END IF;
    OPEN p_data FOR
      SELECT h.hip_historial_precio,
             h.pro_referencia,
             p.pro_nombre,
             h.nic_nicho,
             n.nic_numero,
             n.nic_caracteristica,
             h.hip_precio,
             h.hip_fecha_inicio,
             h.hip_fecha_final
        FROM BOD_HISTORIAL_PRECIO h
        JOIN BOD_PRODUCTO         p ON p.pro_referencia = h.pro_referencia
        JOIN BOD_NICHO            n ON n.nic_nicho      = h.nic_nicho
       WHERE h.pro_referencia = v_ref
       ORDER BY h.hip_fecha_inicio DESC;
  END;
 
  -- Solo precios activos (sin fecha_final) con datos legibles
  PROCEDURE LISTAR_VIGENTES(p_data OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN p_data FOR
      SELECT h.hip_historial_precio,
             h.pro_referencia,
             p.pro_nombre,
             h.nic_nicho,
             n.nic_numero,
             n.nic_caracteristica,
             h.hip_precio,
             h.hip_fecha_inicio
        FROM BOD_HISTORIAL_PRECIO h
        JOIN BOD_PRODUCTO         p ON p.pro_referencia = h.pro_referencia
        JOIN BOD_NICHO            n ON n.nic_nicho      = h.nic_nicho
       WHERE h.hip_fecha_final IS NULL
       ORDER BY p.pro_nombre, n.nic_numero;
  END;
 
  -- Solo precios cerrados de un mes especifico con datos legibles
  PROCEDURE LISTAR_POR_MES(p_mes IN NUMBER, p_anio IN NUMBER, p_data OUT SYS_REFCURSOR) IS
    v_inicio DATE;
    v_fin    DATE;
  BEGIN
    IF p_mes IS NULL OR p_mes < 1 OR p_mes > 12 THEN
      RAISE_APPLICATION_ERROR(-20008, 'BOD_HISTORIAL_PRECIO: mes debe ser entre 1 y 12.');
    END IF;
    IF p_anio IS NULL OR p_anio < 2000 THEN
      RAISE_APPLICATION_ERROR(-20009, 'BOD_HISTORIAL_PRECIO: anio invalido.');
    END IF;
    v_inicio := TRUNC(TO_DATE(p_mes || '/' || p_anio, 'MM/YYYY'), 'MM');
    v_fin    := LAST_DAY(v_inicio);
    OPEN p_data FOR
      SELECT h.hip_historial_precio,
             h.pro_referencia,
             p.pro_nombre,
             h.nic_nicho,
             n.nic_numero,
             n.nic_caracteristica,
             h.hip_precio,
             h.hip_fecha_inicio,
             h.hip_fecha_final
        FROM BOD_HISTORIAL_PRECIO h
        JOIN BOD_PRODUCTO         p ON p.pro_referencia = h.pro_referencia
        JOIN BOD_NICHO            n ON n.nic_nicho      = h.nic_nicho
       WHERE h.hip_fecha_final IS NOT NULL
         AND h.hip_fecha_inicio <= v_fin
         AND h.hip_fecha_final  >= v_inicio
       ORDER BY p.pro_nombre, h.hip_fecha_inicio DESC;
  END;
 
END PKG_BOD_HISTORIAL_PRECIO;
/