<style>
.snippet-tabs { margin: 0.5em 0 1.5em 0; }
.snippet-tabs > input[type="radio"] { display: none; }
.snippet-tabs > label {
  display: inline-block; padding: 4px 14px; margin: 0 2px -1px 0; cursor: pointer;
  border: 1px solid #ddd; border-bottom: none; border-radius: 4px 4px 0 0;
  background: #f5f5f5; color: #555; font-size: 0.9em;
}
.snippet-tabs > .snippet-pane { display: none; border: 1px solid #ddd; padding: 0.5em 1em 0 1em; }
.snippet-tabs > .snippet-pane > pre { margin-top: 0; }
.snippet-tabs > input:nth-of-type(1):checked ~ label:nth-of-type(1),
.snippet-tabs > input:nth-of-type(2):checked ~ label:nth-of-type(2),
.snippet-tabs > input:nth-of-type(3):checked ~ label:nth-of-type(3) {
  background: #fff; color: #000; border-bottom: 1px solid #fff; font-weight: bold;
}
.snippet-tabs > input:nth-of-type(1):checked ~ .snippet-pane:nth-of-type(1),
.snippet-tabs > input:nth-of-type(2):checked ~ .snippet-pane:nth-of-type(2),
.snippet-tabs > input:nth-of-type(3):checked ~ .snippet-pane:nth-of-type(3) { display: block; }
</style>

Before anything else, make sure the IG uses a template that supports languages. The template renders the
language switcher, the translated tab names and table headings, and the notice on pages that have no
translation. On a template without language support, none of that appears, whatever the IG declares. The
language-aware base template is `fhir2.base.template`; the original `fhir.base.template` has no language
support. See [Template text](lang-template.html).

With that in place, three IG parameters turn a single-language IG into a multilingual one. They go in the
`parameter` list of the IG resource. With FSH, put them under `parameters` in `sushi-config.yaml` and SUSHI
writes them into the IG resource for you.

### Declare the default language

This is the language the IG is authored in. The default is `en`.

<div class="snippet-tabs">
<input type="radio" name="deflang" id="deflang-xml" checked="checked"/>
<input type="radio" name="deflang" id="deflang-json"/>
<input type="radio" name="deflang" id="deflang-fsh"/>
<label for="deflang-xml">XML</label>
<label for="deflang-json">JSON</label>
<label for="deflang-fsh">FSH</label>
<div class="snippet-pane" markdown="1">

```xml
<parameter>
  <code value="i18n-default-lang"/>
  <value value="en"/>
</parameter>
```

</div>
<div class="snippet-pane" markdown="1">

```json
{
  "code": "i18n-default-lang",
  "value": "en"
}
```

</div>
<div class="snippet-pane" markdown="1">

```yaml
# sushi-config.yaml
parameters:
  i18n-default-lang: en
```

</div>
</div>

### Declare the additional languages

One `i18n-lang` parameter per language. Use a language code, optionally with a region (for example `pt-BR`).

<div class="snippet-tabs">
<input type="radio" name="langs" id="langs-xml" checked="checked"/>
<input type="radio" name="langs" id="langs-json"/>
<input type="radio" name="langs" id="langs-fsh"/>
<label for="langs-xml">XML</label>
<label for="langs-json">JSON</label>
<label for="langs-fsh">FSH</label>
<div class="snippet-pane" markdown="1">

```xml
<parameter>
  <code value="i18n-lang"/>
  <value value="nl"/>
</parameter>
<parameter>
  <code value="i18n-lang"/>
  <value value="es"/>
</parameter>
```

</div>
<div class="snippet-pane" markdown="1">

```json
{
  "code": "i18n-lang",
  "value": "nl"
},
{
  "code": "i18n-lang",
  "value": "es"
}
```

</div>
<div class="snippet-pane" markdown="1">

```yaml
# sushi-config.yaml
parameters:
  i18n-lang:
    - nl
    - es
```

</div>
</div>

### Say where the translations are

One `translation-sources` parameter per language. The folder must be under `input`, and its last segment
must be exactly the language code. `input/translations/{lang}` is the usual choice.

<div class="snippet-tabs">
<input type="radio" name="sources" id="sources-xml" checked="checked"/>
<input type="radio" name="sources" id="sources-json"/>
<input type="radio" name="sources" id="sources-fsh"/>
<label for="sources-xml">XML</label>
<label for="sources-json">JSON</label>
<label for="sources-fsh">FSH</label>
<div class="snippet-pane" markdown="1">

```xml
<parameter>
  <code value="translation-sources"/>
  <value value="input/translations/nl"/>
</parameter>
<parameter>
  <code value="translation-sources"/>
  <value value="input/translations/es"/>
</parameter>
```

</div>
<div class="snippet-pane" markdown="1">

```json
{
  "code": "translation-sources",
  "value": "input/translations/nl"
},
{
  "code": "translation-sources",
  "value": "input/translations/es"
}
```

</div>
<div class="snippet-pane" markdown="1">

```yaml
# sushi-config.yaml
parameters:
  translation-sources:
    - input/translations/nl
    - input/translations/es
```

</div>
</div>

These folders hold both the resource translations and the translated narrative pages.

### Build

Build the IG as normal. The publisher now generates translation files for your resources under
`translations/{lang}/`. Continue with [Translating resources](lang-ig.html).

### How this works

* `i18n-default-lang` sets the `language` of every generated resource and page that does not say otherwise.
* Each `i18n-lang` adds a language to the set the publisher renders, and to the set it asks the terminology
  server for.
* `translation-sources` folders are scanned on every build. Anything found there is applied on top of the
  source resources and pages before rendering.
* Language packs use `translation-supplements` instead of `translation-sources`. The publisher treats the
  two the same way; the name records that the folder feeds CodeSystem supplements rather than a translated IG.
  See [Language packs](lang-pack.html).
