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
    'less@2.5.1',
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
    'hubaaa:easy-meteor-settings',
    'practicalmeteor:underscore.string',
    'twbs:bootstrap',
    'ian:accounts-ui-bootstrap-3@1.2.76',
    'tsega:bootstrap3-datetimepicker@3.1.3_3',
    'aldeed:simple-schema@1.3.3',
    'ovcharik:alertifyjs@1.4.1',
    'rbabayoff:bootstrap-daterangepicker@2.0.6_1',
    'manuel:viewmodel@1.8.9',
    'gadicohen:reactive-window@1.0.6',
    'hubaaa:json-pipes@0.1.1',
    'hubaaa:endpoint-puller',
    'bruz:github-api'
  ]);

  api.imply([
    'meteor-platform',
    'manuel:viewmodel@1.8.9'
  ]);

  if(process.env.ACCOUNTS_PASSWORD === "1")
  {
    api.use('accounts-password');
    api.imply('accounts-password');
  } else if (process.env.METEOR_TEST_PACKAGES !== "1") {
    api.use('force-ssl');
    api.imply('force-ssl');
  }

  if (process.env.METEOR_TEST_PACKAGES !== "1") {
    api.use('manuel:viewmodel-explorer@1.0.5');
    api.imply('manuel:viewmodel-explorer@1.0.5');
  }

  api.addFiles([
    'src/client/lib/bootstrap-toggle-2.2.1.css',
    'src/client/lib/bootstrap-toggle-2.2.1.js'
  ], 'client');

  api.addFiles('src/client/lib/ViewModel.coffee', 'client');
  api.addFiles('src/lib/namespace.coffee');
  api.addFiles('src/lib/SettingsSchema.coffee');
  api.addFiles('src/lib/SettingsModel.coffee');
  api.addFiles('src/lib/GitHubApiClient.coffee');
  api.addFiles('src/server/lib/SettingsServer.coffee', 'server');
  api.addFiles([
    'src/client/Accounts.ui.config.coffee',
    'src/client/hubapp_user_settings.html',
    'src/client/hubapp_user_settings.coffee',
    'src/client/disableAppToggle.html',
    'src/client/disableAppToggle.coffee',
    'src/client/nav.html',
    'src/client/nav.coffee',
    'src/client/footer.html',
    'src/client/layout.html',
    'src/client/layout.coffee',
    'src/client/main.less',
    'src/client/main.html'
    ], 'client');

  api.addFiles([
    'src/server/GitHubVacationResponder.coffee',
    'src/server/GitHubVacationResponderFactory.coffee'
  ], 'server');
});

Package.onTest(function(api) {
  api.use([
    'underscore',
    'coffeescript',
    'http',
    //'bruz:github-api',
    'practicalmeteor:mocha@2.1.0_3',
    'momentjs:moment',
    'random',
    'ejson'
  ]);

  api.use('packaged-app');

  api.addFiles('tests/lib/SettingSchemaTest.coffee');
  api.addFiles('tests/server/GitHubVacationResponderTest.coffee', 'server');
});
