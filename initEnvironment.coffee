global.createLazyLoader = require('./services/LazyLoader')
global.createPathHelper = require('./services/PathHelper')

global.rootPath = createPathHelper(__dirname).consolidate()

global.Configuration = require(rootPath.config('configuration'))

global.Services = createLazyLoader rootPath.services()
global.Routes = createLazyLoader rootPath.routes()
#global.Records = createLazyLoader rootPath.records()
global.Models = createLazyLoader rootPath.models()
global.assets = {} # initialize this context for connect-assets helpers

util = require('util')
console.inspect = (objs...) ->
  for obj in objs
    message = util.inspect obj,
                           depth: null
                           colors: true
    console.log message
  return
