# Related IGs

## Declaring Related IGs

Related IGs are registered using the parameter ```related-ig```:

```json
    "parameter": [
      {
        "code": "related-ig",
        "value": "role:code=id"
      }
    ]
```

where:

* ```role``` is a one of the following codes: module, data, test-case or ref-impl
* ```code``` is a simple token by which the IG is known internally
* ```id``` is the NPM package IG of the related package. The id does not have a version

E.g. here's an example:

```json
    "parameter": [
      {
        "code": "related-ig",
        "value": "module:library=hl7.fhir.uv.cds-hooks-library"
      }
    ]
```

Or in `sushi-config.yaml`:

```yaml
parameters:
  related-ig: module:library=hl7.fhir.uv.cds-hooks-library
```

## Referencing Content in Related IGs

You can refer content in a related IG using a jekyll statement like this:

{% raw %}
```
{{ site.data.related.[code].link }}
```
{% endraw %}

where ```code``` is the code defined above. The IG Publisher will replace this link with whatever is the appropriate reference depending on the build circumstances.

For example: 

{% raw %}
```
The related IG [{{ site.data.related.code.title }}]({{ site.data.related.code.link }}/index.html) is related because... 
```
{% endraw %}

Note that `site.data.related.code.` has following properties:

* `id`: the NPM package id of the IG
* `title`: the title of the IG
* `link`: the web reference - depends on the build context
* `canonical`: the canonical of the IG
* `version`: the stated version of the IG

## Presenting a list of Related IGs

There's two fragments:

* `related-igs-list.xhtml`
* `related-igs-table.xhtml`

You can include either or both anywhere that suits in the narrative. Here's examples of what they look like:

<hr/>
<ul>
  <li>
Additional Module: <a href="file:///Users/grahamegrieve/temp/igs/HL7-cds-hooks-library#master/output">hl7.fhir.uv.cds-hooks-library</a> (CDS Hooks Library}
  </li>
</ul>
<hr/>

<table class="grid">
  <tr>
    <th>
      <b>ID</b>
    </th>
    <th>
      <b>Title</b>
    </th>
    <th>
      <b>Role</b>
    </th>
    <th>
      <b>Version</b>
    </th>
  </tr>
  <tr>
    <td>
      <a href="file:///Users/grahamegrieve/temp/igs/HL7-cds-hooks-library#master/output">hl7.fhir.uv.cds-hooks-library</a>
    </td>
    <td>CDS Hooks Library</td>
    <td>module</td>
    <td>dev</td>
  </tr>
</table>