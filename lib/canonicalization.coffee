# This module is part of [recursiveuniverse.github.io](http://recursiveuniverse.github.io).
#
# ## Canonicalization Module
#
# HashLife uses extensive [canonicalization][canonical] to optimize the storage of very large patterns with repetitive
# components. The Canonicalization Module implements a very naive hash-table for canoncial representations of squares.
#
# [canonicalization]: http:canonicalization.html
# [canonical]: https://en.wikipedia.org/wiki/Canonicalization

# ### Canoncialization: The "Hash" in HashLife
#
# HashLife gets a tremendous speed-up by storing and reusing squares in a giant cache.
#
# The first part of making this work is "canonicalizing" squares: There is exactly one unique representation
# of each square at every level. To take an extreme example, a 64x64 empty square requires just six
# canonical objects: An empty `Cell` and a single `Square` for each level: 2x2, 4x4, 8x8, 16x16, 32x32 and 64x64.
# By canonicalizing the squares, Hashlife saves an enormous amount of memory and makes it possible for the
# crucial ability to memoize results, a feature implemented in the [memoization][memoization] module.
#
# [memoization]: http:memoization.html

# ### Baseline Setup
_ = require('underscore')
{YouAreDaChef} = require('YouAreDaChef')
exports ?= window or this

# ### Implementing the cache
#
# The cache is organized into an array of 'buckets', each of which is a hash from a simple key
# to a cached square. The buckets are organized by level of the square. This allows some simple
# ordering later when we start fooling around with garbage collection: It's easy to find the
# largest squares that aren't in use.

exports.mixInto = ({Square, Cell}) ->

  counter = 1 # Cell.Alive.value

  YouAreDaChef
  .tag('canonicalization')
    .clazz(Square)
      .after
        initialize: ->
          @value = (counter += 1)

  _for = Square.for

  _.extend Square,

    cache:

      cache_key: ({nw, ne, se, sw}) ->
        "#{nw.value}-#{ne.value}-#{se.value}-#{sw.value}"

      buckets: []

      clear: ->
        @buckets = []

      length: 0

      size: ->
        _.reduce @buckets, ((acc, bucket) -> acc + _.keys(bucket).length), 0

      find: (square) ->
        {nw, ne, se, sw} = square
        console.trace() unless nw?.level?
        (@buckets[nw.level + 1] ||= {})[@cache_key(square)]

      add: (square) ->
        @length += 1
        {nw, ne, se, sw} = square
        (@buckets[nw.level + 1] ||= {})[@cache_key(square)] = square

    for: (quadrants, creator) ->
      found = Square.cache.find(quadrants)
      if found
        found
      else
        {nw, ne, se, sw} = quadrants
        Square.cache.add _for(quadrants, creator)

exports

# ## The first time through
#
# Now that you've finished the [universe][universe], [future][future] and [canonicalization][canonicalization] modules,
# review the [memoization][memoization] module to understand the other half of how Cafe au Life runs so quickly. Review the [garbage collection][gc],
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
# [source]: https://github.com/recursiveuniverse/recursiveuniverse.github.io/blob/master/lib
# [docco]: http://jashkenas.github.com/docco/