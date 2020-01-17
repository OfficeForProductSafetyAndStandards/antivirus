#!/usr/bin/env bash
set -ex

# This is the CI server script to deploy the antivirus API
#
# The working directory should be the git root
#
# The caller should have the following environment variables set:
#
# SPACE: the space to which you want to deploy
# BUILD_ID: the docker tag that you want to deploy

cf7 push -f ./manifest.yml --docker-image beisopss/antivirus:$BUILD_ID --var hostname=antivirus-$SPACE.london.cloudapps.digital
