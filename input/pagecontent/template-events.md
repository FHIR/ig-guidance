
This page describes the events that the IG Publisher raises while it builds an IG, and
how a template can run its own scripts when they happen. It's for template authors: IG
authors using the existing templates don't need to do anything with these events. 

The details on this page are taken from the IG Publisher source (`Template.java`,
`PublisherIGLoader.java` and `PublisherGenerator.java`), and the HL7 base template
(`fhir2.base.template`, `scripts/ant.xml`).

### Overview

A template can nominate an [Apache Ant](https://ant.apache.org/) script, and name an ant
target to run for each of four events:

| Event | When it runs | Gets the IG | Can change the IG | Can add files |
|-------|--------------|-------------|-------------------|---------------|
| `onLoad` | After the IG resource is loaded, before any of its settings are read | Yes | Yes - anything (must return an IG) | No |
| `onGenerate` | After the resources are loaded and validated, before the HTML fragments are generated | Yes | Yes - but not the list of resources | Yes (`onGenerate.files`) |
| `onJekyll` | After the fragments are generated, just before Jekyll runs | No | No | Listed, but ignored |
| `onCheck` | After Jekyll has run | No | No | No |

Every event can report issues back to the publisher, which appear in the QA report (see
[Reporting Issues](#reporting-issues) below).

The order in a build is:

1. Load the template; load the IG resource; process `extraTemplates` and `pre-process`
2. **onLoad**
3. Read the IG parameters and settings, load the dependencies, load and process the resources, validate
4. Generate the summary outputs (e.g. code system and value set lists)
5. Copy the template's `content` folder into the temp folder, then **onGenerate**
6. Generate the HTML fragments for all the resources and pages
7. **onJekyll**
8. Run Jekyll
9. **onCheck**
10. Produce the package, inspect the html, write the QA report, etc.

Notes:

* In `-simplifier` mode, only `onLoad` runs - the publisher doesn't generate anything
* With `-generation-off` (editor process only), `onJekyll` and `onCheck` don't run
* If the publisher fails part way through a build, the later events don't run

### Declaring the Script

The script and the targets are declared in the template's `config.json`:

```json
{
  "script": "scripts/ant.xml",
  "otherScripts": [],
  "targets": {
    "onLoad": "onLoad",
    "onGenerate": "onGenerate",
    "onJekyll": "onJekyll",
    "onCheck": "onCheck"
  }
}
```

* `script` is the path to the ant build file, relative to the template folder
* `targets` is required if there is a `script`. Each property is optional: an event with no target does nothing (other than the `content` copy that comes with `onGenerate`)
* The value of each target property is the name of the ant target to execute. The names don't have to match the event names, though they do in the HL7 templates
* `otherScripts` lists every other ant script that the main script can call. It must be present (even if empty) for the template to be usable on the ci-build: the publisher refuses a template that names a script but doesn't declare `otherScripts` there. Locally, it's a warning

The template's package can extend a base template; when the templates are combined, a
derived template can replace the base template's script or add to it. The HL7 base
template uses ant `extension-point`s (`onLoad.extend`, `onGenerate.extend`,
`onCheck.extend`) so that derived templates can add their own targets with
`extensionOf="onGenerate.extend"`, rather than replacing the whole script.

### Trust

Running an ant script (or a `pre-process` transform) means running code that the template
supplied, so it is only done for trusted templates:

* On the ci-build, only the templates in the publisher's trusted template list may run scripts. A template that isn't trusted can still be used, but only if it has no active content
* Locally, a template that has active content and isn't trusted has to be trusted by the user, either by listing it in `trustedTemplates` in `fhir-settings.json`, or by running with `-trust-template [id]` (or `-trust-template all`)

The ant build file isn't even parsed if the template isn't trusted, since ant executes
any tasks outside a target while parsing. If a template that isn't trusted nominates a
target for an event, the build fails when that event is reached, with the message
"Unable to execute '[target]' in script '[script]' as the template '[id]' is not trusted (reason: ...)".

### The Ant Environment

The ant project's base directory is the IG root folder. These properties are set for
every event:

| Property | Value |
|----------|-------|
| `ig.root` | the IG root folder |
| `ig.template` | the folder the (combined) template is unpacked into (`[ig root]/template`) |
| `ig.scripts` | `[ig.template]/scripts` |
| `ig.networkprohibited` | `true` if the publisher is running with network access prohibited, otherwise `false`. Scripts should not download anything when this is true (the HL7 template skips fetching schemas) |
| `ig.temp` | the publisher's temp folder - the one Jekyll is run on. Set at `onGenerate`, so it's available for `onGenerate`, `onJekyll` and `onCheck`, but not `onLoad` |

For the events that pass the IG (`onLoad` and `onGenerate`), these are also set, where
`[target]` is the name of the ant target:

| Property | Value |
|----------|-------|
| `[target].ig.source` | the path of the IG the publisher wrote for the script, *without* the extension: `[ig.template]/[target]-ig-working.` |
| `[target].ig.dest` | the path where the script writes the changed IG, without the extension: `[ig.template]/[target]-ig-updated.` |

Note that both properties end with a `.`, so the script appends `xml` or `json` to them -
e.g. `${onGenerate.ig.source}xml`. The publisher writes the IG in both formats. The IG is
always written as an **R4** ImplementationGuide, whatever FHIR version the IG itself is
for, and the script must write the updated IG as an R4 ImplementationGuide too. The
publisher reads back `[target]-ig-updated.xml` if it exists, otherwise
`[target]-ig-updated.json`.

Before running a target, the publisher deletes any `[target]-ig-working.*`,
`[target]-ig-updated.*` and `[target]-validation.*` files left over from an earlier run,
so a stale file is never read back as the output of this run.

### The Events

#### onLoad

`onLoad` runs immediately after the IG resource is loaded (and after the template's
`extraTemplates` and `pre-process` are processed), before the publisher reads anything
from it - including the FHIR version, the parameters, and the dependencies.

The script is given the IG, and **must** write an updated IG: if neither
`[target]-ig-updated.xml` nor `.json` exists after the target runs, the build fails
("onLoad script ... failed - no output file produced"). The updated IG replaces the
source IG completely, so the script can change anything: add parameters, add pages,
add resources, etc. If the script doesn't want to change anything, it can just copy the
working file to the destination.

There is no terminology/worker context at this point (none has been loaded yet).

The HL7 base template uses `onLoad` to find the IG's spreadsheets in the IG root and
run `onLoad.xslt` over the IG.

#### onGenerate

Before the `onGenerate` target runs - whether or not there is one, and whether or not
the template is trusted - the publisher copies the contents of the template's `content`
folder into the temp folder (and into each language folder, for multi-language IGs).
This is how a template provides static content such as css, images and scripts.

Then, if there is an `onGenerate` target, it runs. By this point, all the resources have
been loaded and validated, and the summary outputs have been generated, but none of the
HTML fragments for the resources have been generated. `ig.temp` is now set.

The script is given the IG as the publisher has it at this point (the 'published' IG,
with everything the publisher has filled in), and *may* write an updated IG. If it
does, the publisher takes from it:

* the `definition` (groupings, pages, parameters, etc)
* `manifest.page`, `manifest.image` and `manifest.other`

but the script is **not allowed** to change the resources: the updated IG must list
the same number of resources, with the same references, or the build fails ("Templates
are not allowed to modify the resources"). The script can reorder them and change their
details (e.g. their grouping). If the script doesn't write an updated IG, the IG is
unchanged. After this, the publisher reloads its list of pages from the IG.

The script can also tell the publisher about files it made that should be processed as
pages: it sets the ant property `[target].files` to a `;`-separated list of paths
(relative to the IG root). Each file is loaded as if it were in a `pre-process` folder,
with the folder relative to the temp folder as its relative path. Files that the
publisher itself already generated in this run (e.g. svg files that the publisher now
renders from `path-image-source`, which some templates still list) are skipped.

**Note:** the publisher reads `[target].files` after the target runs for `onGenerate`
and `onJekyll`, and expects it to be set - a target should set it to an empty value
if it has no files to report.

The HL7 base template does most of its work here: it works out the FHIR versions,
fetches the schemas, generates `_data/info.json`, `_data/artifacts.json` and the
artifact summary tables, groups and sorts the artifacts in the IG, processes the
include files, checks the menu, and copies its `data` and translation files into
`_data`.

#### onJekyll

`onJekyll` runs after all the HTML fragments have been generated and written to the
temp folder, immediately before Jekyll is run. It's the last chance to change files in
the temp folder before Jekyll processes them.

The script is not given the IG, and can't change it. It can set `[target].files`, but
the list is currently ignored. It doesn't run with `-generation-off`.

The HL7 templates don't use `onJekyll`.

Note: onJekyll is likely to be removed in the future when we stop using Jekyll.

#### onCheck

`onCheck` runs after Jekyll has run, so the script can inspect the generated output
(the `output` folder) and report problems with it. It isn't given the IG, and doesn't
run with `-generation-off`. It's run before the package and the QA report are
finalised, so issues it reports appear in the QA report.

The HL7 base template defines an `onCheck` target, but on its own it only gathers up
the `oncheck-validation*.json` fragments that derived templates' `onCheck.extend`
targets write (see below).

### Reporting Issues

Any event can report issues back to the publisher. The script writes an
OperationOutcome to `[ig.template]/[target]-validation.json` (or, if there's no json file,
`[target]-validation.xml`). The publisher reads it after the target has run, and for
each issue:

* If the issue has the extension `http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-source`, and its value is the path of a file the publisher loaded, the issue is reported against that file. Otherwise it's reported against the IG as a whole
* An issue with severity `fatal` stops the build ("Fatal Error from Template: ...")
* An issue with no severity is ignored
* The issue is converted with the same rules the publisher uses for its own validation messages, and is marked as coming from the template

If the outcomes file can't be read (it's not valid json/xml, or not an OperationOutcome)
the build doesn't fail: the publisher reports an error against the IG saying that
the template didn't produce a readable outcomes file, and the messages it was carrying
are lost.

Since ant can't easily build up a json file, the HL7 base template's approach is for each
target that has something to say to write a fragment file - `ongenerate-validation-[x].json`
or `oncheck-validation-[x].json` in the template folder - containing one or more issues,
each followed by a comma. The final `onGenerate`/`onCheck` target then concatenates the
fragments into `[target]-validation.json`, wrapping them in an OperationOutcome and
removing the trailing comma. Derived templates that use the base template's script can
report issues the same way.

### Files the Script Writes

Scripts run in the template folder, and the publisher keeps track of what they write
there. When a template is used in place (`template = #template`) with the publisher's
watch mode, the template folder is being watched for changes, and changes the script
makes would otherwise trigger another build. The publisher treats these files in the
template folder (and not in sub-folders) as the build's own output:

* `[target]-ig-working.*` and `[target]-ig-updated.*` (including derived names such as `[target]-ig-working.1.xml`)
* `[target]-validation*.json` / `.xml` (including the fragment files such as `ongenerate-validation-igqa.json`)
* `versions.txt`

Template scripts should keep their intermediate files to these names, or write them
somewhere else (e.g. the temp folder).
