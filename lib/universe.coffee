# This module is part of [resursiveuniver.se](http://recursiveuniver.se).
#
# ## Universe Module
#
# The Universe Module provides the basic `Cell` and `Square` classes needed to
# represent the Life universe as a QuadTree. Every othere module depends on
# universe.coffee.

# ### The Life "Universe"
#
# This module mixes special case functionality for computing the `future` of a square into `Square` and `Cell`.

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

class Square
  constructor: ({@nw, @ne, @se, @sw}) ->
    @level = @nw.level + 1
    @initialize.apply(this, arguments)
  initialize: ->
  @for: (quadrants, creator = Square)->
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

  Cell.Alive ?= new Cell(1)
  Cell.Dead  ?= new Cell(0)

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

_.defaults exports, {Cell, Square, set_universe_rules}