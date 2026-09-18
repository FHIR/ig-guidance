The IG publication tooling supports three formats for providing translations:

* **PO**: [GNU gettext PO files](https://www.gnu.org/software/gettext/manual/html_node/PO-Files.html). File extension `.po`.
* **XLIFF**: [OASIS XLIFF 2.0](http://docs.oasis-open.org/xliff/xliff-core/v2.0/xliff-core-v2.0.html). File extension `.xliff`.
* **JSON**: an internal format functionally equivalent to XLIFF, for users who integrate with some other
  translation tool. File extension `.json`.

### Which to use

* For translating resources in an IG or a language pack, any of the three works. PO is still preferred: it has
  the best tool support, and the best handling of plural forms.
* For the publisher's own Java translations, PO is required, because those are the only translations that use
  plural forms.
* For template translations, PO is required.

Whichever you pick, keep one translation file per resource. The publisher generates all three formats on every
build so you can switch, but only one should be in `input/translations` for a given resource.
