exports = module.exports = (app) ->
  app.get '/', Routes.home.index
  app.get '/wechat', Routes.wechat.initialize

  
