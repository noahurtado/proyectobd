CREATE OR REPLACE FUNCTION verificar_estado_contrato(id_contrato_param NUMERIC) RETURNS TEXT AS $$
DECLARE
	r_contrato RECORD;
	r_productor RECORD;
	fecha_rango1 DATE;
	pendiente boolean := false;
	mensaje TEXT :='';
	fechamulta TEXT[];
	montomulta NUMERIC(9,2)[];
	multa TEXT[];
	haymulta boolean := false;
	suma_multas NUMERIC(2);
	ultima_comision_fuepagada boolean;
	i numeric(2) :=1;
	montocomision NUMERIC(9,2);
BEGIN

	-- Buscar elcontrato especifico
	SELECT *
    INTO r_contrato
    FROM contratos
    WHERE id_contrato = id_contrato_param
    AND fecha_cierre_cancelacion IS NULL;

	-- Buscar productor específico
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
				pendiente:= true;
				EXIT;

			elsif (((fecha_rango1 + INTERVAL '1 month' + INTERVAL '5 days'))::DATE <= CURRENT_DATE) THEN
				multa = verificar_multa(r_contrato.id_contrato, fecha_rango1, multa);
				if (multa[1] = 'No pagada') then
				haymulta := true;
					if (((fecha_rango1 + INTERVAL '2 months')::DATE)> CURRENT_DATE) THEN
						fechamulta[i] := TO_CHAR(fecha_rango1, 'MM-YYYY');
						ultima_comision_fuepagada := false;
						EXIT;
						
					elsif (((fecha_rango1 + INTERVAL '2 months')::DATE)<= CURRENT_DATE) THEN
						fechamulta[i] := TO_CHAR(fecha_rango1 + INTERVAL '1 month', 'MM-YYYY');
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
			if (pendiente) then
				suma_multas := array_length(fechamulta, 1);
				montocomision := calcular_comision((fecha_rango1)::DATE, (fecha_rango1 + INTERVAL '1 month')::DATE, r_contrato.id_contrato);
				if (ROUND(montocomision, 2) > 0.00) then
					mensaje:= 'el productor ' || (r_productor.nombre)::TEXT || ' vendió el mes pasado un total de €' || (calcular_venta_mensual(r_contrato.id_contrato, (fecha_rango1)::DATE, (fecha_rango1 + INTERVAL '1 month')::DATE))::TEXT || ', que le corresponde un pago de comision de €' || (calcular_comision((fecha_rango1)::DATE, (fecha_rango1 + INTERVAL '1 month')::DATE, r_contrato.id_contrato))::TEXT || ', el cual tiene hasta el 5 de este mes para pagar. Además, arrastra ' || (suma_multas)::TEXT || ' pagos de multa correspondientes al ';
				else
					mensaje:= 'el productor ' || (r_productor.nombre)::TEXT || ' no está solvente porque arrastra ' || (suma_multas)::TEXT || ' pagos de multa correspondientes al ';
				end if;
				FOR b IN 1..suma_multas LOOP
					mensaje := mensaje || fechamulta[b] ||' (€' || (montomulta[b])::TEXT || ')';
					if (b < suma_multas) then
						mensaje := mensaje || ', ';
					end if;
				end loop;
			end if;
			
			if (ultima_comision_fuepagada) then
				suma_multas := array_length(fechamulta, 1);
				mensaje := 'El productor ' || (r_productor.nombre)::TEXT || ' no está solvente porque está arrastrando ' || (suma_multas)::TEXT || ' pagos de multa correspondientes al ';
				FOR b IN 1..suma_multas LOOP
					mensaje := mensaje || fechamulta[b] ||' (€' || (montomulta[b])::TEXT || ')';
					if (b < suma_multas) then
						mensaje := mensaje || ', ';
					end if;
				end loop;
			else
				suma_multas := array_length(fechamulta, 1)-1;
				montocomision := calcular_comision((fecha_rango1)::DATE, (fecha_rango1 + INTERVAL '1 month')::DATE, r_contrato.id_contrato);
				if (ROUND(montocomision, 2) > 0.00) then
					mensaje := 'El productor ' || (r_productor.nombre)::TEXT || ' no está solvente porque no pagó la comisión de €' || (calcular_comision((fecha_rango1)::DATE, (fecha_rango1 + INTERVAL '1 month')::DATE, r_contrato.id_contrato))::TEXT || ' correspondiente a las ventas de este mes con un total de €' || (calcular_venta_mensual(r_contrato.id_contrato, (fecha_rango1)::DATE, (fecha_rango1 + INTERVAL '1 month')::DATE))::TEXT || '.';
				end if;
				if (suma_multas >= 1) then
					if (ROUND(montocomision, 2) > 0.00) then
						mensaje := mensaje || ' Además, arrastra ' || (suma_multas)::TEXT || ' pagos de multa correspondientes al ';
					else
						mensaje := 'El productor no está solvente porque arrastra ' || (suma_multas)::TEXT || ' pagos de multa correspondientes al ';
					end if;
				FOR b IN 1..suma_multas LOOP
					mensaje := mensaje || fechamulta[b] ||' (€' || (montomulta[b])::TEXT || ')';
					if (b < suma_multas) then
						mensaje := mensaje || ', ';
					end if;
				end loop;
				end if;
			end if;
			
		else
			if (pendiente) THEN
				montocomision := calcular_comision((fecha_rango1)::DATE, (fecha_rango1 + INTERVAL '1 month')::DATE, r_contrato.id_contrato);
				if (ROUND(montocomision, 2) > 0.00) then
					mensaje:= 'el productor ' || (r_productor.nombre)::TEXT || ' vendió el mes pasado un total de €' || (calcular_venta_mensual(r_contrato.id_contrato, (fecha_rango1)::DATE, (fecha_rango1 + INTERVAL '1 month')::DATE))::TEXT || ', que le corresponde un pago de comision de €' || (calcular_comision((fecha_rango1)::DATE, (fecha_rango1 + INTERVAL '1 month')::DATE, r_contrato.id_contrato))::TEXT || ', el cual tiene hasta el 5 de este mes para pagar.';
				else
					mensaje:= 'el productor ' || (r_productor.nombre)::TEXT || ' Está solvente.';
				end if;
			else
				montocomision := calcular_comision((fecha_rango1)::DATE, (fecha_rango1 + INTERVAL '1 month')::DATE, r_contrato.id_contrato);
				if (ROUND(montocomision, 2) > 0.00) then
					mensaje:= 'el productor ' || (r_productor.nombre)::TEXT || ' vendió el mes pasado un total de €' || (calcular_venta_mensual(r_contrato.id_contrato, (fecha_rango1)::DATE, (fecha_rango1 + INTERVAL '1 month')::DATE))::TEXT || ', que le corresponde un pago de comision de €' || (calcular_comision((fecha_rango1)::DATE, (fecha_rango1 + INTERVAL '1 month')::DATE, r_contrato.id_contrato))::TEXT || ' cuyo pago fue realizado el ' || (encontrar_pago(r_contrato.id_contrato, (fecha_rango1)::DATE))::TEXT;
				else
					mensaje:= 'el productor ' || (r_productor.nombre)::TEXT || ' Está solvente.';
				end if;
			end if;
			
			
		end if;

	mensaje := CHR(10) || CHR(10) || CHR(10) || CHR(10) || mensaje || CHR(10) || CHR(10) || 'El contrato expira en ' || (EXTRACT(YEAR FROM AGE(r_contrato.fecha_firma + INTERVAL '1 year', CURRENT_DATE)) * 12 + EXTRACT(MONTH FROM AGE(r_contrato.fecha_firma + INTERVAL '1 year', CURRENT_DATE)))::TEXT || ' meses y ' || EXTRACT(DAY FROM AGE(r_contrato.fecha_firma + INTERVAL '1 year', CURRENT_DATE))::TEXT || ' días.';

	RAISE NOTICE '%',mensaje;

	RETURN mensaje;
END;
$$ LANGUAGE plpgsql;
-- DROP FUNCTION verificar_estado_contrato(id_contrato_param NUMERIC);



CREATE OR REPLACE FUNCTION verificar_multa(id_contrato_param NUMERIC, fecha_rango1 DATE, multa TEXT[]) RETURNS TEXT[] AS $$

DECLARE
	r_contrato RECORD;
	r_pago RECORD;
	fecha_rango2 DATE;
	fecha_5_dias DATE;
	comision NUMERIC(9,2);
	monto_multa NUMERIC(9,2);
	i int;
	pago_encontrado BOOLEAN := FALSE; 
BEGIN

	
	-- Buscar elcontrato especifico
	SELECT *
    INTO r_contrato
    FROM contratos
    WHERE id_contrato = id_contrato_param
    AND fecha_cierre_cancelacion IS NULL;

	IF (fecha_rango1)::DATE < r_contrato.fecha_firma THEN
		RAISE NOTICE 'La fecha % es menor a la fecha en la cual se firmó el contrato: %', TO_CHAR(fecha_rango1, 'DD-MM-YYYY'), TO_CHAR(r_contrato.fecha_firma, 'DD-MM-YYYY');
	END IF;

	-- Calcular las fechas
	fecha_rango2 := (fecha_rango1 + INTERVAL '1 month')::DATE;
	fecha_5_dias := (fecha_rango2 + INTERVAL '5 days')::DATE;

		-- Calcula la comision de esa fecha
		comision := calcular_comision(fecha_rango1,fecha_rango2,r_contrato.id_contrato);


		RAISE NOTICE 'Verificando pagos para el contrato % en el rango de fechas % a %, comisión: €%', r_contrato.id_contrato, TO_CHAR(fecha_rango2, 'DD-MM-YYYY'), TO_CHAR(fecha_5_dias, 'DD-MM-YYYY'), comision;

		IF (ROUND(comision, 2)>0.00) then
		-- Verifica si ya fue pagada en el lapso de 5 días
		SELECT * INTO r_pago
            FROM pagos
            WHERE id_contrato = r_contrato.id_contrato
            AND id_productor = r_contrato.id_productor
            AND id_subastadora = r_contrato.id_subastadora
            AND monto = comision
            AND tipo = 'Comision'
            AND fecha_pago BETWEEN fecha_rango2 AND fecha_5_dias;

			IF (ROUND(comision, 2) = 0.00) then
				multa[1] := 'Comision pagada';
			end if;

			IF NOT FOUND THEN
			RAISE NOTICE 'No se encontró pago para la comisión: €%', comision;
				
					multa[1] := 'No pagada';
				
			ELSE
			RAISE NOTICE 'Pago encontrado para la comisión: €%', comision;
				multa[1] := 'Comision pagada';
				pago_encontrado := true;
			END IF;

			IF (multa[1] = 'No pagada') THEN
					        IF (((fecha_rango1 + INTERVAL '2 months')::DATE) <= CURRENT_DATE) THEN
					            monto_multa := calcular_multa((fecha_rango1 + INTERVAL '1 month')::DATE, (fecha_rango1 + INTERVAL '2 months')::DATE, r_contrato.id_contrato);
					
								IF (ROUND(monto_multa, 2) > 0.00) then
					            -- Buscar pagos de multas
					            FOR r_pago IN 
					                SELECT * FROM pagos
					                WHERE id_contrato = r_contrato.id_contrato
					                AND id_productor = r_contrato.id_productor
					                AND id_subastadora = r_contrato.id_subastadora
					                AND monto = monto_multa
					                AND tipo = 'Multa'
					            LOOP
					                -- Verificar si el id_pago ya está en el array multa
					                IF NOT (r_pago.id_pago::TEXT = ANY(multa)) THEN
					                    -- Si no está presente, agregar el id_pago al array y establecer la bandera
					                    multa := array_append(multa, (r_pago.id_pago)::TEXT);
					                    multa[1] := 'Multa pagada';  -- Actualizar estado
										pago_encontrado := TRUE;
					                    RAISE NOTICE 'Pago de multa encontrado: %', r_pago.id_pago;
					                    RETURN multa;  -- Retornar inmediatamente al encontrar un pago válido
					                END IF;
					            END LOOP;
								else
									multa[1] := 'Comision pagada';
									pago_encontrado := TRUE;
								end if;
					
										-- Si no se encontró ningún pago válido
						    IF NOT pago_encontrado THEN
						        multa[1] := 'No pagada';  -- Si la fecha ya existe
						    END IF;
							
					        END IF;


    	END IF;

	else 
		multa[1] := 'Comision pagada';
		pago_encontrado := TRUE;
	end if;

    

    RETURN multa;
END;
$$ LANGUAGE plpgsql;

-- DROP FUNCTION verificar_multa(id_contrato_param NUMERIC, fecha_rango1 DATE, multa TEXT[]);







CREATE OR REPLACE FUNCTION encontrar_pago(id_contrato_param NUMERIC, fecha_rango1 DATE) RETURNS DATE AS $$
DECLARE
	r_contrato RECORD;
	r_pago RECORD;
	fecha_rango2 DATE;
	fecha_5_dias DATE;
	comision NUMERIC(9,2);
	pago DATE;
BEGIN
	-- Buscar elcontrato especifico
	SELECT *
    INTO r_contrato
    FROM contratos
    WHERE id_contrato = id_contrato_param
    AND fecha_cierre_cancelacion IS NULL;

	-- Calcular las fechas
	fecha_rango2 := (fecha_rango1 + INTERVAL '1 month')::DATE;
	fecha_5_dias := (fecha_rango2 + INTERVAL '5 days')::DATE;

		-- Calcula la comision de esa fecha
		comision := calcular_comision(fecha_rango1,fecha_rango2,r_contrato.id_contrato);

		-- Verifica si ya fue pagada en el lapso de 5 días
		SELECT * INTO r_pago
            FROM pagos
            WHERE id_contrato = r_contrato.id_contrato
            AND id_productor = r_contrato.id_productor
            AND id_subastadora = r_contrato.id_subastadora
            AND monto = comision
            AND tipo = 'Comision'
            AND fecha_pago BETWEEN fecha_rango2 AND fecha_5_dias;

			IF NOT FOUND THEN
			RAISE NOTICE 'No se encontró pago para la comisión: €%', comision;
			ELSE
			RAISE NOTICE 'Pago encontrado para la comisión: €%', comision;
				pago := r_pago.fecha_pago;
			END IF;

			RETURN pago;
END;
$$ LANGUAGE plpgsql;
-- DROP FUNCTION encontrar_pago(id_contrato_param NUMERIC, fecha_rango1 DATE);





CREATE OR REPLACE FUNCTION calcular_comision(fecha_rango1 DATE,fecha_rango2 DATE,id_contrato_param NUMERIC) RETURNS NUMERIC AS $$
DECLARE
	r_contrato RECORD;
	comision NUMERIC(9,2);
	venta_mensual NUMERIC(9,2);
BEGIN
	-- Buscar elcontrato especifico
	SELECT *
    INTO r_contrato
    FROM contratos
    WHERE id_contrato = id_contrato_param
    AND fecha_cierre_cancelacion IS NULL;

	-- Verificar si se encontró el contrato
	IF NOT FOUND THEN
		RAISE NOTICE 'No se encontró un contrato vigente con el id_contrato %', id_contrato_param;
		RETURN 0;
	END IF;


	venta_mensual := calcular_venta_mensual(r_contrato.id_contrato, fecha_rango1, fecha_rango2);


	RAISE NOTICE 'Suma de montos totales en facturas: €%', venta_mensual;
				
    CASE r_contrato.clasificacion
        WHEN 'CA' THEN comision := venta_mensual * 0.005;
        WHEN 'CB' THEN comision := venta_mensual * 0.01;
        WHEN 'CC' THEN comision := venta_mensual * 0.02;
        WHEN 'CG' THEN comision := venta_mensual * 0.05;
        WHEN 'KA' THEN comision := venta_mensual * 0.0025;
    END CASE;

	RETURN comision;
	
END;
$$ LANGUAGE plpgsql;

-- DROP FUNCTION calcular_comision(fecha_rango1 DATE,fecha_rango2 DATE,id_contrato_param NUMERIC);





CREATE OR REPLACE FUNCTION calcular_venta_mensual(id_contrato_param NUMERIC, fecha_rango1 DATE, fecha_rango2 DATE) RETURNS NUMERIC AS $$
DECLARE
	r_contrato RECORD;
	venta_mensual NUMERIC(9,2);
BEGIN
	-- Buscar elcontrato especifico
	SELECT *
    INTO r_contrato
    FROM contratos
    WHERE id_contrato = id_contrato_param
    AND fecha_cierre_cancelacion IS NULL;

	-- Verificar si se encontró el contrato
	IF NOT FOUND THEN
		RAISE NOTICE 'No se encontró un contrato vigente con el id_contrato %', id_contrato_param;
		RETURN 0;
	END IF;


	--Calcular las ganancias totales
	SELECT COALESCE(SUM(f.monto_total), 0) INTO venta_mensual
	FROM facturas_compras f
	WHERE f.id_factura IN (
	    SELECT l.id_factura_compra
	    FROM lotes l
	    WHERE l.id_contrato = r_contrato.id_contrato
	    AND l.id_subastadora = r_contrato.id_subastadora
	    AND l.id_productor = r_contrato.id_productor
	)
	AND f.fecha_emision::DATE BETWEEN fecha_rango1 AND fecha_rango2 - INTERVAL '1 day';


	RETURN venta_mensual;

END;
$$ LANGUAGE plpgsql;
--DROP FUNCTION calcular_venta_mensual(id_contrato_param NUMERIC, fecha_rango1 DATE, fecha_rango2 DATE);




-- Función de calcular el monto de la multa
CREATE OR REPLACE FUNCTION calcular_multa(fecha_rango1 DATE,fecha_rango2 DATE,id_contrato_param NUMERIC) RETURNS NUMERIC AS $$
DECLARE
	r_contrato RECORD;
	multa numeric(9,2);
BEGIN

	-- Buscar elcontrato especifico
	SELECT *
    INTO r_contrato
    FROM contratos
    WHERE id_contrato = id_contrato_param
    AND fecha_cierre_cancelacion IS NULL;

	SELECT COALESCE(SUM(f.monto_total), 0) INTO multa
	FROM facturas_compras f
	WHERE f.id_factura IN (
	    SELECT l.id_factura_compra
	    FROM lotes l
	    WHERE l.id_contrato = r_contrato.id_contrato
	    AND l.id_subastadora = r_contrato.id_subastadora
	    AND l.id_productor = r_contrato.id_productor
	)
	AND f.fecha_emision::DATE BETWEEN fecha_rango1 AND fecha_rango2;


	multa := multa * 0.2;

	RETURN multa;

END;
$$ LANGUAGE plpgsql;
-- DROP FUNCTION calcular_multa(fecha_rango1 DATE,fecha_rango2 DATE,id_contrato_param NUMERIC);



CREATE OR REPLACE FUNCTION calcular_promedio(p_id_floristeria NUMERIC, p_cod_vbn NUMERIC)
RETURNS INTEGER AS $$
DECLARE
    suma_promedios NUMERIC := 0;
    count_promedios INTEGER := 0;
    promedio_final NUMERIC;
BEGIN
    -- Sumar los promedios de los detalles de facturas ventas asociados a un catálogo
    SELECT COALESCE(SUM(promedio), 0), COUNT(promedio) INTO suma_promedios, count_promedios
    FROM detalles_facturas_ventas
    WHERE id_floristeria_cat = p_id_floristeria AND cod_vbn_cat = p_cod_vbn;

    -- Sumar los promedios de los detalles de facturas ventas asociados a un bouquet del mismo catálogo
    SELECT COALESCE(SUM(promedio), 0) + suma_promedios, COUNT(promedio) + count_promedios INTO suma_promedios, count_promedios
    FROM detalles_facturas_ventas
    WHERE id_floristeria_bouquet = p_id_floristeria AND cod_vbn_bouquet = p_cod_vbn;

    -- Calcular el promedio final
    IF count_promedios > 0 THEN
        promedio_final := suma_promedios / count_promedios;
    ELSE
        promedio_final := 0;
    END IF;

    -- Redondear el promedio final
    promedio_final := ROUND(promedio_final);

    RETURN promedio_final;
END;
$$ LANGUAGE plpgsql;
-- DROP FUNCTION calcular_promedio(p_id_floristeria NUMERIC, p_cod_vbn NUMERIC);