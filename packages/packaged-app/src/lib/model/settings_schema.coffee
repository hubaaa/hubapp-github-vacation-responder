log = new ObjectLogger('settings_schema', 'info')

Meteor.startup ->
  try
    log.enter 'hubapp.settings_schema'
    hubapp.settings_schema = new SimpleSchema
      _id:
        type: String
        optional: true

      dateRange: {
        type: [Date],
        label: "Your vacation dates:",
        optional: false,
        autoform: {
          type: "bootstrap-daterangepicker",
          dateRangePickerValue: moment().add(1, 'days').format("DD/MM/YYYY") + " - " + moment().add(3, 'days').format("DD/MM/YYYY"),
          dateRangePickerOptions: {
#            dateLimit: { days: 6 },
            minDate: moment(),
#            maxDate: moment().add(6, 'months'),
            startDate: moment().add(1, 'days'),
            endDate: moment().add(8, 'days'),
            timePicker: true,
            format: 'MM/DD/YYYY h:mm A',
            timePickerIncrement: 30,
            timePicker12Hour: false,
            timePickerSeconds: false
          }
        }
      }

      startDate:
        type: Date
        custom: ->
          if @value < Date.now()
            return "future-date-required"
    #    label: 'Start Date'
        autoform:
          afFieldInput:
            type: "bootstrap-datetimepicker"

      endDate:
        type: Date
        custom: ->
          if @value < @field('startDate').value
            return "invalid-date-range"
        autoform:
          afFieldInput:
            type: "bootstrap-datetimepicker"
    #    label: 'End Date'

      autoResponseText:
        type: String,
        label: "Your GitHub auto-response text:",
        min: 1
        max: 200
        autoform:
          rows: 3

    hubapp.settings_schema.messages
      "future-date-required": "Start date must be a future date."
      "invalid-date-range": "End date must be after start date."
  finally
    log.return()
