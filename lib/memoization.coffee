# This module is part of [recursiveuniver.se](http://recursiveuniver.se).
#
# ## Basic Memoization Module
#
# The Future Module provides methods for computing the future of a pattern, taking into account its ability to grow beyond
# the size of its container square.

# ### The Life "Universe"
#
# The memoizing is a little more bespoke than you would usually see. Normally,
# you would use something like;
#
#   @some_memoized_method = _.memoize( ->
#     "method_body_goes_here"
#   )
#
# However, rolling our own memoize infrastructure allows us to construct
# the `children` method that shows us which squares are logically related to any given
# square, by dint of being its quadrants or result at any time in the future

# ### Baseline Setup

# ### Baseline Setup
_ = require('underscore')
YouAreDaChef = require('YouAreDaChef').YouAreDaChef
exports ?= window or this

exports.mixInto = ({Square, Cell}) ->

  YouAreDaChef(Square)
    .after 'initialize', ->
      @memoized = {}

  Square::get_memo = (index) ->
    @memoized[index]

  Square::set_memo = (index, square) ->
    @memoized[index] = square

  memoize = (clazz, names...) ->
    for name in names
      do (name) ->
        method_body = clazz.prototype[name]
        clazz.prototype[name] = (args...) ->
          index = name + _.map( args, (arg) -> "_#{arg}" ).join('')
          @get_memo(index) or @set_memo(index, method_body.call(this, args...))

  memoize Square.Seed, 'result'
  memoize Square.RecursivelyComputable, 'result', 'result_at_time'