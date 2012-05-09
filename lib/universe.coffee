# This module is part of [resursiveuniver.se](http://recursiveuniver.se).
#
# ## Universe Module
#
# The Universe Module provides the basic `Cell` and `Square` classes needed to
# represent the Life universe as a [Quadtree](https://en.wikipedia.org/wiki/Quadtree). Every other module depends on
# universe.coffee.

# ### The Life "Universe"

# ### Baseline Setup
_ = require('underscore')
exports ?= window or this

# Cafe au Life is based on two very simple classes:
#
# The smallest unit of Life is the `Cell`. The constructor is set up to call an `initialize` method to make point-cuts slightly easier.

class Cell
  constructor: (@value) ->
    @level = 0
    @initialize.apply(this, arguments)
  initialize: ->

_.defaults Cell,
  Alive: new Cell(1)
  Dead:  new Cell(0)

# HashLife operates on square regions of the board, with the length of the side of each square being a natural power of two
# (`2^1 -> 2`, `2^2 -> 4`, `2^3 -> 8`...). Naturally, squares are represented by instances of the class `Square`. The smallest possible square
# (of size `2^1`) has cells for each of its four quadrants, while all larger squares (of size `2^n`) have squares of one smaller
# size (`2^(n-1)`) for each of their four quadrants.
#
# For example, a square of size eight (`2^3`) is composed of four squares of size four (`2^2`):
#
#     nw         ne
#       ....|....
#       ....|....
#       ....|....
#       ....|....
#       ————#————
#       ....|....
#       ....|....
#       ....|....
#       ....|....
#     sw         se
#
# The squares of size four are in turn each composed of four squares of size two (`2^1`):
#
#     nw           ne
#       ..|..|..|..
#       ..|..|..|..
#       ——+——|——+——
#       ..|..|..|..
#       ..|..|..|..
#       —————#—————
#       ..|..|..|..
#       ..|..|..|..
#       ——+——|——+——
#       ..|..|..|..
#       ..|..|..|..
#     sw           se
#
# And those in turn are each composed of four cells, which cannot be subdivided. (For simplicity, a Cafe au Life
# board is represented as one such large square, although the HashLife algorithm can be used to handle any board shape by tiling it with squares.)
#
# As noted above, this data structure is a [Quadtree](https://en.wikipedia.org/wiki/Quadtree).

class Square
  constructor: ({@nw, @ne, @se, @sw}) ->
    @level = @nw.level + 1
    @initialize.apply(this, arguments)
  initialize: ->
  @for: (quadrants, creator = Square) ->
    new creator(quadrants)

_.defaults exports, {Cell, Square}

# ## The first time through
#
# Now that you've finished the [Universe Module][universe], read the [Future Module][future]
# next to understand the core algorithm for computing the future of a pattern. Then move on to the [canonicalization][canonicalization] and
# [memoization][memoization] modules to understand how Cafe au Life runs so quickly. Review the [garbage collection][gc],
# [menagerie][menagerie], and [API][api] modules at your leisure, they are incidental to the core idea.
#
# [menagerie]: http:menagerie.html
# [api]: http:api.html
# [future]: http:future.html
# [canonicalization]: http:canonicalization.html
# [canonical]: https://en.wikipedia.org/wiki/Canonicalization
# [rules]: http:rules.html
# [gc]: http:gc.html
# [universe]: http:universe.html

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