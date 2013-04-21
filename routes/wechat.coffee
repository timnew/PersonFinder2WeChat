exports.initialize = (req, res) ->
  console.log req.query
  #TODO verify signature against token, timestamp and once
  res.send req.query.echostr

exports.request = (req, res) ->
  console.log req.body

