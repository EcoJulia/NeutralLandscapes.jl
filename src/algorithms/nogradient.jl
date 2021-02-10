struct NoGradient <: NeutralLandscapeMaker
end

_landscape!(mat, alg::NoGradient; kw...) where {IT <: Integer} = rand!(mat)
