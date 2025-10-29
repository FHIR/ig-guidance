
A language pack provides translation content for FHIR assets. It is a standard IG with a particular setup in the IG resource that makes it a language pack.  


The following resource types can be translated:

* **CodeSystem**. CodeSystem supplements contain a flat list of codes that have translated content. In addition to the display, the definition, designations and string and markdown extensions may be translated. 
* **Questionnaire**. Each questionnaire item creates a code for the item.id with the display of the item. prefixes, options, and initial values create subcodes (item@(thing)) so that they can be translated (if they are present). 
* **StructureDefinition**. Each element definition in a structure/profile creates a code for the elementDefinition.id with the definition of the item. The properties requirements, comment, meaningWhenMissing, orderMeaning, isModifierMeaning and binding.description create subcodes (item@(thing)) so that they can be translated (if they are present). 


#### Who creates a language pack?

In general, there should only be one language pack for a region that shares a common language/dialect.
HL7 recommends that users in non-english speaking countries that share languages with other countries work through their HL7 affiliate to create a single language pack at the appropriate level of commonality (e.g. some languages are fairly consistent across their multiple countries, while others vary considerably).
If there is no HL7 affiliate, another party - national association or government body - might step up to provide the translations.

#### Setting up the Language Pack

Create a IG from scratch. The easiest way to do this is to clone an [existing Language pack](https://github.com/FHIR/hl7.fhir.r4.es), remove all the content in /input/translations, and rename the ig resource, and update the values in it.  
  Note: Shorthand/FSH is not necessary for language packs - the only resource is the IG resource itself. Once that is written, there's no more resources authored.  

If the language pack is being maintained by an HL7 affiliate, the correct code for the language pack is ```hl7.fhir.[rX].[lang]``` where 
rX is the version being translated e.g. ```r4```, and [lang] is the language and possibly region e.g. ```es``` for Spanish. If the language pack is not maintained by an HL7 affiliate, then the name should not start with ```hl7```; what to use is at the discretion of the creating authority.

Then set up the content (this shows XML, but it can also be in JSON):

````xml
    <page>
      <nameUrl value="index.html"/>
      <title value="Página de inicio"/>
      <generation value="html"/>
    </page>
````

The index page generally identifies who provides the language pack, the scope of its interest, and where to contribute to the work.  

````xml
    <!-- The actual default working language -->
    <parameter>
      <code value="i18n-default-lang"/>
      <value value="es"/>
    </parameter>
````

Set to the language being translated. The language pack is ready to go, and all that remains is to fill out the translations.

#### Providing the translations

1. For each translation language, define an input folder which is subfolder of the {root}/input folder, and which ends with a subfolder that exactly matches the lang. `input/translations/{lang}` is the normal choice.  

2. Create an empty file in the appropriate translation folder which has the name [ResourceType]-[id].[ext] where 
  * ```ResourceType``` is one of CodeSystem, Questionnaire, or StructureDefinition
  * ```id``` is the id assigned to the resource in the core specification or THO 
  * ```ext``` is one of ```.po```, ```.xliff```, or ```.json``` (see [Translation Formats](translation-formats.html))
2. Use the IG publisher to build the Language Pack  

3. Three different files containing the content to translate will be produced in /translations/[lang]/po, /translations/[lang]/json, and /translations/[lang]/xliff
4. Pick the one you want to work with, and edit the content until you're done
5. Save that modified file back into /input/translations. Ensure there's only one translation file for each [ResourceType]-[id]
6. Use the IG publisher to build the Language Pack 

This cycle can be repeated indefinitely as the language pack is developed. Existing translations are preserved in the generated files.

Note that the generated files contain entries for providing translations for the code system metadata, and the code display, designations and definitions. Language packs should at least provide alternative displays, and can provide the others if desired.



#### Publishing Language Packs

This works like other IGs, and if you have an existing IG publication infrastructure, you can (/should) use that. If you don't, HL7 can publish the Language packs on your behalf (contact [the FHIR director](mailto:fhir-director@hl7.org)).

#### Using the Language Pack

The language pack can be read by humans, but also contains an NPM package that is distributed by 
the FHIR NPM system. The NPM package contains a series of CodeSystem supplements that supplement
the explicit or derived code system with a series of concepts that contain the alternate language content.
These supplements can be hosted by a terminology service and made available to software to make use of the translations (or they can read them directly). The NPM also includes the translations in the following formats:
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


---

### External Terminologies & SNOMED CT Distribution

The IG publisher will automatically ask for content in the right language when it 
consults a terminology server. The expectation of the terminology servers is that 
if a display isn't available in the requested language, it'll fall back to the 
default language, and some kind of default language will be used. Note that this
is expected not to be in the desired language. 

Terminology server authors should consult [this language documentation](https://build.fhir.org/ig/HL7/fhir-tx-ecosystem-ig/languages.html) for the expectations of terminology servers in the IG publisher eco-system. 


Choosing which SNOMED CT distribution isn't the same as choosing a language, but it's an interconnected issue. You can specify which SNOMED CT distribution to use by adding an IG parameter `path-expansion-params` that points to a file which includes the parameter `system-version` indicating the version:

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
