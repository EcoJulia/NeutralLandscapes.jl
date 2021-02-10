module NeutralLandscapes

greet() = print("Hello World!")

abstract type NeutralLandscapeMaker end
export NeutralLandscapeMaker

include(joinpath("algorithms", "planargradient.jl"))
export PlanarGradient

include(joinpath("algorithms", "edgegradient.jl"))
export EdgeGradient

export landscape

end # module
