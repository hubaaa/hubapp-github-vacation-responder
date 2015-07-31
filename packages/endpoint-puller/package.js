Package.describe({
  name: 'endpoint-puller',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.1.0.2');
  api.use([
    'meteor',
    'underscore',
    'coffeescript',
    'http',
    'practicalmeteor:loglevel',
    'practicalmeteor:chai',
    'easy-meteor-settings',
    'json-pipes'
  ], 'server');

  api.addFiles('EndpointPuller.coffee', 'server');
});

Package.onTest(function(api) {
  api.use([
    'underscore',
    'coffeescript',
    'practicalmeteor:loglevel',
    'practicalmeteor:chai',
    'practicalmeteor:sinon',
    'practicalmeteor:mocha'
  ], 'server');

  api.use('endpoint-puller', 'server');

  api.addFiles('EndpointPullerTest.coffee', 'server');
});
