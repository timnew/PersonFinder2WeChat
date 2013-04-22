_ = require('lodash')

class WeChatRequest
  constructor: (data) ->
    @type = data.MsgType
    @serviceName =  data.ToUserName
    @userName = data.FromUserName
    @createTime = data.CreateTime

  respondText: (callback, text) ->
    process.nextTick =>
      callback null, new Models.TextResponse
        serviceName: @serviceName
        userName: @userName
        message: text

  respond: (callback) ->
    @respondText callback, "Sorry I don't understand your words."

WeChatRequest.parseXml = (dom) ->
  root = dom[0]

  data = {}
  for node in root.children when node.type == 'tag'
    dataNode = node.children[0]
    data[node.name] = switch dataNode.type
      when 'cdata' then dataNode.children[0].data
      when 'text' then dataNode.data

  RequestClass = @getRequestClass(data.MsgType)

  new RequestClass(data)

WeChatRequest.getRequestClass = (type) ->
  WeChatRequest.types[type] ? WeChatRequest

WeChatRequest.types = {}

exports = module.exports = WeChatRequest

###
<xml>
  <ToUserName><![CDATA[toUser]]></ToUserName>
  <FromUserName><![CDATA[fromUser]]></FromUserName>
  <CreateTime>1348831860</CreateTime>
  <MsgType><![CDATA[text]]></MsgType>
  <Content><![CDATA[this is a test]]></Content>
  <MsgId>1234567890123456</MsgId>
</xml>
###

class TextRequest extends WeChatRequest
  constructor: (data) ->
    super(data)
    @id = data.MsgId
    @message = data.Content

  helpMessage: """
               我不理解您的输入
               输入 "S 人名" 查询
               """

  respond: (callback) ->
    @message = @message.trim()
    parsedText = @message.match /(\w)\s+(.*)/
    console.log parsedText
    return @respondText(callback, @helpMessage) unless parsedText?

    switch parsedText[1].toUpperCase()
      when 'S', 'SEARCH', '找人', '我要找人', '找'
        @searchPerson(callback, parsedText[2])
      else
        @respondText(callback, @helpMessage)

  searchPerson: (callback, name) ->
    Services.PersonFinder.findPerson name, (err, personInfo) =>
      return callback(err) if err?
      console.log "Respond: #{personInfo}"
      @respondText(callback, personInfo)

WeChatRequest.types.text = TextRequest

###
<xml>
<ToUserName><![CDATA[gh_07db88683e6c]]></ToUserName>
<FromUserName><![CDATA[oeGWdjjL6w5OA1xPSy-dQ-e7pIx4]]></FromUserName>
<CreateTime>1366546562</CreateTime>
<MsgType><![CDATA[event]]></MsgType>
<Event><![CDATA[unsubscribe]]></Event>
<EventKey><![CDATA[]]></EventKey>
</xml>
###

###
<xml>
  <ToUserName><![CDATA[gh_07db88683e6c]]></ToUserName>
  <FromUserName><![CDATA[oeGWdjjL6w5OA1xPSy-dQ-e7pIx4]]></FromUserName>
  <CreateTime>1366546510</CreateTime>
  <MsgType><![CDATA[event]]></MsgType>
  <Event><![CDATA[subscribe]]></Event>
  <EventKey><![CDATA[]]></EventKey>
</xml>
###

class EventRequest extends WeChatRequest
  constructor: (data) ->
    super(data)
    @event = data.Event
    @eventKey = data.EventKey

  subscribeHandler: (callback) ->
    @respondText callback, "济苍生以软件，担道义为世苑"

  unsubscribeHandler: (callback) ->
    @respondText callback, "Bye"

  respond: (callback) ->
    handler = this["#{@event}Handler"]

    if handler?
      handler.call(this, callback)
    else
      process.nextTick ->
        callback(null, null)

WeChatRequest.types.event = EventRequest