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
    'meteor',
    'underscore',
    'coffeescript',
    'http',
    'mongo',
    'practicalmeteor:loglevel',
    'practicalmeteor:chai',
    'easy-meteor-settings',
    'practicalmeteor:underscore.string',
    'bruz:github-api'
  ]);


  api.addFiles('GitHubVacationResponder.coffee', 'server');
  api.addFiles('GitHubVacationResponderFactory.coffee', 'server');
});

Package.onTest(function(api) {
  api.use([
    'underscore',
    'coffeescript',
    'http',
    'practicalmeteor:loglevel',
    'practicalmeteor:chai',
    'bruz:github-api',
    'practicalmeteor:sinon',
    'practicalmeteor:mocha'
  ]);

  api.use('packaged-app');

  api.addFiles('GitHubVacationResponderTest.coffee', 'server');
});
