"""
    NearestNeighborCluster

Create a random cluster nearest-neighbour neutral landscape model with 
values ranging 0-1.
"""
struct NearestNeighborCluster <: NeutralLandscapeMaker
    p::Float64
    n::Symbol
    function NearestNeighborCluster(p::Float64 = 0.5, n::Symbol = :rook) 
        @assert p > 0
        @assert n ∈ (:rook, :queen, :diagonal)
        new(p,n)
    end
end

function _landscape!(mat, alg::NearestNeighborCluster)
    classify!(_landscape!(mat, NoGradient()), [1 - alg.p, alg.p])
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
