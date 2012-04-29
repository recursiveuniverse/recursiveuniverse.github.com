require 'UnderscoreMatchersForJasmine'

Life = require('../lib/cafeaulife').set_universe_rules()

describe 'Cell and Square', ->

  it 'should fill the cache', ->

    expect(Life.Square.cache.length > 65000).toBeTruthy()

  it 'should do something sensible with creation', ->

    sq = Life.Square.from_string '''
        ....O...
        ..O.O...
        ......O.
        OO......
        ......OO
        .O......
        ...O.O..
        ...O....
      '''
    expect(sq).toBeA(Life.Square.RecursivelyComputable)
    expect(sq).toRespondTo('result')

    expect(sq.nw).toEqual(
      Life.Square.from_string '''
          ....
          ..O.
          ....
          OO..
        '''
    )
    expect(sq.nw).toBeA(Life.Square.Seed)
    expect(sq.nw).toRespondTo('result')

    expect(sq.nw.nw).toEqual(
      Life.Square.from_string '''
          ..
          ..
        '''
    )
    expect(sq.nw.nw).toBeA(Life.Square.Smallest)
    expect(sq.nw.nw).not.toRespondTo('result')

    expect(sq.nw.nw.nw).toBeA(Life.Cell)

  it 'should compute a result', ->

    s = Life.Square.from_string '''
        ....O...
        ..O.O...
        ......O.
        OO......
        ......OO
        .O......
        ...O.O..
        ...O....
      '''
    s.result()