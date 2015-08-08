[![Build Status](https://travis-ci.org/rbabayoff/hubaaa-github-vacation-responder.svg)](https://travis-ci.org/rbabayoff/hubaaa-github-vacation-responder)

## Hubaaa's GitHub Vacation Auto-Responder

Very much work in progress and test coverage is far from what it should be.

A meteor app that allows you to specify a "I'm on vacation" auto-comment for your **personal** public repos.

For every issue / pull request that will be created or commented on while you're on vacation, it will only auto-comment once.

You can play with a live demo at:

https://hubaaa-github-vacation-responder.meteor.com/

Note that if you create an issue in your own repo, you will NOT get a response. Only non-owners will get a response.

Try it out in a personal [test repo](https://github.com/rbabayoff/github-app-test-repo) of mine - I'm always on vacation, apparently :-)

Please do not create issues in this repo just to generate auto-responses.

### Contributing

See [Developer's Guide](docs/DevGuide.md).

Also, all of the [meteor packages](packages) in this repo (json-pipes, endpoint-puller, etc.), will each get a repo of their own soon.

### License

For now, [GNU v2](LICENSE.md), but will change it to MIT probably soon.
