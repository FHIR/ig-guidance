
### Introduction 

All FHIR IGs are authored in a single primary language that is the master language, and then
additional languages are provided through the use of translation infrastructure.
The primary language does not have to be in english (even though most existing IGs and the core FHIR specifications use english).
Note that the external resources to the IG are also have a single primary language, but may provide translations.  

### Summary 

Text in the final IG comes from 6 different sources:

1. Text in the IG resources 
5. Text from the narrative pages authored as part of the specification
2. Text in the resources from core and other packages the IG depends on
3. Text from the java code that presents the resources 
4. Text from the underlying terminologies (external to FHIR e.g. SCT, LOINC, RxNorm etc)
6. Text from the template that builds all the parts into a coherent specification 



![IG language overview](ig_lang_sources1.png){: style="max-width:100%; height:auto;" }
![IG language overview - resource view](ig_lang_sources2.png){: style="max-width:100%; height:auto;" }
![IG language overview - valueset view](ig_lang_sources3.png){: style="max-width:100%; height:auto;" }


A fully multi-lingual IG must provide translations for all this content. 

This list summarizes the expected source materials for each of these sources. 

#### Text in the IG resources 

Translations are provided as part of the IG using the IG translation mechanism described below.


#### Text from the narrative pages authored as part of the specification 

Each page that is authored - as md or xml - has a matching 
file in the translation source folder (see below) that translates the
page. See Narrative translation


#### Text in the resources from core and other packages the IG depends on

The core specification and the HL7 terminology are developed and delivered in English. 
"Language Packs" are developed by communities of interest that represent regions that 
use particular languages that provide translations of some of the content to other 
langages to support IGs and implementations that depend on the content.

The IG references the language pack(s) of relevance, and the translations they provide
are automatically in scope. 

You need to use an reference language pack, or create and reference your own. 
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

#### Text from the template that builds all the parts into a coherent specification 

Translation of the template text happens in the template - see below.

---

### Translation Formats

The IG publication tooling supports three formats for providing translations:
* PO: https://www.gnu.org/software/gettext/manual/html_node/PO-Files.html (file extension: ```.po```)
* XLIFF: http://docs.oasis-open.org/xliff/xliff-core/v2.0/xliff-core-v2.0.html (file extension: ```.xliff```)
* JSON: An internal format functionally equivalent to XLIFF, provided for users who wish to integrate with some other translation format. (file extension: ```.json```)

In most uses, PO is required, except for translating resources, when any format can be used, but the ```.po``` format 
is still preferred because  - this format has the best support for plural forms, and the overall translation process. 

Note, that only the java translations use the plural forms, and the ```.po``` format is required in that context.
The ```.po``` format is also required in the template translations.

---


## Examples and references: 

* Example Language pack: 
* 




### Translation Workflow For Page Content

```
git show $(git log -n 1 --pretty=format:"%H" -- path/to/translated/file):path/to/source/file
```

This

Gets the commit hash when the translation file was last modified
Uses that hash to show the source file as it existed at that exact commit

If you want to save that version of the source file:
bashgit show $(git log -n 1 --pretty=format:"%H" -- path/to/translated/file):path/to/source/file > source_at_translation_time.txt
For a more interactive approach, you could also:

Find when the translation was done: git log -p -- path/to/translated/file
Note the commit hash
View the source at that point: git show HASH:path/to/source/file
