# Cafe au Life

![Gosper's Glider Gun](http://raganwald.github.com/cafeaulife/docs/gospers_glider_gun.gif)

*(Gosper's Glider Gun. This was the first gun discovered, and proved that Life patterns can grow indefinitely.)*

Cafe au Life is an implementation of John Conway's [Game of Life][life] cellular automata written in [CoffeeScript][cs]. Cafe au Life runs on [Node.js][node], it is not designed to run as an interactive program in a browser window.

[life]: http://en.wikipedia.org/wiki/Conway's_Game_of_Life
[cs]: http://jashkenas.github.com/coffee-script/
[node]: http://nodejs.org

### Why should I care?

Cafe au Life implements Bill Gosper's [HashLife][hashlife] algorithm. HashLife exploits regularity, so for certain life patterns, it runs at super-linear speed. As [noted elsewhere][beautiful], if you set up Gosper's Glider Gun when the Earth was first formed 4.5 billion years ago, and ran one generation per second, in the 143.4 *quadrillion* seconds that have elapsed since then, the pattern would grow to 23,900,000,000,000,036 live cells. Cafe au Life takes just under two seconds to boot up, and another second to calculate the state of the pattern after 143.4 quadrillion generations.

If you haven't seen how the algorithm works, read the [annotated source code][source] and learn how the algorithm works.

[source]: http://recursiveuniver.se/docs/cafeaulife.html
[beautiful]: http://raganwald.posterous.com/a-beautiful-algorithm
[hashlife]: http://en.wikipedia.org/wiki/Hashlife

### How can I try it?

You can try Cafe au Life: Install CoffeeScript and node.js, clone the repository, then use the REPL from the command line:

```bash
raganwald@Reginald-Braithwaites-iMac[cafeaulife (master)⚡] coffee
coffee> Life = require('./lib/cafeaulife').set_universe_rules()
coffee> gun = require('./lib/menagerie').gospers_glider_gun
coffee> gun.future_at_time(143400000000000000).population
23900000000000036
coffee>
```

You can also play with a browser-based version at [raganwald.com/hashlife](http:raganwald.com/hashlife).

Have fun!


### Is it any good?

[Yes](http://news.ycombinator.com/item?id=3067434).

### Neat algorithm, but why does Conway's Game of Life matter?

One of the most important questions we ask ourselves is whether a non-trivial machine can be constructed that reproduces itself. If the answer is "no," then we can reason that for any machine, there must be a factory or creator outside of the machine. That goes for humans and all life. If the answer is "yes," then we can reason that it is not *necessary* for there to be a factory or creator for every machine, including ourselves.

[![The Recursive Universe](http://ws.assoc-amazon.com/widgets/q?_encoding=UTF8&Format=_SL160_&ASIN=0809252023&MarketPlace=US&ID=AsinImage&WS=1&tag=raganwald001-20&ServiceVersion=20070822)](http://www.amazon.com/gp/product/0809252023/ref=as_li_ss_il?ie=UTF8&tag=raganwald001-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=0809252023)

Cellular automata patterns are a kind of machine, with properties close enough to physical machines that it is very easy to reason by correspondence: If such-and-such is possible for a cellular automaton, it must be possible for a physical machine, therefore research into the capabilities of cellular automata is an important part of research into the capabilities of machines, including our bodies and our brains.

Life theorists have proven all sorts of things about what ought to be possible with Life patterns. Life experimenters have taken it to the next level and have built Universal Turing Machines, self-replicating machines, and all sorts of things that demonstrate the universality of Conway's game of Life. Implementations that can handle very large and/or very long-running Life patterns are an important tool for experimentation.

if you'd like to read more, the most approachable book on the subject is William Poundstone's brilliant [The Recursive Universe](http://www.amazon.com/gp/product/0809252023/ref=as_li_ss_il?ie=UTF8&tag=raganwald001-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=0809252023). Beg, borrow, or steal a copy, new or used. Get it in hardcover while you still can.

### What should I read next?

The [annotated source code][source].

### Who's responsible for this?

When he's not shipping Ruby, Javascript and Java applications scaling out to millions of users,
[Reg "Raganwald" Braithwaite](http://braythwayt.com) has authored libraries for Javascript and Ruby programming
such as [Katy](https://github.com/raganwald/Katy), [JQuery Combinators](http://github.com/raganwald/JQuery-Combinators),
[YouAreDaChef](https://github.com/raganwald/YouAreDaChef), [andand](http://github.com/raganwald/andand),
and more you can find on [Github](https://github.com/raganwald).

He has written a [popular programming blog](http://raganwald.com/ "Reginald Braithwaite"), as well as the books [CoffeeScript Ristretto](https://leanpub.com/coffeescript-ristretto), [JavaScript Allongé](https://leanpub.com/javascriptallongesix), and [others](https://leanpub.com/u/raganwald) on programming and programming languages.

---

**(c) 2012 [Reg Braithwaite](http://braythwayt.com)** ([@raganwald](http://twitter.com/raganwald))

Cafe au Life is freely distributable under the terms of the [MIT license](http://en.wikipedia.org/wiki/MIT_License).

The annotated source code was generated directly from the [original source][source] using [Docco][docco].

[source]: https://github.com/recursiveuniverse/recursiveuniverse.github.com/blob/master/lib
[docco]: http://jashkenas.github.com/docco/
