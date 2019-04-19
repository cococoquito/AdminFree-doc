/*  
 ***************** CREACION ESQUEMA ADMINFREE *******************************
 */ 
CREATE SCHEMA ADMINFREE DEFAULT CHARACTER SET utf8 COLLATE utf8_spanish_ci ;


/* 
 ***************** CREACION DE LAS TABLAS ****************************************
 */ 
CREATE TABLE ADMINFREE.CLIENTES (
  ID_CLIENTE 				  TINYINT	         	NOT NULL AUTO_INCREMENT,
  TOKEN 					      VARCHAR(50)  	NOT NULL,
  NOMBRE 					  VARCHAR(100)	NOT NULL,
  USUARIO 					  VARCHAR(100)	NOT NULL,
  TELEFONOS 				  VARCHAR(50)	 	NULL,
  EMAILS 					      VARCHAR(100)	NULL,
  FECHA_ACTIVACION 	  DATE 		     	NOT NULL,
  FECHA_INACTIVACION DATE 		     	NULL,
  ESTADO 					  TINYINT 	     	NOT NULL,
  PRIMARY KEY (ID_CLIENTE)
);

CREATE TABLE ADMINFREE.USUARIOS (
  ID_USUARIO 								INTEGER			NOT NULL AUTO_INCREMENT,
  NOMBRE 									VARCHAR(100) NOT NULL,
  USUARIO_INGRESO 					VARCHAR(50) 	NOT NULL,
  CLAVE_INGRESO 						VARCHAR(50) 	NOT NULL,
  CLIENTE  									TINYINT	        NOT NULL,
  CARGO										VARCHAR(255) NOT NULL,
  CONSECUTIVOS_SOLICITADOS  INTEGER,
  ESTADO 					TINYINT			NOT NULL,
  PRIMARY KEY (ID_USUARIO),
  FOREIGN KEY(CLIENTE) REFERENCES ADMINFREE.CLIENTES(ID_CLIENTE)
);

CREATE TABLE ADMINFREE.MODULOS (
  TOKEN_MODULO VARCHAR(50)	NOT NULL,
  NOMBRE 	  		  VARCHAR(50)	NOT NULL,
  ORDEN 		  		  TINYINT,
  PRIMARY KEY (TOKEN_MODULO)
);

CREATE TABLE ADMINFREE.USUARIOS_MODULOS (
  ID_USUARIO 		  INTEGER		NOT NULL,
  TOKEN_MODULO VARCHAR(50)	NOT NULL,
  PRIMARY KEY (ID_USUARIO,TOKEN_MODULO),
  FOREIGN KEY(ID_USUARIO) REFERENCES ADMINFREE.USUARIOS(ID_USUARIO),
  FOREIGN KEY(TOKEN_MODULO)  REFERENCES ADMINFREE.MODULOS(TOKEN_MODULO)
);

CREATE TABLE ADMINFREE.RESTRICCIONES (
	ID_RESTRICCION  TINYINT			NOT NULL,
	DESCRIPCION 	 	VARCHAR(255)	NOT NULL,
	PRIMARY KEY (ID_RESTRICCION)
);

CREATE TABLE ADMINFREE.RESTRICCIONES_TIPO_CAMPO (
	RESTRICCION 	TINYINT	NOT NULL,
	TIPO_CAMPO 	TINYINT   NOT NULL,
	COMPATIBLE  	VARCHAR(50),
	PRIMARY KEY (RESTRICCION, TIPO_CAMPO),
	FOREIGN KEY (RESTRICCION) REFERENCES ADMINFREE.RESTRICCIONES(ID_RESTRICCION)
);

CREATE TABLE ADMINFREE.CAMPOS_ENTRADA (
	ID_CAMPO  	  				INTEGER			NOT NULL AUTO_INCREMENT,
	CLIENTE 	  					TINYINT			NOT NULL,
	TIPO_CAMPO 				TINYINT 			NOT NULL,
	NOMBRE 						VARCHAR(100)	NOT NULL,
	DESCRIPCION 				VARCHAR(255),
	PRIMARY KEY (ID_CAMPO),
	FOREIGN KEY (CLIENTE) REFERENCES ADMINFREE.CLIENTES(ID_CLIENTE)
);

CREATE TABLE ADMINFREE.SELECT_ITEMS (
	ID_ITEM		INTEGER			NOT NULL AUTO_INCREMENT,
	CAMPO		INTEGER			NOT NULL,
	VALOR			VARCHAR(255) NOT NULL,
	PRIMARY KEY (ID_ITEM),
	FOREIGN KEY (CAMPO) REFERENCES ADMINFREE.CAMPOS_ENTRADA(ID_CAMPO)
);

CREATE TABLE ADMINFREE.NOMENCLATURAS (
	ID_NOMENCLATURA      				INTEGER		 	NOT NULL AUTO_INCREMENT,
	NOMENCLATURA      	 				VARCHAR(15) 	NOT NULL,
	DESCRIPCION        	 	 				VARCHAR(255) NOT NULL,
	CLIENTE 	  				 	 				TINYINT			NOT NULL,
	CONSECUTIVO_INICIAL 				INTEGER 		 	NOT NULL,
	CONSECUTIVOS_SOLICITADOS  	INTEGER,
	SECUENCIA 				 				INTEGER,
	PRIMARY KEY (ID_NOMENCLATURA),
	FOREIGN KEY (CLIENTE) REFERENCES ADMINFREE.CLIENTES(ID_CLIENTE)
);

CREATE TABLE ADMINFREE.NOMENCLATURAS_CAMPOS_ENTRADA (
	ID_NOME_CAMPO    	INTEGER NOT NULL AUTO_INCREMENT,
	NOMENCLATURA  		INTEGER NOT NULL,
	CAMPO 						INTEGER NOT NULL,
	ORDEN 		  		  		TINYINT   NOT NULL,
	TIENE_CONSECUTIVO  TINYINT(1),
	PRIMARY KEY (ID_NOME_CAMPO),
	FOREIGN KEY (NOMENCLATURA) REFERENCES ADMINFREE.NOMENCLATURAS(ID_NOMENCLATURA),
	FOREIGN KEY (CAMPO) REFERENCES ADMINFREE.CAMPOS_ENTRADA(ID_CAMPO)
);

CREATE TABLE ADMINFREE.NOMENCLATURAS_CAMPOS_RESTRICS (
	ID_NOME_CAMPO	INTEGER	NOT NULL,
	RESTRICCION 	 		TINYINT	NOT NULL,
	PRIMARY KEY (ID_NOME_CAMPO,RESTRICCION),
	FOREIGN KEY (ID_NOME_CAMPO) REFERENCES ADMINFREE.NOMENCLATURAS_CAMPOS_ENTRADA(ID_NOME_CAMPO),
	FOREIGN KEY (RESTRICCION) REFERENCES ADMINFREE.RESTRICCIONES(ID_RESTRICCION)
);

CREATE TABLE ADMINFREE.NOMENCLATURAS_CIERRES_ANIO (
	ANIO 								VARCHAR(4) NOT NULL,
	NOMENCLATURA 			INTEGER NOT NULL,
	TOTAL_CONSECUTIVOS 	INTEGER NOT NULL,
	FOREIGN KEY (NOMENCLATURA) REFERENCES ADMINFREE.NOMENCLATURAS(ID_NOMENCLATURA)
);

CREATE TABLE ADMINFREE.TIPOS_DOCUMENTALES (
	ID_TIPO_DOC 	INTEGER NOT NULL AUTO_INCREMENT,
	NOMBRE 			VARCHAR(255) NOT NULL,
	PRIMARY KEY (ID_TIPO_DOC)
);

CREATE TABLE ADMINFREE.SERIES_DOCUMENTALES (
	ID_SERIE 		INTEGER NOT NULL AUTO_INCREMENT,
	CLIENTE 	  		TINYINT NOT NULL,
	CODIGO 			VARCHAR(50) NOT NULL,
	NOMBRE 			VARCHAR(255) NOT NULL,
	AG					TINYINT(3)NULL,
	AC					TINYINT(3)NULL,
	CT					TINYINT(1)NULL,
	M						TINYINT(1)NULL,
	S						TINYINT(1)NULL,
	E						TINYINT(1)NULL,
	PROCEDIMIENTO 	  	 	VARCHAR(500)NULL,
	CANT_CONSECUTIVOS 	INTEGER NULL,
	FECHA_CREACION	  	  	DATE NOT NULL,
	USUARIO_CREACION 		INTEGER NULL,
	FOREIGN KEY (USUARIO_CREACION) REFERENCES ADMINFREE.USUARIOS(ID_USUARIO),
	FOREIGN KEY (CLIENTE) REFERENCES ADMINFREE.CLIENTES(ID_CLIENTE),
	PRIMARY KEY (ID_SERIE)
);

CREATE TABLE ADMINFREE.SUBSERIES_DOCUMENTALES (
	ID_SUBSERIE 	INTEGER NOT NULL AUTO_INCREMENT,
	ID_SERIE         INTEGER NOT NULL,
	CODIGO 			VARCHAR(50) NOT NULL,
	NOMBRE 			VARCHAR(255) NOT NULL,
	AG					TINYINT(3)NULL,
	AC					TINYINT(3)NULL,
	CT					TINYINT(1)NULL,
	M						TINYINT(1)NULL,
	S						TINYINT(1)NULL,
	E						TINYINT(1)NULL,
	PROCEDIMIENTO 	  	  VARCHAR(500)NULL,
	CANT_CONSECUTIVOS INTEGER NULL,
	FECHA_CREACION	  	  DATE NOT NULL,
	USUARIO_CREACION 	  INTEGER NULL,
	FOREIGN KEY (USUARIO_CREACION) REFERENCES ADMINFREE.USUARIOS(ID_USUARIO),
	FOREIGN KEY (ID_SERIE) REFERENCES ADMINFREE.SERIES_DOCUMENTALES(ID_SERIE),
	PRIMARY KEY (ID_SUBSERIE)
);

CREATE TABLE ADMINFREE.TIPOS_DOCUMENTALES_SERIES (
	ID_TIPO_DOC 		INTEGER NOT NULL,
	ID_SERIE 			INTEGER NOT NULL,
	FOREIGN KEY (ID_TIPO_DOC) REFERENCES ADMINFREE.TIPOS_DOCUMENTALES(ID_TIPO_DOC),
	FOREIGN KEY (ID_SERIE) REFERENCES ADMINFREE.SERIES_DOCUMENTALES(ID_SERIE),
	PRIMARY KEY (ID_TIPO_DOC,ID_SERIE)
);

CREATE TABLE ADMINFREE.TIPOS_DOCUMENTALES_SUBSERIES (
	ID_TIPO_DOC 		INTEGER NOT NULL,
	ID_SUBSERIE 		INTEGER NOT NULL,
	FOREIGN KEY (ID_TIPO_DOC) REFERENCES ADMINFREE.TIPOS_DOCUMENTALES(ID_TIPO_DOC),
	FOREIGN KEY (ID_SUBSERIE) REFERENCES ADMINFREE.SUBSERIES_DOCUMENTALES(ID_SUBSERIE),
	PRIMARY KEY (ID_TIPO_DOC,ID_SUBSERIE)
);

CREATE TABLE ADMINFREE.TRDS (
	ID_TRD 							INTEGER NOT NULL AUTO_INCREMENT,
	NOMENCLATURA 			INTEGER NOT NULL, 
	ID_SERIE	 						INTEGER NOT NULL,
	ID_SUBSERIE	 				INTEGER NULL,
	FECHA_ASOCIACION 		DATE NOT NULL,
	USUARIO_ASOCIACION 	INTEGER NULL,
	FOREIGN KEY (NOMENCLATURA) REFERENCES ADMINFREE.NOMENCLATURAS(ID_NOMENCLATURA),
	FOREIGN KEY (ID_SERIE) REFERENCES ADMINFREE.SERIES_DOCUMENTALES(ID_SERIE),
	FOREIGN KEY (ID_SUBSERIE) REFERENCES ADMINFREE.SUBSERIES_DOCUMENTALES(ID_SUBSERIE),
	FOREIGN KEY (USUARIO_ASOCIACION) REFERENCES ADMINFREE.USUARIOS(ID_USUARIO),
	PRIMARY KEY (ID_TRD)
);

/*
 *****************CREACION DE PROCEDIMIENTOS ALMACENADOS****************************
 */
DELIMITER //
 	CREATE PROCEDURE ADMINFREE.PR_CREAR_CLIENTE(
		IN P_TOKEN 			VARCHAR(255),
		IN P_NOMBRE 		VARCHAR(255),
		IN P_TELEFONOS 	VARCHAR(255),
		IN P_EMAILS 			VARCHAR(255),
		IN P_USUARIO 		VARCHAR(255),
		OUT RESPUESTA 	VARCHAR(700))
	BEGIN
		DECLARE V_ID_CLIENTE TINYINT;

		/*Manejo de errores*/
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			ROLLBACK;
			GET STACKED DIAGNOSTICS CONDITION 1 RESPUESTA = MESSAGE_TEXT;
		END;

		/*Inicia transaccion*/
		START TRANSACTION;

		/*se hace la inserccion del cliente*/
		INSERT INTO CLIENTES (TOKEN, NOMBRE, TELEFONOS, EMAILS, ESTADO, FECHA_ACTIVACION, USUARIO)
		VALUES (P_TOKEN, P_NOMBRE, P_TELEFONOS, P_EMAILS, 1, CURDATE(), P_USUARIO);

		/*se obtiene el id del cliente*/
		SELECT ID_CLIENTE  INTO V_ID_CLIENTE FROM CLIENTES WHERE TOKEN = P_TOKEN;

		/*creacion de la tabla consecutivos*/
		SET @tbl_conse = CONCAT('CREATE TABLE IF NOT EXISTS ', CONCAT('CONSECUTIVOS_',V_ID_CLIENTE) ,'(');
		SET @tbl_conse = CONCAT(@tbl_conse,'ID_CONSECUTIVO BIGINT NOT NULL AUTO_INCREMENT,');
		SET @tbl_conse = CONCAT(@tbl_conse,'NOMENCLATURA INTEGER NOT NULL,');
		SET @tbl_conse = CONCAT(@tbl_conse,'CONSECUTIVO VARCHAR(10) NOT NULL,');
		SET @tbl_conse = CONCAT(@tbl_conse,'USUARIO INTEGER,');
		SET @tbl_conse = CONCAT(@tbl_conse,'FECHA_SOLICITUD DATE NOT NULL,');
		SET @tbl_conse = CONCAT(@tbl_conse,'FECHA_ANULACION DATE,');
		SET @tbl_conse = CONCAT(@tbl_conse,'ESTADO TINYINT NOT NULL,');
		SET @tbl_conse = CONCAT(@tbl_conse,'PRIMARY KEY (ID_CONSECUTIVO),');
		SET @tbl_conse = CONCAT(@tbl_conse,'FOREIGN KEY (NOMENCLATURA) REFERENCES ADMINFREE.NOMENCLATURAS(ID_NOMENCLATURA),');
		SET @tbl_conse = CONCAT(@tbl_conse,'FOREIGN KEY (USUARIO) REFERENCES ADMINFREE.USUARIOS(ID_USUARIO))');
		PREPARE pre_tbl_conse FROM @tbl_conse;
		EXECUTE pre_tbl_conse;

		/*creacion de la tabla consecutivos values*/
		SET @tbl_values = CONCAT('CREATE TABLE IF NOT EXISTS ', CONCAT('CONSECUTIVOS_VALUES_',V_ID_CLIENTE) ,'(');
		SET @tbl_values = CONCAT(@tbl_values,'ID_VALUE BIGINT NOT NULL AUTO_INCREMENT,');
		SET @tbl_values = CONCAT(@tbl_values,'ID_CONSECUTIVO BIGINT NOT NULL,');
		SET @tbl_values = CONCAT(@tbl_values,'ID_NOME_CAMPO INTEGER NOT NULL,');
		SET @tbl_values = CONCAT(@tbl_values,'VALOR VARCHAR(500),');
		SET @tbl_values = CONCAT(@tbl_values,'PRIMARY KEY (ID_VALUE),');
		SET @tbl_values = CONCAT(@tbl_values,'FOREIGN KEY (ID_CONSECUTIVO) REFERENCES ADMINFREE.', CONCAT('CONSECUTIVOS_',V_ID_CLIENTE,'(ID_CONSECUTIVO),'));
		SET @tbl_values = CONCAT(@tbl_values,'FOREIGN KEY (ID_NOME_CAMPO) REFERENCES ADMINFREE.NOMENCLATURAS_CAMPOS_ENTRADA(ID_NOME_CAMPO))');
		PREPARE pre_tbl_values FROM @tbl_values;
		EXECUTE pre_tbl_values;

		/*creacion de la tabla consecutivos documentos*/
		SET @tbl_docs = CONCAT('CREATE TABLE IF NOT EXISTS ', CONCAT('CONSECUTIVOS_DOCUMENTOS_',V_ID_CLIENTE) ,'(');
		SET @tbl_docs = CONCAT(@tbl_docs,'ID_DOC BIGINT NOT NULL AUTO_INCREMENT,');
		SET @tbl_docs = CONCAT(@tbl_docs,'ID_CONSECUTIVO BIGINT NOT NULL,');
		SET @tbl_docs = CONCAT(@tbl_docs,'NOMBRE_DOCUMENTO VARCHAR(255) NOT NULL,');
		SET @tbl_docs = CONCAT(@tbl_docs,'TIPO_DOCUMENTO VARCHAR(200) NOT NULL,');
		SET @tbl_docs = CONCAT(@tbl_docs,'SIZE_DOCUMENTO VARCHAR(50) NOT NULL,');
		SET @tbl_docs = CONCAT(@tbl_docs,'FECHA_CARGUE DATE NOT NULL,');
		SET @tbl_docs = CONCAT(@tbl_docs,'PRIMARY KEY (ID_DOC),');
		SET @tbl_docs = CONCAT(@tbl_docs,'FOREIGN KEY (ID_CONSECUTIVO) REFERENCES ADMINFREE.', CONCAT('CONSECUTIVOS_',V_ID_CLIENTE,'(ID_CONSECUTIVO))'));
		PREPARE pre_tbl_docs FROM @tbl_docs;
		EXECUTE pre_tbl_docs;

		/*creacion de la tabla consecutivos transferencias*/
		SET @tbl_trans = CONCAT('CREATE TABLE IF NOT EXISTS ', CONCAT('CONSECUTIVOS_TRANS_',V_ID_CLIENTE) ,'(');
		SET @tbl_trans = CONCAT(@tbl_trans,'ID_TRANS BIGINT NOT NULL AUTO_INCREMENT,');
		SET @tbl_trans = CONCAT(@tbl_trans,'ID_CONSECUTIVO BIGINT NOT NULL,');
		SET @tbl_trans = CONCAT(@tbl_trans,'USUARIO INTEGER,');
		SET @tbl_trans = CONCAT(@tbl_trans,'FECHA_TRANSFERIDO DATE NOT NULL,');
		SET @tbl_trans = CONCAT(@tbl_trans,'PRIMARY KEY (ID_TRANS),');
		SET @tbl_trans = CONCAT(@tbl_trans,'FOREIGN KEY (ID_CONSECUTIVO) REFERENCES ADMINFREE.', CONCAT('CONSECUTIVOS_',V_ID_CLIENTE,'(ID_CONSECUTIVO),'));
		SET @tbl_trans = CONCAT(@tbl_trans,'FOREIGN KEY (USUARIO) REFERENCES ADMINFREE.USUARIOS(ID_USUARIO))');
		PREPARE pre_tbl_trans FROM @tbl_trans;
		EXECUTE pre_tbl_trans;

		/*Fin de transaccion */
		COMMIT;

		/*Mandamos OK si todo salio bien*/
		SET RESPUESTA = 'OK';
	END //
DELIMITER;

DELIMITER //
	CREATE PROCEDURE ADMINFREE.PR_ELIMINAR_CLIENTE(IN ID TINYINT,  OUT RESPUESTA VARCHAR(700))
	BEGIN

		/*Manejo de errores*/ 
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			ROLLBACK;
			GET STACKED DIAGNOSTICS CONDITION 1 RESPUESTA = MESSAGE_TEXT;
		END;

		/*Inicia transaccion*/ 
		START TRANSACTION;

			/*eliminacion de la tabla consecutivos documentos*/
			SET @tbl_docs = CONCAT('DROP TABLE ', CONCAT('CONSECUTIVOS_DOCUMENTOS_',ID));
			PREPARE pre_tbl_docs FROM @tbl_docs;
			EXECUTE pre_tbl_docs;

			/*eliminacion de la tabla consecutivos values*/
			SET @tbl_values = CONCAT('DROP TABLE ', CONCAT('CONSECUTIVOS_VALUES_',ID));
			PREPARE pre_tbl_values FROM @tbl_values;
			EXECUTE pre_tbl_values;

			/*eliminacion de la tabla consecutivos*/
			SET @tbl_conse = CONCAT('DROP TABLE ', CONCAT('CONSECUTIVOS_',ID));
			PREPARE pre_tbl_conse FROM @tbl_conse;
			EXECUTE pre_tbl_conse;

			/*Se elimina las restricciones asociados a los campos del cliente*/
			DELETE FROM ADMINFREE.CAMPOS_ENTRADA_RESTRICCIONES WHERE CAMPO IN(SELECT CE.ID_CAMPO FROM CAMPOS_ENTRADA CE WHERE CE.CLIENTE = ID);

			/*Se elimina los items de los campos asociados al cliente*/
			DELETE FROM ADMINFREE.SELECT_ITEMS WHERE CAMPO IN(SELECT CE.ID_CAMPO FROM CAMPOS_ENTRADA CE WHERE CE.CLIENTE = ID);

			/*Se elimina los campos asociados a las nomenclaturas del cliente*/
			DELETE FROM ADMINFREE.NOMENCLATURAS_CAMPOS_ENTRADA WHERE CAMPO IN(SELECT CE.ID_CAMPO FROM CAMPOS_ENTRADA CE WHERE CE.CLIENTE = ID);

			/*Se elimina los campos asociados al cliente*/
			DELETE FROM ADMINFREE.CAMPOS_ENTRADA WHERE CLIENTE = ID;

			/*Se elimina los cierres de anio para las nomenclaturas del cliente*/
			DELETE FROM ADMINFREE.NOMENCLATURAS_CIERRES_ANIO WHERE NOMENCLATURA IN(SELECT NOM.ID_NOMENCLATURA FROM NOMENCLATURAS NOM WHERE NOM.CLIENTE = ID);

			/*Se elimina las nomenclaturas*/
			DELETE FROM ADMINFREE.NOMENCLATURAS WHERE CLIENTE = ID;

			/*Se elimina los modulos relacionados a todos los usuarios relacionados al cliente*/ 
			DELETE FROM ADMINFREE.USUARIOS_MODULOS WHERE ID_USUARIO IN (SELECT ID_USUARIO FROM ADMINFREE.USUARIOS WHERE CLIENTE = ID);

			/*Se elimina todos los usuarios relacionados al cliente*/ 
			DELETE FROM ADMINFREE.USUARIOS WHERE CLIENTE = ID;

			/*Se elimina el cliente*/ 
			DELETE FROM ADMINFREE.CLIENTES WHERE ID_CLIENTE = ID;

		/*Fin de transaccion */ 
		COMMIT; 

		/*Mandamos OK si todo salio bien*/ 
		SET RESPUESTA = 'OK';
	END //
DELIMITER ;


/* 
 ****************************************INSERTS INICIALES***************************************************
 */ 
INSERT INTO ADMINFREE.MODULOS (TOKEN_MODULO, NOMBRE, ORDEN)  VALUES  ('9f1124f946de506332f221a01d39c411', ' Correspondencia', 1);
INSERT INTO ADMINFREE.MODULOS (TOKEN_MODULO, NOMBRE, ORDEN)  VALUES  ('a9ee4d222a05960a00ea9b5eb6fb0a81', ' Archivo de Gestión', 2);
INSERT INTO ADMINFREE.MODULOS (TOKEN_MODULO, NOMBRE, ORDEN)  VALUES  ('b6177afc6e3818cb7cb663cf71ef1ce4', ' Reportes', 3);
INSERT INTO ADMINFREE.MODULOS (TOKEN_MODULO, NOMBRE, ORDEN)  VALUES  ('4813e117da87e1ae5bdfb0d4967f4387', ' Configuraciones', 4);

INSERT INTO ADMINFREE.RESTRICCIONES (ID_RESTRICCION, DESCRIPCION) VALUES (1, 'El campo es obligatorio');
INSERT INTO ADMINFREE.RESTRICCIONES (ID_RESTRICCION, DESCRIPCION) VALUES (2, 'El valor del campo debe ser solo números' );
INSERT INTO ADMINFREE.RESTRICCIONES (ID_RESTRICCION, DESCRIPCION) VALUES (3, 'El valor del campo debe ser único solamente para la nomenclatura asociada al campo');
INSERT INTO ADMINFREE.RESTRICCIONES (ID_RESTRICCION, DESCRIPCION) VALUES (4, 'El valor del campo debe ser único para todas las nomenclaturas asociadas al campo');
INSERT INTO ADMINFREE.RESTRICCIONES (ID_RESTRICCION, DESCRIPCION) VALUES (5, 'El valor por defecto de la fecha será la fecha actual y el usuario NO podrá modificar este valor');
INSERT INTO ADMINFREE.RESTRICCIONES (ID_RESTRICCION, DESCRIPCION) VALUES (6, 'El valor por defecto de la fecha será la fecha actual y el usuario SI podrá modificar este valor');
INSERT INTO ADMINFREE.RESTRICCIONES (ID_RESTRICCION, DESCRIPCION) VALUES (7, 'El valor de la fecha debe ser mayor que la fecha actual');
INSERT INTO ADMINFREE.RESTRICCIONES (ID_RESTRICCION, DESCRIPCION) VALUES (8, 'El valor de la fecha debe ser menor que la fecha actual');
INSERT INTO ADMINFREE.RESTRICCIONES (ID_RESTRICCION, DESCRIPCION) VALUES (9, 'El valor inicial de la casilla será "NO"');
INSERT INTO ADMINFREE.RESTRICCIONES (ID_RESTRICCION, DESCRIPCION) VALUES (10, 'El valor inicial de la casilla será "SI"');
INSERT INTO ADMINFREE.RESTRICCIONES (ID_RESTRICCION, DESCRIPCION) VALUES (11, 'El valor de la fecha debe ser mayor o igual que la fecha actual');
INSERT INTO ADMINFREE.RESTRICCIONES (ID_RESTRICCION, DESCRIPCION) VALUES (12, 'El valor de la fecha debe ser menor o igual que la fecha actual');

INSERT INTO ADMINFREE.RESTRICCIONES_TIPO_CAMPO(TIPO_CAMPO, RESTRICCION, COMPATIBLE) VALUES (1, 1, NULL);
INSERT INTO ADMINFREE.RESTRICCIONES_TIPO_CAMPO(TIPO_CAMPO, RESTRICCION, COMPATIBLE) VALUES (1, 2, NULL);
INSERT INTO ADMINFREE.RESTRICCIONES_TIPO_CAMPO(TIPO_CAMPO, RESTRICCION, COMPATIBLE) VALUES (1, 3, '4');
INSERT INTO ADMINFREE.RESTRICCIONES_TIPO_CAMPO(TIPO_CAMPO, RESTRICCION, COMPATIBLE) VALUES (1, 4, '3');
INSERT INTO ADMINFREE.RESTRICCIONES_TIPO_CAMPO(TIPO_CAMPO, RESTRICCION, COMPATIBLE) VALUES (2, 1, NULL);
INSERT INTO ADMINFREE.RESTRICCIONES_TIPO_CAMPO(TIPO_CAMPO, RESTRICCION, COMPATIBLE) VALUES (3, 9, '10');
INSERT INTO ADMINFREE.RESTRICCIONES_TIPO_CAMPO(TIPO_CAMPO, RESTRICCION, COMPATIBLE) VALUES (3, 10, '9');
INSERT INTO ADMINFREE.RESTRICCIONES_TIPO_CAMPO(TIPO_CAMPO, RESTRICCION, COMPATIBLE) VALUES (4, 1, NULL);
INSERT INTO ADMINFREE.RESTRICCIONES_TIPO_CAMPO(TIPO_CAMPO, RESTRICCION, COMPATIBLE) VALUES (4, 5, '6,7,8');
INSERT INTO ADMINFREE.RESTRICCIONES_TIPO_CAMPO(TIPO_CAMPO, RESTRICCION, COMPATIBLE) VALUES (4, 6, '5,7,8');
INSERT INTO ADMINFREE.RESTRICCIONES_TIPO_CAMPO(TIPO_CAMPO, RESTRICCION, COMPATIBLE) VALUES (4, 7, '5,6,8,11,12');
INSERT INTO ADMINFREE.RESTRICCIONES_TIPO_CAMPO(TIPO_CAMPO, RESTRICCION, COMPATIBLE) VALUES (4, 8, '5,6,7,11,12');
INSERT INTO ADMINFREE.RESTRICCIONES_TIPO_CAMPO(TIPO_CAMPO, RESTRICCION, COMPATIBLE) VALUES (4, 11, '7,8,12');
INSERT INTO ADMINFREE.RESTRICCIONES_TIPO_CAMPO(TIPO_CAMPO, RESTRICCION, COMPATIBLE) VALUES (4, 12, '7,8,11');
