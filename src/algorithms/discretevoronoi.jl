"""
    DiscreteVoronoi

Assigns a value to each patch using a 1-NN algorithmm with `n` initial clusters
and `1` neighbors. The default is to use three clusters.
"""
struct DiscreteVoronoi <: NeutralLandscapeMaker
    n::Int64
    function DiscreteVoronoi(n::Int64)
        @assert n > 0
        new(n)
    end
end

DiscreteVoronoi() = DiscreteVoronoi(3)

function _landscape!(mat, alg::DiscreteVoronoi)
    fill!(mat, 0.0)
    clusters = sample(eachindex(mat), alg.n; replace=false)
    for (i,n) in enumerate(clusters)
        mat[n] = i
    end  
    coordinates = Matrix{Float64}(undef, (2, prod(size(mat))))
    for (i, p) in enumerate(Iterators.product(axes(mat)...))
        coordinates[1:2, i] .= p
    end
    tree = KDTree(coordinates[:,clusters])
    mat[:] .= nn(tree, coordinates)[1]
    return mat
end


