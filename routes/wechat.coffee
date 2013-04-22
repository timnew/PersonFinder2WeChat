htmlparser = require('htmlparser2')

exports.initialize = (req, res) ->
  console.log req.query
  #TODO verify signature against token, timestamp and once
  res.send req.query.echostr

exports.request = (req, res) ->

  handler = new htmlparser.DefaultHandler (err, body) ->
    request = Models.WeChatRequest.parseXml(body)

    request.respond (err, response) ->
      return err.send 500 if err?

      if response?
        responseText = response.serialize()
        console.log "Response: #{responseText}"
        res.send responseText
      else
        console.log "Response: 404"
        res.send 404

  parser = new htmlparser.Parser(handler)

  req.setEncoding 'utf8'
  buffer = ''
  req.on 'data', (chunk) ->
    buffer += chunk
    parser.parseChunk(chunk)
  req.on 'end', ->
    console.log buffer
    parser.done()
