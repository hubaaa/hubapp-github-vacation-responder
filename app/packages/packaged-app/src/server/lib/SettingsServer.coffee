log = new ObjectLogger('server.hubapp_user_settings', 'debug')

github = hubaaa.GitHubApiClient.get()
syncGetUserRepos = Meteor._wrapAsync github.getUserRepos, github


# All of this generic settings model, view and publication will be wrapped in a easily configurable package
Meteor.publish 'hubapp_user_settings', ->
  try
    log.enter 'publish'
    log.info '@userId:', @userId
    log.info 'settings:', hubapp_user_settings.find( { _id: @userId } ).fetch()[0]
    return hubapp_user_settings.find( { _id: @userId } )
  finally
    log.return()

Meteor.methods
  'hubapp/settings/save': (doc)->
    try
      log.enter 'hubapp/settings/save', @userId, doc
      if not @userId?
        throw new Meteor.Error 'not-signed-in', "You need to be signed-in to change your hubapp settings."
      if doc._id? and doc._id isnt @userId
        throw new Meteor.Error 'not-owner', "The hubapp settings you're trying to save are not your own."
      # It's an insert, let's have the _id be the same as userId, because
      # autoform doesn't allow us to define _id in the schema and an autoValue for it
      hubapp.SettingsSchema.clean(doc, isModifier: false)
      log.info 'cleanedDoc:', doc
      validationContext = hubapp.SettingsSchema.newContext()
      validationContext.validate(doc, {modifier: false, isModifier: false})
      if not validationContext.isValid()
        throw new Meteor.Error 'invalid-settings', "The hubapp settings you're trying to save are invalid.", validationContext.invalidKeys()
      expect(doc.startDate, 'startDate').to.be.an.instanceof Date
      expect(doc.endDate, 'endDate').to.be.an.instanceof Date
      if not doc._id?
        log.info 'Creating settings.'
        doc._id = @userId
      else
        log.info 'Updating settings.'

      log.info 'finalValidatedDoc:', doc
      hubapp_user_settings.upsert _id: doc._id, doc

      # So transform function can do it's thing
      doc = hubapp_user_settings.findOne(_id: doc._id)

      # TODO: We should probably rely on meteor's observeChanges for this in GitHubVacationResponderFactory
      # and not call it directly.
      hubaaa.GitHubVacationResponderFactory.get().update doc
    finally
      log.return()

  'hubapp/settings/delete': (doc)->
    try
      log.enter 'hubapp/settings/delete', doc
      if doc._id isnt @userId
        throw new Meteor.Error 'not-owner', "The hubapp settings you're trying to delete are not your own."
      docsRemoved = hubapp_user_settings.remove _id: @userId
      # Design for testability
      return docsRemoved
    finally
      log.return()


  'hubapp/settings/repos': ->
    try
      log.enter 'hubapp/settings/repos'
 
      if not @userId?
        throw new Meteor.Error(
          'not-signed-in',
          'You need to be signed-in to disable or enable your app.'
        )

      user = Meteor.user()
      return syncGetUserRepos user.services?.github?.username


    finally
      log.return()


  # @throwme for testing purposes
  'hubapp/disable': (disabled, throwme)->
    try
      log.enter 'hubapp/disable', arguments
      if throwme?
        throw new Meteor.Error throwme
      if not @userId?
        throw new Meteor.Error 'not-signed-in', "You need to be signed-in to disable or enable your app."
      docsUpdated = hubapp_user_settings.update( { _id: @userId }, { $set: { disabled: disabled } } )
      expect(docsUpdated).to.equal 1
      doc = hubapp_user_settings.findOne _id: @userId
      expect(doc?).to.be.true
      hubaaa.GitHubVacationResponderFactory.get().update doc
      # Design for testability
      return disabled
    finally
      log.return()


