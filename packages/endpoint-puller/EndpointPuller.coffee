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
      @pullOptions.defaultInterval ?= EasyMeteorSettings.getSetting(defaultPullInterval, 5000)
      expect(@pullOptions.defaultInterval).to.be.a('number').that.is.above(999)
      @pull()
    finally
      log.return()

  pull: ->
    try
      log.enter('pull', arguments)
      result = HTTP.get @endpoint, @httpOptions
      log.info result.data
    finally
      log.return()
