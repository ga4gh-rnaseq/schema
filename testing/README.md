
# Testing and Interoperability

## RNAget API Compliance Testing

Implementors can check if their RNAget implementations conform to the specification by using our [compliance suite](https://github.com/ga4gh-rnaseq/rnaget-compliance-suite).  Full documentation is available [here](https://rnaget-compliance-suite.readthedocs.io/en/latest/)

Several sources have written test servers and clients for the RNAget API.  These are available for testing.  Testing configuration files required for the compliance tests can be found in this repository.  A combined configuration file for testing all available servers is also provided.

Implementors who wish to be included in this list can do so by providing their configuration file.

### Compliance report

The compliance and testing suite generates an HTML report for every tested server.  The latest compliance report can be viewed [here](https://ga4gh-rnaseq.github.io/rnaget-compliance-suite/report/).

### Server Implementations

* CanDIG - The Canadian Distributed Infrastructure for Genomics (CanDIG) project has a proof of concept code [implementation](https://github.com/CanDIG/rnaget_service) available

* ENCODE - The ENCODE project incorporated a custom implementation of the API into their Genomic Data Services. The code is available [here](https://github.com/ENCODE-DCC/genomic-data-service/tree/dev/genomic_data_service/rnaseq/rnaget)

### Server Instances

* crg.cat server - A demo server is available at https://genome.crg.cat/rnaget/ serving the Pan-Cancer Analysis of Whole Genomes (PCAWG) dataset.  To access this server a request must have `Authorization` `Bearer abcdefuvwxyz` in the headers

* GTEx server - A public server from the GTEx project is available at https://gtexportal.org/rnaget

* ENCODE server - A public server with the ENCODE project implementation (see #server-implementations) is available at https://rnaget.encodeproject.org