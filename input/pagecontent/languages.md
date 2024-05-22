
### Introduction 

All IGs are authored in a single primary language that is the master language, and then
additional languages are provided through the use of translation infrastructure.
The primary language does not have to be in english (even though most existing IGs use english)
Note that the external resources to the IG are also have a single primary 
language, but may provide translations. 

### Summary 

Text in the final IG comes from 6 different sources:

1. Text in the IG resources 
2. Text in the resources from core and other packages the IG depends on
3. Text from the java code that presents the resources 
4. Text from the underlying terminologies (external to FHIR e.g. SCT, LOINC, RxNorm etc)
5. Text from the narrative pages authored as part of the specification 
6. Text from the template that builds all the parts into a coherent specification 

A fully multi-lingual IG must somehow provide translations for all this content. 

This list summarizes the expected source materials for each of these sources.

#### Text in the IG resources 

Translations are provided as part of the IG using the IG translation mechanism described below.

#### Text in the resources from core and other packages the IG depends on

The core specification and the HL7 terminology are developed and delivered in English. 
"Language Packs" are developed by communities of interest that represent regions that 
use particular languages that provide translations of some of the content to other 
langages to support IGs and implementations that depend on the content.

The IG references the language pack(s) of relevance, and the translations they provide
are automatically in scope. 

See below for how to create Language Packs.

#### Text from the java code that presents the resources 

The java code uses standard java internationalization techniques internally, but for 
translator convenience, the master copy of the translations are stored in .po files 
in [GitHub with the FHIR Core code](https://github.com/hapifhir/org.hl7.fhir.core/tree/master/org.hl7.fhir.utilities/src/main/resources/source).
Contributions are welcome, and [this file](https://github.com/hapifhir/org.hl7.fhir.core/blob/master/org.hl7.fhir.utilities/src/main/resources/source/editors.txt)
lists who to contact for existing translations. 

See below for some additional documentation.

#### Text from the underlying terminologies (external to FHIR e.g. SCT, LOINC, RxNorm etc)

External terminologies such as SCT and LOINC have some translations, and these are 
supported by the [approved terminology services](https://confluence.hl7.org/display/FHIR/Using+the+FHIR+Validator#UsingtheFHIRValidator-AlternateTerminologyServers).
If the terminology or one of the servers doesn't support your language for the terminology, contact either 
the terminology authority, or the terminology service provider (e.g. [zulip](https://chat.fhir.org/#narrow/stream/179202-terminology) for tx.fhir.org).

See below for how to specify which SNOMED CT distribution to use.

#### Text from the narrative pages authored as part of the specification 

At present, the plan is that each page that is authored - as md or xml - has a matching 
file [name]-[lang].[ext] in the translation source folder (see below) that translates the
page, but right now nothing will happen with that - depends on the template (next)

#### Text from the template that builds all the parts into a coherent specification 

ToDo - working on the template hasn't yet happened.

---

### Translation Formats

The IG publication tooling supports three formats for providing translations:
* PO: https://www.gnu.org/software/gettext/manual/html_node/PO-Files.html (file extension: ```.po```)
* XLIFF: http://docs.oasis-open.org/xliff/xliff-core/v2.0/xliff-core-v2.0.html (file extension: ```.xliff```)
* JSON: An internal format functionally equivalent to XLIFF, provided for users who wish to integrate with some other translation format. (file extension: ```.json```)

The tools do not have a preference for one format over another; they're all equivalent from a process point of view.
However HL7 recommends that users standardise on using the ```.po``` format - this format has the best support for 
plural forms, and the overall translation process. Note, that only the java translations use the plural forms, and
the ```.po``` format is required in that context.

---


### Setting up the IGs

**TODO**:
* Which languages are in scope 
* Where translations come from 

---

### Providing translations for the resources in an IG
**TODO**

---

### Creating a Language Pack

A language pack is a standard IG with a particular setup in the IG resource that makes 
it a language pack. 

#### Who creates a language pack?

In general, there should only be one language pack for a region that shares a common language/dialect.
HL7 recommends that users in non-english speaking countries that share languages with other countries
work through their HL7 affiliate to create a single language pack at the appropriate level of commonality 
(e.g. some languages are fairly consistent across their multiple countries, while others vary considerably).
If there is no HL7 affiliate, another party - national association or government body - might step up 
to provide the translations.

#### Setting up the Language Pack

Create a non-FSH IG from scratch. Note: Shorthand/FSH is not used for language packs - once the initial IG resource is written, there's no more resources authored.
The easiest way to do this is to clone an [existing Language pack](https://github.com/FHIR/hl7.fhir.r4.es), remove all the content in /input/translations, and 
rename the ig resource, and update the values in it.

if the language pack is being maintained by an HL7 affiliate, the correct code for the language pack is ```hl7.fhir.[rX].[lang]``` where 
rX is the version being translated e.g. ```r4```, and [lang] is the language and possibly region e.g. ```es``` for Spanish. If the language 
pack is not maintained by an HL7 affiliate, then the name should not start with ```hl7```; what to use is at the discretion of the creating 
authority.

Then set up the content (this shows XML, but it can also be in JSON):

````xml
    <page>
      <nameUrl value="index.html"/>
      <title value="Página de inicio"/>
      <generation value="html"/>
    </page>
````

The index page generally identifies who provides the language pack, the scope of it's interest, and 
where to contribute to the work.

````xml
    <!-- The actual default working language -->
    <parameter>
      <code value="i18n-default-lang"/>
      <value value="es"/>
    </parameter>
````

Set to the language being translated. The language pack is ready to go, and all that remains is to 
fill out the translations.

#### Providing the translations

1. Create an empty file in /input/translations which has the name [ResourceType]-[id].[ext] where 
** ```ResourceType``` is one of CodeSystem, Questionnaire, or StructureDefinition
** ```id``` is the id assigned to the resource in the core specification or THO 
** ```ext``` is one of ```.po```, ```.xliff```, or ```.json``` (see Translation Formats above)

2. Use the IG publisher to build the Language Pack 
3. Three different files containing the content to translate will be produced in temp/lang/po, temp/lang/json, and temp/lang/xliff
4. Pick the one you want to work with, and edit the content until you're done
5. Save that modified file back into /input/translations. If you used a different extension, delete the original one
6. Use the IG publisher to build the Language Pack 

This cycle can be repeated indefinitely as the language pack is developed. Existing translations are 
preserved in the generated files.

Note that the generated files contain entries for providing translations for the code system metadata, 
and the code display, designations and definitions. Language packs should at least provide alternative 
displays, and can provide the others if desired.

#### Publishing Language Packs

This works like other IGs, and if you have an existing IG publication infrastructure, you can (/should)
use that. If you don't, HL7 can publish the Language packs on your behalf (contact [the FHIR director](mailto:fhir-director@hl7.org)).

#### Using the Language Pack

The language pack can be read by humans, but also contains an NPM package that is distributed by 
the FHIR NPM system. The NPM package contains a series of CodeSystem supplements that supplement
the explicit or derived code system with a series of concepts that contain the alternate language content.
These supplements can be hosted by a terminology service and made available to software to make use 
of the translations (or they can read them directly). The NPM also includes the translations in the following 
formats:
* .po
* .properties (Java)
* .resx (DotNet)

All translation supplement resources may have translations provided for some metadata on the resource itself:
* Name
* Title
* Purpose
* Description
* Publisher
* Copyright

The following resource types can be translated:

* CodeSystem. CodeSystem supplements contain a flat list of codes that have translated content. In addition to the display, the definition, designations and string and markdown extensions may be translated. 
* Questionnaire. Each questionnaire item creates a code for the item.id with the display of the item. prefixes, options, and initial values create subcodes (item@(thing)) so that they can be translated (if they are present) 
* StructureDefinition. Each element definition in a structure/profile creates a code for the elementDefinition.id with the definition of the item. The properties requirements, comment, meaningWhenMissing, orderMeaning, isModifierMeaning and binding.description create subcodes (item@(thing)) so that they can be translated (if they are present) 

---

### Working with the Java Language files

The java code uses standard java internationalization techniques internally (.properties files), 
but for translator convenience, the master copy of the translations are stored in .po files 
in [GitHub with the FHIR Core code](https://github.com/hapifhir/org.hl7.fhir.core/tree/master/org.hl7.fhir.utilities/src/main/resources/source).
Translation contributions are welcome, and [this file](https://github.com/hapifhir/org.hl7.fhir.core/blob/master/org.hl7.fhir.utilities/src/main/resources/source/editors.txt)
lists who to contact for existing translations. 

Implementers wishing to contribute translations should keep the following in mind:

* There is only one set of translations per language(/region). Contributers will have to collaborate. Disputes will be resolved by the relevant HL7 Affiliate if there is one
* The set of phrases that needs translating covers both text that is 'rendered' into the IGs, and validator error messages 
* The set of phrases that need translating changes constantly as the IG publisher is developed in an ongoing fashion. 
* The % coverage of a translation is published on the github home page: https://github.com/hapifhir/org.hl7.fhir.core?tab=readme-ov-file#internationalization

Implementers provide translations by editing the [.po files](https://github.com/hapifhir/org.hl7.fhir.core/tree/master/org.hl7.fhir.utilities/src/main/resources/source)
and then making them as GitHub pull requests. 

The .po file starts with the following lines:

````po
// en -> de
Plural-Forms: nplurals=2; plural=n != 1;
````

The comment on the first line just confirms that this is the translation from English to German, which is implicit in the file name.
The Plural-Forms line is a standard .po file feature that documents the use of plural forms for the language

Then there are a series of entries:

````po
#: [MSG_ID]
#| [previous]
msgid "[english]]"
msgstr "[translated]"
````

Lines:

* ```MSG_ID``` is a fixed identifer used to identify this phrase in the jav code. It is always present
* ```previous``` is what was translated before, if there is already a translation, but the english phrase being translated has changed. This will be present if the english text changes
* ```english``` is the phrase that needs translating. It is always present
* ```translated``` is the existing translation. if the translation is outdated by a change to the english text, it will be prefixed with "!!". This will be present, but may be blank

For a plural message - that is, a message that has a number of (something) associated with it, 
the entry will look like this:

````po

#: [MSG_ID]
msgid "[english]]"
msgid_plural "[plural form in english]"
msgstr[0] ""
msgstr[1] ""
````

There will be one msgstr[n] line per plural form as defined at the start of the file. 
The ```msgid_plural``` provides the english plural form, to help translators understand which words are associated with the number of items.

### External Terminologies & SNOMED CT Distribution

The IG publisher will automatically ask for content in the right language when it 
consults a terminology server. The expectation of the terminology servers is that 
if a display isn't available in the requested language, it'll fall back to the 
default language, and some kind of default language will be used. Note that this
is expected not to be in the desired language. 

Terminology server authors should consult [this language documentation](https://github.com/FHIR/fhir-test-cases/blob/master/tx/languages.md)
for the expectations of terminology servers in the IG publisher eco-system. 

Choosing which SNOMED CT distribution isn't the same as choosing a language, but it's an interconnected 
issue. You can specify which SNOMED CT distribution to use by

