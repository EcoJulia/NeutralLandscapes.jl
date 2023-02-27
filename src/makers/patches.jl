@kwdef struct Patches <: NeutralLandscapeMaker
    numpatches = 10
    areaproportion = 0.3
    kernel = (x, λ) -> exp(-λ*x)
    σ_explore = 3.
    σ_return = 1.
    interweave_frequency = 2
    smoothing_rounds = 15
    smoothing_threshold = 4
    size_distribution = LogNormal()
end 

function _balanced_acceptance_lite(numpoints, dims)
    x,y = dims
    coords = []
    seed = rand(1:10^6, 2)
    for ptct in 1:numpoints
        i, j = haltonvalue(seed[1] + ptct, 2), haltonvalue(seed[2] + ptct, 3)
        coord = CartesianIndex(convert.(Int32, [ceil(x * i), ceil(y * j)])...)
        push!(coords, coord)
    end
    coords
end 

function _patch_distances(centers, knearest=2)
    dists = zeros(length(centers))
    for i in 1:length(centers)
        s = 0.
        thesedists = zeros(length(centers))
        for j in 1:length(centers)
            x = centers[i] - centers[j]
            thesedists[j] = sqrt(x[1]^2+x[2]^2)
        end

        dists[i] = sum(sort(thesedists)[1:knearest])
    end
    dists
end

function _landscape!(mat, p::Patches; kw...)
    mat .= 0 
    centers = _balanced_acceptance_lite(p.numpatches, size(mat))
    size_dist = rand(p.size_distribution, p.numpatches)
    px_per_patch = Int32.(floor.((size_dist ./ sum(size_dist) ) .* p.areaproportion*prod(size(mat))))


    #TODO hueristic to avoid overlap:
    #   1. compute mean dist from all other centers
    #   2. largest patch is furthest, 2nd largest is 2nd furtherst, etc.

    sort!(px_per_patch)
    sorted_Icenter = sortperm(_patch_distances(centers))
    for (i,c) in enumerate(centers[sorted_Icenter])
        _buildpatch!(mat, p, c, i, px_per_patch[i])
    end 


    for _ in 1:p.smoothing_rounds
        _smoothing!(mat, p.smoothing_threshold)
    end
end

isinbounds(x, dims) = x[1] > 0 && x[1] <= dims[1] && x[2] > 0 && x[2] < dims[2]

function _smoothing!(mat, thres)
    for i in CartesianIndices(mat)
        offsets = filter(!isequal(CartesianIndex(0,0)),CartesianIndices((-1:1,-1:1)))
        check = [isinbounds(i + o, size(mat)) ? i+o : nothing  for o in offsets]
        filter!(!isnothing, check)
        if sum([mat[c] == mat[check[begin]] for c in check]) > thres
            mat[i] = mat[check[begin]]
        end
    end
end

function _buildpatch!(mat, p, center, id, pixels)
    current = center
    MAX_ITER = 10*pixels

    pct, it = 0, 0
    while pct < pixels && it < MAX_ITER                
        if mat[current] == 0
            mat[current] = id
            pct += 1
        end
        if it % 2 == 0
            current = gaussian_explore_kernel(size(mat), current, center; σ=p.σ_explore)
        else 
            current = gaussian_return_kernel(size(mat), current, center, σ=p.σ_return)
        end 
        it += 1
    end
end 

function _ensure_inbounds!(dims, current)
    if current[1] < 1 
        current = CartesianIndex(1, current[2])
    elseif current[1] > dims[1]
        current = CartesianIndex(dims[1], current[2])
    end
    if current[2] < 1 
        current = CartesianIndex(current[1], 1)
    elseif current[2] > dims[2]
        current = CartesianIndex(current[1], dims[2])
    end
    current
end

function gaussian_kernel(current, targ; σ=5.0)
    N = MvNormal([targ[1], targ[2]], [σ 0; 0 σ])
    
    offsets = CartesianIndices((-1:1,-1:1))
    
    probmat = zeros(size(offsets))
    for (i,offset) in enumerate(offsets)
        idx = current + offset
        x = [idx[1], idx[2]]
        probmat[i] = pdf(N, x)
    end
    probmat = probmat ./ sum(probmat)


    Ioff = rand(Categorical(vec(probmat)))
    current + offsets[Ioff]
end

function gaussian_return_kernel(dims, current, center; kwargs...)
    dx = current[1] < center[1] ? CartesianIndex(1,0) : CartesianIndex(-1,0)
    dy = current[2] < center[2] ? CartesianIndex(0,1) : CartesianIndex(0,-1) 
    targ = current + dx + dy
    _ensure_inbounds!(dims,gaussian_kernel(current, targ; kwargs...))
end


function gaussian_explore_kernel(dims, current, center; kwargs...)
    # 
    dx = current[1] < center[1] ? CartesianIndex(-1,0) : CartesianIndex(1,0)
    dy = current[2] < center[2] ? CartesianIndex(0,-1) : CartesianIndex(0,1) 
    targ = current + dx + dy
    _ensure_inbounds!(dims, gaussian_kernel(current, targ ; kwargs...))
end
