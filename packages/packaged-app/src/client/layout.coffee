log = new ObjectLogger 'Template.layout', 'debug'

Template.layout.onCreated ->
  try
    log.enter 'onCreated'
    @subscribe 'hubapp_user_settings'
  finally
    log.return()
