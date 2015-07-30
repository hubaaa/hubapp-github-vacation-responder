log = new ObjectLogger('hubaaa.EasyServiceConfig', 'info')

class hubaaa.EasyServiceConfig

  instance = null

  @get: ->
    instance ?= new hubaaa.EasyServiceConfig()

# Dependency injection pattern, mainly for unit tests
  constructor: (@collection = ServiceConfiguration.configurations, @easySettings = EasyMeteorSettings)->
    try
      log.enter('constructor')
      @load()
    finally
      log.return()

  load: ->
    try
      log.enter('load')
      serviceConfigurations = @easySettings.getPrivateSetting 'serviceConfigurations'
      return if not serviceConfigurations?
      expect(serviceConfigurations, 'Meteor.settings.serviceConfigurations').to.be.an 'object'
      for service, config of serviceConfigurations
        expect(config, "Meteor.settings.serviceConfigurations.#{service}").to.be.an 'object'
        # We need to add this to doc, if we don't want to get an array of service configs instead,
        # which might include duplicates.
        config.service = service
        # TODO: Support specifying both sub-documents per service or an array of services???
        @collection.upsert service: service, config
    finally
      log.return()


@EasyServiceConfig = hubaaa.EasyServiceConfig.get()
