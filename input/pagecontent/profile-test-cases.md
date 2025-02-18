## Profile Test Cases

Implementation Guides can contain examples for profiles, and most do. But there are various technical and procedural
mechanisms in place to enforce that the examples for the profiles are valid resources, both in regard to the 
FHIR specification, and any applicable profiles. For this reason, profile examples in the IG are not an appropriate 
to 'test out' the profiles to ensure that they correctly rule out valid resources. 

Instead of defining IG examples for this purpose, the IG publisher supports 'profile test cases' for this purpose. 
Each set of profile test cases is defined by a json file, customarily found in tests/profiles.

### Profile Test Cases Control File

The file that controls the test cases is a json file that contains a JSON Object with a single property
"profiles" that contains an array of objects where each object has a url property, and a set of tests:

```json5
{
  "profiles" : [
    {
      "url" : "{url}",
      "tests": [
        {
          "source" : "{source-file}",
          "description" : "{discussion}",
          "valid" : true|false,
          "outcome" : {
            "resourceType" : "OperationOutcome",
            "issue" : [
              {
              // issues
              }
            ]
          }
        }
      ]
    }
  ]
}
```

where:
* ```url```: identifies the profile being tested
* ```source-file```: contains the resource being tested against the profile - a relative path means relative to the test file, a path starting with `/` means relative to the repository. Customarily, failing resources are stored in the /tests folder, 
* ```discussion```: optional notes for human authors about how what feature of the profile is being tested
* **valid**: true or false .must be present. If false, at least one of the issues from validating the resource against the profile most be in error (not just hints and warnings)
* **outcome**: if present, a [matchetype](matchetypes.html) in pattern mode that makes rules about the issues produced by validating the resource against the profile (though no matchetype extension since OperationOutcome doesn't have them). 

In general, authors should list the key messages they are testing for in the outcomes section, so that the test case don't 'pass' by failing for an unrelated reason
that has nothing to do with the reason the profile is being tested.

### Registering Profile Test Cases

Profile Test Cases file are registered using the [profile-test-cases](https://build.fhir.org/ig/FHIR/fhir-tools-ig/CodeSystem-ig-parameters.html#ig-parameters-profile-test-cases) parameter. There can be more than one profile test case, though this is not usually necessary.

### Running Profile Test Cases

The publisher will automatically execute the test cases. Any test casess that fail will be registered in the QA.
Editors should look in the .out.json file that has the same name as the test cases 