#!/usr/bin/env node

var port = 9876;
var cdn = "http://moar.edgecats.net";

var fs = require('fs'),
  path = require('path'),
  ejs = require('ejs'),
  md = require('marked'),
  exec = require('child_process').exec,
  express = require('express');

var app = express();

exec('find cats -type f').stdout.on('data', function (files) {
  var cats = files.split("\n");

  app.set('views', __dirname + '/views');
  app.engine('html', ejs.renderFile);

  app.get('/netcat', function(req, res){
    res.render('netcat.html');
  });

  app.get('/favicon.ico', function(req, res) {
	  res.sendStatus(404);
  });

  app.get('/auto', function(req, res){
    res.render('auto.html');
  });

  app.get('/auto/full', function(req, res){
    res.render('auto_full.html');
  });

  app.get('/works', function(req, res){
    res.render('auto_works.html');
  });

  app.get('/meow', function(req, res){
    res.writeHead(200, {'Content-Type':'text/html'});
    res.write('<html><body>');
    var reloadcat = cats[Math.floor(Math.random()*cats.length)];
    res.write('<img src="' + cdn + '/' + reloadcat + '"/>');
    res.write('\n<!-- check out the source at github.com/flores/moarcats -->\n');
    res.write('</body></html>');
    res.end();
  });

  app.get('/help', function(req, res){
    var html = md(fs.readFileSync('README.md', 'utf8'));
    res.writeHead(200, {'Content-Type':'text/html'});
    res.write('<html><body>');
    res.write(html);
    res.write('</body></html>');
    res.end();
  });

  app.get('/all', function(req, res){
    res.writeHead(200, {'Content-Type':'text/html'});
    res.write('<html><body>');
    for (var i = 0; i < cats.length; i++) {
      res.write('<a href="' + cdn + '/' + cats[i] + '" target="_blank">' + cats[i] + '</a></br>\n');
    }
    res.write('</body></html>');
    res.end();
  });

  app.get('/all/show', function(req, res){
    res.writeHead(200, {'Content-Type':'text/html'});
    res.write('<html><body>');
    for (var i = 0; i < cats.length; i++) {
      res.write('<img src="' + cdn + '/' + cats[i] + '" alt="cat gifs!"/>\n');
    }
    res.write('</body></html>');
    res.end();
  });

  app.get('/all/count', function(req, res){
    res.send('There are ' + cats.length + ' total edgecat gifs');
  });

  app.get('/netcat/:image', function(req, res){
    var rootDirectory = 'views/';
    var filename = path.join(rootDirectory, req.params.image);
    if (filename.indexOf(rootDirectory) !== 0) {
      throw 'Directory traversal attack!';
    }
    fs.readFile(filename, function ( err, img ) {
      res.writeHead(200, {'Content-Type':'image/png'});
      res.end(img, 'binary');
    });
  });

  app.get('/cats/:cat', function(req, res){
    var rootDirectory = 'cats/';
    var filename = path.join(rootDirectory, req.params.cat);
    if (filename.indexOf(rootDirectory) !== 0) {
      throw 'Directory traversal attack!';
    }
    if (fs.existsSync(filename)) {
      fs.readFile(filename, function ( err, img ) {
	  res.writeHead(200, {
			'Content-Type':'image/gif',
			'Access-Control-Allow-Origin':'*',
	  });
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
      res.send(cdn + '/' + cat);
    }
    else {
      fs.readFile(cat, function ( err, img ) {
	  res.writeHead(200, {
			'Content-Type':'image/gif',
			'Access-Control-Allow-Origin':'*',
			'X-Cat-Link':cdn + '/' + cat,
	  });
        res.end(img, 'binary');
      });
    }
  });

});

app.listen(port);
console.log('here we go on port ' + port);
