# This module is part of [recursiveuniverse.github.io](http://recursiveuniverse.github.io).
#
# ## Memoization Module
#
# HashLife uses extensive [canonicalization][canonical] to optimize the storage of very large patterns with repetitive
# components. The [Canonicalization Module][canonicalization] implements a very naive hash-table for canoncial
# representations of squares.
#
# Since every unique square has a single canonical representation in the cache, HashLife is able to "memoize" results
# such as its future at a particular time. Consider the completely degenerate example of an empty square that is
# `2^64` by `2^64` (18,446,744,073,709,552,000 a side). In order to compute its history, the Hashlife algorithm
# first constructs nine squares that are `2^32` a side. Naturally, they're all identical, empty squares. HashLife
# needs to computer their future, so it computes the first one and memoizes it. When it gets the result for the
# remaining eight, it re-uses the memoized result.
#
# That goes down recursively, of course. Computing the future of an empty `2^32` by `2^32` square starts with
# getting the future of nine identical empty `2^31` by `2^31` squares, and that result is only computed once.
# This continues down recursively until we reach a seed square that is `2^2` by `2x2`.
#
# Not all patterns are as obliging as an empty square, some have fewer or greater amounts of redundancy HashLife
# can exploit. Which is interesting, in that the "complexity" of a pattern's future is closely linked to
# the lack of redundancy encountered in computing the future. This is why a [Glider Gun][gun] with population 36 is many,
# many orders of magnitude less complicated than [Rabbits][rabbits] with population 9.
#
# [canonicalization]: http:canonicalization.html
# [canonical]: https://en.wikipedia.org/wiki/Canonicalization
# [gun]: http://www.conwaylife.com/wiki/index.php?title=Gosper_glider_gun
# [rabbits]: http://www.ericweisstein.com/encyclopedias/life/Rabbits.html

# ### Implementing Memoization
#
# The implementation is a little more bespoke than you would usually see. Normally,
# you would use something like;
#
#   @some_memoized_method = _.memoize( ->
#     "method_body_goes_here"
#   )
#
# However, rolling our own memoization infrastructure allows us to construct
# the `children` method that shows us which squares are logically related to any given
# square, by dint of being its quadrants or result at any time in the future.

# ### Baseline Setup
_ = require('underscore')
{YouAreDaChef} = require('YouAreDaChef')
exports ?= window or this

exports.mixInto = ({Square, Cell}) ->

  YouAreDaChef('memoization')
    .clazz(Square)
      .def
        get_memo: (index) ->
          @memoized[index]
        set_memo: (index, square) ->
          @memoized[index] = square
      .after
        initialize: ->
          @memoized = {}

  memoize = (clazz, names...) ->
    for name in names
      do (name) ->
        method_body = clazz.prototype[name] #FIXME is this broken now that the method_body has been monekeyed about
        clazz.prototype[name] = (args...) ->
          index = name + _.map( args, (arg) -> "_#{arg}" ).join('')
          @get_memo(index) or @set_memo(index, method_body.call(this, args...))

  memoize Square.Seed, 'result'
  memoize Square.RecursivelyComputable, 'result', 'result_at_time'

# ## The first time through
#
# Congratulations, you've finished the four core modules ([universe][universe], [future][future], [canonicalization][canonicalization] and
# [memoization][memoization]) that make up Cafe au Life. Review the [garbage collection][gc],
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