describe 'EasyMeteorSettings', ->
  describe 'getSetting', ->
    it 'returns setting', ->
      settings = new hubaaa.EasyMeteorSettings
        loglevel: 'debug'

      expect(settings.getSetting('loglevel')).to.equal 'debug'

    it "returns public setting, if private one doesn't exist", ->
      settings = new hubaaa.EasyMeteorSettings
        public:
          loglevel: 'trace'

      expect(settings.getSetting('loglevel')).to.equal 'trace'

    it 'returns defaultValue', ->
      settings = new hubaaa.EasyMeteorSettings()

      expect(settings.getSetting('loglevel', 'info')).to.equal 'info'

    it 'returns deep settings', ->
      settings = new hubaaa.EasyMeteorSettings
        serviceConfigurations:
          github:
            apiKey: 'xxx'

      expect(settings.getSetting('serviceConfigurations.github.apiKey')).to.equal 'xxx'

  describe 'getPrivateSetting', ->
    it 'returns setting', ->

      settingsObject =
        serviceConfigurations:
          github:
            apiKey: 'xxx'
            secret: 'yyy'

      settings = new hubaaa.EasyMeteorSettings settingsObject

      expect(settings.getSetting('serviceConfigurations')).to.deep.equal settingsObject.serviceConfigurations
