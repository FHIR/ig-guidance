

### Working with the Java Language files

The java code uses standard java internationalization techniques internally (.properties files), 
but for translator convenience, the master copy of the translations are stored in .po files 
in [GitHub with the FHIR Core code](https://github.com/hapifhir/org.hl7.fhir.core/tree/master/org.hl7.fhir.utilities/src/main/resources/source).
Translation contributions are welcome, and [this file](https://github.com/hapifhir/org.hl7.fhir.core/blob/master/org.hl7.fhir.utilities/src/main/resources/source/editors.txt)
lists who to contact for existing translations. 

Implementers wishing to contribute translations should keep the following in mind:

* There is only one set of translations per language(/region). Contributers will have to collaborate. Disputes will be resolved by the relevant HL7 Affiliate if there is one
* The set of phrases that needs translating covers both text that is 'rendered' into the IGs, and validator error messages 
* The set of phrases that need translating grows constantly as the IG publisher is developed in an ongoing fashion, and existing messages change 
* The % coverage of a translation is published on the github home page: https://github.com/hapifhir/org.hl7.fhir.core?tab=readme-ov-file#internationalization

Implementers provide translations by editing the [.po files](https://github.com/hapifhir/org.hl7.fhir.core/tree/master/org.hl7.fhir.utilities/src/main/resources/source)
(by hand, software or AI with review) and then making them as GitHub pull requests. 

The .po file should start with the following lines:

````po
# en -> de
Plural-Forms: nplurals=2; plural=n != 1;
````

The comment on the first line just confirms that this is the translation from English to German, which is implicit in the file location.
The Plural-Forms line is a standard .po file feature that documents the use of plural forms for the language

Then there are a series of entries:

````po
#: [MSG_ID]
#| [previous]
msgid "[english]"
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
msgid "[english]"
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

Terminology server authors should consult [this language documentation](https://build.fhir.org/ig/HL7/fhir-tx-ecosystem-ig/languages.html)
for the expectations of terminology servers in the IG publisher eco-system. 


Choosing which SNOMED CT distribution isn't the same as choosing a language, but it's an interconnected 
issue. You can specify which SNOMED CT distribution to use by adding an IG parameter `path-expansion-params` that points to a file which includes the parameter `system-version` indicating the version:

```json
{
    "resourceType" : "Parameters",
    "id" : "terminology-expansion",
    "parameter" : [{
      "name" : "includeDesignations",
      "valueBoolean" : true
    },{
      "name" : "system-version",
      "valueUri" : "http://snomed.info/sct|http://snomed.info/sct/11000172109/version/20231115"
    }]
  }
  ```
