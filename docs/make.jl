push!(LOAD_PATH, "../src/")

using Documenter
using DocumenterCitations
using DocumenterVitepress
using NeutralLandscapes

makedocs(;
    sitename="NeutralLandscapes",
    authors="M.D. Catchen",
    modules=[NeutralLandscapes],
    pages=[
        "Index" => "index.md",
        "Gallery" => "gallery.md",
    ],
    format = DocumenterVitepress.MarkdownVitepress(
        repo="https://github.com/EcoJulia/NeutralLandscapes.jl",
        devurl="dev"
     ),
    warnonly=true
)

deploydocs(
    repo="github.com/EcoJulia/NeutralLandscapes.jl.git",
    push_preview=true
)
