const {Client} = require('pg');

const client = new Client({
  host:"localhost",
  user:"postgres",
  port:5432,
  password:"mochi1234",
  database:"proyectobd"
})

module.exports = client

