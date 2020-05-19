const express = require('express');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt-nodejs');
const cors = require('cors');
const knex = require('knex');

const db = knex({
  client: 'pg',
  connection : {
    host : '127.0.0.1',
    user : 'me',
    password : '123abc',
    database : 'tcbook',
    port : '5432',
  }
});

const app = express();

app.use(bodyParser.json());
app.use(cors());

app.get('/', (req, res) => {
  res.send('this is working');
});

app.post('/signin', (req, res) => {
  db.select('email', 'hash').from('login')
    .where('email', '=', req.body.email)
    .then(data => {
      const isValid = bcrypt.compareSync(req.body.password, data[0].hash);
      if(isValid){
        return db.select('*').from('users')
          .where('email', '=', req.body.email)
          .then(user => {
            res.json(user[0]);
          })
          .catch(err => res.status(400).json('400'))
      } else {
        res.status(400).json('400');
      }
    })
    .catch(err => res.status(400).json('400'))
})

app.post('/register', (req, res) => {
  const {email, name, password, batch} = req.body;
  const hash = bcrypt.hashSync(password);
  db.transaction(trx => {
    trx.insert({
      email: email,
      name: name,
      hash: hash,
    })
     .into('login')
     .returning('email')
     .then(loginEmail => {
       return trx('users')
         .returning('*')
         .insert({
           email: loginEmail[0],
           username: name,
           tcbatch: batch
         })
         .then(user => {
           res.json('Success')
         })
     })
     .then(trx.commit)
     .catch(trx.rollback)
  })
    .catch(err => res.status(400).json('error'))
});

app.post('/post', (req, res) => {
  const {post, user_id} = req.body;
  return db('posts').insert({
    post: post,
    post_date: new Date(),
    user_id: user_id,
  }).then(response => {
    res.json(response);
  });
});

app.get('/post', (req, res)=>{
  return db.select('*').from('posts').then(users=>{
    res.json(users);
  })
});

/*
  --> to dos endpoints
      GET /allmembers
      GET /comments
      POST /comment
      PUT /userprofile

*/

app.get('/profile/:id', (req, res) => {
  const {id} = req.params;
  db.select('*').from('users')
    .where({id})
    .then(user => {
      if(user.length){
        res.json(user[0]);
      } else {
        res.status(404).json('not found');
      }
  })
    .catch(err => res.status(404).json('not found'));
});

// bcrypt.compare('bacon', hash, function(err, res){
//   //
// })
//
// bcrypt.compare('veggies', hash, function(err, res){
//   //
// })

app.listen(3027, ()=> {
  console.log('app is running on port 3027');
});
