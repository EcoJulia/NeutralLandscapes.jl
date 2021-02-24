using Test, SafeTestsets

@time @safetestset "planar gradient" begin include("planar.jl") end
@time @safetestset "rand" begin include("rand.jl") end
