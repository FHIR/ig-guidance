### Rules about Narrative

Each resource might contain a Narrative, which is a pair of attributes: 

* An [XHTML fragment](https://hl7.org/fhir/narrative.html) that contains a human readable represenation of the resource 
* A status code that indicates the relationship between the data and the narrative

Many implementations either leave the narrative out, or ignore it, but particularly in the context of documents,
profiles and implementation guides care about the content of the narrative and want to exert control over it. 

Here are some of the aspects of the narrative that implementation guides might want to control:

* whether multiple languages are present, or not, and if they are present, which languages are present 
* whether the narrative is linked to data elements generally or explicitly
* identify particular data elements and require that they are present in the narrative

These are of interest to specify common user experience requirements, allow for 
safe and consistent presentation and translation of documents, and to enforce 
minimum clinical safety expectations.

### Controlling the presence of Language Sections  

A narrative might be divided into a series of language sections, where the root 
elements of the div are all divs with a language attribute. The extension 
[[[http://hl7.org/fhir/StructureDefinition/narrative-language-control]]] can 
be used to control this. 

The extension may be present one or more times, and can have one of the following 
values:

* `_no` : the xhtml is *not* to contain one or more language sections 
* `_yes`: the xhtml is to contain one or more language sections, but there is no rules about what languages 
* `_resource`: the xhtml is to contain a section with the same language as the resource

Otherwise, the extension can contain a language code, and means that a section with the
the specified language is required. 

Note: either of the the values `_no` and `_yes` only make sense if there is no other value present.


### Specifying Narrative Source 

The source of a narrative element can be indicated using a specific class name associated
with the status codes. Specifically, an XHTML element can have one of the following class
names:

* `boilerplate`: The text in the element is not associated with data in the instance. This is typically used for headings, and introductory text that is always present
* `generated`: The text in the element is associated with a data element in the resource, or a related resource. The content might be copied directly, or transformed somewhat, or could be entirely generated but how it is generated depends on resource content, and it introduces no new concepts
* `extension`: the text in the element is associate with an extension in the resource or a related resource 
* `additional`: the text in the element does not come from any source in the resource, and it is only in the narrative

Notes:

* the definitions do not require that the resource narrative is generated; this is usually the case, and when the resource narrative is hand written, in general the content will have to be labelled as `additional` unless tight control is exerted over the author, or the author is trusted to populate the content correctly (e.g. an IG author)
* due to the way resource narratives are generated, elements labeled as associated with extensions might have contain additional elements indicating that they are generated from data, where the data is inside an extension

The extension [[[http://hl7.org/fhir/StructureDefinition/narrative-source-control]]]
is used to tell validators to check that any text in the narrative has been labelled 
to indicate it's source, and to specify the severity of the message associated with 
the check - hint, warning, or error.

Note that indicating the class of the element does not indicate a where the data can
be found, but can help drive intelligent display of the resource, and selecting areas
of the display to highlight and/or treat differently when translating, depending
on the context of use.

### Linking to data elements

There are two ways to establish links between the narrative parts and the 
associated data. The first is using id alignment, where elements in the data
and the xhtml have linked `id` values that establish the relationship, and
using the extension [[[http://hl7.org/fhir/StructureDefinition/textLink]]]
that explicitly links between elements in the narrative and the data portions
of the resource and it's related resources. 
