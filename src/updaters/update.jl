"""
    This file contains methods for simulating change in a
    landscape with expected amounts of spatial and temporal 
    autocorrelation. 
"""

"""
    NeutralLandscapeUpdater is an abstract type for methods
    for updating a landscape matrix
"""
abstract type NeutralLandscapeUpdater end 

"""
    All `NeutralLandscapeUpdater`s have a field `rate`
    which defines the expected change in any cell per timestep.  
"""
rate(up::NeutralLandscapeUpdater) = up.rate
spatialupdater(up::NeutralLandscapeUpdater) = up.spatialupdater
direction(up::NeutralLandscapeUpdater) = up.direction

function update(updater::T, mat) where {T<:NeutralLandscapeUpdater}
    _update(updater, mat)
end
function update!(updater::T, mat) where {T<:NeutralLandscapeUpdater}
    mat = _update(updater, mat)
end

@kwdef struct SpatiallyAutocorrelatedUpdater{SU,D,S} <: NeutralLandscapeUpdater
    spatialupdater::SU = DiamondSquare(0.5)
    direction::D = 0.1
    rate::S = 0.1
end
function _update(sau::SpatiallyAutocorrelatedUpdater, mat)
    change = rand(spatialupdater(sau), size(mat))
    delta = direction(sau) .+ rate(sau) .* transform(fit(ZScoreTransform, change), change)
    mat .+ delta
end


@kwdef struct SpatiotemporallyAutocorrelatedUpdater{SU,TU,D,R} <: NeutralLandscapeUpdater
    spatialupdater::SU = DiamondSquare(0.1)
    temporalupdater::TU = BrownianMotion()
    direction::D = 0.1
    rate::R = 0.1
end
function _update(stau::SpatiotemporallyAutocorrelatedUpdater, mat)
    change = rand(spatialupdater(stau), size(mat))
    temporalshift = broadcast(x->update(stau.temporalupdater, x), mat)
    z = transform(fit(ZScoreTransform, change), change)
    delta = direction(stau) .+ (rate(stau) .* z) .+ (temporalshift .* z)
    mat .+ delta
end




"""
    example of how its used

"""
#env = rand(MidpointDisplacement(0.9), (250,250))
#sau = SpatiallyAutocorrelatedUpdater()
#new = update!(sau, env)
#plot(heatmap.([env, new])...)

