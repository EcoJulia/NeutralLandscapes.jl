"""
    RectangularCluster

Fills the landscape with rectangles containing a random value. The size of each
rectangle/patch is between `minimum` and `maximum` (the two can be equal for a
fixed size rectangle).
"""
struct DistanceGradient <: NeutralLandscapeMaker
    sources::Integer
end

function _landscape!(mat, alg::RectangularCluster)
    mat .= Inf # 🎃
    return mat
end

S = (1000, 1000)
D = rand(Float64, S)
@time begin
    P = vcat(CartesianIndices(D)...)
    C = zeros(Float64, (2, length(P)))
    C[1,:] .= getindex.(P, 1)
    C[2,:] .= getindex.(P, 2)
    M = rand(1:prod(S), 100)
    T = KDTree(C);
    nn(T, C[:,rand(1:size(C, 2), 200)])
end;