As it builds an IG, the IG publisher renders every resource in many different ways, and
also builds tables and lists that cover the whole IG. Each of these renderings is saved as 
a *fragment* - a piece of XHTML that can be included in a page. The templates build the
resource pages out of these fragments (e.g. the 'Snapshot Table' on a profile page is the 
fragment `StructureDefinition-[id]-snapshot.xhtml`), and the pages you author can include 
exactly the same fragments.

This page describes how to include generated fragments, and how to find out which fragments 
are available. Note that this is different to [instance fragments](fragments.html), which show 
part of the XML or JSON of a resource.

### Including a Fragment

Generated fragments are included using the standard Jekyll include:

```
{% raw %}{% include StructureDefinition-my-profile-snapshot.xhtml %}{% endraw %}
```

There are two kinds of fragment names:

* Fragments about a resource are named `[ResourceType]-[id]-[code].xhtml`, where `[code]`
  says which rendering it is (e.g. `snapshot`, `diff`, `dict`, `html`). 
* Fragments about the IG as a whole have no resource prefix e.g. `dependency-table.xhtml`, 
  `globals-table.xhtml`, `ip-statements.xhtml`, `cross-version-analysis.xhtml`, `list-patients.xhtml` 
  (the [home page](index.html) of this IG includes `dependency-table-short.xhtml` and `ip-statements.xhtml`).

#### Multi-language IGs

In a [multi-language IG](languages.html) (built with a template that uses the multi-language 
format, such as the HL7 templates), each fragment is generated once for each language, with 
the language code appended to the name: e.g. `StructureDefinition-my-profile-snapshot-en.xhtml`,
`StructureDefinition-my-profile-snapshot-fr.xhtml`. A copy is also generated without a language
suffix, for the default language of the IG.

A plain `include` always includes the same language, no matter which language version of 
the page is being built. To include the fragment in the language of the page, use 
`lang-fragment` instead, and name the fragment without any language suffix:

```
{%! lang-fragment StructureDefinition-my-profile-snapshot.xhtml %}
```

When the French version of the page is built, this includes `StructureDefinition-my-profile-snapshot-fr.xhtml`,
and so on for each language. If the IG doesn't use the multi-language format, `lang-fragment` is just the 
same as `include`, so it is always safe to use `lang-fragment` for generated fragments. 

### Finding the Available Fragments

Which fragments are generated depends on the resource type, on the content of the resource, on
the IG parameters, the template, and the version of the IG publisher. So rather than relying on a 
list, the best way to find out what is available is to look at what your own build produces: 

* **`temp/pages/_includes`**: every generated fragment is in this folder, under the exact name you
  include (along with the other content Jekyll uses, such as your own includes and data files). 
  To see what is available for a particular resource, look for the files that start with `[ResourceType]-[id]-`.
* **`temp/qa`**: for each generated fragment, there is a matching `.html` file that wraps the fragment
  as a standalone page, so you can open it in a browser and see what it looks like before you include it. 
  (The folder is set by the `path-qa` IG parameter; the HL7 templates default it to `temp/qa`. These files are
  not produced by the ci-build. For multi-language IGs, the file names have the language code, the same as the
  fragments, e.g. `StructureDefinition-my-profile-snapshot-fr.html`). 
* **The resource pages**: find a generated page that shows what you want, then look at the template layout
  for that page (in the `template/layouts` folder) to see which fragment it includes.

If you run the IG publisher with the `-trackFragments` parameter, the publisher also produces 
`output/fragment-usage-analysis.csv`, which lists each kind of fragment with how many were generated, 
how long they took, how big they are, and whether any page actually used them.

### Common Fragments

These are some of the fragments that are commonly included in authored pages. This is not a complete list - 
see above for how to find them all. 

| Fragment | Content |
| --- | --- |
| `[type]-[id]-html.xhtml` | The narrative of any resource |
| `[type]-[id]-xml-html.xhtml`, `[type]-[id]-json-html.xhtml` | The resource as formatted XML or JSON |
| `StructureDefinition-[id]-snapshot.xhtml` | The snapshot table of a profile, logical model or extension |
| `StructureDefinition-[id]-diff.xhtml` | The differential table |
| `StructureDefinition-[id]-snapshot-by-mustsupport.xhtml` | The 'Key Elements' (must support) view |
| `StructureDefinition-[id]-dict.xhtml` | The detailed definitions of the elements |
| `StructureDefinition-[id]-tx.xhtml` | The terminology bindings |
| `StructureDefinition-[id]-inv.xhtml` | The constraints |
| `StructureDefinition-[id]-uses.xhtml` | Where the profile is used |
| `dependency-table.xhtml` | The packages this IG depends on |
| `globals-table.xhtml` | The global profiles declared by this IG |
| `ip-statements.xhtml` | The intellectual property statements for the IG |
| `list-[type]s.xhtml` | A list of all the resources of a type in the IG (e.g. `list-patients.xhtml`) |

