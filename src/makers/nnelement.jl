"""
    NearestNeighborElement <: NeutralLandscapeMaker

    NearestNeighborElement(; n=3, k=1)
    NearestNeighborElement(n, [k=1])

Assigns a value to each patch using a k-NN algorithmm with `n` initial clusters
and `k` neighbors. The default is to use three cluster and a single neighbor.
"""
@kwdef struct NearestNeighborElement <: NeutralLandscapeMaker
    n::Int64 = 3
    k::Int64 = 1
    function NearestNeighborElement(n::Int64, k::Int64 = 1)
        @assert n > 0
        @assert k > 0
        @assert k <= n
        new(n,k)
    end
end

function _landscape!(mat, alg::NearestNeighborElement)
    clusters = sample(eachindex(mat), alg.n; replace=false)
    # Preallocate for NearestNeighbors
    idx = Vector{Int}(undef, alg.k)
    dist = Vector{Float64}(undef, alg.k)
    coordinates = CartesianIndices(mat)
    cluster_coordinates = map(clusters) do c
        SVector(Tuple(coordinates[c]))
    end
    tree = KDTree(cluster_coordinates)
    sortres = false
    if alg.k == 1
        for i in eachindex(mat)
            point = SVector(Tuple(coordinates[i]))
            knn_point!(tree, point, sortres, dist, idx, always_false)
            mat[i] = idx[1]
        end
    else
        for i in eachindex(mat)
            point = SVector(Tuple(coordinates[i]))
            knn_point!(tree, point, sortres, dist, idx, always_false)
            mat[i] = mean(idx)
        end
    end
    return mat
end
