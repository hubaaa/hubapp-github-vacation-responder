[![Build Status](https://travis-ci.org/rbabayoff/hubaaa-github-vacation-responder.svg)](https://travis-ci.org/rbabayoff/hubaaa-github-vacation-responder)

## Hubaaa's GitHub Vacation Auto-Responder

This is the first in a series of apps I'm creating that I hope will generate the basis for a meteor based open-source integration platform.

This app allows you to specify a "I'm on vacation" auto-comment for your **personal** public repos.

For every issue / pull request that will be created or commented on while you're on vacation, it will only auto-comment once.

You can play with a live **demo** at:

https://hubaaa-github-vacation-responder.meteor.com/

Note that if you create an issue in your own repo, you will NOT get a response. Only non-owners will get a response.

Try it out in a personal [test repo](https://github.com/rbabayoff/github-app-test-repo) of mine - I'm always on vacation, apparently :-)

Please do not create issues in **this** repo just to generate auto-responses.

### Known Issues

- Very much work in progress and test coverage is far from what it should be.

- Since the demo runs on meteor's free infrastructure, app may be put in sleep mode and not respond while sleeping.

### Contributing

See [Developer's Guide](DevGuide.md).

Also, all of the [meteor packages](packages) in this repo (json-pipes, endpoint-puller, etc.), will each get a repo of their own soon.

### Comming soon / please contribute

This is a list of issues, features and use cases I already gathered, please feel free to add your own by means of feature requests or creating a PR to update this section of the readme.

- Support organizations

- Support private repos

- Support selecting the organizations you want to generate an auto-response for.

- Support selecting the repo(s) you want to generate an auto-response for.

- Support no end dates, for a "this repo is abandoned" auto-response.

- Support specifying a different auto-response text per repo.

### License

For now, [GNU v2](LICENSE.md), but will probably change to MIT soon.
