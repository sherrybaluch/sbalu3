'use strict';

//HTTPS
const fs = require('fs');
const https = require('https');
const privateKey  = fs.readFileSync('/etc/ssl/private/server_key.key', 'utf8');
const certificate = fs.readFileSync('/etc/ssl/private/server_cert.cer', 'utf8');
const credentials = {key: privateKey, cert: certificate};

const express = require('express');
const app = express();

const bodyParser = require('body-parser');
const NodeCouchDb = require('node-couchdb');
const path = require('path');
const { check, validationResult } = require('express-validator/check');

// Global Vars
app.use(function(req, res, next){
		res.locals.errors = null;
		next();
		});

//support parsing of application/json type post data
app.use(bodyParser.json());

//support parsing of application/x-www-form-urlencoded post data
app.use(bodyParser.urlencoded({ extended: true }));

const methodOverride = require('method-override');
app.use(methodOverride('_method', { methods: ['POST', 'GET'] }));
app.use(methodOverride(function (req, res) {
			if (req.body && typeof req.body === 'object' && '_method' in req.body) {
			// look in urlencoded POST bodies and delete it
			var method = req.body._method
			delete req.body._method
			return method
			}
			}))

// View Engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

//LOGS
var morgan = require('morgan');
app.use(morgan('combined'));
var winston = require('./config/winston');
app.use(morgan('combined', { stream: winston.stream }));

// Connect to CouchDB on VM
const couchExternal = new NodeCouchDb({
    host: '10.92.128.68',
    port: 5984, 
    auth: {
	   user: 'admin',
           password: 'p@ssw0rd'
          }
});

// List all databases to console to test connectivity
couchExternal.listDatabases().then(function(dbs){
	console.log(dbs);
});

//database name
const dbName = 'restaurants';
//all is the name of the MapReduce views
const viewUrl =  '_design/docs/_view/all';

//WEB ROUTES
//INDEX root website/SHOW
app.get('/', function(req, res){
	couchExternal.get(dbName, viewUrl).then(
		function(data, headers, status){
			res.render('index', {restaurant:{},restaurants:data.data.rows});
		},
		function(err){res.send(err);}
	);
});

//STORE Restaurant
app.post('/restaurant/add', function(req, res){

	let errors_arr = [];

	// Get each incoming variable from the post body
	let name = req.body.name.trim();
	let phone_number = req.body.phonenumber.trim();
	let food_type = req.body.food_type.trim();
	let website = req.body.website.trim();

	let new_doc = {
		"_id": name.replace(/ /g,"_"),
		"name": name,
		"food_type": food_type,
		"phonenumber": phone_number,
		"website": website
	}

	// Validate them....
	// name and website cannot have a length of 0
	if (name.length == 0) errors_arr.push({msg:"Name is required."});
	if (website.length == 0) errors_arr.push({msg:"Website is required."});
	// If validation fails, set error messages
	// Set viewUrl to ????
	if (errors_arr.length != 0) {
		couchExternal.get(dbName, viewUrl).then(
			function(data, headers, status){
				res.render('index', {restaurant:new_doc,restaurants:data.data.rows,errors:errors_arr});
			},
			function(err){res.send(err);}
		);
	} else{

		couchExternal.insert(dbName, new_doc).then(
			function(data, headers, status){
				res.redirect('/');
			},
			function(err){
				res.send(err);
				//return;
			}
		)
	}
});
//EDIT Restaurant
app.get('/restaurant/edit/:_id', function(req, res){

	// look up restaurant info by id
	let _id = req.params._id;
	couchExternal.get(dbName, _id).then(
		function(data, headers, status){
			res.render('edit', {restaurant:data.data});
		},
		function(err){
			res.send(err);
		}
	)
	// pass that to the edit.ejs template
	// something like...
	//     	res.render('edit', {restaurant:data,errors:errors_arr});


});


//UPDATE Restaurant
app.post('/restaurant/update/', function(req, res){
	let errors_arr = [];

	// Get each incoming variable from the post body
	let json_obj = {
		name: req.body.name.trim(),
		phonenumber: req.body.phonenumber.trim(),
		food_type: req.body.food_type.trim(),
		website: req.body.website.trim(),
		_id: req.body.id,
		_rev: req.body.rev
	}

	// Validate them....
	// name and website cannot have a length of 0
	if (json_obj.name.length == 0) errors_arr.push({msg:"Name is required."});
	if (json_obj.website.length == 0) errors_arr.push({msg:"Website is required."});
	// If validation fails, set error messages
	// Set viewUrl to ????
	if (errors_arr.length != 0) {
		res.rend('edit',{restaurant:json_obj,errors:errors_arr});
		// couchExternal.get(dbName, viewUrl).then(
		// 	function(data, headers, status){
		// 		res.render('index', {restaurants:data.data.rows,errors:errors_arr});
		// 	},
		// 	function(err){res.send(err);}
		// );
	} else{

		couchExternal.update(dbName, json_obj).then(
			function(data, headers, status){
				res.redirect('/');
			},
			function(err){
				res.send(err);
				//return;
			}
		)
	}
});

//DESTROY Restaurant

app.delete('/restaurant/delete/:_id', function(req, res){
	let _id = req.params._id;
	let _rev = req.body.rev;
	//res.send(_id + "<br>" + _rev);
	couchExternal.del(dbName, _id,_rev).then(
		function(data, headers, status){
			res.redirect('/');
		},
		function(err){
			res.send(err);
			//return;
		}
	);
});

app.get('/test', function(req,res) {
	res.send("TEST IS WORKING");
});

//HTTPS Server
const httpsServer = https.createServer(credentials, app);
httpsServer.listen(8443);
console.log('Running on port 8443...');
