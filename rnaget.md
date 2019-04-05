---
layout: default
title: rnaget API specification
suppress_footer: true
---

# rnaget API

# Version: 1.0.0

## Design principles

This API provides a means of retrieving RNA-seq expression data via a client/server model.

Features of this API include:

* Support for a hierarchical data model which provides the option for servers to associate expression data for discovery and retrieval
* Support for accessing subsets of expression data through slicing operations on the expression matrix and/or query filters to specify features to be included

Out of the scope of this API are:

* A means of retrieving primary (raw) read sequence data.  Input samples are identified in expression output and data servers should implement additional API(s) to allow for search and retrieval of raw reads.  The [htsget API](https://samtools.github.io/hts-specs/htsget.html) is designed for retrieval of read data.
* A means of retrieving reference sequences.  Each study lists the genomic reference used for alignment.  Servers should implement additional API(s) to allow for search and retrieval of reference base sequences.  The [rnaget API](https://samtools.github.io/hts-specs/rnaget.html) is designed for retrieval of references sequences.
* A means of retrieving feature annotation details.  Expression matrices provide a means to link each mapped feature to the corresponding annotation.  Servers should implement additional API(s) to allow for search and retrieval of genomic feature annotation details.

## OpenAPI Description

An OpenAPI description of this specification is available and [describes the 1.0.0 version](rnaget-openapi.yaml). OpenAPI is a language independent way of describing REST services and is compatible with a number of [third party tools](http://openapi.tools/).

## Compliance

Implementors can check if their rnaget implementations conform to the specification by using our [compliance suite](https://github.com/ga4gh-rnaseq/rnaget-compliance-suite).

## Protocol essentials

All API invocations are made to a configurable HTTPS endpoint, receive URL-encoded query string parameters and HTTP headers, and return text or other allowed formatting as requested by the user. Successful requests result with HTTP status code 200 and have the appropriate text encoding in the response body as defined for each endpoint. The server may provide responses with chunked transfer encoding. The client and server may mutually negotiate HTTP/2 upgrade using the standard mechanism.

Requests adhering to this specification MAY include an Accept header specifying an alternative formatting of the response, if the server allows this. Otherwise the server shall return the default content type specified for the invoked method.

HTTP responses may be compressed using [RFC 2616](https://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html) transfer-coding, not content-coding.

HTTP response may include a 3XX response code and Location header redirecting the client to retrieve expression data from an alternate location as specified by [RFC 7231](https://tools.ietf.org/html/rfc7231), clients SHOULD be configured follow redirects. `302`, `303` and `307` are all valid response codes to use.

Requests MAY include an Accept header specifying the protocol version they are using:

```
Accept: text/vnd.ga4gh.rnaget.v1.0.0+plain
```

Responses from the server MUST include a Content-Type header containing the encoding for the invoked method and protocol version:

```
Content-Type: text/vnd.ga4gh.rnaget.v1.0.0+plain; charset=us-ascii
```

## Internet Media Types Handling

When responding to a request a server MUST use the fully specified media type for that endpoint. When determining if a request is well-formed, a server MUST allow a internet type to degrade like so

- `text/vnd.ga4gh.rnaget.v1.0.0+plain; charset=us-ascii`
  - `text/vnd.ga4gh.rnaget.v1.0.0+plain`
  - `text/plain`
- `application/vnd.ga4gh.rnaget.v1.0.0+json; charset=us-ascii`
  - `application/vnd.ga4gh.rnaget.v1.0.0+json`
  - `application/json`

# Errors

The server MUST respond with an appropriate HTTP status code (4xx or 5xx) when an error condition is detected. In the case of transient server errors (e.g., 503 and other 5xx status codes), the client SHOULD implement appropriate retry logic. For example, if a client sends an alphanumeric string for a parameter that is specified as unsigned integer the server MUST reply with `Bad Request`.

<table>
<tr markdown="block"><td>
Error Type
</td><td>
HTTP status code
</td><td>
Description
</td></tr>
<tr markdown="block"><td>
<code>Bad Request</code>
</td><td>
400
</td><td>
Cannot process due to malformed request, the requested parameters do not adhere to the specification
</td></tr>
<tr markdown="block"><td>
<code>Unauthorized</code>
</td><td>
401
</td><td>
Authorization provided is invalid
</td></tr>
<tr markdown="block"><td>
<code>Not Found</code>
</td><td>
404
</td><td>
The resource requested was not found
</td></tr>
<tr markdown="block"><td>
<code>Not Acceptable</code>
</td><td>
406
</td><td>
The requested formatting is not supported by the server
</td></tr>
<tr markdown="block"><td>
<code>Not Implemented</code>
</td><td>
501
</td><td>
The specified request is not supported by the server
</td></tr>
</table>

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

# Request

This section lists the recommended URL endpoints a server SHOULD implement in order to navigate the RNA-seq data hierarchy and allow retrieval of expression data.

Endpoints are described as HTTPS GET methods which will be sufficient for most queries.  Queries containing multiple metadata filters may approach or exceed the URL length limits.  To handle these types of queries it is recommended that servers SHOULD implement parallel HTTPS POST endpoints accepting the same URL parameters as UTF8-encoded JSON.

When processing requests containing multiple filters, the data provider SHOULD use a logical `AND` for selecting the results to return.

## Project Get Methods

The recommended endpoint to return project data is:

    GET /projects/<id>

### URL parameters

<table>
<tr markdown="block"><td>
<code>id</code>
</td><td>
<code>string</code>
<i>required</i>
</td><td>
A string identifying which record to return.

The format of this identifier is left to the discretion of the API provider, including allowing embedded "/" characters. The following would be valid identifiers:

* some-projectId or /byContributor/some-projectId
</td></tr>
</table>

## Project Search Methods

The recommended search endpoint is:

    GET /projects/search

### Search Query Filters

<table>
<tr markdown="block"><td>
<code>tags</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
Comma separated tag list to filter by
</td></tr>
<tr markdown="block"><td>
<code>version</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
Version to return
</td></tr>
</table>

## Project Search Filters
The recommended endpoint for retrieving search filters is:

    GET /projects/search/filters

## Study Get Methods

The recommended endpoint to return study data is:

    GET /studies/<id>

### URL parameters

<table>
<tr markdown="block"><td>
<code>id</code>
</td><td>
<code>string</code>
<i>required</i>
</td><td>
A string identifying which record to return.

The format of this identifier is left to the discretion of the API provider, including allowing embedded "/" characters. The following would be valid identifiers:

* some-studyId or /byProject/some-studyId
</td></tr>
</table>

## Study Search Methods

The recommended search endpoint is:

    GET /studies/search

### Search Query Filters

<table>
<tr markdown="block"><td>
<code>tags</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
Comma separated tag list to filter by
</td></tr>
<tr markdown="block"><td>
<code>version</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
Version to return
</td></tr>
</table>

## Study Search Filters
The recommended endpoint for retrieving search filters is:

    GET /studies/search/filters

## RNA Expression Get Methods

The recommended endpoint to return expression data is:

    GET /expressions/<id>

### URL parameters

<table>
<tr markdown="block"><td>
<code>id</code>
</td><td>
<code>string</code>
<i>required</i>
</td><td>
A string identifying which record to return.

The format of this identifier is left to the discretion of the API provider, including allowing embedded "/" characters. The following would be valid identifiers:

* some-expressionId or /bySample/some-expressionId
</td></tr>
</table>

## Expression Search Methods

The recommended search endpoint is:

    GET /expressions/search

### Search Query Filters

<table>
<tr markdown="block"><td>
<code>tags</code>  
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
Comma separated tag list to filter by
</td></tr>
<tr markdown="block"><td>
<code>version</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
Version to return
</td></tr>
<tr markdown="block"><td>
<code>sampleIDList</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
comma separated list of sampleIDs to match
</td></tr>
<tr markdown="block"><td>
<code>projectID</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
project to filter by
</td></tr>
<tr markdown="block"><td>
<code>studyID</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
study to filter by
</td></tr>
<tr markdown="block"><td>
<code>featureIDList</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
return only values for listed comma separated feature ID values
</td></tr>
<tr markdown="block"><td>
<code>featureNameList</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
return only values for listed comma separated features
</td></tr>
<tr markdown="block"><td>
<code>featureAccessionList</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
return only values for listed comma separated accession numbers
</td></tr>
<tr markdown="block"><td>
<code>minExpression</code>
</td><td>
<code>threshold</code> array  
<i>optional</i>
</td><td>
return only samples with expression values greater than listed threshold for each corresponding feature in the array
</td></tr>
<tr markdown="block"><td>
<code>maxExpression</code>
</td><td>
<code>threshold</code> array  
<i>optional</i>
</td><td>
return only samples with expression values less than listed threshold for each corresponding feature in the array
</td></tr>
</table>

### Expression Threshold

<table>
<tr markdown="block"><td>
<code>threshold</code>  
</td><td>
<code>float</code>
<i>optional</i>
</td><td>
Numeric value to compare to expression value when filtering
</td></tr>
<tr markdown="block"><td>
<code>featureID</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
ID of feature this threshold corresponds to
</td></tr>
<tr markdown="block"><td>
<code>featureName</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
Name of feature this threshold corresponds to
</td></tr>
<tr markdown="block"><td>
<code>featureAccession</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
Accession of feature this threshold corresponds to
</td></tr>
</table>

For each threshold tuple the request SHOULD provide only one of `featureID`, `featureName` or `featureAccession`.

## Expression Search Filters
The recommended endpoint for retrieving search filters is:

    GET /expressions/search/filters

### URL parameters

<table>
<tr markdown="block"><td>
<code>type</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
A string identifying the type of filters to return.  This is one of two values:

feature - returns filters on the feature axis of the matrix

sample - returns filters on the sample axis of the matrix

If not present both lists will be returned.

</td></tr>
</table>

## File Get Methods

The recommended endpoint to return file retrieval URLs is:

    GET /files/<id>

### URL parameters

<table>
<tr markdown="block"><td>
<code>id</code>
</td><td>
<code>string</code>
<i>required</i>
</td><td>
A string identifying which record to return.

The format of this identifier is left to the discretion of the API provider, including allowing embedded "/" characters. The following would be valid identifiers:

* some-fileId or /bam_files/some-fileId
</td></tr>
</table>

## File Search Methods

The recommended search endpoint is:

    GET /files/search

### Search Query Filters

<table>
<tr markdown="block"><td>
<code>tags</code>  
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
Comma separated tag list to filter by
</td></tr>
<tr markdown="block"><td>
<code>projectID</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
project to filter by
</td></tr>
<tr markdown="block"><td>
<code>studyID</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
study to filter by
</td></tr>
<tr markdown="block"><td>
<code>fileType</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
File type to filter by
</td></tr>
</table>

## Additional Methods

## Database Get Methods
The recommended endpoints to return database related data are:

    GET /getVersions
    GET /changeLog/<version>

### Changelog URL parameters

<table>
<tr markdown="block"><td>
<code>version</code>
</td><td>
<code>string</code>
<i>required</i>
</td><td>
A string identifying which version to return the changelog for.

The format of this identifier is left to the discretion of the API provider, including allowing embedded "/" characters. The following would be valid identifiers:

* some-version-string or /byDate/some-version-string
</td></tr>
</table>

# Responses

## Project
The project is the top level of the model hierarchy and contains a set of related studies.  Example projects include:

* all data submitted by contributor X
* the local mirror of the European Nucleotide Archive data

The response to a project query is an array in which each element has the following fields:

<table>
<tr markdown="block"><td>
<code>id</code>
</td><td>
<code>string</code>
<i>required</i>
</td><td>
A unique identifier assigned to this object
</td></tr>
<tr markdown="block"><td>
<code>version</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
Version number of the object
</td></tr>
<tr markdown="block"><td>
<code>tags</code>
</td><td>
<code>string</code> array
<i>optional</i>
</td><td>
List of tags associated with the object
</td></tr>
<tr markdown="block"><td>
<code>name</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
Short, readable name
</td></tr>
<tr markdown="block"><td>
<code>description</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
Detailed description of the object
</td></tr>
</table>

## Project Filters
To support flexible search this provides a means of identifying the search filters supported by the data provider.

The response to a project filter query is an array in which each element has the following fields:

<table>
<tr markdown="block"><td>
<code>filter</code>
</td><td>
<code>string</code>
<i>required</i>
</td><td>
A unique name for the filter for use in search query URLs
</td></tr>
</table>

## Study
The study is a set of related RNA expression values.  It is assumed all samples in a study have been processed uniformly.  Example studies include:

* multiple tissues from all patients enrolled in clinical trial X
* a collection of liver samples from several sources which have been uniformly reprocessed for differential analysis

The response to a study query is an array in which each element has the following fields:

<table>
<tr markdown="block"><td>
<code>id</code>
</td><td>
<code>string</code>
<i>required</i>
</td><td>
A unique identifier assigned to this object
</td></tr>
<tr markdown="block"><td>
<code>version</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
Version number of the object
</td></tr>
<tr markdown="block"><td>
<code>tags</code>
</td><td>
<code>string</code> array
<i>optional</i>
</td><td>
List of tags associated with the object
</td></tr>
<tr markdown="block"><td>
<code>name</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
Short, readable name
</td></tr>
<tr markdown="block"><td>
<code>description</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
Detailed description of the object
</td></tr>
<tr markdown="block"><td>
<code>parentProjectID</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
ID of the project containing the study
</td></tr>
<tr markdown="block"><td>
<code>genome</code>
</td><td>
<code>string</code> array
<i>optional</i>
</td><td>
Name of the reference genome build used for aligning samples in the study.
</td></tr>
<tr markdown="block"><td>
<code>sampleList</code>
</td><td>
<code>string</code> array
<i>optional</i>
</td><td>
ID(s) of samples which provided the read data for the study
</td></tr>
</table>

## Study Filters
To support flexible search this provides a means of identifying the search filters supported by the data provider.

The response to a study filter query is an array in which each element has the following fields:

<table>
<tr markdown="block"><td>
<code>filter</code>
</td><td>
<code>string</code>
<i>required</i>
</td><td>
A unique name for the filter for use in search query URLs
</td></tr>
</table>

## Expression
The expression is a matrix of calculated expression values.

The response to an expression query is an array in which each element is a File object as described below.

## Expression Filters
To support flexible search this provides a means of identifying the search filters supported by the data provider.

The response to an expression filter query is an array in which each element has the following fields:

<table>
<tr markdown="block"><td>
<code>filterType</code>
</td><td>
<code>string</code>
<i>required</i>
</td><td>
Identifies the axis to which these filter apply.  One of:

feature, sample

</td></tr>
<tr markdown="block"><td>
<code>filters</code>
</td><td>
<code>string</code> array
<i>optional</i>
</td><td>
List of unique names for the filters to be used in search query URLs
</td></tr>
</table>

## File
The file response is a URL for downloading the requested file.  Supported files include input and interim processing pipeline files.  Example files include:

The response to a file query is an array in which each element has the following fields:

<table>
<tr markdown="block"><td>
<code>id</code>
</td><td>
<code>string</code>
<i>required</i>
</td><td>
A unique identifier assigned to this object
</td></tr>
<tr markdown="block"><td>
<code>version</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
Version number of the object
</td></tr>
<tr markdown="block"><td>
<code>tags</code>
</td><td>
<code>string</code> array
<i>optional</i>
</td><td>
List of tags associated with the object
</td></tr>
<tr markdown="block"><td>
<code>fileType</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
Type of file.  Examples include:

* BAM
</td></tr>
<tr markdown="block"><td>
<code>studyID</code>
</td><td>
<code>string</code>
<i>optional</i>
</td><td>
ID of containing study
</td></tr>
<tr markdown="block"><td>
<code>URL</code>
</td><td>
<code>string</code>
<i>required</i>
</td><td>
URL to download file.
</td></tr>
</table>

## Changelog
The changelog is a list of changes to the database associated with a version update.

The response to a changelog query is an array in which each element has the following fields:

<table>
<tr markdown="block"><td>
<code>version</code>
</td><td>
<code>string</code>
<i>required</i>
</td><td>
Version number of the object
</td></tr>
<tr markdown="block"><td>
<code>log</code>
</td><td>
<code>string</code> array
<i>optional</i>
</td><td>
List of the specific changes made to the DB
</td></tr>
<table>

## Possible Future API Enhancements

- Allow OR for search filters

## API specification change log
2019-MM-DD:    1.0.0    Initial release version (pending)
