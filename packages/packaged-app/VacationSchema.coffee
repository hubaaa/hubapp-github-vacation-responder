log = new ObjectLogger('VacationSchema', 'info')

try
  log.enter 'hubapp.VacationSchema'
  hubapp.VacationSchema = new SimpleSchema({
    startDate:
      type: Date
      custom: ->
        if @value < Date.now()
          return "Start date must be a future date."
  #    label: 'Start Date'

    endDate:
      type: Date
      custom: ->
        if @value < @field('startDate').value
          return "Start date must be a future date."
  #    label: 'End Date'

    autoResponseText:
      type: String,
      label: "Auto-Response Text",
      min: 1
      max: 200
  })

finally
  log.return()
