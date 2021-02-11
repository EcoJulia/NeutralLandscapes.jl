module NeutralLandscapeTestPlanar

using NeutralLandscapes
using Test

pl33 = rand(PlanarGradient(0.0), (3,3))
@test pl33 == [1 1 1; 1/2 1/2 1/2; 0 0 0]

testmask = [true false true; false true false; true true true]
pl33m = rand(PlanarGradient(0.0), (3,3); mask=testmask)
@test all(pl33m .=== [1 NaN 1; NaN 1/2 NaN; 0 0 0])

@test rand(PlanarGradient(0.0), (5, 5)) == rand(EdgeGradient(0.0), (5, 5))

mat = rand(Float64, (10, 10))
rand!(mat, PlanarGradient(90.0))

end