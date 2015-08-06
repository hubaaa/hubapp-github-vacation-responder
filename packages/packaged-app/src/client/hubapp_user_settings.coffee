log = new ObjectLogger 'Template.hubapp_user_settings_form', 'debug'

autoResponseTextVar = null

Meteor.startup ->
  alertify.defaults.notifier.position = 'top-right'

Template.registerHelper 'absoluteUrl', ->
  return Meteor.absoluteUrl()

Template.hubapp_user_settings_form.onCreated ->
  try
    log.enter 'onCreated'
    @subscribe 'hubapp_user_settings'
  finally
    log.return()

Template.hubapp_user_settings_form.onRendered ->
  try
    log.enter 'onRendered'
  finally
    log.return()


Template.hubapp_user_settings_form.helpers
  settings: ->
    try
      log.enter 'settings', hubapp_user_settings.findOne( { _id: Meteor.userId() } )
      doc = hubapp_user_settings.findOne( { _id: Meteor.userId() } )
      if doc? and doc.autoResponseText
        autoResponseTextVar = new ReactiveVar(doc.autoResponseText)
      else
        autoResponseTextVar = new ReactiveVar(doc.autoResponseText)
      return doc
    finally
      log.return()

  schema: ->
    return hubapp.settings_schema

  autoResponseText: ->
    try
      log.enter 'autoResponseText'
      return autoResponseTextVar.get()
    finally
      log.return()

#  onDeleteError: ->
#    (error)->
#      try
#        log.enter 'onDeleteError', arguments
#        log.error error
#      finally
#        log.return()
#
#  onDeleteSuccess: ->
#    (result)->
#      try
#        log.enter 'onDeleteError', arguments
#        log.info result
#      finally
#        log.return()


Template.hubapp_user_settings_form.events
  "keyup #formAutoResponseText, change #formAutoResponseText": (event)->
    autoResponseTextVar.set $(event.target).val()

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
