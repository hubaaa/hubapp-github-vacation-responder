log = new ObjectLogger('hubaaa.GitHubVacationResponderFactory', 'debug')

class hubaaa.GitHubVacationResponderFactory

  instance = null

  @get: ->
    instance ?= new hubaaa.GitHubVacationResponderFactory

  constructor: (@users = Meteor.users)->
    try
      log.enter('constructor', arguments)
      expect(@users).to.be.an.instanceof Mongo.Collection
      @responders = {}
    finally
      log.return()

  start: =>
    try
      log.enter('start')
      users = @users.find( { 'services.github.accessToken': { $exists: true } } ).fetch()
      for user in users
        expect(user.services.github.username).to.be.ok
        @responders[user.services.github.username] = new hubaaa.GitHubVacationResponder(user)
    finally
      log.return()

Meteor.startup ->
  hubaaa.GitHubVacationResponderFactory.get().start()
