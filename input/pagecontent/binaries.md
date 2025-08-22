### Binary Adjunct Files

For several resource types, it can be more convenient to edit base64Binary content directly. The obvious candidate resources are:

* Binary
* Library
* DocumentReference 

But there are many other resources where this might be useful. The technique described here will work for any Resource with Attachments in it.

Here's how to make it work: 

* Create the resource as per normal 
* For the attachment element, leave the data out, and provide only an id and contentType
* the id has the special value "ig-loader-[filename]", where filename is the name of the file to load. e.g. "id" : "ig-loader-MyLibrary.cql"  (case sensitive)
* The IG Publisher will scan all the folders identified by the [path-binary parameter](https://hl7.org/fhir/tools/CodeSystem-ig-parameters.html#ig-parameters-path-binary), and remove the id property, and replace with with the content from the file 
* If a matching file cannot be found, the id will be left in place, and an error will be logged in the qa page

Binary is a special case. For Binary, make the content of the data itself equal to "ig-loader-[filename]"

Note: the following file extensions are supported:

* .txt (text/plain)
* .pdf (application/pdf)
* .jpg, .png, .gif (image/xx)
* .dicom - application/dicom
* .cql - text/cql. 

### CQL Processing

CQL included into a library is subject to additional processing. Additional content elements will be injected for application/elm+xml or application/elm+json, depending on the `format` cql translator option - do not create a stub for this manually.

CQL translator options are provided using a `cql-options.json` file co-located with the CQL source content (as specified in the `path-binary` parameter). Documentation of this file is provided in the [CqlTranslatorOptions](https://github.com/cqframework/clinical_quality_language/blob/master/Src/java/cql-to-elm/OVERVIEW.md#cqltranslatoroptions) topic of the CQL-to-ELM translator overview.

If no CQL options file is present, the [default](https://github.com/cqframework/clinical_quality_language/blob/master/Src/java/cql-to-elm/OVERVIEW.md#cqltranslatoroptions) translator options will be used.

For each CQL source file included in a Library resource, the following steps are performed:

1. The CQL source file is compiled to ELM, returning any information, warning, or error messages as messages to the publisher output.
2. If there are errors, an additional failure message is reported to the publisher output as an error, indicating the CQL file could not be successfully processed.
3. On successful compilation, the ELM output is base64-encoded as an additional content element `application/elm+xml`, `application/elm+json`, or both, depending on the `format` option.
4. Dependencies of the library are reported as `depends-on` relatedArtifact entries in the library as documented in [Related Artifacts](https://hl7.org/fhir/uv/cql/conformance.html#conformance-requirement-4-5). Dependencies include any models, libraries, code systems, or value sets referenced in the CQL.
5. Any input parameters are added as `in` parameters
6. Any expression definitions are added as `out` parameters
7. Any retrieves in the library are added as `dataRequirement` elements
8. The CqlTranslatorOptions used are added using the `cqf-cqlOptions` extension

Parameters and data requirements are reported as documented in [FHIR Type Mapping](https://hl7.org/fhir/uv/cql/conformance.html#conformance-requirement-4-5) and [Parameters and Data Requirements](https://hl7.org/fhir/uv/cql/conformance.html#parameters-and-data-requirements)

The resulting Library is expected to conform to the following profiles:

1. [CQLLibrary](https://hl7.org/fhir/uv/cql/StructureDefinition-cql-library.html)
2. [CQLModule](https://hl7.org/fhir/uv/cql/StructureDefinition-cql-module.html)
3. [ELMXMLLibrary](https://hl7.org/fhir/uv/cql/StructureDefinition-elm-xml-library.html)
4. [ELMJSONLibrary](https://hl7.org/fhir/uv/cql/StructureDefinition-elm-json-library.html), if `JSON` is specified as a format

