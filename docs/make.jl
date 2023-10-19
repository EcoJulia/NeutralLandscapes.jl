using Documenter, NeutralLandscapes
import Literate

# For GR docs bug
ENV["GKSwstype"] = "100"

vignettes = filter(
    endswith(".jl"),
    readdir(joinpath(@__DIR__, "src", "vignettes"); join = true, sort = true),
)
for vignette in vignettes
    Literate.markdown(
        vignette,
        joinpath(@__DIR__, "src", "vignettes");
        config = Dict("credit" => false, "execute" => true),
    )
end

makedocs(;
    sitename = "NeutralLandscapes",
    authors = "M.D. Catchen",
    modules = [NeutralLandscapes],
    pages = [
        "Index" => "index.md",
        "Gallery" => "gallery.md",
        "Vignettes" => [
            "Overview" => "vignettes/overview.md",
        ],
    ],
    checkdocs = :all,
)

deploydocs(
    repo="github.com/EcoJulia/NeutralLandscapes.jl.git",
    devbranch="main",
    push_preview=true
)
