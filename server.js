#!/usr/bin/env node

var fs = require('fs'),
  path = require('path'),
  ejs = require('ejs'),
  exec = require('child_process').exec,
  express = require('express');

exec('find cats -type f').stdout.on('data', function (files) {
  var cats = files.split("\n");
  var app = express();

  app.set('views', __dirname + '/views');
  app.engine('html', ejs.renderFile);

  app.get('/netcat', function(req, res){
    res.render('netcat.html');
  });
  
  app.get('/auto', function(req, res){
    res.render('auto.html');
  });
  
  app.get('/netcat/:image', function(req, res){
    fs.readFile('views/' + req.params.image, function ( err, img ) {
      res.writeHead(200, {'Content-Type':'image/png'});
      res.end(img, 'binary');
    });
  });
  
  app.get('/cats/:cat', function(req, res){
    if (path.existsSync('cats/' + req.params.cat)) {
      fs.readFile('cats/' + req.params.cat, function ( err, img ) {
        res.writeHead(200, {'Content-Type':'image/gif', 'Access-Control-Allow-Origin':'*'});
        res.end(img, 'binary');
      });
    }
    else {
      res.redirect('/');
    }
  });

  app.get('*', function(req, res){
    var cat = cats[Math.floor(Math.random()*cats.length)];  
    if (req.url == '/random') {
      res.send(req.header('host') + '/' + cat);
    }
    else {
      fs.readFile(cat, function ( err, img ) {
        res.writeHead(200, {'Content-Type':'image/gif', 'Access-Control-Allow-Origin':'*'});
        res.end(img, 'binary');
      });
    }
  });

  app.listen(8001);
});

