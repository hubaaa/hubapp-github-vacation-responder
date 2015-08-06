log = new ObjectLogger('VacationSchemaTest')

describe 'settings_schema', ->
    testContext = null

    beforeEach ->
      testContext = hubapp.settings_schema.newContext()

    it 'verifies startDate is a future date', ->
      testContext.validate
        dateRange: [moment().subtract(1, 'days').toDate(), moment().add(1, 'days').toDate()]
        autoResponseText: "I'm on vacation"
      expect(testContext.isValid()).to.be.false
      expect(testContext.invalidKeys()).to.be.an('array').that.has.length 1
      expect(testContext.invalidKeys()[0]).to.be.an('object')
      expect(testContext.invalidKeys()[0].name).to.equal 'dateRange'
      expect(testContext.invalidKeys()[0].type).to.equal 'future-date-required'

    it 'verifies endDate is after startDate', ->
      testContext.validate
        dateRange: [moment().add(7, 'days').toDate(), moment().add(1, 'days').toDate()]
        autoResponseText: "I'm on vacation"
      expect(testContext.isValid()).to.be.false
      expect(testContext.invalidKeys()).to.be.an('array').that.has.length 1
      expect(testContext.invalidKeys()[0]).to.be.an('object')
      expect(testContext.invalidKeys()[0].name).to.equal 'dateRange'
      expect(testContext.invalidKeys()[0].type).to.equal 'invalid-date-range'

    it 'requires autoResponseText', ->
      testContext.validate
        dateRange: [moment().add(1, 'days').toDate(), moment().add(7, 'days').toDate()]
        autoResponseText: ""
      expect(testContext.isValid()).to.be.false
      expect(testContext.invalidKeys()).to.be.an('array').that.has.length 1
      expect(testContext.invalidKeys()[0]).to.be.an('object')
      expect(testContext.invalidKeys()[0].name).to.equal 'autoResponseText'
      expect(testContext.invalidKeys()[0].type).to.equal 'minString'

    it 'validates valid object', ->
      testContext.validate
        dateRange: [moment().add(1, 'days').toDate(), moment().add(7, 'days').toDate()]
        autoResponseText: "I'm on vacation"
      expect(testContext.isValid()).to.be.true
