

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
