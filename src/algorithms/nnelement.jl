"""
    NearestNeighborElement

Assigns a value to each patch using a k-NN algorithmm with `n` initial clusters
and `k` neighbors. The default is to use three cluster and a single neighbor.
"""
struct NearestNeighborElement <: NeutralLandscapeMaker
    n::Int64
    k::Int64
    function NearestNeighborElement(n::Int64, k::Int64)
        @assert n > 0
        @assert k > 0
        @assert k <= n
        new(n,k)
    end
end

NearestNeighborElement() = NearestNeighborElement(3, 1)

function _coordinatematrix(mat)
    coordinates = Matrix{Float64}(undef, (2, prod(size(mat))))
    for (i, p) in enumerate(Iterators.product(axes(mat)...))
        coordinates[1:2, i] .= p
    end
    coordinates
end

function _landscape!(mat, alg::NearestNeighborElement)
    fill!(mat, 0.0)
    clusters = sample(eachindex(mat), alg.n; replace=false)
    for (i,n) in enumerate(clusters)
        mat[n] = i
    end  
    coordinates = _coordinatematrix(mat)
    tree = KDTree(coordinates[:,clusters])
    if alg.k  == 1
        mat[:] .= nn(tree, coordinates)[1]
    else
        mat[:] .= map(mean, knn(tree, coordinates, alg.k)[1])
    end
    return mat
end
