const client = require('./database.js');
const express = require('express');
const path = require('path');
const app = express();
const bodyParser = require("body-parser");

app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));

app.listen(3300, () => {
    console.log("Server abierto en el puerto 3300");
});

client.connect(err => {
    if (err) {
        console.error('Error en la conexión a la base de datos', err.stack);
    } else {
        console.log('Base de datos conectada exitosamente');
    }
});


    // Endpoint para obtener todos los productores
    app.get('/Productores', async (req, res) => {
        try {
            const result = await client.query(`
                SELECT p.id_productor, p.nombre, p.sitio_web, p.email, paises.nombre AS pais_nombre
                FROM Productores p
                JOIN Paises ON p.id_pais = paises.id_pais
                ORDER BY id_productor ASC;
            `);
            res.status(200).json(result.rows);
        } catch (err) {
            console.error('Error ejecutando query', err.stack);
            res.status(500).send('Error en la consulta a la base de datos');
        }
    });

    // Endpoint para obtener los detalles de un productor específico
    app.get('/Productores/:id', async (req, res) => {
        const id_productor = req.params.id;
        try {
            const result = await client.query('SELECT nombre FROM Productores WHERE id_productor = $1', [id_productor]);
            if (result.rows.length === 0) {
                return res.status(404).send('Productor no encontrado');
            }
            res.status(200).json(result.rows[0]);
        } catch (err) {
            console.error('Error obteniendo productor', err.stack);
            res.status(500).send('Error en la consulta');
        }
    });



    // Endpoint para obtener los detalles de un productor específico
    app.get('/Floristerias/:id', async (req, res) => {
      const id_floristeria = req.params.id;
      try {
          const result = await client.query('SELECT nombre FROM Floristerias WHERE id_floristeria = $1', [id_floristeria]);
          if (result.rows.length === 0) {
              return res.status(404).send('Floristeria no encontrada');
          }
          res.status(200).json(result.rows[0]);
      } catch (err) {
          console.error('Error obteniendo floristeria', err.stack);
          res.status(500).send('Error en la consulta');
      }
  });

  
    // Endpoint para obtener todos las floristerias
    app.get('/Floristerias', async (req, res) => {
      try {
          const result = await client.query(`
              SELECT f.id_floristeria, f.nombre, f.email, paises.nombre AS pais_nombre
              FROM Floristerias f
              JOIN Paises ON f.id_pais = paises.id_pais
          `);
          res.status(200).json(result.rows);
      } catch (err) {
          console.error('Error ejecutando query', err.stack);
          res.status(500).send('Error en la consulta a la base de datos');
      }
  });
 
  
  // Endpoint para obtener los catálogos de un productor específico
  app.get('/Catalogos', async (req, res) => {
    const { id_productor } = req.query;
    if (!id_productor) {
      return res.status(400).send('id_productor es requerido');
    }
    try {
      const result = await client.query(`
        SELECT c.cod_vbn, c.nombre AS nombre_catalogo, c.descripcion
        FROM catalogos_productores c
        WHERE c.id_productor = $1
      `, [id_productor]);
      console.log(result.rows); // Verifica los datos devueltos
      res.status(200).json(result.rows);
    } catch (err) {
      console.error('Error ejecutando query', err.stack);
      res.status(500).send('Error en la consulta a la base de datos');
    }
  });


  // Endpoint para obtener los catálogos de una floristeria especifica
  app.get('/CatalogosFloristerias', async (req, res) => {
    const { id_floristeria } = req.query;
    if (!id_floristeria) {
      return res.status(400).send('id_floristeria es requerido');
    }
    try {
      const result = await client.query(`
        SELECT c.cod_vbn, c.nombre AS nombre_catalogo, c.descripcion, c.cod_hex, colores_flores.nombre AS nombre_color
        FROM catalogos_floristerias c
		    JOIN Colores_flores ON c.cod_hex = colores_flores.cod_hex
		    WHERE c.id_floristeria = $1
        ORDER BY c.nombre ASC;
      `, [id_floristeria]);
      console.log(result.rows); // Verifica los datos devueltos
      res.status(200).json(result.rows);
    } catch (err) {
      console.error('Error ejecutando query', err.stack);
      res.status(500).send('Error en la consulta a la base de datos');
    }
  });


  app.get('/Flores', async (req, res) => {
    try {
        const result = await client.query(`
            SELECT id_flor_corte, nombre_comun
            FROM flores_cortes
            `);
            console.log(result.rows);
            res.status(200).json(result.rows);
        } catch (err) {
            console.error('Error ejecutando query', err.stack);
            res.status(500).send('Error en la consulta a la base de datos');
        }
    });  



    app.get('/Colores', async (req, res) => {
      try {
          const result = await client.query(`
              SELECT cod_hex, nombre
              FROM colores_flores
              `);
              console.log(result.rows);
              res.status(200).json(result.rows);
          } catch (err) {
              console.error('Error ejecutando query', err.stack);
              res.status(500).send('Error en la consulta a la base de datos');
          }
      }); 



    app.get('/PromedioCatalogo', async (req, res) => {
      const { id_floristeria, cod_vbn } = req.query;
      if (!id_floristeria || !cod_vbn) {
          return res.status(400).send('id_floristeria y cod_vbn son requeridos');
      }
  
      try {
          const result = await client.query('SELECT calcular_promedio($1, $2) AS promedio', [id_floristeria, cod_vbn]);
          if (result.rows.length === 0) {
              return res.status(404).send('No se encontró el promedio para el catálogo');
          }
          res.status(200).json(result.rows[0]);
      } catch (err) {
          console.error('Error obteniendo el promedio', err.stack);
          res.status(500).send('Error en la consulta');
      }
  });
  

  
  // Endpoint para agregar una nueva flor
  app.post('/Flores', async (req, res) => {
    const { nombre_comun, etimologia, genero_especie, colores, temperatura } = req.body;
    if (!nombre_comun || !etimologia || !genero_especie || !colores || !temperatura) {
      return res.status(400).send('Todos los campos son obligatorios');
    }
    try {
      const result = await client.query(`
        INSERT INTO flores_cortes (nombre_comun, etimologia, genero_especie, colores, temperatura)
        VALUES ($1, $2, $3, $4, $5)
        RETURNING id_flor_corte
      `, [nombre_comun, etimologia, genero_especie, colores, temperatura]);
      console.log(result.rows[0]); // Verifica el nuevo registro
      res.status(201).json(result.rows[0]);
    } catch (err) {
      console.error('Error agregando flor', err.stack);
      res.status(500).send('Error en la inserción de la flor');
    }
  });
  
  // Endpoint para agregar un nuevo catálogo
  app.post('/Catalogos', async (req, res) => {
    const { id_productor, nombre, cod_vbn, id_flor_corte, descripcion } = req.body;
    if (!id_productor || !nombre || !cod_vbn || !id_flor_corte) {
      return res.status(400).send('Todos los campos son obligatorios');
    }
    try {
      const result = await client.query(`
        INSERT INTO catalogos_productores (id_productor, cod_vbn, nombre, id_flor_corte, descripcion)
        VALUES ($1, $2, $3, $4, $5)
        RETURNING cod_vbn
      `, [id_productor, cod_vbn, nombre, id_flor_corte, descripcion]);
      console.log(result.rows[0]); // Verifica el nuevo registro
      res.status(201).json(result.rows[0]);
    } catch (err) {
      console.error('Error agregando catálogo', err.stack);
      res.status(500).send('Error en la inserción del catálogo');
    }
  });
  



process.on('SIGINT', () => {
    client.end(err => {
        if (err) {
            console.error('Error cerrando conexión a base de datos', err.stack);
        } process.exit();
    });
});