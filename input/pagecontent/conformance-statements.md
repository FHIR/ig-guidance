# Managing Conformance Statements

The IG Publisher includes facilities to mark and list conformance statements made in page content.

Conformance Statements are any sentence or paragraph that includes the words SHALL or SHOULD,
and that make testable assertions. 

In order to manage conformance statements, an IG author has to 

1. represent the statements properly 
2. indicate where in the IG the full list of conformance statements should be shown.

IGs are not required to manage conformance statements in this fashion, unless 
they are HL7 IGs. 

## Identifying Conformance statements 

Conformance Statements come in two flavours: a sentence inside a paragraph 
that makes a testable assertion, or in one or more paragraphs and/or lists,
tables, etc. 

Editors should use whichever form best works for their content, but in
general, it works best if the statements are clearly separated from 
the other narrative content, so the (multi-)paragraph form is recommended. 

### XML 

In XML pages, conformance statements are either `div` elements or `span`
elements that contain the conformance statement. 

`div` elements can contain
any html block elements (p, ul, ol, table, etc), but are anticipated to
be concise and short - longer conformance statements should be broken 
up. `span` elements can contain any inline elements (span, b, i, a, etc).

The elements have the following properties: 

<div class="modified-content" markdown="1">
* class=`fhir-conformance` - this identifies them as conformance statements subject to the processing described here
* id - the stated id of the conformance statement. This is presented to the user as the formal identity of the conformance point.  It must be a string that matches the FHIR 'id' data type.  If not specified, a sequential id will be assigned based on the order in which pages and statements are processed.
* summary - how the text is presented in the summary list of conformance statements. This is required for `div` elements. For `span` elements, the summary defaults to the text
* actors - a comma-separated list of actor ids to which the rule applies.  These must be actors defined in the IG or one of its dependencies.  If there are multiple actors with the same id, the one defined in this IG wins.  If there are multiples with the same id and none are defined in this IG, a warning will be sent to the console and the actor will be ignored.
* categories - a comma-separated list of categories relevant to the requirement.  The code must be in the value set pointed to by requirement-category-codes IG parameter.  Codes within the value set must be unique.
</div>

### Markdown 

In markdown, `div` and `span` elements are not used directly. Instead, the 
character `§` is used to make conformance statements. E.g. in the middle of 
a paragraph, place that character before and after the sentence. 

<div class="modified-content" markdown="1">
The metadata of the conformance statement is represented as a token after the first 
mark character followed by a colon, e.g. `§id-1.2^actor1,actor2^ui:`. The metadata consists
of 3 optional fields, separated by '^'.  A separator is only needed if there is content
following it.  The metadata fields are:

* id - the unique identifier for the conformance statement.  In the above example, `id-1.2`.  (See rules for id in the XML section above.)
* actors - a comma-separated list of actor ids to which the rule applies.  (See rules for actors in the XML section above,)
* categories - a comma-separated list of codes for categories that apply to the rule.  (See rules for categories in the XML section above.)
</div>

To do a multiple paragraph conformance statement, use pairs of the marking 
character in a paragraph of their own, e.g. 

`§§`

This paragraph marker goes before and after the other markdown content that 
forms the conformance statement. The first paragraph also has the details, 
which have this format:

`token:summary^title`

where summary is what will be shown in the conformance statement list, and 
title is the first paragraph of the conformance statement block. 

## Conformance Statement List

The summary list of conformance statements must be placed in the IG somewhere.
Where it actually goes is at the discretion of the author. In XML,
this is represented as an empty `UL` tag with `class="fhir-conformance-list"`.

In markdown, this an empty paragraph containing only the `§` character 
three times. 

It's entirely at the discretion of the editor / authors where the conformance
list goes, but it can only go in one place in the IG.

<div class="new-content" markdown="1">
This view will provide a complete list of all conformance statements found in the IG and
will allow filtering them based on actor and/or category.

## Requirements Resource

In principle, this content would ideally be extracted and represented as a Requirements instance, given that that's what the content
represents.  However, at present the extraction process for these rules occurs after the content has been rendered by Jekyll.
It will be difficult to revisit the timing of this processing due to translation and other processes.  However, it is something
that might be achievable at some point.
</div>