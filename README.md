## Aerospike Service Release for Cloud Foundry

This project implements a BOSH release which is used by the on-demand service tile for Pivotal Cloud Foundry.

### Getting Started

This project is used by the [cf-aerospike-on-demand-tile](https://github.com/aerospike/cf-aerospike-on-demand-tile.git) project. 

It contains the BOSH deployment that is used to deploy both the Aerospike database as well as the AMC console.

### Prerequisites

1. [BOSH CLI](https://bosh.io/docs/bosh-cli.html)
2. Dowload the latest Aerospike Enterprise Edition for Ubuntu 14.04 and place the tgz file in the ```blobs``` directory.

### Updating AMC

To update the Aerospike AMC code that is used in the project, add the new file as a blob and remove the old blob.

### Build

To build the project use: ```./scripts/createRelease.sh <version>``` 

The ```version``` is optional and if not provided, the version from the ./scripts/service_release_version file will be read, incremented and used. The new version will be written back to the file.

