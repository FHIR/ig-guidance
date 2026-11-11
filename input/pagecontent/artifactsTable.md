The Artifacts Summary page (`artifacts.html`) produced by the standard implementation guide templates lists every artifact in the guide in a single
interactive table.  Readers can filter, group, sort, and page through the table on the page itself, and authors can link to the table with a
filter already applied, so a narrative page can point readers straight at "all the value sets" or "everything in the Lab Results grouping".

This page explains what goes into the table and how to build links that open the table with a particular view.

### What appears in the table

Each row is a resource listed in the implementation guide's `definition.resource` (including those that get added automatically).

The columns are:

* **Title** - the resource's title (or name, if it has no title), linked to the resource's page
* **Id** - the resource id
* **Type** - the FHIR resource type, such as `StructureDefinition`, `ValueSet`, or `CapabilityStatement`.  Note that profiles, extensions,
  and logical models are all `StructureDefinition`
* **Description** - the resource's description

The implementation guide's groupings become the table's **categories**.  Each category is shown as a heading row containing the grouping's name
and description, and categories appear in the same order as the groupings are defined in the implementation guide.

If you need the older artifact list instead of the table, set the `old-artifacts` implementation guide parameter to `true`.

### Linking to a filtered view

You can link to the table with a view already applied, either with a fragment that selects one category or with query parameters that set
several options at once.  These work in links from your own pages, in links from other guides or websites, and when typed into the browser's
address bar.

**NOTE:** It's a good idea to always have one link that points to an unconstrained view of the table that the user can filter as they see fit.

#### Query parameters

Query parameters go after `?` and are separated by `&`.  Any parameter you leave out takes its default.

| Parameter | Value | Effect | Default |
|-----------|-------|--------|---------|
| `categories` | Category names, separated by commas | Show only artifacts in these categories | All categories |
| `types` | Resource types, separated by commas | Show only artifacts of these types | All types |
| `text` | Any text | Show only artifacts whose title, id, or description contains the text, ignoring upper and lower case | No text filter |
| `grouping` | `true` or `false` | Turn grouping by category on or off | `true` |
| `order` | A column number and `asc` or `desc`, separated by a comma | Sort by that column.  Column numbers are: `0` grouping order, `2` Title, `3` Id, `4` Type, `5` Description | `0,asc` (grouping order) |
| `length` | A number | Rows per page | `200` |
| `start` | A number | The row to start at, counting from 0.  With `length=50`, `start=50` opens the second page | `0` |

Examples:

| Link | Shows |
|------|-------|
| `artifacts.html?types=ValueSet,CodeSystem` | All value sets and code systems, grouped by category |
| `artifacts.html?types=StructureDefinition&text=extension` | Structure definitions whose title, id, or description mentions "extension" |
| `artifacts.html?categories=Lab%20Results,Vital%20Signs` | The artifacts in the "Lab Results" and "Vital Signs" categories |
| `artifacts.html?grouping=false&order=2,asc` | Every artifact in one flat list, sorted alphabetically by title |
| `artifacts.html?text=blood%20pressure&grouping=false&order=2,asc&length=50` | Artifacts mentioning "blood pressure", in a flat alphabetical list, 50 rows per page |
| `artifacts.html?types=ValueSet#3` | The value sets in the third category |

From a markdown page, such a link looks like this:

```
See the [value sets and code systems](artifacts.html?types=ValueSet,CodeSystem) defined by this guide.
```

#### Rules for parameter values

* **Exact matches for categories and types.**  `types` values must be written exactly as the resource type, including case: `ValueSet` works
  but `valueset` does not.  `categories` values must match the category name exactly as displayed.  Values that match nothing are ignored
  rather than reported, so a misspelled value quietly shows more than you intended.  Check each link after building it.
* **Special characters must be encoded.**  Write a space as `%20` (or `+` in a query parameter) and an ampersand as `%26`.  Because commas
  separate values, a category whose name contains a comma cannot be selected with `categories`; link to it with a [category
  fragment](#linking-to-a-single-category) instead.
* **Categories from the query take precedence.**  If a link has both a `categories` parameter and a category fragment, the fragment is
  ignored.  A fragment combined with other parameters (as in `?types=ValueSet#3`) works as expected.
* **Flat lists are not alphabetical unless you ask.**  When a link includes any query parameter but no `order`, rows are sorted in grouping
  order, even with `grouping=false`.  Add `order=2,asc` to sort by title.
* **Text filters from a link are invisible.**  The `text` parameter searches title, id, and description together and is not shown in any of
  the filter boxes, so readers can't see or clear it on the page.  It applies only while it is in the address; it is not remembered.  Use it
  for links where the filtered result is obvious from the link text.
* **Headings can't be set by a link.**  There is no parameter for the Headings dropdown, and a link with query parameters always opens with
  Headings set to **Full**.

#### Linking to a single category

Add a fragment naming the category to show.  The fragment can be either the category's number or its exact name:

* `artifacts.html#3` - the third category
* `artifacts.html#Lab%20Results` - the category named "Lab Results" (spaces written as `%20`)

Categories are numbered starting from 1 in the order they appear in the table.  Groupings that contain no artifacts in the table are not counted, so
the number is not always the grouping's position in the implementation guide's list of groupings.

Considerations:

* Numbers work on every language's page, whereas names must match the category name as displayed on that language's page (see
  [Languages](#languages)).
* The page contains a target for each category number, so the IG Publisher's link checking accepts links such as `artifacts.html#3`.  
Filters (content starting at `?`) are not considered in link checking.
* The category pointed to by a number may change over time if new artifacts are added that cause a category that was not present previously to
now be present.

A fragment that is neither a category number nor a category name is ignored and the table keeps its current view.  When a reader is already
on the artifacts page, following a link to a different category fragment, or using the browser's Back and Forward buttons between them,
changes the category filter without reloading the page.

#### Links replace the remembered view

The table remembers each reader's view (filters, grouping, sort order, and paging) in their browser.  When a reader arrives through a link
with query parameters or a category fragment, the table ignores the view their browser remembered and
starts from the defaults plus whatever the link specifies.  That linked view then becomes the remembered view.  For example, after
following a link to `artifacts.html?types=ValueSet`, a reader who later opens `artifacts.html` directly still sees only value sets until they
clear the Type filter.

### Languages

In a multi-language guide, each language has its own artifacts page with the same controls, labels in that language, and its own remembered
view.

Category names are shown translated, and `categories` values and category-name fragments must use the name as displayed on the page being
linked to.  A link that works on the English page may therefore select nothing on another language's page.  Category numbers, resource
types, and the other parameters are the same in every language, so links that use only those work everywhere.
