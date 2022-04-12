
"""
    SpatiotemporallyAutocorrelatedUpdater{SU,R,V}

A `NeutralLandscapeUpdater` that has a prescribed level of
spatial and temporal variation (`variability`) and rate of change (`rate`),
and where the spatial distribution of this change is proportional
to a neutral landscape generated with `spatialupdater` at every time
step. 

TODO: perhaps spatial and temporal should each have their own variability param
"""
@kwdef struct SpatiotemporallyAutocorrelatedUpdater{SU,R,V} <: NeutralLandscapeUpdater
    spatialupdater::SU = DiamondSquare(0.1)
    rate::R = 0.1
    variability::V = 0.1
end


"""
    _update(stau::SpatiotemporallyAutocorrelatedUpdater, mat)

Updates `mat` using temporally autocorrelated change, using the direction, rate,
and spatialupdater parameters from `stau`.

TODO: doesn't necessarily have to be a Normal distribution or ZScoreTransform,
could be arbitrary argument
"""
function _update(stau::SpatiotemporallyAutocorrelatedUpdater, mat)
    change = rand(spatialupdater(stau), size(mat))
    temporalshift = rand(Normal(0, variability(stau)), size(mat))
    z = transform(fit(ZScoreTransform, change), change)
    delta = rate(stau) .+  variability(stau) * z .+ temporalshift
    mat .+ delta
end