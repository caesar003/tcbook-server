const express = require('express');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt-nodejs');
const cors = require('cors');
const knex = require('knex');
const multer = require('multer');
const fs = require('fs');
const url = require('url');
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

const storage = multer.diskStorage({
  destination : (req, file, cb) => {
    cb(null, 'public')
  },
  filename : (req, file, cb) => {
    cb(null, file.originalname);
  }
  // filename : (req, file, cb) => {
  //   cb(null, Date.now() + '-' + file.originalname);
  // }
  //
});

const upload = multer({
  storage:storage
}).single('file');

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
  const {post, user_id, attachment} = req.body;
  return db('posts').insert({
    post: post,
    post_date: new Date(),
    user_id: user_id,
    atch: attachment,
  }).then(response => {
    res.json(response);
  });
});

app.get('/post', (req, res)=>{
  return db.select('*')
    .from('posts')
    .orderBy('post_date', 'desc')
    .then(users=>{
      res.json(users);
  })
});

app.get('/users', (req, res) => {
  return db.select('*').from('users').then(users=>{
    res.json(users);
  })
});

app.post('/postMedia', (req, res) => {
  // console.log(req);
  // return res.status(200).json('Ok');
  upload(req, res, (err)=>{
    if(err instanceof multer.MulterError){
      return res.status(500).json(err);
    } else if(err){
      return res.status(500).json(err);
    }
    // console.log(req.file.filename);
    return res.status(200).send(req.file.filename);
  });
});

app.get('/picture/:img', (req, res) => {
  fs.readFile('./public/'+req.params.img, (err, content) => {
    if(err){
      res.writeHead(404, {'Content-Type': 'text/html'});
      console.log(err);
      res.end('Image not found');
    } else {
      res.writeHead(200, {'Content-Type': 'image/jpg'});
      res.end(content);
    }
  })
});

// app.put('/userprofile', (req, res) => {
//   // const {} = req.body;
//   db('users')
//   .where('', '=', '')
//   .update({
//     key:'value',
//     key2: 'value'
//   })
//   .returning('users')
//   .then(users=>{
//     res.json(users);
//   });
// })

// app.get('/video/:clip', (req, res) => {
//
// })

// app.get('/user', (req, res) => {
//   db.select('*').from('users').where('')
// })

/*
  --> to dos endpoints
      GET /allmembers
      GET /comments
      POST /comment
      PUT /userprofile
      POST /profile_picture
      GET /picture
      POST /profile-update
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

app.listen(3027, ()=> {
  console.log('app is running on port 3027');
});
