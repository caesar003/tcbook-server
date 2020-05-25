const handleRegistration = (req, res, db, bcrypt) => {
  const {email, name, password, batch} = req.body;
  const hash = bcrypt.hashSync(password);
  db.transaction(trx => {
    // 1 insert into login table
    trx.insert({
      email: email,
      name: name,
      hash: hash,
    })
     .into('login')
     // take the email back
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
}

module.exports = {handleRegistration};
