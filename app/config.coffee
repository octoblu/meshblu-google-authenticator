passport = require 'passport'
GoogleStrategy = require('passport-google-oauth2').Strategy
Device = require './models/device-authenticator'
MeshbluDB = require 'meshblu-db'
debug = require('debug')('meshblu-google-authenticator:config')

googleOauthConfig =
  clientID: process.env.GOOGLE_CLIENT_ID
  clientSecret: process.env.GOOGLE_CLIENT_SECRET
  callbackURL: process.env.GOOGLE_CALLBACK_URL

class GoogleConfig
  constructor: (@meshbluConn, @meshbluJSON) =>
    @meshbludb = new MeshbluDB @meshbluConn

  onAuthentication: (accessToken, refreshToken, profile, done) =>
    debug 'Authenticated', accessToken
    authenticatorUuid = @meshbluJSON.uuid
    authenticatorName = @meshbluJSON.name
    deviceModel = new Device authenticatorUuid, authenticatorName, meshblu: @meshblu, meshbludb: @meshbludb
    # deviceModel.create 
    done null, {id: profile.id, name: profile.name}

  register: =>
    passport.use new GoogleStrategy googleOauthConfig, @onAuthentication

module.exports = GoogleConfig
