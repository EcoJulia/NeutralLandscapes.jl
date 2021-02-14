module NeutralLandscapes

import NaNMath
import StatsBase
using Random: rand!
using Statistics: quantile
using NearestNeighbors: KDTree, nn

"""
All algorithms are descended from the `NeutralLandscapeMaker` type. A new
algorithm must minimally implement and `_landscape!` method for this type.
"""
abstract type NeutralLandscapeMaker end
export NeutralLandscapeMaker

include("landscape.jl")
export rand, rand!

include("classifyarray.jl")
export classifyArray!

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

include(joinpath("algorithms", "nnelement.jl"))
export NearestNeighborElement

end # module
