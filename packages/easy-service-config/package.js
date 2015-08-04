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
    'practicalmeteor:loglevel@1.2.0_2',
    'practicalmeteor:chai@2.1.0_1',
    'easy-meteor-settings'
  ], 'server');

  api.addFiles('EasyServiceConfig.coffee', 'server');
});

Package.onTest(function(api) {
  api.use([
    'underscore',
    'coffeescript',
    'practicalmeteor:mocha@2.1.0_1'
  ], 'server');

  api.use('tinytest');
  api.use('easy-service-config');

  api.addFiles('EasyServiceConfigTest.coffee', 'server');
});
