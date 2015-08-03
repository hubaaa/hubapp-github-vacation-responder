log = new ObjectLogger('hubapp_user_settings', 'debug')

@hubapp_user_settings = new Mongo.Collection 'hubapp_user_settings'

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
