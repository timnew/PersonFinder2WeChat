class TextResponse
  constructor: (data) ->
    @serviceName = data.serviceName
    @userName = data.userName
    @message = data.message

  serialize: ->
    """
    <xml>
      <ToUserName><![CDATA[#{@userName}]]></ToUserName>
      <FromUserName><![CDATA[#{@serviceName}]]></FromUserName>
      <CreateTime>#{Date.now()}</CreateTime>
      <MsgType><![CDATA[text]]></MsgType>
      <Content><![CDATA[#{@message}]]></Content>
      <FuncFlag>0</FuncFlag>
    </xml>
    """

module.exports = TextResponse