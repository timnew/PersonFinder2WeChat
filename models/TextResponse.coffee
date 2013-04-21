class TextResponse
  constructor: (data) ->
    @userName = data.userName
    @message = data.message

  serialize: ->
    """
    <xml>
      <ToUserName><![CDATA[#{@userName}]]></ToUserName>
      <FromUserName><![CDATA[gh_07db88683e6c]]></FromUserName>
      <CreateTime>#{Date.now()}</CreateTime>
      <MsgType><![CDATA[text]]></MsgType>
      <Content><![CDATA[#{message}]]></Content>
      <FuncFlag>0</FuncFlag>
    </xml>
    """

module.exports = TextResponse