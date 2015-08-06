log = new ObjectLogger('hubapp_user_settings', 'debug')

hubapp_user_settings_transform = (doc)->
  try
    log.enter 'transform', arguments
    expect(doc.dateRange).to.be.an('array').that.has.length 2
    doc.startDate = doc.dateRange[0]
    doc.endDate = doc.dateRange[1]
    return doc
  finally
    log.return()

@hubapp_user_settings = new Mongo.Collection 'hubapp_user_settings', transform: hubapp_user_settings_transform


# Do to a collection2 bug that removes startDate end endDate for some reason on upsert, we don't attach the schema
# to the collection. The meteor method is doing the validation anyway
#hubapp_user_settings.attachSchema hubapp.settings_schema, replace: true

hubapp_user_settings.allow
  remove: (userId, doc)->
    try
      log.enter 'allow.remove', userId, doc
      return userId? and userId is doc._id
    finally
      log.return()
