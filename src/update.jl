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

generator(up::NeutralLandscapeUpdater) = up.generator

function update!(updater::T, mat) where {T<:NeutralLandscapeUpdater}
    _update(updater, mat)
end


@kwdef struct SpatiallyAutocorrelatedUpdater{G,R} <: NeutralLandscapeUpdater
    generator::G = DiamondSquare(0.5)
    rate::R = 0.1
end
function _update(sau::SpatiallyAutocorrelatedUpdater, mat)
    change = rand(generator(sau), size(mat))
    delta = rate(sau) .* transform(fit(ZScoreTransform, change), change)
    mat .+ delta
end


@kwdef struct SpatiotemporallyAutocorrelatedUpdater{G,R,T} <: NeutralLandscapeUpdater
    generator::G = DiamondSquare(0.1)
    rate::R = 0.1
    temporalautocorrelation = 0.1
end
function _update(sau::SpatiallyAutocorrelatedUpdater, mat)
    
end




"""
    example of how its used

"""
#env = rand(MidpointDisplacement(0.9), (250,250))
#sau = SpatiallyAutocorrelatedUpdater()
#new = update!(sau, env)
#plot(heatmap.([env, new])...)