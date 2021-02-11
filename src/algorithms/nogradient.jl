"""
    NoGradient

This type is used to generate a random landscape with no gradients
"""
struct NoGradient <: NeutralLandscapeMaker
end

_landscape!(mat, ::NoGradient) where {IT <: Integer} = rand!(mat)
