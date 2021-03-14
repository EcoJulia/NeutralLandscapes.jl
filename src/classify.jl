"""
    classify!(array, weights[, mask])

Classify an array in-place into proportions based upon a list of class weights.
"""
function classify!(array, weights, mask = nothing)
    quantiles = zeros(length(weights))
    cumsum!(quantiles, weights)
    quantiles ./= quantiles[end]
    boundaryvalues = if isnothing(mask)
        quantile(filter(isfinite, array), quantiles)
    else
        quantile(array[mask .& isfinite.(array)], quantiles)
    end
    for i in eachindex(array)
        array[i] = isnan(array[i]) ? NaN : searchsortedfirst(boundaryvalues, array[i])
    end
    array
end
classify!(array, weights::Real, mask = nothing) = classify!(array, ones(weights), mask)

"""
    classify(array, weights[, mask])

Classify an array into proportions based upon a list of class weights.
"""
classify(array, weights, mask = nothing) = classify!(copy(array), weights, mask)
classify(array, weights::Real, mask = nothing) = classify(array, ones(weights), mask)

function _clusterMean(clusterArray, array)
    clusters = Dict{Float64, Float64}()
    clustersum = Dict{Float64, Float64}()
    labels, nlabels = label(clusterArray)
    for ind in eachindex(labels, array)
        temp = labels[ind]
        if !haskey(clusters, temp)
            clusters[temp] = clustersum[temp] = 0.0
        end
        clusters[temp] += 1.0
        clustersum[temp] += array[ind]          
    end
    for cl in keys(clusters)
        clustersum[cl] /= clusters[cl]
    end
    clustersum[NaN] = NaN
    _rescale!(get.(Ref(clustersum), labels, NaN))
end

"""
    blend(arrays[, scaling])

Blend arrays weighted by scaling factors.
"""
function blend(arrays, scaling::AbstractVector{<:Number} = ones(length(arrays)))
    if length(scaling) != length(arrays)
        throw(DimensionMismatch("The array of landscapes (n = $(length(arrays))) and scaling (n = $(length(scaling))) must have the same length"))
    end
    ret = sum(arrays .* scaling)
    _rescale!(ret)
end

"""
    blend(clusterarray, arrays[, scaling])

Blend a primary cluster NLM with other arrays in which the mean value per 
cluster is weighted by scaling factors.
"""
function blend(clusterarray, arrays::AbstractVector, scaling::AbstractVector{<:Number} = ones(length(arrays)))
    ret = sum(_clusterMean.(Ref(clusterarray), arrays) .* scaling)
    _rescale!(clusterarray + ret)
end
blend(clusterarray, array, scaling = 1) = blend(clusterarray, [array], [scaling])

const _neighborhoods = Dict(
    :rook     => ((1, 0), (0, 1)),
    :diagonal => ((1, 0), (0, 1), (1, 1)),
    :queen    => ((1, 0), (0, 1), (1, 1), (1, -1)),
)


"""
    label(mat[, neighborhood = :rook])

Assign an arbitrary label to all clusters of contiguous matrix elements with the same value.
Returns a matrix of values and the total number of final clusters.
The `neighborhood` structure can be 
`:rook`     `:queen`    `:diagonal`
 0 1 0        1 1 1        0 1 1
 1 x 1        1 x 1        1 x 1
 0 1 0        1 1 1        1 1 0 
`:rook` is the default
"""
function label(mat, neighborhood = :rook)
    neighbors = _neighborhoods[neighborhood]
    m, n = size(mat)
    (m >= 3 && n >= 3) || error("The label algorithm requires the landscape to be at least 3 cells in each direction")
    
    # initialize objects
    ret = similar(mat)
    clusters = IntDisjointSets(0)

    # run through the matrix and make clusters
    for j in axes(mat, 2), i in axes(mat, 1)
        if isfinite(mat[i, j])
            same = []
            for neigh in neighbors[same]
                x,y = i-neigh[1], j-neigh[2]
                1 <= x <= m && 1 <= y <= n && push!(vals, mat[x,y]==mat[i,j] )
            end
            if count(same) == 0
                push!(clusters)
                ret[i, j] = length(clusters)
            elseif count(same) == 1
                n1, n2 = only(neighbors[same])
                ret[i, j] = ret[i - n1, j - n2]
            else
                vals = []
                for neigh in neighbors[same]
                    x,y = i-neigh[1], j-neigh[2]
                    1 <= x <= m && 1 <= y <= n && push!(vals, mat[x,y] )
                end
                unique!(vals)
                if length(vals) == 1
                    ret[i, j] = only(vals)
                else
                    for v in vals[2:end]
                        ret[i, j] = union!(clusters, Int(vals[1]), Int(v))
                    end
                end
            end
        else
            ret[i, j] = NaN
        end
    end

    # merge adjacent clusters with same value
    finalclusters = Set{eltype(ret)}()
    for i in eachindex(ret)
        ret[i] = isnan(ret[i]) ? NaN : find_root(clusters, Int(ret[i]))
        push!(finalclusters, ret[i])
    end

    # assign each cluster a random number in steps of 1 (good for plotting)
    randomcode = Dict(i => j for (i, j) in zip(finalclusters, 1.0:length(finalclusters)))
    randomcode[NaN] = NaN
    for i in eachindex(ret)
        ret[i] = randomcode[ret[i]]
    end 
    
    ret, length(finalclusters)
end

