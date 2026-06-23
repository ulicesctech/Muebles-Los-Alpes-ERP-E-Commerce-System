CREATE OR REPLACE PACKAGE BODY PKG_BOD_CATEGORIA AS
 
  PROCEDURE CREAR(p_descripcion IN VARCHAR2, p_id OUT NUMBER) IS
  BEGIN
    IF TRIM(p_descripcion) IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'BOD_CATEGORIA: descripcion obligatoria.');
    END IF;
    INSERT INTO BOD_CATEGORIA(cat_descripcion)
    VALUES(TRIM(p_descripcion))
    RETURNING cat_categoria INTO p_id;
  END;
 
  PROCEDURE ACTUALIZAR(p_id IN NUMBER, p_descripcion IN VARCHAR2) IS
  BEGIN
    IF p_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20002, 'BOD_CATEGORIA: id obligatorio.');
    END IF;
    IF TRIM(p_descripcion) IS NULL THEN
      RAISE_APPLICATION_ERROR(-20003, 'BOD_CATEGORIA: descripcion obligatoria.');
    END IF;
    UPDATE BOD_CATEGORIA
       SET cat_descripcion = TRIM(p_descripcion)
     WHERE cat_categoria = p_id;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20004, 'BOD_CATEGORIA: no existe.');
    END IF;
  END;
 
  PROCEDURE ELIMINAR(p_id IN NUMBER) IS
    v_used NUMBER;
  BEGIN
    IF p_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20005, 'BOD_CATEGORIA: id obligatorio.');
    END IF;
    SELECT COUNT(1) INTO v_used FROM BOD_TIPO WHERE cat_categoria = p_id;
    IF v_used > 0 THEN
      RAISE_APPLICATION_ERROR(-20006, 'BOD_CATEGORIA: no se puede eliminar, tiene tipos asociados.');
    END IF;
    DELETE FROM BOD_CATEGORIA WHERE cat_categoria = p_id;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20007, 'BOD_CATEGORIA: no existe.');
    END IF;
  END;
 
  PROCEDURE LISTAR(p_data OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN p_data FOR
      SELECT cat_categoria, cat_descripcion
        FROM BOD_CATEGORIA
       ORDER BY cat_descripcion;
  END;
 
  PROCEDURE BUSCAR(p_texto IN VARCHAR2, p_data OUT SYS_REFCURSOR) IS
    v_txt VARCHAR2(4000);
  BEGIN
    v_txt := '%' || UPPER(TRIM(NVL(p_texto, ''))) || '%';
    OPEN p_data FOR
      SELECT cat_categoria, cat_descripcion
        FROM BOD_CATEGORIA
       WHERE UPPER(cat_descripcion) LIKE v_txt
       ORDER BY cat_descripcion;
  END;
 
END PKG_BOD_CATEGORIA;
/