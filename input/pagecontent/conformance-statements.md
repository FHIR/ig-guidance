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

* class=`fhir-conformance` - this identifies them as conformance statements subject to the processing described here
* id - the stated id of the conformance statement. This is presented to the user as the formal identity of the conformance point
* summary - how the text is presented in the summary list of conformance statements. This is required for `div` elements. For `span` elements, the summary defaults to the text

### Markdown 

In markdown, `div` and `span` elements are not used directly. Instead, the 
character `§` is used to make conformance statements. E.g. in the middle of 
a paragraph, place that character before and after the sentence. 

The id of the conformance statement is represented as a token after the first 
mark character followed by a colon, e.g. `§id-1.2:`. In this case, `id-1.2` 
is the id of this conformance statement. Tokens can contain any combination of 
ascii characters, digits 0..9, `-`, `.`, and `_`.

To do a multiple paragraph conformance statement, use pairs of the marking 
character in a paragraph of their own, e.g. 

`$$`

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
