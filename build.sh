#!/bin/bash
git pull
docker pull debian:jessie
docker build -t craeckie/phabricator "$@" .
