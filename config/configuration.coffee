process.env.NODE_ENV = process.env.NODE_ENV?.toLowerCase() ? 'development'

class Config
  port: 80
  cookieSecret: '#()JO@HFOHO#I@HRKNFKLBCWERHIO@HEROFDHF'

class Config.development extends Config
  port: 3000

class Config.test extends Config.development

class Config.heroku extends Config


module.exports = new Config[process.env.NODE_ENV]()