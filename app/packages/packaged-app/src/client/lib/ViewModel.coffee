# We extend template with the ability to use classes instead of POJOs (plain old js objects) for the view model object
Template.prototype.ViewModel = (viewModelClass, name)->

  viewModel = viewModelClass.prototype
  viewModelHelpers = Object.getOwnPropertyNames(viewModel)
  # All properties (primitives, objects or functions) that don't start with an _ become template helpers too.
  # The ones that start with _ are view model specific.
  viewModelHelpers = _.filter(viewModelHelpers, (p)-> p.indexOf("_") != 0 and p isnt 'constructor')
  if name
    @viewmodel(name, viewModel, viewModelHelpers)
  else
    @viewmodel(viewModel, viewModelHelpers)
