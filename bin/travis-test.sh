#!/bin/bash -e

# In travis, the meteor settings need to be added to travis as a private METEOR_SETTINGS environment variable,
# that includes the json of your meteor settings file.
spacejam test-packages --driver-package=practicalmeteor:mocha-console-reporter app/packages/*
