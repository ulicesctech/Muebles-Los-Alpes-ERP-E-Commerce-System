CREATE OR REPLACE PACKAGE BODY PKG_BOD_MATERIAL AS

  PROCEDURE CREAR(p_descripcion IN VARCHAR2, p_id OUT NUMBER) IS
  BEGIN
    IF TRIM(p_descripcion) IS NULL THEN
      RAISE_APPLICATION_ERROR(-21101, 'BOD_MATERIAL: descripcion obligatoria.');
    END IF;

    INSERT INTO BOD_MATERIAL(mat_descripcion)
    VALUES (TRIM(p_descripcion))
    RETURNING mat_material INTO p_id;
  END;

  PROCEDURE ACTUALIZAR(p_id IN NUMBER, p_descripcion IN VARCHAR2) IS
  BEGIN
    IF p_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-21102, 'BOD_MATERIAL: id obligatorio.');
    END IF;

    IF TRIM(p_descripcion) IS NULL THEN
      RAISE_APPLICATION_ERROR(-21103, 'BOD_MATERIAL: descripcion obligatoria.');
    END IF;

    UPDATE BOD_MATERIAL
       SET mat_descripcion = TRIM(p_descripcion)
     WHERE mat_material = p_id;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-21104, 'BOD_MATERIAL: no existe.');
    END IF;
  END;

  PROCEDURE ELIMINAR(p_id IN NUMBER) IS
    v_used NUMBER;
  BEGIN
    IF p_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-21105, 'BOD_MATERIAL: id obligatorio.');
    END IF;

    SELECT COUNT(1) INTO v_used
      FROM BOD_PRODUCTO
     WHERE mat_material = p_id;

    IF v_used > 0 THEN
      RAISE_APPLICATION_ERROR(-21106, 'BOD_MATERIAL: no se puede eliminar, está usado por productos.');
    END IF;

    DELETE FROM BOD_MATERIAL WHERE mat_material = p_id;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-21107, 'BOD_MATERIAL: no existe.');
    END IF;
  END;

  PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN p_data FOR
      SELECT mat_material, mat_descripcion
        FROM BOD_MATERIAL
       ORDER BY mat_descripcion;
  END;

  PROCEDURE BUSCAR(p_texto IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
    v_txt VARCHAR2(4000);
  BEGIN
    v_txt := '%' || UPPER(TRIM(NVL(p_texto,''))) || '%';

    OPEN p_data FOR
      SELECT mat_material, mat_descripcion
        FROM BOD_MATERIAL
       WHERE UPPER(mat_descripcion) LIKE v_txt
       ORDER BY mat_descripcion;
  END;

END PKG_BOD_MATERIAL;
/