"""
TemporallyVariableUpdater{D,S} <: NeutralLandscapeUpdater

A `NeutralLandscapeUpdater` that has a prescribed level of
temporal variation (`variability`) and rate of change (`rate`),
but no spatial correlation in where change is distributed.
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


#TODO this doesn't have to be a Normal distribution, 
#could be arbitrary distribution that is continuous
#and can have mean 0 (or that can be transformed to 
# have mean 0)
"""
function _update(tvu::TemporallyVariableUpdater, mat)
    U = rand(Normal(0, variability(tvu)), size(mat))
    Δ = rate(tvu) .+ U
    mat .+ Δ
end
