module NeutralLandscapes

import NaNMath
using StatsBase: sample, ZScoreTransform, fit, transform
using Random: rand!
using Statistics: quantile, mean
using Distributions: Normal, LogNormal, MvNormal, Categorical, pdf
using NearestNeighbors: KDTree, knn, nn, knn_point!, SVector

import NearestNeighbors
always_false = Returns(false)
if isdefined(NearestNeighbors, :always_false)
    global always_false = NearestNeighbors.always_false
end

using DataStructures: IntDisjointSets, union!, find_root, push!
using Base: @kwdef
using HaltonSequences: haltonvalue
using FFTW: fft, ifft

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
export Patches 

include("landscape.jl")
include("classify.jl")
include(joinpath("makers", "diamondsquare.jl"))
include(joinpath("makers", "discretevoronoi.jl"))
include(joinpath("makers", "distancegradient.jl"))
include(joinpath("makers", "edgegradient.jl"))
include(joinpath("makers", "nncluster.jl"))
include(joinpath("makers", "nnelement.jl"))
include(joinpath("makers", "nogradient.jl"))
include(joinpath("makers", "perlinnoise.jl"))
include(joinpath("makers", "planargradient.jl"))
include(joinpath("makers", "rectangularcluster.jl"))
include(joinpath("makers","wavesurface.jl"))
include(joinpath("makers", "patches.jl"))

include(joinpath("updaters", "update.jl"))
include(joinpath("updaters", "noise.jl"))
include(joinpath("updaters", "temporal.jl"))
include(joinpath("updaters", "spatial.jl"))
include(joinpath("updaters", "spatiotemporal.jl"))
export update, update!
export NoiseGenerator
export NeutralLandscapeUpdater
export TemporallyVariableUpdater
export SpatiallyAutocorrelatedUpdater
export SpatiotemporallyAutocorrelatedUpdater
export rate, variability
export normalize

end # module




