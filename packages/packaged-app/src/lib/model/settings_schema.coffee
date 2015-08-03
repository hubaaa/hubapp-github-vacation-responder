log = new ObjectLogger('settings_schema', 'info')

try
  log.enter 'hubapp.settings_schema'
  hubapp.settings_schema = new SimpleSchema
    _id:
      type: String
      optional: true

    startDate:
      type: Date
      custom: ->
        if @value < Date.now()
          return "Start date must be a future date."
  #    label: 'Start Date'
      autoform:
        afFieldInput:
          type: "bootstrap-datetimepicker"

    endDate:
      type: Date
      custom: ->
        if @value < @field('startDate').value
          return "Start date must be a future date."
      autoform:
        afFieldInput:
          type: "bootstrap-datetimepicker"
  #    label: 'End Date'

    autoResponseText:
      type: String,
      label: "Auto-Response Text",
      min: 1
      max: 200
      autoform:
        rows: 3

finally
  log.return()
