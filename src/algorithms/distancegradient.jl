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
    indices = vcat(CartesianIndices(mat)...)
    coordinates = zeros(Float64, (2, length(indices)))
    coordinates[1,:] .= getindex.(indices, 1)
    coordinates[2,:] .= getindex.(indices, 2)
    guesses = coordinates[:,setdiff(eachindex(mat),alg.sources)]
    tree = KDTree(coordinates[:,alg.sources])
    mat[setdiff(eachindex(mat),alg.sources)] .= nn(tree, guesses)[2]
    mat[alg.sources] .= 0.0
    return mat
end
