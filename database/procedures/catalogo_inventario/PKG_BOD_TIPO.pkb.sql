CREATE OR REPLACE PACKAGE BODY PKG_BOD_TIPO AS
 
  PROCEDURE CREAR(p_descripcion IN VARCHAR2, p_cat_categoria IN NUMBER, p_id OUT NUMBER) IS
  BEGIN
    IF TRIM(p_descripcion) IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'BOD_TIPO: descripcion obligatoria.');
    END IF;
    IF p_cat_categoria IS NULL THEN
      RAISE_APPLICATION_ERROR(-20002, 'BOD_TIPO: cat_categoria obligatoria.');
    END IF;
    INSERT INTO BOD_TIPO(tip_descripcion, cat_categoria)
    VALUES(TRIM(p_descripcion), p_cat_categoria)
    RETURNING tip_tipo INTO p_id;
  END;
 
  PROCEDURE ACTUALIZAR(p_id IN NUMBER, p_descripcion IN VARCHAR2, p_cat_categoria IN NUMBER) IS
  BEGIN
    IF p_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20003, 'BOD_TIPO: id obligatorio.');
    END IF;
    IF TRIM(p_descripcion) IS NULL THEN
      RAISE_APPLICATION_ERROR(-20004, 'BOD_TIPO: descripcion obligatoria.');
    END IF;
    IF p_cat_categoria IS NULL THEN
      RAISE_APPLICATION_ERROR(-20005, 'BOD_TIPO: cat_categoria obligatoria.');
    END IF;
    UPDATE BOD_TIPO
       SET tip_descripcion = TRIM(p_descripcion),
           cat_categoria   = p_cat_categoria
     WHERE tip_tipo = p_id;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20006, 'BOD_TIPO: no existe.');
    END IF;
  END;
 
  PROCEDURE ELIMINAR(p_id IN NUMBER) IS
    v_used NUMBER;
  BEGIN
    IF p_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20007, 'BOD_TIPO: id obligatorio.');
    END IF;
    SELECT COUNT(1) INTO v_used FROM BOD_PRODUCTO WHERE tip_tipo = p_id;
    IF v_used > 0 THEN
      RAISE_APPLICATION_ERROR(-20008, 'BOD_TIPO: no se puede eliminar, esta usado por productos.');
    END IF;
    DELETE FROM BOD_TIPO WHERE tip_tipo = p_id;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20009, 'BOD_TIPO: no existe.');
    END IF;
  END;
 
  PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN p_data FOR
      SELECT t.tip_tipo, t.tip_descripcion, t.cat_categoria, c.cat_descripcion AS categoria
        FROM BOD_TIPO t
        JOIN BOD_CATEGORIA c ON c.cat_categoria = t.cat_categoria
       ORDER BY c.cat_descripcion, t.tip_descripcion;
  END;
 
  PROCEDURE LISTAR_POR_CATEGORIA(p_cat_categoria IN NUMBER, p_data OUT SYS_REFCURSOR) IS
  BEGIN
    IF p_cat_categoria IS NULL THEN
      RAISE_APPLICATION_ERROR(-20010, 'BOD_TIPO: cat_categoria obligatoria.');
    END IF;
    OPEN p_data FOR
      SELECT tip_tipo, tip_descripcion
        FROM BOD_TIPO
       WHERE cat_categoria = p_cat_categoria
       ORDER BY tip_descripcion;
  END;
 
END PKG_BOD_TIPO;
/