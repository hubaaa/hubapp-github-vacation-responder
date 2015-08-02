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
      log.enter 'settings', hubapp_user_settings.findOne( { userId: Meteor.userId() } )
      return hubapp_user_settings.findOne( { userId: Meteor.userId() } )
    finally
      log.return()
