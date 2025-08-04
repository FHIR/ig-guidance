
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

### Specifying Dependencies

IGs can depend on other IGs and packages using two primary identifiers:

1. **Canonical URL** - The official URL of the IG (e.g., `http://hl7.org/fhir/us/core`)
2. **Package ID** - The NPM-style package identifier (e.g., `hl7.fhir.us.core`)

You can specify either identifier, and the publisher will resolve the missing information:

- If you provide only a canonical URL, tools will lookup the corresponding package ID
- If you provide only a package ID, tools will determine the canonical URL from the package metadata
- You can provide both for explicit control

### Dependency Version Syntax

Dependencies use a package reference format similar to NPM: `packageId#version`. In some contexts,
the package reference can have no version. When this is the case, the tools will pick the most 
recent publication (milestone, or otherwise). In IGs, however, dependencies must always have a
stated version (with one specific exception - see [Related IGs](related-igs.html)).

Possible version values are:

* an explicit version - the exact version of the package [major.minor.patch(-name]. The tools will resolve to the exact version specified
* {major.minor} - if just a major and a minor are specified, the tools will resolve to the latest patch version. This isn't supported everywhere 
* `current` - use the last build of the master/main branch on build.fhir.org (note: we apologise for using this misleading term - it doesn't refer to the 'current' milestone, even though this is terminology used elsewhere)
* `dev` -  use the last local build performed on this computer (in any branch), otherwise fall back to #current

it's possible for an IG to depend on multiple different versions of an IG. This can be done explicitly - see below,
ot it can arise through transitive dependencies of packages it depends on. In the latter case, things can be 
quite messy - see [Pinning Canonical References](pinning.html)

#### Depending on multiple different versions of the same package 

todo

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

