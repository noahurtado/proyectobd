INSERT INTO paises (nombre) VALUES
('Países Bajos'),
('Estados Unidos'),
('Colombia'),
('Reino Unido'),
('España'),
('Francia'),
('Italia'),
('Alemania'),
('Japón'),
('China'),
('India'),
('Australia'),
('Canadá'),
('México'),
('Brasil'),
('Argentina'),
('Sudáfrica'),
('Corea del Sur'),
('Rusia'),
('Nueva Zelanda');


INSERT INTO flores_cortes (nombre_comun, etimologia, genero_especie, colores, temperatura) VALUES
('Rosa', 'Del latín rosa.', 'Rosa spp.', 'Rojo, Blanco, Rosa', 20.5),
('Tulipán', 'Del turco tülbend.', 'Tulipa spp.', 'Amarillo, Rojo', 15.0),
('Orquídea', 'Del griego orkhis.', 'Orchidaceae spp.', 'Blanco, Púrpura', 18.0),
('Clavel', 'Del latín clavus.', 'Dianthus spp.', 'Rosa, Rojo', 17.0),
('Lirio', 'Del griego leirion.', 'Lilium spp.', 'Blanco, Naranja', 16.5),
('Hortensia', 'Por el naturalista Philibert Commerson.', 'Hydrangea spp.', 'Azul, Blanco', 15.5),
('Girasol', 'Del griego helios.', 'Helianthus spp.', 'Amarillo', 22.0),
('Margarita', 'Del latín margarita.', 'Bellis spp.', 'Blanco, Amarillo', 18.5),
('Crisantemo', 'Del griego chrysos.', 'Chrysanthemum spp.', 'Amarillo, Blanco', 17.5),
('Peonía', 'En honor a Paeon.', 'Paeonia spp.', 'Rosa, Blanco', 16.0),
('Dalia', 'En honor a Anders Dahl.', 'Dahlia spp.', 'Rojo, Amarillo', 20.0),
('Gardenia', 'Por el botánico Alexander Garden.', 'Gardenia spp.', 'Blanco', 19.0),
('Gladiolo', 'Del latín gladius.', 'Gladiolus spp.', 'Rosa, Amarillo', 21.0),
('Iris', 'Por la diosa griega Iris.', 'Iris spp.', 'Morado, Azul', 16.0),
('Jacinto', 'Del griego hyakinthos.', 'Hyacinthus spp.', 'Azul, Blanco', 15.0),
('Cactus Navidad', 'Por su floración.', 'Schlumbergera spp.', 'Rosa, Blanco', 22.5),
('Rudbeckia', 'En honor a Olaus Rudbeck.', 'Rudbeckia spp.', 'Amarillo, Naranja', 23.0),
('Anémona', 'Del griego anemos.', 'Anemone spp.', 'Rojo, Blanco', 16.0),
('Amarilis', 'Por Amaryllis en mitología griega.', 'Hippeastrum spp.', 'Rojo, Blanco', 17.5),
('Lavanda', 'Del latín lavare.', 'Lavandula spp.', 'Morado', 20.0);


INSERT INTO colores_flores (cod_hex, nombre, descripcion) VALUES
('FF0000', 'Rojo', 'Color asociado con el amor y la pasión.'),
('FFFFFF', 'Blanco', 'Color de la pureza y la paz.'),
('FFFF00', 'Amarillo', 'Color de la alegría y la felicidad.'),
('00FF00', 'Verde', 'Color de la naturaleza y la esperanza.'),
('0000FF', 'Azul', 'Color de la tranquilidad y el océano.'),
('FF00FF', 'Púrpura', 'Color de la realeza y la creatividad.'),
('FFA500', 'Naranja', 'Color de la energía y el entusiasmo.'),
('A52A2A', 'Marrón', 'Color de la tierra y la estabilidad.'),
('808080', 'Gris', 'Color de la neutralidad y la modernidad.'),
('800000', 'Vino', 'Color de la sofisticación y la elegancia.'),
('008080', 'Turquesa', 'Color refrescante y revitalizante.'),
('FFD700', 'Oro', 'Color de la riqueza y el lujo.'),
('4B0082', 'Índigo', 'Color de la sabiduría y el misterio.'),
('DC143C', 'Carmesí', 'Color del poder y la intensidad.'),
('ADD8E6', 'Azul Claro', 'Color de la calma y la serenidad.'),
('FF69B4', 'Rosado', 'Color de la ternura y el romance.'),
('8A2BE2', 'Violeta', 'Color de la espiritualidad y la imaginación.'),
('00CED1', 'Aguamarina', 'Color fresco y relajante.'),
('D2691E', 'Chocolate', 'Color cálido y acogedor.'),
('7CFC00', 'Lima', 'Color vibrante y lleno de vida.');


INSERT INTO significados (descripcion, tipo) VALUES
('Amor eterno', 'Sentimiento'),
('Felicidad', 'Sentimiento'),
('Paz y pureza', 'Sentimiento'),
('Pasión', 'Sentimiento'),
('Alegría', 'Sentimiento'),
('Nuevo comienzo', 'Sentimiento'),
('Buena suerte', 'Sentimiento'),
('Amistad', 'Sentimiento'),
('Agradecimiento', 'Sentimiento'),
('Compasión', 'Sentimiento'),
('Cumpleaños', 'Ocasion'),
('Boda', 'Ocasion'),
('Aniversario', 'Ocasion'),
('San Valentín', 'Ocasion'),
('Graduación', 'Ocasion'),
('Día de la madre', 'Ocasion'),
('Día del padre', 'Ocasion'),
('Navidad', 'Ocasion'),
('Año nuevo', 'Ocasion'),
('Conmemoración', 'Ocasion');


INSERT INTO clientes_floristerias (primer_nombre, primer_apellido, documento_identidad, fecha_nacimiento, segundo_nombre) VALUES
('John', 'Doe', '123456789', '1985-03-25', 'Michael'),
('Jane', 'Smith', '987654321', '1990-06-15', NULL),
('Carlos', 'González', '543216789', '1982-01-12', 'Eduardo'),
('Laura', 'Martínez', '456123789', '1995-10-05', NULL),
('María', 'Lopez', '852963741', '1992-12-20', 'Victoria'),
('Robert', 'Brown', '951753468', '1975-07-14', 'James'),
('Linda', 'Johnson', '789456123', '1980-04-30', NULL),
('Pedro', 'Hernández', '321654987', '1993-09-18', 'Luis'),
('Sofía', 'Ramírez', '654789123', '1988-11-07', 'Elena'),
('Miguel', 'Torres', '963852741', '1986-02-24', 'Andrés'),
('Anna', 'Davis', '258147963', '1991-05-16', NULL),
('Juan', 'Morales', '741852963', '1987-08-22', 'Diego'),
('Emma', 'Wilson', '369258147', '1994-03-09', NULL),
('Lucía', 'Garza', '147852369', '1983-07-27', 'Isabel'),
('Oliver', 'Morris', '753159846', '1990-12-03', 'Alexander'),
('Victoria', 'Cruz', '951357482', '1989-06-19', NULL),
('Daniel', 'Ortiz', '159753284', '1985-10-28', 'Sebastián'),
('Amelia', 'Scott', '284957316', '1993-01-08', NULL),
('Alejandro', 'Medina', '635917482', '1982-04-12', 'Javier'),
('Natalia', 'Jiménez', '482159637', '1996-09-03', 'Gabriela');


INSERT INTO productores (nombre, sitio_web, email, id_pais) VALUES
('Florensis', 'www.florensis.com', 'info@florensis.com', 1),
('Dos Gringos', 'www.dosgringos.com', 'contact@dosgringos.com', 2),
('FlorBella', 'www.florbella.com', 'ventas@florbella.com', 3),
('EuroFlowers', 'www.euroflowers.com', 'sales@euroflowers.com', 1),
('FlowerGarden', 'www.flowergarden.com', 'hello@flowergarden.com', 2),
('NaturalBloom', 'www.naturalbloom.com', 'info@naturalbloom.com', 3),
('TulipHouse', 'www.tuliphouse.com', 'sales@tuliphouse.com', 1),
('SunriseFlowers', 'www.sunriseflowers.com', 'contact@sunriseflowers.com', 3),
('BloomProducers', 'www.bloomproducers.com', 'info@bloomproducers.com', 2),
('GardenArt', 'www.gardenart.com', 'contact@gardenart.com', 3),
('GreenPetals', 'www.greenpetals.com', 'info@greenpetals.com', 1),
('RoseValley', 'www.rosevalley.com', 'sales@rosevalley.com', 3),
('TropicalFlora', 'www.tropicalflora.com', 'contact@tropicalflora.com', 2),
('FreshFlowers', 'www.freshflowers.com', 'info@freshflowers.com', 1),
('SpringFields', 'www.springfields.com', 'sales@springfields.com', 2),
('ColorBloom', 'www.colorbloom.com', 'info@colorbloom.com', 3),
('LilyLand', 'www.lilyland.com', 'contact@lilyland.com', 1),
('DaisyDreams', 'www.daisydreams.com', 'info@daisydreams.com', 2),
('HydrangeaHeaven', 'www.hydrangeaheaven.com', 'contact@hydrangeaheaven.com', 3),
('GardenBloom', 'www.gardenbloom.com', 'info@gardenbloom.com', 1);


INSERT INTO subastadoras (nombre, id_pais) VALUES
('Hessinks Fine Art Auctioneers', 1),
('Vendu Rotterdam', 1),
('Adams Amsterdam Auctions', 1),
('Bloemenveiling Aalsmeer', 1),
('Royal FloraHolland', 1),
('FlowerBid', 2),
('Green Auctions', 3),
('Euro Auction', 1),
('FloraTrade', 2),
('GlobalFlowers', 3),
('FreshBids', 1),
('Sunflower Auctions', 3),
('Golden Petals Auction', 1),
('Rainbow Auction House', 2),
('Sunset Auctions', 1),
('White Bloom Auctions', 3),
('Natural Auction Co.', 2),
('Colorful Flora Auctions', 1),
('Morning Dew Auctions', 3),
('Evening Blossom Auctions', 1);


INSERT INTO floristerias (nombre, email, id_pais) VALUES
('Winston Flowers', 'info@winstonflowers.com', 2),
('Appleyard Flowers', 'contact@appleyardflowers.co.uk', 4),
('Flowers of Colombia', 'ventas@flowersofcolombia.com', 3),
('Flowers4You', 'support@flowers4you.nl', 1),
('FloralShip', 'info@floralship.es', 5),
('BloomMarket', 'hello@bloommarket.com', 2),
('PetalHouse', 'sales@petalhouse.com', 4),
('EverBloom', 'contact@everbloom.com', 3),
('SunnyFlorals', 'info@sunnyflorals.com', 1),
('GoldenRoses', 'support@goldenroses.com', 5),
('FlowerJoy', 'hello@flowerjoy.com', 3),
('TulipDreams', 'contact@tulipdreams.com', 1),
('PurePetals', 'info@purepetals.com', 4),
('RoseParadise', 'sales@roseparadise.com', 2),
('DaisyBliss', 'hello@daisybliss.com', 3),
('FloralHeaven', 'info@floralheaven.com', 5),
('PetalCreations', 'sales@petalcreations.com', 1),
('BloomWorld', 'support@bloomworld.com', 2),
('GardenElegance', 'contact@gardenelegance.com', 3),
('RoyalBouquets', 'info@royalbouquets.com', 4);


INSERT INTO catalogos_productores (cod_vbn, id_productor, nombre, id_flor_corte, descripcion) VALUES
(10001, 1, 'Rosa Elegance', 1, 'Rosas de calidad premium para eventos.'),
(10002, 1, 'Tulipán Bright', 2, 'Tulipanes vibrantes ideales para regalos.'),
(10003, 2, 'Orquídea Deluxe', 3, 'Orquídeas exóticas para decoración.'),
(10004, 3, 'Clavel Charm', 4, 'Claveles frescos y coloridos.'),
(10005, 1, 'Lirio Grace', 5, 'Lirios elegantes para cualquier ocasión.'),
(10006, 2, 'Hortensia Bliss', 6, 'Hortensias suaves y delicadas.'),
(10007, 3, 'Girasol Joy', 7, 'Girasoles vibrantes que alegran el día.'),
(10008, 1, 'Margarita Sun', 8, 'Margaritas brillantes y alegres.'),
(10009, 2, 'Crisantemo Classic', 9, 'Crisantemos duraderos y elegantes.'),
(10010, 3, 'Peonía Dream', 10, 'Peonías encantadoras para momentos especiales.'),
(10011, 1, 'Dalia Luxury', 11, 'Dalias de colores intensos.'),
(10012, 2, 'Gardenia Pure', 12, 'Gardenias clásicas con un aroma único.'),
(10013, 3, 'Gladiolo Noble', 13, 'Gladiolos robustos y coloridos.'),
(10014, 1, 'Iris Mystic', 14, 'Iris etéreos y mágicos.'),
(10015, 2, 'Jacinto Fragrance', 15, 'Jacintos fragantes y coloridos.'),
(10016, 3, 'Cactus Navidad Glow', 16, 'Cactus Navidad ideales para festividades.'),
(10017, 1, 'Rudbeckia Charm', 17, 'Rudbeckias cálidas y alegres.'),
(10018, 2, 'Anémona Elegance', 18, 'Anémonas clásicas y encantadoras.'),
(10019, 3, 'Amarilis Bold', 19, 'Amarilis con colores vibrantes.'),
(10020, 1, 'Lavanda Serenity', 20, 'Lavanda relajante y aromática.');


INSERT INTO contratos (id_productor, id_subastadora, id_contrato, porcentaje_produccion_total, fecha_firma, clasificacion, fecha_cierre_cancelacion) VALUES
(1, 1, 10001, 50.00, '2024-01-01', 'CA', NULL),
(1, 2, 10002, 30.00, '2024-01-05', 'CB', NULL),
(2, 3, 10003, 45.00, '2024-01-10', 'CC', NULL),
(3, 4, 10004, 35.00, '2024-01-15', 'CG', NULL),
(1, 1, 10005, 40.00, '2024-01-20', 'CA', NULL),
(2, 2, 10006, 25.00, '2024-01-25', 'CB', NULL),
(3, 3, 10007, 60.00, '2024-01-30', 'CC', NULL),
(1, 4, 10008, 55.00, '2024-02-05', 'CG', NULL),
(2, 1, 10009, 70.00, '2024-02-10', 'CA', NULL),
(3, 2, 10010, 80.00, '2024-02-15', 'CB', NULL),
(1, 3, 10011, 45.00, '2024-02-20', 'CC', NULL),
(2, 4, 10012, 35.00, '2024-02-25', 'CG', NULL),
(3, 1, 10013, 60.00, '2024-03-01', 'CA', NULL),
(1, 2, 10014, 75.00, '2024-03-05', 'CB', NULL),
(2, 3, 10015, 40.00, '2024-03-10', 'CC', NULL),
(3, 4, 10016, 85.00, '2024-03-15', 'CG', NULL),
(1, 1, 10017, 30.00, '2024-03-20', 'CA', NULL),
(2, 2, 10018, 25.00, '2024-03-25', 'CB', NULL),
(3, 3, 10019, 50.00, '2024-03-30', 'CC', NULL),
(1, 4, 10020, 60.00, '2024-04-01', 'CG', NULL);


INSERT INTO pagos (id_contrato, id_productor, id_subastadora, monto, tipo, fecha_pago) VALUES
(10001, 1, 1, 500.00, 'Membresia', '2024-01-10'),
(10002, 1, 2, 300.00, 'Comision', '2024-02-15'),
(10003, 2, 3, 450.00, 'Multa', '2024-03-01'),
(10004, 3, 4, 350.00, 'Membresia', '2024-04-20'),
(10005, 1, 1, 400.00, 'Comision', '2024-05-30'),
(10006, 2, 2, 250.00, 'Multa', '2024-06-10'),
(10007, 3, 3, 600.00, 'Membresia', '2024-07-15'),
(10008, 1, 4, 550.00, 'Comision', '2024-08-25'),
(10009, 2, 1, 700.00, 'Multa', '2024-09-05'),
(10010, 3, 2, 800.00, 'Membresia', '2024-10-01'),
(10011, 1, 3, 450.00, 'Comision', '2024-11-10'),
(10012, 2, 4, 350.00, 'Multa', '2024-12-20'),
(10013, 3, 1, 600.00, 'Membresia', '2025-01-15'),
(10014, 1, 2, 750.00, 'Comision', '2025-02-25'),
(10015, 2, 3, 400.00, 'Multa', '2025-03-10'),
(10016, 3, 4, 850.00, 'Membresia', '2025-04-20'),
(10017, 1, 1, 300.00, 'Comision', '2025-05-30'),
(10018, 2, 2, 250.00, 'Multa', '2025-06-10'),
(10019, 3, 3, 500.00, 'Membresia', '2025-07-15'),
(10020, 1, 4, 600.00, 'Comision', '2025-08-25');


INSERT INTO detalles_contratos (id_productor, id_subastadora, cod_vbn, id_contrato, cantidad) VALUES
(1, 1, 10001, 10001, 500),
(1, 2, 10002, 10002, 300),
(2, 3, 10003, 10003, 450),
(3, 4, 10004, 10004, 350),
(1, 1, 10005, 10005, 400),
(2, 2, 10006, 10006, 250),
(3, 3, 10007, 10007, 600),
(1, 4, 10008, 10008, 550),
(2, 1, 10009, 10009, 700),
(3, 2, 10010, 10010, 800),
(1, 3, 10011, 10011, 450),
(2, 4, 10012, 10012, 350),
(3, 1, 10013, 10013, 600),
(1, 2, 10014, 10014, 750),
(2, 3, 10015, 10015, 400),
(3, 4, 10016, 10016, 850),
(1, 1, 10017, 10017, 300),
(2, 2, 10018, 10018, 250),
(3, 3, 10019, 10019, 500),
(1, 4, 10020, 10020, 600);


INSERT INTO afiliaciones (id_subastadora, id_floristeria) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15),
(16, 16),
(17, 17),
(18, 18),
(19, 19),
(20, 20);


INSERT INTO facturas_compras (fecha_emision, monto_total, id_subastadora, id_floristeria, envio) VALUES
('2024-01-15', 1500.00, 1, 1, 50.00),
('2024-01-20', 2000.00, 2, 2, 75.00),
('2024-02-01', 1800.00, 3, 3, 60.00),
('2024-02-10', 2500.00, 4, 4, 100.00),
('2024-02-20', 3000.00, 5, 5, 120.00),
('2024-03-01', 2200.00, 6, 6, 80.00),
('2024-03-10', 2700.00, 7, 7, 110.00),
('2024-03-20', 3200.00, 8, 8, 150.00),
('2024-04-01', 4000.00, 9, 9, 200.00),
('2024-04-10', 3600.00, 10, 10, 180.00),
('2024-05-01', 4200.00, 11, 11, 210.00),
('2024-05-15', 3800.00, 12, 12, 190.00),
('2024-06-01', 4400.00, 13, 13, 220.00),
('2024-06-15', 5000.00, 14, 14, 250.00),
('2024-07-01', 5200.00, 15, 15, 260.00),
('2024-07-15', 4800.00, 16, 16, 240.00),
('2024-08-01', 5500.00, 17, 17, 275.00),
('2024-08-15', 6000.00, 18, 18, 300.00),
('2024-09-01', 5800.00, 19, 19, 290.00),
('2024-09-15', 6200.00, 20, 20, 310.00);

INSERT INTO lotes (id_factura_compra, id_productor, cod_vbn, id_subastadora, id_contrato, cantidad, precio_final, indice_calidad, precio_inicial) VALUES
(1, 1, 10001, 1, 10001, 500, 15.00, 0.9, 13.50),
(2, 1, 10002, 2, 10002, 300, 12.00, 0.8, 9.60),
(3, 2, 10003, 3, 10003, 450, 10.00, 0.7, 7.00),
(4, 3, 10004, 4, 10004, 350, 20.00, 0.95, 19.00),
(5, 1, 10005, 1, 10005, 400, 18.00, 0.85, 15.30),
(6, 2, 10006, 2, 10006, 250, 14.00, 0.75, 10.50),
(7, 3, 10007, 3, 10007, 600, 22.00, 0.9, 19.80),
(8, 1, 10008, 4, 10008, 550, 16.00, 0.8, 12.80),
(9, 2, 10009, 1, 10009, 700, 24.00, 0.95, 22.80),
(10, 3, 10010, 2, 10010, 800, 20.00, 0.85, 17.00),
(11, 1, 10011, 3, 10011, 450, 18.00, 0.75, 13.50),
(12, 2, 10012, 4, 10012, 350, 14.00, 0.65, 9.10),
(13, 3, 10013, 1, 10013, 600, 22.00, 0.9, 19.80),
(14, 1, 10014, 2, 10014, 750, 24.00, 0.95, 22.80),
(15, 2, 10015, 3, 10015, 400, 20.00, 0.8, 16.00),
(16, 3, 10016, 4, 10016, 850, 25.00, 0.85, 21.25),
(17, 1, 10017, 1, 10017, 300, 18.00, 0.75, 13.50),
(18, 2, 10018, 2, 10018, 250, 14.00, 0.65, 9.10),
(19, 3, 10019, 3, 10019, 500, 22.00, 0.85, 18.70),
(20, 1, 10020, 4, 10020, 600, 16.00, 0.75, 12.00);


INSERT INTO facturas_ventas (id_floristeria, id_factura_venta, id_cliente_floristeria, fecha, total) VALUES
(1, 1001, 1, '2024-01-15', 17.50),
(2, 1002, 2, '2024-02-01', 19.60),
(3, 1003, 3, '2024-02-10', 18.00),
(4, 1004, 4, '2024-03-01', 6.00),
(5, 1005, 5, '2024-03-15', 19.20),
(6, 1006, 6, '2024-04-01', 20.00),
(7, 1007, 7, '2024-04-15', 16.20),
(8, 1008, 8, '2024-05-01', 12.00),
(9, 1009, 9, '2024-05-15', 16.20),
(10, 1010, 10, '2024-06-01', 12.00),
(11, 1011, 11, '2024-06-15', 19.00),
(12, 1012, 12, '2024-07-01', 31.20),
(13, 1013, 13, '2024-07-15', 10.00),
(14, 1014, 14, '2024-08-01', 15.00),
(15, 1015, 15, '2024-08-15', 24.50),
(16, 1016, 16, '2024-09-01', 11.20),
(17, 1017, 17, '2024-09-15', 18.00),
(18, 1018, 18, '2024-10-01', 33.60),
(19, 1019, 19, '2024-10-15', 19.00),
(20, 1020, 20, '2024-11-01', 35.00);


INSERT INTO personales (id_floristeria, primer_nombre, primer_apelliddo, documento_identidad, fecha_nacimiento, segundo_nombre) VALUES
(1, 'Lucas', 'Pérez', '123456789', '1990-05-10', 'Andrés'),
(2, 'María', 'Gómez', '234567891', '1985-07-15', NULL),
(3, 'Carlos', 'López', '345678912', '1992-03-22', 'David'),
(4, 'Laura', 'Martínez', '456789123', '1988-11-05', 'Isabel'),
(5, 'Ana', 'Ramírez', '567891234', '1993-09-18', NULL),
(6, 'Diego', 'Hernández', '678912345', '1989-01-10', 'Alejandro'),
(7, 'Elena', 'Fernández', '789123456', '1987-04-12', 'Sofía'),
(8, 'Javier', 'Jiménez', '891234567', '1991-02-05', NULL),
(9, 'Isabel', 'Ruiz', '912345678', '1983-06-30', 'Victoria'),
(10, 'Miguel', 'Morales', '102345678', '1985-12-01', 'Luis'),
(11, 'Clara', 'Torres', '112345678', '1994-08-25', NULL),
(12, 'Sebastián', 'Mendoza', '122345678', '1990-10-10', 'Ignacio'),
(13, 'Daniela', 'Cruz', '132345678', '1995-03-05', NULL),
(14, 'Gabriel', 'Ortiz', '142345678', '1982-07-22', 'Emilio'),
(15, 'Natalia', 'Medina', '152345678', '1986-09-14', NULL),
(16, 'Roberto', 'Guerrero', '162345678', '1988-01-28', 'Arturo'),
(17, 'Paula', 'Carrillo', '172345678', '1993-05-17', 'Beatriz'),
(18, 'Fernando', 'Rojas', '182345678', '1991-06-29', NULL),
(19, 'Camila', 'Sánchez', '192345678', '1989-11-03', 'Estefanía'),
(20, 'Andrés', 'Silva', '202345678', '1990-04-13', NULL);


INSERT INTO enlaces (id_significado, id_enlace, descripcion, cod_hex, id_flor_corte) VALUES
(1, 1, 'Rosa roja para expresar amor eterno.', 'FF0000', 1),
(2, 2, 'Tulipán amarillo para felicidad.', 'FFFF00', 2),
(3, 3, 'Orquídea blanca para paz y pureza.', 'FFFFFF', 3),
(4, 4, 'Clavel rojo para simbolizar pasión.', 'FF0000', 4),
(5, 5, 'Lirio naranja para expresar alegría.', 'FFA500', 5),
(6, 6, 'Hortensia azul para nuevo comienzo.', '0000FF', 6),
(7, 7, 'Girasol amarillo para buena suerte.', 'FFFF00', 7),
(8, 8, 'Margarita blanca para amistad.', 'FFFFFF', 8),
(9, 9, 'Crisantemo amarillo para agradecimiento.', 'FFFF00', 9),
(10, 10, 'Peonía rosa para compasión.', 'FF69B4', 10),
(11, 11, 'Dalia roja para cumpleaños.', 'FF0000', 11),
(12, 12, 'Gardenia blanca para bodas.', 'FFFFFF', 12),
(13, 13, 'Gladiolo rosa para aniversario.', 'FF69B4', 13),
(14, 14, 'Iris azul para San Valentín.', '0000FF', 14),
(15, 15, 'Jacinto morado para graduación.', '8A2BE2', 15),
(16, 16, 'Cactus Navidad rojo para Navidad.', 'FF0000', 16),
(17, 17, 'Rudbeckia amarilla para Año Nuevo.', 'FFFF00', 17),
(18, 18, 'Anémona blanca para conmemoración.', 'FFFFFF', 18),
(19, 19, 'Amarilis rojo para expresar amor.', 'FF0000', 19),
(20, 20, 'Lavanda violeta para serenidad.', '8A2BE2', 20);


INSERT INTO catalogos_floristerias (id_floristeria, cod_vbn, nombre, cod_hex, id_flor_corte, descripcion) VALUES
(1, 20001, 'Rosa Romántica', 'FF0000', 1, 'Rosas rojas ideales para ocasiones románticas.'),
(2, 20002, 'Tulipán Dorado', 'FFFF00', 2, 'Tulipanes vibrantes para regalar.'),
(3, 20003, 'Orquídea Blanca', 'FFFFFF', 3, 'Orquídeas exóticas perfectas para decoración.'),
(4, 20004, 'Clavel Puro', 'FF0000', 4, 'Claveles rojos ideales para eventos.'),
(5, 20005, 'Lirio Elegante', 'FFA500', 5, 'Lirios que iluminan cualquier ocasión.'),
(6, 20006, 'Hortensia Azul', '0000FF', 6, 'Hortensias elegantes para momentos especiales.'),
(7, 20007, 'Girasol Dorado', 'FFFF00', 7, 'Girasoles brillantes y alegres.'),
(8, 20008, 'Margarita Fresca', 'FFFFFF', 8, 'Margaritas alegres y vibrantes.'),
(9, 20009, 'Crisantemo Amarillo', 'FFFF00', 9, 'Crisantemos de calidad premium.'),
(10, 20010, 'Peonía Suave', 'FF69B4', 10, 'Peonías delicadas y encantadoras.'),
(11, 20011, 'Dalia Intensa', 'FF0000', 11, 'Dalias rojas con colores vibrantes.'),
(12, 20012, 'Gardenia Pura', 'FFFFFF', 12, 'Gardenias con aroma inconfundible.'),
(13, 20013, 'Gladiolo Colorido', 'FF69B4', 13, 'Gladiolos llenos de vida.'),
(14, 20014, 'Iris Sereno', '0000FF', 14, 'Iris frescos ideales para regalos.'),
(15, 20015, 'Jacinto Perfumado', '8A2BE2', 15, 'Jacintos de gran aroma.'),
(16, 20016, 'Cactus Navidad Festivo', 'FF0000', 16, 'Cactus Navidad para festividades.'),
(17, 20017, 'Rudbeckia Vibrante', 'FFFF00', 17, 'Rudbeckias llenas de energía.'),
(18, 20018, 'Anémona Dulce', 'FFFFFF', 18, 'Anémonas suaves para eventos.'),
(19, 20019, 'Amarilis Resplandeciente', 'FF0000', 19, 'Amarilis vibrantes para ocasiones especiales.'),
(20, 20020, 'Lavanda Relajante', '8A2BE2', 20, 'Lavanda para serenidad y relajación.');

INSERT INTO hist_precios_unitarios (id_floristeria, cod_vbn, fecha_inicio, precio_unitario, fecha_fin, tamano_tallo) VALUES
(1, 20001, '2024-01-01', 3.50, '2024-03-01', 50.0),
(2, 20002, '2024-01-01', 2.80, '2024-03-01', 45.0),
(3, 20003, '2024-01-01', 4.50, '2024-03-01', 60.0),
(4, 20004, '2024-01-01', 2.00, '2024-03-01', 55.0),
(5, 20005, '2024-01-01', 3.20, '2024-03-01', 50.0),
(6, 20006, '2024-01-01', 5.00, '2024-03-01', 70.0),
(7, 20007, '2024-01-01', 1.80, '2024-03-01', 40.0),
(8, 20008, '2024-01-01', 1.50, '2024-03-01', 35.0),
(9, 20009, '2024-01-01', 2.70, '2024-03-01', 50.0),
(10, 20010, '2024-01-01', 4.00, '2024-03-01', 60.0),
(11, 20011, '2024-01-01', 3.80, '2024-03-01', 55.0),
(12, 20012, '2024-01-01', 5.20, '2024-03-01', 65.0),
(13, 20013, '2024-01-01', 2.50, '2024-03-01', 55.0),
(14, 20014, '2024-01-01', 3.00, '2024-03-01', 50.0),
(15, 20015, '2024-01-01', 3.50, '2024-03-01', 60.0),
(16, 20016, '2024-01-01', 2.80, '2024-03-01', 45.0),
(17, 20017, '2024-01-01', 3.00, '2024-03-01', 55.0),
(18, 20018, '2024-01-01', 4.20, '2024-03-01', 60.0),
(19, 20019, '2024-01-01', 3.80, '2024-03-01', 50.0),
(20, 20020, '2024-01-01', 5.00, '2024-03-01', 70.0);


INSERT INTO detalles_bouquets (id_floristeria, cod_vbn, cantidad, descripcion, tamano_tallo) VALUES
(1, 20001, 10, 'Rosas para ramos pequeños.', 50.0),
(2, 20002, 15, 'Tulipanes para centros de mesa.', 45.0),
(3, 20003, 12, 'Orquídeas para arreglos exóticos.', 60.0),
(4, 20004, 8, 'Claveles para decoraciones.', 55.0),
(5, 20005, 20, 'Lirios para ramos elegantes.', 50.0),
(6, 20006, 10, 'Hortensias para eventos.', 70.0),
(7, 20007, 25, 'Girasoles para jardines.', 40.0),
(8, 20008, 18, 'Margaritas para ramos.', 35.0),
(9, 20009, 14, 'Crisantemos para decoraciones.', 50.0),
(10, 20010, 12, 'Peonías para eventos especiales.', 60.0),
(11, 20011, 20, 'Dalias para ramos intensos.', 55.0),
(12, 20012, 10, 'Gardenias aromáticas.', 65.0),
(13, 20013, 15, 'Gladiolos robustos.', 55.0),
(14, 20014, 18, 'Iris para decoraciones mágicas.', 50.0),
(15, 20015, 10, 'Jacintos para regalos.', 60.0),
(16, 20016, 12, 'Cactus Navidad para festividades.', 45.0),
(17, 20017, 22, 'Rudbeckias coloridas.', 55.0),
(18, 20018, 8, 'Anémonas delicadas.', 60.0),
(19, 20019, 16, 'Amarilis resplandecientes.', 50.0),
(20, 20020, 20, 'Lavanda aromática.', 70.0);


INSERT INTO detalles_facturas_ventas (id_floristeria, id_factura_venta, id_detalle_factura_venta, cantidad, id_floristeria_cat, cod_vbn_cat, valor_cantidad, valor_precio, promedio) VALUES
(1, 1001, 1, 5, 1, 20001, 17.50, 3.50, 3.50),
(2, 1002, 2, 7, 2, 20002, 19.60, 2.80, 2.80),
(3, 1003, 3, 4, 3, 20003, 18.00, 4.50, 4.50),
(4, 1004, 4, 3, 4, 20004, 6.00, 2.00, 2.00),
(5, 1005, 5, 6, 5, 20005, 19.20, 3.20, 3.20),
(6, 1006, 6, 4, 6, 20006, 20.00, 5.00, 5.00),
(7, 1007, 7, 9, 7, 20007, 16.20, 1.80, 1.80),
(8, 1008, 8, 8, 8, 20008, 12.00, 1.50, 1.50),
(9, 1009, 9, 6, 9, 20009, 16.20, 2.70, 2.70),
(10, 1010, 10, 3, 10, 20010, 12.00, 4.00, 4.00),
(11, 1011, 11, 5, 11, 20011, 19.00, 3.80, 3.80),
(12, 1012, 12, 6, 12, 20012, 31.20, 5.20, 5.20),
(13, 1013, 13, 4, 13, 20013, 10.00, 2.50, 2.50),
(14, 1014, 14, 5, 14, 20014, 15.00, 3.00, 3.00),
(15, 1015, 15, 7, 15, 20015, 24.50, 3.50, 3.50),
(16, 1016, 16, 4, 16, 20016, 11.20, 2.80, 2.80),
(17, 1017, 17, 6, 17, 20017, 18.00, 3.00, 3.00),
(18, 1018, 18, 8, 18, 20018, 33.60, 4.20, 4.20),
(19, 1019, 19, 5, 19, 20019, 19.00, 3.80, 3.80),
(20, 1020, 20, 7, 20, 20020, 35.00, 5.00, 5.00);

INSERT INTO telefonos (prefijo, cod_area, numero, tipo, id_floristeria) VALUES
(58, 212, 5551234, 'Fijo', 1),
(58, 414, 2345678, 'Movil', 2),
(58, 412, 3456789, 'Movil', 3),
(58, 212, 1234567, 'Fijo', 4),
(58, 414, 9876543, 'Movil', 5),
(58, 416, 5432123, 'Movil', 6),
(58, 212, 9871234, 'Fijo', 7),
(58, 412, 6543219, 'Movil', 8),
(58, 416, 1112233, 'Movil', 9),
(58, 212, 2223344, 'Fijo', 10),
(58, 414, 3334455, 'Movil', 11),
(58, 212, 4445566, 'Fijo', 12),
(58, 412, 5556677, 'Movil', 13),
(58, 416, 6667788, 'Movil', 14),
(58, 212, 7778899, 'Fijo', 15),
(58, 414, 8889900, 'Movil', 16),
(58, 212, 9990011, 'Fijo', 17),
(58, 412, 1111122, 'Movil', 18),
(58, 416, 2222233, 'Movil', 19),
(58, 212, 3333344, 'Fijo', 20);

