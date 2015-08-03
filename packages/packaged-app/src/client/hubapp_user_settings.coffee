log = new ObjectLogger 'Template.hubapp_user_settings_form', 'debug'

Template.hubapp_user_settings_form.onCreated ->
  try
    log.enter 'onCreated'
    @subscribe 'hubapp_user_settings'
  finally
    log.return()

Template.hubapp_user_settings_form.helpers
  settings: ->
    try
      log.enter 'settings', hubapp_user_settings.findOne( { _id: Meteor.userId() } )
      return hubapp_user_settings.findOne( { _id: Meteor.userId() } )
    finally
      log.return()

  schema: ->
    return hubapp.settings_schema

  onDeleteError: ->
    (error)->
      try
        log.enter 'onDeleteError', arguments
        log.error error
      finally
        log.return()

  onDeleteSuccess: ->
    (result)->
      try
        log.enter 'onDeleteError', arguments
        log.info result
      finally
        log.return()
