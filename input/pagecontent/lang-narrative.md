Each page in the default language, whether markdown or XML, can have a translated copy in the translation folder.

1. **Write the translated page** with the same file name as the source page, at the same path relative to
   `input`, inside the translation folder for that language. A page at `input/pagecontent/overview.md` is
   translated by `input/translations/nl/pagecontent/overview.md`. Markdown and XML pages work the same way.
2. **Rebuild.** The translated page is rendered for that language; pages without a translation fall back
   to the default language.

The language must be declared with `i18n-lang`, and the folder with `translation-sources`. See
[Setting up the IG](lang-creating-ml-specs.html).

Narrative translation is a whole-page copy, not a string-by-string file. That makes it easy to start, but
nothing marks what changed in the source afterwards, so keep the translated pages in step with the source
pages yourself.

### How this works

The publisher renders each page once per language. For the default language it uses the page in
`input/pagecontent`. For each other language it takes the page's path relative to `input`, looks for that
path inside the `translation-sources` folder whose name ends with the language code, and uses the file if it
exists. This is why the folder must end with the language code, and why the `pagecontent` subfolder is
repeated inside it. Template chrome around the page, such as headings and footer text,
comes from the template's own PO files.
