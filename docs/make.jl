using Documenter, NCBITaxonomy

makedocs(
    sitename="Neutral Landscapes",
    authors="Timothée Poisot",
    modules=[NeutralLandscapes],
    pages=[
        "Index" => "index.md"
        ]
)

deploydocs(
    deps=Deps.pip("pygments", "python-markdown-math"),
    repo="github.com/EcoJulia/NeutralLandscapes.jl.git",
    devbranch="main",
    push_preview=true
)
