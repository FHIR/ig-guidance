
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

if the language pack is being maintained by an HL7 affiliate, the correct code for the language pack is ```hl7.fhir.[rX].[lang].xml``` where 
rX is the version being translated e.g. ```r4```, and [lang] is the language and possibly region e.g. ```es``` for Spanish.

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

---

### Working with the Java Language files

**TODO**

### External Terminologies & SNOMED CT Distribution

**TODO**