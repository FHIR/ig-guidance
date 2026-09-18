> **Audience.** This page is for template maintainers, the people who own a template's repository. IG
> authors do not translate template text: use a template that supports languages, as described in
> [Setting up the IG](lang-creating-ml-specs.html), and if your language is missing or wrong there, report it
> to the template's maintainers or your HL7 affiliate.

The template adds text of its own around the IG content: the tab names on artifact pages, table headings,
download labels, the artifact index with its group names and descriptions, and notices such as the one shown
when a page has no translation. That text is translated inside the template, in PO files that the publisher
keeps in step with the template's English strings.

Only templates built for languages carry translations. The language-aware base template is
[fhir2.base.template](https://github.com/HL7/ig-template-base2); the original `fhir.base.template` has none.
A template derived from the language-aware base inherits its translations and can add its own strings.

### Maintaining the translations

The files live in the template's `translations` folder: `stringsBase-{lang}.po` for page chrome and
`stringsArtifacts-{lang}.po` for the artifact index, one pair per language.

* To fix or complete a language, edit its two PO files and commit. An empty `msgstr` falls back to English,
  so partial files are fine.
* When you add an English string to a base JSON file, build any IG against the template. The publisher adds
  the new key to every language's PO file, and updates the `msgid` of entries whose English changed. Copy the
  regenerated files back from the IG's `template/translations` folder (see the next section for why they
  land there).
* Translation contributions arrive as pull requests against these PO files; the same regeneration keeps them
  consistent.

### Adding a language to a template

This is the same generate-and-fill cycle as for resources, run on the template instead of the IG.

1. In the template's `translations` folder, create two empty files: `stringsBase-{lang}.po` and
   `stringsArtifacts-{lang}.po`.
2. Build any IG that declares that language with `i18n-lang` and uses your local copy of the template. In that
   IG's `ig.ini`, point `template` at the folder, for example `template = ../ig-template-base2`.
3. The publisher copies the template into the IG's `template` folder and works there, so the regenerated files
   are in `{ig}/template/translations/`, not in your template repository. Each PO file now has every English
   string as a `msgid` with an empty `msgstr`.
4. Copy the two PO files back into the template repository, translate them, and rebuild to check.

Template PO files have one form per string; there are no plurals. An empty `msgstr` means the English text is
used, so a partly translated file is fine.

The runtime `-po` and `-po-dir` flags described in [Adding a new language](lang-new-language.html) do not
apply here. They override the publisher's own Java messages, not the template's strings.

### How this works

The template ships two base files in `translations`, each holding an `en` object that maps a key to the
English text:

* `stringsBase.json`: page chrome, such as tab names, table headings, download labels and notices.
* `stringsArtifacts.json`: the artifact index, one name and one description per artifact group.

Next to them sit `{base}-{lang}.po` files, one per language, with entries of the form:

````po
#: NarrativeContent
msgid "Narrative Content"
msgstr "Inhoud"
````

When the publisher loads the template, it reconciles each base file with its PO files for the IG's default
language and every `i18n-lang`:

* Each language gets an object in the JSON file, filled from its PO file, with the English text wherever a
  translation is empty.
* Each PO file gets an entry for every English key it lacks, and its `msgid` is updated when the English
  changed. The PO file is written back.
* The JSON file is written back, and an XML twin such as `stringsBase.xml` is generated, with one element per
  key carrying the text in every language.

The template's build script then copies the JSON files into Jekyll's `_data` folder, so Liquid includes read
`site.data.stringsBase[lang]['NarrativeContent']`, and its XSLT scripts read the XML twin to build the
artifact index. Includes use the English literal as a last-resort default, so a template string never renders
empty.
