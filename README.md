<img src="https://www.ga4gh.org/wp-content/themes/ga4gh-theme/gfx/GA-logo-horizontal-tag-RGB.svg" alt="GA4GH Logo" style="width: 400px;"/>

# RNAget API

## Overview

The RNAget API describes a common set of endpoints for search and retrieval of processed RNA data.  This currently include feature level expression data from RNA-Seq type assays and signal data over a range of bases from ChIP-seq, methylation or similar epigenetic experiments.

By using these common endpoints, data providers make it easier for client software to access their data with no to minimal modifications to underlying code.  This improves interoperability with other compliant data providers and makes it easier for investigators to retrieve and compare data from multiple sites.

For the software developer, these common endpoints and patterns make it easier to access multiple compliant server sites with the same client software.  This reduces development time which may have otherwise been spent writing parsers and custom request generators.  Using the API it becomes much easier to write software to conduct comparisons, data mingling or other analyses on data retrieved from multiple, potentially geographically dispersed data servers.

## API Definition

| Branch            | Reference        | OpenAPI YAML description | Swagger Validation
|-------------------|------------------|--------------------------|-------------------|
| **master**: the current release | [HTML](https://ga4gh-rnaseq.github.io/schema/releases/1.0.0/) | [ReDoc](https://ga4gh-rnaseq.github.io/schema/releases/1.0.0/redoc-ui.html) |<img src="http://validator.swagger.io/validator?url=https://raw.githubusercontent.com/ga4gh-rnaseq/schema/master/rnaget-openapi.yaml" /> |

### Testing and Compliance

* Introduction to accessing and [testing implementations](testing/README.md) for compliance
* The automated build of the compliance report is [here](https://ga4gh-rnaseq.github.io/rnaget-compliance-suite/report/)
* Complete documentation of the testing and compliance suite is [here](https://rnaget-compliance-suite.readthedocs.io/en/latest/)

### For current data providers

The RNAget API is designed to be implemented in parallel to an existing web interface.  Current data providers with their own web interfaces in use by their current users can implement the RNAget endpoints without disrupting those users.  The API does not place any requirements on the backend database and query engines - a data server is free to use their existing data infrastructure if desired.  To implement the RNAget API the appropriate endpoints need to be created and then linked to the existing backend.

The testing and compliance suite can be used to test implemented endpoints for API compliance.

### For new data providers

A group or organization can use the RNAget API to make their data available to users.  The RNAget API describes a lightweight data hierarchy and a set of endpoints compatible with client software implementing the API.  It is important to note that the RNAget API does not place any restrictions on the data backend.  A server implementor is free to select whatever back end best suits their individual needs.  There are several paths towards setting up a compliant server:

* The [OpenAPI description](rnaget-openapi.yaml) of the specification can be used with code generators like [OpenAPI Generator](https://github.com/OpenAPITools/openapi-generator).
* The [testing and compliance page](testing/README.md) includes a list of example server implementations which can be used as is or as a starting point.
* A custom solution can be implemented to link the API endpoints and queries to a local data backend (of any desired type) serving the data

### For client software developers

The API specification describes a common data retrieval interface.  The purpose is to make it easy to retrieve data from any compatible server for use in downstream local analyses.  The RNAget API does not contain analytical tools.  It describes the format of the requests that should be sent to servers to search, slice and retrieve RNA data as well as the format of the responses.  Client software compatible with these specifications can access data from any compliant server without having to rewrite the interface.

# License

See the [LICENSE](LICENSE).

# More Information

* [Global Alliance for Genomics and Health](http://genomicsandhealth.org)
