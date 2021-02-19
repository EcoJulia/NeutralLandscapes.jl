"""
    classify!(array, weights[, classifyMask])

Classify an array into proportions based upon a list of class weights.
"""
function classify!(array, weights, mask = nothing)
    quantiles = zeros(length(weights))
    cumsum!(quantiles, weights)
    quantiles ./= quantiles[end]
    boundaryvalues = isnothing(mask) ?
    quantile(filter(isfinite, array), quantiles) :
    quantile(array[mask .& isfinite.(array)], quantiles)
    for i in eachindex(array)
        array[i] = isnan(array[i]) ? NaN : searchsortedfirst(boundaryvalues, array[i])
    end
    array
end

# TODO fix this function using _label
function _clusterMean(clusterArray, array)
    clusters = Dict{Float64, Float64}()
    clustersum = Dict{Float64, Float64}()
    for ind in eachindex(clusterArray, array)
        temp = clusterArray[ind]
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
    _rescale!(get.(Ref(clustersum), clusterArray, NaN))
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
function blend(clusterarray, arrays, scaling::AbstractVector{<:Number} = ones(length(arrays)))
    ret = sum(_clusterMean.(Ref(clusterarray), arrays) .* scaling)
    _rescale!(clusterarray + ret)
end


function _label(mat)
    rook = ((1, 0), (0, 1))
    m, n = size(mat)
    (m >= 3 && n >= 3) || error("The label algorithm requires the landscape to be at least 3 cells in each direction")
    
    # initialize objects and fill corners of ret
    ret = zeros(Int, m, n)
    clusters = Dict{Int, Int}()
    label = 0

    # run through the matrix and make clusters
    for j in axes(mat, 2), i in axes(mat, 1)
        same = [i - n[1] > 0 && j - n[2] > 0 && mat[i - n[1], j - n[2]] == mat[i, j] for n in rook]
        if count(same) == 0
            ret[i, j] = label += 1
            clusters[label] = label
        else
            vals = [ret[i - n[1], j - n[2]] for n in rook[same]]
            mi = minimum(vals)
            for v in vals
                clusters[v] = mi
            end
            ret[i, j] = mi
        end
    end
    
    # merge adjacent clusters with same value
    ncl = 0
    for i in eachindex(ret)
        ret[i] = _getval(clusters, ret[i])
        ncl = max(ncl, ret[i])
    end
    ncl, ret
end

function _getval(clusters, val)
    while true
        val2 = clusters[val]
        val2 == val && return val
        val = val2
    end
end 
