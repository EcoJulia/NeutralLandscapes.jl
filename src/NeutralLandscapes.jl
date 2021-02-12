module NeutralLandscapes

import NaNMath
using Random: rand!

using NearestNeighbors

abstract type NeutralLandscapeMaker end
export NeutralLandscapeMaker

include("landscape.jl")
export rand, rand!

include(joinpath("algorithms", "nogradient.jl"))
export NoGradient

include(joinpath("algorithms", "planargradient.jl"))
export PlanarGradient

include(joinpath("algorithms", "edgegradient.jl"))
export EdgeGradient

include(joinpath("algorithms", "wavesurface.jl"))
export WaveSurface

include(joinpath("algorithms", "distancegradient.jl"))
export DistanceGradient

include(joinpath("algorithms", "rectangularcluster.jl"))
export RectangularCluster

end # module
