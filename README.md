## Aerospike Service Release for Cloud Foundry

This project implements a BOSH release which is used by the on-demand service tile for Pivotal Cloud Foundry.

### Getting Started

This project is used by the [cf-aerospike-on-demand-tile](https://github.com/aerospike/cf-aerospike-on-demand-tile.git) project. 

It contains the BOSH deployment that is used to deploy both the Aerospike database as well as the AMC console.

### Prerequisites

1. [BOSH CLI](https://bosh.io/docs/bosh-cli.html)
2. Dowload the latest Aerospike Enterprise Edition for Ubuntu 14.04 and run ``bosh add-blob THE-SERVER-RELEASE.tgz THE-SERVER-RELEASE.tgz``
3. Dowload the latest Aerospike Enterprise Edition AMC Ubuntu 14.04 and run ``bosh add-blob THE-AMC-RELEASE.deb amc/THE-AMC-RELEASE.deb``

### Build

To build the project use: ```./scripts/createRelease.sh <version>``` 

The ```version``` is optional and if not provided, the version from the ./scripts/service_release_version file will be read, incremented and used. The new version will be written back to the file.

