#!/bin/bash
#set -xv

function realpath() {
      [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

SCRIPT=$(realpath $0)
SCRIPT_DIR=$(dirname $SCRIPT)
ROOT_DIR=$SCRIPT_DIR/..

BLOBS_DIR=$ROOT_DIR/blobs
SERVER_PACKAGE_DIR=$ROOT_DIR/packages/aerospike-server
AMC_PACKAGE_DIR=$ROOT_DIR/packages/aerospike-amc
TEMPLATE_DIR=$ROOT_DIR/templates

if [ "$#" -gt 1 ]; then
  echo "Usage: [<version>]"
  echo " 1st arg (optional): release version (i.e. 0.0.1)"
  echo ""
  exit -1
fi

pushd $BLOBS_DIR
  SERVER_NAME=`find *.tgz -type f -print`
popd

if [ -z "$SERVER_NAME" ]; then
  echo "ERROR:"
  echo "Aerospike Enterprise file missing."
  echo "Download the Aerospike Enterprise tgz file and copy it into the blobs directory."
  exit -1
fi

ruby $SCRIPT_DIR/generatePackage.rb $SERVER_NAME $TEMPLATE_DIR/server_spec.erb > $SERVER_PACKAGE_DIR/spec

pushd $BLOBS_DIR
  AMC_NAME=`find amc/* -print`
popd

ruby $SCRIPT_DIR/generatePackage.rb $AMC_NAME $TEMPLATE_DIR/amc_spec.erb > $AMC_PACKAGE_DIR/spec

# auto-increment version number
source $SCRIPT_DIR/version
if [ "$#" -gt 0 ]; then
  SERVICE_RELEASE_VERSION="$1"
  printf "SERVICE_RELEASE_VERSION=%s\n" $SERVICE_RELEASE_VERSION > $SCRIPT_DIR/version
else
  perl -i -pe 's/SERVICE_RELEASE_VERSION=\d+\.\d+\.\K(\d+)/ $1+1 /e' $SCRIPT_DIR/version
  source $SCRIPT_DIR/version
fi

RELEASE_DIR=$(realpath $ROOT_DIR)

PRODUCT_NAME=aerospike-service
RELEASE_NAME=aerospike-service-release

cd $RELEASE_DIR

# Uncomment if the jobs have to be generated each time
rm -rf .dev_releases *releases .*builds  ~/.bosh/cache
bosh -n create release --name $RELEASE_NAME \
     --version $SERVICE_RELEASE_VERSION --force --with-tarball
