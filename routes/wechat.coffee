exports.initialize = (req, res) ->
  console.log req.query
  #TODO verify signature against token, timestamp and once
  res.send req.query.echostr

exports.request = (req, res) ->
  Services.readStream req, (err, body) ->
    console.log body

    response = new Models.TextResponse
      userName: "oeGWdjp_F2bsJlX5fOTOwsZ2Fokw"
      message: "Hello WeChat"

    res.send response.serialize()
