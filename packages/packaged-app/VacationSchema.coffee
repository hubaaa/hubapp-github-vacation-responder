VacationSchema = new SimpleSchema
  startDate:
    type: Date
#    label: 'Start Date'

  endDate:
    type: Date
#    label: 'End Date'

  autoResponseText:
    type: String,
    label: "Auto-Response Text",
    max: 200
