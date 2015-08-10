# Development & Contribution Guide

## Prerequisites

This is a [meteor](https://www.meteor.com/) app, so basic knowledge of meteor is required. Meteor is a full stack JavaScript only web application platform. Dealing with technology all my life, and with meteor extensively in the past few years, I have been repetitively proven that meteor significantly cuts web app development time :-)

Since this app uses GitHub oauth authorization, you will need to:

1. Create a GitHub developer application.

2. Use some kind of http tunneling solution to be able to expose your local app to the Internet so Sign-In with GitHub will work. This guide will provide you instructions on using [ngrok](https://ngrok.com/), but there are other [solutions](http://john-sheehan.com/blog/a-survey-of-the-localhost-proxying-landscape) out there.

Also, if you're a team of developers (and as a rule of thumb in general), I recommend following [The Twelve-Factor App](http://12factor.net/) principles religiously in development environments too, so every developer has it's own completely separate environment, including separate domains, DBs, accounts, services, github developer apps, etc.

## Installation & Configuration

### Clone the app's repo

```
git clone git@github.com:rbabayoff/hubaaa-github-vacation-responder.git
```

Or using https:

```
https://github.com/rbabayoff/hubaaa-github-vacation-responder.git
```

### Configure ngrok

#### Install

The ngrok binary is already included in this repo's bin folder. In the future, I'll move the ngrok dependency to a docker ngrok image or an npm package that downloads and installs ngrok.

#### Sign-Up

Create an account at [ngrok](https://dashboard.ngrok.com/user/login).

Once created, I recommend that you get on a paid plan, so you can reserve an http tunneling subdomain under ngrok.io. If not, and if the subdomain you usually use is used by someone else, you will need to change your GitHub developer app URLs. Not a biggy and the URLs update immediately, though.

#### Create the ngrok.yml file

After you signed-in to ngrok for the first time, you will need to add your ngrok authtoken to your development environment. It's a one-time setup. Just copy the command from you dashboard [here](https://dashboard.ngrok.com/). It should be something like:

```
ngrok authtoken yourAuthToken
```

This will create a `ngrok.yml` file at `$HOME/.ngrok2` where your authtoken will be stored.

#### Reserve a sub-domain

If you already have or decided to get on a paid plan, reserve a subdomain for yourself under ngrok.io [here](https://dashboard.ngrok.com/reserved). I usually like to use my github username as this subdomain, so my local app will be accessible at:

https://rbabayoff.ngrok.io/

#### How-to run ngrok

Since meteor runs on port 3000 by default, you will need to start ngrok as follows before starting your app:

```
# From the repo root
bin/ngrok http -bind-tls=true -subdomain=mysubdomain 3000
```

Your locally running meteor app will now be accessible from the Internet at: https://*your-subdomain*.ngrok.io/

-bind-tls=true forces ngrok to only listen on https, not http, which is a requirement of oauth.

If you prefer to not specify tunneling related command line arguments every time you run ngrok, you can specify in ngrok's ngrok.yml configuration file a list of predefined tunnels. So, for the tunnel above, edit you your ngrok.yml file and add the following:

```yml
authtoken: your-ngrok-authtoken
# Add this:
tunnels:
  meteor: # This is a name / alias you provide for each tunnel in the file
    proto: http
    addr: 3000
    bind_tls: true
    subdomain: your-ngrok-subdomain
```

Now, to start the meteor tunnel specified in ngrok.yml, just:

```bash
# From the repo root
bin/ngrok start meteor
```

To start all tunnels specified in ngrok.yml:

```bash
bin/ngrok start --all
```

### Create the GitHub developer application

To create GitHub developer applications, you need to be on a paid personal or organizational github account.

Create a developer app [here](https://github.com/settings/developers).

Choose a unique application name, for example:

my-github-username.hubaaa.com

This name will be sent to GitHub's api in the User-Agent header. More on that later.

For **Homepage URL**, specify the ngrok.io public URL you'll use to expose your local app:

https://*your-ngrok-subdomain*.ngrok.io/

For **Authorization callback URL**, append `/_oauth/github` to the Homepage URL:

https://*your-ngrok-subdomain*.ngrok.io/_oauth/github

### Create your meteor settings file

With meteor, you can manage your application environment's configuration with either environment variables or a settings json file that you provide to meteor on the command line, as follows:

```bash
meteor --settings settings.json
```

This app reads the required GitHub developer app info from a meteor settings file, so you'll need to create one. A sample is already provided in this repo. Just copy and modify it to include your GitHub developer app info:

```bash
# From the repo root
cp samples/sample.settings.json settings.json
vi settings.json
```

For appName, specify the name of the github developer application you created.

The [easy-service-config](packages/easy-service-config) meteor package included in this repo automatically loads all the [loginWith](http://docs.meteor.com/#/full/meteor_loginwithexternalservice) related service configurations it finds in the settings file under `serviceConfigurations` into meteor's `ServiceConfiguration.configurations` collection, so you won't have to configure your GitHub developer application in meteor manually on first time use.

### Create your meteor runtime environment

meteor relies on environment variables such as ROOT_URL, MONGO_URL and EMAIL_URL for it's runtime environment. I recommend creating a file that exports those that you can "bash source" before running meteor. Here too, a sample is already provided, just copy it and modify it for your environment:

```
cp samples/sample.meteor.env meteor.env
vi meteor.env
```

### Install spacejam

[spacejam](https://www.npmjs.com/package/spacejam) is an open source meteor tool I'm actively maintaining that deals with running meteor tests from the command line and in continuous integration environments. It also includes scripts that help you easily manage and run meteor and meteor tests in different environments. Though it is not required to use spacejam, this repo includes helper / shortcut scripts that rely on it and that will save you a lot of command line typing and application configuration management.

```
npm install -g spacejam
```

## Running the app

Before you run the app, you will need to export your meteor environment variables by sourcing your meteor.env file:

```bash
# From the repo root
source meteor.env
```

Then, just use the mrun script in the bin folder to run the meteor app. It will automatically take care of running meteor with your settings.json file:

```bash
# From the repo root
bin/mrun
```

The app will now be accessible from the internet at:

https://your-ngrok-subdomain.ngrok.io/

Note that you will only have to source your meteor.env file once per shell session, even if you changed it, since mrun will automatically source it again every time before it runs meteor.

## UI only development without ngrok / http tunneling

ngrok is very slow sometimes, especially with meteor's single page app model and the fact the in development mode, meteor doesn't bundle all javascript and css files into one file, as it does in production, and just sends all of them, one by one, to the client.

Therefore, if you're adding features to the UI or fixing UI bugs, you can:

1. Enable the ACCOUNTS_PASSWORD env var in your meteor.env file so you can sign into the app with a username and password, instead of with GitHub. This will also turn off the actual GitHub vacation auto-responder in the app.

2. Temporarily Remove force-ssl from the app, so you can access it at http://localhost:3000/. To remove it:

```bash
# From the repo root
meteor remove force-ssl
```

Don't forget to add it back before pushing.

## Running and writing tests

### Running tests

As with every meteor app of mine, all source code is maintained in packages, including the app specific code itself, in a package called packaged-app in this repo. Tests are written in mocha, using my [practicalmeteor:mocha](https://atmospherejs.com/practicalmeteor/mocha).

To run all of this repo's meteor package tests in the browser:

```bash
# From the repo root
bin/mtp packages/*
````

To run all of this repo's meteor package tests from the command line using spacejam:

```bash
# From the repo root
bin/spacejam packages/*
````

### Writing tests

Is a must. Pull requests will not be accepted without tests. Some guidelines:

1. Make extensive use of [sinon.js](practicalmeteor:mocha) spies and stubs to make sure that each test tests the behavior of the code under test in complete isolation.

2. for the same reason, each test must create a new object per test.

3. beforeEach and afterEach should always restore all stubs and spies. My [sinon.js](practicalmeteor:mocha) meteor wrapper package includes spy and stub factories with restoreAll() support. See the test code in this repo's packages for example.

## Pull requests

This app uses Travis CI to run all package tests using spacejam on every change pushed to GitHub. Pull requests will not be accepted until their build passes in Travis CI.

To verify all tests will pass in Travis CI, run all package tests using `bin/spacejam packages/*` before creating your pull request.

## Final words

If you found an error in this guide, think I missed something, think something is not clear, or think it should be improved somehow, please do let me know.

That's it! Happy contributing :-)
