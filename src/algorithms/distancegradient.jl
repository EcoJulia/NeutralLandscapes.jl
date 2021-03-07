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
    coordinates = Matrix{Float64}(undef, (2, prod(size(mat))))
    for (i, p) in enumerate(Iterators.product(axes(mat)...))
        coordinates[1:2, i] .= p
    end
    tree = KDTree(coordinates[:,alg.sources])
    mat[:] .= nn(tree, coordinates)[2]
    return mat
end
