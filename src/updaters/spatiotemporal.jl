

@kwdef struct SpatiotemporallyAutocorrelatedUpdater{SU,R,V} <: NeutralLandscapeUpdater
    spatialupdater::SU = DiamondSquare(0.1)
    rate::R = 0.1
    variability::V = 0.1
end
function _update(stau::SpatiotemporallyAutocorrelatedUpdater, mat)
    change = rand(spatialupdater(stau), size(mat))
    temporalshift = rand(Normal(0, variability(stau)), size(mat))
    z = transform(fit(ZScoreTransform, change), change)
    delta = rate(stau) .+  z .+ temporalshift
    mat .+ delta
end