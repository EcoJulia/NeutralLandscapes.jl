using Documenter, NCBITaxonomy

makedocs(
    sitename="NCBITaxonomy",
    authors="Timothée Poisot",
    modules=[NCBITaxonomy],
    pages=[
        "Index" => "index.md",
        "Finding taxa" => "namefinding.md",
        "Navigating lineages" => "lineages.md",
        "Portal data use-case" => "portal.md"
        ]
)

deploydocs(
    deps=Deps.pip("pygments", "python-markdown-math"),
    repo="github.com/EcoJulia/NCBITaxonomy.jl.git",
    devbranch="main",
    push_preview=true
)
