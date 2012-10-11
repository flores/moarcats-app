var fs = require('fs'),
  path = require('path'),
  exec = require('child_process').exec,
  app = require('express').createServer();

exec('find cats -type f').stdout.on('data', function (files) {
  var cats = files.split("\n");
  
  app.get('/netcat', function(req, res){
    res.render('netcat.html');
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

