## UML Class Diagrams

This page describes how to use the IG publisher to create UML Class Diagrams for 
StructureDefinitions and Profiles. For other kinds of UML diagrams, see 
[PlantUml Diagrams](diagrams-plantuml.html).

The diagrams produced are pure graphical images (SVG). In theory it's possible
to generate some logical kind of UML class diagram (e.g. MOF) but these UML
representations are not very interoperable, and also are so poor in information 
about the elemetns in comparison to the other definition forms that no benefit 
has emerged over the years that FHIR has been in development. 

### Introduction 

The IG publisher can create Class Diagrams for any StructureDefinition. 

If the StructureDefinition has derivation = `specialization` then the 
output will be a classical UML class diagram. With regard to the generating
class diagrams for profiles (derivation = `constraint`), note:

* Profiles are not actually definitions of class (they are 'set of rules' on a class definition)
* the diagram has many custom variations from a true class diagram, but is visually similar
* whether these diagrams are useful or not depends on whether the profile has enough information to make the diagram useful without having too much

The diagrams are produced on the fly by SVG generation code. The generation process 
is careful to produce accurate classes and constraints (e.g. slices) but makes no 
effort to produce a nicely laid out diagram; for that, editors must attend to the layout
manually (as explained below).

### Configuring the class Diagrams

Because the UML diagrams require editor management, they are not generated automatically. 
The following IG parameter controls the appearance of the UML diagrams:

```yaml
  generate-uml: source
```

The `generate-uml` parameter appears only once, and can have one of the following values:

* `none`: Do not generate any UML (default)
* `source`: generate when a source diagram is found in /input/diagrams
* `all`: Generate a UML diagram always

If the setting is not `none` then a UML diagram for each StructureDefinition will be 
produced in `/temp/diagrams` in two different formats: An `.svg` format, and an `.html`
format. The HTML output has the same style as it would in the page, and shows what the
diagram will look like in the output, and also loads the SVG from the svg file, so you 
can see what the Inkscape changes look like. The .svg is missing the style information, but can 
be edited directly by Inkscape (see below).

Because of this, whenever an editor sets generate-uml to `source` or `all` the editor 
should make sure that `temp/diagrams` or `temp` is listed in the `.gitignore` file ('temp'
should be listed always anyway). In addition, so that the diagram html pages render correctly,
the editor should unzip the file [diagram-assets](http://fhir.org/diagram-assets.zip) into
`/temp/diagrams/assets`.

### Using Inkscape Diagram design 

Preparation:

* Install [Inkscape](https://inkscape.org) (use the current stable version)
* Other SVG editors are not supported - you can try using them, but if they don't work (and there's lots of reasons why they might not), then you'll have to use Inkscape
* You can ask an AI to lay the SVG out for you - at present (mid-2025) the AI has some interesting ideas, but execution is a bit sloppy. If you do, ask it to preserve the ids on the elements, and it *might* work (the AI might introduce complex transforms that are ignored by the IG publisher, for instance). It's generally better to get the AI to generate a suggestive layout and then adapt that in Inkscape

Edit Cycle:

* open the .svg file in `temp/diagrams`
* You'll note that Inkscape can't read the attributes, and the layout of the text is wrong. That is expected, and doesn't matter other than making editors life a little harder
* You can move the classes around (the only thing you can change is top,left - anything else will be ignored)
* You can ignore the lines, and they'll just follow the classes around when the diagram is regenerated
* if you want to move the lines, add another point to the line (double click on it in Inkscape), which will move the connector (line, title, and cardinality) to manually managed. 
* to stop managing a line, just delete it - it will be recreated
* when you're happy with their location, save the file with the same name to `/input/diagrams`
* Run the generation again, and check the output again

Repeat this cycle until you're happy with the appearance of the diagram. Note that changes
to the content will change the diagram, so a typical workflow is to edit the diagram once 
early in the process, and then revisit the diagrams towards the end of preparing for a 
publication release.

### Other UML Class Diagrams

A page can add a Class Diagram that covers multiple different classes (e.g. StructureDefinitions with 
derivation = `specialization`). To do this, add a 'uml' instruction into the page:

```
{%! uml {json} %}
```

where the JSON is a valid JSON Object with the following properties:

* `id` - the id of the diagram. Must be unique across all the IG, and must not be the same as the id or name of an existing StructureDefinition
* `attributes` - boolean for whether to show attributes in the class (e.g. may not want to show class contents if the focus of the diagram is about the class heirarchy)
* `no-inner-classes` - boolean for whether to suppress inner classes in the class (e.g. may not want to show class contents if the focus of the diagram is about the class heirarchy)
* `classes` - an array of String, where the entries in the array are the name (StructureDefinition.name) of classes to show in the diagram
* `prefix` - optional - add if you want the diagram in the page twice (or more) in different tabs etc. This is a prefix that goes on all the ids in the generated SVG so that they remain unique. At least one of the instances of the diagram should not have a prefix (that's the Inkscape one)

Use Inkscape to layout the diagram just like any other diagram


