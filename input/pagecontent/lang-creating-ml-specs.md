
## Setting up the IG for multilingual support

Setting up an IG to be multilingual consists of defining:
* IG language 
* Which language are in scope
* Where translations come from 

### IG language
in the IG, set the parameter 

```xml
    <parameter>
      <code value="i18n-default-lang"/>
      <value value="en"/>
    </parameter>
```

### Languages in scope

The IG can contain one or more languages in scope
```xml
    <parameter>
      <code value="i18n-lang"/>
      <value value="nl"/>
    </parameter>
    <parameter>
      <code value="i18n-lang"/>
      <value value="es"/>
    </parameter>
```



### Translation content location

For an IG

```xml
    <parameter>
      <code value="translation-sources"/>
      <value value="input/translations/nl"/>
    </parameter>
    <parameter>
      <code value="translation-sources"/>
      <value value="input/translations/es"/>
    </parameter>
```


For language packs, the translation locations are defined with the parameter `translation-supplements`:

```json
    "parameter": [
      {
        "code": "translation-supplements",
        "value": "input/translations/pt"
      }
...
    ]
```


## Providing translations



### Providing translations for the resources in an IG

When a multi-lingual IG is built, output will be created in `/translations/{lang}/{format}` for all the strings in the resources that are known to be translatable. Any existing translations will be preserved in the generated output.  

Editors/translators choose which format is preferred, edit the content as text or using their preferred language editing software (or just AI directly). The output of this is an updated translation file, which  is then copied into `/input/...` (as specifed in the IG parameter translations). 
