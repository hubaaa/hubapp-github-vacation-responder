log = new ObjectLogger('hubaaa.EasyMeteorSettings')

class hubaaa.EasyMeteorSettings

  instance = null

  @get: ->
    instance ?= new hubaaa.EasyMeteorSettings()

  constructor: (@settings = Meteor.settings)->
    try
      log.enter('constructor')
      @settings ?= {}
      @settings.public ?= {}
    finally
      log.return()

  getSetting: (name, defaultValue)->
    try
      log.enter('get')
      value = _.deep @settings, name
      value ?= _.deep @settings.public, name
      value ?= defaultValue
    finally
      log.return()

  getPrivateSetting: (name, defaultValue)->
    try
      log.enter('get')
      value = _.deep @settings, name
      value ?= defaultValue
    finally
      log.return()

  getPublicSetting: (name, defaultValue)->
    try
      log.enter('get')
      value = _.deep @settings.public, name
      value ?= defaultValue
    finally
      log.return()

  getRequiredSetting: (name)->
    try
      log.enter('getRequiredSetting')
      value = @getSetting(name)
      if not value?
        throw new Meteor.Error 'missing-required-meteor-setting', "'#{name}' doesn't exist in Meteor.settings or Meteor.settings.public"

      return value
    finally
      log.return()

  getRequiredPrivateSetting: (name)->
    try
      log.enter('get')
      value = @getPrivateSetting(name)
      if not value?
        throw new Meteor.Error 'missing-required-meteor-setting', "'#{name}' doesn't exist in Meteor.settings"

      return value
    finally
      log.return()

  getRequiredPublicSetting: (name)->
    try
      log.enter('get')
      value = @getPublicSetting(name)
      if not value?
        throw new Meteor.Error 'missing-required-meteor-setting', "'#{name}' doesn't exist in Meteor.settings.public"

      return value
    finally
      log.return()

@EasyMeteorSettings = hubaaa.EasyMeteorSettings.get()
