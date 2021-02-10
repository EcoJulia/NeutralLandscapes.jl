# Use-case: the portal data

In this example, we will use `NCBITaxonomy` to validate the names of the species
used in the Portal teaching dataset:

> Ernest, Morgan; Brown, James; Valone, Thomas; White, Ethan P. (2017): Portal
> Project Teaching Database. figshare.
> https://doi.org/10.6084/m9.figshare.1314459.v6

We will download a list of species from figshare, which is given as a JSON file:

```@example portal
using NCBITaxonomy
using DataFrames
using JSON
using StringDistances

species_file = download("https://ndownloader.figshare.com/files/3299486")
species = JSON.parsefile(species_file)
```

## Cleaning up the portal names

There is are two things we want to do at this point: extract the species names
from the file, and then validate that they are spelled correctly, or that they
are the most recent taxonomic name according to NCBI.

We will store our results in a data frame:

```@example portal
cleanup = DataFrame(
    code = String[],
    portal = String[],
    name = String[],
    rank = Symbol[],
    order = String[],
    taxid = Int[]
)
```

The next step is to loop throug the species, and figure out what to do with
them:

```@example portal
for sp in species
    portal_name = sp["species"] == "sp." ? sp["genus"] : sp["genus"]*" "*sp["species"]
    ncbi_tax = taxid(portal_name)
    if isnothing(ncbi_tax)
        ncbi_tax = taxid(portal_name; fuzzy=true)
    end
    ncbi_lin = lineage(ncbi_tax)
    push!(cleanup,
        (
            sp["species_id"], portal_name, ncbi_tax.name, rank(ncbi_tax),
            first(filter(t -> isequal(:order)(rank(t)), lineage(ncbi_tax))).name,
            ncbi_tax.id
        )
    )
end

first(cleanup, 5)
```

## Looking at species with a name discrepancy

Finally, we can look at the codes for which there is a likely issue because the
names do not match -- this can be because of new names, improper use of
vernacular, or spelling issues:

```@example portal
filter(r -> r.portal != r.name, cleanup)
```

Note that these results should *always* be manually curated. For example, two
species have been assigned to groups that are *obviously* wrong:

```@example portal
filter(r -> r.order ∈ ["Gentianales","Hemiptera"], cleanup)
```

## Fixing the mis-identified species

Well, the obvious choice here is *manual cleaning*. This is a good solution.
Another thing that `NCBITaxonomy` offers is the ability to build a `namefinder`
from a list of known NCBI taxa. This is good if we know that the names we expect
to find are part of a reference list.

In this case, we know that the species are going to be vertebrates, so we can use
the `vertebratefinder` function to restrict the search to these groups:

```@example portal
vertebratefinder(true)("Lizard"; fuzzy=true)
```

However, this approach does not seem to work for the second group:

```@example portal
vertebratefinder(true)("Perognathus hispidus"; fuzzy=true)
```

## The mystery of the hispid pocket mouse

This one will not be solved by our approach, as it is an invalid name --
*Perognathus hispidus* should actually be *Chaetodipus hispidus*. Here are the
list of issues that result in this name not being identifiable easily. First,
*Chaetodipus* is a valid name, for which *Perognathus* is not a synonym. So
searching by genus is not going to help. Second, there are a whole lot of
species that end with *hispidus*, and trying different string distances is not
going to help. We can try:

```@example portal
vertebratefinder(true)("Perognathus hispidus"; fuzzy=true, dist=DamerauLevenshtein)
```

This returns a valid taxon, but an incorrect one (the Olive-backed pocket
mouse). There is no obvious way to solve this problem.

*Or is it?*

To solve the issue with Lizards, we had to move away from `taxid`, and use
`verterbatefinder` to limit the scope of the search. It would save some time to
use this for the entire portal dataset, so let's create a `portalnamesolver`
function:

```@example portal
portalnamesolver = vertebratefinder(true)
```

It currently does *not* help with our example - but this is ok, as we cal use
one of Julia's features to hard-code the solution: dispatching on values.
Because `portalnamesolver` is a singleton function (due to the way `namefinder`
works), we need to be explicit about which module we want to expand it from (the
`@__MODULE__` will get the appropriate value, which can be `Main` if you work
from the REPL, the Weave sandbox if you are generatic a document, or your own
module if you structure your analysis this wat):

```@example portal
Env = @__MODULE__
function Env.portalnamesolver(::Type{Val{Symbol("Perognathus hispidus")}})
    return ncbi"Chaetodipus hispidus"
end
```

This definition says "every time we call the `portalnamesolver` with a `Symbol`
containing this species name, return this species". We can call it with:

```@example portal
portalnamesolver(Val{Symbol("Perognathus hispidus")})
```

Note that this is *not* changing the behavior of our `portalnamesolver`, it is
simply adding a method:

```@example portal
portalnamesolver("Lizards"; fuzzy=true)
```

At this point, we may want to update the very first loop, to use the
`portalnamesolver` throughout.

## Wrapping-up

This vignette illustrates how to go through a list of names, and match them
against the NCBI taxonomy. We have seen a number of functions from
`NCBITaxonomy`, including fuzzy string searching,. using custom string
distances, limiting the taxonomic scope of the search, and finally using
value-based dispatch to fix the unfixable. The last step can be automated a lot
by relying on Julia's existing code generation techniques, but this goes beyond
the scope of this vignette.