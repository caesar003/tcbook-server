const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');
const pool = require('./db.js');
const app = express();

const USERS = [
  {
    "id": 1,
    "name" : "John",
    "email" : "john@test.com",
  },
  {
    "id" : 2,
    "name" : "Jeff",
    "email" : "jeff@mail.com",
  }
];

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended:false}));

app.get('/', (req, res) => {
  res.send('hello');
});

app.get('/about', (req, res) => {
  res.send('about');
});

app.get('/users', (req, res) => {
  const query = `select * from users`;
  pool.query(query).then(data => res.json(data))
  .catch(err=>console.log(err));
})


app.listen(3045);
console.log('server is running on port 3045');

module.exports = app;
