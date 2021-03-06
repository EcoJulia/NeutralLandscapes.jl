"""
    EdgeGradient <: NeutralLandscapeMaker

    EdgeGradient(; direction=360rand())
    EdgeGradient(direction)

This type is used to generate an edge gradient landscape, where values change
as a bilinear function of the *x* and *y* coordinates. The direction is
expressed as a floating point value, which will be in *[0,360]*. The inner
constructor takes the mod of the value passed and 360, so that a value that is
out of the correct interval will be corrected.
"""
@kwdef struct EdgeGradient <: NeutralLandscapeMaker
    direction::Float64 = 360rand()
    EdgeGradient(x::T) where {T <: Real} = new(mod(x, 360.0))
end

function _landscape!(mat, alg::EdgeGradient) where {IT <: Integer}
    _landscape!(mat, PlanarGradient(alg.direction))
    mat .= -2.0abs.(0.5 .- mat) .+ 1.0
end
