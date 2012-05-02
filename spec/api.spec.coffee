_ = require('underscore')
require 'UnderscoreMatchersForJasmine'

Life = require('../lib/cafeaulife').set_universe_rules()

describe 'from_json', ->

  describe 'cells', ->

    it 'should get cells from json', ->
      expect(Life.Cell.from_json([[0]])).toEqual(Life.Cell.Dead)
      expect(Life.Cell.from_json([[1]])).toEqual(Life.Cell.Alive)

    it 'should translate cells to json', ->
      expect(Life.Cell.Dead.to_json()).toEqual([[0]])
      expect(Life.Cell.Alive.to_json()).toEqual([[1]])

  describe 'squares', ->

    it 'should accept rectangles', ->

      expect( Life.Square.from_json [
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1]
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1]
        [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      ]).toBeA(Life.Square)

    it 'should accept strings', ->

      expect( Life.Square.from_string '''
        ....O...
        ..O.O...
        ......O.
        OO......
        ......OO
        .O......
        ...O.O..
        ...O....
      ''' ).toBeA(Life.Square)

  describe 'round trips', ->

    it 'should round-trip 2x2 squares', ->

      source = Life.Square.from_json([
        [0, 1]
        [1, 0]
      ])

      expect( source.nw ).toEqual( Life.Cell.Dead, 'NOT DEAD' )
      expect( source.ne ).toEqual( Life.Cell.Alive, 'NOT ALIVE' )
      expect( source.se ).toEqual( Life.Cell.Dead, 'NOT DEAD' )
      expect( source.sw ).toEqual( Life.Cell.Alive, 'NOT ALIVE' )

      expect( source.ne.to_json() ).toEqual( [[1]] )

      expect( Life.Square.from_json([
        [0, 1]
        [1, 0]
      ]).to_json() ).toEqual([
        [0, 1]
        [1, 0]
      ])

    it 'should round trip 4x4 squares', ->

      expect( Life.Square.from_json([
        [0, 0, 0, 1]
        [0, 0, 1, 0]
        [0, 1, 0, 0]
        [1, 0, 0, 0]
      ]).to_json() ).toEqual([
        [0, 0, 0, 1]
        [0, 0, 1, 0]
        [0, 1, 0, 0]
        [1, 0, 0, 0]
      ])

  describe 'from_json', ->

    it 'should handle ones and zeroes', ->

      expect( Life.Square.from_json [[1]] ).toEqual(Life.Cell.Alive)

      expect( Life.Square.from_json [[0]] ).toEqual(Life.Cell.Dead)

    it 'should handle size two squares', ->

      expect( Life.Square.from_json([[1, 0], [0, 1]]) ).toEqual(
        Life.Square.for(
          nw: Life.Cell.Alive
          ne: Life.Cell.Dead
          se: Life.Cell.Alive
          sw: Life.Cell.Dead
        )
      )

    it 'should handle size four squares', ->

      expect( Life.Square.from_json [
        [0, 0, 0, 1]
        [0, 0, 1, 0]
        [0, 1, 0, 0]
        [1, 0, 0, 0]
      ] ).toEqual(
        Life.Square.for
          nw: Life.Square.for
            nw: Life.Cell.Dead
            ne: Life.Cell.Dead
            se: Life.Cell.Dead
            sw: Life.Cell.Dead
          ne: Life.Square.for
            nw: Life.Cell.Dead
            ne: Life.Cell.Alive
            se: Life.Cell.Dead
            sw: Life.Cell.Alive
          se: Life.Square.for
            nw: Life.Cell.Dead
            ne: Life.Cell.Dead
            se: Life.Cell.Dead
            sw: Life.Cell.Dead
          sw: Life.Square.for
            nw: Life.Cell.Dead
            ne: Life.Cell.Alive
            se: Life.Cell.Dead
            sw: Life.Cell.Alive
      )

      expect( Life.Square.from_json [
        [0, 0, 0, 0]
        [0, 0, 1, 0]
        [0, 1, 0, 0]
        [0, 0, 0, 1]
      ] ).toEqual(
        Life.Square.for
          nw: Life.Square.for
            nw: Life.Cell.Dead
            ne: Life.Cell.Dead
            se: Life.Cell.Dead
            sw: Life.Cell.Dead
          ne: Life.Square.for
            nw: Life.Cell.Dead
            ne: Life.Cell.Dead
            se: Life.Cell.Dead
            sw: Life.Cell.Alive
          se: Life.Square.for
            nw: Life.Cell.Dead
            ne: Life.Cell.Dead
            se: Life.Cell.Alive
            sw: Life.Cell.Dead
          sw: Life.Square.for
            nw: Life.Cell.Dead
            ne: Life.Cell.Alive
            se: Life.Cell.Dead
            sw: Life.Cell.Dead
      )