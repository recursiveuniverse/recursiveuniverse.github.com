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
#
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

class Cell
  constructor: (@value) ->
    @level = 0
    @initialize.apply(this, arguments)
  initialize: ->
  @for: ->
    new @(arguments...)

class Square
  constructor: ({@nw, @ne, @se, @sw}) ->
    @level = @nw.level + 1
    @initialize.apply(this, arguments)
  initialize: ->
  @for: (quadrants, creator = Square)->
    new creator(quadrants)

_.defaults exports, {Cell, Square}