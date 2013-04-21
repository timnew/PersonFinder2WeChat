describe 'PersonFinder', ->

  testRepo = 'test-nokey'
  apiKey = 'apiKey'

  it 'Should exported', ->
    Services.PersonFinder.should.be.ok
    Services.PersonFinder.should.respondTo 'findPerson'
    Services.PersonFinder.PersonFinder.should.be.ok
    Services.PersonFinder.PersonFinder.should.be.instanceOf Function

  describe 'buildQuery', ->
    it 'should ignore apikey if not avaiable', ->
      finder = new Services.PersonFinder.PersonFinder(testRepo)

      query = finder.buildQuery
        q: 'Someone'

      query.should.eql
        q: 'Someone'

    it 'should apply apikey if avaiable', ->
      finder = new Services.PersonFinder.PersonFinder(testRepo, apiKey)

      query = finder.buildQuery
        q: 'Someone'

      query.should.eql
        q: 'Someone'
        key: apiKey

  describe 'findPerson', ->
    finder = new Services.PersonFinder.PersonFinder(testRepo)

    it 'should return person', (done) ->
      finder.findPerson 'Achille', (err, person) ->
        console.log err
        console.log person
        done(err)