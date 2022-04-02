"""
TemporallyVariableUpdater{D,S} <: NeutralLandscapeUpdater

A `NeutralLandscapeUpdater` that has a prescribed

"""
@kwdef struct TemporallyVariableUpdater{D,R,V} <: NeutralLandscapeUpdater
    spatialupdater::D = missing
    rate::R = 0.1
    variability::V = 0.1
end

"""
_update(tvu::TemporallyVariableUpdater, mat)

Updates `mat` using temporally autocorrelated change, 
using the direction and rate parameters from `tvu`.
"""
function _update(tvu::TemporallyVariableUpdater, mat)
    U = rand(Normal(0, variability(tvu)), size(mat))
    Δ = rate(tvu) .+ U
    mat .+ Δ
end
