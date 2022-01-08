
@kwdef struct TemporallyAutocorrelatedUpdater{D,S} <: NeutralLandscapeUpdater
    spatialupdater = missing
    direction::D = 0.1
    rate::S = 0.1
end
function _update(sau::TemporallyAutocorrelatedUpdater, mat)
    U = rand(Normal(), size(mat))
    Δ = direction(sau) .+ rate(sau) .* U
    mat .+ Δ
end
