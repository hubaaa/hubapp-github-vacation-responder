describe 'GitHubVacationResponder', ->
  describe 'constructor', ->
    it 'works', ->

      user = Meteor.users.findOne { "services.github.username": "rbabayoff" }
      expect(user?).to.be.true
      expect(user.services?.github?.accessToken?).to.be.true

      responder = new hubaaa.GitHubVacationResponder(user)
