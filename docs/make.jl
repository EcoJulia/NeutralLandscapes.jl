using Documenter, NeutralLandscapes

# For GR docs bug
ENV["GKSwstype"] = "100"

makedocs(
    sitename="Neutral Landscapes",
    authors="Timothée Poisot",
    modules=[NeutralLandscapes],
    pages=[
        "Index" => "index.md",
        "Gallery" => "gallery.md"
        ],
    checkdocs=:all,
    strict=true,
)

deploydocs(
    deps=Deps.pip("pygments", "python-markdown-math"),
    repo="github.com/EcoJulia/NeutralLandscapes.jl.git",
    devbranch="main",
    push_preview=true
)
