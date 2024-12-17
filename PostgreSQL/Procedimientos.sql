
-- Proceso llamado por pgAgent para cerrar automáticamente el contrato luego de 1 año
CREATE OR REPLACE PROCEDURE actualizar_fecha_cierre()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE contratos
    SET fecha_cierre_cancelacion = CURRENT_DATE
    WHERE fecha_cierre_cancelacion IS NULL 
    AND fecha_firma + INTERVAL '1 year' <= CURRENT_DATE;
END;
$$;
-- DROP PROCEDURE IF EXISTS actualizar_fecha_cierre();



CREATE OR REPLACE PROCEDURE cerrar_contrato(id_contrato_c NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE contratos
    SET fecha_cierre_cancelacion = CURRENT_DATE
    WHERE fecha_cierre_cancelacion IS NULL 
    AND id_contrato = id_contrato_c;
END;
$$;

-- DROP PROCEDURE IF EXISTS cerrar_contrato(id_contrato_c NUMERIC);






--Por id
CREATE OR REPLACE PROCEDURE comprar_lote(id_contrato_p NUMERIC, cod_vbn_p NUMERIC, id_floristeria_p NUMERIC, cantidad_p NUMERIC, precio_inicial_p NUMERIC, precio_final_p NUMERIC, indice_calidad_p NUMERIC, envio boolean)
LANGUAGE plpgsql
AS $$
DECLARE
	r_contrato RECORD;
	r_floristeria RECORD;
	r_detalle_contrato RECORD;
	r_catalogo_productor RECORD;
	r_afiliacion RECORD;
	r_factura_compra RECORD;
	r_lote RECORD;
	precio_envio NUMERIC(9,2);
	monto_factura NUMERIC (9,2);
BEGIN

	SELECT *
    INTO r_contrato
    FROM contratos
    WHERE id_contrato = id_contrato_p
	AND fecha_cierre_cancelacion IS NULL;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró un contrato vigente con el id_contrato %', id_contrato_p;
	END IF;

	SELECT *
    INTO r_catalogo_productor
    FROM catalogos_productores
    WHERE cod_vbn = cod_vbn_p;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró un catálogo con VBN no. %', cod_vbn_p;
	END IF;

	SELECT *
    INTO r_floristeria
    FROM floristerias
    WHERE id_floristeria = id_floristeria_p;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró una floristeria con id_floristeria = %', id_floristeria_p;
	END IF;

	Select *
	INTO r_afiliacion
	FROM afiliaciones
	WHERE id_subastadora = r_contrato.id_subastadora
	AND id_floristeria = r_floristeria.id_floristeria;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'La floristeria "%" no está afiliada a la subastadora, no puede realizar la compra', r_floristeria.nombre;
	END IF;


	Select *
	INTO r_detalle_contrato
	FROM detalles_contratos
	WHERE id_contrato = r_contrato.id_contrato
	AND cod_vbn = r_catalogo_productor.cod_vbn;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'El catálogo "%" no pertenece al contrato de id = %', r_catalogo_productor.nombre, r_contrato.id_contrato;
	END IF;

	
	
	if (envio) then
		precio_envio := precio_final_p * 0.1;
		monto_factura := precio_final_p + precio_envio;
		INSERT INTO facturas_compras (fecha_emision, monto_total, id_subastadora, id_floristeria, envio) VALUES
		(CURRENT_TIMESTAMP, monto_factura, r_contrato.id_subastadora, id_floristeria_p, precio_envio)
		RETURNING id_factura INTO r_factura_compra;
	else
		INSERT INTO facturas_compras (fecha_emision, monto_total, id_subastadora, id_floristeria) VALUES
		(CURRENT_TIMESTAMP, precio_final_p, r_contrato.id_subastadora, id_floristeria_p)
		RETURNING id_factura INTO r_factura_compra;
	end if;

	
	INSERT INTO lotes (id_factura_compra, id_productor, cod_vbn, id_subastadora, id_contrato, cantidad, precio_inicial, indice_calidad, precio_final) VALUES
	(r_factura_compra.id_factura, r_contrato.id_productor, r_catalogo_productor.cod_vbn, r_contrato.id_subastadora, r_contrato.id_contrato, cantidad_p, precio_inicial_p, indice_calidad_p, precio_final_p)
	RETURNING id_lote INTO r_lote;

	
RAISE NOTICE 'Lote comprado con id = %, con id_factura = %', r_lote.id_lote, r_factura_compra.id_factura;
END;
$$;
-- DROP PROCEDURE IF EXISTS comprar_lote(id_contrato_p NUMERIC, cod_vbn_p NUMERIC, id_floristeria_p NUMERIC, cantidad_p NUMERIC, precio_inicial_p NUMERIC, precio_final_p NUMERIC, indice_calidad_p NUMERIC, envio boolean);




-- por nombre
CREATE OR REPLACE PROCEDURE comprar_lote(nombre_productor VARCHAR, nombre_subastadora VARCHAR, cod_vbn_p NUMERIC, nombre_floristeria VARCHAR, cantidad_p NUMERIC, precio_inicial_p NUMERIC, precio_final_p NUMERIC, indice_calidad_p NUMERIC, envio boolean)
LANGUAGE plpgsql
AS $$
DECLARE
	r_productor RECORD;
	r_subastadora RECORD;
	r_contrato RECORD;
	r_floristeria RECORD;
	r_detalle_contrato RECORD;
	r_catalogo_productor RECORD;
	r_afiliacion RECORD;
	r_factura_compra RECORD;
	r_lote RECORD;
	precio_envio NUMERIC(9,2);
	monto_factura NUMERIC (9,2);
BEGIN

	SELECT *
    INTO r_productor
    FROM productores
    WHERE nombre = nombre_productor;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró un productor llamado %', nombre_productor;
	END IF;


	SELECT *
    INTO r_subastadora
    FROM subastadoras
    WHERE nombre = nombre_subastadora;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró una subastadora llamada %', nombre_subastadora;
	END IF;

	
	SELECT *
    INTO r_contrato
    FROM contratos
    WHERE id_productor = r_productor.id_productor
	AND id_subastadora = r_subastadora.id_subastadora
	AND fecha_cierre_cancelacion IS NULL;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró un contrato vigente con el productor % y la subastadora %', nombre_productor, nombre_subastadora;
	END IF;


	SELECT *
    INTO r_catalogo_productor
    FROM catalogos_productores
    WHERE cod_vbn = cod_vbn_p;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró un catálogo con VBN no. %', cod_vbn_p;
	END IF;


	SELECT *
    INTO r_floristeria
    FROM floristerias
    WHERE nombre = nombre_floristeria;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró una floristeria llamada %', nombre_floristeria;
	END IF;


	Select *
	INTO r_afiliacion
	FROM afiliaciones
	WHERE id_subastadora = r_contrato.id_subastadora
	AND id_floristeria = r_floristeria.id_floristeria;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'La floristeria "%" no está afiliada a la subastadora, no puede realizar la compra', nombre_floristeria;
	END IF;


	Select *
	INTO r_detalle_contrato
	FROM detalles_contratos
	WHERE id_contrato = r_contrato.id_contrato
	AND cod_vbn = r_catalogo_productor.cod_vbn;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'El catálogo "%" no pertenece al contrato de id = %', r_catalogo_productor.nombre, r_contrato.id_contrato;
	END IF;

	
	
	if (envio) then
		precio_envio := precio_final_p * 0.1;
		monto_factura := precio_final_p + precio_envio;
		INSERT INTO facturas_compras (fecha_emision, monto_total, id_subastadora, id_floristeria, envio) VALUES
		(CURRENT_TIMESTAMP, monto_factura, r_subastadora.id_subastadora, r_floristeria.id_floristeria, precio_envio)
		RETURNING id_factura INTO r_factura_compra;
	else
		INSERT INTO facturas_compras (fecha_emision, monto_total, id_subastadora, id_floristeria) VALUES
		(CURRENT_TIMESTAMP, precio_final_p, r_subastadora.id_subastadora, r_floristeria.id_floristeria)
		RETURNING id_factura INTO r_factura_compra;
	end if;

	
	INSERT INTO lotes (id_factura_compra, id_productor, cod_vbn, id_subastadora, id_contrato, cantidad, precio_inicial, indice_calidad, precio_final) VALUES
	(r_factura_compra.id_factura, r_contrato.id_productor, r_catalogo_productor.cod_vbn, r_subastadora.id_subastadora, r_contrato.id_contrato, cantidad_p, precio_inicial_p, indice_calidad_p, precio_final_p)
	RETURNING id_lote INTO r_lote;

	
RAISE NOTICE 'Lote comprado con id = %, con id_factura = %', r_lote.id_lote, r_factura_compra.id_factura;
END;
$$;
-- DROP PROCEDURE IF EXISTS comprar_lote(nombre_productor VARCHAR, nombre_subastadora VARCHAR, cod_vbn_p NUMERIC, nombre_floristeria VARCHAR, cantidad_p NUMERIC, precio_inicial_p NUMERIC, precio_final_p NUMERIC, indice_calidad_p NUMERIC, envio boolean);



-- Productor
CREATE OR REPLACE PROCEDURE registrar_productor(nombre_pais_p VARCHAR, nombre_p VARCHAR, sitio_web_p VARCHAR, email_p VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
	r_pais RECORD;
	r_productor RECORD;
BEGIN

	SELECT *
    INTO r_pais
    FROM paises
    WHERE nombre = nombre_pais_p;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró un pais llamado %', nombre_pais_p;
	END IF;

	INSERT INTO productores (nombre, sitio_web, email, id_pais) VALUES
	(nombre_p, sitio_web_p, email_p, r_pais.id_pais)
	RETURNING id_productor INTO r_productor;

	RAISE NOTICE 'Productor creado con id = %', r_productor.id_productor;

END;
$$;
-- DROP PROCEDURE IF EXISTS registrar_productor(nombre_pais_p VARCHAR, nombre_p VARCHAR, sitio_web_p VARCHAR, email_p VARCHAR);




-- Subastadora
CREATE OR REPLACE PROCEDURE registrar_subastadora(nombre_pais_s VARCHAR, nombre_s VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
	r_pais RECORD;
	r_subastadora RECORD;
BEGIN

	SELECT *
    INTO r_pais
    FROM paises
    WHERE nombre = nombre_pais_s;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró un pais llamado %', nombre_pais_s;
	END IF;

	INSERT INTO subastadoras (nombre, id_pais) VALUES
	(nombre_s, r_pais.id_pais)
	RETURNING id_subastadora INTO r_subastadora;

	RAISE NOTICE 'Subastadora creada con id = %', r_subastadora.id_subastadora;

END;
$$;
-- DROP PROCEDURE IF EXISTS registrar_subastadora(nombre_pais_s VARCHAR, nombre_s VARCHAR);



-- Floristeria
CREATE OR REPLACE PROCEDURE registrar_floristeria(nombre_pais_f VARCHAR, nombre_f VARCHAR, email_f VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
	r_pais RECORD;
	r_floristeria RECORD;
BEGIN

	SELECT *
    INTO r_pais
    FROM paises
    WHERE nombre = nombre_pais_f;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró un pais llamado %', nombre_pais_f;
	END IF;

	INSERT INTO floristerias (nombre, email, id_pais) VALUES
	(nombre_f, email_f, r_pais.id_pais)
	RETURNING id_floristeria INTO r_floristeria;

	RAISE NOTICE 'Floristeria creada con id = %', r_floristeria.id_floristeria;

END;
$$;
-- DROP PROCEDURE IF EXISTS registrar_floristeria(nombre_pais_f VARCHAR, nombre_f VARCHAR, email_f VARCHAR);



-- Contrato
CREATE OR REPLACE PROCEDURE registrar_contrato(nombre_productor VARCHAR, nombre_subastadora VARCHAR, porcentaje_produccion NUMERIC)
LANGUAGE plpgsql
AS $$
DECLARE
	r_productor RECORD;
	r_subastadora RECORD;
	r_contrato RECORD;
BEGIN

	SELECT *
    INTO r_productor
    FROM productores
    WHERE nombre = nombre_productor;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró un productor llamado %', nombre_productor;
	END IF;


	SELECT *
    INTO r_subastadora
    FROM subastadoras
    WHERE nombre = nombre_subastadora;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró una subastadora llamada %', nombre_subastadora;
	END IF;

	
	INSERT INTO contratos (id_productor, id_subastadora, porcentaje_produccion_total, fecha_firma, clasificacion, fecha_cierre_cancelacion) VALUES
	(r_productor.id_productor, r_subastadora.id_subastadora, porcentaje_produccion, CURRENT_DATE, 'CA', null) -- La clasificación es indiferente porque un trigger lo cambiará acorde al porcentaje
	RETURNING id_contrato INTO r_contrato;

	RAISE NOTICE 'Contrato creado con id = %', r_contrato.id_contrato;

END;
$$;
-- DROP PROCEDURE IF EXISTS registrar_contrato(nombre_productor VARCHAR, nombre_subastadora VARCHAR, porcentaje_produccion NUMERIC);



-- Catálogo productor
CREATE OR REPLACE PROCEDURE registrar_catalogo_productor(nombre_productor VARCHAR, nombre_flor VARCHAR, cod_vbn_p NUMERIC, nombre_c VARCHAR, descripcion VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
	r_productor RECORD;
	r_flor_corte RECORD;
BEGIN

	SELECT *
    INTO r_productor
    FROM productores
    WHERE nombre = nombre_productor;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró un productor llamado %', nombre_productor;
	END IF;


	SELECT *
    INTO r_flor_corte
    FROM flores_cortes
    WHERE nombre_comun = nombre_flor;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró una flor llamada %', nombre_flor;
	END IF;

	if descripcion is null then
		INSERT INTO catalogos_productores (cod_vbn, id_productor, nombre, id_flor_corte, descripcion) VALUES
		(cod_vbn_p, r_productor.id_productor, nombre_c, r_flor_corte.id_flor_corte, null);
	else
		INSERT INTO catalogos_productores (cod_vbn, id_productor, nombre, id_flor_corte, descripcion) VALUES
		(cod_vbn_p, r_productor.id_productor, nombre_c, r_flor_corte.id_flor_corte, descripcion);
	end if;

	RAISE NOTICE 'Catálogo creado con VBN no. %', cod_vbn_p;

END;
$$;
-- DROP PROCEDURE IF EXISTS registrar_catalogo_productor(nombre_productor VARCHAR, nombre_flor VARCHAR, cod_vbn_p NUMERIC, nombre_c VARCHAR, descripcion VARCHAR);



-- Pago
CREATE OR REPLACE PROCEDURE registrar_pago(nombre_productor VARCHAR, nombre_subastadora VARCHAR, tipo_p VARCHAR, monto_p NUMERIC)
LANGUAGE plpgsql
AS $$
DECLARE
	r_productor RECORD;
	r_subastadora RECORD;
	r_contrato RECORD;
	r_pago RECORD;
BEGIN

	SELECT *
    INTO r_productor
    FROM productores
    WHERE nombre = nombre_productor;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró un productor llamado %', nombre_productor;
	END IF;


	SELECT *
    INTO r_subastadora
    FROM subastadoras
    WHERE nombre = nombre_subastadora;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró una subastadora llamada %', nombre_subastadora;
	END IF;


	SELECT *
    INTO r_contrato
    FROM contratos
    WHERE id_productor = r_productor.id_productor
	AND id_subastadora = r_subastadora.id_subastadora
	AND fecha_cierre_cancelacion IS NULL;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró un contrato vigente entre % y %', nombre_productor, nombre_subastadora;
	END IF;


		INSERT INTO pagos (id_contrato, id_productor, id_subastadora, monto, tipo, fecha_pago) VALUES
		(r_contrato.id_contrato, r_productor.id_productor, r_subastadora.id_subastadora, monto_p, tipo_p, CURRENT_DATE)
		RETURNING id_pago INTO r_pago;


	RAISE NOTICE 'Pago creado con id = %', r_pago.id_pago;

END;
$$;
-- DROP PROCEDURE IF EXISTS registrar_pago(nombre_productor VARCHAR, nombre_subastadora VARCHAR, tipo_p VARCHAR, monto_p NUMERIC);



--Enlace
CREATE OR REPLACE PROCEDURE registrar_enlace(descripcion_significado VARCHAR, tipo_significado VARCHAR, descripcion_e VARCHAR, nombre_comun_flor VARCHAR, nombre_color VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
	r_significado RECORD;
	r_flor_corte RECORD;
	r_color RECORD;
	r_enlace RECORD;
BEGIN

	SELECT *
    INTO r_significado
    FROM significados
    WHERE descripcion = descripcion_significado
	AND tipo = tipo_significado;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró un significado registrado de tipo "%" con la descripcion "%"', tipo_significado, descripcion_significado;
	END IF;

	if nombre_comun_flor IS NOT NULL then
		SELECT *
	    INTO r_flor_corte
	    FROM flores_cortes
	    WHERE nombre_comun = nombre_comun_flor;
	
		IF NOT FOUND THEN
			RAISE EXCEPTION 'No se encontró una flor llamada %', nombre_comun_flor;
		END IF;
	end if;


	if nombre_color IS NOT NULL then
		SELECT *
	    INTO r_color
	    FROM colores_flores
	    WHERE nombre = nombre_color;
	
		IF NOT FOUND THEN
			RAISE EXCEPTION 'No se encontró un color llamado %', nombre_color;
		END IF;
	end if;

	if nombre_comun_flor is null and nombre_color is null then
		RAISE EXCEPTION 'Al menos un color o una flor deben estar asociados al significado mediante a este enlace';
	end if;

		if nombre_comun_flor is null then
		
			if descripcion_e is null then
				INSERT INTO enlaces (id_significado, descripcion, cod_hex, id_flor_corte) VALUES
				(r_significado.id_significado, null, r_color.cod_hex, null)
				RETURNING id_enlace INTO r_enlace;
			else
				INSERT INTO enlaces (id_significado, descripcion, cod_hex, id_flor_corte) VALUES
				(r_significado.id_significado, descripcion_e, r_color.cod_hex, null)
				RETURNING id_enlace INTO r_enlace;
			end if;
			
		elsif nombre_color is null then

			if descripcion_e is null then
				INSERT INTO enlaces (id_significado, descripcion, cod_hex, id_flor_corte) VALUES
				(r_significado.id_significado, null, null, r_flor_corte.id_flor_corte)
				RETURNING id_enlace INTO r_enlace;
			else
				INSERT INTO enlaces (id_significado, descripcion, cod_hex, id_flor_corte) VALUES
				(r_significado.id_significado, descripcion_e, null, r_flor_corte.id_flor_corte)
				RETURNING id_enlace INTO r_enlace;
			end if;
			
		else

			if descripcion_e is null then
				INSERT INTO enlaces (id_significado, descripcion, cod_hex, id_flor_corte) VALUES
				(r_significado.id_significado, null, r_color.cod_hex, r_flor_corte.id_flor_corte)
				RETURNING id_enlace INTO r_enlace;
			else
				INSERT INTO enlaces (id_significado, descripcion, cod_hex, id_flor_corte) VALUES
				(r_significado.id_significado, descripcion_e, r_color.cod_hex, r_flor_corte.id_flor_corte)
				RETURNING id_enlace INTO r_enlace;
			end if;
			
		end if;


	RAISE NOTICE 'Enlace creado con id = %', r_enlace.id_enlace;

END;
$$;
-- DROP PROCEDURE IF EXISTS registrar_enlace(descripcion_significado VARCHAR, tipo_significado VARCHAR, descripcion_e VARCHAR, nombre_comun_flor VARCHAR, nombre_color VARCHAR);


-- Personales
CREATE OR REPLACE PROCEDURE registrar_personal(nombre_floristeria VARCHAR, primer_nombre_p VARCHAR, primer_apellido_p VARCHAR, documento_identidad_p VARCHAR, fecha_nacimiento_p DATE, segundo_nombre_p VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
	r_floristeria RECORD;
	r_personal RECORD;
BEGIN

	SELECT *
    INTO r_floristeria
    FROM floristerias
    WHERE nombre = nombre_floristeria;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró una floristeria llamada %', nombre_floristeria;
	END IF;

	IF segundo_nombre_p IS NULL then
		INSERT INTO personales (id_floristeria, primer_nombre, primer_apelliddo, documento_identidad, fecha_nacimiento, segundo_nombre) VALUES
		(r_floristeria.id_floristeria, primer_nombre_p, primer_apellido_p, documento_identidad_p, fecha_nacimiento_p, null)
		RETURNING id_personal INTO r_personal;
	else
		INSERT INTO personales (id_floristeria, primer_nombre, primer_apelliddo, documento_identidad, fecha_nacimiento, segundo_nombre) VALUES
		(r_floristeria.id_floristeria, primer_nombre_p, primer_apellido_p, documento_identidad_p, fecha_nacimiento_p, segundo_nombre_p)
		RETURNING id_personal INTO r_personal;
	end if;

	RAISE NOTICE 'Personal creado con id = %', r_personal.id_personal;

END;
$$;
-- DROP PROCEDURE IF EXISTS registrar_personal(nombre_floristeria VARCHAR, primer_nombre_p VARCHAR, primer_apellido_p VARCHAR, documento_identidad_p VARCHAR, fecha_nacimiento_p DATE, segundo_nombre_p VARCHAR);




-- Afiliacion
CREATE OR REPLACE PROCEDURE registrar_afiliacion(nombre_subastadora VARCHAR, nombre_floristeria VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
	r_subastadora RECORD;
	r_floristeria RECORD;
BEGIN

	SELECT *
    INTO r_floristeria
    FROM floristerias
    WHERE nombre = nombre_floristeria;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró una floristeria llamada %', nombre_floristeria;
	END IF;


	SELECT *
    INTO r_subastadora
    FROM subastadoras
    WHERE nombre = nombre_subastadora;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró una subastadora llamada %', nombre_subastadora;
	END IF;
	

		INSERT INTO afiliaciones (id_subastadora, id_floristeria) VALUES
		(r_subastadora.id_subastadora, r_floristeria.id_floristeria);

	RAISE NOTICE 'Afiliación entre la subastadora % y la floristeria % creada exitosamente', nombre_subastadora, nombre_floristeria;

END;
$$;
-- DROP PROCEDURE IF EXISTS registrar_afiliacion(nombre_subastadora VARCHAR, nombre_floristeria VARCHAR);



CREATE OR REPLACE PROCEDURE registrar_catalogo_floristeria(nombre_floristeria VARCHAR, cod_vbn_c NUMERIC, nombre_catalogo VARCHAR, nombre_flor VARCHAR, nombre_color VARCHAR, descripcion_c VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
	r_floristeria RECORD;
	r_flor_corte RECORD;
	r_color RECORD;
BEGIN

		SELECT *
	    INTO r_floristeria
	    FROM floristerias
	    WHERE nombre = nombre_floristeria;
	
		IF NOT FOUND THEN
			RAISE EXCEPTION 'No se encontró una floristeria llamada %', nombre_floristeria;
		END IF;


		SELECT *
	    INTO r_flor_corte
	    FROM flores_cortes
	    WHERE nombre_comun = nombre_flor;
	
		IF NOT FOUND THEN
			RAISE EXCEPTION 'No se encontró una flor llamada %', nombre_flor;
		END IF;


		SELECT *
	    INTO r_color
	    FROM colores_flores
	    WHERE nombre = nombre_color;
	
		IF NOT FOUND THEN
			RAISE EXCEPTION 'No se encontró un color llamado %', nombre_color;
		END IF;
	
		if descripcion_c is null then
			INSERT INTO catalogos_floristerias (id_floristeria, cod_vbn, nombre, cod_hex, id_flor_corte, descripcion) VALUES
			(r_floristeria.id_floristeria, cod_vbn_c, nombre_catalogo, r_color.cod_hex, r_flor_corte.id_flor_corte, null);
		else
			INSERT INTO catalogos_floristerias (id_floristeria, cod_vbn, nombre, cod_hex, id_flor_corte, descripcion) VALUES
			(r_floristeria.id_floristeria, cod_vbn_c, nombre_catalogo, r_color.cod_hex, r_flor_corte.id_flor_corte, descripcion_c);
		end if;

	RAISE NOTICE 'Catálogo creado con VBN no. %', cod_vbn_c;

END;
$$;
-- DROP PROCEDURE IF EXISTS registrar_catalogo_floristeria(nombre_floristeria VARCHAR, cod_vbn_c NUMERIC, nombre_catalogo VARCHAR, nombre_flor VARCHAR, nombre_color VARCHAR, descripcion_c VARCHAR);




-- Detalle Bouquet
CREATE OR REPLACE PROCEDURE registrar_bouquet(nombre_catalogo VARCHAR, cantidad_b NUMERIC, descripcion_b VARCHAR, tallo_tamano_b VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
	r_catalogo_f RECORD;
	r_bouquet RECORD;
BEGIN

		SELECT *
	    INTO r_catalogo_f
	    FROM catalogos_floristerias
	    WHERE nombre = nombre_catalogo;
	
		IF NOT FOUND THEN
			RAISE EXCEPTION 'No se encontró un catálogo llamado %', nombre_catalogo;
		END IF;

	
		if descripcion_b is null then
		
			if tallo_tamano_b is null then
				INSERT INTO detalles_bouquets (id_floristeria, cod_vbn, cantidad, descripcion, tamano_tallo) VALUES
				(r_catalogo_f.id_floristeria, r_catalogo_f.cod_vbn, cantidad_b, null, null)
				RETURNING id_detalle_bouquet INTO r_bouquet;
			else
				INSERT INTO detalles_bouquets (id_floristeria, cod_vbn, cantidad, descripcion, tamano_tallo) VALUES
				(r_catalogo_f.id_floristeria, r_catalogo_f.cod_vbn, cantidad_b, null, tallo_tamano_b)
				RETURNING id_detalle_bouquet INTO r_bouquet;
			end if;
			
		else
		
			if tallo_tamano_b is null then
				INSERT INTO detalles_bouquets (id_floristeria, cod_vbn, cantidad, descripcion, tamano_tallo) VALUES
				(r_catalogo_f.id_floristeria, r_catalogo_f.cod_vbn, cantidad_b, descripcion_b, null)
				RETURNING id_detalle_bouquet INTO r_bouquet;
			else
				INSERT INTO detalles_bouquets (id_floristeria, cod_vbn, cantidad, descripcion, tamano_tallo) VALUES
				(r_catalogo_f.id_floristeria, r_catalogo_f.cod_vbn, cantidad_b, descripcion_b, tallo_tamano_b)
				RETURNING id_detalle_bouquet INTO r_bouquet;
			end if;
			
		end if;

	RAISE NOTICE 'Detalle Bouquet creado con id = %', r_bouquet.id_detalle_bouquet;

END;
$$;
-- DROP PROCEDURE IF EXISTS registrar_bouquet(nombre_catalogo VARCHAR, cantidad_b NUMERIC, descripcion_b VARCHAR, tallo_tamano_b VARCHAR);




-- Precio
CREATE OR REPLACE PROCEDURE registrar_precio_catalogo_floristeria(nombre_catalogo VARCHAR, precio_unidad_p NUMERIC, tamano_tallo_p NUMERIC)
LANGUAGE plpgsql
AS $$
DECLARE
	r_catalogo_f RECORD;
BEGIN

		SELECT *
	    INTO r_catalogo_f
	    FROM catalogos_floristerias
	    WHERE nombre = nombre_catalogo;
	
		IF NOT FOUND THEN
			RAISE EXCEPTION 'No se encontró un catálogo llamado %', nombre_catalogo;
		END IF;

	
		if tamano_tallo_p is null then

			INSERT INTO hist_precios_unitarios (id_floristeria, cod_vbn, fecha_inicio, precio_unitario, fecha_fin, tamano_tallo) VALUES
			(r_catalogo_f.id_floristeria, r_catalogo_f.cod_vbn, CURRENT_DATE, precio_unidad_p, null, null);
			
		else
		
			INSERT INTO hist_precios_unitarios (id_floristeria, cod_vbn, fecha_inicio, precio_unitario, fecha_fin, tamano_tallo) VALUES
			(r_catalogo_f.id_floristeria, r_catalogo_f.cod_vbn, CURRENT_DATE, precio_unidad_p, null, tamano_tallo_p);

		end if;

	RAISE NOTICE 'Precio registrado exitosamente para le fecha: %', TO_CHAR(CURRENT_DATE, 'DD-MM-YYYY');

END;
$$;
-- DROP PROCEDURE IF EXISTS registrar_precio_catalogo_floristeria(nombre_catalogo VARCHAR, precio_unidad_p NUMERIC, tamano_tallo_p NUMERIC);




-- Telefono Productor
CREATE OR REPLACE PROCEDURE registrar_telefono_productor(nombre_productor VARCHAR, prefijo_t NUMERIC, cod_area_t NUMERIC, numero_t NUMERIC, tipo_t VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
	r_productor RECORD;
BEGIN

		SELECT *
	    INTO r_productor
	    FROM productores
	    WHERE nombre = nombre_productor;
	
		IF NOT FOUND THEN
			RAISE EXCEPTION 'No se encontró un productor llamado %', nombre_productor;
		END IF;

	

		INSERT INTO telefonos (prefijo, cod_area, numero, tipo, id_productor) VALUES
		(prefijo_t, cod_area_t, numero_t, tipo_t, r_productor.id_productor);


	RAISE NOTICE 'Se registró el número +% % % (%) para el productor %', prefijo_t, cod_area_t, numero_t, tipo_t, r_productor.nombre;

END;
$$;
-- DROP PROCEDURE IF EXISTS registrar_telefono_productor(nombre_productor VARCHAR, prefijo_t NUMERIC, cod_area_t NUMERIC, numero_t NUMERIC, tipo_t VARCHAR);




-- Telefono Floristeria
CREATE OR REPLACE PROCEDURE registrar_telefono_floristeria(nombre_floristeria VARCHAR, prefijo_t NUMERIC, cod_area_t NUMERIC, numero_t NUMERIC, tipo_t VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
	r_floristeria RECORD;
BEGIN

		SELECT *
	    INTO r_floristeria
	    FROM floristerias
	    WHERE nombre = nombre_floristeria;
	
		IF NOT FOUND THEN
			RAISE EXCEPTION 'No se encontró una floristeria llamada %', nombre_floristeria;
		END IF;

	

		INSERT INTO telefonos (prefijo, cod_area, numero, tipo, id_floristeria) VALUES
		(prefijo_t, cod_area_t, numero_t, tipo_t, r_floristeria.id_floristeria);


	RAISE NOTICE 'Se registró el número +% % % (%) para la floristeria %', prefijo_t, cod_area_t, numero_t, tipo_t, r_floristeria.nombre;

END;
$$;
-- DROP PROCEDURE IF EXISTS registrar_telefono_floristeria(nombre_floristeria VARCHAR, prefijo_t NUMERIC, cod_area_t NUMERIC, numero_t NUMERIC, tipo_t VARCHAR);




-- Telefono Subastadora
CREATE OR REPLACE PROCEDURE registrar_telefono_subastadora(nombre_subastadora VARCHAR, prefijo_t NUMERIC, cod_area_t NUMERIC, numero_t NUMERIC, tipo_t VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
	r_subastadora RECORD;
BEGIN

		SELECT *
	    INTO r_subastadora
	    FROM subastadoras
	    WHERE nombre = nombre_subastadora;
	
		IF NOT FOUND THEN
			RAISE EXCEPTION 'No se encontró una subastadora llamada %', nombre_subastadora;
		END IF;
	

		INSERT INTO telefonos (prefijo, cod_area, numero, tipo, id_subastadora) VALUES
		(prefijo_t, cod_area_t, numero_t, tipo_t, r_subastadora.id_subastadora);


	RAISE NOTICE 'Se registró el número +% % % (%) para la subastadora %', prefijo_t, cod_area_t, numero_t, tipo_t, r_subastadora.nombre;

END;
$$;
-- DROP PROCEDURE IF EXISTS registrar_telefono_subastadora(nombre_subastadora VARCHAR, prefijo_t NUMERIC, cod_area_t NUMERIC, numero_t NUMERIC, tipo_t VARCHAR);




-- Telefono Personal
CREATE OR REPLACE PROCEDURE registrar_telefono_personal(nombre_personal VARCHAR, apellido_personal VARCHAR, documento_identidad_p VARCHAR, prefijo_t NUMERIC, cod_area_t NUMERIC, numero_t NUMERIC, tipo_t VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
	r_personal RECORD;
	r_floristeria RECORD;
BEGIN

		SELECT *
	    INTO r_personal
	    FROM personales
	    WHERE primer_nombre = nombre_personal
		AND primer_apelliddo = apellido_personal
		AND documento_identidad = documento_identidad_p;
	
		IF NOT FOUND THEN
			RAISE EXCEPTION 'No se encontró un personal llamado % % con documento de identidad = %', nombre_personal, apellido_personal, documento_identidad_p;
		END IF;

		SELECT *
	    INTO r_floristeria
	    FROM floristerias
	    WHERE id_floristeria = r_personal.id_floristeria;
	

		INSERT INTO telefonos (prefijo, cod_area, numero, tipo, id_floristeria_personal, id_personal) VALUES
		(prefijo_t, cod_area_t, numero_t, tipo_t, r_personal.id_floristeria, r_personal.id_personal);


	RAISE NOTICE 'Se registró el número +% % % (%) para el personal % % (%) perteneciente a la floristería %', prefijo_t, cod_area_t, numero_t, tipo_t, r_personal.primer_nombre, r_personal.primer_apelliddo, r_personal.documento_identidad, r_floristeria.nombre;

END;
$$;
-- DROP PROCEDURE IF EXISTS registrar_telefono_personal(nombre_personal VARCHAR, apellido_personal VARCHAR, documento_identidad_p VARCHAR, prefijo_t NUMERIC, cod_area_t NUMERIC, numero_t NUMERIC, tipo_t VARCHAR);