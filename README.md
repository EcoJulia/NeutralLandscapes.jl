# Neutral Landscapes

**Python source:** https://github.com/tretherington/nlmpy

~~~julia
julia> grad = PlanarGradient(60.0)
PlanarGradient(60.0)

julia> landscape(grad, (4, 6))
4×6 Array{Float64,2}:
  0.366025   1.23205   2.09808   2.9641  3.83013  4.69615
 -0.133975   0.732051  1.59808   2.4641  3.33013  4.19615
 -0.633975   0.232051  1.09808   1.9641  2.83013  3.69615
 -1.13397   -0.267949  0.598076  1.4641  2.33013  3.19615
~~~