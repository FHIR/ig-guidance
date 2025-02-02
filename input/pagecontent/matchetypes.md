### Introduction 

`Matchetype` is an invented word created by combining `Matching` and `archetype`. A `Matchetype` 
is a resource that specifies what another resource should be, and is typically used during 
some testing process, possibly with a [[[TestScript]]] or [[[TestPlan]]]. This concept is 
sometimes called 'Specification By Example`. 

In principle, a Matchetype is a used to specify the output from an operation or sequences
of operations. Typically, a test case will specify one or more concrete resource instances, 
and a sequence of activities to undertake (e.g. post this CodeSystem and this Valueset to
a server, and then perform and $expand operation, or post these resources to an empty 
server and then perform a search). Given a known set of inputs, the output from the sequence
of the operations has a known expected set of elements. 

Unfortunately, it's common for the expected output to be only partially complete. For instance:

* the output includes timestamps that are different each time 
* the output specifies that the resource ids most be different each time 
* the output has server identities in it that must differ between servers
* there are small but allowed variations between different implementations e.g. error messages are allowed to vary, or some servers echo the ValueSet.compose and some do not 

Matchetypes are intended for use in these kind of contexts: writing test cases that produce 
specified outputs with a little variation, where the test cases are suitable for using some 
kind of diff program (winmerge, Beyond Compare) to view and manage the output expectations. 
For this reason, matchetypes are usually in the same format as the resource they are testing 
against, but in fact tha this is not necessary.

Note that at some points, the allowable differences in output can exceed the differences that 
can be expressed using matchetypes, and they stop being an effective - efficient - way to 
specify test output. At this point, other techniques must be used (typically FHIRPath assertions
and profiles), though they can be combined with matchetypes for maximal efficiency.

### Using Matchetypes 

Matchetypes are specified as the output rules in test cases. There's no inherent support for them 
in the FHIR specifcation, but the java instance validator supports them - you can invoke the java
instance validator with the flag ```-matchetype {filename}``` and in addition to whatever other 
validation would normally occur, the resource will also be checked against the expectations 
expressed in the matchetype. 

In addition, there are two other parameters:

* ```-matchetype-externals {filename}#id``` - specify a set of externals - see below
* ```-matchetype-properties {filename}``` - specify additional properties as inputs to the matchetypes (see below)
* ```-matchetype-sorted {filename}``` - output the sorted version of the actual resource to the specified filename (for comparison purposes)

### Resource Validity

Matchetypes are based on resources, but are usually not fully valid resources at the 
primitive value level. The instance validator knows about matchetypes and can be instructed
to validate them anyway. The usual circumstance where this happens is in an IG, where 
testing collaterol is included in the IG, clearly labelled as Matchetypes, and the validator
checks that the matchetypes are otherwise valid resources. 

### Extensions

There are three extensions used with matchetypes:

* ```http://hl7.org/fhir/tools/StructureDefinition/matchetype```: marks a resource as a Matchetype
* ```http://hl7.org/fhir/tools/StructureDefinition/matchetype-optional```: Indicates which output elements are optional
* ```http://hl7.org/fhir/tools/StructureDefinition/matchetype-count```: Indicates that it is only the count that matters
* ```http://hl7.org/fhir/tools/StructureDefinition/matchetype-sort```: Sort a list prior to comparison

#### Marking a resource as a Matchetype

When a resource is a matchetype, it must be marked as one by the inclusion of the base 
matchetype archetype:

```json5
  "extension" : [{
    "url" : "http://hl7.org/fhir/tools/StructureDefinition/matchetype",
    "valueBoolean" : true
  }]
```

This extension doesn't so anything specific other than ensure that the purpose of the invalid
resource is clear. 

#### Managing Optional Values 

The extension ``````http://hl7.org/fhir/tools/StructureDefinition/matchetype-optional``` is used
to mark optional values. There's two ways to use this resource:

* As a boolean flag to indicate that the element that carries the extension is optional 
* As a string with a comma separated set of element names to indicate that the sub-elements are optional

The second approach is provided to make it easy to indicate that primitive values are optional in json. 

Examples:

```json5
  "compose" : {
    "extension" : [{
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/matchetype-optional",
      "valueBoolean" : true
    }].
    // details
  }
```

The compose is optional. Compose may be used in a list of elements to indicate that one of them is 
optional:

```json5
  "parameter" : [{
     // details
  },{
    "extension" : [{
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/matchetype-optional",
      "valueBoolean" : true
    }].
    // details
  }, {
    // details
  }]
```

Another way to use the optional extension is to indicate that a set of sub-properties are 
optional:


```json5
  "resourceType" : "ValueSet",
  "extension" : [{
    "url" : "http://hl7.org/fhir/tools/StructureDefinition/matchetype-optional",
    "valueString" : "id,title,date"
  }],
  // details...
```

#### Comparison by count

Sometimes, there is no way to require a particular set of information, but it is possible
to say how many entries there can be:

```json5
  "extension" : [{
    "url" : "http://hl7.org/fhir/tools/StructureDefinition/matchetype-count",
    "valueString" : "concept"
  }],
  // details...
```

This means that whatever concept contains, it must contain the same number of entries 
as the matchetype. Note that the use for this is a very narrow corner case, but it has
arisen in real world usage.

#### Sorting resources 

In order to use the matchetype on a list, it's really necessary that the list itself
should be ordered, so that the comparison process produces meaningful results. Sometimes,
the lists are naturally sorted, and the order matters and must be maintained. Other times,
the necessity for order is only required in the matchetype itself. In these cases, the order
of the list can be specified using the ```http://hl7.org/fhir/tools/StructureDefinition/matchetype-sort```
extension. 

```json5
  "extension" : [{
    "url" : "http://hl7.org/fhir/tools/StructureDefinition/matchetype-sort",
    "extension" : [{
      "url" : "element",
      "valueString" : "{name}"
    },{
      "url" : "expression",
      "valueString" : "{fhirpath}"
    }]
  }]
  ```

  The elements with name **{name}** will be sorted according to the value of the expression as iterated on each 
  of the elements. A typical use is to sort the parameters in a value set expansion:

```json5
  "expansion" : {
    "extension" : [{
      "url" : "http://hl7.org/fhir/tools/StructureDefinition/matchetype-sort",
      "extension" : [{
        "url" : "element",
        "valueString" : "parameter"
      },{
        "url" : "expression",
        "valueString" : "name"
      }]
    }]
  }
```

The parameters will be sorted alphbetically by name.

### Primitive Values 

Most of the allowed variation in test results is in the primitive values. 
E.g, there must be an element present, but the value of the element varies. 
In these cases, the value of the primitive type is replaced with a mask that 
specifies the allowable values e.g. `$instant$`.

Here's some typical usage:

```json
  "expansion" : {
    "identifier" : "$uuid$",
    "timestamp" : "$instant$",
    "offset" : 0
  }
```

The identifier must a valid UUID of some sort, and the timestamp must be a a
valid instant, though it can be any instant. 

Note: This approach is taken rather than using an extension on the primitive 
type in order to support bulk comparison and ease of editing. 

The following mask values are known:

* *`$$`* or *`$string$`* : the primitive value can be anything (but not nothing)
* *`$instant$`* : the primitive value can be any valid [[[instant]]]
* *`$date$`* : the primitive value can be any valid [[[date]]]
* *`$uuid$`* : the primitive value can be any valid [[[uuid]]]
* *`$id$`* : the primitive value can be any valid [[[id]]]
* *`$url$`* : the primitive value can be any valid [[[url]]];
* *`$token$`* : the primitive value can be any valid token (a [[[code]]] with no internal spaces)
* *`$version$`* : the primitive value must be a valid version of FHIR, and is fixed to whatever the current version of FHIR is
* *`$semver$`* : the primitive value must be a valid [semver](http://semver.org)
* *`$choice:$`* : the primitive value must be one of a set of choices - split up by `|` e.g. `$choice:male|female$`
* *`$fragments:$`* : the primitive value must contain the text strings - split up by `|` e.g. `$fragments:valueset|version$`. This is typically used for error messages - whatever the error message is, it must contain the words 'valueset' and 'version'
* *`$external:$`* : the primitive value must be from the external strings (see below)

#### External Strings

When invoking the validator, users can pass in an file that contains external strings. These external strings
can then be used to determine the acceptable content for the resource. 

The external strings file is a json object that contains set of named objects, which generally
correspond to test cases. The user passes in both the filename and the name of the test case 
that is being executed. 

Each of the named objects is a json object that contains a series of named properties, where
each of the properties is a string value. The file will look something like this

```json
{
  "test-case-1" : {
    "1" : "some error message",
    "2" : "some other error message"
  },
  "test-case-2" : {
    "1" : "some error message",
    "2" : "some other error message"
  }
}
```

Then the primitive field contains `$external:name$` where the name is the name of the second
level json property in the external strings file. The content of the resource must contain 
the string as found in the external strings file.

In the case that there is no external strings file, or no string found in the external
strings file, the field value can contain a set of choices: `$external:name:{choices}$` which
work exactly like the $choice$ mask as specified above.
