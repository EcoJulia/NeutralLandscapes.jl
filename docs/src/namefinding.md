# Finding taxa

## The `taxid` function

```@docs
taxid
vernacular
synonyms
```

The `taxid` function will return a `NCBITaxon` object, which has two fields:
`name` and `id`. We do not return the `class` attribute, because the package
will always return the scientific name, as the examples below illustrate:

```@example taxid
using NCBITaxonomy
taxid("Bos taurus")
```

There is a convenience string macro to replace the `taxid` function:

```@example taxid
ncbi"Bos taurus"
```

Note that because the names database contains vernacular and deprecated names,
the *scientific name* will be returned, no matter what you search

```@example taxid
taxid("cow")
```

This may be a good point to note that we can use the `vernacular` function to
get a list of NCBI-known vernacular names:

```@example taxid
taxid("cow") |> vernacular
```

You can pass an additional `fuzzy=true` keyword argument to the `taxid` function
to perform fuzzy name matching using the Levenshtein distance:

```@example taxid
taxid("Paradiplozon homion", fuzzy=true)
```

Note that both fuzzy searching and non-standard naming come at a performance
cost, so it is preferable to use the strict matching unless necessary. As a
final note, you can specify any distance function from the `StringDistances`
package, using the `dist` argument. This is true of `taxid`, and indeed of any
function returned by a `namefinder`.

## Building a better namefinder

The `namefinder` function has one job: generating a function that works exactly
like `taxid`, but only searches on a smaller subset of the data. In fact,
`taxid` is a special case of `namefinder`, which simply searches the whole
database.

```@docs
namefinder
descendantsfinder
```

Here is an illustration of why using namefinders makes sense. Let's say we have
to search for a potentially misspelled name:

```@example taxid
@time taxid("Ebulavurus"; fuzzy=true)
```

We can build a more efficient namefinder by selecting the nodes in the taxonomy
that belong to the `VRL` division. Doing so requires to call `namefinder` on a
`DataFrame`. Note that we are doing some merging here, which results in the data
frame we use having more columns than the names data frame -- but this does not
matter, because the `namefinder` is not picky about having *too much*
information.

```@example taxid
using DataFrames, DataFramesMeta
viralfinder = namefinder(
  leftjoin(
    @where(
      select(NCBITaxonomy.nodes_table, [:tax_id, :division_code]),
      :division_code .== Symbol("VRL")
    ),
    NCBITaxonomy.names_table;
    on = :tax_id
  )
)

@time viralfinder("Bumbulu ebolavirus"; fuzzy=true);
```

For searches in specific groups, the `descendantsfinder` is a convenient
wrapper: it will return a `namefinder` limited to all taxa below its argument.

```@example taxid
diplectanidfinder = descendantsfinder(taxid("Diplectanidae"))
diplectanidfinder("Lamellodiscus")
```

## Standard namefinders

To save some time, there are namefinders pre-populated with the large-level
taxonomic divisions.

```@docs
bacteriafinder
virusfinder
mammalfinder
vertebratefinder
plantfinder
invertebratefinder
rodentfinder
primatefinder
```

All of these return a `namefinder` function -- so for example, the viral example
from above can be re-written simply as:

```@example taxid
virusfinder()("Bumbulu ebolavirus"; fuzzy=true)
```

Note that we need to *call* the finder function to return the name finder. This
may change in a future release.

## Internal functions

```@docs
NCBITaxonomy._get_sciname_from_taxid
NCBITaxonomy._df_from_taxlist
```
