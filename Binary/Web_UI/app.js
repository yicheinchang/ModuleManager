/**
 * Module dependencies.
 */

var express = require('express');
var routes = require('./routes');
var http = require('http');
var path = require('path');
var fs=require('fs');


// routes
var serviceManager=require('./routes/serviceManager.js');

// create log file
//var logFile = fs.createWriteStream('./LogFile.log', {flags: 'a'});

// load LICENSE
var license='';
fs.readFile('../LICENSE.txt', 'utf8', function(err, data) {
  if (err) {
    throw err;
  }else{
    license=data;
  }
});

var app = express();

// all environments
app.set('port', process.env.PORT || 6812);
app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
//app.use(express.logger({stream: logFile}));
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.urlencoded());
//app.use(express.methodOverride());
app.use(express.cookieParser('asdf$#@!1234'));
app.use(express.session());
app.use(app.router);
app.use(require('stylus').middleware(__dirname + '/public'));
app.use(express.static(path.join(__dirname, 'public')));

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}

//Add login 
app.use(function(req, res, next){
  res.locals.login=req.session.login;
  next();
});

app.post('/', routes.index);
app.get('/', routes.index);
app.get('/about', function(req, res){
  res.render('about', {title: 'About', license: license})
});
app.post('/ServiceManage', function(req, res){
  if(req.session.login != 'true'){
    console.log('Not a validate user');
    res.send('Please Login');
  }else{
    serviceManager.action(req, res);
  }
});

app.get('/logout', function(req, res){
  if(req.session){
    req.session.destroy();
  }
  routes.index(req, res);
});

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
