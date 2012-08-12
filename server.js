#!/usr/bin/env node

var fs = require('fs'),
   http = require('http'),
   util = require('util'),
   exec = require('child_process').exec;


exec('find images -type f').stdout.on('data', function(files) {
  var cats = files.split("\n");
  http.createServer( function(req, res) {
    var cat = cats [Math.floor(Math.random()*cats.length) ];  
    fs.readFile(cat, function(err, img) {
      res.writeHead(200, {'Content-Type':'image/gif'});
      res.end(img, 'binary');
    });
  }).listen(process.env.PORT || 8001, '0.0.0.0');
});



