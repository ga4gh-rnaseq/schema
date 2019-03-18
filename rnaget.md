---
layout: default
title: rnaget API specification
suppress_footer: true
---

# rnaget API

# Version: 1.0.0

# Design principles

This API provides a means of retrieving RNA-seq expression data via a client/server model.

Features of this API include:

* A matrix representation for expression data to allow for efficient retrieval of large numbers of results
* Support for a hierarchical data model which provides the option for servers to associate expression data for discovery and retrieval
* Support for accessing subsets of expression data through slicing operations on the expression matrix and/or query filters to specify features to be included

Out of the scope of this API are:

* A means of retrieving primary (raw) read sequence data.  Expression matrices provide a means to link each included sample to the corresponding input read sequences and servers should implement additional API(s) to allow for search and retrieval of raw reads.
* A means of retrieving reference sequences.  Expression matrices provide a means to link each included sample to the genomic reference used for alignment.  Servers should implement additional API(s) to allow for search and retrieval of reference base sequences.
* A means of retrieving feature annotation details.  Expression matrices provide a means to link each mapped feature to the corresponding annotation.  Servers should implement additional API(s) to allow for search and retrieval of genomic feature annotation details.

# Protocol essentials

All API invocations are made to a configurable HTTPS endpoint, receive URL-encoded query string parameters, and return JSON output. Successful requests result with HTTP status code 200 and have UTF8-encoded JSON in the response body. The server may provide responses with chunked transfer encoding. The client and server may mutually negotiate HTTP/2 upgrade using the standard mechanism.

# Errors

The server MUST respond with an appropriate HTTP status code (4xx or 5xx) when an error condition is detected.

# Request

This section lists the recommended URL endpoints a server SHOULD implement in order to navigate the RNA-seq data hierarchy and allow retrieval of expression data.

Endpoints are described as HTTPS GET methods which will be sufficient for most queries.  Queries containing multiple metadata filters may approach or exceed the URL length limits.  To handles these types of queries it is recommended that servers SHOULD implement parallel HTTPS POST endpoints accepting the same URL parameters as UTF8-encoded JSON.

When processing requests containing multiple filters, the data provider SHOULD use a logical `AND` for selecting the results to return.

## Project Get Methods

The recommended endpoint to return project data is:

    GET /projects/<id>

### URL parameters

<table>
<tr markdown="block"><td>
`id`
</td><td>
_required string_
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
`tags`
</td><td>
_optional string_
</td><td>
Comma separated tag list to filter by
</td></tr>
<tr markdown="block"><td>
`version`
</td><td>
_optional string_
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
`id`
</td><td>
_required string_
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
`tags`
</td><td>
_optional string_
</td><td>
Comma separated tag list to filter by
</td></tr>
<tr markdown="block"><td>
`version`
</td><td>
_optional string_  
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
`id`
</td><td>
_required string_
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
`tags`  
</td><td>
_optional string_
</td><td>
Comma separated tag list to filter by
</td></tr>
<tr markdown="block"><td>
`version`
</td><td>
_optional string_  
</td><td>
Version to return
</td></tr>
<tr markdown="block"><td>
`sampleID`
</td><td>
_optional string_  
</td><td>
sampleID to match
</td></tr>
<tr markdown="block"><td>
`projectID`
</td><td>
_optional string_  
</td><td>
project to filter by
</td></tr>
<tr markdown="block"><td>
`studyID`
</td><td>
_optional string_  
</td><td>
study to filter by
</td></tr>
<tr markdown="block"><td>
`featureIDList`
</td><td>
_optional string_  
</td><td>
return only values for listed feature ID values
</td></tr>
<tr markdown="block"><td>
`featureNameList`
</td><td>
_optional string_  
</td><td>
return only values for listed features
</td></tr>
<tr markdown="block"><td>
`featureAccessionList`
</td><td>
_optional string_  
</td><td>
return only values for listed accession numbers
</td></tr>
<tr markdown="block"><td>
`minExpression`
</td><td>
_optional threshold_ array  
</td><td>
return only samples with expression values greater than listed threshold for each corresponding feature in the array
</td></tr>
<tr markdown="block"><td>
`maxExpression`
</td><td>
_optional threshold_ array  
</td><td>
return only samples with expression values less than listed threshold for each corresponding feature in the array
</td></tr>
</table>

### Expression Threshold

<table>
<tr markdown="block"><td>
`threshold`  
</td><td>
_optional float_
</td><td>
Numeric value to compare to expression value when filtering
</td></tr>
<tr markdown="block"><td>
`featureID`
</td><td>
_optional string_  
</td><td>
ID of feature this threshold corresponds to
</td></tr>
<tr markdown="block"><td>
`featureName`
</td><td>
_optional string_  
</td><td>
Name of feature this threshold corresponds to
</td></tr>
<tr markdown="block"><td>
`featureAccession`
</td><td>
_optional string_  
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
`type`
</td><td>
_optional string_
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
`id`
</td><td>
_required string_
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
`tags`  
</td><td>
_optional string_
</td><td>
Comma separated tag list to filter by
</td></tr>
<tr markdown="block"><td>
`projectID`
</td><td>
_optional string_  
</td><td>
project to filter by
</td></tr>
<tr markdown="block"><td>
`studyID`
</td><td>
_optional string_  
</td><td>
study to filter by
</td></tr>
<tr markdown="block"><td>
`fileType`
</td><td>
_optional string_  
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
`version`
</td><td>
_required string_
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
`id`
</td><td>
_required string_
</td><td>
A unique identifier assigned to this object
</td></tr>
<tr markdown="block"><td>
`version`
</td><td>
_optional string_
</td><td>
Version number of the object
</td></tr>
<tr markdown="block"><td>
`tags`
</td><td>
_optional string_ array
</td><td>
List of tags associated with the object
</td></tr>
<tr markdown="block"><td>
`name`
</td><td>
_optional string_
</td><td>
Short, readable name
</td></tr>
<tr markdown="block"><td>
`description`
</td><td>
_optional string_
</td><td>
Detailed description of the object
</td></tr>
</table>

## Project Filters
To support flexible search this provides a means of identifying the search filters supported by the data provider.

The response to a project filter query is an array in which each element has the following fields:

<table>
<tr markdown="block"><td>
`filter`
</td><td>
_required string_
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
`id`
</td><td>
_required string_
</td><td>
A unique identifier assigned to this object
</td></tr>
<tr markdown="block"><td>
`version`
</td><td>
_optional string_
</td><td>
Version number of the object
</td></tr>
<tr markdown="block"><td>
`tags`
</td><td>
_optional string_ array
</td><td>
List of tags associated with the object
</td></tr>
<tr markdown="block"><td>
`name`
</td><td>
_optional string_
</td><td>
Short, readable name
</td></tr>
<tr markdown="block"><td>
`description`
</td><td>
_optional string_
</td><td>
Detailed description of the object
</td></tr>
<tr markdown="block"><td>
`parentProjectID`
</td><td>
_optional string_
</td><td>
ID of the project containing the study
</td></tr>
<tr markdown="block"><td>
`sampleList`
</td><td>
_optional string_ array
</td><td>
ID(s) of samples which provided the read data for the study
</td></tr>
</table>

## Study Filters
To support flexible search this provides a means of identifying the search filters supported by the data provider.

The response to a study filter query is an array in which each element has the following fields:

<table>
<tr markdown="block"><td>
`filter`
</td><td>
_required string_
</td><td>
A unique name for the filter for use in search query URLs
</td></tr>
</table>

## Expression
The expression is a matrix of calculated expression values.

The response to an expression query is an array in which each element has the following fields:

<table>
<tr markdown="block"><td>
`expressionDataURL`
</td><td>
_required string_
</td><td>
URL for download or stream of expression data bundle
</td></tr>
</table>

## Expression Filters
To support flexible search this provides a means of identifying the search filters supported by the data provider.

The response to an expression filter query is an array in which each element has the following fields:

<table>
<tr markdown="block"><td>
`filterType`
</td><td>
_required string_
</td><td>
Identifies the axis to which these filter apply.  One of:

feature, sample

</td></tr>
<tr markdown="block"><td>
`filters`
</td><td>
_optional string_ array
</td><td>
List of unique names for the filters to be used in search query URLs
</td></tr>
</table>

## File
The file response is a URL for downloading the requested file.  Supported files include input and interim processing pipeline files.  Example files include:

The response to a file query is an array in which each element has the following fields:

<table>
<tr markdown="block"><td>
`id`
</td><td>
_required string_
</td><td>
A unique identifier assigned to this object
</td></tr>
<tr markdown="block"><td>
`version`
</td><td>
_optional string_
</td><td>
Version number of the object
</td></tr>
<tr markdown="block"><td>
`tags`
</td><td>
_optional string_ array
</td><td>
List of tags associated with the object
</td></tr>
<tr markdown="block"><td>
`fileType`
</td><td>
_optional string_
</td><td>
Type of file.  Examples include:

* BAM
</td></tr>
<tr markdown="block"><td>
`studyID`
</td><td>
_optional string_
</td><td>
ID of containing study
</td></tr>
<tr markdown="block"><td>
`URL`
</td><td>
_required string_
</td><td>
URL to download file.
</td></tr>
</table>

## Changelog
The changelog is a list of changes to the database associated with a version update.

The response to a changelog query is an array in which each element has the following fields:

<table>
<tr markdown="block"><td>
`version`
</td><td>
_required string_
</td><td>
Version number of the object
</td></tr>
<tr markdown="block"><td>
`log`
</td><td>
_optional string_ array
</td><td>
List of the specific changes made to the DB
</td></tr>
<table>

# API specification change log
2019-MM-DD:    1.0.0    Initial release version <pending>
