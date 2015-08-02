log = new ObjectLogger 'hubapp_user_settings'

@hubapp_user_settings = new Mongo.Collection 'hubapp_user_settings'

if Meteor.isServer
  hubapp_user_settings._ensureIndex { userId: 1 }, { unique: true }

#hubapp.UserSettingsSchema = new SimpleSchema
#  vacation:
#    type: hubapp.VacationSchema
#
hubapp_user_settings.attachSchema hubapp.VacationSchema

# All of this generic settings model, view and publication will be wrapped in a easily configurable package
if Meteor.isServer
  Meteor.publish 'hubapp_user_settings', ->
    log.info '@userId:', @userId
    log.info 'settings:', hubapp_user_settings.find( { userId: @userId } ).fetch()[0]
    return hubapp_user_settings.find( { userId: @userId } )

  hubapp_user_settings.allow
    insert: (userId, doc)->
      return false if not userId? or doc.userId isnt userId
      return hubapp.VacationSchema.newContext().validate doc

    update: (userId, doc, fields, modifier)->
      return doc.userId is userId
      # TODO: Need to validate changed doc, so we'll probably have to move to insert / update methods
      # instead of allow / deny functions
#      return hubapp.VacationSchema.newContext().validate doc

    remove: (userId, doc)->
      return doc.userId is userId
