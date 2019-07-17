# rnaget API

## Overview

The rnaget API describes a common set of endpoints for search and retrieval of processed RNA data.  This currently include feature level expression data from RNA-Seq type assays and signal data over a range of bases from ChIP-seq, methylation or similar epigenetic experiments.

By using these common endpoints, data providers make it easier for client software to access their data with no to minimal modifications to underlying code.  This improves interoperability with other compliant data providers and makes it easier for investigators to retrieve and compare data from multiple sites.

For the software developer, these common endpoints and patterns make it easier to access multiple compliant server sites with the same client software.  This reduces development time which may have otherwise been spend writing parsers and custom request generators.  Using the API it becomes much easier to write software to conduct comparisons, data mingling or other analyses on data retrieved from multiple, potentially geographically dispersed data servers.

## Getting started with rnaget

This repository has several files describing the rnaget API specification:

* The [API specification document](https://github.com/ga4gh-rnaseq/schema/blob/master/rnaget.md)
* A [machine-readable](https://github.com/ga4gh-rnaseq/schema/blob/master/rnaget-openapi.yaml) OpenAPI instance of the specification. View in [online visualizer](https://editor.swagger.io/?url=https://raw.githubusercontent.com/ga4gh-rnaseq/schema/master/rnaget-openapi.yaml)
* Introduction to accessing and [testing implementations](https://github.com/ga4gh-rnaseq/schema/blob/master/testing/README.md) for compliance
* Additional [background](https://github.com/ga4gh-rnaseq/schema/blob/master/rna_seq_design_notes.md) on the API
* The automated build of the compliance report is [here](https://ga4gh-rnaseq.github.io/rnaget-compliance-suite/report/)
* Complete documentation of the testing and compliance suite is [here](https://rnaget-compliance-suite.readthedocs.io/en/latest/)

### For current data providers

The rnaget API is designed to be implemented in parallel to an existing web interface.  Current data providers with their own web interfaces in use by their current users can implement the rnaget endpoints without disrupting those users.  The API does not place any requirements on the backend database and query engines - a data server is free to use their existing data infrastructure if desired.  To implement the rnaget API the appropriate endpoints need to be created and then linked to the existing backend.

The testing and compliance suite can be used to test implemented endpoints for API compliance.

### For new data providers

A group or organization can use the rnaget API to make their data available to users.  The rnaget API descirbed a lightweight data hierachy and a set of endpoints compatible with client software implementing the API.  It is important to note that the rnaget API does not place any restrictions on the data backend.  A server implementor is free to select whatever back end best suits their individual needs.  There are several paths towards setting up a compliant server:

* The [OpenAPI description](https://github.com/ga4gh-rnaseq/schema/blob/master/rnaget-openapi.yaml) of the specification can be used with code generators like [OpenAPI Generator](https://github.com/OpenAPITools/openapi-generator).
* The [testing and compliance page](https://github.com/ga4gh-rnaseq/schema/blob/master/testing/README.md) includes a list of example server implementations which can be used as is or as a starting point.
* A custom solution can be implemented to link the API endpoints and queries to a local data backend (of any desired type) serving the data

### For client software developers

The API specification describes a common data retrieval interface.  The purpose is to make it easy to retrieve data from any compatible server for use in downstream local analyses.  The rnaget API does not contain analytical tools.  It describes the format of the requests that should be sent to servers to search, slice and retrieve rna data as well as the format of the responses.  Client software compatible with these specifications can access data from any compliant server without having to rewrite the interface.

