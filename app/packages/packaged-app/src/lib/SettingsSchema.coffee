log = new ObjectLogger('SettingsSchema', 'info')

# We don't enforce start or end dates in the future, because people may create the auto-response
# after leaving on vacation, or even theday they return, and app will only generate comments for issues / comment
# after startDate
# Todo: When pulling for the first time, and if earliest event is after startDate ask for more events, until reaching startDate
Meteor.startup ->
  try
    log.enter 'hubapp.SettingsSchema'
    hubapp.SettingsSchema = new SimpleSchema
      _id:
        type: String
        optional: true

      startDate:
        type: Date

      endDate:
        type: Date
        custom: ->
          if @value < @field('startDate').value
            return "invalid-date-range"
          else if @value < Date.now()
            return "future-end-date-required"

      autoResponseText:
        type: String,
        label: "Your GitHub auto-response text:",
        min: 1
        max: 200

      disabled:
        type: Boolean
        optional: true

      repo:
        type: String
        optional: true


    hubapp.SettingsSchema.messages
      "invalid-date-range": "End date must be after start date."
  finally
    log.return()
