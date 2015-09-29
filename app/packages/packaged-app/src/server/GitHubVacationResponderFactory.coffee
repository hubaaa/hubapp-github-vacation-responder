log = new ObjectLogger('hubaaa.GitHubVacationResponderFactory', 'info')

# TODO: This is a naive implementation. While still in non-clustered app mode,
# we should have a "cron" job that checks every 5 minutes for:
# - GitHub vacation responses in the db that are about to begin in the next 5 minutes
# - GitHub vacation responses that have been stopped and remove them from @responders.
# TODO: Deal with timezones, if needed
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

  init: =>
    try
      log.enter('start')
      users = @users.find( { 'services.github.accessToken': { $exists: true } } ).fetch()
      for user in users
        expect(user.services.github.username).to.be.ok
        appSettings = hubapp_user_settings.findOne _id: user._id
        if appSettings?
          @responders[user.services.github.username] = new hubaaa.GitHubVacationResponder(user, appSettings)
          @responders[user.services.github.username].init()
    finally
      log.return()

  # We should probably call this upsert.
  # Starts or restarts a vacation response for a specific user.
  update: (appSettings)=>
    try
      log.enter('userAppSettings')
      if process.env.ACCOUNTS_PASSWORD is "1"
        log.warn "Using accounts-password instead of accounts-github, app will not run."
        return
      user = @users.findOne _id: appSettings._id
      expect(user).to.be.ok
      expect(user.services.github.accessToken).to.be.ok
      expect(user.services.github.username).to.be.ok
      if @responders[user.services.github.username]?
        # Clean it up
        @responders[user.services.github.username].stop()
        delete @responders[user.services.github.username]
      return if appSettings.disabled is true
      @responders[user.services.github.username] = new hubaaa.GitHubVacationResponder(user, appSettings)
      @responders[user.services.github.username].init()
    finally
      log.return()


Meteor.startup ->
  if not process.env.METEOR_TEST_PACKAGES?
    hubaaa.GitHubVacationResponderFactory.get().init()
