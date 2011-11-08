Robot = require '../robot'
TurntableBot  = require 'ttapi'

class Turntable extends Robot.Adapter
  constructor: (robot)->
    @user  = process.env.HUBOT_TT_USER_ID
    @auth  = process.env.HUBOT_TT_USER_AUTH
    @room  = process.env.HUBOT_TT_ROOM_ID
    super(robot)

  send: (user, strings...) ->
    for str in strings
      @client.speak str

  reply: (user, strings...) ->
    for str in strings
      @send user, "#{user.name}: #{str}"

  run: ->
    self = @
    console.log "Hubot Turntable."

    @client = new TurntableBot @auth, @user
    @client.on 'speak', @.read
    @client.on 'ready', =>
      console.log "Trying to log in"
      @client.roomRegister(@room)
    @client.on 'roomChanged', =>
      console.log "Changed into room"
      @client.speak "Hello everybody."

  read: (data)=>
    # ignore own messages
    return if @user == data.userid
    user = @robot.userForId data.userid, name: data.name
    @receive new Robot.TextMessage(user, data.text)
    

module.exports = Turntable

