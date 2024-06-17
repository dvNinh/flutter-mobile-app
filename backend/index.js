const express = require('express')
const app = express()
const port = 3000

app.use(express.urlencoded({
    extended: true,
}));
app.use(express.json());

const session = require('express-session');
app.use(session({
    secret: 'keyboard cat',
    resave: true,
    saveUninitialized: true,
}));

const router = require('./route.js');
app.use(router);

const db = require('./config/db');
db.connect();

app.post('/', (req, res) => {
    console.log(req.body);
    res.status(201).json({success: true});
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})