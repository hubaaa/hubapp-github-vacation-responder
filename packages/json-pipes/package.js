Package.describe({
  name: 'json-pipes',
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
    'practicalmeteor:loglevel@1.2.0_2',
    'practicalmeteor:chai@2.1.0_1',
    'easy-meteor-settings'
  ]);

  api.addFiles('JsonPipe.coffee');
});

Package.onTest(function(api) {
  api.use([
    'underscore',
    'coffeescript',
    'practicalmeteor:mocha@2.1.0_1'
  ]);

  api.use('json-pipes');

  api.addFiles('JsonPipeTest.coffee');
});
