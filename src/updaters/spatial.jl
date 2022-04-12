
"""
    SpatiallyAutocorrelatedUpdater{SU,R,V}

A `NeutralLandscapeUpdater` that has a prescribed level of 
spatial variation (`variability`) and rate of change (`rate`),
and where the spatial distribution of this change is proportional
to a neutral landscape generated with `spatialupdater` at every time
step. 

TODO: make it possible to fix a given spatial updater at each timestep.
"""
@kwdef struct SpatiallyAutocorrelatedUpdater{SU,R,V} <: NeutralLandscapeUpdater
    spatialupdater::SU = DiamondSquare(0.5)
    rate::R = 0.1
    variability::V = 0.1
end

"""
    _update(sau::SpatiallyAutocorrelatedUpdater, mat; transform=ZScoreTransform)

Updates `mat` using spatially autocorrelated change, using the direction, rate,
and spatial updater parameters from `sau`.

TODO: doesn't necessarily have to be a ZScoreTransform, could be arbitrary
argument
"""
function _update(sau::SpatiallyAutocorrelatedUpdater, mat)
    change = rand(spatialupdater(sau), size(mat))
    delta = rate(sau) .+ variability(sau) .* transform(fit(ZScoreTransform, change), change)
    mat .+ delta
end
