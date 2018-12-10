# Expression Matrix Data Model

The use cases indicate that an expression matrix is a good model and for single cell data a practical way to deliver large datasets.  Associated metadata needs to be tracked and should remain associated with the expression matrix.  Several existing data formats include this feature in their design.  For others, the metadata may need to be in separate files that should remain as a package with the expression matrix.

The matrix and associated metadata should be easy to convert to several formats which the user can request.  Example formats include: HDF5, AnnData, SingleCellExperiment, Zarr, Parquet, Loom, CSV, Matrix Market and others.

_Insert image of the expression matrix model_

### Expression Values Matrix

The core of the expression matrix is the numeric expression values for each feature calculated from the raw reads by the mapping and quantification pipeline.  This is a N x M matrix of floating point values to allow it to be easily imported as a dataframe into downstream analysis pipelines.  In order to conform to modern machine learning and statistics conventions, by default the rows will be samples/libraries and the columns will be features (genes for example).  For interoperability with downstream analysis tools it is recommended that the data provider support a user query requesting the transpose of the matrix.

The matrix will have 2 associated arrays – 1 each for the samples and features axis labels.  These arrays will be the same length as the corresponding axis and contain the IDs of the individual samples and features respectively.  The arrays should preserve the order of the labels and each label should be unique within the array.  It is recommended that the feature IDs be accession numbers to reference the genomic annotation used and promote uniqueness.

### Matrix Metadata Annotations

This model allows for several additional elements containing metadata annotations.  For both the row and column axes there can be a matrix of metadata elements for each entry.  Similar to the main expression matrix, these metadata matrices will each have an associated array containing the unique key values.  The final element is a set of metadata that applies to the matrix as a whole.  This could be processing pipeline, the query that generated the matrix, etc.  Since this is independent of the dimensions of the data matrix it can be a key-value dictionary and could even be stored separately as CSV or some similar compact form.

# Bundle Metadata Discussion

### Minimum Bundle Metadata

The following metadata fields describe a minimal set of metadata necessary to work with the expression values and determine their comparability with other datasets.

<table>
<tr markdown="block"><td>
`workstreamURLs`
</td><td>
_string_ array
</td><td>
URL(s) for the workstream(s) used to calculate expression.  Advise that tool names, versions, settings be included in workstream/pipeline description referenced by this URL
</td></tr>
<tr markdown="block"><td>
`processingTools`
</td><td>
_string_ array
</td><td>
List of tools used in processing.  Entries should include version, command line options, etc.
</td></tr>
<tr markdown="block"><td>
`referenceURL`
</td><td>
_string_
</td><td>
URL of the reference genome used
</td></tr>
<tr markdown="block"><td>
`referenceName`
</td><td>
_string_
</td><td>
Nane of the reference genome
</td></tr>
<tr markdown="block"><td>
`annotationURL`
</td><td>
_string_
</td><td>
URL of the annotation used
</td></tr>
<tr markdown="block"><td>
`annotationName`
</td><td>
_string_
</td><td>
Name of the annotation
</td></tr>
<tr markdown="block"><td>
`organism`
</td><td>
_string_
</td><td>
The species providing the samples.
</td></tr>
<tr markdown="block"><td>
`units`
</td><td>
_string_
</td><td>
A string identifying the unit of measurement.  Ex. TPM, FPKM, count
</td></tr>
</table>

### A place to describe the read processing pipeline

The bundle metadata is intended to contain metadata common to all the samples and features in the associated matrix.  It is highly recommended that this be used to describe the processing pipeline used to quantify the raw reads and produce the expression data.  The genomic reference used to align the reads and the annotation used to map the alignments should also be included here.

### Merged datasets

It may occur that the matrix contains samples from multiple projects or studies.  If elements like the processing pipeline are no longer common to all samples, care should be taken to move this metadata to the samples or features metadata table instead of the bundle metadata.

# Feature Metadata Discussion

### Minimum Feature Metadata

The following metadata fields describe a recommended minimal set of feature metadata.

<table>
<tr markdown="block"><td>
`featureName`
</td><td>
_string_
</td><td>
A human readable name for the feature. Would be better if it were unique to the sample within the database.
</td></tr>
<tr markdown="block"><td>
`featureType`
</td><td>
_string_
</td><td>
The annotated type of the feature.  Examples include: Gene, Transcript, Exon, Intron and so on
</td></tr>
<tr markdown="block"><td>
`chromosome`
</td><td>
_string_
</td><td>
Reference chromosome of the feature.
</td></tr>
</table>

# The meaning of zero

Microarray and image-based RNA-seq (Seq-FISH etc.) have a dependency on probes which may not have 100% coverage of the annotation reference.  The consequence is that some features which show zero expression may not necessarily have a truly zero expression.  This idea can be extended further in the context of submitted data as well as potentially access restricted data.  The result is that a zero value can indicate one of several states:

1. _Not measured_ – not measured at all and value is not available
2. _Not supplied_ – measured but not provided to the data repository
3. _Restricted access_ – measured but require further authentication to view
4. _Not applicable_ – measurement does not apply to the sample

If practical a data provider should adopt a means to indicate these states rather than use a zero.
