 -- =========================
 --BODY
  -- =========================
  CREATE OR REPLACE PACKAGE BODY PKG_CI_PRODUCTO AS

  PROCEDURE assert_txt(p_val IN VARCHAR2, p_msg IN VARCHAR2) IS
  BEGIN
    IF TRIM(p_val) IS NULL THEN
      RAISE_APPLICATION_ERROR(-20101, p_msg);
    END IF;
  END;

  PROCEDURE assert_num(p_val IN NUMBER, p_msg IN VARCHAR2) IS
  BEGIN
    IF p_val IS NULL THEN
      RAISE_APPLICATION_ERROR(-20102, p_msg);
    END IF;
  END;

  PROCEDURE PRO_CREAR(
    p_referencia     IN VARCHAR2,
    p_nombre         IN VARCHAR2,
    p_descripcion    IN VARCHAR2,
    p_tip_tipo       IN NUMBER,
    p_mat_material   IN NUMBER,
    p_alto_cm        IN NUMBER,
    p_ancho_cm       IN NUMBER,
    p_profundidad_cm IN NUMBER,
    p_color          IN VARCHAR2,
    p_peso           IN NUMBER,
    p_foto           IN BLOB
  ) IS
  BEGIN
    assert_txt(p_referencia, 'Producto: referencia obligatoria.');
    assert_txt(p_nombre, 'Producto: nombre obligatorio.');
    assert_num(p_tip_tipo, 'Producto: tipo obligatorio.');
    assert_num(p_mat_material, 'Producto: material obligatorio.');
    assert_num(p_alto_cm, 'Producto: alto obligatorio.');
    assert_num(p_ancho_cm, 'Producto: ancho obligatorio.');
    assert_num(p_profundidad_cm, 'Producto: profundidad obligatoria.');
    assert_num(p_peso, 'Producto: peso obligatorio.');

    IF p_alto_cm <= 0 OR p_ancho_cm <= 0 OR p_profundidad_cm <= 0 THEN
      RAISE_APPLICATION_ERROR(-20103, 'Producto: dimensiones deben ser mayores a 0.');
    END IF;

    IF p_peso <= 0 THEN
      RAISE_APPLICATION_ERROR(-20104, 'Producto: peso debe ser mayor a 0.');
    END IF;

    INSERT INTO BOD_PRODUCTO(
      pro_referencia, pro_nombre, pro_descripcion,
      tip_tipo, mat_material,
      pro_alto_cm, pro_ancho_cm, pro_profundidad_cm,
      pro_color, pro_peso, pro_foto
    ) VALUES (
      TRIM(p_referencia), TRIM(p_nombre), p_descripcion,
      p_tip_tipo, p_mat_material,
      p_alto_cm, p_ancho_cm, p_profundidad_cm,
      p_color, p_peso, p_foto
    );
  END;

  PROCEDURE PRO_ACTUALIZAR(
    p_referencia     IN VARCHAR2,
    p_nombre         IN VARCHAR2,
    p_descripcion    IN VARCHAR2,
    p_tip_tipo       IN NUMBER,
    p_mat_material   IN NUMBER,
    p_alto_cm        IN NUMBER,
    p_ancho_cm       IN NUMBER,
    p_profundidad_cm IN NUMBER,
    p_color          IN VARCHAR2,
    p_peso           IN NUMBER
  ) IS
  BEGIN
    assert_txt(p_referencia, 'Producto: referencia obligatoria.');
    assert_txt(p_nombre, 'Producto: nombre obligatorio.');
    assert_num(p_tip_tipo, 'Producto: tipo obligatorio.');
    assert_num(p_mat_material, 'Producto: material obligatorio.');
    assert_num(p_alto_cm, 'Producto: alto obligatorio.');
    assert_num(p_ancho_cm, 'Producto: ancho obligatorio.');
    assert_num(p_profundidad_cm, 'Producto: profundidad obligatoria.');
    assert_num(p_peso, 'Producto: peso obligatorio.');

    UPDATE BOD_PRODUCTO
       SET pro_nombre         = TRIM(p_nombre),
           pro_descripcion    = p_descripcion,
           tip_tipo           = p_tip_tipo,
           mat_material       = p_mat_material,
           pro_alto_cm        = p_alto_cm,
           pro_ancho_cm       = p_ancho_cm,
           pro_profundidad_cm = p_profundidad_cm,
           pro_color          = p_color,
           pro_peso           = p_peso
     WHERE pro_referencia = TRIM(p_referencia);

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20105, 'Producto no existe.');
    END IF;
  END;

  PROCEDURE PRO_ACTUALIZAR_FOTO(
    p_referencia IN VARCHAR2,
    p_foto       IN BLOB
  ) IS
  BEGIN
    assert_txt(p_referencia, 'Producto: referencia obligatoria.');
    UPDATE BOD_PRODUCTO
       SET pro_foto = p_foto
     WHERE pro_referencia = TRIM(p_referencia);

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20106, 'Producto no existe para actualizar foto.');
    END IF;
  END;

  PROCEDURE PRO_ELIMINAR(p_referencia IN VARCHAR2) IS
    v_used1 NUMBER;
    v_used2 NUMBER;
  BEGIN
    assert_txt(p_referencia, 'Producto: referencia obligatoria.');

    -- No eliminar si tiene historial precio
    SELECT COUNT(1) INTO v_used1
      FROM BOD_HISTORIAL_PRECIO
     WHERE pro_referencia = TRIM(p_referencia);

    -- No eliminar si tiene promociones
    SELECT COUNT(1) INTO v_used2
      FROM PROMO_PROMOCION
     WHERE pro_referencia = TRIM(p_referencia);

    IF v_used1 > 0 OR v_used2 > 0 THEN
      RAISE_APPLICATION_ERROR(-20107, 'No se puede eliminar: producto tiene historial de precio o promociones.');
    END IF;

    DELETE FROM BOD_PRODUCTO WHERE pro_referencia = TRIM(p_referencia);

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20108, 'Producto no existe.');
    END IF;
  END;

  PROCEDURE PRO_OBTENER(p_referencia IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
  BEGIN
    assert_txt(p_referencia, 'Producto: referencia obligatoria.');

    OPEN p_data FOR
      SELECT pro_referencia, pro_nombre, pro_descripcion,
             tip_tipo, mat_material,
             pro_alto_cm, pro_ancho_cm, pro_profundidad_cm,
             pro_color, pro_peso
        FROM BOD_PRODUCTO
       WHERE pro_referencia = TRIM(p_referencia);
  END;

  PROCEDURE PRO_LISTAR(p_data OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN p_data FOR
      SELECT pro_referencia, pro_nombre,
             tip_tipo, mat_material,
             pro_color, pro_peso
        FROM BOD_PRODUCTO
       ORDER BY pro_nombre;
  END;

  PROCEDURE PRO_BUSCAR(p_texto IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
    v_txt VARCHAR2(4000);
  BEGIN
    v_txt := '%' || UPPER(TRIM(NVL(p_texto,''))) || '%';

    OPEN p_data FOR
      SELECT pro_referencia, pro_nombre, pro_descripcion,
             tip_tipo, mat_material, pro_color, pro_peso
        FROM BOD_PRODUCTO
       WHERE UPPER(pro_nombre) LIKE v_txt
          OR UPPER(pro_referencia) LIKE v_txt
       ORDER BY pro_nombre;
  END;

  PROCEDURE PRO_OBTENER_FOTO(p_referencia IN VARCHAR2, p_foto OUT BLOB) IS
  BEGIN
    assert_txt(p_referencia, 'Producto: referencia obligatoria.');
    SELECT pro_foto INTO p_foto
      FROM BOD_PRODUCTO
     WHERE pro_referencia = TRIM(p_referencia);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20109, 'Producto no existe para obtener foto.');
  END;

END PKG_CI_PRODUCTO;
/