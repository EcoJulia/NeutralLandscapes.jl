"""
    DistanceGradient

The `sources` field is the *linear* indices of the matrix, from which the
distance must be calculated.
"""
struct DistanceGradient <: NeutralLandscapeMaker
    sources::Vector{Integer}
end

function _landscape!(mat, alg::RectangularCluster)
    indices = vcat(CartesianIndices(mat)...)
    coordinates = zeros(Float64, (2, length(indices)))
    coordinates[1,:] .= getindex.(indices, 1)
    coordinates[2,:] .= getindex.(indices, 2)
    tree = KDTree(coordinates)
    guesses = coordinates[:,setdiff(eachindex(mat),alg.sources)]
    mat[guesses] .= nn(tree, guesses)[2]
    mat[alg.sources] .= 0.0
    return mat
end
