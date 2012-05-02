# This module is part of [recursiveuniver.se](http://recursiveuniver.se).
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
# Any result, at any scale, that has been computed before is reused. This is extremely
# efficient when dealing with patterns that contain a great deal of redundancy, such as
# the kinds of patterns constructed for the purpose of emulating circuits or machines in Life.
#
# Once Cafe au Life has calculated the results for the 65K possible four-by-four
# squares, the rules are no longer applied to any generation: Any pattern of any size is
# recursively computed terminating in a four-by-four square that has already been computed and cached.
#
# This module provides a `mixInto` function so that it retroactively modify existing classes.

# ### Baseline Setup
_ = require('underscore')
YouAreDaChef = require('YouAreDaChef').YouAreDaChef
exports ?= window or this

# ### Implementing the cache
#
# The cache is organized into an array of 'buckets', each of which is a hash from a simple key
# to a cached square. The buckets are organized by level of the square. This allows some simple
# ordering later when we start fooling around with garbage collection: It's easy to find the
# largest squares that aren't in use.
exports.mixInto = ({Square, Cell}) ->

  counter = 1 # Cell.Alive.value

  YouAreDaChef(Square)
    .after 'initialize', ->
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
# If this is your first time through the code, and you've already read the [Rules][rules] and [Future][future] modules, you can look at the
# [Garbage Collection][gc] and [API][api] modules next.
#
# [menagerie]: http:menagerie.html
# [api]: http:api.html
# [future]: http:future.html
# [canonicalization]: http:canonicalization.html
# [canonical]: https://en.wikipedia.org/wiki/Canonicalization
# [rules]: http:rules.html
# [gc]: http:gc.html

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