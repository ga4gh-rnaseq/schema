---
layout: default
title: rnaseq expression protocol
suppress_footer: true
---

# RNA-seq expression API spec v0.1.0

# Design principles

This API provides a means of retrieving RNA-seq expression data via a client/server model.

Features of this API include:

* A matrix representation for expression data to allow for efficient retrieval of large numbers of results
* Support for a hierarchical data model which provides the option for servers to associate expression data for discovery and retrieval
* Support for accessing subsets of expression data through slicing operations on the expression matrix and/or query filters to specify features to be included
* A method to return per-base values over an interval which could be a subset of the genome or the entire genome similar to a wiggle representation used for visualization

Out of the scope if this API are:

* A means of retrieving primary read sequence data.  Expression matrices provide a means to link to their input read sequences and servers should implement additional API(s) to allow for search and retrieval of raw reads.
* A means of retrieving reference sequences.  Expression matrices provide a means to link to the genomic reference used for alignment.  Servers should implement additional API(s) to allow for search and retrieval of reference base sequences.

# Protocol essentials

All API invocations are made to a configurable HTTP(S) endpoint, receive URL-encoded query string parameters, and return JSON output. Successful requests result with HTTP status code 200 and have UTF8-encoded JSON in the response body. The server may provide responses with chunked transfer encoding. The client and server may mutually negotiate HTTP/2 upgrade using the standard mechanism.

# Errors

The server MUST respond with an appropriate HTTP status code (4xx or 5xx) when an error condition is detected.

# Request

## Project Methods

The recommended endpoint to return project data is:

    GET /projects/<id>

## URL parameters

<table>
<tr markdown="block"><td>
`id`
</td><td>
_string_
</td><td>
A string identifying which records to return.  If left blank all available projects will be returned.

The format of this identifier is left to the discretion of the API provider, including allowing embedded "/" characters. The following would be valid identifiers:

* some-projectId or /byContributor/some-projectId
</td></tr>
</table>

## Project Search Methods

The recommended search endpoint is:

    GET /projects/search

## Search Query Filters

<table>
<tr markdown="block"><td>
`tags`
</td><td>
_string_
</td><td>
Comma separated tag list to filter by
</td></tr>
<tr markdown="block"><td>
`version`
</td><td>
_string_
</td><td>
Version to return
</td></tr>
</table>

## Study Methods

The recommended endpoint to return study data is:

    GET /studies/<id>

## URL parameters

<table>
<tr markdown="block"><td>
`id`
</td><td>
_string_
</td><td>
A string identifying which records to return.  If left blank all available studies will be returned.

The format of this identifier is left to the discretion of the API provider, including allowing embedded "/" characters. The following would be valid identifiers:

* some-studyId or /byProject/some-studyId
</td></tr>
</table>

## Study Search Methods

The recommended search endpoint is:

    GET /studies/search

## Search Query Filters

<table>
<tr markdown="block"><td>
`tags`  
</td><td>
_string_
</td><td>
Comma separated tag list to filter by
</td></tr>
<tr markdown="block"><td>
`version`
</td><td>
_string_  
</td><td>
Version to return
</td></tr>
</table>

## RNA Expression Methods

The recommended endpoint to return expression data is:

    GET /expressions/<id>

## URL parameters

<table>
<tr markdown="block"><td>
`id`
_required_
</td><td>
_string_
</td><td>
A string identifying which record to return.

The format of this identifier is left to the discretion of the API provider, including allowing embedded "/" characters. The following would be valid identifiers:

* some-expressionId or /bySample/some-expressionId
</td></tr>
</table>

## Expression Search Methods

The recommended search endpoint is:

    GET /expressions/search

## Search Query Filters

<table>
<tr markdown="block"><td>
`tags`  
</td><td>
_string_
</td><td>
Comma separated tag list to filter by
</td></tr>
<tr markdown="block"><td>
`version`
</td><td>
_string_  
</td><td>
Version to return
</td></tr>
<tr markdown="block"><td>
`organism`
</td><td>
_string_  
</td><td>
organism to match
</td></tr>
<tr markdown="block"><td>
`reference`
</td><td>
_string_  
</td><td>
genomic reference to filter by
</td></tr>
<tr markdown="block"><td>
`annotation`
</td><td>
_string_  
</td><td>
annotation to filter by
</td></tr>
<tr markdown="block"><td>
`tissue`
</td><td>
_string_  
</td><td>
tissue type to match
</td></tr>
<tr markdown="block"><td>
`sampleID`
</td><td>
_string_  
</td><td>
sampleID to match
</td></tr>
<tr markdown="block"><td>
`projectID`
</td><td>
_string_  
</td><td>
project to filter by
</td></tr>
<tr markdown="block"><td>
`studyID`
</td><td>
_string_  
</td><td>
study to filter by
</td></tr>
<tr markdown="block"><td>
`geneNameList`
</td><td>
_string_  
</td><td>
return only values for listed genes
</td></tr>
<tr markdown="block"><td>
`geneAccessionList`
</td><td>
_string_  
</td><td>
return only values for listed accession numbers
</td></tr>
</table>

## File Methods

The recommended endpoint to return file retrieval URLs is:

    GET /files/<id>

## URL parameters

<table>
<tr markdown="block"><td>
`id`
_required_
</td><td>
_string_
</td><td>
A string identifying which record to return.

The format of this identifier is left to the discretion of the API provider, including allowing embedded "/" characters. The following would be valid identifiers:

* some-fileId or /bam_files/some-fileId
</td></tr>
</table>

## File Search Methods

The recommended search endpoint is:

    GET /files/search

## Search Query Filters

<table>
<tr markdown="block"><td>
`tags`  
</td><td>
_string_
</td><td>
Comma separated tag list to filter by
</td></tr>
<tr markdown="block"><td>
`projectID`
</td><td>
_string_  
</td><td>
project to filter by
</td></tr>
<tr markdown="block"><td>
`studyID`
</td><td>
_string_  
</td><td>
study to filter by
</td></tr>
<tr markdown="block"><td>
`fileType`
</td><td>
_string_  
</td><td>
File type to filter by
</td></tr>
</table>

## Additional Methods

## Database Methods
The recommended endpoints to return database related data are:

    GET /getVersions
    GET /changeLog/<version>

## Changelog URL parameters

<table>
<tr markdown="block"><td>
`version`
_required_
</td><td>
_string_
</td><td>
A string identifying which version to return the changelog for.

The format of this identifier is left to the discretion of the API provider, including allowing embedded "/" characters. The following would be valid identifiers:

* some-version-string or /byDate/some-version-string
</td></tr>
</table>

## Responses

## Project
The project is the top level of the model hierarchy and contains a set of related studies.  Example projects include:

* all data submitted by contributor X
* the local mirror of the European Nucleotide Archive data

The response to a project query is an array in which each element has the following fields:

<table>
<tr markdown="block"><td>
`id`
_required_
</td><td>
_string_
</td><td>
A unique identifier assigned to this object
</td></tr>
<tr markdown="block"><td>
`version`
</td><td>
_string_
</td><td>
Version number of the object
</td></tr>
<tr markdown="block"><td>
`tags`
</td><td>
_string_ array
</td><td>
List of tags associated with the object
</td></tr>
<tr markdown="block"><td>
`name`
</td><td>
_string_
</td><td>
Short, readable name
</td></tr>
<tr markdown="block"><td>
`description`
</td><td>
_string_
</td><td>
Detailed description of the object
</td></tr>
</table>

## Study
The study is a set of related RNA expression values.  The samples in a study have been processed uniformly.  Example studies include:

* multiple tissues from all patients enrolled in clinical trial X
* a collection of liver samples from several sources which have been uniformly reprocessed for differential analysis

The response to a study query is an array in which each element has the following fields:

<table>
<tr markdown="block"><td>
`id`
_required_
</td><td>
_string_
</td><td>
A unique identifier assigned to this object
</td></tr>
<tr markdown="block"><td>
`version`
</td><td>
_string_
</td><td>
Version number of the object
</td></tr>
<tr markdown="block"><td>
`tags`
</td><td>
_string_ array
</td><td>
List of tags associated with the object
</td></tr>
<tr markdown="block"><td>
`name`
</td><td>
_string_
</td><td>
Short, readable name
</td></tr>
<tr markdown="block"><td>
`description`
</td><td>
_string_
</td><td>
Detailed description of the object
</td></tr>
<tr markdown="block"><td>
`parentProjectID`
</td><td>
_string_
</td><td>
ID of the project containing the study
</td></tr>
<tr markdown="block"><td>
`patientList`
</td><td>
_string_ array
</td><td>
ID(s) of patients supplying the samples in the study
</td></tr>
<tr markdown="block"><td>
`sampleList`
</td><td>
_string_ array
</td><td>
ID(s) of samples which provided the read data for the study
</td></tr>
</table>

## Expression
The expression is a matrix of calculated expression values.

The response to an expression query is an array in which each element has the following fields:

<table>
<tr markdown="block"><td>
`id`
_required_
</td><td>
_string_
</td><td>
A unique identifier assigned to this object
</td></tr>
<tr markdown="block"><td>
`version`
</td><td>
_string_
</td><td>
Version number of the object
</td></tr>
<tr markdown="block"><td>
`tags`
</td><td>
_string_ array
</td><td>
List of tags associated with the object
</td></tr>
<tr markdown="block"><td>
`parentStudyID`
</td><td>
_string_
</td><td>
ID of containing study
</td></tr>
<tr markdown="block"><td>
`organism`
</td><td>
_string_
</td><td>
Organism of the sample
</td></tr>
<tr markdown="block"><td>
`tissue`
</td><td>
_string_
</td><td>
Sample tissue type
</td></tr>
<tr markdown="block"><td>
`sampleID`
</td><td>
_string_
</td><td>
ID of the source sample
</td></tr>
<tr markdown="block"><td>
`expressionDataURL`
_required_
</td><td>
_string_
</td><td>
URL for download of expression data bundle
</td></tr>
</table>

## File
The file response is a URL for downloading the requested file.  Supported files include input and interim processing pipeline files.  Example files include:

The response to a file query is an array in which each element has the following fields:

<table>
<tr markdown="block"><td>
`id`
_required_
</td><td>
_string_
</td><td>
A unique identifier assigned to this object
</td></tr>
<tr markdown="block"><td>
`version`
</td><td>
_string_
</td><td>
Version number of the object
</td></tr>
<tr markdown="block"><td>
`tags`
</td><td>
_string_ array
</td><td>
List of tags associated with the object
</td></tr>
<tr markdown="block"><td>
`fileType`
</td><td>
_string_
</td><td>
Type of file.  Examples include:

* BAM
</td></tr>
<tr markdown="block"><td>
`studyID`
</td><td>
_string_
</td><td>
ID of containing study
</td></tr>
<tr markdown="block"><td>
`URL`
_required_
</td><td>
_string_
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
_required_
</td><td>
_string_
</td><td>
Version number of the object
</td></tr>
<tr markdown="block"><td>
`log`
</td><td>
_string_ array
</td><td>
List of the specific changes made to the DB
</td></tr>
<table>
