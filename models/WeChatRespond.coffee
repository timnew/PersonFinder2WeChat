class Text
  constructor: (data) ->
    @userName = data.userName
    @message = data.message

  serialize: ->
    """
    <xml>
      <ToUserName><![CDATA[#{@userName}]]></ToUserName>
      <FromUserName><![CDATA[ThoughtWorksChina]]></FromUserName>
      <CreateTime>#{Date.now()}</CreateTime>
      <MsgType><![CDATA[text]]></MsgType>
      <Content><![CDATA[#{message}]]></Content>
      <FuncFlag>0</FuncFlag>
    </xml>
    """

exports.Text = Text