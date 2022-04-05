using NeutralLandscapes
using Test

# test it's running
@test TemporallyVariableUpdater() != π
@test SpatiallyAutocorrelatedUpdater() != π
@test SpatiotemporallyAutocorrelatedUpdater() != π