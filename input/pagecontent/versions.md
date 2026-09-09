
### Implementation Guide Versioning

FHIR Implementation Guides follow a semantic versioning (semver) approach with some standards specific adaptations:

#### Standard Release Versions

Milestone releases correspond to formal publications that the publisher expects implementers to base production
implementations on. Milestone releases use standard semantic versioning with the format `major.minor.patch`:

- **Major version**: Tied to the major document version, for major rewrites e.g. STU2, R4
- **Minor version**: Incremented for new features or minor changes, STU updates within the scope of the published standard  
- **Patch version**: Incremented for bug fixes and minor corrections that are not expected to change the content exchanged by applications

Note that HL7 exercises careful governance over the choice as to whether minor changes cause a new publication or can happen within 
the scope of the standards update process. 

Examples:
- `1.0.0` - First major release
- `1.1.0` - Update to edition 1 with minor new features (and maybe changes)
- `1.1.1` - Technical Correction for version 1.1

#### Draft and Working Versions

For draft, ballot, and working publications, a suffix is appended to the base version using a hyphen:

- `1.0.0-ballot` - Ballot version of 1.0.0
- `2.1.0-draft` - Draft version of 2.1.0  
- `1.5.0-preview` - Preview version of 1.5.0
- `3.0.0-cibuild` - Continuous integration build of 3.0.0

Common suffixes include:
- `-ballot` - For ballot versions
- `-draft` - For draft versions  
- `-preview` - For preview releases
- `-cibuild` - For continuous integration builds

Working releases are generally preview for comment, and generally not appropriate for production implementations, 
though implementers often do anyway. 

### Implementation Guide Dependencies

### Nomenclature 

Agreed terms:
* *Milestone* Publication: A publication of an IG that is intended to be formal version that implementers adopt, and that is supported as a recognized version even after later versions are published. It may be the subject of ongoing technical corrections. Most IGs (not all) have such a publication cycle. Do not have suffixes on the version
* *Working* Release: A draft version that is released for testing/comment/ballot, and will be superceded by later versions. Have suffixes on the version)
* *ci-build* version: A version built from whatever is committed to GitHub, and built by build.fhir.org. Usually 'the ci-build' refers to the version built from the mster/main branch in the GitHub repository.
* *Technical Correction* : a publication that is intended to replace a *Milestone* due to some technical error being found in it. Shares the same major.minor as the publication it corrects, and increments the patch. Technical Corrections are considered Milestones

Confusing terms:
* *current*: current refers to either the last milestone or the ci-build, and so it ambiguous. Unfortunately it is also being used as documented below to refer to the ci-build in version references. It's also used in [package-list.json](https://confluence.hl7.org/spaces/FHIR/pages/66928420/FHIR+IG+PackageList+doco) with a slightly different meaning)
* *latest*: This refers to either the last published milestone or the last published (milestone or working version) 

Todo:

* what are acceptable terms for current and latest?

### Specifying Dependencies

IGs can depend on other IGs and packages using two primary identifiers:

1. **Canonical URL** - The official URL of the IG (e.g., `http://hl7.org/fhir/us/core`)
2. **Package ID** - The NPM-style package identifier (e.g., `hl7.fhir.us.core`)

You can specify either identifier, and the publisher will resolve the missing information:

- If you provide only a canonical URL, tools will lookup the corresponding package ID
- If you provide only a package ID, tools will determine the canonical URL from the package metadata
- You can provide both for explicit control

### Dependency Versions

If an IG want to use content from another IG, then it has to 'depend on it' by 
including it in the package dependencies. Dependencies are always to a combination of package + version, 
and are specified either in the ImplementationGuide resource for the IG, or if the IG is built 
by Sushi, in the sushi-config.yaml. In IGs, dependencies must always have a stated version 
(with one specific exception - see [Related IGs](related-igs.html)).

Possible version values are:

* an explicit version - the exact version of the package [major.minor.patch(-name]. The tools will resolve to the exact version specified
* {major.minor} - if just a major and a minor are specified, the tools will resolve to the latest patch version. This isn't supported everywhere 
* `current` - use the last build of the master/main branch on build.fhir.org (note: we apologise for using this misleading term as described above)
* `dev` -  use the last local build performed on this computer (in any branch), otherwise fall back to #current

it's possible for an IG to depend on multiple different versions of an IG. This can be done explicitly - see below,
ot it can arise through transitive dependencies of packages it depends on. In the latter case, things can be 
quite messy - see [Pinning Canonical References](pinning.html)

### Package Version Syntax

Outside of an IG resource, e.g. in the parameters to the validator, the 
package reference syntax used is similar to NPM: `packageId#version`.
In some contexts, the package reference can have no version. When this
is the case, the tools will pick the most recent publication (milestone,
or otherwise). 

Tools:
* Validator: Unknown
* ?


#### Depending on multiple different versions of the same package 

An IG can depend on multiple versions of an IG at once, e.g:

```json
  "dependsOn" : [{
    "packageId" : "hl7.fhir.us.core",
    "version" : "3.1.1"
  }, {
    "packageId" : "hl7.fhir.us.core",
    "version" : "7.0.0"
  }]
```

The reasons why an IG might want to do this is complicated and it creates many issues, but sometimes there is no choice. 

This isn't directly possible in sushi-config.yaml, or in the package.json format used inside NPM packages, 
so in those cases, a convention from the NPM package ecosystem is adopted:

```json
"dependencies" : {
  "hl7.fhir.us.core" : "3.1.1",
  "uscore@npm:hl7.fhir.us.core" : "7.0.0"
}
```

A similar syntax would apply in sushi-config.yaml, but it is not yet supported by Sushi.

#### Automatic Packages 

The IG Publisher always ensures that 4 packages are loaded: 

* Publication Package: Miscellaneous supporting binaries for rendering (images, tree lines, etc)
* Tooling Extensions: Extensions and other definitions used internally to the tooling
* Extensions Pack : Extensions that are defined for all implementations 
* terminology.hl7.org (THO): The base HL7 terminology that is always in scope 

There is never any reason for editors to pay any attention to the publication package 
(hl7.fhir.pubpack), though since it is first any systemic errors in the package 
infrastructure will show up as errors with the pubpack. Otherwise, it's of no interest
to editors. 

The same is largely true for the tooling extensions - they're internal business to 
the Publication tooling. There are a few cases where editors need to pay attention
to this - consult the FHIR Product Director if you think you need to. 

For the other two packages - Extensions Pack and THO, the IG publisher will inject  
the most recent full release of each of these packages into the IG *if it doesn't 
see them already present*. Editors can choose something other than the most recent 
full release by adding explicit dependencies to these packages.

