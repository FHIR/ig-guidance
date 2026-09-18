A language pack is how the text you do not own gets translated: resources from FHIR core, HL7 terminology
(THO), and any other specification that a community wants to translate once and share. A pack is released on
its own schedule, so translations of a specification do not wait for the next release of that specification.

### Using a language pack

Add the pack for your language as a dependency of your IG, like any other package, for example
`hl7.fhir.r4.es` for Spanish on R4. Its translations are then in scope, and the rendered pages in that language
pick up the translated displays and definitions.

### Who creates a language pack?

In general, there should only be one language pack for a region that shares a common language or dialect.
HL7 recommends that users in non-English-speaking countries that share a language with other countries work
through their HL7 affiliate to create a single pack at the appropriate level of commonality. Some languages
are consistent across countries, others vary considerably. If there is no HL7 affiliate, another party such as
a national association or government body might step up to provide the translations.

### Creating a language pack

A language pack is a standard IG whose only authored resource is the IG resource itself. FSH is not needed.

1. **Start from an existing pack.** Clone [hl7.fhir.r4.es](https://github.com/FHIR/hl7.fhir.r4.es), remove
   everything under `input/translations`, rename the IG resource and update its values.
2. **Name it.** If an HL7 affiliate maintains it, use `hl7.fhir.{rX}.{lang}`, where `rX` is the FHIR
   version being translated and `lang` is the language, optionally with region. Otherwise do not start the
   name with `hl7`; the rest is at the discretion of the creating authority.
3. **Set the language** to the language being translated:

   ```xml
       <parameter>
         <code value="i18n-default-lang"/>
         <value value="es"/>
       </parameter>
   ```

4. **Point at the translation folder** with `translation-supplements`, and mark the IG as a pack with
   `lang-pack`, which tags the supplements it publishes as language-pack content:

   ```xml
       <parameter>
         <code value="translation-supplements"/>
         <value value="input/translations/es"/>
       </parameter>
       <parameter>
         <code value="lang-pack"/>
         <value value="true"/>
       </parameter>
   ```

5. **Declare what you translate as dependencies.** A pack for FHIR core needs nothing beyond the core version.
   A pack for another specification, such as IPS, adds that specification as a dependency so that its
   resources are in scope.
6. **Write an index page** that says who provides the pack, its scope, and where to contribute.

### Filling in the translations

This is the same build, translate, copy-back cycle as [Translating resources](lang-ig.html), with one
difference: the pack has no resources of its own, so you tell the publisher which upstream resources to
generate translation files for. For each one, create an empty file
`input/translations/{lang}/{ResourceType}-{id}.{ext}`, where `ResourceType` is CodeSystem, Questionnaire or
StructureDefinition, `id` is the resource's id in the specification being translated, and `ext` is `.po`,
`.xliff` or `.json`. Then build, translate the generated file, save it back over the empty one, and build again.

The generated files include entries for the code system metadata as well as each code's display, designations
and definition. A pack should at least provide alternative displays; the rest is optional.

### Publishing a language pack

This works like any other IG. If you have a publication infrastructure, use it. If not, HL7 can publish the
pack on your behalf; contact [the FHIR director](mailto:fhir-director@hl7.org).

### How this works

The pack's NPM package contains a CodeSystem supplement for each translated resource, carrying the
alternate-language content as designations. For a code system the supplement is direct; for a
StructureDefinition or Questionnaire the publisher derives a code system first, one code per element or item
and one sub-code per translatable property, as described under [Translating resources](lang-ig.html). That
page also lists what is translatable per resource type. Terminology servers can host these supplements, and
software can read them directly. The package also ships the translations as `.po`, `.properties` (Java) and
`.resx` (.NET) files.
