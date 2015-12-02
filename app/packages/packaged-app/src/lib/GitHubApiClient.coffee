log = new ObjectLogger('hubaaa.GitHubApiClient', 'debug')


class hubaaa.GitHubApiClient


  instance = null

  @get: ->
    instance ?= new hubaaa.GitHubApiClient
    return instance


  constructor: ->
    try
      log.enter('constructor', arguments)

      @endpoint = 'https://api.github.com'

      @httpOptions = {
        headers:
          'User-Agent': 'Github api meteor client'
      }

    finally
      log.return()


  _request: (method, path, callback)->
    try
      log.enter('_get', arguments)

      expect(path).to.be.a('string').that.is.ok
      url = @endpoint + path
      HTTP.call method, url, @httpOptions, callback

    finally
      log.return()


  getUserRepos: (username, callback)->
    try
      log.enter('getUserRepos', arguments)

      expect(username).to.be.a('string').that.is.ok

      path = "/users/#{username}/repos"
      @_request 'GET', path, (err, result)->


        # TODO wrap errors
        if err
          callback err
          return

        repos = [{name: 'All'}]
        for repo in result.data
          repos.push {
            name: repo.name
          }

        log.debug 'repos:', repos
        callback undefined, repos

    finally
      log.return()


Meteor.startup ->
  hubaaa.GitHubApiClient.get()

