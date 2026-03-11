 -- =========================
 --BODY
  -- =========================
  CREATE OR REPLACE PACKAGE BODY PKG_CI_PRECIO_STOCK AS

  PROCEDURE PRECIO_REGISTRAR(
    p_pro_referencia IN VARCHAR2,
    p_nic_nicho      IN NUMBER,
    p_precio         IN NUMBER,
    p_fecha_inicio   IN DATE,
    p_id_out         OUT NUMBER
  ) IS
    v_ref VARCHAR2(40);
  BEGIN
    v_ref := TRIM(p_pro_referencia);

    IF v_ref IS NULL THEN RAISE_APPLICATION_ERROR(-20301, 'Precio: referencia obligatoria.'); END IF;
    IF p_nic_nicho IS NULL THEN RAISE_APPLICATION_ERROR(-20302, 'Precio: nicho obligatorio.'); END IF;
    IF p_precio IS NULL OR p_precio <= 0 THEN RAISE_APPLICATION_ERROR(-20303, 'Precio: valor debe ser > 0.'); END IF;
    IF p_fecha_inicio IS NULL THEN RAISE_APPLICATION_ERROR(-20304, 'Precio: fecha inicio obligatoria.'); END IF;

    -- Cerrar vigente anterior (mismo producto+nicho) si existe
    UPDATE BOD_HISTORIAL_PRECIO
       SET hip_fecha_final = p_fecha_inicio - (1/86400) -- 1 segundo antes
     WHERE pro_referencia = v_ref
       AND nic_nicho = p_nic_nicho
       AND hip_fecha_inicio <= p_fecha_inicio
       AND (hip_fecha_final IS NULL OR hip_fecha_final >= p_fecha_inicio);

    INSERT INTO BOD_HISTORIAL_PRECIO(
      pro_referencia, nic_nicho, hip_precio, hip_fecha_inicio, hip_fecha_final
    ) VALUES (
      v_ref, p_nic_nicho, p_precio, p_fecha_inicio, NULL
    )
    RETURNING hip_historial_precio INTO p_id_out;
  END;

  PROCEDURE PRECIO_VIGENTE(
    p_pro_referencia IN VARCHAR2,
    p_nic_nicho      IN NUMBER,
    p_data           OUT SYS_REFCURSOR
  ) IS
    v_ref VARCHAR2(40);
  BEGIN
    v_ref := TRIM(p_pro_referencia);
    IF v_ref IS NULL THEN RAISE_APPLICATION_ERROR(-20305, 'Precio vigente: referencia obligatoria.'); END IF;
    IF p_nic_nicho IS NULL THEN RAISE_APPLICATION_ERROR(-20306, 'Precio vigente: nicho obligatorio.'); END IF;

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

  PROCEDURE PRECIO_LISTAR_POR_PRODUCTO(
    p_pro_referencia IN VARCHAR2,
    p_data           OUT SYS_REFCURSOR
  ) IS
    v_ref VARCHAR2(40);
  BEGIN
    v_ref := TRIM(p_pro_referencia);
    IF v_ref IS NULL THEN RAISE_APPLICATION_ERROR(-20307, 'Precio listar: referencia obligatoria.'); END IF;

    OPEN p_data FOR
      SELECT hip_historial_precio, pro_referencia, nic_nicho,
             hip_precio, hip_fecha_inicio, hip_fecha_final
        FROM BOD_HISTORIAL_PRECIO
       WHERE pro_referencia = v_ref
       ORDER BY hip_fecha_inicio DESC, hip_historial_precio DESC;
  END;

  PROCEDURE STOCK_GUARDAR(
    p_hip_historial_precio IN NUMBER,
    p_minimo               IN NUMBER,
    p_maximo               IN NUMBER,
    p_reservado            IN NUMBER,
    p_disponible           IN NUMBER
  ) IS
    v_exists NUMBER;
  BEGIN
    IF p_hip_historial_precio IS NULL THEN
      RAISE_APPLICATION_ERROR(-20308, 'Stock: hip_historial_precio obligatorio.');
    END IF;

    IF p_minimo IS NULL OR p_maximo IS NULL OR p_reservado IS NULL OR p_disponible IS NULL THEN
      RAISE_APPLICATION_ERROR(-20309, 'Stock: minimo/maximo/reservado/disponible son obligatorios.');
    END IF;

    IF p_minimo < 0 OR p_maximo < 0 OR p_reservado < 0 OR p_disponible < 0 THEN
      RAISE_APPLICATION_ERROR(-20310, 'Stock: valores no pueden ser negativos.');
    END IF;

    IF p_minimo > p_maximo THEN
      RAISE_APPLICATION_ERROR(-20311, 'Stock: minimo no puede ser mayor a maximo.');
    END IF;

    IF p_reservado > p_disponible THEN
      RAISE_APPLICATION_ERROR(-20312, 'Stock: reservado no puede ser mayor a disponible.');
    END IF;

    SELECT COUNT(1) INTO v_exists
      FROM BOD_STOCK
     WHERE hip_historial_precio = p_hip_historial_precio;

    IF v_exists = 0 THEN
      INSERT INTO BOD_STOCK(hip_historial_precio, sto_minimo, sto_maximo, sto_reservado, sto_disponible)
      VALUES (p_hip_historial_precio, p_minimo, p_maximo, p_reservado, p_disponible);
    ELSE
      UPDATE BOD_STOCK
         SET sto_minimo   = p_minimo,
             sto_maximo   = p_maximo,
             sto_reservado= p_reservado,
             sto_disponible = p_disponible
       WHERE hip_historial_precio = p_hip_historial_precio;
    END IF;
  END;

  PROCEDURE STOCK_OBTENER(
    p_hip_historial_precio IN NUMBER,
    p_data                 OUT SYS_REFCURSOR
  ) IS
  BEGIN
    IF p_hip_historial_precio IS NULL THEN
      RAISE_APPLICATION_ERROR(-20313, 'Stock obtener: hip_historial_precio obligatorio.');
    END IF;

    OPEN p_data FOR
      SELECT sto_stock, hip_historial_precio,
             sto_minimo, sto_maximo, sto_reservado, sto_disponible
        FROM BOD_STOCK
       WHERE hip_historial_precio = p_hip_historial_precio;
  END;

END PKG_CI_PRECIO_STOCK;
/