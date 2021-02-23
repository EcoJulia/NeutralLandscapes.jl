"""
    NearestNeighborElement

Create a random cluster nearest-neighbour neutral landscape model with 
values ranging 0-1.
"""
struct NearestNeighborCluster{T<:AbstractFloat} <: NeutralLandscapeMaker
    p::T
    n::Symbol
    function NearestNeighborCluster(p::T = 0.5, n::Symbol = :rook)
        @assert p > 0
        @assert n ∈ (:rook, :queen, :diagonal)
        new(p,n)
    end
end

NearestNeighborCluster(p::T = 0.5, n::Symbol = :rook) where T <: AbstractFloat = 
    NearestNeighborCluster{T}(p, n)

function _landscape!(mat, alg::NearestNeighborElement)
    # I ignore the masking here - all the other algos apply it after only
    classify!(rand!(mat), [1 - p, p])
    clusters, nClusters = label(mat)
    clusters .= rand(nClusters)[clusters]
