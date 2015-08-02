log = new ObjectLogger('VacationSchema', 'info')

try
  log.enter 'hubapp.VacationSchema'
  hubapp.VacationSchema = new SimpleSchema({
    userId:
      type: String
      autoValue: ->
        return @userId

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
  })

finally
  log.return()
