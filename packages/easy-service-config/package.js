Package.describe({
  name: 'easy-service-config',
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
    'service-configuration',
    'practicalmeteor:loglevel',
    'practicalmeteor:chai',
    'easy-meteor-settings'
  ], 'server');

  api.addFiles('EasyServiceConfig.coffee', 'server');
});

Package.onTest(function(api) {
  api.use([
    'underscore',
    'coffeescript',
    'practicalmeteor:loglevel',
    'practicalmeteor:chai',
    'practicalmeteor:sinon'
  ], 'server');

  api.use('tinytest');
  api.use('easy-service-config');

  api.addFiles('EasyServiceConfigTest.coffee', 'server');
});
