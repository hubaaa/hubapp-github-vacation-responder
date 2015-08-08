log = new ObjectLogger('VacationSchemaTest')

describe 'SettingsSchema', ->
    testContext = null

    beforeEach ->
      testContext = hubapp.SettingsSchema.newContext()

    it 'verifies endDate is after startDate', ->
      testContext.validate
        startDate: moment().add(7, 'days').toDate()
        endDate: moment().add(1, 'days').toDate()
        autoResponseText: "I'm on vacation"
      expect(testContext.isValid()).to.be.false
      expect(testContext.invalidKeys()).to.be.an('array').that.has.length 1
      expect(testContext.invalidKeys()[0]).to.be.an('object')
      expect(testContext.invalidKeys()[0].name).to.equal 'endDate'
      expect(testContext.invalidKeys()[0].type).to.equal 'invalid-date-range'

    it 'requires autoResponseText', ->
      testContext.validate
        startDate: moment().add(1, 'days').toDate()
        endDate: moment().add(7, 'days').toDate()
        autoResponseText: ""
      expect(testContext.isValid()).to.be.false
      expect(testContext.invalidKeys()).to.be.an('array').that.has.length 1
      expect(testContext.invalidKeys()[0]).to.be.an('object')
      expect(testContext.invalidKeys()[0].name).to.equal 'autoResponseText'
      expect(testContext.invalidKeys()[0].type).to.equal 'minString'

    it 'validates valid object', ->
      testContext.validate
        startDate: moment().add(1, 'days').toDate()
        endDate: moment().add(7, 'days').toDate()
        autoResponseText: "I'm on vacation"
      expect(testContext.isValid()).to.be.true
