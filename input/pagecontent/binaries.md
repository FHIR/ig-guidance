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

CQL included into a library is subject to additional processing. A second content will be injected for application/elm+xml - do not create a stub for this manually)

