"""
    PlanarGradient

This type is used to generate a planar gradient landscape, where values change
as a bilinear function of the *x* and *y* coordinates. The direction is
expressed as a floating point value, which will be in *[0,360]*. The inner
constructor takes the mod of the value passed and 360, so that a value that is
out of the correct interval will be corrected.
"""
struct PlanarGradient <: NeutralLandscapeMaker
    direction::Float64
    PlanarGradient(x::T) where {T <: Real} = new(mod(x, 360.0))
end

"""
    PlanarGradient()

Creates a `PlanarGradient` with a random direction.
"""
PlanarGradient() = PlanarGradient(360rand())

"""
    landscape(alg::PlanarGradient, s::Tuple{IT,IT}=(10,30)) where {IT <: Integer}

Creates a landscape of size `s` following the planar gradient model. The
additional arguments `kw...` are passed to the post-processing function, see the
documentation of **TODO**. 
"""
function _landscape!(mat, alg::PlanarGradient; kw...) where {IT <: Integer}
    eastness = sin(deg2rad(alg.direction))
    southness = -1cos(deg2rad(alg.direction))
    rows, cols = axes(mat)
    mat .= southness .* rows .+ (eastness .* cols)'
    return mat
end