log = new ObjectLogger('hubaaa.JsonPipe', 'info')

class hubaaa.JsonPipe

  ###
  @param @options:
    filter:
      An optional filtering function that returns:
      false if doc should be dropped
      true if doc should be passed along the pipe
      undefined if it doesn't care about this specific doc
      Once we support multiple filters, if at least one filter returns false, doc will be dropped.
      Otherwise, at least one filter needs to return true for doc to pass
    transform:
      An optional transform function that returns the transformed document
    output:
      An optional output handler that received the "end product"
    outputCollection:
      An optional collection where to save the transformed / extended output in.
      Can be an existing Mongo.Collection or the name of the Mongo.Collection to create.
  @todo:
    1. Support filterCollection (as basis for data caching too)
    2. Support multiple filters, transformers and output handlers
    3. Support filters that are mongodb filter expressions to be applied on saved doc
    in filterCollection.
  ###
  constructor: (@options = {})->
    try
      log.enter('constructor', arguments)
      expect(@options).to.be.an 'object'
      expect(@options.filter).to.be.a('function') if @options.filter?
      expect(@options.transform).to.be.a('function') if @options.transform?
      expect(@options.process).to.be.a('function') if @options.process?

      if @options.outputCollection?
        if typeof @options.outputCollection is "string"
#          We need to create the collection
          @outputCollection = new Mongo.Collection @options.outputCollection
#       TODO: Support specifying ctor options for outputCollection
        else if @options.outputCollection instanceof Mongo.Collection
#          Got a ref to an existing collection
          @outputCollection = @options.outputCollection
    finally
      log.return()

  ###
  Pipes the doc through filters and transformers, eventually saving it in a collection
  and / or providing it to output handlers.
  First argument of call to filter / transform / process is always context, which is a new clean object for each call to pipe,
  where you can put whatever you want on it, for later steps in the pipe. We don't use this, because I don't want to mess up
  with the this of filters / transformers / processors. And in general, I don't like changing thises - non-split personalities is a good thing :)
  @return undefined, if doc was filtered or the (transformed) doc.
  ###
  pipe: (doc)->
    try
      log.enter('pipe', arguments)
      context = {}
      if @options.filter?
        pass = @options.filter(context, doc)
        return if pass is false
      if @options.transform?
        transformedDoc = @options.transform(context, doc)
        expect(transformedDoc).to.be.an 'object'
      if @outputCollection?
        transformedDoc._id = @outputCollection.insert transformedDoc
      if @options.process?
        @options.process(context, doc, transformedDoc)
      return transformedDoc
    finally
      log.return()
