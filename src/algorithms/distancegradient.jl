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
