log = new ObjectLogger('GitHubVacationResponderTest', 'debug')

describe.skip 'GitHubVacationResponder', ->
  describe 'constructor', ->
    @timeout(10000)
    it 'works', (done)->
      try
        log.enter 'works'
        user = Meteor.users.findOne { "services.github.username": "rbabayoff" }
        expect(user?).to.be.true
        expect(user.services?.github?.accessToken?).to.be.true

        responder = new hubaaa.GitHubVacationResponder(user)
        done()
      catch err
        done(err)
      finally
        log.return()
