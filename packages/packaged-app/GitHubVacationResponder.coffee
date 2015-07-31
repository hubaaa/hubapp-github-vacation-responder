log = new ObjectLogger('hubaaa.GitHubVacationResponder', 'debug')

githubIssues = new Mongo.Collection "github.issues"
githubIssues._ensureIndex { id: 1 }, { unique: true }
githubIssues._ensureIndex { 'repo.owner': 1 }

class hubaaa.GitHubVacationResponder extends hubaaa.EndpointPuller

  ###
  @param @endpoint - Absolute URL to endpoint
  @httpOptions - Passed as is to meteor's HTTP.get
  @pullOptions - Pull specific options:
  ###
  constructor: (@user)->
    try
      log.enter('constructor', arguments)

#      @user = Meteor.users.findOne { "services.github.username": @username }
      expect(@user?).to.be.true
      expect(@user.services.github.username).to.be.ok
      expect(@user.services.github.accessToken).to.be.ok

      @username = @user.services.github.username
      @accessToken = @user.services.github.accessToken

      @github = new GitHub
        # required
        version: "3.0.0"
        # optional
#        debug: true,
#        protocol: "https"
#        host: "api.github.com"
        timeout: 10000
        headers:
          "User-Agent": "Ronen.Hubaaa" # GitHub is happy with a unique user agent

      @github.authenticate
        type: "oauth"
        token: @accessToken

      endpoint = "https://api.github.com/users/#{@username}/received_events"

      @httpOptions =
        headers:
          "Authorization": "token #{@accessToken}"
          "Accept": "application/vnd.github.v3+json"
          "User-Agent": "Ronen.Hubaaa"

      jsonPipeOptions =
        filter: @filter
        transform: @transform
        onOutput: @onOutput

      super(endpoint, httpOptions, {}, jsonPipeOptions)
    finally
      log.return()

# Only thing that passes through are new issues in the user's
# personal repos, and where a vacation auto-response has not been posted yet.
# @TODO:
# 1. Support issue comments
# 2. Support pull requests and pull request comments
# 3. Only auto-responding if actually on vacation
  filter: (event)=>
    try
      log.fineEnter('filter', event)
      return false if event.type isnt "IssuesEvent"
      return false if _s.startsWith(event.repo.name, "#{@username}/") isnt true
      return false if event.payload.action isnt "opened"
      issue = githubIssues.findOne {id: event.payload.id}
      return false if issue? # Already responded on this issue
    finally
      log.fineReturn()

  transform: (event)=>
    try
      log.enter('transform')
      issue = _.pick event.payload, 'id', 'number', 'url', 'comments_url', 'html_url'
      # Some fields we pick for debugging purposes only
      issue.repo =
        owner: @username
#       name: # TODO: figure it out
      log.info 'issue:', issue
      return issue
    finally
      log.return()

  onOutput: (issue)=>
    try
      log.enter('outputHandler')
      expect(issue.comments_url).to.be.ok
      comment =
        body: "Hubaaa: I'm on vacation :-)"

      postHttpOptions = EJSON.clone(@httpOptions)
      postHttpOptions.data = comment

      result = HTTP.post issue.comments_url, postHttpOptions

      log.info 'result:', result

      issue.metafields =
        # Every app will get it's own namespace under metafields eventually
        "github-vacation-responder": _.pick result, 'created_at', 'url', 'html_url', 'body'
        # @TODO: Support multiple vacations during the open lifetime of the same issue

      log.info 'issue:', issue

      issue._id = githubIssues.insert issue
      return issue
    finally
      log.return()
