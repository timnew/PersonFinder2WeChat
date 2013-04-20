_ = require('lodash')
request = require('superagent')
htmlparser = require("htmlparser2")

class PersonFinder
  constructor: (repo, @apiKey) ->
    @baseUrl = "https://www.google.org/personfinder/#{repo}"

  buildQuery: (query) ->
    if @apiKey?
      _.extend query,
        key: @apiKey
    else
      query

  findPerson: (name, callback) ->
    request
      .get("#{@baseUrl}/api/search")
      .query @buildQuery
        q: name
      .end (err, res) ->
        return callback(err) if err?

        handler = new htmlparser.DefaultHandler callback

        parser = new htmlparser.Parser(handler)

        res.setEncoding 'utf8'

        res.on 'data', (chunk) ->
          parser.parseChunk(chunk)

        res.on 'end', ->
          parser.done()

module.exports = PersonFinder

