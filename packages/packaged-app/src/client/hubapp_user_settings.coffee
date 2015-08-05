log = new ObjectLogger 'Template.hubapp_user_settings_form', 'debug'

Meteor.startup ->
  alertify.defaults.notifier.position = 'bottom-left'

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

AutoForm.hooks
  hubapp_user_settings_form:
    before:
      method: (doc)->
        try
          log.enter('before', arguments)
          $('button[type="submit"]').html('Saving...')
          $('button[type="submit"]').attr('disabled','disabled')
          return doc
        finally
          log.return()

    after:
      method: (error, result)->
        try
          log.enter('after', arguments)
          $('button[type="submit"]').removeAttr('disabled')
          $('button[type="submit"]').html('Save')
          if error?
            log.error error
            alertify.error('Oops. Something went wrong :-( Please try again later.', 2)
          else
            alertify.success('Saved. Happy vacationing!', 2)
        finally
          log.return()

#  onSuccess: ->
#    try
#      log.enter('onSuccess', arguments)
#    finally
#      log.return()
#
#  onError: (error)->
#    try
#      log.enter('onError', arguments)
#      log.error error
#    finally
#      log.return()
