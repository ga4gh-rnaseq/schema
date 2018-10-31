---
layout: default
title: sequence annotation protocol
suppress_footer: true
---

# Sequence Annotation API spec v0.1.0

# Design principles

This API provides a means of retrieving genomic sequence annotation data via a client/server model.

Features of this API include:

* A method to return annotated genomic features in a format compatible with the standard GFF/GTF format
* A method to return per-base values over an interval which could be a subset of the genome or the entire genome similar to a wiggle representation used for visualization

Out of the scope if this API are:

* A means of retrieving reference sequences.  Expression matrices provide a means to link to the genomic reference used for alignment.  Servers should implement additional API(s) to allow for search and retrieval of reference base sequences.

# Protocol essentials

All API invocations are made to a configurable HTTP(S) endpoint, receive URL-encoded query string parameters, and return JSON output. Successful requests result with HTTP status code 200 and have UTF8-encoded JSON in the response body. The server may provide responses with chunked transfer encoding. The client and server may mutually negotiate HTTP/2 upgrade using the standard mechanism.

# Errors

The server MUST respond with an appropriate HTTP status code (4xx or 5xx) when an error condition is detected.

# Request

## Sequence Annotation Methods

The recommended endpoint to return sequence annotation data is:

    GET /annotations/<id>

## URL parameters

<table>
<tr markdown="block"><td>
`id`
</td><td>
_string_
</td><td>
A string identifying which records to return.  If left blank all available projects will be returned.

The format of this identifier is left to the discretion of the API provider, including allowing embedded "/" characters. The following would be valid identifiers:

* some-annotationId or /byGenome/some-annotationId
</td></tr>
</table>

## Sequence Annotation Search Methods

The recommended search endpoint is:

    GET /annotations/search

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
`reference`
</td><td>
_string_
</td><td>
return annotations for specified referenceID
</td></tr>
</table>

## Feature Methods

The recommended endpoint to return specific feature data is:

    GET /features/<id>

## URL parameters

<table>
<tr markdown="block"><td>
`id`
</td><td>
_string_
</td><td>
A string identifying which records to return.  If left blank all available studies will be returned.

The format of this identifier is left to the discretion of the API provider, including allowing embedded "/" characters. The following would be valid identifiers:

* some-featureId or /byAnnotation/some-featureId
</td></tr>
</table>

## Feature Search Methods

The recommended search endpoint is:

    GET /features/search

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
`gene`
</td><td>
_string_  
</td><td>
gene name of feature to filter by
</td></tr>
<tr markdown="block"><td>
`accession`
</td><td>
_string_  
</td><td>
accession number of feature to filter by
</td></tr>
<tr markdown="block"><td>
`type`
</td><td>
_string_  
</td><td>
feature type to filter by
</td></tr>
<tr markdown="block"><td>
`reference`
</td><td>
_string_  
</td><td>
referenceID to filter by
</td></tr>
</table>

## Continuous Value Methods

The recommended endpoint to return continuous data is:

    GET /continuous/<id>

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

* some-continuousId or /bySample/some-continuousId
</td></tr>
</table>

## Continuous Value Search Methods

The recommended search endpoint is:

    GET /continuous/search

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
`reference`
</td><td>
_string_  
</td><td>
return continuous for specified referenceID
</td></tr>
<tr markdown="block"><td>
`start`
</td><td>
_integer_  
</td><td>
starting coordinate of open interval to filter by

Default: `0`
</td></tr>
<tr markdown="block"><td>
`end`
</td><td>
_integer_  
</td><td>
ending coordinate of open interval to filter by
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

## Sequence Annotation
The sequence annotation is a top level genomic annotation object corresponding to a single GFF file.

The sequence annotation has the following fields:

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
`referenceGenomeID`
_required_
</td><td>
_string_
</td><td>
ID of the annotation reference
</td></tr>
<table>

## Feature
A feature is an element within a sequence annotation and corresponds to a single line of a GFF file.

A feature has the following fields:

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
`accession`
_required_
</td><td>
_string_
</td><td>
Accession number
</td></tr>
<tr markdown="block"><td>
`name`
</td><td>
_string_
</td><td>
Short, readable name
</td></tr>
<tr markdown="block"><td>
`seqName`
_required_
</td><td>
_string_
</td><td>
Name of the reference
</td></tr>
<tr markdown="block"><td>
`start`
_required_
</td><td>
_int_
</td><td>
Zero-based start coordinate
</td></tr>
<tr markdown="block"><td>
`end`
_required_
</td><td>
_int_
</td><td>
Zero-based end coordinate
</td></tr>
<tr markdown="block"><td>
`strand`
</td><td>
_string_
</td><td>
Strand feature is located on.  Default: `+`
</td></tr>
<tr markdown="block"><td>
`featureType`
_required_
</td><td>
_string_
</td><td>
Type of feature.
</td></tr>
<tr markdown="block"><td>
`parentID`
</td><td>
_string_
</td><td>
ID of the parent feature, if any.
</td></tr>
<tr markdown="block"><td>
`childIDs`
</td><td>
_string_ array
</td><td>
ID(s) of any child feature(s)
</td></tr>
<tr markdown="block"><td>
`attributes`
</td><td>
_string_ array
</td><td>
List of feature attributes in `key`:`value` format
</td></tr>
<table>

## Continuous Annotation
A continuous annotation is an array of values for a contiguous interval of bases.  There is a single value for each base in the interval.  This is analogous to a wiggle file.

A continuous annotation has the following fields:

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
`seqName`
_required_
</td><td>
_string_
</td><td>
Name of the reference
</td></tr>
<tr markdown="block"><td>
`start`
</td><td>
_int_
</td><td>
Zero-based start coordinate.  Default: `0`
</td></tr>
<tr markdown="block"><td>
`strand`
</td><td>
_string_
</td><td>
Strand of the feature.  Default: `+`
</td></tr>
<tr markdown="block"><td>
`values`
_required_
</td><td>
_float_ array
</td><td>
Numeric value for each base beginning at `start` with no skipped positions.  The length of `values` defines the interval
</td></tr>
<table>

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

* GTF
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


