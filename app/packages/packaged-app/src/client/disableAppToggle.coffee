log = new ObjectLogger 'Template.disableAppToggle', 'debug'

changing = false

Template.disableAppToggle.onCreated ->
  try
    log.enter 'onCreated'
    expect(Meteor.userId()).to.be.ok

    settings = hubapp_user_settings.findOne _id: Meteor.userId()

    log.debug 'settings', settings

    @vm = new ViewModel 'disableAppToggleViewModel',
      appEnabled: not settings?._id? or not settings.disabled

      hasSettings: ->
        try
          log.enter 'hasSettings'
          hasSettings = hubapp_user_settings.findOne({_id: Meteor.userId()})?
          log.debug 'hasSettings:', hasSettings
          return hasSettings
        finally
          log.return()

      tooltip: ->
        if not @hasSettings()
          return "To disable the app, you first need to save your settings."
        else
          return undefined

      onChange: (checked)->
        try
          log.enter 'onChange', checked, changing
          return if changing is true

          Meteor.call 'hubapp/disable', not @appEnabled(), (error, result)=>
            try
              log.enter 'disableCB', arguments
              if error?
                try
                  log.error error
                  changing = true
                  $('#disableAppToggle').bootstrapToggle('toggle')
                  alertify.error('Oops. Something went wrong :-( Please try again later.', 2)
                finally
                  Meteor.defer ->
                    log.debug 'changing changing back to false'
                    changing = false
            finally
              log.return()
        finally
          log.return()

    log.debug 'toJS', @vm.toJS()

  finally
    log.return()


Template.disableAppToggle.onRendered ->
  try
    log.enter 'onRendered'
    @vm.bind(@)
    $('#disableAppToggle').bootstrapToggle()
  finally
    log.return()
