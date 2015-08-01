describe 'GitHubVacationResponder', ->
  describe 'constructor', ->
    @timeout(10000)
    it 'works', (done)->
      try
        user = Meteor.users.findOne { "services.github.username": "rbabayoff" }
        expect(user?).to.be.true
        expect(user.services?.github?.accessToken?).to.be.true

        responder = new hubaaa.GitHubVacationResponder(user)
        done()
      catch err
        done(err)
