# [node catgifs](http://edgecats.net)

![example](http://edgecats.net)

cat gifs on demand for any occasion or project. Make any request for any resource for moar cats. No 5xx or 4xx's here: just cat gifs.

Use it anywhere you need a cat gif!  For example

```<img src='http://edgecats.net' alt='a random cat gif!'/>```

or something like this to click for new cat gifs

```
  <div id="catcontainer" onclick="moarcats();">
    <img src="http://edgecats.net" alt="random cat"/>
  </div>

  <script type="text/javascript">
    function moarcats() {
      var catcontainer = document.getElementById("catcontainer");
      catcontainer.innerHTML = '<img src="http://edgecats.net" alt="random cat"/>';
      return false;
    }
  </script>
```

Also allows cross origin requests.

# omg /netcat

try [netcat](http://edgecats.net/netcat) out!

drag him around!
type `moar cats` for an adorable cat!

# need a random link generator or a specific cat?

try [this](http://edgecats.net/random)

edgecats.net/cats/<whatever> is a static cacheable image.

# license

This is released under the Kitty License.  If you like this code, you should scratch your nearest cat.

Inspired by [placekitten](http://placekitten.com).
