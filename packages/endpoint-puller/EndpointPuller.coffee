log = new ObjectLogger('hubaaa.EndpointPuller', 'info')

# @todo:
# 1. Once we support webhooks too, move to composition / mixins, instead of pure inheritance.
# 2. This is a simplistic design that assumes we're running a single instance of the app.
# Once we move to a chronos / rq scheduler based distributed job scheduling infrastructure,
# every pull is a command line program that runs once, and before exiting,
# schedules the next pull job, according to config / rate limit response headers / etc.
class hubaaa.EndpointPuller extends hubaaa.JsonPipe

#  @endpoint: Absolute URL to endpoint
#  @httpOptions: Passed as is to meteor's HTTP.get
#  @pullOptions: Pull specific options:
#  @jsonPipeOptions: Passed up to JsonPipe
#  @todo:
#   1. Support either providing an already existing jsonPipe or an options doc to create a json pipe
  constructor: (@endpoint, @httpOptions = {}, @pullOptions = {}, @jsonPipeOptions = {})->
    try
      log.enter('constructor', arguments)
      super(@jsonPipeOptions)
      expect(@pullOptions).to.be.an 'object'
      @pullOptions.defaultPullInterval ?= EasyMeteorSettings.getSetting('packages.endpoint-puller.defaultPullInterval', 5000)
      expect(@pullOptions.defaultPullInterval).to.be.a('number').that.is.above(999)
    finally
      log.return()

# TODO: Standardize on time zone for all requests.
  pull: =>
    try
      log.enter('pull', arguments)
      delete @pullTimer if @pullTimer?
      result = HTTP.get @endpoint, @httpOptions
      if @httpOptions.headers['If-Modified-Since']?
        # No new events related to the user
        if result.statusCode is 304
          log.info 'Nothing changed.'
          @pullTimer = Meteor.setTimeout @pull, @pullOptions.defaultPullInterval
          return
      expect(result.statusCode).to.equal 200
      # TODO: Do this only if sendIfModifiedSince option is true
      # Apparently this http client is lowercasing http headers.
      if result.headers['last-modified']?
        # So next request will use it
        log.debug 'last-modified:', result.headers['last-modified']
        @httpOptions.headers['If-Modified-Since'] = result.headers['last-modified']
      else if @httpOptions.headers['If-Modified-Since']?
        # If we didn't get a last-modified header, we can't use an If-Modified-Since header
        log.debug 'Deleting If-Modified-Since header for next request.'
        delete @httpOptions.headers['If-Modified-Since']
      if _.isArray(result.data)
        for doc in result.data
          expect(doc).to.be.an 'object'
          processedDoc = @pipe(doc)
          log.fine 'processedDoc:', processedDoc
      else
        processedDoc = @pipe result.data
        log.debug 'processedDoc:', processedDoc
      log.debug 'defaultPullInterval:', @pullOptions.defaultPullInterval
      @pullTimer = Meteor.setTimeout @pull, @pullOptions.defaultPullInterval
    catch ex
      # So we continue trying
      log.error ex
      Meteor.setTimeout @pull, @pullOptions.defaultPullInterval if not @pullTimer?
    finally
      log.return()
