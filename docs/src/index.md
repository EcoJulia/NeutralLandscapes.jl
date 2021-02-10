# NCBITaxonomy

This package provides an interface to the [NCBI
Taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy). When installed, it will
download the *latest* version of the taxonomy files from the NCBI `ftp` service.
To update the version of the taxonomy you use, you need to build the package
again. This package is developed as part of the activities of the Viral
Emergence Research Initiative ([VERENA](https://www.viralemergence.org/))
consortium, with financial support from the Institut de Valorisation des Données
([IVADO](https://ivado.ca/en/)) at Université de Montréal.

## Overview of capacities

- retrieval of names from the taxonomy
- listing of children and descendant taxa
- fuzzy matching of names

## How does it work?

Internally, the package relies on the files provided by NCBI to reconstruct the
taxonomy -- the README for what the files contain can be found
[here](https://ftp.ncbi.nih.gov/pub/taxonomy/new_taxdump/taxdump_readme.txt).
Note that the files *and* their expected MD5 checksum are downloaded when the
package is built, and the data are *not* extracted unless the checksum matches.
The package will also check that the checksum on the server is different from
the version on disk, to avoid downloading data for nothing.

Data are saved as arrow tables when the package is built, and these are loaded
when the package is loaded with `import` or `using`, as `DataFrames`. These data
frames are *not* exported, but they are used by the various function of the
package. Note also that a number of fields are removed, and some tables are
pre-merged - not at build time (so there is no information loss, and you are
welcome to dig into the full data frame by reloading the arrow file), but at
load time.

The package will check that the local version of the taxonomy file is
sufficiently recent (no older than about 30 days), and if this is not the case,
will prompt the user to update to a more recent version.