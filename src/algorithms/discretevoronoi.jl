"""
    DiscreteVoronoi <: NeutralLandscapeMaker

    DiscreteVoronoi(n=3) 
    DiscreteVoronoi(; n=3) 

This type provides a rasterization of a Voronoi-like diagram.
Assigns a value to each patch using a 1-NN algorithmm with `n` initial clusters.
It is a `NearestNeighborElement` algorithmm with `k` neighbors set to 1.
The default is to use three clusters.
"""
@kwdef struct DiscreteVoronoi <: NeutralLandscapeMaker
    n::Int64 = 3
    function DiscreteVoronoi(n::Int64) 
        @assert n > 0
        new(n)
    end
end

_landscape!(mat, alg::DiscreteVoronoi) = _landscape!(mat, NearestNeighborElement(alg.n, 1))

