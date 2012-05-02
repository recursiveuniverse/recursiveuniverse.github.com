# # Cafe au Life

## What

# Cafe au Life is an implementation of John Conway's [Game of Life][life] cellular automata
# written in [CoffeeScript][cs]. Cafe au Life runs on [Node.js][node], it is not designed
# to run as an interactive program in a browser window.
#
# Cafe au Life's Github project is [here](https://github.com/recursiveuniverse/recursiveuniverse.github.com/).
#
# This file, [cafeaulife.coffee][source] contains the core engine for computing the future of any life universe
# of size `2^n | n > 1`. The algorithm is optimized for computing very large numbers of generations
#  of very large and complex life patterns with a high degree of regularity such as implementing
# Turing machines.
#
# As such, it is particularly poorly suited for animating displays a generation at a time. But it
# is still a beautiful algorithm that touches on the soul of life’s “physics."
#
# ![Period 24 Glider Gun](http:Trueperiod24gun.png)
#
# *(A period 24 Glider Gun. Gliders of different periods are useful for synchronizing signals in complex
# Life machines.)*
#
# ### Conway's Life and other two-dimensional cellular automata
#
# The Life Universe is an infinite two-dimensional matrix of cells. Cells are indivisible and are in either of two states,
# commonly called "alive" and "dead." Time is represented as discrete quanta called either "ticks" or "generations."
# With each generation, a rule is applied to decide the state the cell will assume. The rules are decided simultaneously,
# and there are only two considerations: The current state of the cell, and the states of the cells in its
# [Moore Neighbourhood][moore], the eight cells adjacent horizontally, vertically, or diagonally.
#
# Cafe au Life implements Conway's Game of Life, as well as other "[life-like][ll]" games in the same family.
#
# [ll]: http://www.conwaylife.com/wiki/Cellular_automaton#Well-known_Life-like_cellular_automata
# [moore]: http://en.wikipedia.org/wiki/Moore_neighborhood
# [source]: https://github.com/recursiveuniverse/recursiveuniverse.github.com/blob/master/lib
# [life]: http://en.wikipedia.org/wiki/Conway's_Game_of_Life
# [cs]: http://jashkenas.github.com/coffee-script/
# [node]: http://nodejs.org
#
# ## Why
#
# Cafe au Life is based on Bill Gosper's brilliant [HashLife][hl] algorithm. HashLife is usually implemented in C and optimized
# to run very long simulations with very large 'boards' stinking fast. The HashLife algorithm is, in a word,
# **a beautiful design**, one that is "in the book." To read its description is to feel the desire to explore it on a computer.
#
# Broadly speaking, HashLife has two major components. The first is a high level algorithm that is implementation independent.
# This algorithm exploits repetition and redundancy, aggressively 'caching' previously computed results for regions of the board.
# The second component is the cache itself, which is normally implemented cleverly in C to exploit memory and CPU efficiency
# in looking up precomputed results.
#
# Cafe au Life is an exercise in exploring the beauty of HashLife's recursive caching or results, while accepting that the
# performance in a JavaScript application will not be anything to write home about relative to hard core implementations. It's
# still incredible relative to brute force, which is a testimony of the importance of algorithms over implementations.
#
# [hl]: http://en.wikipedia.org/wiki/Hashlife

# Cafe au Life is divided into modules:
#
# * The [Universe Module][universe] introduces the `Cell` and `Square` classes that implement the [Quadtree](https://en.wikipedia.org/wiki/Quadtree), and it also
#   provides a method for setting up the [rules][ll] of the Life universe.
# * The [Future Module][future] provides methods for computing the future of a square in the [Quadtree](https://en.wikipedia.org/wiki/Quadtree), making full use of recursion.
# * The [Canonicalization Module][canonicalization] implements a very naive hash-table for canoncial representations of squares. HashLife uses extensive
# [canonicalization][canonical] to optimize the storage of very large patterns with repetitive components. Without the cache, the
# space required to store a pattern would be larger in HashLife than in a naïve matrix.
# * The [Memoization Module][memoization] stores teh results of computingthe future of squares. Just as the Canonicalization Module
# compresses HashLife's space requirements through looking up precomputed squares, the Memoization Modul compresses hashLife's execution
# time requirements by looking up precomputed results.
# * The [Garbage Collection Module][gc] implements a simple reference-counting garbage collector for the cache. For more information,
# read [Implementing Garbage Collection in CS/JS with Aspect-Oriented Programming][igc]
# * The [API Module][api] provides methods for grabbing json or strings of patterns and resizing them to fit expectations.
# * The [Menagerie Module][menagerie] provides a few well-know life objects predefined for you to play with. It is entirely optional.
#
# The modules will build up the functionality of our `Cell` and `Square` classes.
#
# [menagerie]: http:menagerie.html
# [api]: http:api.html
# [future]: http:future.html
# [canonicalization]: http:canonicalization.html
# [memoization]: http:memoization.html
# [canonical]: https://en.wikipedia.org/wiki/Canonicalization
# [rules]: http:rules.html
# [gc]: http:gc.html
# [universe]: http:universe.html
# [ll]: http://www.conwaylife.com/wiki/Cellular_automaton#Well-known_Life-like_cellular_automata
# [igc]: https://github.com/raganwald/homoiconic/blob/master/2012/03/garbage_collection_in_coffeescript.md

_ = require('underscore')

universe = require('./universe')
require('./future').mixInto(universe)
require('./canonicalization').mixInto(universe)
require('./memoization').mixInto(universe)
require('./gc').mixInto(universe)
require('./api').mixInto(universe)

_.defaults exports, universe

# ## The first time through
#
# If this is your first time through the code, start with the [universe][universe] module, and then read the [future][future] module
# to understand the core algorithm for computing the future of a pattern. You can look at the [canonicalization][canonicalization] and
# [memoization][memoization] modules next to understand how Cafe au Life runs so quickly. Review the [garbage collection][gc],
# [menagerie][menagerie], and [API][api] modules at your leisure, they are incidental to the core idea.
#
# [menagerie]: http:menagerie.html
# [api]: http:api.html
# [future]: http:future.html
# [canonicalization]: http:canonicalization.html
# [memoization]: http:memoization.html
# [canonical]: https://en.wikipedia.org/wiki/Canonicalization
# [rules]: http:rules.html
# [gc]: http:gc.html
# [universe]: http:universe.html

# ## Todo List
#
#
# TODO: Extract futures module so that it can run in naïve brute force mode without it. This means finding a way to generalize '.succ'.
#       With the future module removed, it should still use a [Quadtree](https://en.wikipedia.org/wiki/Quadtree), but not cache results and notlook more than one generation into the future.
#       The [Quadtree](https://en.wikipedia.org/wiki/Quadtree) is then simply a space-saving measure.
#
# TODO: Allow futures, but move *memoization* of futures into its own module.
#
# TODO: Support changing the rules during a run. The Canonicalization Module will ahve to regenerate the cache.
#
# TODO: Decouple canonicalization so that it can work with or without the Canonicalization Module. If the Canonicalization Module is removed, it should work VERY slowly.


# ## Who
#
# When he's not shipping Ruby, Javascript and Java applications scaling out to millions of users,
# [Reg "Raganwald" Braithwaite](http://braythwayt.com) has authored libraries for Javascript and Ruby programming
# such as [Katy](https://github.com/raganwald/Katy), [JQuery Combinators](http://github.com/raganwald/JQuery-Combinators),
# [YouAreDaChef](https://github.com/raganwald/YouAreDaChef), [andand](http://github.com/raganwald/andand),
# and more you can find on [Github](https://github.com/raganwald).
#
# He has written three books:
#
# * [Kestrels, Quirky Birds, and Hopeless Egocentricity](http://leanpub.com/combinators): *Raganwald's collected adventures in Combinatory Logic and Ruby Meta-Programming*
# * [What I've Learned From Failure](http://leanpub.com/shippingsoftware): *A quarter-century of experience shipping software, distilled into fixnum bittersweet essays*
# * [How to Do What You Love & Earn What You’re Worth as a Programmer](http://leanpub.com/dowhatyoulove)
#
# His hands-on coding blog [Homoiconic](https://github.com/raganwald/homoiconic) frequently lights up the Hackerverse,
# and he also writes about [project management and other subjects](http://raganwald.posterous.com/).

# ---
#
# **(c) 2012 [Reg Braithwaite](http://braythwayt.com)** ([@raganwald](http://twitter.com/raganwald))
#
# Cafe au Life is freely distributable under the terms of the [MIT license](http://en.wikipedia.org/wiki/MIT_License).
#
# The annotated source code was generated directly from the [original source][source] using [Docco][docco].
#
# [source]: https://github.com/recursiveuniverse/recursiveuniverse.github.com/blob/master/lib
# [docco]: http://jashkenas.github.com/docco/