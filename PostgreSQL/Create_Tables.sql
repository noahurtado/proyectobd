-- CREACION DE LAS TABLAS CON SU SECUENCIA CORRESPONDIENTE -------------------------------------------------------------------------
CREATE EXTENSION pgagent;

-- PAIS
CREATE SEQUENCE id_pais_secuencia
	START WITH 1
	INCREMENT BY 1;
	
CREATE TABLE paises(
    id_pais numeric(3) NOT NULL DEFAULT nextval('id_pais_secuencia') PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- FLOR CORTE
CREATE SEQUENCE id_flor_corte_secuencia
	START WITH 1
	INCREMENT BY 1;
	
CREATE TABLE flores_cortes(
    id_flor_corte numeric(5) NOT NULL DEFAULT nextval('id_flor_corte_secuencia') PRIMARY KEY,
    nombre_comun VARCHAR(50) NOT NULL UNIQUE,
    etimologia VARCHAR(300) NOT NULL,
    genero_especie VARCHAR(100) NOT NULL,
    colores VARCHAR(100) NOT NULL,
    temperatura NUMERIC(4,2) NOT NULL
);

-- COLOR FLOR
CREATE TABLE colores_flores(
    cod_hex VARCHAR(6) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(300) NOT NULL
);

-- SIGNIFICADO
CREATE SEQUENCE id_significado_secuencia
	START WITH 1
	INCREMENT BY 1;
	
CREATE TABLE significados(
    id_significado numeric(2) NOT NULL DEFAULT nextval('id_significado_secuencia') PRIMARY KEY,
    tipo VARCHAR(20) NOT NULL,
    descripcion VARCHAR(300),
	
	CONSTRAINT CHK_tipo CHECK (tipo IN ('Ocasion', 'Sentimiento'))
);

-- CLIENTE FLORISTERIA
CREATE SEQUENCE id_cliente_floristeria_secuencia
	START WITH 1
	INCREMENT BY 1;
	
CREATE TABLE clientes_floristerias(
    id_cliente_floristeria numeric(6) NOT NULL DEFAULT nextval('id_cliente_floristeria_secuencia') PRIMARY KEY,
    primer_nombre VARCHAR(50) NOT NULL,
    primer_apellido VARCHAR(50) NOT NULL,
    documento_identidad VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
	segundo_nombre VARCHAR(50),

	CONSTRAINT CHK_fecha_nacimiento CHECK (fecha_nacimiento < CURRENT_DATE)
);

-- PRODUCTOR
CREATE SEQUENCE id_productor_secuencia
	START WITH 1
	INCREMENT BY 1;
	
CREATE TABLE productores(
    id_productor numeric(4) NOT NULL DEFAULT nextval('id_productor_secuencia') PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    sitio_web VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    id_pais numeric(3) NOT NULL,
	
    CONSTRAINT FK_pais FOREIGN KEY(id_pais) REFERENCES paises(id_pais)
);

-- SUBASTADORA
CREATE SEQUENCE id_subastadora_secuencia
	START WITH 1
	INCREMENT BY 1;
	
CREATE TABLE subastadoras(
    id_subastadora numeric(4) NOT NULL DEFAULT nextval('id_subastadora_secuencia') PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    id_pais numeric(3) NOT NULL,
	
    CONSTRAINT FK_pais FOREIGN KEY(id_pais) REFERENCES paises(id_pais)
);

-- CONTRATO
CREATE SEQUENCE id_contrato_secuencia
	START WITH 1
	INCREMENT BY 1;
	
CREATE TABLE contratos(
	id_productor numeric(4) NOT NULL,
    id_subastadora numeric(4) NOT NULL,
    id_contrato numeric(6) NOT NULL DEFAULT nextval('id_contrato_secuencia') NOT NULL UNIQUE,
    porcentaje_produccion_total NUMERIC(5,2) NOT NULL,
    fecha_firma DATE NOT NULL,
    clasificacion VARCHAR(5) NOT NULL,
	fecha_cierre_cancelacion DATE,
	id_productor_renovado numeric(4), -- Referencia al contrato renovado (opcional)
	id_subastadora_renovado numeric(4), -- Referencia al contrato renovado (opcional)
    id_contrato_renovado numeric(4), -- Referencia al contrato renovado (opcional)
	
    CONSTRAINT PK_contrato PRIMARY KEY (id_productor, id_subastadora, id_contrato),
    CONSTRAINT FK1_productor FOREIGN KEY (id_productor) REFERENCES productores (id_productor),
    CONSTRAINT FK2_subastadora FOREIGN KEY (id_subastadora) REFERENCES subastadoras (id_subastadora),
    CONSTRAINT FK3_contrato_renovado FOREIGN KEY (id_productor_renovado,id_subastadora_renovado, id_contrato_renovado) REFERENCES contratos(id_productor, id_subastadora, id_contrato),
	CONSTRAINT U_contrato_renovado UNIQUE (id_contrato_renovado,id_productor_renovado,id_subastadora_renovado),
	CONSTRAINT CHK_clasificacion CHECK (clasificacion IN ('CA', 'CB', 'CC', 'CG', 'KA')),
	CONSTRAINT CHK_porcentaje_produccion_total CHECK (porcentaje_produccion_total >0 AND porcentaje_produccion_total <= 100)
);

-- CATALOGO PRODUCTOR
CREATE TABLE catalogos_productores(
    cod_vbn numeric(6) NOT NULL,
	id_productor numeric(4) NOT NULL,
    nombre VARCHAR(50) NOT NULL UNIQUE,
	id_flor_corte numeric(5) NOT NULL,
    descripcion VARCHAR(300),
	
    CONSTRAINT PK_catalogo_productor PRIMARY KEY(id_productor, cod_vbn),
    CONSTRAINT FK1_productor FOREIGN KEY(id_productor) REFERENCES productores(id_productor),
    CONSTRAINT FK2_flor_corte FOREIGN KEY(id_flor_corte) REFERENCES flores_cortes(id_flor_corte)
);

-- PAGO
CREATE SEQUENCE id_pago_secuencia
	START WITH 1
	INCREMENT BY 1;
	
CREATE TABLE pagos(
	id_contrato numeric(6) NOT NULL,
    id_productor numeric(4) NOT NULL,
    id_subastadora numeric(4) NOT NULL,
    id_pago numeric(6) NOT NULL DEFAULT nextval('id_pago_secuencia'),
    monto NUMERIC(9,2) NOT NULL,
    tipo VARCHAR(10) NOT NULL,
    fecha_pago DATE NOT NULL,
	
    CONSTRAINT PK_pago PRIMARY KEY(id_productor, id_subastadora, id_contrato, id_pago),
    CONSTRAINT FK_contrato FOREIGN KEY(id_productor, id_subastadora, id_contrato) REFERENCES contratos(id_productor, id_subastadora, id_contrato),
	CONSTRAINT CHK_tipo_pago CHECK (tipo IN ('Membresia', 'Multa', 'Comision'))
);

-- FLORISTERIA
CREATE SEQUENCE id_floristeria_secuencia
	START WITH 1
	INCREMENT BY 1;
	
CREATE TABLE floristerias(
    id_floristeria numeric(4) NOT NULL DEFAULT nextval('id_floristeria_secuencia') PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    id_pais numeric(3) NOT NULL,
	
    CONSTRAINT FK_pais FOREIGN KEY(id_pais) REFERENCES paises(id_pais)
);

-- PERSONAL
CREATE SEQUENCE id_personal_secuencia
	START WITH 1
	INCREMENT BY 1;
	
CREATE TABLE personales(
    id_personal numeric(4) NOT NULL DEFAULT nextval('id_personal_secuencia'),
	id_floristeria numeric(4) NOT NULL,
    primer_nombre VARCHAR(50) NOT NULL,
    primer_apelliddo VARCHAR(50) NOT NULL,
    documento_identidad VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
	segundo_nombre VARCHAR(50),
    
    CONSTRAINT PK_personal PRIMARY KEY(id_floristeria, id_personal),
    CONSTRAINT FK_floristeria FOREIGN KEY(id_floristeria) REFERENCES floristerias(id_floristeria),
	CONSTRAINT CHK_fecha_nacimiento CHECK (fecha_nacimiento < CURRENT_DATE)
);

-- DETALLE CONTRATO

CREATE TABLE detalles_contratos(
	id_productor numeric(4) NOT NULL,
    id_subastadora numeric(4) NOT NULL,
	cod_vbn numeric(6) NOT NULL,
    id_contrato numeric(6) NOT NULL,
    cantidad numeric(6) NOT NULL,
    
    CONSTRAINT PK_detalle_contrato PRIMARY KEY(id_productor, id_subastadora, cod_vbn, id_contrato),
    CONSTRAINT FK1_catalogo FOREIGN KEY(id_productor, cod_vbn) REFERENCES catalogos_productores(id_productor, cod_vbn),
    CONSTRAINT FK2_contrato FOREIGN KEY(id_productor, id_subastadora, id_contrato) REFERENCES contratos(id_productor, id_subastadora, id_contrato)
);

-- AFILIACION

CREATE TABLE afiliaciones(
    id_subastadora numeric(4) NOT NULL,
    id_floristeria numeric(4) NOT NULL,
	
    CONSTRAINT PK_afiliacion PRIMARY KEY(id_subastadora, id_floristeria),
    CONSTRAINT FK1_subastadora FOREIGN KEY(id_subastadora) REFERENCES subastadoras(id_subastadora),
    CONSTRAINT FK2_floristeria FOREIGN KEY(id_floristeria) REFERENCES floristerias(id_floristeria)
);

-- FACTURA COMPRA
CREATE SEQUENCE id_factura_compra_secuencia
	START WITH 1
	INCREMENT BY 1;
	
CREATE TABLE facturas_compras(
    id_factura numeric(7) NOT NULL DEFAULT nextval('id_factura_compra_secuencia') PRIMARY KEY,
    fecha_emision TIMESTAMP NOT NULL,
    monto_total NUMERIC(9,2) NOT NULL,
	id_subastadora numeric(4) NOT NULL,
    id_floristeria numeric(4) NOT NULL,
    envio NUMERIC(9,2),
    
    CONSTRAINT FK_afiliacion FOREIGN KEY(id_subastadora, id_floristeria) REFERENCES afiliaciones(id_subastadora, id_floristeria)
);

-- LOTE
CREATE SEQUENCE id_lote_secuencia
	START WITH 1
	INCREMENT BY 1;
	
CREATE TABLE lotes(
	-- Factura
	id_factura_compra numeric(7) NOT NULL,
	-- Detalle contrato
	-- /Catalogo
	id_productor numeric(4) NOT NULL,
	cod_vbn numeric(6) NOT NULL,
	-- /Contrato
    id_subastadora numeric(4) NOT NULL,
    id_contrato numeric(6) NOT NULL,
    id_lote numeric(7) NOT NULL DEFAULT nextval('id_lote_secuencia'),
    cantidad numeric(6) NOT NULL,
    precio_inicial NUMERIC(9,2) NOT NULL,
    indice_calidad NUMERIC(2,1) NOT NULL,
    precio_final NUMERIC(9,2) NOT NULL,
	
    CONSTRAINT PK_lote PRIMARY KEY(id_factura_compra, id_productor, id_subastadora, cod_vbn, id_contrato, id_lote),
    CONSTRAINT FK1_factura_compra FOREIGN KEY(id_factura_compra) REFERENCES facturas_compras(id_factura),
    CONSTRAINT FK2_detalle_contrato FOREIGN KEY(id_productor, id_subastadora, cod_vbn, id_contrato) REFERENCES detalles_contratos(id_productor, id_subastadora, cod_vbn, id_contrato),
	CONSTRAINT CHK_indice_calidad CHECK (indice_calidad >= 0.5 AND indice_calidad <= 1)
);

-- ENLACE
CREATE SEQUENCE id_enlace_secuencia
	START WITH 1
	INCREMENT BY 1;
	
CREATE TABLE enlaces(
	id_significado numeric(2) NOT NULL,
    id_enlace numeric(4) NOT NULL DEFAULT nextval('id_enlace_secuencia'),
    descripcion VARCHAR(300),
    cod_hex VARCHAR(6),
	id_flor_corte numeric(5),
    
    CONSTRAINT PK_enlace PRIMARY KEY(id_significado, id_enlace),
    CONSTRAINT FK1_color_flor FOREIGN KEY(cod_hex) REFERENCES colores_flores(cod_hex),
    CONSTRAINT FK2_significado FOREIGN KEY(id_significado) REFERENCES significados(id_significado),
	CONSTRAINT FK3_flor_corte FOREIGN KEY(id_flor_corte) REFERENCES flores_cortes(id_flor_corte)
);

-- FACTURA VENTA
CREATE SEQUENCE id_factura_venta_secuencia
	START WITH 1
	INCREMENT BY 1;
	
CREATE TABLE facturas_ventas(
	id_floristeria numeric(5) NOT NULL,
    id_factura_venta numeric(7) NOT NULL DEFAULT nextval('id_factura_venta_secuencia'),
    id_cliente_floristeria numeric(6) NOT NULL,
    fecha DATE NOT NULL,
    total NUMERIC(9,2) NOT NULL,
    
    CONSTRAINT PK_factura_venta PRIMARY KEY(id_floristeria, id_factura_venta),
    CONSTRAINT FK1_floristeria FOREIGN KEY(id_floristeria) REFERENCES floristerias(id_floristeria),
    CONSTRAINT FK2_cliente_floristeria FOREIGN KEY(id_cliente_floristeria) REFERENCES clientes_floristerias(id_cliente_floristeria)
);

-- CATALOGO FLORISTERIA
CREATE TABLE catalogos_floristerias(
    id_floristeria numeric(4) NOT NULL,
    cod_vbn numeric(6) NOT NULL,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    cod_hex VARCHAR(6) NOT NULL,
    id_flor_corte numeric(5) NOT NULL,
	descripcion VARCHAR(300),
	
    CONSTRAINT PK_catalogo_floristeria PRIMARY KEY(id_floristeria, cod_vbn),
    CONSTRAINT FK1_floristeria FOREIGN KEY(id_floristeria) REFERENCES floristerias(id_floristeria),
    CONSTRAINT FK2_color_flor FOREIGN KEY(cod_hex) REFERENCES colores_flores(cod_hex),
    CONSTRAINT FK3_flor_corte FOREIGN KEY(id_flor_corte) REFERENCES flores_cortes(id_flor_corte)
);

-- HISTORICO PRECIO UNITARIO
CREATE TABLE hist_precios_unitarios(
    id_floristeria numeric(5) NOT NULL,
	cod_vbn numeric(6) NOT NULL,
    fecha_inicio DATE NOT NULL,
    precio_unitario NUMERIC(9,2) NOT NULL,
    fecha_fin DATE,
    tamano_tallo NUMERIC(5,2),
    
    CONSTRAINT PK_hist_precio_unitario PRIMARY KEY(id_floristeria, cod_vbn, fecha_inicio),
    CONSTRAINT FK_catalogo_floristeria FOREIGN KEY(id_floristeria, cod_vbn) REFERENCES catalogos_floristerias(id_floristeria, cod_vbn)
);

-- DETALLE BOUQUET
CREATE SEQUENCE id_detalle_bouquet_secuencia
	START WITH 1
	INCREMENT BY 1;
	
CREATE TABLE detalles_bouquets(
    id_floristeria numeric(5) NOT NULL,
    cod_vbn numeric(6) NOT NULL,
    id_detalle_bouquet numeric(5) NOT NULL DEFAULT nextval('id_detalle_bouquet_secuencia'),
    cantidad numeric(4) NOT NULL,
    descripcion VARCHAR(300),
    tamano_tallo NUMERIC(5,2),
	
    CONSTRAINT PK_detalle_bouquet PRIMARY KEY(id_floristeria, cod_vbn, id_detalle_bouquet),
    CONSTRAINT FK_catalogo_floristeria FOREIGN KEY(id_floristeria, cod_vbn) REFERENCES catalogos_floristerias(id_floristeria, cod_vbn)
);

-- DETALLE FACTURA VENTA
CREATE SEQUENCE detalle_factura_venta_secuencia
	START WITH 1
	INCREMENT BY 1;
	
CREATE TABLE detalles_facturas_ventas(
	--Factura
    id_floristeria numeric(4) NOT NULL,
    id_factura_venta numeric(7) NOT NULL,
    id_detalle_factura_venta numeric(7) NOT NULL DEFAULT nextval('detalle_factura_venta_secuencia'),
    cantidad numeric(6) NOT NULL,
	-- Det Bouquet
	id_floristeria_bouquet numeric(4),
    cod_vbn_bouquet numeric(6),
    id_detalle_bouquet numeric(5),
	-- Catalogo floristeria
	id_floristeria_cat numeric(4),
    cod_vbn_cat numeric(6),
	
    valor_calidad NUMERIC(1),
    valor_precio NUMERIC(1),
    promedio NUMERIC(1),
	
    CONSTRAINT PK_detalle_factura_venta PRIMARY KEY(id_floristeria, id_factura_venta, id_detalle_factura_venta),
    CONSTRAINT FK1_factura_venta FOREIGN KEY(id_floristeria, id_factura_venta) REFERENCES facturas_ventas(id_floristeria, id_factura_venta),
    CONSTRAINT FK2_detalle_bouquet FOREIGN KEY(id_floristeria_bouquet, cod_vbn_bouquet, id_detalle_bouquet) REFERENCES detalles_bouquets(id_floristeria, cod_vbn, id_detalle_bouquet),
    CONSTRAINT FK3_catalogo_floristeria FOREIGN KEY(id_floristeria_cat, cod_vbn_cat) REFERENCES catalogos_floristerias(id_floristeria, cod_vbn),
	CONSTRAINT CHK_Valor_calidad CHECK ((valor_calidad>= 0) AND (valor_calidad <=5)),
	CONSTRAINT CHK_Valor_precio CHECK ((valor_precio>= 0) AND (valor_precio <=5)),
	CONSTRAINT CHK_Promedio CHECK ((promedio>= 0) AND (promedio <=5))
);

-- TELEFONO
CREATE TABLE telefonos(
    prefijo numeric(2) NOT NULL,
    cod_area numeric(3) NOT NULL,
    numero numeric(7) NOT NULL,
    tipo VARCHAR(10) NOT NULL,
	-- Floristeria
    id_floristeria numeric(4),
	-- Productor
    id_productor numeric(4),
	-- Personal
	id_floristeria_personal numeric(4),
    id_personal numeric(4),
	-- Subastadora
    id_subastadora numeric(4),
    CONSTRAINT PK_telefono PRIMARY KEY(prefijo, cod_area, numero),
    CONSTRAINT FK1_floristeria FOREIGN KEY(id_floristeria) REFERENCES floristerias(id_floristeria),
    CONSTRAINT FK2_productor FOREIGN KEY(id_productor) REFERENCES productores(id_productor),
    CONSTRAINT FK3_personal FOREIGN KEY(id_floristeria_personal, id_personal) REFERENCES personales(id_floristeria, id_personal),
    CONSTRAINT FK4_subastador FOREIGN KEY(id_subastadora) REFERENCES subastadoras(id_subastadora),
	CONSTRAINT CHK_tipo_telefono CHECK (tipo IN('Fijo', 'Movil')),
	CONSTRAINT CHK_prefijo CHECK (prefijo BETWEEN 1 AND 99),
	CONSTRAINT CHK_cod_area CHECK (cod_area BETWEEN 100 AND 999),
	CONSTRAINT CHK_numero CHECK (numero BETWEEN 1000000 AND 9999999)
);

