The IG publication tooling enforces lots of validation rules that try to enforce that your implementation guide is 'technically' correct.  However,
it's possible to create implementation guides that are 'technically correct', but are going to be problematic for the target implementer community
or for the implementer community at large.

This page tries to consolidate a number of recommendations/best practices for creating "good" IGs that will be easy to understand by developers,
will be consistent with other IGs and will create specifications that reduce implementation costs for the community as a whole (and as a result,
hopefully result in increased/faster adoption.

The guidance here is not static.  New recommendations will be added and existing recommendations will be reworded, clarified or even removed based on
feedback from the community.  At some point, we may even seek formal review of the content listed here.

### Pages and organization

* Each IG should display non-normative content (background, use-cases, downloads, etc.) separately from normative material (content that sets conformance 
criteria for compliant implementations). 
* In addition to the standard index, toc and artifacts pages, most IGs should have a 'background' page, a 'downloads' page and one or more pages that
define the normative content

### Writing and narrative

* Your best technical person may not be your best technical writer.  Try to have documentation written by people who know how to write and communicate,
rather than presuming that someone who knows how to write super-awesome FHIRPath and can code slice discriminators in their sleep is going to be good at 
writing intuitive, consistent, clear and  concise IG text.
*	Write for your primary audience – generally software developers.  That means:
    * Avoiding medical jargon or any language that wouldn't be familiar to a non-clinical lay-person.
      * If specific medical terms must be used because they're intrinsically tied to the purpose of the implementation guide, then either point to directly 
        include a 'primary' that provides a simple overview of the relevant concepts that would be easily consumable by a non-clinician
      * Use hyperlinks or flyovers for complex terms to provide definitions
* Keep documentation brief and focus on what software developers must know in order to implement.
    * It should be possible for a developer to skim an IG and have a pretty good idea of what's in the IG, how it relates to what they need and how long it'll 
      take to implement in ~30 minutes.  If it takes more than an hour, the IG is probably too complex or doesn't have appropriate overview/explanatory text and 
      diagrams.
* Make your IG navigable.  Use hyperlinks wherever possible – both to content that exists within the implementation guide as well to external sources that 
  provide additional "drill-down" information.  The only time a hyperlink isn't appropriate is when the concept has already been linked to within the same 
  couple of paragraphs of a single section.
    * This includes both page content as well as intro and notes sections and even definitions and usage notes within profiles.
* Design the order of presentation of content in the implementation guide such that reading from start to end presents information in a logical order.  
  However, don't presume that readers will navigate in order.  They may jump directly into the middle of the IG and navigate at random through the content 
  based on their instance.  As such, both backward and forward hyperlinks are appropriate – especially for content in distinct sections.
* Single, large pages are better then numerous short pages
    * Single pages can easily be searched using Ctrl-F and can be scrolled around to see related content.  Multiple small pages make it easy to get lost
      and/or miss content
* Put "good" anchor names on all pages (harder to do this for markdown)
    * You never know when someone might need to link to a particular page in the spec.  While, the publisher will auto-generate link points, these will be 
      version-specific.  The anchor names you define will persist across versions
* Put intros on all artifacts
    * Every artifact should have text that explains what it's for and where it fits in the grand scheme of things (including how it's different from potentially
      related artifacts.
    * If it's a complex artifact, include usage notes too.
* Use aliases to ensure that common domain terms will show up when searching
* If there's controversy about why something is the way it is or it's driven by subtle/non-widely-understood requirements, be sure to capture the reasons 
  for the current design in rationale so that future maintainers can take that information into account when designing
* The index page should always start with a patient-friendly explanation of the purpose of the IG
* Ensure there's a section in the specification that explains (or points to explanations for) key information that needs to be understood prior to reading
  the implementation guide.  That includes both FHIR information (what is a resource, what is an extension, how do the formats work), information about IG
  conventions (e.g. the meaning of SHALL/SHOULD/MAY), as well as information
  about the domain the IG is for.  Always assume that your implementation guide is a reader's first entry point into both HL7 and your domain and give
  pointers to the necessary resources to help them get up-to speed quickly.  This section should in
* The IG must include an explanation of what "mustSupport" means for different types of implementations of the IG.
* Try to keep narrative consistent with the style of other IGs, particularly IGs your IG depends on
* IGs should always indicate how to engage with the community - including for those who might not read the IG until 5+ years after the guide was first
  written.
* Explain the relationship of the IG to any other guides (both formal dependencies and informal relationships).  Also include a reference to the IG registry
  as a location to find more IGs of interest.

#### Styles

There are defined styles for narrative:

* `stu-note`
* `dragon`
* `note-to-balloters`
* `modified-content`
* `new-content`
* `feedback`

<div xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.w3.org/1999/xhtml ../../schema/fhir-xhtml.xsd" xmlns="http://www.w3.org/1999/xhtml">
<blockquote class="stu-note">
	<strong>This note (styled 'stu-note') contains a warning message.</strong>
	This message may be used to draw the readers' attention to some points, e.g. to request feedback, or be aware of any constraints, or disclaimers.
</blockquote>
</div>

<div class="dragon">
This box is styled 'dragon' serves to warn about issues or pitfalls
</div>

<p class="note-to-balloters">This paragraph is styled `note-to-balloters`</p>

<p class="modified-content">This paragraph is styled `modified-content`</p>

<p class="new-content">This paragraph is styled `new-content`</p>

<p class="feedback">This paragraph is styled `feedback`</p>


### Images and Diagrams

* Diagrams can be very helpful, but it takes time to do them well.  Don't leave them until the last minute
* Try to ensure that pictures have a consistent color scheme and visual approach
* Make sure embedded graphics can be distributed under a CC-no-attribution license (or provide attribution if that's required under the open-source license)
* Make sure the source for the graphic is checked in and that the authoring tool is either free or widely used.  Don't use esoteric websites that might not 
  be around in 5-10 years or formats that are unlikely to be convertable.


### Artifacts

* Manage artifact volume
    * Consider "What is computably useful?" - I.e. What do you actually need to validate automatically and what might be better (more clear) as text
      * In some cases, consider producing both a computable and 'human' friendly profile where the former is a constraint on the latter
      * At the same time, do try to be computable most of the time. Human-readable text is frequently ambiguous and very expensive to enforce
    * What is reasonably reviewable/implementable?  Yes, you could write 200 profiles.  However, if balloters can't realistically check all of them and confirm 
      that they're correct and/or implementers aren't going to be able to implement that sort of volume in the next 5 years, you're wasting your time
    * Also consider long-term maintenance.  Every artifact you introduce is going to need to be maintained for 10-20 years, maybe longer.  Make sure there's
      a good reason for the resource to exist
* Use appropriate artifacts.  Implementation Guides can (and should) contain more than just profiles
    * Use capability statements to define what interface capabilities implementers are expected to support (including using extensions to differentiate 
      MAY/SHOULD/SHALL)
  * OperationDefinition, NamingSystem, MessageDefinition, GraphDefinition, Questionnaire, etc. are all available


### Profiles

*	Use mustSupport to identify what must be supported, not cardinality
* Try to allow for existing/legacy data unless you're happy to throw it all away.
    * 0..1, mustSupport allows for missing data while still setting expectations for data sharing
*	Avoid constraining 'max'
    * It's better to slice and set constraints that let you extract the specific repetition(s) you need than to prevent others from sending the data they have
    * If you constrain max, it means you're forcing implementations to create a custom implementation interface that just strips data out that could be
      ignored for free
* Be cautious about constraints enforcing business rules
    * legacy data and/or external data may not comply
    * business rules will often change more frequently than systems do (and aren't constrained by backward-compatibility rules)
    * different systems may have different business rules
    * Instead, only enforce constraints that you're confident will stand the test of time.  Other constraints can be expressed as usage notes to warn 
      implementers about what's 'currently expected' and/or handled as business rules within the system.  (It's totally fine to reject instances that pass 
      profile validation because they fail context-specific business rules.)
* Avoid forcing meta.profile to be present or have certain values.  If an instance meets the rules of a profile, that should be sufficient.  Requiring the
  profile be declared means that the author of an otherwise conformant system must spend money to change and maintain the software forevermore to make that
  declaration.  The declaration of a profile has no semantic meaning - i.e. an instance that's valid against a profile and an instance that's valid against
  the profile and happens to declare the profile shouldn't ever drive differences in behavior.  Even if the profile is declared, systems will still need
  to verify validity.
* Never prevent meta.profile from having additional (unconstrained) values.  It's totally fine for an instance to indicate it complies with rules you don't
  recognize.  Profile declarations never change the interpretation or processing rules for a message.


### Terminology

Terminology is complex enough that it has its own page.  See the [terminology FAQs](terminology.html).


### Security and Privacy Considerations

* Section is focused on speaking to the Security and Privacy experts
  * The purpose of the section is to explain what attacks have been considered and what countermeasures can be applied to defend against them
  * Privacy Principles -- related to a subject of data; transparency, purpose limitation, data minimization, accuracy, storage limitations, and security -- There are regional specializations. 
  * Security Principles -- security is risk management against risks to Confidentiality, Integrity, and Availability
* Keep points succinct to the special considerations of your IG
  * Reference FHIR core security and privacy for background http://build.fhir.org/secpriv-module.html
  * Reference FHIR core security and privacy checklist http://build.fhir.org/security.html
  * Leverage the security and privacy categorization defined in FHIR core where appropriate
  * Leverage the security and privacy implementation guides such as SMART-on-FHIR
* Include specific conformance requirements of your IG that are related to Security or Privacy in this section, and what attacks that requirement is addressing
* Include residual risks that are not addressed as they would need to be addressed in system design, system deployment, or policy


### Examples

* Include examples that showcase all key parts of the IG
* Include comments in your examples (this means authoring should be done in XML)
* At least one example should highlight every must-support element and every extension defined within the IG
* Avoid declaring meta.profile in your examples unless there's an expectation that implementers must populate production instances with a value for meta.profile
  (something to be avoided - see [profiles](#profiles)).  Forcing validation and linkage to the profile in the publisher can always be done by other means, and
  including meta.profile in the example may lead implementers to think they can rely on it - when they can't.


### Extensions

* Before defining a new extension:
    * Consider whether anything in core could be used
    * Look at existing core and IG extensions
    * Consult with the responsible work group and chat.fhir.org
    * Look at http://clinfhir.com/igAnalysis.html to see what extensions are currently in common use on that element
    * If a new extension is needed, consider if it can be made generic enough that it could be used in other spaces and would be appropriate to register as an 
      HL7 'core' extension
* Create extensions nested inside the elements they apply to rather than at the root
* When defining 'coded' extensions, consider whether other users might reasonably want to use different value sets and, if so, define the extension as
  CodeableConcept without a fixed binding and then create a constrained profile on that extension for use in your IG that tightens it to meet your requirements


### General

* Keep in mind that you might well not always be the primary author of the IG, so ensure all relevant source material is under source control and that 
  content is organized and named intuitively.  Artifacts need to be in 'standard' formats.
* Even for closed projects, IGs should be developed in consultation with the open community
    * Ask questions and share what you're up to on chat.fhir.org so you're aware of other work you can leverage/align with and so you can take advantage of the 
      knowledge of the broader community
    * Seek engagement from the relevant work group.  (Remember, they're going to have to endorse your IG's design approach before it can get to higher maturity 
      levels or normative – you don't want to have to make significant design changes late in the process.)
* Copy and paste the text of your IGs into MS Word or an equivalent tool to do full grammar and spell checking on the content

