
PlantUML diagrams can be added by:

1. Creating the diagram source file 
2. Including the generated svg in the narrative pages

The following example shows how:
<div>{% include plantuml.svg %}</div>
<br clear="all"/>

### Creating the diagram source
The source diagram is a file in the `input/images-source` folder. The extension must be `.plantuml` e.g. `filename.plantuml`. The IG Publisher will generate a file called `filename.svg` which can be used in the IG pages.


PlantUML has several diagram types and special features. Documentation and examples are abundant out there, so here are a few starting points: 

*  [Several type of PlantUML diagrams](https://plantuml.com/)
*  [Styling](https://plantuml.com/style-evolution) with many [skinparams](https://plantuml.com/skinparam)
*  [Text formatting features](https://plantuml.com/creole)


Simple diagrams are easy to make but more advanced features can be added. Adding these features will normally require some local iterations. The best is to either 
* Install PlantUML jar locally and run it as a command line
* Install a [VSCode extension](https://open-vsx.org/extension/jebbs/plantuml) 
* Try out the main [PlantUML online server](http://www.plantuml.com/plantuml/) or [another online server](https://www.planttext.com/) or [yet another](https://plantuml-editor.kkeisuke.com/).

Here's another perspective on how PlantUML is used:
<figure>
{% include sequence.svg %}
</figure>


<br/>


### Including diagrams in narrative

#### Markdown
To include a diagram in a markdown page, after creating the diagram source, we can use a simple jekyll include tag:
{% raw %}
```
{% include filename.svg %}
```
{% endraw %}
Where filename is the name of the file that contains the diagram source. Given the way markdown is processed, the text may end up wrapped around the diagram. To resolve this, we can add a `<br clear="all"/>` html tag after inserting the diagram.

{% raw %}
```
<div>{% include filename.svg %}</div>
<br clear="all"/>
```
{% endraw %}


#### **XHTML and markdown**
A diagram can be added in an xhtml page by means of a  jekyll include tag, possibly wrapped in a figure and with an opptional figure caption:

{% raw %}
```
<figure>
  {% include filename.svg %}
  <figcaption>Simple diagram</figcaption>
</figure>
```
{% endraw %}

> **At the end, it may be simpler and safer to always include the svg as a html fragment inside the page - whether it's markdown or html.**

{% raw %}
```
<figure>
  {% include filename.svg %}
  <figcaption>Example with styles and other features</figcaption>
</figure>
```
{% endraw %}



### Troubleshooting
The most common issue will be issues with PlantUML syntax. 
* Sometimes the image will not be generated and an error image is going to be put in the place of the image, with some indication on the issue. 
* In some cases the build will stop with an error.

Debugging PlantUML can be done by iterating the diagram, suported by the tools indicated above.


### IG Publisher PlantUML processing
For reference: when building the IG, the Publisher picks the plantuml diagram source, the page(s) that reference that diagram and creates the html pages:
<div>{% include how_plantuml_is_used.svg %}</div>
<br clear="all"/>

