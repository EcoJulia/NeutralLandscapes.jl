module NeutralLandscapes

import NaNMath
using Random: rand, rand!

abstract type NeutralLandscapeMaker end
export NeutralLandscapeMaker

include("landscape.jl")
export landscape, landscape!

include(joinpath("algorithms", "nogradient.jl"))
export NoGradient

include(joinpath("algorithms", "planargradient.jl"))
export PlanarGradient

include(joinpath("algorithms", "edgegradient.jl"))
export EdgeGradient

end # module
