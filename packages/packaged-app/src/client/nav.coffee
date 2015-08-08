log = new ObjectLogger 'Template.nav', 'debug'

Template.nav.onCreated ->
  try
    log.enter 'onCreated'
    @subscribe 'hubapp_user_settings',
      onStop: (error)=>
        try
          log.enter 'onSubscribeStop'
          log.error error if error?
        finally
          log.return()
      onReady: =>
        try
          log.enter 'onSubscribeReady'
        finally
          log.return()

  finally
    log.return()
