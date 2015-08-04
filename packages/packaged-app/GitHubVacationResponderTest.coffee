log = new ObjectLogger('GitHubVacationResponderTest', 'debug')

describe 'GitHubVacationResponder', ->

  responder = null

  userId = Random.id()

  defaultTestUser =
    _id: userId
    services:
      github:
        username: 'testuser'
        accessToken: 'myAccessToken'

  testUser = null

  defaultAppSettings =
    _id: userId
    startDate: null
    endDate: null
    autoResponseText: "I'm on vacation."

  appSettings = null

  beforeEach ->
    stubs.restoreAll()
    spies.restoreAll()
    # We clone so we don't have unit test side effects
    testUser = EJSON.clone defaultTestUser
    appSettings = EJSON.clone defaultAppSettings

  afterEach ->
    stubs.restoreAll()
    spies.restoreAll()

  describe 'constructor', ->
    it 'properly initializes all member fields', (done)->
      try
        log.enter 'properly initializes all member fields'
        appSettings.startDate = moment().add(1, 'days').toDate()
        appSettings.endDate = moment().add(7, 'days').toDate()
        responder = new hubaaa.GitHubVacationResponder(testUser, appSettings)
        expect(responder.user).to.deep.equal testUser
        expect(responder.appSettings).to.deep.equal appSettings
        expect(responder.username).to.equal 'testuser'
        expect(responder.accessToken).to.equal 'myAccessToken'
        expect(responder.endpoint).to.equal "https://api.github.com/users/testuser/received_events"
        expect(responder.httpOptions).to.deep.equal
          headers:
            "Authorization": "token myAccessToken"
            "Accept": "application/vnd.github.v3+json"
            "User-Agent": EasyMeteorSettings.getRequiredSetting('appName')
        expect(responder.pullOptions.sendIfModifiedSinceHeader).to.be.true
        expect(responder.jsonPipeOptions).to.deep.equal
          filter: responder.filter
          transform: responder.transform
          process: responder.process
        expect(@pullTimer).to.be.undefined
        expect(@startTimer).to.be.undefined
        expect(@stopTimer).to.be.undefined
        done()
      catch err
        done(err)
      finally
        log.return()

    it 'to different values between calls too (coffee bug)', (done)->
      try
        log.enter 'to different values between calls too (coffee bug)'
        testUser.services.github.username = 'testuser2'
        appSettings.startDate = moment().add(2, 'days').toDate()
        appSettings.endDate = moment().add(4, 'days').toDate()
        responder = new hubaaa.GitHubVacationResponder(testUser, appSettings)
        expect(responder.user).to.deep.equal testUser
        expect(responder.appSettings).to.deep.equal appSettings
        expect(responder.username).to.equal 'testuser2'
        expect(responder.accessToken).to.equal 'myAccessToken'
        expect(responder.endpoint).to.equal "https://api.github.com/users/testuser2/received_events"
        expect(responder.httpOptions).to.deep.equal
          headers:
            "Authorization": "token myAccessToken"
            "Accept": "application/vnd.github.v3+json"
            "User-Agent": EasyMeteorSettings.getRequiredSetting('appName')
        expect(responder.pullOptions.sendIfModifiedSinceHeader).to.be.true
        expect(responder.jsonPipeOptions).to.deep.equal
          filter: responder.filter
          transform: responder.transform
          process: responder.process
        done()
      catch err
        done(err)
      finally
        log.return()

    describe 'init', ->
      it 'starts immediately if startDate is due, calls stop and cleans timers on stop', (done)->
        try
          log.enter 'starts immediately if startDate is due, calls stop and cleans timers on stop'
          appSettings.startDate = moment().subtract(1, 'seconds').toDate()
          appSettings.endDate = moment().add(200, 'milliseconds').toDate()
          responder = new hubaaa.GitHubVacationResponder(testUser, appSettings)
          stubs.create('GET', HTTP, 'get').returns
            statusCode: 200
            data: {}
            headers: {}
          spies.create 'pull', responder, 'pull'
          spies.create 'setTimeout', Meteor, 'setTimeout'
          spies.create 'start', responder, 'start'
          spies.create 'stop', responder, 'stop'
          responder.init()
          expect(spies.start).to.have.been.called
          expect(spies.pull).to.have.been.called
          expect(spies.setTimeout).to.have.been.calledTwice
          expect(spies.stop).to.have.not.been.called
          expect(responder.startTimer, 'startTimer').to.be.undefined
          expect(responder.pullTimer, 'pullTimer').to.be.ok
          expect(responder.stopTimer, 'stopTimer').to.be.ok
          Meteor.setTimeout ->
            try
              expect(spies.stop).to.have.been.called
              expect(responder.startTimer, 'startTimer').to.be.undefined
              expect(responder.pullTimer, 'pullTimer').to.be.undefined
              expect(responder.stopTimer, 'stopTimer').to.be.undefined
              done()
            catch ex
              done(ex)
          , 100
          done()
        catch err
          done(err)
        finally
          log.return()

    describe 'init', ->
      it 'schedules start if startDate is in the future, calls stop and cleans timers on stop', (done)->
        try
          log.enter 'schedules start if startDate is in the future, calls stop and cleans timers on stop'
          appSettings.startDate = moment().add(100, 'seconds').toDate()
          appSettings.endDate = moment().add(300, 'milliseconds').toDate()
          responder = new hubaaa.GitHubVacationResponder(testUser, appSettings)
          stubs.create('GET', HTTP, 'get').returns
            statusCode: 200
            data: {}
            headers: {}
          spies.create 'pull', responder, 'pull'
          spies.create 'setTimeout', Meteor, 'setTimeout'
          spies.create 'start', responder, 'start'
          spies.create 'stop', responder, 'stop'
          responder.init()
          expect(spies.start).to.have.not.been.called
          expect(spies.pull).to.have.not.been.called
          expect(spies.setTimeout).to.have.been.calledTwice
          expect(spies.stop).to.have.not.been.called
          expect(responder.startTimer, 'startTimer').to.be.ok
          expect(responder.pullTimer, 'pullTimer').to.be.undefined
          expect(responder.stopTimer, 'stopTimer').to.be.ok
          Meteor.setTimeout ->
            try
              expect(spies.start).to.have.been.called
              expect(responder.pullTimer, 'pullTimer').to.be.ok
            catch ex
              done(ex)
          , 200
          Meteor.setTimeout ->
            try
              expect(spies.stop).to.have.been.called
              expect(responder.startTimer, 'startTimer').to.be.undefined
              expect(responder.pullTimer, 'pullTimer').to.be.undefined
              expect(responder.stopTimer, 'stopTimer').to.be.undefined
              done()
            catch ex
              done(ex)
          , 400
          done()
        catch err
          done(err)
        finally
          log.return()
