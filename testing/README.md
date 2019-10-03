
# Testing and Interoperability

## RNAget API Compliance Testing

Implementors can check if their RNAget implementations conform to the specification by using our [compliance suite](https://github.com/ga4gh-rnaseq/rnaget-compliance-suite).  Full documentation is available [here](https://rnaget-compliance-suite.readthedocs.io/en/latest/)

Several sources have written test servers and clients for the RNAget API.  These are available for testing.  Testing configuration files required for the compliance tests can be found in this repository.  A combined configuration file for testing all available servers is also provided.

Implementors who wish to be included in this list can do so by providing their configuration file.

### Compliance report

The compliance and testing suite generates an HTML report for every tested server.  The latest compliance report can be viewed [here](https://ga4gh-rnaseq.github.io/rnaget-compliance-suite/report/).

### Server Implementations

* CanDIG - The Canadian Distributed Infrastructure for Genomics (CanDIG) project has a proof of concept code [implementation](https://github.com/CanDIG/rnaget_service) available

### Server Instances

* caltech.edu server - A demo server is available at http://felcat.caltech.edu/rnaget/ serving the Pan-Cancer Analysis of Whole Genomes (PCAWG) dataset.

* crg.cat server - A demo server is available at https://genome.crg.cat/rnaget/ serving the Pan-Cancer Analysis of Whole Genomes (PCAWG) dataset.  To access this server a request must have `Authorization` `Bearer abcdefuvwxyz` in the headers.


### Client Examples

These client implementations are provided by their respective developers as examples of using the API.  GA4GH does not have a client testing suite as each client is an individual effort.  Links to clients are presented as an "as is" resource for developers.

* saupchurch client - This is an iPython notebook example designed to demonstrate basic navigation and operations on the demo PCAWG dataset.  It is available [here](https://github.com/saupchurch/bioinformatics-tools/blob/master/GA4GH-rnaget-API-examples.ipynb).  An [interactive version](https://gke.mybinder.org/v2/gh/saupchurch/bioinformatics-tools/master) is accessible via [Binder](https://gke.mybinder.org).

* emi80 client - This is a Go command line application covering the basic functionalities of the API. It is available at: https://github.com/guigolab/rnaget-client
