# Navigating lineages

## Core functions

```@docs
lineage
children
descendants
parent
rank
```

## Examples

The `children` function will return a list of `NCBITaxon` that are immediately
descending from the one given as argument. For example, the genus
*Lamellodiscus* contains:

```@example lineages
using NCBITaxonomy

ncbi"Lamellodiscus" |> children
```

Note that the `parent` function does the opposite of `children`:

```@example lineages
ncbi"Lamellodiscus kechemirae" |> parent
```

To get the full descendants of a taxon (*i.e.* the children of its children,
recursively), we can do:

```@example lineages
descendants(ncbi"Diplectanidae")
```

We can also work upwards in the taxonomy, using the `lineage` function -- it
takes an optional `stop_at` argument, which is the farther up it will go:

```@example lineages
lineage(ncbi"Lamellodiscus elegans"; stop_at=ncbi"Monogenea")
```

The `rank` function is useful to know where in the taxonomy you are:

```@example lineages
[t => rank(t) for t in lineage(ncbi"Lamellodiscus elegans"; stop_at=ncbi"Monogenea")]
```

## Internal functions

```@docs
NCBITaxonomy._descendants
NCBITaxonomy._children
NCBITaxonomy._taxa_from_id
```