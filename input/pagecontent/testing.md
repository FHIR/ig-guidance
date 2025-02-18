## Testing Support

This page summarises the support that the IG publisher offers to authors to
support the testing process, both for testing the IG and for testing implementations
that intend/claim to implement the IG. 

In general, the expectation is that an IG doesn't include implementation testing collateral; the
testing collateral targeted at implementations of the IG is found elsewhere. This is usually 
because testing the IG is an iterative responsive process where 
the test cases change due to testing experience. On the other hand, some IGs define
the test cases as part of writing the IG, and changing the test cases is considered
changing the IG itself. 

For this reason, the IG framework supports both defining testing collateral as part of the IG,
and also as part of a testing-focused IG that contains only test materials related to 
another IG. 

### Testing Profiles

The simplest kind of testing material is resources that are provided to test 
profiles, especially the invariants in the profiles. For further information,
so [Profile Test Cases](profile-test-cases.html).

### Generating Test Instances 

You can generate test instances in two different ways: 

* Using a Liquid template 
* Using a profile factory 

See <a href="testfactory.html">Using a Test Factory</a> for further details.

### Including Test Collateral in the Package

Testing collateral can be included in the package using the parameter 
<a href="https://hl7.org/fhir/tools/CodeSystem-ig-parameters.html#ig-parameters-path-test">path-test</a>. Any content 
found in a folder named in this parameter will be added to the <code>tests</code> folder in the generated package.
This often includes the test material from the previous two sections.

### Including Test Information in the narrative

See <a href="jsonxml.html">Including JSON or XML in the narrative</a> - this is used to present 
information from the testing collateral in the narrative for human readers. 

### Test Data Publication

A typical development cycle for testing collateral is that the test material is only partially completed
when a specification is completed and published, and it will continue to change. For this reason, the 
IG publisher and the FHIR publication process recognizes a package {package.v[X]}.tests, e.g. 
<code>hl7.fhir.us.core.v700.tests</code>. Such packages can be created and published through the 
active testing process at HL7 (and IHE?) without needing formal approval by the committees - they are 
understood to be automatically approved along with the existing root package. The IG editors can maintain
the test package, or delegate that to other editors, and new publications can be approved at the editorial
level without requiring approval from the various relevant committees. 

The normal publication process keeps a full copy of the specification at {canonical}/{version} for
each version published, and the current accepted version at {canonical}. The publication box (the 
yellow box at the top of this page) cross-links all the published versions, and is updated for all 
past versions as new versions are published. This is suitable for formal specifications where no
more than 2-3 versions a year are published, but not appropriate for a lot of testing collateral, 
where there might be a new version every few days during active testing cycles. 

For this reason, testing collateral can be published in a different mode, where only the latest 
version is published, and only zip archives of past 

(Todo)
