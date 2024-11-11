const client = require('./database.js');
const express = require('express');
const path = require('path');
const app = express();
const bodyParser = require("body-parser");

app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));

app.listen(3303, () => {
    console.log("Server is now listening at port 3303");
});

client.connect(err => {
    if (err) {
        console.error('Error en la conexión a la base de datos', err.stack);
    } else {
        console.log('Base de datos conectada exitosamente');
    }
});

app.get('/Paises', (req, res) => {
    client.query('SELECT * FROM Paises', (err, result) => {
        if (err) {
            console.error('Error ejecutando query', err.stack); 
            es.status(500).send('Error en la consulta a la base de datos');
        } else {
            res.status(200).json(result.rows);
        }
    });
});

app.post('/Paises', (req, res) => {
    const { id_pais, nombre_pais } = req.body;
    client.query('INSERT INTO Paises (id_pais, nombre_pais) VALUES ($1, $2)', [id_pais, nombre_pais], (err, result) => {
        if (err) {
            console.error('Error ejecutando query', err.stack);
            res.status(500).send('Error al insertar datos en la base de datos');
        } else {
            res.status(201).send('País añadido exitosamente');
        }
    });
});

app.get('/Paises/:id', (req, res) => {

    client.query(`Select * from Paises where id_pais=${req.params.id}`, (err, result)=>{
        if (err) {
            console.error('Error ejecutando query', err.stack);
            res.status(500).send('Error en la consulta a la base de datos');
        } else {
            res.status(200).json(result.rows);
        }
    });
});

app.get('/Flores', async (req, res) => {
    try {
        const floresQuery = await client.query('SELECT f.id_flor, f.nombre_flor, f.vbn, f.temperatura_corte, g.nombre_genero FROM Flores f JOIN Generos_Flores g ON f.id_genero = g.id_genero');
        res.json(floresQuery.rows);
    } catch (error) {
        console.error(error); res.status(500).send('Error al obtener los datos');
    }
});

app.get('/GenerosFlores', (req, res) => {
    client.query('SELECT * FROM Generos_Flores', (err, result) => {
        if (err) {
            console.error('Error ejecutando query', err.stack); 
            es.status(500).send('Error en la consulta a la base de datos');
        } else {
            res.status(200).json(result.rows);
        }
    });
});


process.on('SIGINT', () => {
    client.end(err => {
        if (err) {
            console.error('Error cerrando conexión a base de datos', err.stack);
        } process.exit();
    });
});