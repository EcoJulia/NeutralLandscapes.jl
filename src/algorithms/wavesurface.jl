"""
    WaveSurface

Creates a sinusoidal landscape with a `direction` and a number of `periods`. If
neither are specified, there will be a single period of random direction.
"""
struct WaveSurface <: NeutralLandscapeMaker
    direction::AbstractFloat
    periods::Int
    function WaveSurface(x::AbstractFloat, y::Int)
        @assert y >= 1
        new(mod(x, 360.0), y)
    end
end

"""
    WaveSurface()

When given no argument, `WaveSurface` returns a single period at a random
orientation.
"""
WaveSurface() = WaveSurface(360rand(), 1)

function _landscape!(mat, alg::WaveSurface)
    rand!(mat, PlanarGradient(alg.direction))
    mat .= sin.(mat .* (2π * alg.periods))
end