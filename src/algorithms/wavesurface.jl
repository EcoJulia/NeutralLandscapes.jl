"""
    WaveSurface <: NeutralLandscapeMaker

    WaveSurface(; direction=360rand(), periods=1)
    WaveSurface(direction, periods)

Creates a sinusoidal landscape with a `direction` and a number of `periods`. If
neither are specified, there will be a single period of random direction.
"""
@kwdef struct WaveSurface <: NeutralLandscapeMaker
    direction::Float64 = 360rand()
    periods::Int64 = 1
    function WaveSurface(x::T, y::K) where {T <: Real, K <: Integer}
        @assert y >= 1
        new(mod(x, 360.0), y)
    end
end

function _landscape!(mat, alg::WaveSurface)
    rand!(mat, PlanarGradient(alg.direction))
    mat .= sin.(mat .* (2π * alg.periods))
end
