

@kwdef struct SpatiallyAutocorrelatedUpdater{SU,R,V} <: NeutralLandscapeUpdater
    spatialupdater::SU = DiamondSquare(0.5)
    rate::R = 0.1
    variability::V = 0.1
end
function _update(sau::SpatiallyAutocorrelatedUpdater, mat)
    change = rand(spatialupdater(sau), size(mat))
    delta = rate(sau) .+ variability(sau) .* transform(fit(ZScoreTransform, change), change)
    mat .+ delta
end
