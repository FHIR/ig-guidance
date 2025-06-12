The canonical data type introduces a form for referring to a canonical 
resource by it's url and version:

```json
  "valueSet" : "http://example.org/ValueSet/some-id|version"
```

The version is part is optional. This URL:

```json
  "valueSet" : "http://example.org/ValueSet/some-id"
```

delegates to the implementation to choose the latest correct version from the set of allowed versions in the context of use. 

The first approach, being specific about the version, is called 'pinning' the version: it is pinned down and the 
appropriate choice of version cannot change over time.

### Additional references 

note that there's a few other places where this logic applies:

* ValueSet.compose.include.system + ValueSet.compose.include.version (and exclude)
* ConceptMap.group.system + ConceptMap.group.version (and target)

### Choosing the correct version

Unfortunately, choosing the correct version from the set of allowed versions in the context of use is 
rather more complicated than we would wish, and has proven too difficult for implementers. 

The principle problem is that most implementation guides and/or applicable guidance is published in 
packages, and when the version is not pinned in the context of a package, the correct version to
choose is the most recent version from the set of packages that the package that contains the reference 
depends on.

In principle, this is not a difficult algorithm:

1. Find the package that contains the resource that contains the canonical reference being resolved 
2. make a list of all the packages this depends on, using deep(/transitive) dependencies
3. Find all the versions of the resource for the stated URL in that set of packages 
4. pick the most recent

Unfortunately, this is not as simple as it seems. There are a number of potentially tricky 
problems to solve:

* the determination of most recent from a list of resources with the same URL may be ambiguous (see discussion below about this determination)
* the package resolution documented above is not in the base specification and is not something most implementers know about at all (this will be fixed in R6)
* there may be multiple resources with the same URL and version. If these are not functionally identical, then that's some kind of publishing error, but it still needs to resolved somehow. 
* (most importantly) the package context may not be known - and is explicitly not known on a RESTful API

For this reason, it's a much better approach for authors of implementation guidance, particularly in the form of Implementation Guides, to pin canonical references so that there's no confusion about which version is intended. 

### How to pin canonical references 

Authors can choose to pin the canonical references manually, and to invest in checking every reference on a regular basis (or at least, before any review / publication steps), and make sure that they are correct. 

However this is too laborious for most editors, or simply not a good use of precious time, so the IG publisher can be instructed to pin the canonicals itself. This is done using the [`pin-canonicals`](https://hl7.org/fhir/tools/CodeSystem-ig-parameters.html#ig-parameters-pin-canonicals) parameter, which can have the following values:

* `pin-none`: take no action (which is the default if it's not present)
* `pin-all`:  any unversioned canonical references that can be resolved through the package dependencies will have `|(version)` appended to the canonical
* `pin-multiples`: pinning the canonical reference will only happen if there is multiple versions found in the package dependencies

Note that `pin-multiples` is a bad idea in general - the pinning only occurs when there's multiple matches *inside* the package dependencies. But this doesn't speak to the general problem of multiple matches in an implementer's environment where the implementer is dealing with multiple different IGs with intersecting package dependencies, or collating content from multiple packages on a terminology server. For this reason, `pin-all` is strongly recommended to authors.

### Controlling where pinning happens

By default, the pinning happens in the canonical directly. E.g. any author provided canonical of `http://example.org/ValueSet/some-id` will be changed to `http://example.org/ValueSet/some-id|version` during the publication process. 

It's also possible to provide the parameter `pin-dest` that specifies a Parameters resource that is part of the IG. If you do this, then the pinning is written into this parameters resource as a set of instructions about which version of a resource to use (the parameters `system-version`, `default-valueset-version`, and `default-canonical-version` which are all documented as part of R6, but are applied by the tooling eco-system in the context of earlier versions). 

The advantage of writing the decision to a [manifest](https://build.fhir.org/ig/HL7/crmi-ig/branches/master/StructureDefinition-crmi-manifestlibrary-examples.html) is that implementers can control the scope of the application of pinning precisely at the time of implementation (assembly - see below), and can also easily alter the pinned versions where that's appropriate (and some large eco-systems function in this way).

However the problem with this approach is that
* Implementers need to precisely in control of the scope of application (and this is difficult or even impossible, see above)
* implementers can easily make mistakes pinning the versions and pin to something illegal, or at least incompatible with other trading partners' choices
* implementers need tooling that consistently interprets the manifests correctly (mainly, only approved tx-ecosystem terminology servers do this reliably)

For this reason, authors should only direct the pinning to a manifest when there is a large ecosystem framework using manifests.

### Specifying not to use package dependency based resolution

There are some references where authors do not want the version to be pinned at all, and do not want the package dependencies to be relevant to the choice of version for the canonical references. Instead, implementers should always use the latest version.

This happens for any content that is not found in packages at all. Given the ubiquity of packages, this means that it's mainly the large code systems that don't come from packages - SNOMED CT, Loinc, RxNorm, ICD-11 etc. These references aren't pinned, and the IG publisher won't pin them (it ignores the stub definitions for them in THO).

How can you tell which canonicals? You can't. Yet. (TODO)

For any other content, the content will come from a package, and be subject to the package dependency rules. Implementers can indicate that package versioning doesn't apply by pinning the version to the current mot recent version:

```json
  "valueSet" : "http://example.org/ValueSet/some-id|*"
```

The wildcard version `*` means that the most recent version applies, and this is considered to apply outside the scope of the package dependencies.

Note: this is not supported by the tools at this time.

### What about packages that are already published without pinning?

For the large cohort of packages published prior to mid-2025, where canonicals are not pinned, and package versioning applies, the only safe way to work with the resources if they are used with tools that don't understand the package versioning framework, or if they are working outside the package framework (e.g. RESTful servers), is to pin the canonicals as they extract them out of the package infrastructure. 

There are two tools that can perform this assembly operation for implementers:

* [UploadFIG](https://github.com/brianpos/UploadFIG)
* [the Java Validator](https://confluence.hl7.org/spaces/FHIR/pages/35718580/Using+the+FHIR+Validator#UsingtheFHIRValidator-PackageRegeneration)

Both of these tools can be instructured to pin canonicals as they extract content from packages, and implementers should routinely do this before/as they are uploaded onto FHIR servers etc. (And FHIR Server documentation should link to this page and these tools to help implementers).

### Choosing the most recent version 

Once you have a list of a different versions of the same resource (e.g. the same URL), choosing the most recent isn't always straight forward. 
In principle, systems can do this by:

* comparing the versions 
* comparing the dates 

Comparing the dates isn't as reliable as it first sounds, because sometimes point/patch releases are made on old versions, so they get more recent dates, and sometimes the dates are updated as the resources are copied around. If systems are confident that dates are reliable, they can use the dates. 

Comparing versions is trickier than it sounds, because there are so many versions schemes - semver, dates, others. Though in R5+ resources have a versionAlgorithm to help with this, different versions of the resource may have different schemes (if it's even stated), though is not common. 

In practice, a workable approach is:
* if the version looks like semver, treat it as semver 
* if the version look like a date, treat it as a date
* otherwise, or if the versions don't look consistent, sort them alphabetically 

This advice might get updated from time to time, but this appears to sort almost all resources found in the ecosystem correctly.