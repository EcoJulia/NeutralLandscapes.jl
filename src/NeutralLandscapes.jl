module NeutralLandscapes

import NaNMath
using StatsBase: sample
using Random: rand!
using Statistics: quantile, mean
using Distributions: Normal
using NearestNeighbors: KDTree, knn, nn
using DataStructures: IntDisjointSets, union!, find_root, push!
using Base: @kwdef

export rand, rand!
export classify!, classify, blend, label

export NeutralLandscapeMaker

export DiscreteVoronoi
export DiamondSquare, MidpointDisplacement
export EdgeGradient
export DistanceGradient
export NearestNeighborCluster
export NearestNeighborElement
export NoGradient
export PerlinNoise
export PlanarGradient
export RectangularCluster
export WaveSurface

include("landscape.jl")
include("classify.jl")
include("makers/diamondsquare.jl")
include("makers/discretevoronoi.jl")
include("makers/distancegradient.jl")
include("makers/edgegradient.jl")
include("makers/nncluster.jl")
include("makers/nnelement.jl")
include("makers/nogradient.jl")
include("makers/perlinnoise.jl")
include("makers/planargradient.jl")
include("makers/rectangularcluster.jl")
include("makers/wavesurface.jl")

end # module
