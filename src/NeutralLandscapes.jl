module NeutralLandscapes

import NaNMath
using StatsBase: sample
using Random: rand!
using Statistics: quantile
using Distributions: Normal
using Statistics: quantile, mean
using NearestNeighbors: KDTree, knn, nn

"""
All algorithms are descended from the `NeutralLandscapeMaker` type. A new
algorithm must minimally implement and `_landscape!` method for this type.
"""
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

include(joinpath("algorithms", "diamondsquare.jl"))
export DiamondSquare, MidpointDisplacement

include(joinpath("algorithms", "wavesurface.jl"))
export WaveSurface

include(joinpath("algorithms", "distancegradient.jl"))
export DistanceGradient

include(joinpath("algorithms", "rectangularcluster.jl"))
export RectangularCluster

include(joinpath("algorithms", "nnelement.jl"))
export NearestNeighborElement

include(joinpath("algorithms", "perlinnoise.jl"))
export PerlinNoise

include("classify.jl")
export classify!, blend

end # module
