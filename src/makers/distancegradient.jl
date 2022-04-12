"""
    DistanceGradient <: NeutralLandscapeMaker

    DistanceGradient(; sources=[1])
    DistanceGradient(sources)

The `sources` field is a `Vector{Integer}` of *linear* indices of the matrix, 
from which the distance must be calculated.
"""
@kwdef struct DistanceGradient <: NeutralLandscapeMaker
    sources::Vector{Integer} = [1]
end

function _landscape!(mat, alg::DistanceGradient)
    @assert maximum(alg.sources) <= length(mat)
    @assert minimum(alg.sources) > 0
    coordinates = CartesianIndices(mat)
    source_coordinates = map(alg.sources) do c
        SVector(Tuple(coordinates[c]))
    end
    idx = Vector{Int}(undef, 1)
    dist = Vector{Float64}(undef, 1)
    tree = KDTree(source_coordinates)
    _write_knn!(mat, dist, idx, tree, coordinates)
    return mat
end

# Function barrier, somehow we lose type stability with this above
function _write_knn!(mat, dist, idx, tree, coordinates)
    sortres = false
    for i in eachindex(mat)
        point = SVector(Tuple(coordinates[i]))
        knn_point!(tree, point, sortres, dist, idx, always_false)
        mat[i] = dist[1]
    end
    return mat
end
