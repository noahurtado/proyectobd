
--Arco exclusivo de detalles_facturas_ventas
CREATE OR REPLACE FUNCTION validar_arco_exclusivo_factura_venta()
RETURNS TRIGGER AS $$
BEGIN
    -- Validar que al menos uno de los conjuntos de claves no sea nulo
    IF (NEW.id_floristeria_bouquet IS NULL AND NEW.cod_vbn_bouquet IS NULL AND NEW.id_detalle_bouquet IS NULL
        AND NEW.id_floristeria_cat IS NULL AND NEW.cod_vbn_cat IS NULL) THEN
        RAISE EXCEPTION 'La factura debe pertenecer a un bouquet o a un catalogo';
    END IF;

    -- Validar que solo uno de los conjuntos de claves tenga valores no nulos
    IF (NEW.id_floristeria_bouquet IS NOT NULL AND NEW.cod_vbn_bouquet IS NOT NULL AND NEW.id_detalle_bouquet IS NOT NULL) THEN
        IF (NEW.id_floristeria_cat IS NOT NULL OR NEW.cod_vbn_cat IS NOT NULL) THEN
            RAISE EXCEPTION 'Error, factura ya asignada a un bouquet o catalogo';
        END IF;
    ELSIF (NEW.id_floristeria_cat IS NOT NULL AND NEW.cod_vbn_cat IS NOT NULL) THEN
        IF (NEW.id_floristeria_bouquet IS NOT NULL OR NEW.cod_vbn_bouquet IS NOT NULL OR NEW.id_detalle_bouquet IS NOT NULL) THEN
            RAISE EXCEPTION 'Error, factura ya asignada a un catalogo o bouquet';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER TRG_validar_arco_exclusivo_factura_venta
BEFORE INSERT OR UPDATE ON detalles_facturas_ventas
FOR EACH ROW
EXECUTE FUNCTION validar_arco_exclusivo_factura_venta();

-- ALTER TABLE detalles_facturas_ventas DISABLE TRIGGER TRG_validar_arco_exclusivo_factura_venta;
-- ALTER TABLE detalles_facturas_ventas ENABLE TRIGGER TRG_validar_arco_exclusivo_factura_venta;




--Arco exclusivo de teléfono
CREATE OR REPLACE FUNCTION validar_arco_exclusivo_telefono()
RETURNS TRIGGER AS $$
BEGIN
    -- Validar que al menos uno de los conjuntos de claves no sea nulo
    IF (NEW.id_floristeria IS NULL AND NEW.id_productor IS NULL AND NEW.id_floristeria_personal IS NULL
        AND NEW.id_personal IS NULL AND NEW.id_subastadora IS NULL) THEN
        RAISE EXCEPTION 'El telefono debe pertenecerle a algun individuo u organizacion';
    END IF;

    -- Validar que solo uno de los conjuntos de claves tenga valores no nulos
    IF (NEW.id_floristeria IS NOT NULL) THEN
        IF (NEW.id_productor IS NOT NULL) OR (NEW.id_floristeria_personal IS NOT NULL OR NEW.id_personal IS NOT NULL) OR (NEW.id_subastadora IS NOT NULL) THEN
            RAISE EXCEPTION 'Error, telefono ya asignado a un individuo u organizacion';
        END IF;
    ELSIF (NEW.id_productor IS NOT NULL) THEN
        IF (NEW.id_floristeria IS NOT NULL) OR (NEW.id_floristeria_personal IS NOT NULL OR NEW.id_personal IS NOT NULL) OR (NEW.id_subastadora IS NOT NULL) THEN
            RAISE EXCEPTION 'Error, telefono ya asignado a un individuo u organizacion';
        END IF;
	ELSIF (NEW.id_floristeria_personal IS NOT NULL AND NEW.id_personal IS NOT NULL) THEN
        IF (NEW.id_floristeria IS NOT NULL) OR (NEW.id_productor IS NOT NULL) OR (NEW.id_subastadora IS NOT NULL) THEN
            RAISE EXCEPTION 'Error, telefono ya asignado a un individuo u organizacion';
        END IF;
	ELSIF (NEW.id_subastadora IS NOT NULL) THEN
        IF (NEW.id_floristeria IS NOT NULL) OR (NEW.id_floristeria_personal IS NOT NULL OR NEW.id_personal IS NOT NULL) OR (NEW.id_productor IS NOT NULL) THEN
            RAISE EXCEPTION 'Error, telefono ya asignado a un individuo u organizacion';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER TRG_validar_arco_exclusivo_telefono
BEFORE INSERT OR UPDATE ON telefonos
FOR EACH ROW
EXECUTE FUNCTION validar_arco_exclusivo_telefono();

-- ALTER TABLE telefonos DISABLE TRIGGER TRG_validar_arco_exclusivo_telefono;
-- ALTER TABLE telefonos ENABLE TRIGGER TRG_validar_arco_exclusivo_telefono;




--Opcionalidad de FK de la tabla Enlace
CREATE OR REPLACE FUNCTION validar_FKs_enlace()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.cod_hex IS NULL AND NEW.id_flor_corte IS NULL) THEN
        RAISE EXCEPTION 'El enlace debe pertenecerle a al menos un color y/o una flor';
    END IF;
	
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRG_validar_FKs_enlace
BEFORE INSERT OR UPDATE ON enlaces
FOR EACH ROW
EXECUTE FUNCTION validar_FKs_enlace();

-- ALTER TABLE enlaces DISABLE TRIGGER TRG_validar_FKs_enlace;
-- ALTER TABLE enlaces ENABLE TRIGGER TRG_validar_FKs_enlace;





CREATE OR REPLACE FUNCTION verificar_porcentaje_produccion()
RETURNS TRIGGER AS $$
DECLARE
    total_produccion NUMERIC(5,2);
BEGIN

    -- Verificar el porcentaje de producción total de los contratos activos (fecha_cierre_cancelacion IS NULL)
    SELECT SUM(porcentaje_produccion_total) INTO total_produccion
    FROM contratos
    WHERE id_productor = NEW.id_productor
    AND fecha_cierre_cancelacion IS NULL;

    -- Sumar el porcentaje del nuevo contrato al total de producción
    total_produccion := total_produccion + NEW.porcentaje_produccion_total;

    -- Verificar si el total supera el 100%
    IF total_produccion > 100 THEN
        RAISE EXCEPTION 'La suma del porcentaje de producción para el productor con ID % supera el 100%%', NEW.id_productor;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRG_verificar_porcentaje_produccion
BEFORE INSERT ON contratos
FOR EACH ROW
EXECUTE FUNCTION verificar_porcentaje_produccion();

-- ALTER TABLE contratos DISABLE TRIGGER TRG_verificar_porcentaje_produccion;
-- ALTER TABLE contratos ENABLE TRIGGER TRG_verificar_porcentaje_produccion;




CREATE OR REPLACE FUNCTION verificar_contrato_membresia()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar que id_contrato_renovado no sea igual a id_contrato
    IF NEW.id_contrato_renovado IS NOT NULL 
       AND NEW.id_contrato_renovado = NEW.id_contrato THEN
        RAISE EXCEPTION 'id_contrato_renovado no puede ser igual a id_contrato.';
    END IF;

    -- Verificar si la operación es una actualización
    IF TG_OP = 'UPDATE' THEN
        -- Permitir la actualización de fecha_cierre_cancelacion si está siendo cambiada
        IF NEW.fecha_cierre_cancelacion IS DISTINCT FROM OLD.fecha_cierre_cancelacion THEN
            RETURN NEW;
        END IF;

        -- Impedir la actualización si fecha_cierre_cancelacion es NULL
        IF NEW.fecha_cierre_cancelacion IS NULL AND NEW.clasificacion IS DISTINCT FROM OLD.clasificacion THEN
		RETURN NEW;
		ELSIF NEW.fecha_cierre_cancelacion IS NULL THEN
		RAISE EXCEPTION 'No se puede actualizar si fecha_cierre_cancelacion es NULL.';
		END IF;
		
        -- Permitir la actualización de los campos de renovación
        IF NEW.id_productor_renovado IS DISTINCT FROM OLD.id_productor_renovado
           OR NEW.id_subastadora_renovado IS DISTINCT FROM OLD.id_subastadora_renovado
           OR NEW.id_contrato_renovado IS DISTINCT FROM OLD.id_contrato_renovado THEN
            RETURN NEW;
        END IF;
    END IF;

    -- Verificar si ya existe un contrato con el mismo id_productor e id_subastadora sin fecha de cierre
    IF (SELECT COUNT(*) FROM contratos
        WHERE id_productor = NEW.id_productor
        AND id_subastadora = NEW.id_subastadora
        AND fecha_cierre_cancelacion IS NULL) > 0 THEN
        RAISE EXCEPTION 'No se puede crear un nuevo contrato hasta que se cierre el contrato existente.';
    END IF;

    -- Verificar si ya existe un contrato con el mismo id_productor e id_subastadora con fecha de cierre y sin pago válido
    IF (SELECT COUNT(*) FROM contratos
        WHERE id_productor = NEW.id_productor
        AND id_subastadora = NEW.id_subastadora
        AND fecha_cierre_cancelacion IS NOT NULL
        AND (SELECT COUNT(*) FROM pagos
             WHERE pagos.id_contrato = contratos.id_contrato
             AND pagos.id_productor = contratos.id_productor
             AND pagos.id_subastadora = contratos.id_subastadora
             AND pagos.tipo = 'Membresia'
             AND pagos.monto = 500
             AND pagos.fecha_pago >= contratos.fecha_cierre_cancelacion
             AND pagos.fecha_pago <= CURRENT_DATE) = 0) > 0 THEN
        RAISE EXCEPTION 'No se puede crear un nuevo contrato sin un pago de Membresia válido después de la fecha de cierre anterior.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_contrato_membresia
BEFORE INSERT OR UPDATE ON contratos
FOR EACH ROW
EXECUTE FUNCTION verificar_contrato_membresia();

-- ALTER TABLE contratos DISABLE TRIGGER trg_verificar_contrato_membresia;
-- ALTER TABLE contratos ENABLE TRIGGER trg_verificar_contrato_membresia;





-- Crear la función del trigger para BEFORE INSERT OR UPDATE
CREATE OR REPLACE FUNCTION verificar_clasificacion_before_insert_or_update() RETURNS TRIGGER AS $$
DECLARE
    contratos_vigentes_subastadora INTEGER;
    contratos_vigentes_productor INTEGER;
BEGIN
    -- Contar los contratos vigentes (fecha_cierre_cancelacion IS NULL) para el mismo productor y subastadora
    SELECT COUNT(*) INTO contratos_vigentes_subastadora
    FROM contratos
    WHERE id_productor = NEW.id_productor 
      AND id_subastadora = NEW.id_subastadora
      AND fecha_cierre_cancelacion IS NULL;

    IF contratos_vigentes_subastadora > 1 THEN
        RAISE EXCEPTION 'El productor no puede tener más de un contrato vigente con la misma subastadora.';
    END IF;

    -- Clasificación especial para contratos del 100% de productores fuera de Holanda
    IF NEW.porcentaje_produccion_total = 100 THEN
        PERFORM 1
        FROM productores
        WHERE id_productor = NEW.id_productor
          AND id_pais = (SELECT id_pais FROM paises WHERE nombre = 'Holanda');

        IF FOUND THEN
            NEW.clasificacion := 'KA';
        END IF;
    END IF;

    -- Contar todos los contratos vigentes del productor
    SELECT COUNT(*) INTO contratos_vigentes_productor
    FROM contratos
    WHERE id_productor = NEW.id_productor 
      AND fecha_cierre_cancelacion IS NULL;

    -- Verificar clasificación según el porcentaje de producción
    IF contratos_vigentes_productor = 0 THEN
	
		IF NEW.porcentaje_produccion_total = 100 THEN
        PERFORM 1
        FROM productores
        WHERE id_productor = NEW.id_productor
          AND id_pais != (SELECT id_pais FROM paises WHERE nombre = 'Holanda');

        	IF FOUND THEN
            	NEW.clasificacion := 'KA';
			ELSE
				NEW.clasificacion := 'CA';
        	END IF;
    	END IF;
		
        IF NEW.porcentaje_produccion_total >= 50 AND NEW.porcentaje_produccion_total < 100 THEN
            NEW.clasificacion := 'CA';
        ELSIF NEW.porcentaje_produccion_total >= 20 AND NEW.porcentaje_produccion_total < 50 THEN
            NEW.clasificacion := 'CB';
        ELSIF NEW.porcentaje_produccion_total < 20 THEN
            NEW.clasificacion := 'CC';
        END IF;
    ELSE
        NEW.clasificacion := 'CG';
    END IF;

	IF TG_OP = 'UPDATE' THEN
	SELECT COUNT(*) INTO contratos_vigentes_productor
    FROM contratos
    WHERE id_productor = NEW.id_productor 
      AND fecha_cierre_cancelacion IS NULL;
	  
		IF contratos_vigentes_productor = 1 THEN
			IF NEW.porcentaje_produccion_total = 100 THEN
		        PERFORM 1
		        FROM productores
		        WHERE id_productor = NEW.id_productor
		          AND id_pais != (SELECT id_pais FROM paises WHERE nombre = 'Holanda');
		
		        	IF FOUND THEN
		            	NEW.clasificacion := 'KA';
					ELSE
						NEW.clasificacion := 'CA';
		        	END IF;
		    	END IF;
        	IF NEW.porcentaje_produccion_total >= 50 AND NEW.porcentaje_produccion_total < 100 THEN
            	NEW.clasificacion := 'CA';
        	ELSIF NEW.porcentaje_produccion_total >= 20 AND NEW.porcentaje_produccion_total < 50 THEN
            	NEW.clasificacion := 'CB';
        	ELSIF NEW.porcentaje_produccion_total < 20 THEN
            	NEW.clasificacion := 'CC';
        	END IF;
		END IF;
	END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_clasificacion_before_insert_or_update
BEFORE INSERT OR UPDATE ON contratos
FOR EACH ROW EXECUTE FUNCTION verificar_clasificacion_before_insert_or_update();

-- ALTER TABLE contratos DISABLE TRIGGER trg_verificar_clasificacion_before_insert_or_update;
-- ALTER TABLE contratos ENABLE TRIGGER trg_verificar_clasificacion_before_insert_or_update;





CREATE OR REPLACE FUNCTION actualizar_clasificaciones_after_insert_or_update() RETURNS TRIGGER AS $$
DECLARE
    contratos_vigentes_productor INTEGER;
BEGIN
    -- Contar todos los contratos vigentes del productor
    SELECT COUNT(*) INTO contratos_vigentes_productor
    FROM contratos
    WHERE id_productor = NEW.id_productor 
      AND fecha_cierre_cancelacion IS NULL;

    -- Actualizar la clasificación de todos los contratos vigentes del productor a 'CG' si tiene más de uno
    IF contratos_vigentes_productor > 1 THEN
        UPDATE contratos
        SET clasificacion = 'CG'
        WHERE id_productor = NEW.id_productor 
          AND fecha_cierre_cancelacion IS NULL
          AND clasificacion != 'CG';
    END IF;

	IF TG_OP = 'UPDATE' THEN
	IF contratos_vigentes_productor = 1 THEN
			IF NEW.porcentaje_produccion_total = 100 THEN
				        PERFORM 1
				        FROM productores
				        WHERE id_productor = NEW.id_productor
				          AND id_pais != (SELECT id_pais FROM paises WHERE nombre = 'Holanda');
				
				        	IF FOUND THEN
				            	UPDATE contratos
				        		SET clasificacion = 'KA'
				        		WHERE id_productor = NEW.id_productor 
				          		AND fecha_cierre_cancelacion IS NULL
				          		AND clasificacion != 'KA';
							ELSE
								UPDATE contratos
				        		SET clasificacion = 'CA'
				        		WHERE id_productor = NEW.id_productor 
				          		AND fecha_cierre_cancelacion IS NULL
				          		AND clasificacion != 'CA';
				        	END IF;
			END IF;
			IF NEW.porcentaje_produccion_total >= 50 AND NEW.porcentaje_produccion_total < 100 THEN
            	UPDATE contratos
        		SET clasificacion = 'CA'
        		WHERE id_productor = NEW.id_productor 
          		AND fecha_cierre_cancelacion IS NULL
          		AND clasificacion != 'CA';
        	ELSIF NEW.porcentaje_produccion_total >= 20 AND NEW.porcentaje_produccion_total < 50 THEN
            	UPDATE contratos
        		SET clasificacion = 'CB'
        		WHERE id_productor = NEW.id_productor 
          		AND fecha_cierre_cancelacion IS NULL
          		AND clasificacion != 'CB';
        	ELSIF NEW.porcentaje_produccion_total < 20 THEN
            	UPDATE contratos
        		SET clasificacion = 'CC'
        		WHERE id_productor = NEW.id_productor 
          		AND fecha_cierre_cancelacion IS NULL
          		AND clasificacion != 'CC';
        	END IF;
		END IF;
	END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para AFTER INSERT OR UPDATE
CREATE TRIGGER trg_actualizar_clasificaciones_after_insert_or_update
AFTER INSERT OR UPDATE ON contratos
FOR EACH ROW EXECUTE FUNCTION actualizar_clasificaciones_after_insert_or_update();

-- ALTER TABLE contratos DISABLE TRIGGER trg_actualizar_clasificaciones_after_insert_or_update;
-- ALTER TABLE contratos ENABLE TRIGGER trg_actualizar_clasificaciones_after_insert_or_update;



CREATE OR REPLACE FUNCTION enlace_renovar_contrato()
RETURNS TRIGGER AS $$
DECLARE
    c_contrato RECORD;
BEGIN
    SELECT *
    INTO c_contrato
    FROM contratos
    WHERE id_productor = NEW.id_productor
    AND id_subastadora = NEW.id_subastadora
    AND id_contrato_renovado IS NULL
    AND fecha_cierre_cancelacion IS NOT NULL;

    IF FOUND THEN
        -- Actualizar el contrato existente para enlazarlo con el nuevo contrato
        UPDATE contratos
        SET id_contrato_renovado = NEW.id_contrato,
            id_productor_renovado = NEW.id_productor,
            id_subastadora_renovado = NEW.id_subastadora
        WHERE id_contrato = c_contrato.id_contrato;

    END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER TRG_enlace_renovar_contrato
AFTER INSERT ON contratos
FOR EACH ROW
EXECUTE FUNCTION enlace_renovar_contrato();

-- ALTER TABLE contratos DISABLE TRIGGER TRG_enlace_renovar_contrato;
-- ALTER TABLE contratos ENABLE TRIGGER TRG_enlace_renovar_contrato;





CREATE OR REPLACE FUNCTION verificar_pago_comision()
RETURNS TRIGGER AS $$
DECLARE
	fecha_rango1 DATE;
	fecha_rango2 DATE;
	r_contrato RECORD;
	comision numeric(9,2);
	multa TEXT[];
BEGIN
		SELECT *
    INTO r_contrato
    FROM contratos
    WHERE id_contrato = NEW.id_contrato
    AND fecha_cierre_cancelacion IS NULL;

	-- Verificar si se encontró el contrato
	IF NOT FOUND THEN
		RAISE NOTICE 'No se encontró un contrato vigente con el id_contrato %', NEW.id_contrato;
	ELSE
	
	    IF NEW.tipo = 'Comision' THEN
	        IF EXTRACT(DAY FROM NEW.fecha_pago) < 1 OR EXTRACT(DAY FROM NEW.fecha_pago) > 5 THEN
	            RAISE EXCEPTION 'Los pagos de tipo "Comision" solo pueden registrarse entre el 01 y el 05 del mes';
			ELSE
	
				fecha_rango2 := (DATE_TRUNC('month', NEW.fecha_pago))::DATE;
				fecha_rango1 := fecha_rango2 - INTERVAL '1 month';
				IF (fecha_rango2::DATE < r_contrato.fecha_firma) then
					RAISE EXCEPTION 'No tiene comisiones pendientes';
				ELSE




					multa = verificar_multa(r_contrato.id_contrato, fecha_rango1, multa);
					if (multa[1] = 'No pagada') then
					
						comision := calcular_comision(fecha_rango1,fecha_rango2,r_contrato.id_contrato);
						if (NEW.monto = comision) then
							RETURN NEW;
						else
							RAISE EXCEPTION 'El monto ingresado no coincide con el monto necesario para la comision. El productor debe pagar €%',comision;
						end if;
					else
						RAISE EXCEPTION 'No hay comisiones pendientes para este mes';
					end if;
				end if;
				
	        END IF;
	    END IF;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER TRG_verificar_pago_comision
BEFORE INSERT ON pagos
FOR EACH ROW
EXECUTE FUNCTION verificar_pago_comision();

-- ALTER TABLE pagos DISABLE TRIGGER TRG_verificar_pago_comision;
-- ALTER TABLE pagos ENABLE TRIGGER TRG_verificar_pago_comision;




CREATE OR REPLACE FUNCTION verificar_pago_multa()
RETURNS TRIGGER AS $$
DECLARE

	r_contrato RECORD;
	r_productor RECORD;
	fecha_rango1 DATE;
	pendiente boolean := false;
	montomulta NUMERIC(9,2)[];
	multa TEXT[];
	haymulta boolean := false;
	ultima_comision_fuepagada boolean;
	i numeric(2) :=1;
	coincide BOOLEAN := false;
BEGIN


    IF NEW.tipo = 'Multa' THEN


	-- Buscar elcontrato especifico
	SELECT *
    INTO r_contrato
    FROM contratos
    WHERE id_contrato = NEW.id_contrato
    AND fecha_cierre_cancelacion IS NULL;

	SELECT *
    INTO r_productor
    FROM productores
    WHERE id_productor = r_contrato.id_productor;

	-- Empezar con la fecha_firma del contrato
	fecha_rango1 := (DATE_TRUNC('month', r_contrato.fecha_firma))::DATE;
		LOOP
			if ((fecha_rango1 + INTERVAL '1 month')::DATE > CURRENT_DATE) THEN
				EXIT;
				
			elsif ((fecha_rango1 + INTERVAL '1 month')::DATE <= CURRENT_DATE) AND ((fecha_rango1 + INTERVAL '1 month' + INTERVAL '5 days')::DATE > CURRENT_DATE) THEN
				EXIT;

			elsif (((fecha_rango1 + INTERVAL '1 month' + INTERVAL '5 days'))::DATE <= CURRENT_DATE) THEN
				multa = verificar_multa(r_contrato.id_contrato, fecha_rango1, multa);
				if (multa[1] = 'No pagada') then
				haymulta := true;
					if (((fecha_rango1 + INTERVAL '2 months')::DATE)> CURRENT_DATE) THEN
						ultima_comision_fuepagada := false;
						EXIT;
						
					elsif (((fecha_rango1 + INTERVAL '2 months')::DATE)<= CURRENT_DATE) THEN
						montomulta[i] := calcular_multa((fecha_rango1 + INTERVAL '1 month')::DATE,(fecha_rango1 + INTERVAL '2 months')::DATE,r_contrato.id_contrato);
						i:= i+1;
					end if;

				elsif (multa[1] = 'Comision pagada') THEN
					if (((fecha_rango1 + INTERVAL '2 months')::DATE)> CURRENT_DATE) THEN
						ultima_comision_fuepagada := true;
						EXIT;
					end if;
				end if;
				
				fecha_rango1 := (fecha_rango1 + INTERVAL '1 month')::DATE;
			end if;
		END LOOP;

		if (haymulta) THEN

			FOR b IN 1..array_length(montomulta, 1) LOOP
				IF NEW.monto = montomulta[b] THEN
					coincide := TRUE;
					EXIT;
				END IF;
			END LOOP;
			
			IF NOT coincide THEN
				RAISE EXCEPTION 'El monto ingresado no coincide con ninguna multa pendiente.';
			ELSE
				RETURN NEW;
			END IF;

		else
			RAISE EXCEPTION 'El productor % está solvente',r_productor.nombre;
			
		end if;




	

    END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRG_verificar_pago_multa
BEFORE INSERT ON pagos
FOR EACH ROW
EXECUTE FUNCTION verificar_pago_multa();

-- ALTER TABLE pagos DISABLE TRIGGER TRG_verificar_pago_multa;
-- ALTER TABLE pagos ENABLE TRIGGER TRG_verificar_pago_multa;





CREATE OR REPLACE FUNCTION verificar_pago_membresia()
RETURNS TRIGGER AS $$
BEGIN

    IF NEW.tipo = 'Membresia' THEN
        IF (NEW.monto = 500) then
			RETURN NEW;
		ELSE
			RAISE EXCEPTION 'Los pagos de membresía son de €500';
		END IF;
    END IF;

	
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRG_verificar_pago_membresia
BEFORE INSERT ON pagos
FOR EACH ROW
EXECUTE FUNCTION verificar_pago_membresia();

-- ALTER TABLE pagos DISABLE TRIGGER TRG_verificar_pago_membresia;
-- ALTER TABLE pagos ENABLE TRIGGER TRG_verificar_pago_membresia;




CREATE OR REPLACE FUNCTION verificar_fecha_firma_contrato()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.fecha_firma IS DISTINCT FROM CURRENT_DATE THEN
        RAISE EXCEPTION 'La fecha de la firma debe ser la fecha actual';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRG_verificar_fecha_firma_contrato
BEFORE INSERT ON contratos
FOR EACH ROW
EXECUTE FUNCTION verificar_fecha_firma_contrato();

-- ALTER TABLE contratos DISABLE TRIGGER TRG_verificar_fecha_firma_contrato;
-- ALTER TABLE contratos ENABLE TRIGGER TRG_verificar_fecha_firma_contrato;




CREATE OR REPLACE FUNCTION verificar_fecha_cierre()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar si fecha_cierre_cancelacion está siendo actualizada
    IF NEW.fecha_cierre_cancelacion IS DISTINCT FROM OLD.fecha_cierre_cancelacion THEN
        -- Comprobar que la nueva fecha_cierre_cancelacion sea la fecha actual
        IF NEW.fecha_cierre_cancelacion <> CURRENT_DATE THEN
            RAISE EXCEPTION 'La fecha_cierre_cancelacion debe ser la fecha actual.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRG_verificar_fecha_cierre
BEFORE UPDATE ON contratos
FOR EACH ROW
EXECUTE FUNCTION verificar_fecha_cierre();

-- ALTER TABLE contratos DISABLE TRIGGER TRG_verificar_fecha_cierre;
-- ALTER TABLE contratos ENABLE TRIGGER TRG_verificar_fecha_cierre;




CREATE OR REPLACE FUNCTION verificar_fecha_pago()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.fecha_pago IS DISTINCT FROM CURRENT_DATE THEN
        RAISE EXCEPTION 'La fecha del pago debe ser la fecha actual';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRG_verificar_fecha_pago
BEFORE INSERT ON pagos
FOR EACH ROW
EXECUTE FUNCTION verificar_fecha_pago();

-- ALTER TABLE pagos DISABLE TRIGGER TRG_verificar_fecha_pago;
-- ALTER TABLE pagos ENABLE TRIGGER TRG_verificar_fecha_pago;




CREATE OR REPLACE FUNCTION validar_precio_final_lote()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.precio_final < NEW.precio_inicial THEN
        RAISE EXCEPTION 'El precio final del lote no puede ser menor que el precio inicial.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_precio_final_lote
BEFORE INSERT OR UPDATE ON lotes
FOR EACH ROW
EXECUTE FUNCTION validar_precio_final_lote();

-- ALTER TABLE lotes DISABLE TRIGGER trigger_validar_precio_final_lote;
-- ALTER TABLE lotes ENABLE TRIGGER trigger_validar_precio_final_lote;



CREATE OR REPLACE FUNCTION validar_fecha_hora()
RETURNS TRIGGER AS $$
BEGIN
	if extract(DOW from new.fecha_emision) in (0,6) then
		RAISE EXCEPTION 'Las subastas no ocurren ni sabado ni domingo';
	end if;
	
	if extract(hour from new.fecha_emision) < 8 or extract(hour from new.fecha_emision)>15 then
		RAISE EXCEPTION 'Las subastas no ocurren antes de las 8am ni despues de 3pm';
	end if;
	
	return new;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER validar_fecha_hora_trigger
BEFORE INSERT OR UPDATE ON facturas_compras
FOR EACH ROW
EXECUTE FUNCTION validar_fecha_hora();

-- ALTER TABLE facturas_compras DISABLE TRIGGER validar_fecha_hora_trigger;
-- ALTER TABLE facturas_compras ENABLE TRIGGER validar_fecha_hora_trigger;




CREATE OR REPLACE FUNCTION fechas_contratos()
RETURNS TRIGGER AS $$
BEGIN 
	if new.fecha_cierre_cancelacion <= new.fecha_firma then
		RAISE EXCEPTION 'La fecha cierre no puede ser menor o igual a la fecha de la firma';
	end if;	
	return new;
end;

$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER fechas_contratos_trigger
BEFORE INSERT OR UPDATE ON contratos
FOR EACH ROW
EXECUTE FUNCTION fechas_contratos();

-- ALTER TABLE contratos DISABLE TRIGGER fechas_contratos_trigger;
-- ALTER TABLE contratos ENABLE TRIGGER fechas_contratos_trigger;




CREATE OR REPLACE FUNCTION validar_afiliacion_en_compra()
RETURNS TRIGGER AS $$
DECLARE
	r_factura RECORD;
BEGIN 
	
	SELECT *
	INTO r_factura
	FROM facturas_compras
	WHERE id_factura = NEW.id_factura_compra;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró una factura con id = %',NEW.id_factura_compra; 
	END IF;

	IF (r_factura.id_subastadora != NEW.id_subastadora) THEN
		RAISE EXCEPTION 'La factura de ID % no pertenece a la compra del lote de la subastadora. El lote pertenece a la subastadora de ID % y la factura fue emitida por la subastadora de ID %. Error de asociación con FKs', NEW.id_factura_compra,NEW.id_subastadora,r_factura.id_subastadora;
	END IF;
	
	
	RETURN NEW;
end;

$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER TRG_validar_afiliacion_en_compra
BEFORE INSERT ON lotes
FOR EACH ROW
EXECUTE FUNCTION validar_afiliacion_en_compra();

-- ALTER TABLE lotes DISABLE TRIGGER TRG_validar_afiliacion_en_compra;
-- ALTER TABLE lotes ENABLE TRIGGER TRG_validar_afiliacion_en_compra;




CREATE OR REPLACE FUNCTION validar_lote_contrato_vigente()
RETURNS TRIGGER AS $$
DECLARE
	r_contrato RECORD;
BEGIN 
	
	SELECT *
	INTO r_contrato
	FROM contratos
	WHERE id_contrato = NEW.id_contrato
	AND fecha_cierre_cancelacion IS NULL;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'No se encontró un contrato vigente con id = %',NEW.id_contrato; 
	END IF;
	
	
	RETURN NEW;
end;

$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER TRG_validar_lote_contrato_vigente
BEFORE INSERT ON lotes
FOR EACH ROW
EXECUTE FUNCTION validar_lote_contrato_vigente();

-- ALTER TABLE lotes DISABLE TRIGGER TRG_validar_lote_contrato_vigente;
-- ALTER TABLE lotes ENABLE TRIGGER TRG_validar_lote_contrato_vigente;




CREATE OR REPLACE FUNCTION validar_factura_lote()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM lotes
        WHERE id_factura_compra = NEW.id_factura_compra
    ) THEN
        RAISE EXCEPTION 'La factura ya está asociada a un lote existente. No se puede asociar nuevamente.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_lote_existente
BEFORE INSERT ON lotes
FOR EACH ROW
EXECUTE FUNCTION validar_factura_lote();

-- ALTER TABLE lotes DISABLE TRIGGER trigger_validar_lote_existente;
-- ALTER TABLE lotes ENABLE TRIGGER trigger_validar_lote_existente;



CREATE OR REPLACE FUNCTION validar_precio_lote()
RETURNS TRIGGER AS $$
DECLARE
	r_factura RECORD;
	suma_monto NUMERIC(9,2);
	calc_envio NUMERIC(9,2);
BEGIN

    SELECT *
	INTO r_factura
	FROM facturas_compras
	WHERE id_factura = NEW.id_factura_compra;

	suma_monto := NEW.precio_final;

	if r_factura.envio IS NOT NULL then
	
		calc_envio := NEW.precio_final * 0.1;
	
		if (calc_envio != r_factura.envio) then
			RAISE EXCEPTION 'El monto del envio de la factura con ID % no es el 10 por ciento del precio del lote',r_factura.id_factura;
		end if;
		
		suma_monto := NEW.precio_final + calc_envio;
	end if;
	
		if (suma_monto != r_factura.monto_total) then
			RAISE EXCEPTION 'El monto total de la factura con ID % no está acorde al precio del lote',r_factura.id_factura;
		end if;


    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRG_validar_precio_lote
BEFORE INSERT ON lotes
FOR EACH ROW
EXECUTE FUNCTION validar_precio_lote();

-- ALTER TABLE lotes DISABLE TRIGGER TRG_validar_precio_lote;
-- ALTER TABLE lotes ENABLE TRIGGER TRG_validar_precio_lote;