## Hubaaa's GutHub Vacation Auto-Responder

Very much work in progress and test coverage is far from what it should be.

A meteor app that allows you to specify a "I'm on vacation" auto-comment for your personal public repos.

For every issue / pull request that will be created or commented on while you're on vacation, it will only auto-comment once (not fully tested, though).

You can see a live demo at (UX still needs a lot of work):

https://hubaaa-github-vacation-responder.meteor.com/

Note that if you create an issue in your own repo, you will NOT get a response. Only others will get it in your repos.

Try it out in a personal [test repo](https://github.com/rbabayoff/github-app-test-repo) of mine - I'm always on vacation, apparently :-)

Please do not create issues in this repo just to get auto replies.

### Known Issues

- No way to disable it, you can only update dates and text. Will be adding disabling support shortly. For now, just set it to a far away date, if you want to disable it.

### Contributing

See [Developer's Guide](docs/DevGuide.md).

Also, all the [meteor packages](packages) in this repo, will each get a repo of their own soon.

### License

For now, [GNU v2](LICENSE.md), but will change it to MIT probably soon.
