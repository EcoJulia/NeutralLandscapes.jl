"""
    NearestNeighborCluster <: NeutralLandscapeMaker

    NearestNeighborCluster(; p=0.5, n=:rook)
    NearestNeighborCluster(p, [n=:rook])

Create a random cluster nearest-neighbour neutral landscape model with 
values ranging 0-1. `p` sets the density of original clusters, and `n`
sets the neighborhood for clustering (see `?label` for neighborhood options)
"""
@kwdef struct NearestNeighborCluster <: NeutralLandscapeMaker
    p::Float64 = 0.5
    n::Symbol = :rook
    function NearestNeighborCluster(p::Float64, n::Symbol = :rook) 
        @assert p > 0
        @assert n ∈ (:rook, :queen, :diagonal)
        new(p,n)
    end
end

function _landscape!(mat, alg::NearestNeighborCluster)
    _landscape!(mat, NoGradient())
    classify!(mat, [alg.p, 1 - alg.p])
    replace!(mat, 2.0 => NaN)
    clusters, nClusters = label(mat, alg.n)
    coordinates = _coordinatematrix(clusters)
    sources = findall(!isnan, vec(clusters))
    tree = KDTree(coordinates[:,sources])
    clusters[:] .= clusters[sources[nn(tree, coordinates)[1]]]
    randvals = rand(nClusters)
    mat .= randvals[Int.(clusters)]
    mat
end
