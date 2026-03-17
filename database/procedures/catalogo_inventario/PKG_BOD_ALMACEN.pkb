CREATE OR REPLACE PACKAGE BODY PKG_BOD_ALMACEN AS

  PROCEDURE CREAR(p_nombre IN VARCHAR2, p_pais IN VARCHAR2, p_ubicacion IN VARCHAR2, p_id OUT NUMBER) IS
  BEGIN
    IF TRIM(p_nombre) IS NULL THEN RAISE_APPLICATION_ERROR(-21401, 'BOD_ALMACEN: nombre obligatorio.'); END IF;
    IF TRIM(p_pais) IS NULL THEN RAISE_APPLICATION_ERROR(-21402, 'BOD_ALMACEN: pais obligatorio.'); END IF;
    IF TRIM(p_ubicacion) IS NULL THEN RAISE_APPLICATION_ERROR(-21403, 'BOD_ALMACEN: ubicacion obligatoria.'); END IF;

    INSERT INTO BOD_ALMACEN(alm_nombre, alm_pais, alm_ubicacion)
    VALUES(TRIM(p_nombre), TRIM(p_pais), TRIM(p_ubicacion))
    RETURNING alm_almacen INTO p_id;
  END;

  PROCEDURE ACTUALIZAR(p_id IN NUMBER, p_nombre IN VARCHAR2, p_pais IN VARCHAR2, p_ubicacion IN VARCHAR2) IS
  BEGIN
    IF p_id IS NULL THEN RAISE_APPLICATION_ERROR(-21404, 'BOD_ALMACEN: id obligatorio.'); END IF;
    IF TRIM(p_nombre) IS NULL THEN RAISE_APPLICATION_ERROR(-21405, 'BOD_ALMACEN: nombre obligatorio.'); END IF;
    IF TRIM(p_pais) IS NULL THEN RAISE_APPLICATION_ERROR(-21406, 'BOD_ALMACEN: pais obligatorio.'); END IF;
    IF TRIM(p_ubicacion) IS NULL THEN RAISE_APPLICATION_ERROR(-21407, 'BOD_ALMACEN: ubicacion obligatoria.'); END IF;

    UPDATE BOD_ALMACEN
       SET alm_nombre = TRIM(p_nombre),
           alm_pais = TRIM(p_pais),
           alm_ubicacion = TRIM(p_ubicacion)
     WHERE alm_almacen = p_id;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-21408, 'BOD_ALMACEN: no existe.');
    END IF;
  END;

  PROCEDURE ELIMINAR(p_id IN NUMBER) IS
    v_used NUMBER;
  BEGIN
    IF p_id IS NULL THEN RAISE_APPLICATION_ERROR(-21409, 'BOD_ALMACEN: id obligatorio.'); END IF;

    SELECT COUNT(1) INTO v_used FROM BOD_NIC_ALM WHERE alm_almacen = p_id;
    IF v_used > 0 THEN
      RAISE_APPLICATION_ERROR(-21410, 'BOD_ALMACEN: no se puede eliminar, tiene nichos asignados.');
    END IF;

    DELETE FROM BOD_ALMACEN WHERE alm_almacen = p_id;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-21411, 'BOD_ALMACEN: no existe.');
    END IF;
  END;

  PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN p_data FOR
      SELECT alm_almacen, alm_nombre, alm_pais, alm_ubicacion
        FROM BOD_ALMACEN
       ORDER BY alm_nombre;
  END;

END PKG_BOD_ALMACEN;
/