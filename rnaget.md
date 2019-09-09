---
layout: default
title: rnaget API specification
suppress_footer: true
---

# rnaget API

# Version: 1.0.0

## Design principles

This API provides a means of retrieving data from several types of RNA experiments including:

* Feature-level expression data from RNA-seq type measurements
* Coordinate-based signal/intensity data similar to a bigwig representation

via a client/server model.

Features of this API include:

* Support for a hierarchical data model which provides the option for servers to associate expression data for discovery and retrieval
* Support for accessing subsets of expression data through slicing operations on the expression matrix and/or query filters to specify features to be included
* Support for accessing signal/intensity data by specifying a range of genomic coordinates to be included

Out of the scope of this API are:

* A means of retrieving primary (raw) read sequence data. Input samples are identified in expression output and data servers should implement additional API(s) to allow for search and retrieval of raw reads. The [htsget API](https://samtools.github.io/hts-specs/htsget.html) is designed for retrieval of read data.
* A means of retrieving reference sequences. Servers should implement additional API(s) to allow for search and retrieval of reference base sequences. The [rnaget API](https://samtools.github.io/hts-specs/rnaget.html) is designed for retrieval of references sequences.
* A means of retrieving feature annotation details. Expression matrices provide the identity of each mapped feature. Servers should implement additional API(s) to allow for search and retrieval of genomic feature annotation details.

## OpenAPI Description

An OpenAPI description of this specification is available and [describes the 1.0.0 version](rnaget-openapi.yaml). OpenAPI is an independent API description format for describing REST services and is compatible with a number of [third party tools](http://openapi.tools/).

## Compliance

Implementors can check if their rnaget implementations conform to the specification by using our [compliance suite](https://github.com/ga4gh-rnaseq/rnaget-compliance-suite).

## Protocol essentials

All API invocations are made to a configurable HTTPS endpoint, receive URL-encoded query string parameters and HTTP headers, and return text or other allowed formatting as requested by the user. Queries containing [unsafe or reserved](https://www.ietf.org/rfc/rfc1738.txt) characters in the URL, including but not limited to "&", "/", "#", MUST encode all such characters.  Successful requests result with HTTP status code 200 and have the appropriate text encoding in the response body as defined for each endpoint. The server may provide responses with chunked transfer encoding. The client and server may mutually negotiate HTTP/2 upgrade using the standard mechanism.

Requests adhering to this specification MAY include an Accept header specifying an alternative formatting of the response, if the server allows this. Otherwise the server shall return the default content type specified for the invoked method.  Unless specified, the default content type is the rnaget protocol version:

```
Accept: application/vnd.ga4gh.rnaget.v1.0.0+json
```

A server MAY support other formatting.  The server SHOULD respond with an `Not Acceptable` error if the client requests a format not supported by the server.

HTTP responses may be compressed using [RFC 2616](https://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html) transfer-coding, not content-coding.

HTTP response may include a 3XX response code and Location header redirecting the client to retrieve expression data from an alternate location as specified by [RFC 7231](https://tools.ietf.org/html/rfc7231), clients SHOULD be configured to follow redirects. `302`, `303` and `307` are all valid response codes to use.

Responses from the server MUST include a Content-Type header containing the encoding for the invoked method and protocol version.  Unless negotiated with the client and allowed by the server, the default encoding is:

```
Content-Type: application/vnd.ga4gh.rnaget.v1.0.0+json; charset=us-ascii
```

All response objects from the server are expected to be in JSON format, regardless of the response status code, unless otherwise negotiated with the client and allowed by the server.

Object IDs are intended for persistent retrieval of their respective objects.  An object ID MUST uniquely identify an object within the scope of a single data server.  It is beyond the scope of this API to enforce uniqueness of ID among different data servers.

## Internet Media Types Handling

When responding to a request a server MUST use the fully specified media type for that endpoint. When determining if a request is well-formed, a server MUST allow a internet type to degrade like so

- `application/vnd.ga4gh.rnaget.v1.0.0+json; charset=us-ascii`
  - `application/vnd.ga4gh.rnaget.v1.0.0+json`
  - `application/json`

## Errors

The server MUST respond with an appropriate HTTP status code (4xx or 5xx) when an error condition is detected. In the case of transient server errors (e.g., 503 and other 5xx status codes), the client SHOULD implement appropriate retry logic. For example, if a client sends an alphanumeric string for a parameter that is specified as unsigned integer the server MUST reply with `Bad Request`.

| Error type        | HTTP status code | Description
|-------------------|------------------|-------------|
| `Bad Request`     | 400 | Cannot process due to malformed request, the requested parameters do not adhere to the specification |
| `Unauthorized`    | 401 | Authorization provided is invalid |
| `Not Found`       | 404 | The resource requested was not found |
| `Not Acceptable`  | 406 | The requested formatting is not supported by the server |
| `Not Implemented` | 501 | The specified request is not supported by the server |

## Security

The rnaget API can be used to retrieve potentially sensitive genomic data and is dependent on the implementation.  Effective security measures are essential to protect the integrity and confidentiality of these data.

Sensitive information transmitted on public networks, such as access tokens and human genomic data, MUST be protected using Transport Level Security (TLS) version 1.2 or later, as specified in [RFC 5246](https://tools.ietf.org/html/rfc5246).

If the data holder requires client authentication and/or authorization, then the client's HTTPS API request MUST present an OAuth 2.0 bearer access token as specified in [RFC 6750](https://tools.ietf.org/html/rfc6750), in the Authorization request header field with the Bearer authentication scheme:

```
Authorization: Bearer [access_token]
```

Data providers SHOULD verify user identity and credentials.  The policies and processes used to perform user authentication and authorization, and the means through which access tokens are issued, are beyond the scope of this API specification. GA4GH recommends the use of the OAuth 2.0 framework ([RFC 6749](https://tools.ietf.org/html/rfc6749)) for authentication and authorization.  It is also recommended that implementions of this standard also implement and follow the GA4GH [Authentication and Authorization Infrastructure (AAI) standard](https://docs.google.com/document/d/1zzsuNtbNY7agPRjfTe6gbWJ3BU6eX19JjWRKvkFg1ow).

## CORS
Cross-origin resource sharing (CORS) is an essential technique used to overcome the same origin content policy seen in browsers. This policy restricts a webpage from making a request to another website and leaking potentially sensitive information. However the same origin policy is a barrier to using open APIs. GA4GH open API implementers should enable CORS to an acceptable level as defined by their internal policy. For any public API implementations should allow requests from any server.

GA4GH is publishing a [CORS best practices document](https://docs.google.com/document/d/1Ifiik9afTO-CEpWGKEZ5TlixQ6tiKcvug4XLd9GNcqo/edit?usp=sharing), which implementers should refer to for guidance when enabling CORS on public API instances.

## Responsible data sharing

The GA4GH promotes secure, federated and ethical approaches to data sharing.  For a discussion of the nature of RNA expression data, the importance of sharing expression data and some of the privacy considerations to be aware of please refer to the [Ethics Toolkit for Sharing Gene Expression Data from RNA Sequencing](https://docs.google.com/document/d/1QeiYFkJDE81Bdl88LEYH0R6fQ-BgOQiKz0-dqaZqeWE).

## API Methods

This section lists the recommended URL endpoints a server SHOULD implement in order to navigate the RNA-seq data hierarchy and allow retrieval of expression data.

Endpoints are described as HTTPS GET methods which will be sufficient for most queries.  Queries containing multiple metadata filters may approach or exceed the URL length limits.  To handle these types of queries it is recommended that servers SHOULD implement parallel HTTPS POST endpoints accepting the same URL parameters as a UTF8-encoded JSON key-value dictionary.

When processing requests containing multiple filters, the data provider SHOULD use a logical `AND` for selecting the results to return.

### Project: Get project by id

The project is the top level of the model hierarchy and contains a set of related studies.  Example projects include:

* all data submitted by contributor X
* the local mirror of the European Nucleotide Archive data

`GET /projects/<id>`

The primary method for accessing specific project data.  The reponse is the specified project in JSON format unless an alternative formatting supported by the server is requested.

#### Path parameters

| Parameter | Data Type | Required | Description 
|-----------|-----------|----------|-----------|
| `id`      | string    | Yes      | A string identifying which record to return.  The format of this identifier is left to the discretion of the API provider, including allowing embedded "/" characters. The following would be valid identifiers: some-projectId or /byContributor/some-projectId |

#### Response

The server shall return the selected project as a JSON formatted object.  The server may return the project in an alternative formatting, such as plain text, if requested by the client via the `Accept` header and the format is supported by the server.

On success and a project is returned the server MUST issue a 200 status code.

The response to a project query is a JSON object with the following fields:

| Data Field | Data Type | Required | Description 
|------------|-----------|----------|-----------|
| `id`       | string    | Yes      | A unique identifier assigned to this object |
| `version`  | string    | Optional | Version number of the object |
| `tags`     | string array | Optional | List of tags for the object |
| `name`     | string    | Optional | Short, readable name |
| `description` | string | Optional | Detailed description of the object |

#### An example response

```
{
  "description": "Pan Cancer Analysis of Whole Genomes test data from Expression Atlas E-MTAB-5423",
  "id": "43378a5d48364f9d8cf3c3d5104df560",
  "name": "PCAWG",
  "tags": [
    "PCAWG",
    "cancer"
  ],
  "version": "1.0"
}
```

### Project:  Search for matching projects

The recommended search endpoint is:

`GET /projects/search`

To support queries with many parameters the data provider SHOULD implement the following POST endpoint:

`POST /projects/search`

accepting a UTF-8 JSON encoded key-value dictionary in the form:

```
{
  "filter1": "value1",
  "filter2": "value2"
}
```

in which each `filter#` key matches the corresponding URL parameter.  The reponse is a list of matching projects in JSON format unless an alternative formatting supported by the server is requested.

#### URL parameters

| Parameter | Data Type | Required | Description 
|-----------|-----------|----------|-----------|
| `tags`    | string    | Optional | Comma separated tag list to filter by |
| `version` | string    | Optional | Version to return |

#### Response

The server shall return the matching projects as a list of JSON formatted objects.  The server may return the objects in an alternative formatting, such as plain text, if requested by the client via the `Accept` header and the format is supported by the server.

On success and one or more projects are returned the server MUST issue a 200 status code.

The response to a project search query is a list of JSON objects each with the following fields:

| Data Field | Data Type | Required | Description 
|------------|-----------|----------|-----------|
| `id`       | string    | required | A unique identifier assigned to this object |
| `version`  | string    | optional | Version number of the object |
| `tags`     | string array | optional | List of tags for the object |
| `name`     | string    | optional | Short, readable name |
| `description` | string | optional | Detailed description of the object |

#### An example response

```
[
  {
    "description": "Pan Cancer Analysis of Whole Genomes test data from Expression Atlas E-MTAB-5423",
    "id": "43378a5d48364f9d8cf3c3d5104df560",
    "name": "PCAWG",
    "tags": [
      "PCAWG",
      "cancer"
    ],
    "version": "1.0"
  }
]
```

### Project: Get available search filters

To support flexible search this provides a means of identifying the search filters supported by the data provider.

`GET /projects/search/filters`

The reponse is a list of search filters in JSON format unless an alternative formatting supported by the server is requested.

#### Response

The server shall return the available filters as a list of JSON formatted objects.  The server may return the objects in an alternative formatting, such as plain text, if requested by the client via the `Accept` header and the format is supported by the server.

On success and one or more filters are returned the server MUST issue a 200 status code.

The response to a project search filter query is a list of JSON objects each with the following fields:

| Data Field    | Data Type | Required | Description 
|---------------|-----------|----------|-----------|
| `filter`      | string    | Yes      | A unique name for the filter for use in search query URLs |
| `fieldType`    | string    | Yes      | The dataType (`string`, `float`, etc.) of the filter |
| `description` | string    | Yes      | Detailed description of the filter |
| `values` | string array   | Optional | List of supported values for the filter |

#### An example response

```
[
  {
    filter: "version",
    fieldType: "string",
    description: "release version to match",
    values: ["1.0"]
  },
  {
    filter: "tags",
    fieldType: "string",
    description: "comma separated list of tags",
    values: ["tag1", "tag2"]
  },
  {
    filter: "name",
    fieldType: "string",
    description: "project name",
    values: []
  }
]
```

### Study: Get study by id

The study is a set of related RNA expression values.  It is assumed all samples in a study have been processed uniformly.  Example studies include:

* multiple tissues from all patients enrolled in clinical trial X
* a collection of liver samples from several sources which have been uniformly reprocessed for differential analysis

`GET /studies/<id>`

The primary method for accessing specific study data.  The reponse is the specified study in JSON format unless an alternative formatting supported by the server is requested.

#### Path parameters

| Parameter | Data Type | Required | Description 
|-----------|-----------|----------|-----------|
| `id`      | string    | Yes      | A string identifying which record to return.  The format of this identifier is left to the discretion of the API provider, including allowing embedded "/" characters. The following would be valid identifiers: some-studyId or /byContributor/some-studyId |

#### Response

The server shall return the selected study as a JSON formatted object.  The server may return the object in an alternative formatting, such as plain text, if requested by the client via the `Accept` header and the format is supported by the server.

On success and a study is returned the server MUST issue a 200 status code.

The response to a study query is a JSON object with the following fields:

| Data Field | Data Type | Required | Description 
|------------|-----------|----------|-----------|
| `id`       | string    | Yes      | A unique identifier assigned to this object |
| `version`  | string    | Optional | Version number of the object |
| `tags`     | string array | Optional | List of tags for the object |
| `name`     | string    | Optional | Short, readable name |
| `description` | string | Optional | Detailed description of the object |
| `parentProjectID` | string | Optional | ID of the project containing the study |
| `genome`   | string    | Optional | Name of the reference genome build used for aligning samples in the study |
| `sampleList` | string array | Optional | ID(s) of samples which provided the read data for the study |

#### An example response

```
{
  "description": "PCAWG study",
  "id": "6cccbbd76b9c4837bd7342dd616d0fec",
  "name": "PCAWG",
  "parentProjectID": "43378a5d48364f9d8cf3c3d5104df560",
  "tags": [
    "PCAWG",
    "cancer"
  ],
  "version": "1.0"
}
```

### Study: Search for matching studies

The recommended search endpoint is:

`GET /studies/search`

To support queries with many parameters the data provider SHOULD implement the following POST endpoint:
 
`POST /studies/search`

accepting a UTF-8 JSON encoded key-value dictionary in the form:

```
{
  "filter1": "value1",
  "filter2": "value2"
}
```

in which each `filter#` key matches the corresponding URL parameter.  The reponse is a list of matching studies in JSON format unless an alternative formatting supported by the server is requested.

#### URL parameters

| Parameter | Data Type | Required | Description
|-----------|-----------|----------|-----------|
| `tags`    | string    | Optional | Comma separated tag list to filter by |
| `version` | string    | Optional | Version to return |

#### Response

The server shall return the matching studies as a list of JSON formatted objects.  The server may return the objects in an alternative formatting, such as plain text, if requested by the client via the `Accept` header and the format is supported by the server.

On success and one or more studies are returned the server MUST issue a 200 status code.

The response to a study search query is a list of JSON objects each with the following fields:

| Data Field | Data Type | Required | Description
|------------|-----------|----------|-----------|
| `id`       | string    | Yes      | A unique identifier assigned to this object |
| `version`  | string    | Optional | Version number of the object |
| `tags`     | string array | Optional | List of tags for the object |
| `name`     | string    | Optional | Short, readable name |
| `description` | string | Optional | Detailed description of the object |
| `parentProjectID` | string | Optional | ID of the project containing the study |
| `genome`   | string    | Optional | Name of the reference genome build used for aligning samples in the study |
| `sampleList` | string array | Optional | ID(s) of samples which provided the read data for the study |

#### An example response

```
[
  {
    "description": "PCAWG study",
    "id": "6cccbbd76b9c4837bd7342dd616d0fec",
    "name": "PCAWG",
    "parentProjectID": "43378a5d48364f9d8cf3c3d5104df560",
    "tags": [
      "PCAWG",
      "cancer"
    ],
    "version": "1.0"
  }
]
```

### Study: Get available search filters

To support flexible search this provides a means of identifying the search filters supported by the data provider.

`GET /studies/search/filters`

The reponse is a list of search filters in JSON format unless an alternative formatting supported by the server is requested.

#### Response

The server shall return the available filters as a list of JSON formatted objects.  The server may return the objects in an alternative formatting, such as plain text, if requested by the client via the `Accept` header and the format is supported by the server.

On success and one or more filters are returned the server MUST issue a 200 status code.

The response to a study search filter query is a list of JSON objects each with the following fields:

| Data Field    | Data Type | Required | Description
|---------------|-----------|----------|-----------|
| `filter`      | string    | Yes      | A unique name for the filter for use in search query URLs |
| `fieldType`    | string    | Yes      | The dataType (`string`, `float`, etc.) of the filter |
| `description` | string    | Yes      | Detailed description of the filter |
| `values` | string array   | Optional | List of supported values for the filter |

#### An example response

```
[
  {
    filter: "version",
    fieldType: "string",
    description: "release version to match",
    values: ["1.0"]
  },
  {
    filter: "tags",
    fieldType: "string",
    description: "comma separated list of tags",
    values: ["tag1", "tag2"]
  },
  {
    filter: "name",
    fieldType: "string",
    description: "study name",
    values: []
  },
  {
    filter: "projectID",
    fieldType: "string",
    description: "ID of parent project",
    values: []
  }
]
```

### Expression: Get RNA Expression by id

The expression is a matrix of calculated expression values.  Expression requests return a URL for the download or streaming of this numeric matrix.

`GET /expressions/<id>`

The primary method for accessing specific expression data.  The reponse is the specified expression object in JSON format unless an alternative formatting supported by the server is requested.

If the server will not be providing expression value matrix data it MUST still define the `/expressions` endpoint and MUST respond with an `Not Implemented` error to requests sent to this endpoint.

#### Path parameters

| Parameter | Data Type | Required | Description 
|-----------|-----------|----------|-----------|
| `id`      | string    | Yes      | A string identifying which record to return.  The format of this identifier is left to the discretion of the API provider, including allowing embedded "/" characters. The following would be valid identifiers: some-expressionId or /byContributor/some-expressionId |

#### Response

The server shall return the selected expression as a JSON formatted object.  The server may return the expression in an alternative formatting, such as plain text, if requested by the client via the `Accept` header and the format is supported by the server.

On success and an expression is returned the server MUST issue a 200 status code.

The response to an expression query is a JSON object with the following fields:

| Data Field | Data Type | Required | Description 
|------------|-----------|----------|-----------|
| `version`  | string    | Optional | Version number of the object |
| `tags`     | string array | Optional | List of tags for the object |
| `fileType` | string    | Optional | Type of file.  Examples include: loom, tsv |
| `studyID` | string | Optional | ID of containing study |
| `url    ` | string | Yes      | An `https:` URL to download file |
| `units  ` | string | Yes      | Units for the values. Examples include: TPM, FPKM, counts |
| `headers` | object | Optional | For HTTPS URLs, the server may supply a JSON object containing one or more string key-value pairs which the client MUST supply verbatim as headers with any request to the URL. For example, if headers is `{"Authorization": "Bearer xxxx"}`, then the client must supply the header `Authorization: Bearer xxxx` with the HTTPS request to the URL. |
| `md5    ` | hex string | Optional | MD5 digest of the “payload” data — the url data blocks |

#### An example response

```
{
  "url": "http://server.com/rnaget/E-MTAB-5423-query-results.tpms.loom",
  "fileType": "loom",
  "studyID": "6cccbbd76b9c4837bd7342dd616d0fec",
  "units": "TPM",
  "headers": {
      "Authorization": "Bearer xxxx",
      "Accept": "application/vnd.loom"
    },
    "md5": "(some 32 character hex value)"
}
```

### Expression: Get supported data formats

The recommended search endpoint is:

`GET /expressions/formats`

The response is a list of the supported data formats as a JSON formatted object unless an alternative formatting supported by the server is requested.  A data provider may use any internal storage format that they wish with no restrictions from this API.  To support development of interoperable clients, it is recommended that data providers MUST support at least 1 of the following common output formats:

  * Tab delimited text (.tsv)
  * [Loom](https://linnarssonlab.org/loompy/format/index.html) (.loom)

A Tab delimited file can have any number of comment lines beginning with `#` for storing metadata.  There should be one header row following the comments.  Feature (genes/transcripts) names and/or ID fields should be the first columns of the header row and have the `string` type.  All following columns are for the samples and will have 32-bit `float` values in each row.

##### Example .tsv file

```
# Example tsv file
geneID	geneName	sample1	sample2
ENSG00000000003	TSPAN6	12.4	15.6
```

A Loom format file will have a 32-bit `float` matrix for the expression values with samples on the column axis and features on the row axis.  Associated metadata can be stored as row and column attributes as described by loom specification.

##### Expression metadata

This describes a set of minimal metadata appropriate for several types of RNA experiments.  The purpose is to define a common naming scheme for metadata to enable client software to have some expectation of data fields for improved interoperability.  These definitions are not intended to be a comprehensive set of metadata and defining such a universal set is beyond the scope of this effort.

Where possible details are incorporated by reference.  This is to reduce the final size of matrix files, support existing metadata standards and support server-defined metadata fields.

All field names are presented here in camel case.  Parsers should treat field names as case-insensitive and any white space contained in the field names should be ignored:

sampleID == sampleid == Sample ID != sample_id

All fields are optional.

| Metadata Field   | Description
|------------------|-------------|
| sampleID         | an identifier for the biological specimen the experiment was conducted on.  This id MUST uniquely identify the sample within the scope of the server |
| assayType        | the type of experiment performed (ex. RNA-seq, ATAC-seq, ChIP-seq, DNase-Hypersensitivity, methylation profiling, histone profiling, microRNA profiling, transcription profiling, WGS) |
| samplePrepProtocol | reference to a resource or webpage describing the protocol used to obtain and prepare the sample |
| libraryPrepProtocol | reference to a resource or webpage describing the protocol used to prepare the library for sequencing |
| annotation       | a reference to the specific annotation used for quantifying the reads |
| analysisPipeline | reference to a resource or webpage describing the analysis protocol.  This description should include a full listing of all software used including the exact version and command line options used.  If containerized software is used a reference to the specific containers should be included. The GA4GH [Tool Registry Service](https://github.com/ga4gh/tool-registry-service-schemas) is a resource for discovering and registering genomic tools and workflows. |
| cellType         | a term from the [CL ontology](http://www.ontobee.org/ontology/CL) |
| phenotype        | phenotype term applicable to the sample |
| phenotypeSource  | reference to the ontology used for `phenotype` (example: Human Phenotype Ontology, https://hpo.jax.org/app/) |
| sex              | sex of the organism providing the sample [PATO 47 term](http://purl.obolibrary.org/obo/PATO_0000047) |
| organism         | organism of origin for the sample |
| tissue           | tissue of origin or organism part of origin |
| cellLine         | name of [cell line](http://www.ontobee.org/ontology/CLO) |

##### The meaning of zero

Microarray and image-based RNA-seq (Seq-FISH etc.) have a dependency on probes which may not have 100% coverage of the annotation reference.  The consequence is that some features which show zero expression may not necessarily have a truly zero expression.  This idea can be extended further in the context of submitted data as well as potentially access restricted data.  The result is that a zero value can indicate one of several states:

1. _Not measured_ – not measured at all and value is not available
2. _Not supplied_ – measured but not provided to the data repository
3. _Restricted access_ – measured but require further authentication to view
4. _Not applicable_ – measurement does not apply to the sample

If practical a data provider SHOULD adopt a means to indicate these states rather than use a zero.  It is recommended that the `NaN` value be used to indicate these states.

#### Response

The server shall return the supported formats as JSON formatted string array.  The server may return the list in an alternative formatting, such as plain text, if requested by the client via the `Accept` header and the format is supported by the server.

On success and a list is returned the server MUST issue a 200 status code.

#### An example response

```
GET /expressions/formats
["tsv", "loom"]
```

### Expression: Search for matching RNA expressions

The recommended search endpoint is:

`GET /expressions/search`

To support queries with many parameters the data provider SHOULD implement the following POST endpoint:

    POST /expressions/search

accepting a UTF-8 JSON encoded key-value dictionary in the form:
```
{
  "filter1": "value1",
  "filter2": "value2"
}
```

in which each `filter#` key matches the corresponding URL parameter.  The reponse is a list of matching expressions in JSON format unless an alternative formatting supported by the server is requested.

#### URL parameters

| Parameter | Data Type | Required | Description
|-----------|-----------|----------|-----------|
| `format`  | string    | Yes      | Data format to return.  MUST be one of the supported data types returned by a request to the `/expressions/formats` endpoint |
| `tags`    | string    | Optional | Comma separated tag list to filter by |
| `version` | string    | Optional | Version to return |
| `sampleIDList` | string | Optional | comma separated list of sampleIDs to match |
| `projectID` | string | Optional | project to filter by |
| `studyID` | string | Optional |  study to filter by |
| `featureIDList` | string | Optional | return only values for listed comma separated feature ID values |
| `featureNameList` | string | Optional | return only values for listed comma separated features |
| `minExpression` | `threshold` array | Optional | return only samples with expression values greater than listed threshold for each corresponding feature in the array |
| `maxExpression` | `threshold` array | Optional | return only samples with expression values less than listed threshold for each corresponding feature in the array |

#### Response

The server shall return the filtered expression as a JSON formatted object.  The server may return the expression in an alternative formatting, such as plain text, if requested by the client via the `Accept` header and the format is supported by the server.

On success and an expression is returned the server MUST issue a 200 status code.

The response to an expression query is a JSON object with the following fields:

| Data Field | Data Type | Required | Description
|------------|-----------|----------|-----------|
| `version`  | string    | Optional | Version number of the object |
| `tags`     | string array | Optional | List of tags for the object |
| `fileType` | string    | Optional | Type of file.  Examples include: loom, tsv |
| `studyID` | string | Optional | ID of containing study |
| `url    ` | string | Yes      | An `https:` URL to download file |
| `units  ` | string | Yes      | Units for the values. Examples include: TPM, FPKM, counts |
| `headers` | object | Optional | For HTTPS URLs, the server may supply a JSON object containing one or more string key-value pairs which the client MUST supply verbatim as headers with any request to the URL. For example, if headers is `{"Authorization": "Bearer xxxx"}`, then the client must supply the header `Authorization: Bearer xxxx` with the HTTPS request to the URL. |
| `md5    ` | hex string | Optional | MD5 digest of the “payload” data — the url data blocks |

#### An example response

```
[
  {
    "url": "https://server.com/rnaget/E-MTAB-5423-query-results.tpms.loom",
    "fileType": "loom",
    "studyID": "6cccbbd76b9c4837bd7342dd616d0fec",
    "units": "TPM",
    "headers": {
      "Authorization": "Bearer xxxx",
      "Accept": "application/vnd.loom"
    },
    "md5": "(some 32 character hex value)"
  }
]
```

#### Expression Threshold

To allow for filtering on a range of expression values for multiple features the `/expressions/search` endpoint optionally accepts an array of `threshold` object.  This is a JSON formatted object with the following fields.

| Data Field         | Data Type | Required | Description
|--------------------|-----------|----------|-----------|
| `threshold`        | 32-bit float | Yes      | Numeric value to compare to expression value when filtering |
| `featureID`        | string    | Optional | ID of feature this threshold corresponds to |
| `featureName`      | string    | Optional | Name of feature this threshold corresponds to |

For each threshold tuple the request MUST provide only one of `featureID` or `featureName`.

#### Sample `threshold`

{
  "threshold": 10,
  "featureName": "GABARAPL2"
}

Reminder: if passed as a URL parameter to a GET endpoint the list of `threshold` objects MUST be encoded.  The sample `threshold` ahen encoded as an argument for `minExpression` is:

`'%5B%7B%22threshold%22%3A%2010%2C%20%22featureName%22%3A%20%22GABARAPL2%22%7D%5D'`

#### Expression: Get available search filters

To support flexible search this provides a means of identifying the search filters supported by the data provider.

`GET /expressions/search/filters`

The reponse is a list of search filters in JSON format unless an alternative formatting supported by the server is requested.

#### Response

The server shall return the available filters as a list of JSON formatted objects.  The server may return the objects in an alternative formatting, such as plain text, if requested by the client via the `Accept` header and the format is supported by the server.

On success and one or more filters are returned the server MUST issue a 200 status code.

The response to an expression search filter query is a list of JSON objects each with the following fields:

| Data Field    | Data Type | Required | Description
|---------------|-----------|----------|-----------|
| `filter`      | string    | Yes      | A unique name for the filter for use in search query URLs |
| `fieldType`    | string    | Yes      | The dataType (`string`, `float`, etc.) of the filter |
| `description` | string    | Yes      | Detailed description of the filter |
| `values` | string array   | Optional | List of supported values for the filter |

#### An example response

```
[
  {
    filter: "version",
    fieldType: "string",
    description: "release version to match",
    values: ["1.0"]
  },
  {
    filter: "sampleID",
    fieldType: "string",
    description: "ID of the sample",
    values: ["tag1", "tag2"]
  },
  {
    filter: "projectID",
    fieldType: "string",
    description: "ID of the parent project",
    values: []
  },
  {
    filter: "studyID",
    fieldType: "string",
    description: "ID of the parent study",
    values: []
  },
  {
    filter: "featureIDList",
    fieldType: "string",
    description: "comma separated list of feature IDs to match",
    values: []
  },
  {
    filter: "featureNameList",
    fieldType: "string",
    description: "comma separated list of feature names to match",
    values: []
  },
  {
    filter: "minExpression",
    fieldType: "32-bit float",
    description: "return values with expression greater than this value",
    values: []
  },
  {
    filter: "maxExpression",
    fieldType: "32-bit float",
    description: "return values with expression less than this value",
    values: []
  }
]
```

### Continuous: Get signal values by id

The continuous object is a matrix of numeric signal values.  Continuous requests return this numeric matrix as a file attachment.

`GET /continuous/<id>`

The primary method for accessing specific continuous value data.  The reponse is the specified continuous matrix as a downloadable attachment.

If the server will not be providing numeric signal matrix data it MUST still define the `/continuous` endpoint and MUST respond with an `Not Implemented` error to requests sent to this endpoint.

##### Content encoding
Unless negotiated with the client and allowed by the server, the default encoding for this method is:

```
Content-type: application/octet-stream
```

The encodings for loom and tsv files for this method are:

For loom files:
```
Content-type: application/vnd.loom
Content-Disposition: attachment
```

For tsv files:
```
Content-type: text/tab-separated-values
Content-Disposition: attachment
```

#### Path parameters

| Parameter | Data Type | Required | Description 
|-----------|-----------|----------|-----------|
| `id`      | string    | Yes      | A string identifying a set of one or more records to return.  The format of this identifier is left to the discretion of the API provider, including allowing embedded "/" characters. The following would be valid identifiers: some-continuousId or /byContributor/some-continuousId |

#### URL parameters

| Parameter | Data Type | Required | Description 
|-----------|-----------|----------|-----------|
| `chr` | string | Optional |  The refererence to which `start` and `end` apply in the form chr? where ? is the specific ID of the chromosome (ex. chr1, chrX).  The server MUST respond with a `Bad Request` if either start or end are specified and chr is not specified. |
| `start`   | 32-bit unsigned integer | Optional | The start position of the range on the sequence, 0-based, inclusive. The server MUST respond with a `Bad Request` error if start is specified and is larger than the total sequence length. The server must respond with a `Bad Request` error if start is specified and chr is not specified.  The server MUST respond with a `Not Implemented` if the start is greater than the end. |
| `end`     | 32-bit unsigned integer | Optional | The end position of the range on the sequence, 0-based, exclusive. The server must respond with a `Bad Request` error if end is specified and chr is not specified.  The server MUST respond with a `Not Implemented` if the start is greater than the end. |

#### Request parameters

| Parameter | Data Type | Required | Description 
|-----------|-----------|----------|-----------|
| `Accept`  | string    | Optional | The formatting of the returned continuous object, defaults to `application/octet-stream` if not specified. A server MAY support other formatting. The server SHOULD respond with an `Not Acceptable` error if the client requests a format not supported by the server.|

#### Response

The server shall return the selected continuous matrix as a downloadable attachment.

On success and a continuous object is returned the server MUST issue a 200 status code.

#### An example response

```
200 OK
Content-type: application/vnd.loom
Content-Disposition: attachment

<matrix file as response body>
```

### Continuous: Get supported data formats

The recommended endpoint is:

`GET /continuous/formats`

The response is a list of the supported data formats as a JSON formatted object unless an alternative formatting supported by the server is requested.  A data provider may use any internal storage format that they wish with no restrictions from this API.  To support development of interoperable clients, it is recommended that data providers MUST support at least 1 of the following common output formats:

  * Tab delimited text (.tsv)
  * [Loom](https://linnarssonlab.org/loompy/format/index.html) (.loom)

A Tab delimited file can have any number of comment lines beginning with `#` for storing metadata.  The first line of the tsv file will be a tab-delimited list beginning with `#labels` and containing the labels for text fields in the main matrix.  The second line of the tsv file will be a tab-delimited list containing 2 items: `#range` and the range in the form chr?:start-stop where the start coordinate is zero-based, inclusive and the stop coordinate is zero-based, exclusive.  Any additonal comments may follow these 2 lines.  The data matrix follows the comment block.  Sample names and/or ID fields should be the first columns of the header row, be in the same order as listed in the `#labels` comment  and have the `string` type.  All coordinates in the continuous range described in the `#range` comment will be in the following columns with each base position in its own column.  The coordinate columns will contain 32-bit `float` values in each row corresponding to the measured signal value at that coordiante for the sample correponding to that row.

##### Example .tsv file

```
#labels	sampleID	sampleName
#range	chr1:1000000-1000002
# assembly	GRCh38-V29-male
12003-L1	12003-human-liver-4	12.4	15.6
```

A Loom format file will have a 32-bit `float` matrix for the signal values with coordinates on the column axis and samples on the row axis.  Associated metadata can be stored as row and column attributes as described by the loom specification.

#### Response

The server shall return the supported formats as JSON formatted string array.  The server may return the list in an alternative formatting, such as plain text, if requested by the client via the `Accept` header and the format is supported by the server.

On success and a list is returned the server MUST issue a 200 status code.

#### An example response

```
GET /continuous/formats
["tsv", "loom"]
```

### Continuous: Search for matching values

The recommended search endpoint is:

`GET /continuous/search`

To support queries with many parameters the data provider SHOULD implement the following POST endpoint:

    POST /continuous/search

accepting a UTF-8 JSON encoded key-value dictionary in the form:
```
{
  "filter1": "value1",
  "filter2": "value2"
}
```

in which each `filter#` key matches the corresponding URL parameter.  The reponse is a continuous object in JSON format unless an alternative formatting supported by the server is requested.

#### URL parameters

| Parameter | Data Type | Required | Description
|-----------|-----------|----------|-----------|
| `format`  | string    | Yes      | Data format to return.  MUST be one of the supported data types returned by a request to the `/continuous/formats` endpoint |
| `studyID` | string    | Optional |  study to filter by |
| `tags`    | string    | Optional | Comma separated tag list to filter by |
| `version` | string    | Optional | Version to return |
| `sampleIDList` | string | Optional | comma separated list of sampleIDs to match |
| `chr` | string | Optional |  The refererence to which `start` and `end` apply in the form chr? where ? is the specific ID of the chromosome (ex. chr1, chrX).  The server MUST respond with a `Bad Request` if either start or end are specified and chr is not specified. |
| `start`   | 32-bit unsigned integer | Optional | The start position of the range on the sequence, 0-based, inclusive. The server MUST respond with a `Bad Request` error if start is specified and is larger than the total sequence length. The server must respond with a `Bad Request` error if start is specified and chr is not specified.  The server MUST respond with a `Not Implemented` if the start is greater than the end. |
| `end`     | 32-bit unsigned integer | Optional | The end position of the range on the sequence, 0-based, exclusive. The server must respond with a `Bad Request` error if end is specified and chr is not specified.  The server MUST respond with a `Not Implemented` if the start is greater than the end. |

#### Response

The server shall return the selected continuous object as a JSON formatted object.  The server may return the continuous object in an alternative formatting, such as plain text, if requested by the client via the `Accept` header and the format is supported by the server.

On success and a continuous object is returned the server MUST issue a 200 status code.

If start and end query parameter are specified and equal each other, the server should respond with a 404 status code and return a `Not Found` error.

```
GET /continuous/search?chr=chr1&start=0&end=0

```

The response to a continuous query is a JSON object with the following fields:

| Data Field | Data Type | Required | Description
|------------|-----------|----------|-----------|
| `version`  | string    | Optional | Version number of the object |
| `tags`     | string array | Optional | List of tags for the object |
| `fileType` | string    | Optional | Type of file.  Examples include: loom, tsv |
| `studyID` | string | Optional | ID of containing study |
| `url    ` | string | Yes      | An `https:` URL to download file |
| `headers` | object | Optional | For HTTPS URLs, the server may supply a JSON object containing one or more string key-value pairs which the client MUST supply verbatim as headers with any request to the URL. For example, if headers is `{"Authorization": "Bearer xxxx"}`, then the client must supply the header `Authorization: Bearer xxxx` with the HTTPS request to the URL. |
| `md5    ` | hex string | Optional | MD5 digest of the “payload” data — the url data blocks |

#### An example response

```
{ 
  "url": "https://server.com/rnaget/E-MTAB-5423-query-results.bw.loom",
  "fileType": "loom",
  "studyID": "6cccbbd76b9c4837bd7342dd616d0fec",
  "headers": {
      "Authorization": "Bearer xxxx",
      "Accept": "application/vnd.loom"
    },
    "md5": "(some 32 character hex value)"
}
```

### Continuous: Get available search filters

To support flexible search this provides a means of identifying the search filters supported by the data provider.

`GET /continuous/search/filters`

The reponse is a list of search filters in JSON format unless an alternative formatting supported by the server is requested.

#### Response

The server shall return the available filters as a list of JSON formatted objects.  The server may return the objects in an alternative formatting, such as plain text, if requested by the client via the `Accept` header and the format is supported by the server.

On success and one or more filters are returned the server MUST issue a 200 status code.

The response to a continuous search filter query is a list of JSON objects each with the following fields:

| Data Field    | Data Type | Required | Description 
|---------------|-----------|----------|-----------|
| `filter`      | string    | Yes      | A unique name for the filter for use in search query URLs |
| `fieldType`    | string    | Yes      | The dataType (`string`, `float`, etc.) of the filter |
| `description` | string    | Yes      | Detailed description of the filter |
| `values` | string array   | Optional | List of supported values for the filter |

#### An example response

```
[
  {
    filter: "cell_type",
    fieldType: "string",
    description: "cell type",
    values: ["Brain", "Bone", "Kidney"]
  },
  {
    filter: "assay_type",
    fieldType: "string",
    description: "type of assay",
    values: ["Histone"]
  }
]
```

## Possible Future API Enhancements

- Allow OR for search filters
- Report size of download file
- Matrix slicing with bool array or list of indices

## API specification change log

1.0.0    Initial release version
