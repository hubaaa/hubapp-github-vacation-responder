#!/bin/bash -e

export METEOR_TEST_PACKAGES="1"

spacejam test-packages --driver-package=practicalmeteor:mocha-console-reporter packages/*
