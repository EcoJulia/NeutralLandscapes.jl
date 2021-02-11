"""
    WaveSurface

Creates a sinusoidal landscape with a `direction` and a number of `periods`. If
neither are specified, there will be a single period of random direction.
"""
struct WaveSurface <: NeutralLandscapeMaker
    direction::Float64
    periods::Int64
    function WaveSurface(x::T, y::K) where {T <: Real, K <: Integer}
        @assert y >= 1
        new(mod(x, 360.0), y)
    end
end

WaveSurface() = WaveSurface(360rand(), 1)

function _landscape!(mat, alg::WaveSurface)
    _landscape!(mat, PlanarGradient(alg.direction))
    mat .= sin.(mat .* (2π * alg.periods))
end
