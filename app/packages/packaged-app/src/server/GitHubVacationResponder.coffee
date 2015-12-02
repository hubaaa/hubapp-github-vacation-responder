log = new ObjectLogger('hubaaa.GitHubVacationResponder', 'debug')

githubIssues = new Mongo.Collection "github.issues"
githubIssues._ensureIndex { id: 1 }, { unique: true }
githubIssues._ensureIndex { html_url: 1 }, { unique: true }
githubIssues._ensureIndex { 'repo.owner': 1 }

class hubaaa.GitHubVacationResponder extends hubaaa.EndpointPuller

  ###
  @param @endpoint - Absolute URL to endpoint
  @httpOptions - Passed as is to meteor's HTTP.get
  @pullOptions - Pull specific options:
  ###
  constructor: (@user, @appSettings)->
    try
      log.enter('constructor', arguments)

#      @user = Meteor.users.findOne { "services.github.username": @username }
      expect(@user?).to.be.true
      expect(@user.services.github.username).to.be.ok
      expect(@user.services.github.accessToken).to.be.ok
      expect(@appSettings?).to.be.true
      expect(@appSettings.startDate).to.be.an.instanceof Date
      expect(@appSettings.endDate).to.be.an.instanceof Date
      expect(@appSettings.autoResponseText).to.be.a('string').that.is.ok

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
          "User-Agent": EasyMeteorSettings.getRequiredSetting('appName') # GitHub is happy with a unique user agent that matches the app name

      @github.authenticate
        type: "oauth"
        token: @accessToken

      endpoint = "https://api.github.com/users/#{@username}/received_events"

      httpOptions =
        headers:
          "Authorization": "token #{@accessToken}"
          "Accept": "application/vnd.github.v3+json"
          "User-Agent": EasyMeteorSettings.getRequiredSetting('appName')

      jsonPipeOptions =
        filter: @filter
        transform: @transform
        process: @process

      super(endpoint, httpOptions, sendIfModifiedSinceHeader: true, jsonPipeOptions)
    finally
      log.return()


  init: =>
    try
      log.enter('init')

      if @startTimer?
        try
          Meteor.clearTimeout @startTimer
        catch ex
          log.error ex
        delete @startTimer

      if @stopTimer?
        try
          Meteor.clearTimeout @stopTimer
        catch ex
          log.error ex
        delete @stopTimer

      return if @appSettings.endDate.valueOf() <= Date.now()

      # Let's first create the stop timer, in case the start timer throws an exception
      stopDelay = @appSettings.endDate.valueOf() - Date.now()
      @stopTimer = Meteor.setTimeout @stop, stopDelay

      if @appSettings.startDate.valueOf() <= Date.now()
        # Start immediately
        @start()
        return

      startDelay = @appSettings.startDate.valueOf() - Date.now()
      @startTimer = Meteor.setTimeout @start, startDelay
      return
    finally
      log.return()


  start: =>
    try
      log.enter 'start'
      @pull()
    finally
      log.return()


  stop: =>
    try
      log.enter 'stop'
      # This is the EndpointPuller pull timeout
      if @pullTimer?
        try
          Meteor.clearTimeout @pullTimer
        catch ex
          log.error ex
        delete @pullTimer
    finally
      log.return()


# Only thing that passes through are new issues in the user's
# personal repos, and where a vacation auto-response has not been posted yet.
# @TODO:
# 1. Support issue comments
# 2. Support pull requests and pull request comments
# 3. Only auto-responding if actually on vacation
  filter: (context, event)=>
    try
      log.fineEnter('filter', event)
      expect(event.created_at).to.be.ok
      created_at = new Date(event.created_at)
      expect(created_at).to.be.ok

      return false if created_at.valueOf() < @appSettings.startDate.valueOf()

      if @appSettings.repo? and @appSettings.repo isnt 'All'
        return false if event.repo.name isnt "#{@username}/" + @appSettings.repo

      if event.type is "IssuesEvent"
        return false if event.payload.action not in ["opened", 'reopened']
        html_url = event.payload.issue.html_url
      else if event.type is "IssueCommentEvent"
        # PR comments also fire this event, and payload is issue, not pull_request
        html_url = event.payload.issue.html_url
      else if event.type is "PullRequestEvent"
        return false if event.payload.action not in ['opened', 'reopened', 'synchronize']
        html_url = event.payload.pull_request.html_url
      else
        return false

      return false if _s.startsWith(event.repo.name, "#{@username}/") isnt true

      log.info 'event:', event

      issue = githubIssues.findOne { html_url: html_url }
      return false if issue? # Already responded on this issue

      return true
    finally
      log.fineReturn()

  transform: (context, event)=>
    try
      log.enter('transform', event)
      if event.payload.issue?
        issueType = 'issue'
      else if event.payload.pull_request?
        issueType = "pull_request"
      else
        log.warn 'event:', event
        throw event

      issue = _.pick event.payload[issueType], 'id', 'number', 'url', 'comments_url', 'html_url'
      # Some fields we pick for debugging purposes only
      issue.type = issueType
      issue.repo =
        owner: @username
#       name: # TODO: figure it out
      log.info 'issue:', issue
      return issue
    finally
      log.return()

  process: (context, event, issue)=>
    try
      log.enter('outputHandler')
      expect(event.actor.login).to.be.ok
      expect(issue.comments_url).to.be.ok

      comment =
        body: "Hey @#{event.actor.login},\n\n#{@appSettings.autoResponseText}\n\nThis comment was automatically generated by Hubaaa's [GitHub Vacation Responder](#{Meteor.absoluteUrl()}) app."
#        body: "Hey @#{event.actor.login},\n\n#{@appSettings.autoResponseText}\n\nThis comment was automatically generated by [Hubaaa's](http://hubaaa.com) [GitHub Vacation Responder](http://hubaaa.com/apps/github-vacation-responder) app."

      postHttpOptions = EJSON.clone(@httpOptions)
      postHttpOptions.data = comment

      result = HTTP.post issue.comments_url, postHttpOptions

      log.info 'result:', result

      issue.metafields =
        # Every app will get it's own namespace under metafields eventually
        "github-vacation-responder": _.pick result.data, 'created_at', 'url', 'html_url', 'body'
        # @TODO: Support multiple vacations during the open lifetime of the same issue

      log.info 'issue:', issue

      issue._id = githubIssues.insert issue
      return issue
    finally
      log.return()
