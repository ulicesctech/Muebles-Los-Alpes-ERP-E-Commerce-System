CREATE OR REPLACE PACKAGE BODY PKG_CP_BOD_PEDIDO AS

    -- ============================================================
    -- CONFIGURACION CENTRAL
    -- ============================================================

    -- Prefijo del codigo de pedido.
    -- Cambia solo este valor para que todos los pedidos nuevos usen
    -- la nueva abreviatura.  El numero correlativo es siempre el ID
    -- del registro (ped_pedido), por lo que no hay huecos ni saltos.
    -- Ejemplos: 'PED', 'OC', 'COMP', 'REQ'
    C_PREFIJO_PEDIDO CONSTANT VARCHAR2(20) := 'PED';

    -- Formas de pago disponibles.
    -- Para agregar una forma de pago: agrega un registro mas al array.
    -- Para quitarla: elimina o comenta la linea correspondiente.
    -- El primer campo (fp) es el valor que se guarda en BD;
    -- debe coincidir con los valores permitidos por el CHECK constraint
    -- de BOD_PEDIDO.ped_forma_pago.
    -- El segundo campo (desc_) es el texto que se muestra en la UI.
    TYPE t_forma_pago_rec IS RECORD (
        fp    VARCHAR2(30),
        desc_ VARCHAR2(60)
    );
    TYPE t_formas_pago IS TABLE OF t_forma_pago_rec INDEX BY PLS_INTEGER;

    FUNCTION C_FORMAS_PAGO RETURN t_formas_pago IS
        v_lista t_formas_pago;
    BEGIN
        -- ► AQUI se configuran las formas de pago ◄
        -- Orden: aparecen en este mismo orden en el combo de la UI.
        v_lista(1).fp := 'CONTADO';  v_lista(1).desc_ := 'Contado';
        v_lista(2).fp := 'CREDITO';  v_lista(2).desc_ := 'Credito';
        -- Ejemplo para agregar mas opciones:
        -- v_lista(3).fp := 'CHEQUE';   v_lista(3).desc_ := 'Cheque';
        -- v_lista(4).fp := 'TRANSFERENCIA'; v_lista(4).desc_ := 'Transferencia Bancaria';
        RETURN v_lista;
    END C_FORMAS_PAGO;

    -- ============================================================
    -- PROCEDIMIENTOS
    -- ============================================================

    -- PED_CREAR
    -- Inserta el pedido con codigo TEMP, obtiene el ID con RETURNING,
    -- luego actualiza el codigo con el patron "PREFIJO-ID" en un solo
    -- bloque atomico.  El VB ya no arma el codigo ni hace un segundo
    -- UPDATE de cabecera para sobreescribirlo.
    PROCEDURE PED_CREAR(
        p_forma_pago IN  VARCHAR2,
        p_total      IN  NUMBER,
        p_id         OUT NUMBER
    ) AS
        v_codigo VARCHAR2(50);
    BEGIN
        INSERT INTO BOD_PEDIDO(ped_codigo, ped_forma_pago, ped_total, ped_fecha)
        VALUES ('TEMP', p_forma_pago, NVL(p_total, 0), SYSDATE)
        RETURNING ped_pedido INTO p_id;

        -- Armar el codigo definitivo con el prefijo configurado arriba
        v_codigo := C_PREFIJO_PEDIDO || '-' || TO_CHAR(p_id);

        UPDATE BOD_PEDIDO
           SET ped_codigo = v_codigo
         WHERE ped_pedido = p_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END PED_CREAR;

    PROCEDURE PED_ACTUALIZAR(
        p_id         IN NUMBER,
        p_codigo     IN VARCHAR2,
        p_forma_pago IN VARCHAR2,
        p_total      IN NUMBER
    ) AS
    BEGIN
        UPDATE BOD_PEDIDO
           SET ped_codigo     = p_codigo,
               ped_forma_pago = p_forma_pago,
               ped_total      = p_total
         WHERE ped_pedido = p_id;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END PED_ACTUALIZAR;

    PROCEDURE PED_ELIMINAR(p_id IN NUMBER) AS
    BEGIN
        DELETE FROM BOD_DETALLE_PEDIDO WHERE ped_pedido = p_id;
        DELETE FROM BOD_PEDIDO         WHERE ped_pedido = p_id;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END PED_ELIMINAR;

    PROCEDURE PED_LISTAR(p_data OUT SYS_REFCURSOR) AS
    BEGIN
        OPEN p_data FOR
            SELECT p.ped_pedido,
                   p.ped_codigo,
                   p.ped_fecha,
                   p.ped_forma_pago,
                   p.ped_total,
                   (SELECT LISTAGG(pr2.pro_nombre, ', ') WITHIN GROUP (ORDER BY pr2.pro_nombre)
                      FROM BOD_DETALLE_PEDIDO  d2
                      JOIN BOD_HISTORIAL_PRECIO h2 ON d2.hip_historial_precio = h2.hip_historial_precio
                      JOIN BOD_PRODUCTO         pr2 ON h2.pro_referencia = pr2.pro_referencia
                     WHERE d2.ped_pedido = p.ped_pedido) AS producto,
                   (SELECT LISTAGG(m2.mat_descripcion, ', ') WITHIN GROUP (ORDER BY m2.mat_descripcion)
                      FROM BOD_DETALLE_PEDIDO  d2
                      JOIN BOD_HISTORIAL_PRECIO h2  ON d2.hip_historial_precio = h2.hip_historial_precio
                      JOIN BOD_PRODUCTO         pr2 ON h2.pro_referencia = pr2.pro_referencia
                      JOIN BOD_MATERIAL         m2  ON pr2.mat_material = m2.mat_material
                     WHERE d2.ped_pedido = p.ped_pedido) AS material,
                   (SELECT SUM(d3.detpe_cantidad_solicitada)
                      FROM BOD_DETALLE_PEDIDO d3
                     WHERE d3.ped_pedido = p.ped_pedido) AS cantidad_solicitada,
                   (SELECT SUM(d4.detpe_cantidad_recibida)
                      FROM BOD_DETALLE_PEDIDO d4
                     WHERE d4.ped_pedido = p.ped_pedido) AS cantidad_ingresada
              FROM BOD_PEDIDO p
             ORDER BY p.ped_pedido DESC;
    END PED_LISTAR;

    PROCEDURE PED_BUSCAR(p_codigo IN VARCHAR2, p_data OUT SYS_REFCURSOR) AS
    BEGIN
        OPEN p_data FOR
            SELECT * FROM (
                SELECT p.ped_pedido,
                       p.ped_codigo,
                       p.ped_fecha,
                       p.ped_forma_pago,
                       p.ped_total,
                       (SELECT LISTAGG(pr2.pro_nombre, ', ') WITHIN GROUP (ORDER BY pr2.pro_nombre)
                          FROM BOD_DETALLE_PEDIDO  d2
                          JOIN BOD_HISTORIAL_PRECIO h2  ON d2.hip_historial_precio = h2.hip_historial_precio
                          JOIN BOD_PRODUCTO         pr2 ON h2.pro_referencia = pr2.pro_referencia
                         WHERE d2.ped_pedido = p.ped_pedido) AS producto,
                       (SELECT LISTAGG(m2.mat_descripcion, ', ') WITHIN GROUP (ORDER BY m2.mat_descripcion)
                          FROM BOD_DETALLE_PEDIDO  d2
                          JOIN BOD_HISTORIAL_PRECIO h2  ON d2.hip_historial_precio = h2.hip_historial_precio
                          JOIN BOD_PRODUCTO         pr2 ON h2.pro_referencia = pr2.pro_referencia
                          JOIN BOD_MATERIAL         m2  ON pr2.mat_material = m2.mat_material
                         WHERE d2.ped_pedido = p.ped_pedido) AS material,
                       (SELECT SUM(d3.detpe_cantidad_solicitada)
                          FROM BOD_DETALLE_PEDIDO d3
                         WHERE d3.ped_pedido = p.ped_pedido) AS cantidad_solicitada,
                       (SELECT SUM(d4.detpe_cantidad_recibida)
                          FROM BOD_DETALLE_PEDIDO d4
                         WHERE d4.ped_pedido = p.ped_pedido) AS cantidad_ingresada
                  FROM BOD_PEDIDO p
            ) t
            WHERE UPPER(t.ped_codigo) LIKE '%' || UPPER(p_codigo) || '%'
               OR UPPER(t.producto)   LIKE '%' || UPPER(p_codigo) || '%'
               OR UPPER(t.material)   LIKE '%' || UPPER(p_codigo) || '%'
            ORDER BY t.ped_pedido DESC;
    END PED_BUSCAR;

    PROCEDURE PED_OBTENER_ID(p_id IN NUMBER, p_data OUT SYS_REFCURSOR) AS
    BEGIN
        OPEN p_data FOR
            SELECT ped_pedido, ped_codigo, ped_fecha, ped_forma_pago, ped_total
              FROM BOD_PEDIDO
             WHERE ped_pedido = p_id;
    END PED_OBTENER_ID;

    PROCEDURE PED_RECIBIR(p_detpe_id IN NUMBER, p_cantidad_recibida IN NUMBER) IS
        v_hip_id   NUMBER;
        v_cant_sol NUMBER;
    BEGIN
        IF p_detpe_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'BOD_DETALLE_PEDIDO: id obligatorio.');
        END IF;
        IF p_cantidad_recibida IS NULL OR p_cantidad_recibida <= 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'BOD_DETALLE_PEDIDO: cantidad recibida debe ser > 0.');
        END IF;
        SELECT hip_historial_precio, detpe_cantidad_solicitada
          INTO v_hip_id, v_cant_sol
          FROM BOD_DETALLE_PEDIDO
         WHERE detpe_detalle_pedido = p_detpe_id;
        IF p_cantidad_recibida > v_cant_sol THEN
            RAISE_APPLICATION_ERROR(-20003, 'BOD_DETALLE_PEDIDO: cantidad recibida no puede superar la solicitada.');
        END IF;
        UPDATE BOD_DETALLE_PEDIDO
           SET detpe_cantidad_recibida = p_cantidad_recibida
         WHERE detpe_detalle_pedido = p_detpe_id;
        PKG_BOD_STOCK.ENTRADA(v_hip_id, p_cantidad_recibida);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END PED_RECIBIR;

    PROCEDURE PED_RECIBIR_TODO(p_ped_id IN NUMBER) IS
        CURSOR c_detalles IS
            SELECT detpe_detalle_pedido, hip_historial_precio, detpe_cantidad_solicitada
              FROM BOD_DETALLE_PEDIDO
             WHERE ped_pedido = p_ped_id;
    BEGIN
        IF p_ped_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20004, 'BOD_PEDIDO: id obligatorio.');
        END IF;
        FOR r IN c_detalles LOOP
            UPDATE BOD_DETALLE_PEDIDO
               SET detpe_cantidad_recibida = r.detpe_cantidad_solicitada
             WHERE detpe_detalle_pedido = r.detpe_detalle_pedido;
            PKG_BOD_STOCK.ENTRADA(r.hip_historial_precio, r.detpe_cantidad_solicitada);
        END LOOP;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK; RAISE;
    END PED_RECIBIR_TODO;

    -- --------------------------------------------------------
    -- PED_LISTAR_FORMAS_PAGO
    -- Lee el array C_FORMAS_PAGO y lo convierte en un cursor
    -- usando una tabla temporal en memoria (coleccion PL/SQL).
    -- No usa SQL dinamico: es estable en todas las versiones Oracle.
    -- Para agregar/quitar formas de pago solo edita C_FORMAS_PAGO.
    -- --------------------------------------------------------
    PROCEDURE PED_LISTAR_FORMAS_PAGO(p_data OUT SYS_REFCURSOR) IS
        v_lista t_formas_pago;
        v_idx   PLS_INTEGER;
        v_fps   SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
        v_descs SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
    BEGIN
        v_lista := C_FORMAS_PAGO();
        v_idx   := v_lista.FIRST;
        WHILE v_idx IS NOT NULL LOOP
            v_fps.EXTEND;   v_fps(v_fps.LAST)     := v_lista(v_idx).fp;
            v_descs.EXTEND; v_descs(v_descs.LAST) := v_lista(v_idx).desc_;
            v_idx := v_lista.NEXT(v_idx);
        END LOOP;
        OPEN p_data FOR
            SELECT f.column_value AS forma_pago,
                   d.column_value AS descripcion
              FROM (SELECT ROWNUM rn, column_value FROM TABLE(v_fps))  f
              JOIN (SELECT ROWNUM rn, column_value FROM TABLE(v_descs)) d
                ON f.rn = d.rn
             ORDER BY f.rn;
    END PED_LISTAR_FORMAS_PAGO;

END PKG_CP_BOD_PEDIDO;
/
