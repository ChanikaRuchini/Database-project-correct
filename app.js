const express=require("express");
var appController=require('./controllers/appController');
var loginController=require('./controllers/log-inController');
var session		=	require('express-session');
var bodyParser  	= 	require('body-parser');
var cookieParser= require('cookie-parser');
var uuid=require('uuid/v1');
//var databaseController=require('./controllers/databaseController');
var app=express();

//set up template engine

app.set('view engine','ejs');


//set up session middleware

app.use(session({secret: 'malintha',saveUninitialized: true,resave: true}));
app.use(bodyParser.json());      
app.use(bodyParser.urlencoded({extended: true}));
app.use(cookieParser());
//static files

app.use(express.static('./public'));

//fire controllers
appController(app);
loginController(app);
//databaseController(app);
//databaseController(app);
//listen to port

app.listen(3000);
console.log('listning to port 3000');
