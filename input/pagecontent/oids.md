FHIR canonical resources (CodeSystem, ValueSet, StructureDefinition, etc.) are identified by their canonical URL. But many
implementation environments - CDA, V2, V3, and a number of national and vendor infrastructures - still identify these
things by OID. To support this, the IG Publisher will automatically assign an OID to every canonical resource in an IG,
and include it as an identifier on the resource:

```json
  "identifier" : [{
    "system" : "urn:ietf:rfc:3986",
    "value" : "urn:oid:2.16.840.1.113883.4.642.40.83.42.1"
  }]
```

To do this, the IG Publisher needs to know the root OID for the IG. Each IG gets its own root OID, which is
recorded in a central registry so that no two IGs use the same root.

### Policy

* **HL7 IGs**: An OID assignment is **required** for all IGs published by HL7 International (packages starting with `hl7.`), 
  including IGs published by HL7 affiliates
* **Other Publishers**: OID assignment is **encouraged** for all other publishers. It costs nothing, and means that the 
  resources in the IG can be used in OID based environments without anyone having to make up OIDs later

### The Registry

The assignments are recorded in 
[oid-assignments.json](https://github.com/FHIR/ig-registry/blob/master/oid-assignments.json) 
in the [IG Registry](https://github.com/FHIR/ig-registry). Each entry maps an OID to the package id of the IG it is assigned to:

```json
    "2.16.840.1.113883.4.642.40.83" : { "id" : "hl7.fhir.uv.howto", "info" : "Grahame Grieve, 1-Aug 2026" },
```

* The key is the root OID assigned to the IG
* `id` is the package id of the IG (from the IG's `packageId`)
* `info` records who made the assignment, and when

HL7 assigns OIDs for this purpose from the root `2.16.840.1.113883.4.642.40` - most IGs simply get the next
number in sequence (e.g. `2.16.840.1.113883.4.642.40.91`). However the OID does not have to come from this root: 
publishers (including HL7 affiliates) that already manage their own OID root can assign an OID from their own tree 
and register it here, and a set of related IGs may be assigned from a common sub-root (e.g. `2.16.840.1.113883.4.642.40.200.x`).

Assignments are permanent. An OID is never reused or reassigned to a different package, even if the IG is withdrawn. 
Assignments that were made in error are retired by prefixing the entry with `!` rather than deleting it.

### Requesting an OID

There are three ways to get an OID assigned for your IG:

1. **Zulip**: Ask on [chat.fhir.org](https://chat.fhir.org/#narrow/stream/179252-IG-creation) in the `#IG creation` stream. 
   Include the package id of the IG
2. **Email**: Send an email to the FHIR Product Director, with the package id of the IG
3. **Pull Request**: Make a pull request against [oid-assignments.json](https://github.com/FHIR/ig-registry/blob/master/oid-assignments.json). 
   PRs are welcome as long as they follow the form of the file:
   * Add a single new entry, using the next unused number in the sequence (or an OID from your own root)
   * Use the actual package id of the IG
   * Fill out `info` with your name and the date
   * Make sure the file is still valid JSON
   * Check that the package id doesn't already have an OID (each package should only have one)

Note that the OID is assigned to the package, not to a particular version of it. Once your IG has an OID, you never need 
to request another one for later versions.

### Using the OID

Once an OID has been assigned, add the `auto-oid-root` parameter to your IG:

```xml
    <parameter>
      <code>
        <system value="http://hl7.org/fhir/tools/CodeSystem/ig-parameters"/>
        <code value="auto-oid-root"/>
      </code>
      <value value="2.16.840.1.113883.4.642.40.83"/>
    </parameter>
```

or, if you are using Sushi, in `sushi-config.yaml`:

```yaml
parameters:
  auto-oid-root: 2.16.840.1.113883.4.642.40.83
```

The IG Publisher will then assign OIDs to the canonical resources in the IG under that root, and record them in 
the file `input/oids.ini`. This file **must** be committed to source control along with the rest of the IG: it is what 
ensures that each resource keeps the same OID from build to build, and from release to release. If the file is lost, 
the OIDs will be re-assigned and may not match the OIDs that were published previously.

You should not generally need to edit `oids.ini`. The two exceptions are:

* If you change the id of a resource, change the id in `oids.ini` too, so that the resource keeps its OID
* If a resource must have a particular OID that was assigned some other way, you can replace the assigned OID 
  (only if you really know what you're doing with OIDs)

### See also

* [How do I get a new OID for a code system?](terminology.html#oids) - for OIDs for external code systems 
* [IG Best Practices](best-practice.html)
