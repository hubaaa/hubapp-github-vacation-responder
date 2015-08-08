log = new ObjectLogger 'Template.hubapp_user_settings_form', 'debug'

Meteor.startup ->
  alertify.defaults.notifier.position = 'top-right'

Template.registerHelper 'absoluteUrl', ->
  return Meteor.absoluteUrl()

Template.registerHelper 'appSettings', ->
  return if not Meteor.user()
  return hubapp_user_settings.findOne _id: Meteor.userId()

Template.hubapp_user_settings_form.onCreated ->
  try
    log.enter 'onCreated'
    expect(Meteor.userId()).to.be.ok

    settings = hubapp_user_settings.findOne _id: Meteor.userId()

    log.debug 'settings', settings

    @vm = new ViewModel 'appSettingsViewModel',
      startDate: settings?.startDate || moment().toDate()
      endDate: settings?.endDate || moment().add(7, 'days').endOf('day').toDate()
      autoResponseText: settings?.autoResponseText || ''
      disabled: if settings? then settings.disabled else false
      saveButtonText: 'Save'

      isValid: ->
        try
          log.enter 'isValid'
          model = EJSON.clone(@toJS())
          hubapp.SettingsSchema.clean model
          log.info 'model:', model
          validationContext = hubapp.SettingsSchema.newContext()
          if validationContext.validate(model, {modifier: false, isModifier: false})
            return true
          else
            log.error validationContext.invalidKeys()
        finally
          log.return()

      save: (event)->
        try
          log.enter 'save', event
          event.preventDefault()
          @saveButtonText('Saving...')
          settings = @toJS()
          Meteor.call 'hubapp/settings/save', settings, (error, result)=>
            try
              log.enter 'saveCB', arguments
              @saveButtonText('Save')
              if error?
                log.error error
                alertify.error('Oops. Something went wrong :-( Please try again later.', 2)
              else
                # For some reason, the disableAppToggleViewModel doesn't change the enabled state of the bootstrapToggle,
                # so we do it here.
                $('#disableAppToggle').bootstrapToggle('enable')
                if @disabled is true
                  alertify.success('Saved.', 2)
                else
                  alertify.success('Saved. Happy vacationing!', 2)
            finally
              log.return()
        finally
          log.return()
  finally
    log.return()

Template.hubapp_user_settings_form.onRendered ->
  try
    log.enter 'onRendered'
    @vm.bind(@)
    log.info 'vmToJS:', ViewModel.byId("appSettingsViewModel").toJS()
    $('#vacationDates').daterangepicker
      startDate: ViewModel.byId("appSettingsViewModel").startDate()
      endDate: ViewModel.byId("appSettingsViewModel").endDate()
      opens: "center"
      drops: "down"
      timePicker: true
      locale:
        format: 'MM/DD/YYYY h:mm A'
      timePickerIncrement: 30
      timePicker24Hour: false
      timePickerSeconds: false
    , (start, end, label)->
        try
          log.enter 'daterangepicker.cb', arguments
          ViewModel.byId("appSettingsViewModel").startDate(start.toDate())
          ViewModel.byId("appSettingsViewModel").endDate(end.toDate())
        finally
          log.return()
  finally
    log.return()

Template.hubapp_user_settings_form.helpers
  settings: ->
    try
      log.enter 'settings', hubapp_user_settings.findOne( { _id: Meteor.userId() } )
      doc = hubapp_user_settings.findOne( { _id: Meteor.userId() } )
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


#AutoForm.hooks
#  hubapp_user_settings_form:
#    before:
#      method: (doc)->
#        try
#          log.enter('before', arguments)
#          $('button[type="submit"]').html('Saving...')
#          $('button[type="submit"]').attr('disabled','disabled')
#          return doc
#        finally
#          log.return()
#
#    after:
#      method: (error, result)->
#        try
#          log.enter('after', arguments)
#          $('button[type="submit"]').removeAttr('disabled')
#          $('button[type="submit"]').html('Save')
#          if error?
#            log.error error
#            alertify.error('Oops. Something went wrong :-( Please try again later.', 2)
#          else
#            alertify.success('Saved. Happy vacationing!', 2)
#        finally
#          log.return()

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

#      autoform:
#        type: "bootstrap-daterangepicker"
#        dateRangePickerValue: moment().add(1, 'days').format("MM/DD/YYYY h:mm A") + " - " + moment().add(8, 'days').format("MM/DD/YYYY h:mm A")
##             maxDate: moment().add(6, 'months')
#            startDate: moment().add(1, 'days')
#            endDate: moment().add(8, 'days')
