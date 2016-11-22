#!/bin/bash

SERVICE_RELEASE_VERSION=0.0.1

if [ "$#" -gt 0 ]; then
  SERVICE_RELEASE_VERSION="$1"
fi

bosh -n delete deployment aerospike-service
bosh -n delete release aerospike-service-release
scripts/createRelease.sh $SERVICE_RELEASE_VERSION
bosh upload release
bosh -n deploy
