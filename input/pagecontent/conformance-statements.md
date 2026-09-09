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
* id - the stated id of the conformance statement. This is presented to the user as the formal identity of the conformance point.  It must be a string that matches the FHIR 'id' data type.  If not specified, a sequential id will be assigned based on the order in which pages and statements are processed.  It may optionally contain additional metadata about the conformance
statement.  See <a href="#metadata">below</a>.
* summary - how the text is presented in the summary list of conformance statements. This is required for `div` elements. For `span` elements, the summary defaults to the text
</div>

### Markdown 

In markdown, `div` and `span` elements are not used directly. Instead, the 
character `§` is used to make conformance statements. E.g. in the middle of 
a paragraph, place that character before and after the sentence. 

To do a multiple paragraph conformance statement, use pairs of the marking 
character in a paragraph of their own, e.g. 

`!§§`

This paragraph marker goes before and after the other markdown content that 
forms the conformance statement. The first paragraph also has the details, 
which have this format:

`id:summary^title`

where summary is what will be shown in the conformance statement list, and 
title is the first paragraph of the conformance statement block. 

<div class="new-content" markdown="1">
<a name="metadata"> </a>
## Additional statement metadata

It is possible to specify additional metadata about a conformance statement rather than just
assigning an identifier:
* A flag for whether the statement is conditional (only applies in certain situations) or not
(the statement always applies)
* An indication of the actor(s) to which the statement applies
* An indication of the category(ies) within which the statement falls

To flag a statement as 'conditional', simply place a '?' at the end of the id in the syntax
noted above.  For example, `conf-3?` would flag the conformance statement `conf-3` as being
'conditional'.

To indicate actors, the relevant ActorDefinitions must be defined in the IG or in one of the
dependency IGs.  After the id (and optional conditional marker), include a '^' symbol and then
include a comma-separated list of the ids of the applicable ActorDefinitions.  Note that if there
is more than one in-scope ActorDefinition with the same id, the one defined in the current IG will
be used.  If the multiple ActorDefinitions are defined in other IGs, it will cause an error.

To indicate categories, the IG must first include the `requirements-category-vs` property in your IG
with a value set that is to be used for category codes.  E.g.

```
parameters:
  path-expansion-params: "../../input/terminology-settings.json"
  requirements-category-vs: "http://hl7.org/fhir/us/davinci-crd/ValueSet/cs-categories"
```
for SUSHI or
```
<parameter>
   <code value="requirements-category-vs"/>
   <value value="http://hl7.org/fhir/us/davinci-crd/ValueSet/cs-categories"/>
</parameter>
```
for XML

Then include a second '^' and follow it by a list of the category codes that apply

A full example might look like this:
<code>§someid?^actor1,actor2^category1,category2</code><code>:Something **SHALL** happen§</code>

The '^' symbol can be omitted if theres nothing following it.  So
<code>§someid?^actor1,actor2</code><code>:...</code> and <code>§someid?</code><code>:...</code> are
legal.  However <code>§someid?^category1,category2</code><code>:...</code> is not ok.  It would need to be
<code>§someid?^^category1,category2</code><code>:...</code>
</div>

<div class="modified-content" markdown="1">
## Conformance Statement Table

The summary list of conformance statements must be placed in the IG somewhere.
Where it actually goes is at the discretion of the author. In XML,
this is represented as an empty `<table/>` tag with `class="fhir-conformance-list"`.

In markdown, this an empty paragraph containing only the `§` character 
three times. 

It is entirely at the discretion of the editor / authors where the conformance
table goes, but it can only go in one place in the IG for a given language.
</div>

<div class="new-content" markdown="1">
The injected table will list all conformance statements with links to where they appear in
the IG text.  It will also allow filtering by the different columns visible.

This view will provide a complete list of all conformance statements found in the IG and
will allow filtering them based on actor and/or category.

### Guidance for interpretting the table
It is quite likely that readers will misinterpret this table without additional guidance.  Implementation guides that display this table should include an introduction that covers most or all of the following content (though feel free to adjust the wording or even submit a PR to improve the suggested wording found here):

<div markdown="1">
This page contains a table listing all the free-text conformance statements found in the IG. This table is provided as a useful summary for implementers for the purpose of evaluating key features and to support testing. However, reading this table alone is insufficient to understand or successfully implement the specification:

1. The table only includes conformance expectations expressed as free text. It does not include the computable expectations represented in capability statements, profiles, value sets, etc.
2. The text text in the table only includes the 'formal' requirement. It does not provide the contextual language around the statement that will be needed for successful explanation. The 'id' of each statement is a hyperlink to the place it appears in the text to assist with gathering the needed context.

A few other notes:

* The ids are generally specific to the pages on which the requirements appear, but not always. If content is moved from one page to another, the id will remain the same.
* While ids start as contiguous, as the specification is updated, it is possible some conformance statements will be removed, which will create a gap in the numbers. This is not an error.
* Ids are not final until published in an official release. After that point, ids will not be changed.
* It is possible for the text of a given rules to change somewhat from one release to another so long as the intention of the rule is the same. If the intent has a significant change, the old rule will be removed and a new one added in its place (with a new id).
* The requirements are expressed against a set of actors that represent 'logical entities' relevant to the IG. However, there may be multiple real-world systems in a given implementation that actually compose those logical entities.  This distribution of functionality between real systems will vary by implementation. It will be up to implementers to determine how the various conformance statements will apply to the actal systems in their architecture.
* The categorizations are general. In practice, all 'exchange', 'ui', and 'storage' requirements are some aspect of 'processing' requirements. The categories will give hints as to the architectural layer a requirement will apply to, but there is nothing definitive implied by the category(ies) listed.
</div>

## Requirements Resource

If conformance statements are marked up using the syntax described in this page, the publisher will also generate a
Requirements instance that contains the full set of requirements so-marked.  This will be placed in the root of the IG.
Authors **MAY** opt to copy this resource into the input folder of their IG to cause a Requirements instance to be published
as part of their IG artifacts and IG package.  It is possible to adjust the title and other metadata of the resource, but the
id and URL must be left unchanged.  If subsequent changes in the text of the IG cause the Requirements resource to be out-of-date,
a warning will appear in the IG QA.

This multi-step process (generate the IG, then copy the Requirements instance to the input and re-generate the IG) is caused by the
fact that requirements extraction happens *after* Jekyll and other IG processing has occurred, meaning that it is too late for the
publisher to inject the resource automatically.
</div>