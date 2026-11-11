### Introduction

A binding on an element says which value set its codes come from, and how strongly
(required, extensible, preferred or example). But a single binding often isn't enough
to say everything a profile author needs to say about the codes in an element.
Common examples:

* A profile wants to allow any code in a broad value set, but also wants to say that
  a narrower value set is the one that systems are expected to use, or that a broader
  one is the absolute limit
* A jurisdiction wants a national code system to be present in an element alongside
  an international code, without replacing the international binding
* The codes that are appropriate depend on the context - for instance, on another value in
  the resource, or on the setting in which the resource is being used
* The binding is expected to change in the future, and implementers need to know what
  value set is coming (a 'candidate' binding)

Additional bindings address these needs. In R5 and later, they are found in
`ElementDefinition.binding.additional`; in R4 and R4B, the same information is
represented using the [additional binding extension](https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-additional-binding.html) (`http://hl7.org/fhir/tools/StructureDefinition/additional-binding`), or the cross-version extension for `ElementDefinition.binding.additional`.
Each additional binding has:

* `purpose` - what the binding means (see below)
* `valueSet` - the value set the binding refers to
* `documentation` / `shortDoco` - an explanation of the binding, which is shown when the binding is rendered
* `usage` - zero or more use contexts that restrict when the binding applies (see [How Usage Works](#usage))
* `any` - for repeating elements, whether the binding applies to all the repeats, or to just one of them

The purpose is what determines how the additional binding is interpreted:

| Purpose | Meaning | Checked by the validator as |
|---------|---------|-----------------------------|
| maximum | The codes must come from this value set (a hard upper limit) | required |
| minimum | Systems must support at least the codes in this value set | not checked |
| required | A code from this value set must be present | required |
| extensible | A code from this value set must be present if a suitable one exists | extensible |
| preferred | A code from this value set is recommended | preferred |
| candidate, current, current-extensible | Bindings that are proposed, or that are in force now (but may change) | not checked |
| best-practice, open | Additional guidance about the codes to use | not checked |
| ui | The value set to present to a user when choosing a code | not checked |
| starter | A starter set of codes; implementers are expected to extend it | not checked |
| component | Only used when the element has multiple components (see the specification) | not checked |
{:.grid}

Only the purposes that can be tested against a single instance are checked; the others are
documentation, and are shown in the rendered binding table, but the validator doesn't do
anything with them. For the purposes that are checked, an additional binding is validated
exactly like the primary binding, with the strength given in the table above, and the
validator's messages say that the problem comes from an additional binding (e.g.
"...specified in an additional binding"). Note that an additional binding never has a
max value set fallback - that only applies to the primary binding.

### Coding vs CodeableConcept

Additional bindings work differently depending on the type of the element they
are on, because the types carry different numbers of codes.

#### Coding, code (and other primitives)

A `Coding` (or a `code`, `string` or `uri`) carries exactly one code. Every binding that
applies to it - the primary binding, and each additional binding that is in scope - is
checked against that one code. In effect, the bindings intersect: if the primary binding
is required to value set A, and there's an additional required binding to value set B,
then the code must be in both A and B.

This makes additional bindings on a `Coding` a way of narrowing the primary binding,
and it's easy to define bindings that no code can satisfy. Care is needed: if the
value sets don't overlap, every instance will fail validation.

For `code` elements, the validator uses the code system implied by the primary binding
when checking the additional bindings, so the code is checked as a code from the
same code system, whether or not it happens to be in the additional value set.

#### CodeableConcept

A `CodeableConcept` can carry multiple codings, which are all meant to represent the
same concept. A binding on a `CodeableConcept` is satisfied when one of the codings
meets the binding - the other codings are allowed to come from anywhere.

That means that each binding - primary and additional - can be satisfied by a
*different* coding. If the primary binding is required to value set A (say, an
international code system) and there's an additional required binding to value set B
(say, a national code system), then the `CodeableConcept` is valid when it has a
coding from A and a coding from B (or a coding that is in both). So on a
`CodeableConcept`, additional bindings are a way of asking for *more codes* -
translations - rather than narrowing the primary binding:

```json
"code" : {
  "coding" : [{
    "system" : "http://snomed.info/sct",
    "code" : "271649006"
  }, {
    "system" : "http://example.org/national-codes",
    "code" : "BP-SYS"
  }]
}
```

This is the usual reason for using additional bindings, and it is why most additional bindings
are found on `CodeableConcept` elements. (The same applies to a `CodeableReference`, through its concept.)

### How Usage Works {#usage}

By default, an additional binding applies everywhere the element is used. When the
additional binding has one or more `usage` elements, it only applies when all of the
use contexts it lists are in force. Each usage is a `UsageContext`, with a `code`
(a Coding identifying what kind of context it is) and a `value` (the value that
context must have).

The difficulty is that the use contexts are generally not something that can be
determined from the resource itself: nothing in an Observation says that it is
being exchanged in a particular jurisdiction, or that it is part of a particular
workflow. So the validator has two ways of deciding that a use context is in force:

1. The use context is declared by whoever is running the validator
2. The use context refers to content in the resource, and the content matches

If either of these applies for every usage on the additional binding, the binding is in scope,
and it is checked. Otherwise, the additional binding is ignored.

#### Declared Use Contexts

The validator doesn't decide which use contexts apply to a validation; the user has to
say. The command line validator has a `-usage` parameter for this, which takes a
`code=value` pair, and can be repeated:

```
-usage http://terminology.hl7.org/CodeSystem/usage-context-type#gender=Coding:http://hl7.org/fhir/administrative-gender#female
```

The code is always `system#code`. The value is prefixed with its type:

* `Coding:system#code` - e.g. `Coding:http://hl7.org/fhir/administrative-gender#female`. Since `UsageContext.value[x]`
  has no Coding choice, this becomes a CodeableConcept with one coding. A value with no type prefix is read as a Coding
* `Quantity:decimal:system#code` - e.g. `Quantity:65:http://unitsofmeasure.org#a`
* `Reference:url` - e.g. `Reference:http://example.org/fhir/Patient/1`

A declared use context matches a usage on an additional binding when:

* the codes match (same system and code), and
* the values are the same type, and
* the values match. At present, only CodeableConcept values are compared: they match when
  any coding in one has the same system and code as any coding in the other (versions are
  ignored). Quantity, Range and Reference values are accepted on the command line, but
  never match anything (yet)

Declared use contexts are only available when running the validator directly; the IG
publisher doesn't have a way to declare them, so when validating IG content, only the
content-based matching described below applies.

#### Use Contexts that Refer to Content

The second way is for the usage to refer to an element in the resource. This is done by
using the canonical URL of the profile as the system of `usage.code`, and the path of an
element in the profile as the code. The value is then compared with the content of that
element in the resource being validated. For example, this additional binding in an
Observation profile only applies when the Observation's category is 'laboratory':

```json
"additional" : [{
  "purpose" : "required",
  "valueSet" : "http://example.org/fhir/ValueSet/lab-codes",
  "usage" : [{
    "code" : {
      "system" : "http://example.org/fhir/StructureDefinition/my-observation",
      "code" : "Observation.category"
    },
    "valueCodeableConcept" : {
      "coding" : [{
        "system" : "http://terminology.hl7.org/CodeSystem/observation-category",
        "code" : "laboratory"
      }]
    }
  }]
}]
```

The rules the validator uses:

* The system must be the profile's URL - either the plain URL, or the versioned URL (`url|version`).
  The profile is the one that contains the binding, which is the profile the element is being validated against
* The code is the path of an element, which is matched against the paths of the elements in the
  resource being validated (the whole resource, not just the element with the binding).
  Paths are compared segment by segment. If a segment in the usage code doesn't
  have an index (`[n]`), then any repeat matches; if it does, only that repeat matches
* The value must be a CodeableConcept (other types never match). The resource content
  must be a Coding or a CodeableConcept:
  * a Coding matches when it has the same system and code as the first coding in the usage value, and,
    if the usage value's coding has a version, the same version
  * a CodeableConcept matches when any of its codings match
* If any of the matching elements in the resource match the value, the usage is in force

Use contexts that refer to content are evaluated against the actual instance, so it is
fine for an additional binding to apply to some instances that conform to a profile and not others.

#### What gets reported

When an additional binding with usage is found to apply, the validator reports an
informational message so that the outcome can be traced:

> The additional binding to [value set] applies to this element, because [code] = [value]

and any errors, warnings or hints that come from checking the binding say why the additional binding
was applied ("...specified in an additional binding which applies because [code] = [value]").
When the binding doesn't apply, nothing is reported - it is just not checked.

Additional bindings with no usage always apply, and don't produce the informational message.

#### Checking the usage definitions in profiles

When validating a profile, the validator also checks the usages on additional bindings
that are represented using the R4/R4B extension:

* If the usage code's system is the profile's URL, the code must be the path of an element in the profile's
  differential or snapshot (error if not)
* ... and the value must be a CodeableConcept (error if not)
* If the usage code's system is anything else, the validator issues a hint that the use context
  isn't recognised, so it can't be validated (it can still be in force when it is declared at validation time)

The same checks are not yet applied to the R5+ `binding.additional.usage` element.
