"""
    PlanarGradient <: NeutralLandscapeMaker

    PlanarGradient(; direction=360rand())
    PlanarGradient(direction)

This type is used to generate a planar gradient landscape, where values change
as a bilinear function of the *x* and *y* coordinates. The direction is
expressed as a floating point value, which will be in *[0,360]*. The inner
constructor takes the mod of the value passed and 360, so that a value that is
out of the correct interval will be corrected.
"""
@kwdef struct PlanarGradient <: NeutralLandscapeMaker
    direction::Float64 = 360rand()
    PlanarGradient(x::T) where {T <: Real} = new(mod(x, 360.0))
end

function _landscape!(mat, alg::PlanarGradient) where {IT <: Integer}
    eastness = sin(deg2rad(alg.direction))
    southness = -1cos(deg2rad(alg.direction))
    rows, cols = axes(mat)
    mat .= collect(rows) .* southness .+ cols' .* eastness
    return mat
end
