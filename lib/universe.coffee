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

# ### Setting the rules for this game's "Universe"
#
# There many possible games consisting of cellular automata arranged in a two-dimensional
# matrix. Cafe au Life handles the "[life-like][ll]" ones, roughly those that have:
#
# [ll]: http://www.conwaylife.com/wiki/Cellular_automaton#Well-known_Life-like_cellular_automata
#
# * A stable 'quiescent' state. A universe full of empty cells will stay empty.
# * Rules based only on the population of a cell's Moore Neighborhood: Every cell is affected by the population of its eight neighbours,
#   and all eight neighbours are treated identically.
# * Two states.
#
# Given a definition of the state machine for each cell, Cafe au Life performs all the necessary initialization to compute
# the future of a pattern.
#
# The default, `set_universe_rules()`, is equivalent to `set_universe_rules([2,3],[3])`, which
# invokes Conway's Game of Life, commonly written as 23/3. Other games can be invoked with their survival
# and birth counts, e.g. `set_universe_rules([1,3,5,7], [1,3,5,7])` invokes [Replicator][replicator]
#
# [replicator]: http://www.conwaylife.com/wiki/Replicator_(CA)

# First, here's a handy function for turning any array or object into a dictionary function.
#
# (see also: [Reusable Abstractions in CoffeeScript][reuse])
#
# [reuse]: https://github.com/raganwald/homoiconic/blob/master/2012/01/reuseable-abstractions.md#readme

dfunc = (dictionary) ->
  (indices...) ->
    indices.reduce (a, i) ->
      a[i]
    , dictionary

# Next, a helper function that sets the rules for the current "game." Calling `set_universe_rules(...)` creates
# a `succ` function that answers the successor cell given a matrix of cells. It doesn't operate directly
# on squares or cells.

set_universe_rules = (survival = [2,3], birth = [3]) ->

  return exports if Square.current_rules?.toString() is {survival, birth}.toString()

  Square.current_rules = {survival, birth}

  rule = dfunc [
    (if birth.indexOf(x) >= 0 then Cell.Alive else Cell.Dead) for x in [0..9]
    (if survival.indexOf(x) >= 0 then Cell.Alive else Cell.Dead) for x in [0..9]
  ]

  Square.succ = (cells, row, col) ->
    current_state = cells[row][col]
    neighbour_count = cells[row-1][col-1] + cells[row-1][col] +
      cells[row-1][col+1] + cells[row][col-1] +
      cells[row][col+1] + cells[row+1][col-1] +
      cells[row+1][col] + cells[row+1][col+1]
    rule(current_state, neighbour_count)

  exports

# **Reminder**: the Universe module doesn't actually implement any computation of the future of a pattern, it simply
# provides the `Square.succ` helper that the [Future] module uses. You could just as easily use this helper method to
# construct a naïve algorithm.

_.defaults exports, {Cell, Square, set_universe_rules}

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