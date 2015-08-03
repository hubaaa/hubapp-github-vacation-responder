log = new ObjectLogger('VacationSchemaTest')

describe 'settings_schema', ->
    testContext = null

    beforeEach ->
      testContext = hubapp.settings_schema.newContext()

    it 'verifies startDate is a future date', ->
      testContext.validate
        startDate: moment().subtract(1, 'days').toDate()
        endDate: moment().add(1, 'days').toDate()
        autoResponseText: "I'm on vacation"
      expect(testContext.isValid()).to.be.false
      expect(testContext.invalidKeys()).to.be.an('array').that.has.length 1
      expect(testContext.invalidKeys()[0]).to.be.an('object')
      expect(testContext.invalidKeys()[0].name).to.equal 'startDate'
      log.info testContext.invalidKeys()[0].type

    it 'verifies endDate is after startDate', ->
      testContext.validate
        startDate: moment().add(7, 'days').toDate()
        endDate: moment().add(1, 'days').toDate()
        autoResponseText: "I'm on vacation"
      expect(testContext.isValid()).to.be.false
      expect(testContext.invalidKeys()).to.be.an('array').that.has.length 1
      expect(testContext.invalidKeys()[0]).to.be.an('object')
      expect(testContext.invalidKeys()[0].name).to.equal 'endDate'
      log.info testContext.invalidKeys()[0].type

    it 'requires autoResponseText', ->
      testContext.validate
        startDate: moment().add(1, 'days').toDate()
        endDate: moment().add(7, 'days').toDate()
        autoResponseText: ""
      expect(testContext.isValid()).to.be.false
      expect(testContext.invalidKeys()).to.be.an('array').that.has.length 1
      expect(testContext.invalidKeys()[0]).to.be.an('object')
      expect(testContext.invalidKeys()[0].name).to.equal 'autoResponseText'
      log.info testContext.invalidKeys()[0].type

    it 'validates valid object', ->
      testContext.validate
        startDate: moment().add(1, 'days').toDate()
        endDate: moment().add(7, 'days').toDate()
        autoResponseText: "I'm on vacation"
      expect(testContext.isValid()).to.be.true
