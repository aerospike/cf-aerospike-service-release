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

if [ "$#" -gt 1 ]; then
  echo "Usage: [<version>]"
  echo " 1st arg (optional): release version (i.e. 0.0.1)"
  echo ""
  exit -1
fi

pushd $BLOBS_DIR
  SERVER_NAME=`find -H *.tgz -type f -print`
popd

if [ -z "$SERVER_NAME" ]; then
  echo "ERROR:"
  echo "Aerospike Enterprise file missing."
  echo "Download the Aerospike Enterprise tgz file and copy it into the blobs directory."
  exit -1
fi

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
RELEASE_TAR_NAME="$RELEASE_NAME-$SERVICE_RELEASE_VERSION.tgz"

cd $RELEASE_DIR

# Uncomment if the jobs have to be generated each time
rm -rf .dev_releases *releases .*builds  ~/.bosh/cache
# bosh -n create release --name $RELEASE_NAME \
#      --version $SERVICE_RELEASE_VERSION --force --with-tarball

bosh -n create-release --name $RELEASE_NAME --version $SERVICE_RELEASE_VERSION --tarball $RELEASE_TAR_NAME --force
cp $RELEASE_TAR_NAME dev_releases/$RELEASE_NAME/