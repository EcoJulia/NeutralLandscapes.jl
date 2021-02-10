struct EdgeGradient <: NeutralLandscapeMaker
    direction::Float64
    EdgeGradient(x::T) where {T <: Real} = new(mod(x, 360.0))
end

EdgeGradient() = EdgeGradient(360rand())

"""
    landscape(alg::EdgeGradient, s::Tuple{IT,IT}=(10,30)) where {IT <: Integer}

Creates a landscape of size `s` following the planar gradient model. The
additional arguments `kw...` are passed to the post-processing function, see the
documentation of **TODO**. 
"""
function _landscape!(mat, alg::EdgeGradient; kw...) where {IT <: Integer}
    _landscape!(mat, PlanarGradient(alg.direction); kw...)
    mat .= -2.0abs.(0.5 .- mat) .+ 1.0
end
