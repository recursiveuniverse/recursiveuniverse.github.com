# This module is part of [recursiveuniverse.github.io](http://recursiveuniverse.github.io).
#
# ## API Module
#
# The API Module provides convenience methods for interacting with squares from the outside

# ### Baseline Setup
_ = require('underscore')
{YouAreDaChef} = require('YouAreDaChef')
exports ?= window or this

exports.mixInto = ({Square, Cell}) ->

  # ### Extracting matrices and strings from Cells and Squares

  YouAreDaChef('api')
    .clazz(Cell)
      .def
        to_json: ->
          [[@value]]
        toString: ->
          '' + @value
    .clazz(Square)
      .def
        to_json: ->
          a =
            nw: @nw.to_json()
            ne: @ne.to_json()
            se: @se.to_json()
            sw: @sw.to_json()
          b =
            top: _.map( _.zip(a.nw, a.ne), ([left, right]) ->
              if _.isArray(left)
                left.concat(right)
              else
                [left, right]
            )
            bottom: _.map( _.zip(a.sw, a.se), ([left, right]) ->
              if _.isArray(left)
                left.concat(right)
              else
                [left, right]
            )
          b.top.concat(b.bottom)
        toString: ->
          (_.map @to_json(), (row) ->
            ([' ', '*'][c] for c in row).join('')
          ).join('\n')

  # ### Constructing squares from matrices and strings

  throw 'Wanted alive or dead' unless Cell.Alive? and Cell.Dead?

  _.extend Cell,
    from_json: (json) ->
      throw 'Unh?' unless Cell.Alive.value is 1 and Cell.Dead.value is 0
      if json.length is 1
        if json[0][0] instanceof Cell
          json[0][0]
        else if json[0][0] is 0
          Cell.Dead
        else if json[0][0] is 1
          Cell.Alive
        else
          throw 'a 1x1 square must contain a zero, one, or Cell'
      else
        throw 'cannot handle larger squares'

  _.extend Square,
    from_string: (str) ->
      strs = str.split('\n')
      json = _.map strs, (ln) ->
        {'.': 0, ' ': 0, 'O': 1, '+': 1, '*': 1}[c] for c in ln
      Square.from_json(json)
    from_json: (json) ->
      dims = [json.length].concat json.map( (row) -> row.length )
      sz = Math.pow(2, Math.ceil(Math.log(Math.max(dims...)) / Math.log(2)))
      _.each [0..json.length - 1], (i) ->
        if json[i].length < sz
          json[i] = json[i].concat _.map( [1..(sz - json[i].length)], -> 0 )
      if json.length < sz
        json = json.concat _.map( [1..(sz - json.length)], ->
          _.map [1..sz], -> 0
        )
      if json.length is 1
        Cell.from_json(json)
      else
        half_length = json.length / 2
        Square.for
          nw: Square.from_json(
            json.slice(0, half_length).map (row) ->
              row.slice(0, half_length)
          )
          ne: Square.from_json(
            json.slice(0, half_length).map (row) ->
              row.slice(half_length)
          )
          se: Square.from_json(
            json.slice(half_length).map (row) ->
              row.slice(half_length)
          )
          sw: Square.from_json(
            json.slice(half_length).map (row) ->
              row.slice(0, half_length)
          )

  # ### Padding and cropping squares
  #
  # When displaying squares, it is convenient to crop them to the smallest square that contains
  # live cells.
  YouAreDaChef('api')
    .clazz(Cell)
      .def
        isEmpty: ->
          @value is 0
    .clazz(Square)
      .def
        trim: ->
          if @nw?.sw?.isEmpty() and @nw.nw.isEmpty() and @nw.ne.isEmpty() and \
             @ne.nw.isEmpty() and @ne.ne.isEmpty() and @ne.se.isEmpty() and \
             @se.ne.isEmpty() and @se.se.isEmpty() and @se.sw.isEmpty() and \
             @sw.se.isEmpty() and @sw.sw.isEmpty() and @sw.nw.isEmpty()
            Square.for
              nw: @nw.se
              ne: @ne.sw
              se: @se.nw
              sw: @sw.ne
            .trim()
          else
            this
      .after
        initialize: ->
          @isEmpty = _.memoize( ->
            (@nw is @ne is @se is @sw) and @nw.isEmpty()
          )

  # ### Querying squares
  Cell.Dead.population = 0
  Cell.Alive.population = 1

  YouAreDaChef('api')
    .clazz(Square)
      .after
        initialize: ->
          @population = @nw.population + @ne.population + @se.population + @sw.population

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