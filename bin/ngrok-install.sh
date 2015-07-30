#!/bin/bash -e

if [ -z "$DEVELOPER" ]; then
  >&2 echo "Error: DEVELOPER needs to be defined."
fi

curl

mkdir -p $HOME/.ngrok2

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $HOME/.ngrok2/ngrok.key -out $HOME/.ngrok2/ngrok.crt

# TODO: Fill automatically
# US
# Delaware
# Delaware
# Hubaaa Inc.
# devops
# $DEVELOPER.ngrok.io
