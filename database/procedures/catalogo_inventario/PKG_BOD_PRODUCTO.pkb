CREATE OR REPLACE PACKAGE BODY PKG_BOD_PRODUCTO AS

  PROCEDURE CREAR(
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
    v_ref VARCHAR2(40);
  BEGIN
    v_ref := TRIM(p_referencia);

    IF v_ref IS NULL THEN RAISE_APPLICATION_ERROR(-21301, 'BOD_PRODUCTO: referencia obligatoria.'); END IF;
    IF TRIM(p_nombre) IS NULL THEN RAISE_APPLICATION_ERROR(-21302, 'BOD_PRODUCTO: nombre obligatorio.'); END IF;
    IF p_tip_tipo IS NULL THEN RAISE_APPLICATION_ERROR(-21303, 'BOD_PRODUCTO: tip_tipo obligatorio.'); END IF;
    IF p_mat_material IS NULL THEN RAISE_APPLICATION_ERROR(-21304, 'BOD_PRODUCTO: mat_material obligatorio.'); END IF;

    IF p_alto_cm <= 0 OR p_ancho_cm <= 0 OR p_profundidad_cm <= 0 THEN
      RAISE_APPLICATION_ERROR(-21305, 'BOD_PRODUCTO: dimensiones deben ser > 0.');
    END IF;
    IF p_peso IS NULL OR p_peso <= 0 THEN
      RAISE_APPLICATION_ERROR(-21306, 'BOD_PRODUCTO: peso debe ser > 0.');
    END IF;

    INSERT INTO BOD_PRODUCTO(
      pro_referencia, pro_nombre, pro_descripcion,
      tip_tipo, mat_material,
      pro_alto_cm, pro_ancho_cm, pro_profundidad_cm,
      pro_color, pro_peso, pro_foto
    )
    VALUES(
      v_ref, TRIM(p_nombre), p_descripcion,
      p_tip_tipo, p_mat_material,
      p_alto_cm, p_ancho_cm, p_profundidad_cm,
      p_color, p_peso, p_foto
    );
  END;

  PROCEDURE ACTUALIZAR(
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
    v_ref VARCHAR2(40);
  BEGIN
    v_ref := TRIM(p_referencia);

    IF v_ref IS NULL THEN RAISE_APPLICATION_ERROR(-21307, 'BOD_PRODUCTO: referencia obligatoria.'); END IF;
    IF TRIM(p_nombre) IS NULL THEN RAISE_APPLICATION_ERROR(-21308, 'BOD_PRODUCTO: nombre obligatorio.'); END IF;
    IF p_tip_tipo IS NULL THEN RAISE_APPLICATION_ERROR(-21309, 'BOD_PRODUCTO: tip_tipo obligatorio.'); END IF;
    IF p_mat_material IS NULL THEN RAISE_APPLICATION_ERROR(-21310, 'BOD_PRODUCTO: mat_material obligatorio.'); END IF;

    IF p_alto_cm <= 0 OR p_ancho_cm <= 0 OR p_profundidad_cm <= 0 THEN
      RAISE_APPLICATION_ERROR(-21311, 'BOD_PRODUCTO: dimensiones deben ser > 0.');
    END IF;
    IF p_peso IS NULL OR p_peso <= 0 THEN
      RAISE_APPLICATION_ERROR(-21312, 'BOD_PRODUCTO: peso debe ser > 0.');
    END IF;

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
     WHERE pro_referencia = v_ref;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-21313, 'BOD_PRODUCTO: no existe.');
    END IF;
  END;

  PROCEDURE ACTUALIZAR_FOTO(p_referencia IN VARCHAR2, p_foto IN BLOB) IS
    v_ref VARCHAR2(40);
  BEGIN
    v_ref := TRIM(p_referencia);
    IF v_ref IS NULL THEN
      RAISE_APPLICATION_ERROR(-21314, 'BOD_PRODUCTO: referencia obligatoria.');
    END IF;

    UPDATE BOD_PRODUCTO
       SET pro_foto = p_foto
     WHERE pro_referencia = v_ref;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-21315, 'BOD_PRODUCTO: no existe para actualizar foto.');
    END IF;
  END;

  PROCEDURE ELIMINAR(p_referencia IN VARCHAR2) IS
    v_ref  VARCHAR2(40);
    v_used NUMBER;
  BEGIN
    v_ref := TRIM(p_referencia);
    IF v_ref IS NULL THEN
      RAISE_APPLICATION_ERROR(-21316, 'BOD_PRODUCTO: referencia obligatoria.');
    END IF;

    SELECT COUNT(1) INTO v_used FROM BOD_HISTORIAL_PRECIO WHERE pro_referencia = v_ref;
    IF v_used > 0 THEN
      RAISE_APPLICATION_ERROR(-21317, 'BOD_PRODUCTO: no se puede eliminar, tiene historial de precio.');
    END IF;

    SELECT COUNT(1) INTO v_used FROM PROMO_PROMOCION WHERE pro_referencia = v_ref;
    IF v_used > 0 THEN
      RAISE_APPLICATION_ERROR(-21318, 'BOD_PRODUCTO: no se puede eliminar, tiene promociones.');
    END IF;

    DELETE FROM BOD_PRODUCTO WHERE pro_referencia = v_ref;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-21319, 'BOD_PRODUCTO: no existe.');
    END IF;
  END;

  PROCEDURE OBTENER(p_referencia IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
    v_ref VARCHAR2(40);
  BEGIN
    v_ref := TRIM(p_referencia);
    IF v_ref IS NULL THEN
      RAISE_APPLICATION_ERROR(-21320, 'BOD_PRODUCTO: referencia obligatoria.');
    END IF;

    OPEN p_data FOR
      SELECT pro_referencia, pro_nombre, pro_descripcion,
             tip_tipo, mat_material,
             pro_alto_cm, pro_ancho_cm, pro_profundidad_cm,
             pro_color, pro_peso
        FROM BOD_PRODUCTO
       WHERE pro_referencia = v_ref;
  END;

  PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN p_data FOR
      SELECT pro_referencia, pro_nombre, tip_tipo, mat_material, pro_color, pro_peso
        FROM BOD_PRODUCTO
       ORDER BY pro_nombre;
  END;

  PROCEDURE BUSCAR(p_texto IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
    v_txt VARCHAR2(4000);
  BEGIN
    v_txt := '%' || UPPER(TRIM(NVL(p_texto,''))) || '%';

    OPEN p_data FOR
      SELECT pro_referencia, pro_nombre, pro_descripcion,
             tip_tipo, mat_material, pro_color, pro_peso
        FROM BOD_PRODUCTO
       WHERE UPPER(pro_referencia) LIKE v_txt
          OR UPPER(pro_nombre) LIKE v_txt
       ORDER BY pro_nombre;
  END;

  PROCEDURE OBTENER_FOTO(p_referencia IN VARCHAR2, p_foto OUT BLOB) IS
    v_ref VARCHAR2(40);
  BEGIN
    v_ref := TRIM(p_referencia);
    IF v_ref IS NULL THEN
      RAISE_APPLICATION_ERROR(-21321, 'BOD_PRODUCTO: referencia obligatoria.');
    END IF;

    SELECT pro_foto INTO p_foto
      FROM BOD_PRODUCTO
     WHERE pro_referencia = v_ref;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-21322, 'BOD_PRODUCTO: no existe para obtener foto.');
  END;

END PKG_BOD_PRODUCTO;
/