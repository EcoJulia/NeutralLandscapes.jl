using NeutralLandscapes
using Test

# test it's running
@test TemporallyVariableUpdater() != π
@test SpatiallyAutocorrelatedUpdater() != π
@test SpatiotemporallyAutocorrelatedUpdater() != π

function testupdaters(model)
    updater = model()

    # Test defaults 
    @test rate(updater) == 0.1 
    @test variability(updater) == 0.1 

    # Test kwargs 
    updater = model(rate = 1.0, variability=0.05, spatialupdater=MidpointDisplacement(0.5))
    @test rate(updater) == 1.0
    @test variability(updater) == 0.05 
    @test typeof(updater.spatialupdater) <: NeutralLandscapeMaker
    @test updater.spatialupdater == MidpointDisplacement(0.5)

    # Test updating
    env = rand(MidpointDisplacement(0.5), 50, 50)
    newenv = update(updater, env)
    @test env != newenv

    oldenv = deepcopy(env)
    update!(updater, env)
    @test env != oldenv 
end 

function testnormalize(model)
    updater = model()
    env = rand(MidpointDisplacement(0.5), 50, 50)
    seq = update(updater, env, 30)
    normseq = normalize(seq)
    @test min(normseq...) >= 0 && max(normseq...) <= 1
    @test length(findall(isnan, normseq[end])) == 0

    env = [NaN 5 2 1 NaN; 3 4 5 2 1; 6 NaN 0 5 2; NaN NaN 0 4 5]
    seq = update(updater, env, 30)
    normseq = normalize(seq) 
    @test length(findall(isnan, normseq[end])) == 5

end

models = [
    TemporallyVariableUpdater, 
    SpatiallyAutocorrelatedUpdater, 
    SpatiotemporallyAutocorrelatedUpdater
]


testnormalize.(models)
testupdaters.(models)
