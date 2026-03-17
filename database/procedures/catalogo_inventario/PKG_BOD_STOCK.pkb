CREATE OR REPLACE PACKAGE BODY PKG_BOD_STOCK AS

  PROCEDURE GUARDAR(
    p_hip_historial_precio IN NUMBER,
    p_minimo               IN NUMBER,
    p_maximo               IN NUMBER,
    p_reservado            IN NUMBER,
    p_disponible           IN NUMBER
  ) IS
    v_exists NUMBER;
  BEGIN
    IF p_hip_historial_precio IS NULL THEN
      RAISE_APPLICATION_ERROR(-21801, 'BOD_STOCK: hip_historial_precio obligatorio.');
    END IF;

    IF p_minimo IS NULL OR p_maximo IS NULL OR p_reservado IS NULL OR p_disponible IS NULL THEN
      RAISE_APPLICATION_ERROR(-21802, 'BOD_STOCK: minimo/maximo/reservado/disponible obligatorios.');
    END IF;

    IF p_minimo < 0 OR p_maximo < 0 OR p_reservado < 0 OR p_disponible < 0 THEN
      RAISE_APPLICATION_ERROR(-21803, 'BOD_STOCK: valores no pueden ser negativos.');
    END IF;

    IF p_minimo > p_maximo THEN
      RAISE_APPLICATION_ERROR(-21804, 'BOD_STOCK: minimo no puede ser mayor a maximo.');
    END IF;

    IF p_reservado > p_disponible THEN
      RAISE_APPLICATION_ERROR(-21805, 'BOD_STOCK: reservado no puede ser mayor a disponible.');
    END IF;

    SELECT COUNT(1) INTO v_exists
      FROM BOD_STOCK
     WHERE hip_historial_precio = p_hip_historial_precio;

    IF v_exists = 0 THEN
      INSERT INTO BOD_STOCK(hip_historial_precio, sto_minimo, sto_maximo, sto_reservado, sto_disponible)
      VALUES(p_hip_historial_precio, p_minimo, p_maximo, p_reservado, p_disponible);
    ELSE
      UPDATE BOD_STOCK
         SET sto_minimo = p_minimo,
             sto_maximo = p_maximo,
             sto_reservado = p_reservado,
             sto_disponible = p_disponible
       WHERE hip_historial_precio = p_hip_historial_precio;
    END IF;
  END;

  PROCEDURE OBTENER(p_hip_historial_precio IN NUMBER, p_data OUT SYS_REFCURSOR) IS
  BEGIN
    IF p_hip_historial_precio IS NULL THEN
      RAISE_APPLICATION_ERROR(-21806, 'BOD_STOCK: hip_historial_precio obligatorio.');
    END IF;

    OPEN p_data FOR
      SELECT sto_stock, hip_historial_precio, sto_minimo, sto_maximo, sto_reservado, sto_disponible
        FROM BOD_STOCK
       WHERE hip_historial_precio = p_hip_historial_precio;
  END;

END PKG_BOD_STOCK;
/