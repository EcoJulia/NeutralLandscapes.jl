module NeutralLandscapes

abstract type NeutralLandscapeMaker end
export NeutralLandscapeMaker

include("landscape.jl")
export landscape

include(joinpath("algorithms", "planargradient.jl"))
export PlanarGradient

include(joinpath("algorithms", "edgegradient.jl"))
export EdgeGradient

end # module
