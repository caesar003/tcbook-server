const express = require('express');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt-nodejs');
const cors = require('cors');
const knex = require('knex');
const multer = require('multer');
const fs = require('fs');
const url = require('url');
const login = require('./controllers/login');
const register = require('./controllers/register');
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

// SIGNIN
app.post('/signin', (req, res) => {login.handleLogin(req, res, db, bcrypt)});

// REGISTRATION
app.post('/register', (req, res) => {register.handleRegistration(req, res, db, bcrypt)});

// SUBMIT FEED
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


// GET FEED
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

app.get('/users/:id', (req, res) => {
  const id = req.params.id;
  console.log(id);
  return db.select('*').from('users').where('id', '!=', id).then(users => {res.json(users)});
  // return db.select('*').from('users').then(users=>{
  //   res.json(users);
  // })
});

app.post('/profile-picture', (req, res) => {
  upload(req, res, (err)=>{
    if(err instanceof multer.MulterError){
      return res.status(500).json(err);
    } else if(err){
      return res.status(500).json(err);
    }
    return res.status(200).send(req.file.filename);
  });
});

app.get('/picture/:img', (req, res) => {
  fs.readFile('./public/'+req.params.img, (err, content) => {
    if(err){
      // res.writeHead(404, {'Content-Type': 'text/html'});
      console.log(err);
      // res.end('Image not found');
      fs.readFile('./public/no-image.jpg', (err, content)=>{
        res.end(content);
      })
    } else {
      res.writeHead(200, {'Content-Type': 'image/jpg'});
      res.end(content);
    }
  })
});

// UPDATE PROFILE DETAIL
app.put('/profile-detail', (req, res) => {
  const {id, name, tcbatch, origin, dob, completename} = req.body;
  console.log(req);
  //res.writeHead(200, {'Content-Type': 'text/html'});
  db('users')
    .where('id', '=', id)
    .update({
      username:name,
      tcbatch:tcbatch,
      origin:origin,
      dob :dob,
      completename: completename,
    }).returning('users')
    .then(users=>{
      res.json(users);
    })
  // res.json('request received');
});


// UPDATE 'about me'
app.put('/about', (req, res) => {
  const {id, about} = req.body;
  db('users')
  .where('id', '=', id)
  .update({
    about: about
  }).returning('users')
  .then(users => {
    res.status(200).json(users);
  })
  .catch(err=>res.status(400).json('there\'s something wrong'))
});

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

/*app.get('/message/:sender/:receiver', (req, res) => {
  // console.log(req.params);
  const {sender, receiver} = req.params;
  db.select('*').from('chat')
  .where('sender', '=', sender)
  .where('receiver', '=', receiver)
  .then(messages => {
    res.json(messages);
  }).catch(err => res.status(404).json('not found'))
  // res.status(200).json('request accepted');
}); */

app.get('/message/:identifier', (req, res) => {
  const {identifier} = req.params;
  db.select('*')
  .from('chat')
  .where('identifier', '=', identifier)
  .then(messages => {
    res.json(messages);
  }).catch(err => res.status(404).json('There is something wrong!'));
});

app.post('/chat', (req, res) => {
  const {sender, receiver, message, identifier} = req.body;
  db.select('*')
  .from('conversationlist')
  .where('identifier', '=', identifier)
  .then(data=>{
    if(data.length){
      db('conversationlist')
      .update({
        sender: sender,
        receiver: receiver,
        last_message: message,
      }).where('identifier', '=', identifier);
    } else {
      db.insert({
        sender: sender,
        receiver: receiver,
        identifier: identifier,
        last_message: message,
      }).into('conversationlist');
    }
  });
  db.insert({
    sender: sender,
    receiver: receiver,
    identifier: identifier,
    message: message,
  }).into('chat')
  .returning('*')
  .then(data => {
    res.json(data);
  }).catch(err => console.log(err));
});

app.get('/conversationlist/:identifier', (req, res) => {
  const {identifier} = req.params;
  db.select('*')
  .from('conversationlist')
  .where('identifier', '=', identifier)
  .then(data => {
    if(data.length){
      console.log('it exists');
    } else {
      console.log('data doesn\'t exists!');
    }
    console.log(data);
    res.json(data);
  }).catch(err => console.log(err));
})

app.post('/message', (req, res) => {
  const {sender, receiver, message, identifier} = req.body;
  db.insert({
    sender: sender,
    receiver: receiver,
    identifier: identifier,
    message: message,
  }).into('chat')
  .returning('*')
  .then(data => res.json(data))
  .catch(err => console.log(err))
});

app.listen(3027, ()=> {
  console.log('app is running on port 3027');
});


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

/*
insert into conversationlist (identifier, sender, receiver, last_message) values
  ('u7u10', 10, 7, 'fine thanks')
  on conflict on constraint conversationlist_identifier_key
  do update set sender = 10, receiver = 7, last_message = 'fine thanks';

*/
