_ = require('lodash')
request = require('superagent')
htmlparser = require("htmlparser2")

###
<pfif:person>
  <pfif:person_record_id>test-nokey.personfinder.google.org/person.24185213</pfif:person_record_id>
  <pfif:entry_date>2013-04-16T20:17:20Z</pfif:entry_date>
  <pfif:expiry_date>2013-05-16T20:17:20Z</pfif:expiry_date>
  <pfif:author_name>achille</pfif:author_name>
  <pfif:source_name>google.org</pfif:source_name>
  <pfif:source_date>2013-04-16T20:17:20Z</pfif:source_date>
  <pfif:source_url>http://google.org/personfinder/test-nokey/view?id=test-nokey.personfinder.google.org%2Fperson.24185213</pfif:source_url>
  <pfif:full_name>Achille Bottino</pfif:full_name>
  <pfif:given_name>Achille</pfif:given_name>
  <pfif:family_name>Bottino</pfif:family_name>
  <pfif:sex>male</pfif:sex>
  <pfif:age>13</pfif:age>
  <pfif:note>
    <pfif:note_record_id>test-nokey.personfinder.google.org/note.24361198</pfif:note_record_id>
    <pfif:person_record_id>test-nokey.personfinder.google.org/person.24185213</pfif:person_record_id>
    <pfif:entry_date>2013-04-16T20:17:20Z</pfif:entry_date>
    <pfif:author_name>achille</pfif:author_name>
    <pfif:source_date>2013-04-16T20:17:20Z</pfif:source_date>
    <pfif:author_made_contact>true</pfif:author_made_contact>
    <pfif:status>is_note_author</pfif:status>
    <pfif:text>Ciao.</pfif:text>
  </pfif:note>
  <pfif:note>
    <pfif:note_record_id>test-nokey.personfinder.google.org/note.24197208</pfif:note_record_id>
    <pfif:person_record_id>test-nokey.personfinder.google.org/person.24185213</pfif:person_record_id>
    <pfif:entry_date>2013-04-20T13:58:41Z</pfif:entry_date>
    <pfif:author_name>Tim</pfif:author_name>
    <pfif:source_date>2013-04-20T13:58:41Z</pfif:source_date>
    <pfif:status>information_sought</pfif:status>
    <pfif:text>I saw him somewhere</pfif:text>
  </pfif:note>
</pfif:person>
###
class Person
  constructor: (data, @notes) ->
    _.extend this, data

  sexText:
    male: '男'
    female: '女'

  renderSex: ->
    if @sex?
      @sexText[@sex]
    else
      ‘性别未登录’

  renderAge: ->
    if @age?
      "#{@age} 岁"
    else
      "年龄未登录"

  render: ->
    """
    #{@full_name} #{@renderSex()} #{@renderAge()}

    #{@renderNotes()}
    原始链接：#{@source_url}
    """

  renderNotes: ->
    result = ''
    result += note.render() for note in @notes
    result

class Note
  constructor: (data) ->
    _.extend this, data

  render: ->
    """
    [#{@source_date}] #{@author_name}: #{@text}

    """

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
      .end (err, res) =>
        return callback(err) if err?

        handler = new htmlparser.DefaultHandler (err, data) =>
          return calback(err) if err?

          @parseDom(callback, data)

        parser = new htmlparser.Parser(handler)

        res.setEncoding 'utf8'
        buffer = ''
        res.on 'data', (chunk) ->
          buffer += chunk
          parser.parseChunk(chunk)
        res.on 'end', ->
          console.log buffer
          parser.done()

  parseDom: (callback, dom) ->
    root = htmlparser.DomUtils.getElementsByTagName('pfif:pfif', dom)
    personDoms = htmlparser.DomUtils.getElementsByTagName('pfif:person', root[0])

    persons = []

    if personDoms.length == 0
      message = """
                数据库中暂时还没有您查询的内容
                您可以访问下面连接，帮助完善数据库
                https://google.org/personfinder/2013-sichuan-earthquake/create?role=seek
                """
      callback(null, message)
    else
      for personDom in personDoms
        persons.push @parsePerson(personDom)

      callback(null, @renderModels(persons))

  renderModels: (models) ->
    result = ''
    for model in models
      result+= model.render()
    result

  parseNote: (dom) ->
    noteData = {}

    for node in dom.children when node.type == 'tag'
      name = node.name.split(':')[1]
      noteData[name] = node.children[0].data

    new Note(noteData)

  parsePerson: (dom) ->
    personData = {}
    notes = []
    for node in dom.children when node.type == 'tag'
      name = node.name.split(':')[1]
      if name == 'note'
        notes.push @parseNote(node)
      else
        personData[name] = node.children[0].data

    new Person(personData, notes)

module.exports = new PersonFinder(Configuration.repository, Configuration.apiKey)

module.exports.PersonFinder = PersonFinder

