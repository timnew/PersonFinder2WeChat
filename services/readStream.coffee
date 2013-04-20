module.exports = (stream, callback) ->
  stream.setEncoding 'utf8'

  buffer = ''
  exception = null

  stream.on 'data', (chunk) ->
    try
      buffer += chunk
    catch ex
      exception = ex

  stream.on 'end', ->
    callback(exception, buffer)
