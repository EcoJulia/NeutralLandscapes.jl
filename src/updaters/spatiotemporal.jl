

@kwdef struct SpatiotemporallyAutocorrelatedUpdater{SU,D,R} <: NeutralLandscapeUpdater
    spatialupdater::SU = DiamondSquare(0.1)
    direction::D = 0.1
    rate::R = 0.1
end
function _update(stau::SpatiotemporallyAutocorrelatedUpdater, mat)
    change = rand(spatialupdater(stau), size(mat))
    temporalshift = rand(Normal(), size(mat))
    z = transform(fit(ZScoreTransform, change), change)
    delta = direction(stau) .+ (rate(stau) .* z) .+ (rate(stau) .* temporalshift)
    mat .+ delta
end