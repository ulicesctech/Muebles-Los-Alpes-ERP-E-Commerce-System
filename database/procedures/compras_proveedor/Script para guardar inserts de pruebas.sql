-- ==========================================================
-- ADMIN_PERMISOS
-- ==========================================================
INSERT INTO ADMIN_PERMISOS VALUES (DEFAULT,1,1,1,1,1,1);
INSERT INTO ADMIN_PERMISOS VALUES (DEFAULT,1,1,0,1,0,0);
INSERT INTO ADMIN_PERMISOS VALUES (DEFAULT,0,1,1,0,1,0);
INSERT INTO ADMIN_PERMISOS VALUES (DEFAULT,0,0,1,1,0,1);

-- ==========================================================
-- ADMIN_GRUPO_USUARIO
-- ==========================================================
INSERT INTO ADMIN_GRUPO_USUARIO VALUES (DEFAULT,'ADMIN',1);
INSERT INTO ADMIN_GRUPO_USUARIO VALUES (DEFAULT,'RRHH',2);
INSERT INTO ADMIN_GRUPO_USUARIO VALUES (DEFAULT,'FACTURACION',3);
INSERT INTO ADMIN_GRUPO_USUARIO VALUES (DEFAULT,'CLIENTE',4);

-- ==========================================================
-- RH_PUESTO
-- ==========================================================
INSERT INTO RH_PUESTO VALUES (DEFAULT,'Gerente',8000,'Admin');
INSERT INTO RH_PUESTO VALUES (DEFAULT,'Vendedor',3500,'Ventas');
INSERT INTO RH_PUESTO VALUES (DEFAULT,'Bodeguero',3000,'Inventario');
INSERT INTO RH_PUESTO VALUES (DEFAULT,'Contador',5000,'Finanzas');

-- ==========================================================
-- RH_EMPLEADO
-- ==========================================================
INSERT INTO RH_EMPLEADO VALUES (DEFAULT,'1001','Juan','Carlos','Perez','Lopez','Dir1','Av1','01001','1111',NULL,1);
INSERT INTO RH_EMPLEADO VALUES (DEFAULT,'1002','Maria','Luisa','Gomez','Diaz','Dir2','Av2','01002','2222',NULL,2);
INSERT INTO RH_EMPLEADO VALUES (DEFAULT,'1003','Luis','Fernando','Ramirez','Cruz','Dir3','Av3','01003','3333',NULL,3);
INSERT INTO RH_EMPLEADO VALUES (DEFAULT,'1004','Ana','Sofia','Torres','Mendez','Dir4','Av4','01004','4444',NULL,4);

-- ==========================================================
-- RH_ASCENSO
-- ==========================================================
INSERT INTO RH_ASCENSO VALUES (DEFAULT,1,1,SYSDATE,NULL);
INSERT INTO RH_ASCENSO VALUES (DEFAULT,2,2,SYSDATE,NULL);
INSERT INTO RH_ASCENSO VALUES (DEFAULT,3,3,SYSDATE,NULL);
INSERT INTO RH_ASCENSO VALUES (DEFAULT,4,4,SYSDATE,NULL);

-- ==========================================================
-- ADMIN_LOGIN_EMPLEADO
-- ==========================================================
INSERT INTO ADMIN_LOGIN_EMPLEADO VALUES (1,'pass1','user1');
INSERT INTO ADMIN_LOGIN_EMPLEADO VALUES (2,'pass2','user2');
INSERT INTO ADMIN_LOGIN_EMPLEADO VALUES (3,'pass3','user3');
INSERT INTO ADMIN_LOGIN_EMPLEADO VALUES (4,'pass4','user4');

-- ==========================================================
-- CLI_CLIENTE
-- ==========================================================
INSERT INTO CLI_CLIENTE VALUES (DEFAULT,'DPI','2001','123','Pedro',NULL,'Lopez',NULL,'Guatemala','Guatemala','Mixco','1','Dir','01001','5555',NULL,'p1@mail.com',NULL,'NATURAL');
INSERT INTO CLI_CLIENTE VALUES (DEFAULT,'DPI','2002','124','Jose',NULL,'Perez',NULL,'Guatemala','Guatemala','Mixco','2','Dir','01002','6666',NULL,'p2@mail.com',NULL,'NATURAL');
INSERT INTO CLI_CLIENTE VALUES (DEFAULT,'DPI','2003','125','Luis',NULL,'Gomez',NULL,'Guatemala','Guatemala','Mixco','3','Dir','01003','7777',NULL,'p3@mail.com',NULL,'NATURAL');
INSERT INTO CLI_CLIENTE VALUES (DEFAULT,'DPI','2004','126','Ana',NULL,'Diaz',NULL,'Guatemala','Guatemala','Mixco','4','Dir','01004','8888',NULL,'p4@mail.com',NULL,'NATURAL');

-- ==========================================================
-- ADMIN_LOGIN_CLIENTE
-- ==========================================================
INSERT INTO ADMIN_LOGIN_CLIENTE VALUES (1,'cpass1','cuser1');
INSERT INTO ADMIN_LOGIN_CLIENTE VALUES (2,'cpass2','cuser2');
INSERT INTO ADMIN_LOGIN_CLIENTE VALUES (3,'cpass3','cuser3');
INSERT INTO ADMIN_LOGIN_CLIENTE VALUES (4,'cpass4','cuser4');

-- ==========================================================
-- CLI_CARRITO
-- ==========================================================
INSERT INTO CLI_CARRITO VALUES (DEFAULT,'CAR1',1,SYSDATE,0);
INSERT INTO CLI_CARRITO VALUES (DEFAULT,'CAR2',2,SYSDATE,0);
INSERT INTO CLI_CARRITO VALUES (DEFAULT,'CAR3',3,SYSDATE,0);
INSERT INTO CLI_CARRITO VALUES (DEFAULT,'CAR4',4,SYSDATE,0);

-- ==========================================================
-- FAC_FACTURA_CLIENTE
-- ==========================================================
INSERT INTO FAC_FACTURA_CLIENTE VALUES (DEFAULT,1,1,'FAC1',SYSDATE);
INSERT INTO FAC_FACTURA_CLIENTE VALUES (DEFAULT,2,2,'FAC2',SYSDATE);
INSERT INTO FAC_FACTURA_CLIENTE VALUES (DEFAULT,3,3,'FAC3',SYSDATE);
INSERT INTO FAC_FACTURA_CLIENTE VALUES (DEFAULT,4,4,'FAC4',SYSDATE);

-- ==========================================================
-- CLI_DETALLE_CARRITO
-- ==========================================================
-- (se llena después de historial precio)

-- ==========================================================
-- BOD_CATEGORIA
-- ==========================================================
INSERT INTO BOD_CATEGORIA VALUES (DEFAULT,'Muebles');
INSERT INTO BOD_CATEGORIA VALUES (DEFAULT,'Oficina');
INSERT INTO BOD_CATEGORIA VALUES (DEFAULT,'Hogar');
INSERT INTO BOD_CATEGORIA VALUES (DEFAULT,'Decoracion');

-- ==========================================================
-- BOD_MATERIAL
-- ==========================================================
INSERT INTO BOD_MATERIAL VALUES (DEFAULT,'Madera');
INSERT INTO BOD_MATERIAL VALUES (DEFAULT,'Metal');
INSERT INTO BOD_MATERIAL VALUES (DEFAULT,'Plastico');
INSERT INTO BOD_MATERIAL VALUES (DEFAULT,'Vidrio');

-- ==========================================================
-- BOD_TIPO
-- ==========================================================
INSERT INTO BOD_TIPO VALUES (DEFAULT,'Silla',1);
INSERT INTO BOD_TIPO VALUES (DEFAULT,'Mesa',2);
INSERT INTO BOD_TIPO VALUES (DEFAULT,'Escritorio',3);
INSERT INTO BOD_TIPO VALUES (DEFAULT,'Estante',4);

-- ==========================================================
-- BOD_PRODUCTO
-- ==========================================================
INSERT INTO BOD_PRODUCTO VALUES ('P1','Silla1','Desc',1,1,50,50,50,'Rojo',1000,NULL);
INSERT INTO BOD_PRODUCTO VALUES ('P2','Mesa1','Desc',2,2,100,50,60,'Negro',2000,NULL);
INSERT INTO BOD_PRODUCTO VALUES ('P3','Escritorio1','Desc',3,3,120,60,70,'Blanco',3000,NULL);
INSERT INTO BOD_PRODUCTO VALUES ('P4','Estante1','Desc',4,4,180,80,30,'Cafe',4000,NULL);

-- ==========================================================
-- BOD_PROVEEDOR
-- ==========================================================
INSERT INTO BOD_PROVEEDOR VALUES (DEFAULT,'NIT1','Prov1','Av1','1','Dir','1111');
INSERT INTO BOD_PROVEEDOR VALUES (DEFAULT,'NIT2','Prov2','Av2','2','Dir','2222');
INSERT INTO BOD_PROVEEDOR VALUES (DEFAULT,'NIT3','Prov3','Av3','3','Dir','3333');
INSERT INTO BOD_PROVEEDOR VALUES (DEFAULT,'NIT4','Prov4','Av4','4','Dir','4444');

-- ==========================================================
-- PROMO_PROMOCION
-- ==========================================================
INSERT INTO PROMO_PROMOCION VALUES (DEFAULT,'P1',10,SYSDATE,SYSDATE+10);
INSERT INTO PROMO_PROMOCION VALUES (DEFAULT,'P2',15,SYSDATE,SYSDATE+10);
INSERT INTO PROMO_PROMOCION VALUES (DEFAULT,'P3',20,SYSDATE,SYSDATE+10);
INSERT INTO PROMO_PROMOCION VALUES (DEFAULT,'P4',25,SYSDATE,SYSDATE+10);

-- ==========================================================
-- BOD_NICHO
-- ==========================================================
INSERT INTO BOD_NICHO VALUES (DEFAULT,'N1','Z1','A');
INSERT INTO BOD_NICHO VALUES (DEFAULT,'N2','Z2','B');
INSERT INTO BOD_NICHO VALUES (DEFAULT,'N3','Z3','C');
INSERT INTO BOD_NICHO VALUES (DEFAULT,'N4','Z4','D');

-- ==========================================================
-- BOD_ALMACEN
-- ==========================================================
INSERT INTO BOD_ALMACEN VALUES (DEFAULT,'Alm1','GT','Ub1');
INSERT INTO BOD_ALMACEN VALUES (DEFAULT,'Alm2','GT','Ub2');
INSERT INTO BOD_ALMACEN VALUES (DEFAULT,'Alm3','GT','Ub3');
INSERT INTO BOD_ALMACEN VALUES (DEFAULT,'Alm4','GT','Ub4');

-- ==========================================================
-- BOD_NIC_ALM
-- ==========================================================
INSERT INTO BOD_NIC_ALM VALUES (DEFAULT,1,1);
INSERT INTO BOD_NIC_ALM VALUES (DEFAULT,2,2);
INSERT INTO BOD_NIC_ALM VALUES (DEFAULT,3,3);
INSERT INTO BOD_NIC_ALM VALUES (DEFAULT,4,4);

-- ==========================================================
-- BOD_HISTORIAL_PRECIO
-- ==========================================================
INSERT INTO BOD_HISTORIAL_PRECIO VALUES (DEFAULT,'P1',1,100,SYSDATE,NULL);
INSERT INTO BOD_HISTORIAL_PRECIO VALUES (DEFAULT,'P2',2,200,SYSDATE,NULL);
INSERT INTO BOD_HISTORIAL_PRECIO VALUES (DEFAULT,'P3',3,300,SYSDATE,NULL);
INSERT INTO BOD_HISTORIAL_PRECIO VALUES (DEFAULT,'P4',4,400,SYSDATE,NULL);

-- ==========================================================
-- BOD_STOCK
-- ==========================================================
INSERT INTO BOD_STOCK VALUES (DEFAULT,1,10,50,5,20);
INSERT INTO BOD_STOCK VALUES (DEFAULT,2,10,50,5,20);
INSERT INTO BOD_STOCK VALUES (DEFAULT,3,10,50,5,20);
INSERT INTO BOD_STOCK VALUES (DEFAULT,4,10,50,5,20);

-- ==========================================================
-- CLI_DETALLE_CARRITO
-- ==========================================================
INSERT INTO CLI_DETALLE_CARRITO VALUES (DEFAULT,1,1,2);
INSERT INTO CLI_DETALLE_CARRITO VALUES (DEFAULT,2,2,3);
INSERT INTO CLI_DETALLE_CARRITO VALUES (DEFAULT,3,3,1);
INSERT INTO CLI_DETALLE_CARRITO VALUES (DEFAULT,4,4,4);

-- ==========================================================
-- BOD_PEDIDO
-- ==========================================================
INSERT INTO BOD_PEDIDO VALUES (DEFAULT,'PED1',SYSDATE,100,'SIMULADO');
INSERT INTO BOD_PEDIDO VALUES (DEFAULT,'PED2',SYSDATE,200,'SIMULADO');
INSERT INTO BOD_PEDIDO VALUES (DEFAULT,'PED3',SYSDATE,300,'SIMULADO');
INSERT INTO BOD_PEDIDO VALUES (DEFAULT,'PED4',SYSDATE,400,'SIMULADO');

-- ==========================================================
-- BOD_DETALLE_PEDIDO
-- ==========================================================
INSERT INTO BOD_DETALLE_PEDIDO VALUES (DEFAULT,1,1,5,3);
INSERT INTO BOD_DETALLE_PEDIDO VALUES (DEFAULT,2,2,6,4);
INSERT INTO BOD_DETALLE_PEDIDO VALUES (DEFAULT,3,3,7,5);
INSERT INTO BOD_DETALLE_PEDIDO VALUES (DEFAULT,4,4,8,6);

-- ==========================================================
-- BOD_ORDEN_COMPRA
-- ==========================================================
INSERT INTO BOD_ORDEN_COMPRA VALUES ('OC1','COD1',1,SYSDATE,500);
INSERT INTO BOD_ORDEN_COMPRA VALUES ('OC2','COD2',2,SYSDATE,600);
INSERT INTO BOD_ORDEN_COMPRA VALUES ('OC3','COD3',3,SYSDATE,700);
INSERT INTO BOD_ORDEN_COMPRA VALUES ('OC4','COD4',4,SYSDATE,800);

-- ==========================================================
-- BOD_ORDEN_DETALLE_PEDIDO
-- ==========================================================
INSERT INTO BOD_ORDEN_DETALLE_PEDIDO VALUES (DEFAULT,'OC1',1,'Madera',100,5);
INSERT INTO BOD_ORDEN_DETALLE_PEDIDO VALUES (DEFAULT,'OC2',2,'Metal',200,6);
INSERT INTO BOD_ORDEN_DETALLE_PEDIDO VALUES (DEFAULT,'OC3',3,'Plastico',300,7);
INSERT INTO BOD_ORDEN_DETALLE_PEDIDO VALUES (DEFAULT,'OC4',4,'Vidrio',400,8);

-- ==========================================================
-- FAC_FACTURA_PROVEEDOR
-- ==========================================================
INSERT INTO FAC_FACTURA_PROVEEDOR VALUES ('OC1','FP1',SYSDATE);
INSERT INTO FAC_FACTURA_PROVEEDOR VALUES ('OC2','FP2',SYSDATE);
INSERT INTO FAC_FACTURA_PROVEEDOR VALUES ('OC3','FP3',SYSDATE);
INSERT INTO FAC_FACTURA_PROVEEDOR VALUES ('OC4','FP4',SYSDATE);

-- ==========================================================
-- FAC_RECLAMO_PROVEEDOR
-- ==========================================================
INSERT INTO FAC_RECLAMO_PROVEEDOR VALUES (DEFAULT,'OC1','Error producto','ABIERTO',SYSDATE,NULL);
INSERT INTO FAC_RECLAMO_PROVEEDOR VALUES (DEFAULT,'OC2','Entrega tardia','CERRADO',SYSDATE,SYSDATE);
INSERT INTO FAC_RECLAMO_PROVEEDOR VALUES (DEFAULT,'OC3','Dañado','ABIERTO',SYSDATE,NULL);
INSERT INTO FAC_RECLAMO_PROVEEDOR VALUES (DEFAULT,'OC4','Faltante','CERRADO',SYSDATE,SYSDATE);