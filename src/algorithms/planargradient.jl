struct PlanarGradient <: NeutralLandscapeMaker
    direction::Float64
    PlanarGradient(x::T) where {T <: Real} = new(mod(x, 360.0))
end

PlanarGradient() = PlanarGradient(360rand())

function landscape(alg::PlanarGradient, s::Tuple{IT,IT}=(10,30)) where {T <: Real, IT <: Integer}
    eastness = sin(deg2rad(alg.direction))
    southness = -1cos(deg2rad(alg.direction))
    l = southness .* (1:s[1]) .+ (eastness .* (1:s[2]))'
    return l
end