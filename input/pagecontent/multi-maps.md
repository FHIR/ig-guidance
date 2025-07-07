# Creating Mapping Tables across multiple code systems

Maps between different code systems are mostly done with ConceptMaps, which are 
one-way maps from source to target code systems. Some maps are embedded in
CodeSystems using properties, though these mappings don't have the features of 
mappings in ConceptMaps such as relationship type, and comments.

But when presented in the IG publisher, the maps are presented individually. if 
you want a mapping table that scans across multiple code systems, you can do it
with a multi-map. 

## Including a multi-map in the IG

In principle, including a multi-map is easy:

<pre>
{%! multi-map {
  "title" : "Mapping across Address Types",
  "source" : "http://terminology.hl7.org/ValueSet/something",
  "scan" : true
} %}
</pre>

You can include a multi-map in either an xhtml page or a markdown page; the 
syntax is the same. This simple case creates a mapping table where 
the map is anchored by the v3 address type, and the other columns are based on
whatever other mappings the IG publisher can find that map from the v3 address
type to some other code system.

* `title`: A title to put above the map (optional)
* `source`: the URL of a value set or a code system which are the codes in the left hand column 

The source controls the left column, and also the rows in the table. There will be 
an row in the table for each code in the value set or code system. 

## Adding other columns to the table

As shown above, you can simply ask the IG publisher to include whatever it can
find in the table using `'scan' : true`. Alternatively, you can define columns explicitly
Note that you can do both - you can define a set of columns, and scan for any other maps
that exist. Any additional maps will come after the explicitly defined columns. 

<pre>
{
  "columns" : [{
    "type" : "ConceptMap",
    "url" : "{url}"
  },{
    "type" : "CodeSystem",
    "url" : "{url}",
    "property" : "{code}"
  }]
} 
</pre>

Common settings across all columns:

* `title`: Assign the caption for the column (optional)
* `type`: There's two kinds of columns: ConceptMap and CodeSystem - see below.

### ConceptMaps

Adding a ConceptMap is straightforward - type = ConceptMap and use the 
URL to nominate the ConceptMap. The maps will be shown whether they are forward 
or backward. 

### CodeSystem
 
Adding a CodeSystem is a bit more involed - type = CodeSystem and use the 
URL to nominate the CodeSystem. 

In addition, you must nominate a property - this is either a URI or code 
used for a property in the nominated code system. The IG publisher will
expect that the property values are Codings, and look for a match 
using system + code. if it finds one, it will add the matched concept 
to the table 

## Example

{% multi-map {
  "caption" : "Address Type Mappings for FHIR, V3, and v2",
  "title" : "FHIR",
  "source" : "http://hl7.org/fhir/ValueSet/address-use",
  "columns" : [{
    "type" : "ConceptMap",
    "url" : "http://hl7.org/fhir/ConceptMap/101",
    "title" : "V3"
  },{
    "type" : "ConceptMap",
    "url" : "http://hl7.org/fhir/ConceptMap/cm-address-use-v2",
    "title" : "V2"
  }]
} %}
