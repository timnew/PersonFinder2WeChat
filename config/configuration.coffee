process.env.NODE_ENV = process.env.NODE_ENV?.toLowerCase() ? 'development'

class Config
  port: 80
  cookieSecret: '#()JO@HFOHO#I@HRKNFKLBCWERHIO@HEROFDHF'
  apiKey: null

class Config.development extends Config

class Config.test extends Config.development

class Config.heroku extends Config
  apiKey: process.env.apiKey

module.exports = new Config[process.env.NODE_ENV]()