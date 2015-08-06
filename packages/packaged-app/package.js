Package.describe({
  name: 'packaged-app',
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
    'meteor-platform',
    'underscore',
    'coffeescript',
    'http',
    'mongo',
    'templating',
    'random',
    'ejson',
    'reactive-var',
    'accounts-github',
    'momentjs:moment',
    'practicalmeteor:loglevel@1.2.0_2',
    'practicalmeteor:chai@2.1.0_1',
    'easy-meteor-settings',
    'practicalmeteor:underscore.string',
    'twbs:bootstrap',
    'ian:accounts-ui-bootstrap-3@1.2.76',
    'tsega:bootstrap3-datetimepicker@3.1.3_3',
    'antalakas:autoform-bs-daterangepicker@2.0.6_1',
    'aldeed:simple-schema@1.3.3',
    //'aldeed:collection2@2.3.3',
    'aldeed:autoform@5.3.1',
    'aldeed:autoform-bs-datetimepicker@1.0.6',
    'ovcharik:alertifyjs@1.4.1',
    'json-pipes',
    'endpoint-puller',
    'bruz:github-api'
  ]);


  api.imply('meteor-platform');

  api.addFiles('src/lib/namespace.coffee');
  api.addFiles('src/lib/model/settings_schema.coffee');
  api.addFiles('src/lib/model/settings_collection.coffee');
  api.addFiles('src/server/lib/model/settings_collection.coffee', 'server');
  api.addFiles([
    'src/client/hubapp_user_settings.html',
    'src/client/hubapp_user_settings.coffee'
    ], 'client');
  api.addFiles('GitHubVacationResponder.coffee', 'server');
  api.addFiles('GitHubVacationResponderFactory.coffee', 'server');
});

Package.onTest(function(api) {
  api.use([
    'underscore',
    'coffeescript',
    'http',
    //'bruz:github-api',
    'practicalmeteor:mocha@2.1.0_1',
    'momentjs:moment',
    'random',
    'ejson'
  ]);

  api.use('packaged-app');

  api.addFiles('VacationSchemaTest.coffee');
  api.addFiles('GitHubVacationResponderTest.coffee', 'server');
});
