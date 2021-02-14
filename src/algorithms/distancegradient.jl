"""
    DistanceGradient

The `sources` field is the *linear* indices of the matrix, from which the
distance must be calculated.
"""
struct DistanceGradient <: NeutralLandscapeMaker
    sources::Vector{Integer}
end

DistanceGradient() = DistanceGradient([1])

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
