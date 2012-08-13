# [node catgifs](http://lo.no.de)

![example](http://lo.no.de)

cat gifs on demand for any occasion or project. Make any request for any resource for moar cats. No 5xx or 4xx's here: just cat gifs.

Use it anywhere you need a cat gif.  For example:

```<img src='http://lo.no.de' alt='a random cat gif!'/>```

or

```
  <div id="catcontainer" onclick="moarcats();">
    <img src="http://lo.no.de" alt="random cat"/>
  </div>

  <script type="text/javascript">
    function moarcats() {
      var catcontainer = document.getElementById("catcontainer");
      cat.innerHTML = '<img src="http://lo.no.de" alt="random cat"/>';
      return false;
    }
  </script>
```

Also allows cross origin requests, nerd.

Inspired by [placekitten](http://placekitten.com).
