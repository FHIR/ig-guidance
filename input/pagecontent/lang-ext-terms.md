Displays for codes from SNOMED CT, LOINC, RxNorm and other external terminologies are not something you
translate in the IG. The terminology server provides them, in the languages it has.

### What to do

1. Declare your languages with `i18n-lang` (see [Setting up the IG](lang-creating-ml-specs.html)). The
   publisher asks the terminology server for displays in each declared language.
2. Check the rendered value sets. Where the server has no display in your language, it falls back to a
   default language, which will usually not be the one you want.
3. If a terminology or the server does not cover your language, contact the terminology authority or the
   service provider. For tx.fhir.org, use the
   [terminology stream on Zulip](https://chat.fhir.org/#narrow/stream/179202-terminology).

The [approved terminology services](https://confluence.hl7.org/display/FHIR/Using+the+FHIR+Validator#UsingtheFHIRValidator-AlternateTerminologyServers)
carry the translations that SNOMED CT, LOINC and others publish.

### Choosing a SNOMED CT distribution

Choosing a SNOMED CT edition is not the same as choosing a language, but the two are connected: a national
edition carries that country's language reference sets. Point the IG parameter `path-expansion-params` at a
Parameters file that sets `system-version`:

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

### How this works

The publisher sends the declared languages to the terminology server with each lookup and expansion. The
server is expected to return a display in the requested language when it has one, and otherwise a display in
its default language. Terminology server authors should consult
[the language documentation for the terminology ecosystem](https://build.fhir.org/ig/HL7/fhir-tx-ecosystem-ig/languages.html)
for what the publisher expects.
