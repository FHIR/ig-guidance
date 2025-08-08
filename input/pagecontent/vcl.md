
### ValueSet Compose Language (VCL)

#### Overview

ValueSet Compose Language (VCL) is a domain-specific language for expressing ValueSet CLDs in a compact syntax suitable for use within a URL and enabling a new familty of implicit ValueSet URIs that are usable across all code systems.  The design and development of VCL was inspired by the Expression Constraint Language (ECL) from SNOMED CT.

VCL is particularly useful for dynamic generation of ValueSets for subsequent use with the `/ValueSet/$expand` operation.

#### ValueSet Compose Language Basics

* **Grammar**: VCL has a formal grammar (see below) defined in [ANTLR](https://www.antlr.org/).
* **Whitespace**: Except within quoted values, spaces and tabs are ignored. Newlines and carriage returns are prohibited. (Do we really want this?)
* **URIs**: URIs must include a scheme consisting solely of ascii letters. Percent-encoding must be used where required by the URI specification but also for round brackets `(` and `)`. (Because the `systemUri` term uses brackets as a delimiter.)
* **Quoting**: All codes and values (but not URIs) involving non-alphanumeric characters or the dash or underscore must be quoted. Double-quotes (`"`) are used with backslash (`\`) as the escape character. Only `"` and `\\` can be escaped.  (what about embedded newlines?)
* **Comments**: There is no syntax for comments.

#### VCL Structure

The essence of ValueSet's compose is an inclusion rule and an optional exclusion rule.
Both rules take the same form which is a disjunction (OR) of a conjunction (AND) of one or more sub-expressions.
The sub-expressions are a set of codes, or a filter (property, op, value) triplet, or a ValueSet include (a form of nesting).

In VCL the conjunction is expressed with a comma (`,`) and the disjunction is expressed with a semicolon (`;`).
Brackets are used to group sub-expressions and eliminate ambiguity; there are no operator precedence rules for comma and semicolon.
A sub-expression is then either a single code, a filter, or a ValueSet include.

| `abc` | the single code, `abc` |
| `"abc"` | the single code, `abc` |
| `"a/bc.123"` | the single code, `a/bc.123` |
| `^http://example.com/ValueSet/123` | ValueSet include for `http://example.com/ValueSet/123` |

Filters map (mostly) to a triple: `{property}{op}{value}` where operators have a corresponding symbol.
Use of these symbols means whitespace is not required to separate the three components.

**Note** FHRI R6 has two new features that come into play at this point.
1. A new operator "of" which maps to `{value}{op}{property}`, and more specifically `{value}.{property}`
2. The operators `in`, `not-in`, and `of` allow nested filters instead of a value

| Op               | Symbol   | Notes |
|------------------|----------|-------|
| =                | `=`      |
| is-a             | `<<`     |
| descendent-of    | `<`      |
| is-not-a         | `~<<`    |
| regex            | `/`      |
| in               | `^`      |
| not-in           | `~^`     |
| generalizes      | `>>`     |
| child-of         | `<!`     |
| descendent-leaf  | `!!<`    |
| exists           | `?`      |
| of               | `.`      | order of arguments is reversed because "value" is the code |

#### VCL Grammar

This is the VCL formal grammar defined in [ANTLR](https://www.antlr.org/).

```antlr
grammar VCL;

vcl         : expr EOF ;
expr        : subExpr (conjunction | disjunction | exclusion )? ;
subExpr     : systemUri? (simpleExpr | OPEN expr CLOSE);
conjunction : (COMMA subExpr)+ ;
disjunction : (SEMI subExpr)+ ;
exclusion   : DASH subExpr ;
simpleExpr  : STAR | code | filter | includeVs ;

includeVs   : IN (URI | systemUri) ;
systemUri   : OPEN URI CLOSE;
filter      : (property
                ( EQ code
                | IS_A code
                | IS_NOT_A code
                | DESC_OF code
                | REGEX str
                | IN (codeList | URI | filterList)
                | NOT_IN (codeList | URI | filterList)
                | GENERALIZES code
                | CHILD_OF code
                | DESC_LEAF code
                | EXISTS code     // only true and false are valid codes here
                )
              | (code | codeList | STAR | URI | filterList ) DOT property  // operator "of"
              );
filterList  : LCRLY filter (COMMA filter)* RCRLY ;
property    : code ;

codeList        : LCRLY code (COMMA code)+ RCRLY ;
code            : SCODE | QUOTED_VALUE ;
str             : QUOTED_VALUE ;


DASH          : '-' ;
OPEN          : '(' ;
CLOSE         : ')' ;
LCRLY         : '{' ;
RCRLY         : '}' ;
SEMI          : ';' ;
COMMA         : ',' ;
DOT           : '.' ;
STAR          : '*' ;

EQ            : '=' ;
IS_A          : '<<' ;
IS_NOT_A      : '~<<' ;
DESC_OF       : '<' ;
REGEX         : '/' ;
IN            : '^' ;
NOT_IN        : '~^' ;
GENERALIZES   : '>>' ;
CHILD_OF      : '<!' ;
DESC_LEAF     : '!!<' ;
EXISTS        : '?' ;

URI             : [a-zA-Z]+ [:] [a-zA-Z0-9?=:;&_%+-.@#$^!{}/]+ ('|' ~[|()] *)? ;
SCODE           : [a-zA-Z0-9] [-_a-zA-Z0-9]* ;   // simple codes only
QUOTED_VALUE    : '"' (~["\\] | '\\' ["\\])* '"' ;

WS              : [ \t]+ -> skip ;   // skip spaces, tabs; newlines not permitted
```

#### VCL Examples

| Expression | Meaning |
| ---------- | ------- |
| `B`                         | the code `B` |
| `"B"`                       | the code `B` |
| `"B.123"`                   | the code `B.123` |
| `concept << B`              | the set of codes including `B` or any descendant of `B` |
| `*`                         | all codes |
| `parent = B`                | the set of codes that have `B` as a (direct) parent |
| `prop_name = B`             | the set of codes that have `B` as the value for their `prop_name` property |
| `prop_name = “string”`      | Same, but for values that require quoting (non-alhpanumeric characters) |
| `inactive = true`           | All inactive codes |
| `prop1 = B , prop2 = “C”`   | ”and” – intersection of codes matching each sub-expression |
| `prop1 = B ; prop2 = “C”`   | “or” -- union of codes matching each sub-expression |
| `B.codeprop`                | the set of values of the `codeprop` property of `B` |
  `{concept < B}.codeprop`    | the set of values of the `codeprop` property of all codes that are descendants of `B` | 
| `{B.codeprop1}.codeprop2`   | the set of values of the ’codeprop2’ property for all codes that are the value of the `codeprop1` property of `B` |
| `codeprop1^{codeprop2 = C}` | the set of codes that have a ‘codeprop1’ property with a value that has a `codeprop2` property with the value `C` |
| `ingredient?true`           | the set of codes that have a value for the property `ingredient` |
| `code/“A[0-9]*\\.9”`        | the set of codes where the code matches the regex `A[0-9]\.9` |
| `property^{123,456}`        | the set of codes where the `codeprop` property value is `123` or `456` |
| `has_ingredient^http://acme.com/VS/controlled` | the set of codes with an ingredient in the controlled substance ValueSet |


#### Additional Examples

* `(subscriber;provider)`
* `(http://loinc.org)(41995-2;4548-4;4549-2;17855-8;17856-6;62388-4;71875-9;59261-8;86910-7);(http://snomed.info/sct)(365845005;165679005;165680008;65681007;451061000124104;451051000124101);(http://www.ama-assn.org/go/cpt)(83036;83037;3044F;3046F)`
* `((http://snomed.info/sct)concept<<17311000168105;(http://snomed.info/sct)(61796011000036105;923929011000036103);(http://loinc.org)ancestor=LP185676-6)-((http://loinc.org)76573-5)`
* `(http://hl7.org/fhir/paymentstatus)paid;(http://hl7.org/fhir/payeetype)provider`
* `^http://hl7.org/fhir/ValueSet/payeetype`
* `ancestor=LP185676-6`
* `COMPONENT/".*Dichloroethane.*"`
* `COMPONENT=LP15653-6`
* `(10007-3;10008-1)`
* `((10007-3;10008-1);(COMPONENT=LP212516-1,PROPERTY=LP6817-3,TIME_ASPCT=LP6960-1,SYSTEM=LP28433-8))-(29557-6)`
* `(http://loinc.org)10007-3;^http://loinc.org/vs/LP257682-7`
* `parent^{LP46821-2,LP259418-4}`
* `(COMPONENT=LP212516-1,PROPERTY=LP6817-3,TIME_ASPCT=LP6960-1,SYSTEM=LP28433-8)`
* `COMPONENT/".*prowazekii.*"`
* `PROPERTY=LP6879-3`
* `(emergency;family;guardian;friend;partner;work;caregiver;agent;guarantor;owner;parent)`
* `(in-progress;aborted;completed;entered-in-error)`
* `(^http://csiro.au/fhir/ValueSet/selfexclude)-(^http://csiro.au/fhir/ValueSet/selfexclude)`
* `^http://csiro.au/fhir/ValueSet/selfexcludeB`
* `^http://csiro.au/fhir/ValueSet/selfexcludeC`
* `(^http://csiro.au/fhir/ValueSet/selfimport)-(^http://csiro.au/fhir/ValueSet/selfexcludeA)`
* `^http://csiro.au/fhir/ValueSet/selfimport`
* `(constraint="<< 30506011000036107 |australian product|: 700000101000036108 |hasTP| = 17311000168105 |PANADOL|",expression="<< 30506011000036107 |australian product|: 700000101000036108 |hasTP| = 17311000168105 |PANADOL|")`
* `concept~<<929360061000036106`
* `concept^http://snomed.info/sct?fhir_vs/refset=929360061000036106`
* `concept<<17311000168105`
* `concept<<"_ActNoImmunizationReason"`
* `A`
* `concept<<chol-mmol`
* `A,B`
* `A;B`
* `panadol.contains`
* `(consists_of.has_ingredient)`
* `{concept<<panadol}.contains`
* `has_ingredient^{has_tradename=2201670}`
* `{a.b}.c`
* `has_ingredient = 1886`
* `consists_of^{has_ingredient = 1886}`
* `consists_of^{has_ingredient^{has_tradename=2201670}}`
* `(has_ingredient=1886, has_dose_form=317541)`
* `(has_ingredient=1886, has_dose_form^{concept<<1151133})`
