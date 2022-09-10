using Test, SafeTestsets

@time @safetestset "updaters" begin include("updaters.jl") end
@time @safetestset "planar gradient" begin include("planar.jl") end
@time @safetestset "integrations" begin include("integrations.jl") end
@time @safetestset "rand" begin include("rand.jl") end
