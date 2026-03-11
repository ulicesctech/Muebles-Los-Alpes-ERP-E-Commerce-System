 -- =========================
 --BODY
  -- =========================

CREATE OR REPLACE PACKAGE BODY PKG_CI_CATALOGOS AS

  -- Helpers
  PROCEDURE assert_not_null(p_val IN VARCHAR2, p_msg IN VARCHAR2) IS
  BEGIN
    IF TRIM(p_val) IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, p_msg);
    END IF;
  END;

  PROCEDURE assert_id(p_id IN NUMBER, p_msg IN VARCHAR2) IS
  BEGIN
    IF p_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20002, p_msg);
    END IF;
  END;

  -- =========================
  -- CATEGORIA
  -- =========================
  PROCEDURE CAT_CREAR(p_descripcion IN VARCHAR2, p_id OUT NUMBER) IS
  BEGIN
    assert_not_null(p_descripcion, 'Categoria: descripcion obligatoria.');
    INSERT INTO BOD_CATEGORIA(cat_descripcion)
    VALUES (TRIM(p_descripcion))
    RETURNING cat_categoria INTO p_id;
  END;

  PROCEDURE CAT_ACTUALIZAR(p_id IN NUMBER, p_descripcion IN VARCHAR2) IS
    v_exists NUMBER;
  BEGIN
    assert_id(p_id, 'Categoria: id obligatorio.');
    assert_not_null(p_descripcion, 'Categoria: descripcion obligatoria.');

    SELECT COUNT(1) INTO v_exists FROM BOD_CATEGORIA WHERE cat_categoria = p_id;
    IF v_exists = 0 THEN RAISE_APPLICATION_ERROR(-20003, 'Categoria no existe.'); END IF;

    UPDATE BOD_CATEGORIA
       SET cat_descripcion = TRIM(p_descripcion)
     WHERE cat_categoria = p_id;
  END;

  PROCEDURE CAT_ELIMINAR(p_id IN NUMBER) IS
    v_used NUMBER;
  BEGIN
    assert_id(p_id, 'Categoria: id obligatorio.');

    SELECT COUNT(1) INTO v_used FROM BOD_TIPO WHERE cat_categoria = p_id;
    IF v_used > 0 THEN
      RAISE_APPLICATION_ERROR(-20004, 'No se puede eliminar: categoria tiene tipos asociados.');
    END IF;

    DELETE FROM BOD_CATEGORIA WHERE cat_categoria = p_id;
  END;

  PROCEDURE CAT_LISTAR(p_data OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN p_data FOR
      SELECT cat_categoria, cat_descripcion
        FROM BOD_CATEGORIA
       ORDER BY cat_descripcion;
  END;

  PROCEDURE CAT_BUSCAR(p_texto IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
    v_txt VARCHAR2(4000);
  BEGIN
    v_txt := '%' || UPPER(TRIM(NVL(p_texto,''))) || '%';
    OPEN p_data FOR
      SELECT cat_categoria, cat_descripcion
        FROM BOD_CATEGORIA
       WHERE UPPER(cat_descripcion) LIKE v_txt
       ORDER BY cat_descripcion;
  END;

  -- =========================
  -- MATERIAL
  -- =========================
  PROCEDURE MAT_CREAR(p_descripcion IN VARCHAR2, p_id OUT NUMBER) IS
  BEGIN
    assert_not_null(p_descripcion, 'Material: descripcion obligatoria.');
    INSERT INTO BOD_MATERIAL(mat_descripcion)
    VALUES (TRIM(p_descripcion))
    RETURNING mat_material INTO p_id;
  END;

  PROCEDURE MAT_ACTUALIZAR(p_id IN NUMBER, p_descripcion IN VARCHAR2) IS
    v_exists NUMBER;
  BEGIN
    assert_id(p_id, 'Material: id obligatorio.');
    assert_not_null(p_descripcion, 'Material: descripcion obligatoria.');

    SELECT COUNT(1) INTO v_exists FROM BOD_MATERIAL WHERE mat_material = p_id;
    IF v_exists = 0 THEN RAISE_APPLICATION_ERROR(-20005, 'Material no existe.'); END IF;

    UPDATE BOD_MATERIAL
       SET mat_descripcion = TRIM(p_descripcion)
     WHERE mat_material = p_id;
  END;

  PROCEDURE MAT_ELIMINAR(p_id IN NUMBER) IS
    v_used NUMBER;
  BEGIN
    assert_id(p_id, 'Material: id obligatorio.');

    SELECT COUNT(1) INTO v_used FROM BOD_PRODUCTO WHERE mat_material = p_id;
    IF v_used > 0 THEN
      RAISE_APPLICATION_ERROR(-20006, 'No se puede eliminar: material referenciado por productos.');
    END IF;

    DELETE FROM BOD_MATERIAL WHERE mat_material = p_id;
  END;

  PROCEDURE MAT_LISTAR(p_data OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN p_data FOR
      SELECT mat_material, mat_descripcion
        FROM BOD_MATERIAL
       ORDER BY mat_descripcion;
  END;

  PROCEDURE MAT_BUSCAR(p_texto IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
    v_txt VARCHAR2(4000);
  BEGIN
    v_txt := '%' || UPPER(TRIM(NVL(p_texto,''))) || '%';
    OPEN p_data FOR
      SELECT mat_material, mat_descripcion
        FROM BOD_MATERIAL
       WHERE UPPER(mat_descripcion) LIKE v_txt
       ORDER BY mat_descripcion;
  END;

  -- =========================
  -- TIPO
  -- =========================
  PROCEDURE TIP_CREAR(p_descripcion IN VARCHAR2, p_cat_categoria IN NUMBER, p_id OUT NUMBER) IS
  BEGIN
    assert_not_null(p_descripcion, 'Tipo: descripcion obligatoria.');
    assert_id(p_cat_categoria, 'Tipo: categoria obligatoria.');

    INSERT INTO BOD_TIPO(tip_descripcion, cat_categoria)
    VALUES (TRIM(p_descripcion), p_cat_categoria)
    RETURNING tip_tipo INTO p_id;
  END;

  PROCEDURE TIP_ACTUALIZAR(p_id IN NUMBER, p_descripcion IN VARCHAR2, p_cat_categoria IN NUMBER) IS
    v_exists NUMBER;
  BEGIN
    assert_id(p_id, 'Tipo: id obligatorio.');
    assert_not_null(p_descripcion, 'Tipo: descripcion obligatoria.');
    assert_id(p_cat_categoria, 'Tipo: categoria obligatoria.');

    SELECT COUNT(1) INTO v_exists FROM BOD_TIPO WHERE tip_tipo = p_id;
    IF v_exists = 0 THEN RAISE_APPLICATION_ERROR(-20007, 'Tipo no existe.'); END IF;

    UPDATE BOD_TIPO
       SET tip_descripcion = TRIM(p_descripcion),
           cat_categoria   = p_cat_categoria
     WHERE tip_tipo = p_id;
  END;

  PROCEDURE TIP_ELIMINAR(p_id IN NUMBER) IS
    v_used NUMBER;
  BEGIN
    assert_id(p_id, 'Tipo: id obligatorio.');

    SELECT COUNT(1) INTO v_used FROM BOD_PRODUCTO WHERE tip_tipo = p_id;
    IF v_used > 0 THEN
      RAISE_APPLICATION_ERROR(-20008, 'No se puede eliminar: tipo referenciado por productos.');
    END IF;

    DELETE FROM BOD_TIPO WHERE tip_tipo = p_id;
  END;

  PROCEDURE TIP_LISTAR(p_data OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN p_data FOR
      SELECT t.tip_tipo, t.tip_descripcion, t.cat_categoria, c.cat_descripcion AS categoria
        FROM BOD_TIPO t
        JOIN BOD_CATEGORIA c ON c.cat_categoria = t.cat_categoria
       ORDER BY c.cat_descripcion, t.tip_descripcion;
  END;

  PROCEDURE TIP_LISTAR_POR_CATEGORIA(p_cat_categoria IN NUMBER, p_data OUT SYS_REFCURSOR) IS
  BEGIN
    assert_id(p_cat_categoria, 'Tipo: categoria obligatoria.');
    OPEN p_data FOR
      SELECT tip_tipo, tip_descripcion
        FROM BOD_TIPO
       WHERE cat_categoria = p_cat_categoria
       ORDER BY tip_descripcion;
  END;

  -- =========================
  -- ALMACEN
  -- =========================
  PROCEDURE ALM_CREAR(p_nombre IN VARCHAR2, p_pais IN VARCHAR2, p_ubicacion IN VARCHAR2, p_id OUT NUMBER) IS
  BEGIN
    assert_not_null(p_nombre, 'Almacen: nombre obligatorio.');
    assert_not_null(p_pais, 'Almacen: pais obligatorio.');
    assert_not_null(p_ubicacion, 'Almacen: ubicacion obligatoria.');

    INSERT INTO BOD_ALMACEN(alm_nombre, alm_pais, alm_ubicacion)
    VALUES (TRIM(p_nombre), TRIM(p_pais), TRIM(p_ubicacion))
    RETURNING alm_almacen INTO p_id;
  END;

  PROCEDURE ALM_ACTUALIZAR(p_id IN NUMBER, p_nombre IN VARCHAR2, p_pais IN VARCHAR2, p_ubicacion IN VARCHAR2) IS
  BEGIN
    assert_id(p_id, 'Almacen: id obligatorio.');
    assert_not_null(p_nombre, 'Almacen: nombre obligatorio.');
    assert_not_null(p_pais, 'Almacen: pais obligatorio.');
    assert_not_null(p_ubicacion, 'Almacen: ubicacion obligatoria.');

    UPDATE BOD_ALMACEN
       SET alm_nombre = TRIM(p_nombre),
           alm_pais   = TRIM(p_pais),
           alm_ubicacion = TRIM(p_ubicacion)
     WHERE alm_almacen = p_id;
  END;

  PROCEDURE ALM_ELIMINAR(p_id IN NUMBER) IS
    v_used NUMBER;
  BEGIN
    assert_id(p_id, 'Almacen: id obligatorio.');
    SELECT COUNT(1) INTO v_used FROM BOD_NIC_ALM WHERE alm_almacen = p_id;
    IF v_used > 0 THEN
      RAISE_APPLICATION_ERROR(-20009, 'No se puede eliminar: almacen tiene nichos asignados.');
    END IF;
    DELETE FROM BOD_ALMACEN WHERE alm_almacen = p_id;
  END;

  PROCEDURE ALM_LISTAR(p_data OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN p_data FOR
      SELECT alm_almacen, alm_nombre, alm_pais, alm_ubicacion
        FROM BOD_ALMACEN
       ORDER BY alm_nombre;
  END;

  -- =========================
  -- NICHO
  -- =========================
  PROCEDURE NIC_CREAR(p_numero IN VARCHAR2, p_zona IN VARCHAR2, p_caracteristica IN VARCHAR2, p_id OUT NUMBER) IS
  BEGIN
    assert_not_null(p_numero, 'Nicho: numero obligatorio.');
    assert_not_null(p_zona, 'Nicho: zona obligatoria.');
    assert_not_null(p_caracteristica, 'Nicho: caracteristica obligatoria.');

    INSERT INTO BOD_NICHO(nic_numero, nic_zona, nic_caracteristica)
    VALUES (TRIM(p_numero), TRIM(p_zona), TRIM(p_caracteristica))
    RETURNING nic_nicho INTO p_id;
  END;

  PROCEDURE NIC_ACTUALIZAR(p_id IN NUMBER, p_numero IN VARCHAR2, p_zona IN VARCHAR2, p_caracteristica IN VARCHAR2) IS
  BEGIN
    assert_id(p_id, 'Nicho: id obligatorio.');
    assert_not_null(p_numero, 'Nicho: numero obligatorio.');
    assert_not_null(p_zona, 'Nicho: zona obligatoria.');
    assert_not_null(p_caracteristica, 'Nicho: caracteristica obligatoria.');

    UPDATE BOD_NICHO
       SET nic_numero = TRIM(p_numero),
           nic_zona   = TRIM(p_zona),
           nic_caracteristica = TRIM(p_caracteristica)
     WHERE nic_nicho = p_id;
  END;

  PROCEDURE NIC_ELIMINAR(p_id IN NUMBER) IS
    v_used1 NUMBER;
    v_used2 NUMBER;
  BEGIN
    assert_id(p_id, 'Nicho: id obligatorio.');

    SELECT COUNT(1) INTO v_used1 FROM BOD_NIC_ALM WHERE nic_nicho = p_id;
    SELECT COUNT(1) INTO v_used2 FROM BOD_HISTORIAL_PRECIO WHERE nic_nicho = p_id;

    IF v_used1 > 0 OR v_used2 > 0 THEN
      RAISE_APPLICATION_ERROR(-20010, 'No se puede eliminar: nicho referenciado por almacen o precios.');
    END IF;

    DELETE FROM BOD_NICHO WHERE nic_nicho = p_id;
  END;

  PROCEDURE NIC_LISTAR(p_data OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN p_data FOR
      SELECT nic_nicho, nic_numero, nic_zona, nic_caracteristica
        FROM BOD_NICHO
       ORDER BY nic_numero;
  END;

END PKG_CI_CATALOGOS;
/