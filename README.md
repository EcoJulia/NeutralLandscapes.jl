# Neutral Landscapes

**Python source:** https://github.com/tretherington/nlmpy

~~~julia
julia> grad = PlanarGradient(60.0)
PlanarGradient(60.0)

julia> mask = rand(4, 6) .> 0.2
4×6 BitMatrix:
 1  1  1  1  1  1
 1  1  0  1  1  0
 1  1  1  0  1  0
 1  1  0  1  1  1

julia> landscape(grad, (4, 6), mask = mask)
4×6 Matrix{Float64}:
 0.257284   0.405827    0.554371    0.702914  0.851457    1.0
 0.171523   0.320066  NaN           0.617152  0.765695  NaN
 0.0857614  0.234305    0.382848  NaN         0.679934  NaN
 0.0        0.148543  NaN           0.445629  0.594173    0.742716
~~~