-- ============================================================
-- PKG_BOD_STOCK.pkb
-- ============================================================
CREATE OR REPLACE PACKAGE BODY PKG_BOD_STOCK AS
 
  PROCEDURE GUARDAR(
    p_hip_historial_precio IN NUMBER,
    p_minimo               IN NUMBER,
    p_maximo               IN NUMBER,
    p_disponible           IN NUMBER
  ) IS
    v_exists NUMBER;
  BEGIN
    IF p_hip_historial_precio IS NULL THEN RAISE_APPLICATION_ERROR(-20001, 'BOD_STOCK: hip_historial_precio obligatorio.'); END IF;
    IF p_minimo IS NULL OR p_maximo IS NULL OR p_disponible IS NULL THEN
      RAISE_APPLICATION_ERROR(-20002, 'BOD_STOCK: todos los valores son obligatorios.');
    END IF;
    IF p_minimo < 0 OR p_maximo < 0 OR p_disponible < 0 THEN
      RAISE_APPLICATION_ERROR(-20003, 'BOD_STOCK: valores no pueden ser negativos.');
    END IF;
    IF p_minimo > p_maximo THEN
      RAISE_APPLICATION_ERROR(-20004, 'BOD_STOCK: minimo no puede ser mayor a maximo.');
    END IF;
 
    SELECT COUNT(1) INTO v_exists
      FROM BOD_STOCK
     WHERE hip_historial_precio = p_hip_historial_precio;
 
    IF v_exists = 0 THEN
      INSERT INTO BOD_STOCK(hip_historial_precio, sto_minimo, sto_maximo, sto_disponible)
      VALUES(p_hip_historial_precio, p_minimo, p_maximo, p_disponible);
    ELSE
      UPDATE BOD_STOCK
         SET sto_minimo     = p_minimo,
             sto_maximo     = p_maximo,
             sto_disponible = p_disponible
       WHERE hip_historial_precio = p_hip_historial_precio;
    END IF;
  END;
 
  PROCEDURE OBTENER(p_hip_historial_precio IN NUMBER, p_data OUT SYS_REFCURSOR) IS
  BEGIN
    IF p_hip_historial_precio IS NULL THEN
      RAISE_APPLICATION_ERROR(-20005, 'BOD_STOCK: hip_historial_precio obligatorio.');
    END IF;
    OPEN p_data FOR
      SELECT s.sto_stock,
             s.hip_historial_precio,
             s.sto_minimo,
             s.sto_maximo,
             s.sto_disponible,
             p.pro_referencia,
             p.pro_nombre,
             n.nic_numero,
             n.nic_caracteristica,
             a.alm_nombre,
             h.hip_precio,
             h.hip_fecha_inicio
        FROM BOD_STOCK            s
        JOIN BOD_HISTORIAL_PRECIO h  ON h.hip_historial_precio = s.hip_historial_precio
        JOIN BOD_PRODUCTO         p  ON p.pro_referencia       = h.pro_referencia
        JOIN BOD_NICHO            n  ON n.nic_nicho            = h.nic_nicho
        JOIN BOD_NIC_ALM          na ON na.nic_nicho           = n.nic_nicho
        JOIN BOD_ALMACEN          a  ON a.alm_almacen          = na.alm_almacen
       WHERE s.hip_historial_precio = p_hip_historial_precio;
  END;
 
  PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN p_data FOR
      SELECT s.sto_stock,
             s.hip_historial_precio,
             p.pro_referencia,
             p.pro_nombre,
             n.nic_numero,
             n.nic_caracteristica,
             a.alm_nombre,
             h.hip_precio,
             h.hip_fecha_inicio,
             s.sto_minimo,
             s.sto_maximo,
             s.sto_disponible,
             CASE
               WHEN s.sto_disponible <= s.sto_minimo THEN 'BAJO'
               WHEN s.sto_disponible >= s.sto_maximo THEN 'ALTO'
               ELSE 'NORMAL'
             END AS estado_stock
        FROM BOD_STOCK            s
        JOIN BOD_HISTORIAL_PRECIO h  ON h.hip_historial_precio = s.hip_historial_precio
        JOIN BOD_PRODUCTO         p  ON p.pro_referencia       = h.pro_referencia
        JOIN BOD_NICHO            n  ON n.nic_nicho            = h.nic_nicho
        JOIN BOD_NIC_ALM          na ON na.nic_nicho           = n.nic_nicho
        JOIN BOD_ALMACEN          a  ON a.alm_almacen          = na.alm_almacen
       ORDER BY p.pro_nombre, a.alm_nombre, n.nic_numero;
  END;
 
  PROCEDURE LISTAR_POR_PRODUCTO(p_pro_referencia IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
    v_ref VARCHAR2(40);
  BEGIN
    v_ref := TRIM(p_pro_referencia);
    IF v_ref IS NULL THEN
      RAISE_APPLICATION_ERROR(-20006, 'BOD_STOCK: pro_referencia obligatorio.');
    END IF;
    OPEN p_data FOR
      SELECT s.sto_stock,
             s.hip_historial_precio,
             p.pro_referencia,
             p.pro_nombre,
             n.nic_numero,
             n.nic_caracteristica,
             a.alm_nombre,
             h.hip_precio,
             h.hip_fecha_inicio,
             s.sto_minimo,
             s.sto_maximo,
             s.sto_disponible,
             CASE
               WHEN s.sto_disponible <= s.sto_minimo THEN 'BAJO'
               WHEN s.sto_disponible >= s.sto_maximo THEN 'ALTO'
               ELSE 'NORMAL'
             END AS estado_stock
        FROM BOD_STOCK            s
        JOIN BOD_HISTORIAL_PRECIO h  ON h.hip_historial_precio = s.hip_historial_precio
        JOIN BOD_PRODUCTO         p  ON p.pro_referencia       = h.pro_referencia
        JOIN BOD_NICHO            n  ON n.nic_nicho            = h.nic_nicho
        JOIN BOD_NIC_ALM          na ON na.nic_nicho           = n.nic_nicho
        JOIN BOD_ALMACEN          a  ON a.alm_almacen          = na.alm_almacen
       WHERE h.pro_referencia = v_ref
       ORDER BY a.alm_nombre, n.nic_numero;
  END;
 
  -- Suma cantidad al disponible — llamado desde Compras al recibir mercancia
  PROCEDURE ENTRADA(p_hip_historial_precio IN NUMBER, p_cantidad IN NUMBER) IS
    v_exists NUMBER;
  BEGIN
    IF p_hip_historial_precio IS NULL THEN
      RAISE_APPLICATION_ERROR(-20007, 'BOD_STOCK: hip_historial_precio obligatorio.');
    END IF;
    IF p_cantidad IS NULL OR p_cantidad <= 0 THEN
      RAISE_APPLICATION_ERROR(-20008, 'BOD_STOCK: cantidad debe ser mayor a 0.');
    END IF;
 
    SELECT COUNT(1) INTO v_exists
      FROM BOD_STOCK
     WHERE hip_historial_precio = p_hip_historial_precio;
 
    IF v_exists = 0 THEN
      RAISE_APPLICATION_ERROR(-20009, 'BOD_STOCK: no existe registro de stock para este historial. Registra el stock primero.');
    END IF;
 
    UPDATE BOD_STOCK
       SET sto_disponible = sto_disponible + p_cantidad
     WHERE hip_historial_precio = p_hip_historial_precio;
  END;
 
  -- Resta cantidad del disponible — llamado desde Ventas al facturar
  PROCEDURE SALIDA(p_hip_historial_precio IN NUMBER, p_cantidad IN NUMBER) IS
    v_disponible NUMBER;
  BEGIN
    IF p_hip_historial_precio IS NULL THEN
      RAISE_APPLICATION_ERROR(-20010, 'BOD_STOCK: hip_historial_precio obligatorio.');
    END IF;
    IF p_cantidad IS NULL OR p_cantidad <= 0 THEN
      RAISE_APPLICATION_ERROR(-20011, 'BOD_STOCK: cantidad debe ser mayor a 0.');
    END IF;
 
    SELECT sto_disponible INTO v_disponible
      FROM BOD_STOCK
     WHERE hip_historial_precio = p_hip_historial_precio;
 
    IF v_disponible < p_cantidad THEN
      RAISE_APPLICATION_ERROR(-20012, 'BOD_STOCK: stock insuficiente. Disponible: ' || v_disponible);
    END IF;
 
    UPDATE BOD_STOCK
       SET sto_disponible = sto_disponible - p_cantidad
     WHERE hip_historial_precio = p_hip_historial_precio;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20013, 'BOD_STOCK: no existe registro de stock para este historial.');
  END;
 
END PKG_BOD_STOCK;
/