> **Audience.** This page is for the people who maintain a language in the FHIR tooling, typically an HL7
> affiliate or whoever is listed for that language in the editors file. IG authors do not need it: if your
> language is already supported, translate your IG as described on the other pages, and if it is missing,
> contact your affiliate rather than opening the language yourself.

The publisher's own text, the table headings, labels and validator messages described in
[Publisher-generated text](lang-java-pack.html), is translated in the FHIR core Java library. If a language
is not in the list yet, someone has to open it up: register the language, generate the empty translation
files, and submit them so the language ships with the next release. This page walks through that.

All paths below are inside the [org.hl7.fhir.core](https://github.com/hapifhir/org.hl7.fhir.core) repository,
under `org.hl7.fhir.utilities/src/main/resources/` unless stated otherwise.

### What you need

* A Java JDK and Maven, and a git clone of `org.hl7.fhir.core` that you can build.
* Clones of the two repositories the generator scans for message usage:
  [fhir-ig-publisher](https://github.com/HL7/fhir-ig-publisher) and
  [fhirsmith](https://github.com/HealthIntersections/fhirsmith). They are only read, not built.
* The language code you are adding, and the number of plural forms it has. Use a two-letter code such as
  `sv`; add a region with an underscore if the region matters, as in `pt_BR`.

### Register the language

Add a line to `translations-control.ini` under `[languages]`. The value is the number of plural forms in the
language, which decides how many `msgstr[n]` slots each plural message gets in the PO file.

```ini
[languages]
de=2
es=3
ja=1
...
sv=2
```

For reference, the languages already registered use 1 (ja, zh, ko), 2 (de, fr, nl, pt, uz, sv), 3 (es, ru, lt)
and 6 (ar). The [CLDR plural rules](https://www.unicode.org/cldr/charts/latest/supplemental/language_plural_rules.html)
list the categories for every language.

### Add the language name table

`languages.csv` gives the name of every supported language in every supported language. The publisher uses
it to label the language switcher in a multilingual IG. Add a column for the new language, with the name of
each existing language in the new language, and add a row for the new language, with its name in each
existing language.

```csv
language,en,de,...,sv
en,English,Englisch,...,Engelska
...
sv,Swedish,Schwedisch,...,Svenska
```

If a cell is left empty the publisher falls back to the display from the FHIR languages value set, so this
step is not blocking, but the switcher looks better with it.

### Create the two properties files

The generator writes translations into Java properties files, but it reads the first line of each file to
learn the plural keywords for the language. So the files must exist before the first run, holding only that
header:

`Messages_sv.properties`
```
# InstanceValidator = one,other
```

`rendering-phrases_sv.properties`
```
# Rendering = one,other
```

The keywords after `=` are the plural categories for the language, in order. Their number must match the
count in `translations-control.ini`, and their order defines which `msgstr[n]` in the PO file maps to which
category. Look at the header of an existing language with the same plural structure and copy it.

### Add yourself to the editors list

Add a line to `source/editors.txt` with the language code, your name and GitHub handle. This is who gets
contacted about that language.

### Build and run the generator

Build the validator CLI once:

```
mvn package -DskipTests --projects org.hl7.fhir.validation.cli --also-make
```

Then run the language regeneration command, giving it the three repository paths:

```
java -jar org.hl7.fhir.validation.cli/target/org.hl7.fhir.validation.cli-<version>-SNAPSHOT.jar lang-regen ^
  <path to org.hl7.fhir.core> ^
  <path to fhir-ig-publisher> ^
  <path to fhirsmith>
```

The repository root has a `regenerate-po.bat` that wraps this; edit its three paths to match your machine.

The command first checks that every message constant in the Java code has an English string and vice versa,
scanning all three repositories. If that check fails it prints the errors and stops without generating
anything. That means the code is out of sync, not that your language is wrong; ask on the
[FHIR Zulip](https://chat.fhir.org/) if it happens on a clean checkout.

When the check passes, it regenerates every language, including yours. You should now have two new files:

* `source/rendering-phrases-sv.po`
* `source/validator-messages-sv.po`

with every English phrase as a `msgid` and an empty `msgstr`. The properties files stay header-only until
there are translations to put in them.

### Submit

Commit and open a pull request against `org.hl7.fhir.core` with:

* `translations-control.ini`
* `languages.csv`
* `Messages_sv.properties` and `rendering-phrases_sv.properties`
* `source/rendering-phrases-sv.po` and `source/validator-messages-sv.po`
* `source/editors.txt`

The PO files can be empty or partly translated at this point. Once merged, the language exists in the next
release and translation can proceed as described in [Publisher-generated text](lang-java-pack.html). The
project's Crowdin configuration is driven by the file names, so a new language's PO files are picked up
there automatically.

### Translate and iterate

Translate the PO files, then run `lang-regen` again. It merges your translations into the properties files
and preserves them on later runs, marking entries whose English changed as described under
[Publisher-generated text](lang-java-pack.html).

You do not need a release to try your translations. Both the validator and the IG publisher accept the PO
files at runtime:

```
java -jar validator_cli.jar ... -po-dir path/to/source
java -jar publisher.jar -ig . -po-dir path/to/source
```

`-po <file>` loads a single file. File names must follow the convention, `validator-messages-sv.po` or
`rendering-phrases-sv.po`, because the loader infers the bundle and locale from the name. Add
`-po-stale-handling exclude` to see English instead of outdated translations.

### How this works

The Java code refers to messages by constant, for example `ABSTRACT_CODE_NOT_ALLOWED`, defined in
`I18nConstants` for validator messages and `RenderingI18nContext` for rendering phrases. At runtime it looks
the constant up in a Java `ResourceBundle`: `Messages.properties` or `rendering-phrases.properties` for
English, and `Messages_<locale>.properties` or `rendering-phrases_<locale>.properties` for other languages.
If no bundle exists for the locale, the library logs that the locale is not supported and falls back to English.

The PO files under `source/` are the master copy for translators. The generator reconciles each language's PO
file against the English properties file: it adds entries for new phrases, removes entries for phrases that no
longer exist, marks translations whose English changed as outdated, sorts by id, and gives duplicated English
strings a `msgctxt` so translation tools keep them apart. It then flattens the PO into the language's
properties file.

Plural messages are stored in the English properties file as two keys, `<id>_one` and `<id>_other`, and in
the PO file as one entry with a `msgstr[n]` per plural form. When writing the properties file back, `msgstr[n]`
becomes `<id>_<keyword>`, taking the keyword from position `n` of the header line. At runtime the library uses
ICU plural rules for the locale to pick the keyword for a given number, so the header keywords must be the CLDR
category names for that language.

The runtime override flags use the same reconciliation code, so a PO file from a newer or older checkout still
lines up with the installed jar.
