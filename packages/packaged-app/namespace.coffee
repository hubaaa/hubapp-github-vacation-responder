# Every app will have it's unique namespace, but we will also create an internal package scoped namespace called hubapp
# for each app
@hubaaa ?= {}
hubaaa['github-vacation-responder'] ?= {}
@hubapp = hubaaa['github-vacation-responder']
