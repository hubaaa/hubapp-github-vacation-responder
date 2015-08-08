# Development Guide

## Prerequisites

This is a [meteor](https://www.meteor.com/) app, so basic knowledge of meteor is probably required. Meteor is a full stack JavaScript only web application platform. From my many years of experience and after using meteor extensively in the last few years, I can attest that it cuts web app development time significantly.

Since this app uses GitHub oauth authorization, you will need to:

1. Create a GitHub developer application.

2. Use some kind of http tunneling solution to be able to expose your local app on the Internet so Sign-In with GitHub will work. This guide will provide you instructions on using [ngrok](https://ngrok.com/), but there are other [soltuions](http://john-sheehan.com/blog/a-survey-of-the-localhost-proxying-landscape) out there.

Also, if you're a team of developers (and as a rule of thumb in general), I recommend following the [The Twelve-Factor App](http://12factor.net/) principles religiosity in development environments too, so every developer has it's own completely separate environment, including separate domains, DBs, accounts, services, developer apps, etc.

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

Following the Twelve-Factor App principles, the ngrok binary is already included in the repo's bin folder. In the future, we'll move the ngrok dependency to a docker ngrok image or an npm package that downloads and install ngrok.

#### Sign-Up

Create an account at [ngrok](https://dashboard.ngrok.com/user/login).

Once created, I recommend that you get on a paid plan, so you can reserve for yourself an http tunneling subdomain under ngrok.io. If not, and if the subdomain you usually use is used by someone else, you will need to change your GitHub developer app URLs. Not a biggy and updates realtime, though.

#### Create the ngrok.yml file

After you signed-in to ngrok for the first time, you will need to add your ngrok authtoken to your development environment. It's a one-time setup. Just copy command from [here](https://dashboard.ngrok.com/). It should be something like:

```
ngrok authtoken yourAuthToken
```

This will create a `ngrok.yml` file at `$HOME/.ngrok2` where your authtoken will be stored.

#### Reserve a sub-domain

If you already have or decided to get on a paid plan, reserve a subdomain for yourself under ngrok.io [here](https://dashboard.ngrok.com/reserved). I usually like to use my github username as this subdomain, so my local app will accessible at:

https://rbabayoff.ngrok.io/

#### How-to run ngrok

Since meteor runs on port 3000 by default, you will need to start ngrok as follows before starting your app:

```
# From the repo root
bin/ngrok http -bind-tls=true -subdomain=mysubdomain 3000
```

Your locally running meteor app will know be accessible from the Internet at: https://*mysubdomain*.ngrok.io/

-bind-tls=true forces ngrok to only listen on https, not http, which is a requirement of oauth.

If you prefer to not specify tunneling related command line arguments every time you run ngrok, you can specify in ngrok's ngrok.yml configuration file a list of predefined tunnels. So, for the tunnel above, edit you your ngrok.yml file and add the following:

```yml
authtoken: myNgrokAuthtoken
# Add this:
tunnels:
  meteor: # This is a name / alias you provide to each tunnel
    proto: http
    addr: 3000
    bind_tls: true
    subdomain: myNgrokSubdomain
```

Now, to start the meteor tunnel specified in ngrok.yml, just:

```bash
# From the repo root
bin/ngrok start meteor
```

To start all tunnels specified in ngrok.yml:

```bash
ngrok start --all
```

### Create the GitHub developer application

To create GitHub developer apps, you need to be on a paid personal or organizational github account.

Create a developer app [here](https://github.com/settings/developers).

Choose a unique application name, for example:

myGitHubUsername.hubaaa.com

This name will be sent to GitHub's api in the User-Agent header. More on that later.

For **Homepage URL**, specify an ngrok.io public URL you'll use to expose your local app. If you reserved a ngrok sub-domain, use the reserved one. i.e.:

https://*myReservedSubDomain*.ngrok.io/

For **Authorization callback URL**, append `/_oauth/github` to the Homepage URL, i.e.:

https://*myReservedSubDomain*.ngrok.io/_oauth/github

### Create your meteor settings file

With meteor, you can manage your application environment's configuration with either environment variables or a settings json file that you provide to meteor on the command line, as follows:

```bash
meteor --settings=settings.json
```

This app reads the required GitHub developer app info from a meteor settings file, so you'll need to create one. A sample is already provided in this repo. Just copy and modify it to include your GitHub developer application's info:

```bash
# From the repo root
cp samples/sample.settings.json settings.json
vi settings.json
```

The [easy-service-config](packages/easy-service-config) meteor package I've created automatically loads all the [loginWith](http://docs.meteor.com/#/full/meteor_loginwithexternalservice) related service configurations it finds in the settings file under `serviceConfigurations` into meteor's `ServiceConfiguration.configurations` collection, so you won't have to configure your GitHub developer application in meteor manually.

### Create your meteor run environment

meteor relies on environment variables such as ROOT_URL, MONGO_URL and EMAIL_URL for it's run environment. I recommend creating a file that exports those that you can "bash source" before running meteor. Here too, a sample is already provided, just copy it and modify it for your environment:

```
cp samples/sample.meteor.env meteor.env
vi meteor.env
```

### Install spacejam

[spacejam](https://www.npmjs.com/package/spacejam) is an open source meteor tool I'm actively maintaining that deals with running meteor tests from the command line and in continuous integration environments and easily managing and running meteor and meteor tests in different environments. Though it is not required to use spacejam, this repo includes helper / shortcut scripts that rely on it and that will save you a lot of command line typing and application configuration management.

```
npm install -g spacejam
```

## Running the app



## Running and writing tests

## Creating pull requests
