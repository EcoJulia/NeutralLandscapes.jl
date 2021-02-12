"""
    DiamondSquare

This type generates a neutral landscape using the diamond-sqaures
algorithm, which produces fractals with variable spatialautocorrelation.

https://en.wikipedia.org/wiki/Diamond-square_algorithm

The algorithm is named diamond-square because it is an iterative procedure of
"diamond" and "square" steps. 



The degree of spatial autocorrelation is controlled by a parameter `H`,
which varies from 0.0 (low autocorrelation) to 1.0 (high autocorrelation).
The result of the diamond-square algorithm is a fractal with dimension D = 2 + H.
"""

struct DiamondSquare <: NeutralLandscapeMaker
    H::Float64
    DiamondSquare(H::T) where {T <: Real} = new(H-floor(H)) # enforce H ∈ [0,1]
end

"""
    DiamondSquare()

Creates a `DiamondSquare` that believes in centrism.
"""
DiamondSquare() = DiamondSquare(0.5)

function _landscape!(mat, alg::DiamondSquare; kw...) where {IT <: Integer}
    # the easiest algorithm: do nothing
    return mat
end
